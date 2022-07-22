/************************************************************************ 
@Authors Rikky Malviya
@Date    24 jan 2022
@Name    SalesEngagementBatchClass
@Description Batch Class to run Automation for Sales Engagement Automation Tool with Multiple use cases/rule sets
@Accessibility Only Modigie Automation User and Modigie Admin
***********************************************************************/
public with sharing class SalesEngagementBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    //Perform In Start
    List<Id> tempParamListIds = new List<Id>();
    String tempObjType;

    String objType;
    List<Id> allListId = new List<Id>();
    List<Id> lstId = new List<Id>();
    List<sObject> lstObj = new List<sObject>();

    Integer b_size;
    Boolean isQueue = false;
    Boolean apiCalledUpdateCredits = false;
    String getModigieJobSource = 'Sales Engagement Tool Automation';
    
    List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();
    String accessToken;

    Set<Id> mapRuleIdLst = new Set<Id>();
    Set<Id> mapPerformanceRuleIdLst = new Set<Id>();
    Map<Id, sObject> mapRuleSets = new Map<Id, sObject>();
    Map<Id, sObject> mapPerformanceRuleSets = new Map<Id, sObject>();
    Map<Id, Integer> mapRuleCounter = new Map<Id, Integer>();
    Map<Id, String> ruleSetLogic = new Map<Id, String>();

    //Added for issue: Prioritize for queue if next one can fire it
    Map<Id, List<Id>> improvedMapRecordToRule = new Map<Id, List<Id>>();
    Map<Id, List<Id>> improvedMapNextRecordToRule = new Map<Id, List<Id>>();

    Map<Id, List<Id>> improvedPerformanceMapRecordToRule = new Map<Id, List<Id>>();

    /*Removed for issue: Prioritize for queue if next one can fire it
    Map<Id, Id> mapRecordToRule = new Map<Id, Id>();
    List<Id> serviceCalled = new List<Id>();
    List<Id> modiQueue = new List<Id>();
    Map<Id, Id> mapNextRecordToRule = new Map<Id, Id>();
    */

    public static string removeParenthesis(String Company){
        if(Company == null){
            return null;
        }
        String regex = '[(][^()]*[)]';
        //Company
            
        if(Company.contains('(') && Company.contains(')')){
            String tempCompany = Company;
            Company = Company.replaceAll(regex, '');
            if(tempCompany != Company){
                Company = removeParenthesis(Company);
            }
            
            
        }
        Company = Company.normalizeSpace();
        System.debug('After-->'+Company+'------');
        //if(String.isBlank(FirstName) || String.isBlank(LastName) || String.isBlank(Company)){
            //modiCalledFromRule.remove(objRecId);
        // System.debug('Modigie Data Hygiene');
        //}    
        return Company;
    }

    public void constructorFunction(Set<Id> mapRuleIdLst, String paramObjType){
        objType = paramObjType;
        //Refresh mapRuleCounter in execute for better results, If we do this rule Custom Setting will need to refreshed and updated in the chunk too
        for(Id mapRuleId: mapRuleIdLst){
            ruleSetLogic.put(mapRuleId, RuleSetClass.GetRuleSetSubQuery(mapRuleId, objType).removeStart('AND '));
            mapRuleCounter.put(mapRuleId, 0);

        }

        try{
            modigieCredential = ModigieApiUtils.getServiceAccountDetails();
        }catch (ServerErrorException e) {
            Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(e.getMessage());
            errorMap.put('ModigieService', 'Get Modigie Job Automation');
            System.debug(e.getMessage());
            throw new ServerErrorException(JSON.serialize(errorMap));
        }catch (System.QueryException e) {
            System.debug(e.getMessage());
            throw new SalesEngagementBatchClassException('You are not an authorized user.');
        }catch (Exception e){
            System.debug(e.getMessage());
            throw new SalesEngagementBatchClassException('Error in fetching Modigie Credential.');
        }
    }

    public SalesEngagementBatchClass(List<Id> paramLstIds, String paramObjType) {
        tempParamListIds = paramLstIds;
        tempObjType = paramObjType;
    }
    public void ProcessInStart(List<Id> paramLstIds, String paramObjType) {
        try{
            /**
             * Records to fire
             */
            System.debug('inside processInStart....');
            allListId = paramLstIds;
            Map<Id, List<Id>> mapPerformanceRuleToRecord = new Map<Id, List<Id>>();
            Map<Id, List<Id>> mapRuleToRecord = new Map<Id, List<Id>>();

            String userId = Userinfo.getUserId();
            List<String> modigiePermissionSets = new List<String>{'Modigie_Automation_User'};
            List<user> u = [SELECT Id, Name FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name IN :modigiePermissionSets) AND Id =: userId];
            if(!u.isEmpty()){
                    List<modigie__creditAccountUsers__c> cau = [SELECT Id, Name, modigie__Credit_Id__c, modigie__User_Id__c, modigie__isPerformance__c FROM modigie__creditAccountUsers__c WHERE modigie__User_Id__c =: userId];
                    if(!cau.isEmpty()){
                        if(cau.size() == 1){
                            if(cau[0].modigie__isPerformance__c){
                                String creditId = cau[0].modigie__Credit_Id__c;
                                mapPerformanceRuleToRecord = RuleSetClass.RecordsToFire(paramLstIds, creditId, true);

                                System.debug('Line 119' + mapRuleToRecord);
                                modigie__creditAccountDetails__c cad = [SELECT Id, Name, modigie__Credit_Id__c, modigie__Default__c, modigie__isPerformance__c FROM modigie__creditAccountDetails__c WHERE modigie__Default__c = true LIMIT 1];
                                mapRuleToRecord = RuleSetClass.RecordsToFire(paramLstIds, cad.modigie__Credit_Id__c, false);
                                System.debug('Line 122' + mapRuleToRecord);
                                System.debug('size 1.... inside if');
                            }
                            else{
                                String creditId = cau[0].modigie__Credit_Id__c;
                                mapRuleToRecord = RuleSetClass.RecordsToFire(paramLstIds, creditId, cau[0].modigie__isPerformance__c);
                                System.debug('size 1.... inside else');
                            }
                        }
                        else{
                            for(modigie__creditAccountUsers__c c: cau){
                                if(c.modigie__isPerformance__c){
                                    String creditId = c.modigie__Credit_Id__c;
                                    mapPerformanceRuleToRecord = RuleSetClass.RecordsToFire(paramLstIds, creditId, c.modigie__isPerformance__c);
                                }
                                else{
                                    String creditId = c.modigie__Credit_Id__c;
                                    mapRuleToRecord = RuleSetClass.RecordsToFire(paramLstIds, creditId, c.modigie__isPerformance__c);
                                }
                            }
                        }
                        
                    }
                    else{
                        System.debug('Line 145');
                        modigie__creditAccountDetails__c cad = [SELECT Id, Name, modigie__Credit_Id__c, modigie__Default__c, modigie__isPerformance__c FROM modigie__creditAccountDetails__c WHERE modigie__Default__c = true LIMIT 1];
                        mapRuleToRecord = RuleSetClass.RecordsToFire(paramLstIds, cad.modigie__Credit_Id__c, cad.modigie__isPerformance__c);
                        System.debug('Line 148' + mapRuleToRecord);
                    }
                    
            }
            // Map<Id, List<Id>> mapRuleToRecord = RuleSetClass.RecordsToFire(paramLstIds);
            System.debug('Rule to Record 155 -> ' + mapRuleToRecord);
            System.debug('Performance Rule to Record 156 -> ' + mapPerformanceRuleToRecord);
            mapRuleIdLst = mapRuleToRecord.keySet();
            System.debug('Line 158' + mapRuleIdLst.size());
            System.debug('Line 159' + mapRuleIdLst);
            for(Id mapRuleId: mapRuleIdLst){
                List<Id> templstId = mapRuleToRecord.get(mapRuleId);
                for(Id mapRecordId: templstId){
                    //Removed for issue: Prioritize for queue if next one can fire it
                    //mapRecordToRule.put(mapRecordId, mapRuleId);
                    if(improvedMapRecordToRule.containsKey(mapRecordId)){
                        List<Id> tempMultipleRuleIds = improvedMapRecordToRule.get(mapRecordId);
                        tempMultipleRuleIds.add(mapRuleId);
                        improvedMapRecordToRule.put(mapRecordId, tempMultipleRuleIds);
                    }else{
                        improvedMapRecordToRule.put(mapRecordId, new List<Id>{mapRuleId});
                    }
                }
                lstId.addAll(templstId);
                //String tempRuleName = RuleSetClass.GetRuleSetName(mapRuleId);
            }

            mapPerformanceRuleIdLst = mapPerformanceRuleToRecord.keySet();
            for(Id mapPerformanceRuleId: mapPerformanceRuleIdLst){
                List<Id> templstId = mapPerformanceRuleToRecord.get(mapPerformanceRuleId);
                for(Id mapRecordId: templstId){
                    //Removed for issue: Prioritize for queue if next one can fire it
                    //mapRecordToRule.put(mapRecordId, mapRuleId);
                    if(improvedPerformanceMapRecordToRule.containsKey(mapRecordId)){
                        List<Id> tempMultipleRuleIds = improvedPerformanceMapRecordToRule.get(mapRecordId);
                        tempMultipleRuleIds.add(mapPerformanceRuleId);
                        improvedPerformanceMapRecordToRule.put(mapRecordId, tempMultipleRuleIds);
                    }else{
                        improvedPerformanceMapRecordToRule.put(mapRecordId, new List<Id>{mapPerformanceRuleId});
                    }
                }
                lstId.addAll(templstId);
                //String tempRuleName = RuleSetClass.GetRuleSetName(mapRuleId);
            }

            System.debug('improvedMapRecordToRule ->'+ improvedMapRecordToRule);
            Set<Id> mapAllRulesetList = new Set<Id>();
            mapAllRulesetList.addAll(mapRuleIdLst);
            mapAllRulesetList.addAll(mapPerformanceRuleIdLst);
            constructorFunction(mapAllRulesetList, paramObjType);
            List<modigie__Modigie_Rule_Sets__c> tempModiRuleSets = [SELECT Id, modigie__Rule_Set_Name__c, modigie__Email_Limit_Sent__c, modigie__Limit__c, modigie__Usage__c, modigie__isLimit__c, modigie__Maintain_Queue__c, modigie__isActive__c, modigie__CreditId__c FROM modigie__Modigie_Rule_Sets__c WHERE Id = :mapRuleIdLst AND modigie__isActive__c = true];
            mapRuleSets = new Map<Id, modigie__Modigie_Rule_Sets__c>(tempModiRuleSets);
            // for performance rulesets
            List<modigie__Modigie_Rule_Sets__c> tempModiPerformanceRuleSets = [SELECT Id, modigie__Rule_Set_Name__c, modigie__Email_Limit_Sent__c, modigie__Limit__c, modigie__Usage__c, modigie__isLimit__c, modigie__Maintain_Queue__c, modigie__isActive__c, modigie__CreditId__c FROM modigie__Modigie_Rule_Sets__c WHERE Id = :mapPerformanceRuleIdLst AND modigie__isActive__c = true];
            mapPerformanceRuleSets = new Map<Id, modigie__Modigie_Rule_Sets__c>(tempModiPerformanceRuleSets);

        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('SalesEngagementBatchClass Error', e);
            System.debug(e.getMessage());
        }
    }
    /*
    public SalesEngagementBatchClass(Map<Id, Id> paramRecordToRule, Map<Id, sObject> paramRuleSets, String paramObjType){
        try{
            isQueue = true;
            mapRecordToRule = paramRecordToRule;
            lstId.addAll(paramRecordToRule.keySet());
            mapRuleSets = paramRuleSets;
            mapRuleIdLst = mapRuleSets.keySet();

            constructorFunction(mapRuleIdLst, paramObjType);
        }catch(Exception e){
            //EmailServiceClass.sendErrorEmail('SalesEngagementBatchClass Error', e);
            System.debug(e.getMessage());
        }
    }
    
    public SalesEngagementBatchClass(Map<Id, Id> paramRecordToRule, Map<Id, Id> paramNextRecordToRule, Map<Id, sObject> paramRuleSets, String paramObjType){
        try{
            isQueue = true;
            mapRecordToRule = paramRecordToRule;
            mapNextRecordToRule = paramNextRecordToRule;
            lstId.addAll(paramRecordToRule.keySet());
            mapRuleSets = paramRuleSets;
            mapRuleIdLst = mapRuleSets.keySet();
            try{
                b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                if(b_size > 100 || b_size < 1){
                    b_size = 100;
                }
            }catch(Exception e){
                b_size = 100;
            }
            constructorFunction(mapRuleIdLst, paramObjType);
        }catch(Exception e){
            //EmailServiceClass.sendErrorEmail('SalesEngagementBatchClass Error', e);
            System.debug(e.getMessage());
        }
    }*/

    //Added for issue: Prioritize for queue if next one can fire it
    public SalesEngagementBatchClass(Map<Id, List<Id>> paramRecordToRule, Map<Id, sObject> paramRuleSets, String paramObjType){
        try{
            isQueue = true;
            improvedMapRecordToRule = paramRecordToRule;
            lstId.addAll(paramRecordToRule.keySet());
            mapRuleSets = paramRuleSets;
            mapRuleIdLst = mapRuleSets.keySet();

            constructorFunction(mapRuleIdLst, paramObjType);
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('SalesEngagementBatchClass Error', e);
            System.debug(e.getMessage());
        }
    }

    //Added for issue: Prioritize for queue if next one can fire it
    public SalesEngagementBatchClass(Map<Id, List<Id>> paramRecordToRule, Map<Id, List<Id>> paramNextRecordToRule, Map<Id, sObject> paramRuleSets, String paramObjType){
        try{
            isQueue = true;
            improvedMapRecordToRule = paramRecordToRule;
            improvedMapNextRecordToRule = paramNextRecordToRule;
            lstId.addAll(paramRecordToRule.keySet());
            mapRuleSets = paramRuleSets;
            mapRuleIdLst = mapRuleSets.keySet();
            try{
                b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                if(b_size > 100 || b_size < 1){
                    b_size = 100;
                }
            }catch(Exception e){
                b_size = 100;
            }
            constructorFunction(mapRuleIdLst, paramObjType);
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('SalesEngagementBatchClass Error', e);
            System.debug(e.getMessage());
        }
    }

    public database.QueryLocator start(Database.BatchableContext bc) {
        if(!isQueue){
            ProcessInStart(tempParamListIds, tempObjType);
        }
        String qry = '';
        Set<Id> setIds = new Set<Id>(lstId);
        try{
            qry += 'SELECT Id, ';
            String appendLater = ' AND FirstName != Null AND LastName != Null AND (Email != Null OR modigie__Linkedin_URL__c != Null)';
            if(objType == 'Lead'){
                qry += 'Company';
                appendLater += ' AND Company != Null';
            }else if(objType == 'Contact'){
                qry+= 'Account.Name, Account.Id';
                appendLater += ' AND Account.Name != Null';
            }
            qry += ', FirstName, LastName, Email, MobilePhone, modigie__Linkedin_URL__c, (SELECT Id FROM modigie__Modigie__r) FROM ' + objType + ' WHERE Id = :setIds AND Id NOT IN (SELECT modigie__' + objType + '__c FROM modigie__Modigie__c WHERE modigie__Status__c IN (\'In process\', \'Validated\', \'Not Available\'))' + appendLater;
            
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('SalesEngagementBatchClass Error', e);
            qry += 'SELECT Id FROM Lead WHERE Id = Null';
        }
        return database.getQueryLocator(qry);
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        try{
            System.debug('Hello.......');
            //Boolean flsCheck = Check();
            //flscheck need to be added extra field
            if(
                FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') 
                && FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') 
                && FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Jobid__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Jobid__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Jobid__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Validation_Key__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Validation_Key__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Validation_Key__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Status__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Status__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Status__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Lead__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Lead__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Lead__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Parent_Id__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Parent_Id__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Parent_Id__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Validation_Date_Get_Mobile_Number__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Validation_Date_Get_Mobile_Number__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Validation_Date_Get_Mobile_Number__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Get_Modigie_Job_Status__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Get_Modigie_Job_Status__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Get_Modigie_Job_Status__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Get_Mobile_Campaign_User__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Get_Mobile_Campaign_User__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Get_Mobile_Campaign_User__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Campaign_Id_GetMobileNumber__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Campaign_Id_GetMobileNumber__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Campaign_Id_GetMobileNumber__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Mobile__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Mobile__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Mobile__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Modigie_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Modigie_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Modigie_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Line_Activity_Modigie_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Modigie_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Modigie_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Modigie_Val_Number__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Modigie_Val_Number__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Modigie_Val_Number__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Phone_Type_Modigie_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Modigie_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Modigie_Validated_Number__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__LinkedIn_Url_Get_Mobile_Number__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__LinkedIn_Url_Get_Mobile_Number__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__LinkedIn_Url_Get_Mobile_Number__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Current_Title_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Current_Title_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Current_Title_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Current_Employer_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Current_Employer_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Current_Employer_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Current_Country_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Current_Country_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Current_Country_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Company_Name_Matches_Records_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Company_Name_Matches_Records_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Company_Name_Matches_Records_Get_Modigie__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Mobile_2__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Mobile_2__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Mobile_2__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Mobile_3__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Mobile_3__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Mobile_3__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate1__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate1__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate1__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate2__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate2__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate2__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number1__c' ) 
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number2__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number2__c' )
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Rule_Set_Logic__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Logic__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Logic__c' )
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Rule_Set_Id__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Id__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Id__c' )
                && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Rule_Set_Name__c' ) 
                && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Name__c' ) 
                && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Name__c' )
            ){
                ModigieStaticReferenceHelper.isSalesEngagementBatchRunning = true;
                List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
                Map<Id, Id> modiCalledFromRule = new Map<Id, Id>();
                Map<Id, Id> modiCalledFromPerformanceRule = new Map<Id, Id>();
                Map<Id, Id> modiQueuedFromRule = new Map<Id, Id>();

                Map<String, Object> outerMap = new Map<String, Object>();

                List<modigie__creditAccountUsers__c> cau = [SELECT Id, Name, modigie__Credit_Id__c, modigie__isPerformance__c FROM modigie__creditAccountUsers__c
                                                  WHERE modigie__User_Id__c =: Userinfo.getUserId() AND modigie__isPerformance__c = false LIMIT 1];
                String creditAccountId;
                if(!cau.isEmpty()){
                    creditAccountId = cau[0].modigie__Credit_Id__c;
                }
                else{
                    List<modigie__creditAccountDetails__c> cad = [SELECT Id, Name, modigie__Credit_Id__c, modigie__Default__c FROM modigie__creditAccountDetails__c
                                                            WHERE modigie__Default__c = true LIMIT 1];
                    if(!cad.isEmpty()){
                    creditAccountId = cad[0].modigie__Credit_Id__c;
                    }
                }

                outerMap.put('creditsId', creditAccountId);
                System.debug('creditsId'+ creditAccountId);

                String currentPackageVersion = String.valueOf(System.requestVersion());
                if(System.requestVersion().patch() != null){
                    currentPackageVersion += '.' + System.requestVersion().patch();
                }
                List<Map<String, Object>> lstJobLevelCustomParameters = new List<Map<String, Object>>{
                    new Map<String, Object>{'name' => 'modigie-client-name', 'value' => 'sfdc'},
                    new Map<String, Object>{'name' => 'modigie-client-sfdc-version', 'value' => currentPackageVersion},
                    new Map<String, Object>{'name' => 'modigie-client-sfdc-org', 'value' => UserInfo.getOrganizationId()}
                };

                lstJobLevelCustomParameters.add(new Map<String, Object>{'name' => 'modigie-client-sfdc-automation','value' => 'GetModigie-Automation-SalesEngagement'});

                outerMap.put('customParameters', lstJobLevelCustomParameters);

                List<Map<String, Object>> tempLstObj = new List<Map<String, Object>>();
                List<Map<String, Object>> newTempLstObj = new List<Map<String, Object>>();

                ModigieJsonWrapper.personSyncWrapper personSyncWrap = new ModigieJsonWrapper.personSyncWrapper();
                personSyncWrap.client.code = 'sfdc';
                personSyncWrap.client.version = '1.70.0';
                Set<Id> rulesetIds = new Set<Id>();

                for(sObject objRec : scope) {
                    Id objRecId = (Id)objRec.get('Id');
                    //Added for issue: Prioritize for queue if next one can fire it
                    List<Id> tempMulRuleSetId = improvedMapRecordToRule.get(objRecId);
                    System.debug('tempMulRuleSetId---->'+tempMulRuleSetId);
                    //List<sObject> tempMulModiRuleSet = new List<sObject>();
                    for(Id tempSingleRuleSetId: tempMulRuleSetId){
                        sObject tempSingleModiRuleSet = mapRuleSets.get(tempSingleRuleSetId);

                        if((Boolean)tempSingleModiRuleSet.get('modigie__isActive__c')){
                            if((Boolean)tempSingleModiRuleSet.get('modigie__isLimit__c')){
                                Integer tempLimit = Integer.valueOf((decimal)tempSingleModiRuleSet.get('modigie__Limit__c'));
                                Integer tempUsage = Integer.valueOf((decimal)tempSingleModiRuleSet.get('modigie__Usage__c'));
                                if(tempUsage == null){
                                    tempUsage = 0;
                                    if(tempLimit == null){
                                        tempUsage = 0;
                                    }
                                }
                                Integer tempCounter = mapRuleCounter.get(tempSingleRuleSetId);

                                System.debug(tempSingleRuleSetId +' isCheck ' + (tempLimit - (tempUsage + tempCounter)));
                                if((tempLimit - (tempUsage + tempCounter)) > 0){
                                    //Not negating prioritize rule from below for firing
                                    if(!modiCalledFromRule.containsKey(objRecId)){
                                        modiCalledFromRule.put(objRecId, tempSingleRuleSetId);
                                    }else{
                                        //Since, it is negation we can break here (Look modiCalledFromRule adding condition), we already got the rule which will fire our record
                                        break;
                                    }
                                }else{
                                    Boolean currentRuleMaintainQueue = (Boolean)tempSingleModiRuleSet.get('modigie__Maintain_Queue__c');
                                    System.debug('isQueue-->'+ isQueue);
                                    if(currentRuleMaintainQueue && !isQueue){
                                        //Limit Reached for particular RuleSet with Maintain Queue
                                        //Not negating prioritize rule from below for queuing
                                        //We can have replace ruleId so, queues priority is from below
                                        if(!modiQueuedFromRule.containsKey(objRecId)){
                                            System.debug('Put in Queue');
                                            modiQueuedFromRule.put(objRecId, tempSingleRuleSetId);
                                        }
                                    }else {
                                        //Limit Reached for particular RuleSet without Maintain Queue
                                    }
                                }
                            }else{
                                //Not negating prioritize rule from below for firing
                                //if(!modiCalledFromRule.containsKey(objRecId)){
                                    //modiCalledFromRule.put(objRecId, tempSingleRuleSetId);
                                //}
                                modiCalledFromRule.put(objRecId, tempSingleRuleSetId);
                            }
                        }
                    }

                    // for performance rulesets
                    List<Id> tempMulPerformanceRuleSetId = improvedPerformanceMapRecordToRule.get(objRecId);
                    System.debug('line 536'+tempMulPerformanceRuleSetId);
                    if(tempMulPerformanceRuleSetId != null){
                        for(Id tempSingleRuleSetId: tempMulPerformanceRuleSetId){
                            System.debug('line 538'+mapPerformanceRuleSets.get(tempSingleRuleSetId));
                            sObject tempSingleModiRuleSet = mapPerformanceRuleSets.get(tempSingleRuleSetId);
                            System.debug('line 540'+tempSingleModiRuleSet);
                            if((Boolean)tempSingleModiRuleSet.get('modigie__isActive__c')){
                                if((Boolean)tempSingleModiRuleSet.get('modigie__isLimit__c')){
                                    Integer tempLimit = Integer.valueOf((decimal)tempSingleModiRuleSet.get('modigie__Limit__c'));
                                    Integer tempUsage = Integer.valueOf((decimal)tempSingleModiRuleSet.get('modigie__Usage__c'));
                                    if(tempUsage == null){
                                        tempUsage = 0;
                                        if(tempLimit == null){
                                            tempUsage = 0;
                                        }
                                    }
                                    Integer tempCounter = mapRuleCounter.get(tempSingleRuleSetId);

                                    System.debug(tempSingleRuleSetId +' isCheck ' + (tempLimit - (tempUsage + tempCounter)));
                                    if((tempLimit - (tempUsage + tempCounter)) > 0){
                                        //Not negating prioritize rule from below for firing
                                        if(!modiCalledFromPerformanceRule.containsKey(objRecId)){
                                            modiCalledFromPerformanceRule.put(objRecId, tempSingleRuleSetId);
                                        }else{
                                            //Since, it is negation we can break here (Look modiCalledFromPerformanceRule adding condition), we already got the rule which will fire our record
                                            break;
                                        }
                                    }else{
                                        Boolean currentRuleMaintainQueue = (Boolean)tempSingleModiRuleSet.get('modigie__Maintain_Queue__c');
                                        System.debug('isQueue-->'+ isQueue);
                                        if(currentRuleMaintainQueue && !isQueue){
                                            //Limit Reached for particular RuleSet with Maintain Queue
                                            //Not negating prioritize rule from below for queuing
                                            //We can have replace ruleId so, queues priority is from below
                                            if(!modiQueuedFromRule.containsKey(objRecId)){
                                                System.debug('Put in Queue');
                                                modiQueuedFromRule.put(objRecId, tempSingleRuleSetId);
                                            }
                                        }else {
                                            //Limit Reached for particular RuleSet without Maintain Queue
                                        }
                                    }
                                }else{
                                    //Not negating prioritize rule from below for firing
                                    //if(!modiCalledFromRule.containsKey(objRecId)){
                                        //modiCalledFromRule.put(objRecId, tempSingleRuleSetId);
                                    //}
                                    modiCalledFromPerformanceRule.put(objRecId, tempSingleRuleSetId);
                                }
                            }
                        }
                    }
                    

                    System.debug('modiCalledFromRule------>' + modiCalledFromRule);
                    System.debug('modiCalledFromRule------>' + modiCalledFromPerformanceRule);

                    if(modiQueuedFromRule.containsKey(objRecId) && modiCalledFromRule.containsKey(objRecId)){
                        System.debug('Contains in Called so removed from queue');
                        modiQueuedFromRule.remove(objRecId);
                    }

                    String FirstName = (String)objRec.get('FirstName');
                    FirstName = FirstName.normalizeSpace();
                    String LastName = (String)objRec.get('LastName');
                    LastName = LastName.normalizeSpace();
                    String Company;
                    if(objType == 'Lead'){
                        Company = (String)objRec.get('Company');
                        if(Company.contains('(') && Company.contains(')')){
                            Company = removeParenthesis(Company);
                        }
                        if((String.isBlank(Company)) && modiCalledFromRule.containsKey(objRecId)){
                            modiCalledFromRule.remove(objRecId);
                        }
                    }
                    
                    
                    
                    if((String.isBlank(FirstName) || String.isBlank(LastName)) && modiCalledFromRule.containsKey(objRecId)){
                        modiCalledFromRule.remove(objRecId);
                    }
                    

                    if(modiCalledFromRule.containsKey(objRecId)){
                        ModigieJsonWrapper.cls_items itemlist = new ModigieJsonWrapper.cls_items();
                        itemlist.id = objRecId;
                        itemlist.objectType = objType;
                        itemlist.firstName = FirstName;
                        itemlist.lastName = LastName;
                        if(objType == 'Lead'){
                            itemlist.company.title = Company;
                        }
                        else if(objType == 'Contact'){
                            itemlist.company.accountId = (String)objRec.getSObject('Account').get('Id');
                        }
                        if(objRec.get('Email') != null){
                            ModigieJsonWrapper.cls_emailAddresses emailAddresses = new ModigieJsonWrapper.cls_emailAddresses();
                            emailAddresses.emailAddress.userFormat = (String)objRec.get('Email');
                            emailAddresses.rels.add('business');
                            emailAddresses.origin = 'salesforce-email';
                            itemlist.emailAddresses.add(emailAddresses);
                            if(objRec.get('modigie__linkedin_url__c') != null && GetModigieButton.checkValidLinkedInUrl((String)objRec.get('modigie__linkedin_url__c'))) {
                                ModigieJsonWrapper.cls_urls urls = new ModigieJsonWrapper.cls_urls();
                                urls.url.userFormat = (String)objRec.get('modigie__linkedin_url__c');
                                urls.rels.add('linkedInUser');
                                urls.origin = 'salesforce-email';
                                itemlist.urls.add(urls);
                            }
                        }else if(objRec.get('modigie__linkedin_url__c') != null && GetModigieButton.checkValidLinkedInUrl((String)objRec.get('modigie__linkedin_url__c'))) {
                            ModigieJsonWrapper.cls_urls urls = new ModigieJsonWrapper.cls_urls();
                            urls.url.userFormat = (String)objRec.get('modigie__linkedin_url__c');
                            urls.rels.add('linkedInUser');
                            urls.origin = 'salesforce-email';
                            itemlist.urls.add(urls);
                        }else{
                            continue;
                        }

                        List<String> mobileNumberList = new List<String>();
                        
                        if(objRec.get('MobilePhone') != Null){
                            String mobileNumber = (String) objRec.get('MobilePhone');
                            if(!mobileNumber.startsWith('+')){
                                if(mobileNumber.startsWith('1')){
                                    mobileNumber = '+' + mobileNumber;
                                }else{
                                    mobileNumber = '+1' + mobileNumber;
                                }
                            }
                            mobileNumberList.add(mobileNumber);
                        }
                        for(String MobileNumber: mobileNumberList){
                            ModigieJsonWrapper.cls_phoneNumbers phoneNumbers = new ModigieJsonWrapper.cls_phoneNumbers();
                            phoneNumbers.phoneNumber.userFormat = MobileNumber;
                            phoneNumbers.rels.add('business');
                            phoneNumbers.origin = 'salesforce-phone';
                            itemlist.phoneNumbers.add(phoneNumbers);
                        }
                        itemlist.syncTrigger.creditAccount.id = (String)mapRuleSets.get(modiCalledFromRule.get(objRecId)).get('modigie__CreditId__c');
                        itemlist.syncTrigger.ruleset.id = modiCalledFromRule.get(objRecId);
                        itemlist.syncTrigger.triggerType.automation = 'GetModigie-Automation-SalesEngagement';
                        itemlist.progress.job.jobType = 'mobilePhone';
                        personSyncWrap.items.add(itemlist);
                        rulesetIds.add(modiCalledFromRule.get(objRecId));
                        //code above is for new payload /\ /\

                        Map<String, Object> sinCon = new Map<String, Object>();
                        sinCon.put('firstName', FirstName);
                        sinCon.put('lastName', LastName);
                        if(objType == 'Lead'){
                            sinCon.put('company', Company);
                        }else if(objType == 'Contact'){
                            sinCon.put('company', objRec.getSObject('Account').get('Name'));
                        }
                        
                        List<String> lstMobileNumber = new List<String>();
                        
                        if(objRec.get('MobilePhone') != Null){
                            String mobileNumber = (String) objRec.get('MobilePhone');
                            if(!mobileNumber.startsWith('+')){
                                if(mobileNumber.startsWith('1')){
                                    mobileNumber = '+' + mobileNumber;
                                }else{
                                    mobileNumber = '+1' + mobileNumber;
                                }
                            }
                            lstMobileNumber.add(mobileNumber);
                        }
                        if(!lstMobileNumber.isEmpty()){
                            sinCon.put('mobilePhones', lstMobileNumber);
                        }
                        Map<String, String> customParaMap = new Map<String, String>();
                        customParaMap.put('name', 'recordIdAndOrgId');
                        customParaMap.put('value', objRec.id + UserInfo.getOrganizationId());
                        List<Map<String, String>> tempLstMap = new List<Map<String, String>>();
                        tempLstMap.add(customParaMap);
                        sinCon.put('customParameters', tempLstMap);
                        if(objRec.get('Email') != null){
                            sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputEmail');
                            sinCon.put('companyEmail', objRec.get('Email'));
                            if(objRec.get('modigie__linkedin_url__c') != null && GetModigieButton.checkValidLinkedInUrl((String)objRec.get('modigie__linkedin_url__c'))) {
                                sinCon.put('linkedInUrl', objRec.get('modigie__linkedin_url__c'));
                            }
                        }else if(objRec.get('modigie__linkedin_url__c') != null && GetModigieButton.checkValidLinkedInUrl((String)objRec.get('modigie__linkedin_url__c'))) {
                            sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputLinkedIn');
                            sinCon.put('linkedInUrl', objRec.get('modigie__linkedin_url__c'));
                        }else{
                            continue;
                        }
                        System.debug('Made sincon by attribute');
                        Map<String, Object> newSinCon = new Map<String, Object>();
                        newSinCon = sinCon;
                        newSinCon.put('rulesetId',modiCalledFromRule.get(objRecId));
                        newTempLstObj.add(newSinCon);
                        tempLstObj.add(sinCon);
                        Id tempCalledRuleSetId = modiCalledFromRule.get(objRecId);
                        mapRuleCounter.put(tempCalledRuleSetId, (mapRuleCounter.get(tempCalledRuleSetId) + 1));
                        System.debug(tempCalledRuleSetId +'Increament by 1 -' + mapRuleCounter.get(tempCalledRuleSetId));   
                    }


                    //for performance ruleset---------------

                    if(modiCalledFromPerformanceRule.containsKey(objRecId)){
                        ModigieJsonWrapper.cls_items itemlist = new ModigieJsonWrapper.cls_items();
                        itemlist.id = objRecId;
                        itemlist.objectType = objType;
                        itemlist.firstName = FirstName;
                        itemlist.lastName = LastName;
                        if(objType == 'Lead'){
                            itemlist.company.title = Company;
                        }
                        else if(objType == 'Contact'){
                            itemlist.company.accountId = (String)objRec.getSObject('Account').get('Id');
                        }
                        if(objRec.get('Email') != null){
                            ModigieJsonWrapper.cls_emailAddresses emailAddresses = new ModigieJsonWrapper.cls_emailAddresses();
                            emailAddresses.emailAddress.userFormat = (String)objRec.get('Email');
                            emailAddresses.rels.add('business');
                            emailAddresses.origin = 'salesforce-email';
                            itemlist.emailAddresses.add(emailAddresses);
                            if(objRec.get('modigie__linkedin_url__c') != null && GetModigieButton.checkValidLinkedInUrl((String)objRec.get('modigie__linkedin_url__c'))) {
                                ModigieJsonWrapper.cls_urls urls = new ModigieJsonWrapper.cls_urls();
                                urls.url.userFormat = (String)objRec.get('modigie__linkedin_url__c');
                                urls.rels.add('linkedInUser');
                                urls.origin = 'salesforce-email';
                                itemlist.urls.add(urls);
                            }
                        }else if(objRec.get('modigie__linkedin_url__c') != null && GetModigieButton.checkValidLinkedInUrl((String)objRec.get('modigie__linkedin_url__c'))) {
                            ModigieJsonWrapper.cls_urls urls = new ModigieJsonWrapper.cls_urls();
                            urls.url.userFormat = (String)objRec.get('modigie__linkedin_url__c');
                            urls.rels.add('linkedInUser');
                            urls.origin = 'salesforce-email';
                            itemlist.urls.add(urls);
                        }else{
                            continue;
                        }

                        List<String> mobileNumberList = new List<String>();
                        
                        if(objRec.get('MobilePhone') != Null){
                            String mobileNumber = (String) objRec.get('MobilePhone');
                            if(!mobileNumber.startsWith('+')){
                                if(mobileNumber.startsWith('1')){
                                    mobileNumber = '+' + mobileNumber;
                                }else{
                                    mobileNumber = '+1' + mobileNumber;
                                }
                            }
                            mobileNumberList.add(mobileNumber);
                        }
                        for(String MobileNumber: mobileNumberList){
                            ModigieJsonWrapper.cls_phoneNumbers phoneNumbers = new ModigieJsonWrapper.cls_phoneNumbers();
                            phoneNumbers.phoneNumber.userFormat = MobileNumber;
                            phoneNumbers.rels.add('business');
                            phoneNumbers.origin = 'salesforce-phone';
                            itemlist.phoneNumbers.add(phoneNumbers);
                        }
                        itemlist.syncTrigger.creditAccount.id = (String)mapPerformanceRuleSets.get(modiCalledFromPerformanceRule.get(objRecId)).get('modigie__CreditId__c');
                        itemlist.syncTrigger.ruleset.id = modiCalledFromPerformanceRule.get(objRecId);
                        itemlist.syncTrigger.triggerType.automation = 'GetModigie-Automation-SalesEngagement';
                        itemlist.progress.job.jobType = 'mobilePhone';
                        
                        personSyncWrap.items.add(itemlist);
                        rulesetIds.add(modiCalledFromPerformanceRule.get(objRecId));
                    }
                    
                    
                    //End of Added for issue: Prioritize for queue if next one can fire it
                    /*
                    Id tempRuleSetId = mapRecordToRule.get((Id)objRec.get('Id'));
                    sObject tempModiRuleSet = mapRuleSets.get(tempRuleSetId);
                    
                    //scope run till {limit - usage}, and if maintain queue enabled put in queue
                    if((Boolean)tempModiRuleSet.get('modigie__isActive__c')){
                        Integer tempLimit = Integer.valueOf((decimal)tempModiRuleSet.get('modigie__Limit__c'));
                        Integer tempUsage = Integer.valueOf((decimal)tempModiRuleSet.get('modigie__Usage__c'));
                        System.debug(tempRuleSetId +'isCheck' + (tempLimit - (tempUsage + mapRuleCounter.get(tempRuleSetId))));
                        if((tempLimit - (tempUsage + mapRuleCounter.get(tempRuleSetId))) > 0){
                            Map<String, Object> sinCon = new Map<String, Object>();
                            sinCon.put('firstName', objRec.get('FirstName'));
                            sinCon.put('lastName', objRec.get('LastName'));
                            if(objType == 'Lead'){
                                sinCon.put('company', objRec.get('Company'));
                            }else if(objType == 'Contact'){
                                sinCon.put('company', objRec.getSObject('Account').get('Name'));
                            }
                            
                            List<String> lstMobileNumber = new List<String>();
                            
                            if(objRec.get('MobilePhone') != Null){
                                String mobileNumber = (String) objRec.get('MobilePhone');
                                if(!mobileNumber.startsWith('+')){
                                    if(mobileNumber.startsWith('1')){
                                        mobileNumber = '+' + mobileNumber;
                                    }else{
                                        mobileNumber = '+1' + mobileNumber;
                                    }
                                }
                                lstMobileNumber.add(mobileNumber);
                            }
                            if(!lstMobileNumber.isEmpty()){
                                sinCon.put('mobilePhones', lstMobileNumber);
                            }
                            Map<String, String> customParaMap = new Map<String, String>();
                            customParaMap.put('name', 'recordIdAndOrgId');
                            customParaMap.put('value', objRec.id + UserInfo.getOrganizationId());
                            List<Map<String, String>> tempLstMap = new List<Map<String, String>>();
                            tempLstMap.add(customParaMap);
                            sinCon.put('customParameters', tempLstMap);
                            if(objRec.get('Email') != null){
                                sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputEmail');
                                sinCon.put('companyEmail', objRec.get('Email'));
                                if(objRec.get('modigie__linkedin_url__c') != null && GetModigieButton.checkValidLinkedInUrl((String)objRec.get('modigie__linkedin_url__c'))) {
                                    sinCon.put('linkedInUrl', objRec.get('modigie__linkedin_url__c'));
                                }
                            }else if(objRec.get('modigie__linkedin_url__c') != null && GetModigieButton.checkValidLinkedInUrl((String)objRec.get('modigie__linkedin_url__c'))) {
                                sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputLinkedIn');
                                sinCon.put('linkedInUrl', objRec.get('modigie__linkedin_url__c'));
                            }else{
                                continue;
                            }
                            tempLstObj.add(sinCon);
                            mapRuleCounter.put(tempRuleSetId, (mapRuleCounter.get(tempRuleSetId) + 1));
                            System.debug(tempRuleSetId +'Increament by 1' + mapRuleCounter.get(tempRuleSetId));
                            serviceCalled.add((Id)objRec.get('Id'));
                        }else{
                            if((Boolean)tempModiRuleSet.get('modigie__Maintain_Queue__c') && !isQueue){
                                //Limit Reached for particular RuleSet with Maintain Queue
                                modiQueue.add((Id)objRec.get('Id'));
                                System.debug('Queued Added');
                            }else {
                                //Limit Reached for particular RuleSet without Maintain Queue
                            }
                            //Send Email for Limit Reached
                        }
                    }*/
                }
                

                for(Id ruleId: rulesetIds){
                    ModigieJsonWrapper.cls_rulesets ruleset = new ModigieJsonWrapper.cls_rulesets();
                    if(mapPerformanceRuleSets.keySet().contains(ruleId)){
                        System.debug('inside if...');
                        ruleset.id = (String)mapPerformanceRuleSets.get(ruleId).get('Id');
                        ruleset.title = (String)mapPerformanceRuleSets.get(ruleId).get('modigie__Rule_Set_Name__c');
                        ruleset.objectType = objType;
                        ruleset.logic = (String)ruleSetLogic.get((String)mapPerformanceRuleSets.get(ruleId).get('Id')).substring(4);
                        System.debug(ruleset.logic.substring(4));
                        personSyncWrap.rulesets.add(ruleset);
                        
                    }
                    else{
                        System.debug('inside else....');
                        ruleset.id = (String)mapRuleSets.get(ruleId).get('Id');
                        ruleset.title = (String)mapRuleSets.get(ruleId).get('modigie__Rule_Set_Name__c');
                        ruleset.objectType = objType;
                        ruleset.logic = (String)ruleSetLogic.get((String)mapRuleSets.get(ruleId).get('Id')).substring(4);
                        personSyncWrap.rulesets.add(ruleset);
                    }
                    System.debug('ruleset--->'+ruleset);
                    
                }
                
                System.debug('personSync----->'+personSyncWrap);
                System.debug('personSync2----->'+JSON.serialize(personSyncWrap));
                
                outerMap.put('contacts', tempLstObj);
                System.debug('Payload'+outerMap);
                List<Map<String, Object>> items = ModigieApiUtils.setNewPayload(outerMap, newTempLstObj, objType);
                Map<String, Object> newPayload = new Map<String, Object>();
                Map<String, String> client = new Map<String, String>();
                client.put('code', 'sfdc');
                client.put('version', '1.70.0');
                newPayload.put('client', client);
                newPayload.put('items', items);
                System.debug('newpayload'+newPayload);

                List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Mobile Phone Job Create' LIMIT 1];
                String targetAudience, endpoint, contentType;
                if(!calloutInfo.isEmpty()){
                    endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
                    targetAudience = calloutInfo[0].modigie__targetAud__c;
                    contentType = calloutInfo[0].modigie__Content_Type__c;
                }

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');
                request.setHeader('Content-Type', ' application/json');
                
                //Refresh AccessToken Every Batch Chunk
                accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Email__c, targetAudience, modigieCredential[0].modigie__Private_Key__c);

                request.setHeader('Authorization', accessToken);
                request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);
                request.setEndpoint(endpoint);
                request.setBody(JSON.serialize(outerMap));
                request.setTimeout(120000);
                HttpResponse response = new HttpResponse();

                if(!modiCalledFromRule.isEmpty()){
                    apiCalledUpdateCredits = true;
                    response = http.send(request);
                }
                
                /*if(String.valueOf(response.getStatusCode())[0] == '5'){
                    response = http.send(request);
                }else if(response.getStatusCode == 401){
                    accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential.modigie__Service_Account_Credentials__c, 'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app', modigieCredential.modigie__Private_Key__c);
                    response = http.send(request);
                }*/

                if(response.getStatusCode() == 202 || modiCalledFromRule.isEmpty()){
                    String jobid;
                    String jsonResponse = response.getBody();
                    Map<String, Object> responseMap = new Map<String, Object>();

                    if(!modiCalledFromRule.isEmpty()){
                        responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
                        jobid = responseMap.get('id').toString();
                    }

                    for (sObject objRec : scope) {
                        Id objRecId = (Id)objRec.get('id');
                        if(modiCalledFromRule.containsKey(objRecId) || modiQueuedFromRule.containsKey(objRecId)){
                            modigie__Modigie__c modiRec = new modigie__Modigie__c();
                            //Integer size = 0;
                            if(objRec.getSObjects('modigie__Modigie__r') != Null){
                                //size = objRec.getSObjects('modigie__Modigie__r').size();
                                if(objRec.getSObjects('modigie__Modigie__r').size() > 0) {
                                    modiRec.id = (Id)objRec.getSObjects('modigie__Modigie__r')[0].get('Id');
                                }
                            }
                
                            modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();

                            String parentField = 'modigie__'+objType+'__c';
                            modiRec.put(parentField, objRecId);
                            modiRec.modigie__Parent_Id__c = objRecId;

                            Id tempRuleId = modiCalledFromRule.get(objRecId);
                            if(tempRuleId == null){
                                tempRuleId = modiQueuedFromRule.get(objRecId);
                            }
                            modiRec.modigie__Rule_Set_Id__c = tempRuleId;
                            String tempRuleName = (String)mapRuleSets.get(tempRuleId).get('modigie__Rule_Set_Name__c');
                            modiRec.modigie__Rule_Set_Name__c = tempRuleName;

                            String tempLogic = (String)ruleSetLogic.get(tempRuleId);
                            if(tempLogic != null){
                                Integer lastIndex = 32767;
                                if(tempLogic.length() < lastIndex){
                                    lastIndex = tempLogic.length();
                                }
                                tempLogic = tempLogic.subString(4, lastIndex);
                            }
                            modiRec.modigie__Rule_Set_Logic__c = tempLogic;
                            
                            if(modiQueuedFromRule.containsKey(objRecId)){
                                System.debug('Queued');
                                modiRec.modigie__Status__c = 'In queue';
                            }else{
                                System.debug('Called');
                                modiRec.modigie__Status__c = 'In process';

                                String statusGetModigie = responseMap.get('status').toString();
                                statusGetModigie = statusGetModigie.substring(0, 1).toUpperCase() + statusGetModigie.substring(1, statusGetModigie.length());
                                modiRec.modigie__Get_Modigie_Job_Status__c = statusGetModigie;
                                modiRec.modigie__Jobid__c = jobid;
                            }
                            modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                            modiRec.modigie__User_GetModigieMobile__c = UserInfo.getUserId();
                
                            modirec.modigie__Mobile__c = null;
                            modirec.modigie__Accuracy_Match_Modigie_Validated_Number__c = null;
                            modirec.modigie__Line_Activity_Modigie_Validated_Number__c = null;
                            modirec.modigie__Best_Time_to_Call_Validated_Number__c = null;
                            modirec.modigie__Day_of_Week_Detail_Modigie_Val_Number__c = null;
                            modirec.modigie__Phone_Type_Modigie_Validated_Number__c = null;
                            modirec.modigie__Phone_Type_Alternate_Number1__c = null;
                            modirec.modigie__Phone_Type_Alternate_Number2__c = null;
                            modirec.modigie__LinkedIn_Url_Get_Mobile_Number__c = null;
                            modirec.modigie__Current_Title_Get_Modigie__c = null;
                            modirec.modigie__Current_Employer_Get_Modigie__c = null;
                            modirec.modigie__Current_Country_Get_Modigie__c = null;
                            modirec.modigie__Company_Name_Matches_Records_Get_Modigie__c = null;
                            modirec.modigie__Mobile_2__c = null;
                            modirec.modigie__Mobile_3__c = null;
                            modirec.modigie__Accuracy_Match_Alternate_Number1__c = null;
                            modirec.modigie__Accuracy_Match_Alternate_Number2__c = null;
                            modirec.modigie__Line_Activity_Alternate1__c = null;
                            modirec.modigie__Line_Activity_Alternate2__c = null;
                            modirec.modigie__Day_of_Week_Detail_Alternate_Number1__c = null;
                            modirec.modigie__Day_of_Week_Detail_Alternate_Number2__c = null;
                            modirec.modigie__Best_Time_to_Call_Alternate_Number1__c = null;
                            modirec.modigie__Best_Time_to_Call_Alternate_Number2__c = null;
                            modiRec.modigie__Get_Modigie_Job_Source__c = getModigieJobSource;
                            System.debug('modiRec -> '+modiRec);
                            modiList.add(modiRec);
                        }
                        /*
                        if(serviceCalled.contains((id)objRec.get('id')) || modiQueue.contains((id)objRec.get('id'))){
                            modigie__Modigie__c modiRec = new modigie__Modigie__c();
                            if(objRec.getSObjects('modigie__Modigie__r') != Null){
                                if(objRec.getSObjects('modigie__Modigie__r').size() > 0) {
                                    modiRec.id = (Id)objRec.getSObjects('modigie__Modigie__r')[0].get('Id');
                                }
                            }
                
                            modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
                            modiRec.modigie__Jobid__c = jobid;

                            String parentField = 'modigie__'+objType+'__c';
                            modiRec.put(parentField, (Id)objRec.get('id'));
                            modiRec.modigie__Parent_Id__c = (Id)objRec.get('id');

                            Id tempRuleId = mapRecordToRule.get((Id)objRec.get('id'));
                            modiRec.modigie__Rule_Set_Id__c = tempRuleId;
                            String tempRuleName = (String)mapRuleSets.get(tempRuleId).get('modigie__Rule_Set_Name__c');
                            modiRec.modigie__Rule_Set_Name__c = tempRuleName;
                            modiRec.modigie__Rule_Set_Logic__c = RuleSetClass.GetRuleSetSubQuery(tempRuleId, objType);
                            if(modiQueue.contains((id)objRec.get('id'))){
                                System.debug('Queued');
                                modiRec.modigie__Status__c = 'In queue';
                            }else{
                                System.debug('Called');
                                modiRec.modigie__Status__c = 'In process';

                                String statusGetModigie = responseMap.get('status').toString();
                                statusGetModigie = statusGetModigie.substring(0, 1).toUpperCase() + statusGetModigie.substring(1, statusGetModigie.length());
                                modiRec.modigie__Get_Modigie_Job_Status__c = statusGetModigie;
                            }
                            modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                            modiRec.modigie__User_GetModigieMobile__c = UserInfo.getUserId();
                
                            modirec.modigie__Mobile__c = null;
                            modirec.modigie__Accuracy_Match_Modigie_Validated_Number__c = null;
                            modirec.modigie__Line_Activity_Modigie_Validated_Number__c = null;
                            modirec.modigie__Best_Time_to_Call_Validated_Number__c = null;
                            modirec.modigie__Day_of_Week_Detail_Modigie_Val_Number__c = null;
                            modirec.modigie__Phone_Type_Modigie_Validated_Number__c = null;
                            modirec.modigie__Phone_Type_Alternate_Number1__c = null;
                            modirec.modigie__Phone_Type_Alternate_Number2__c = null;
                            modirec.modigie__LinkedIn_Url_Get_Mobile_Number__c = null;
                            modirec.modigie__Current_Title_Get_Modigie__c = null;
                            modirec.modigie__Current_Employer_Get_Modigie__c = null;
                            modirec.modigie__Current_Country_Get_Modigie__c = null;
                            modirec.modigie__Company_Name_Matches_Records_Get_Modigie__c = null;
                            modirec.modigie__Mobile_2__c = null;
                            modirec.modigie__Mobile_3__c = null;
                            modirec.modigie__Accuracy_Match_Alternate_Number1__c = null;
                            modirec.modigie__Accuracy_Match_Alternate_Number2__c = null;
                            modirec.modigie__Line_Activity_Alternate1__c = null;
                            modirec.modigie__Line_Activity_Alternate2__c = null;
                            modirec.modigie__Day_of_Week_Detail_Alternate_Number1__c = null;
                            modirec.modigie__Day_of_Week_Detail_Alternate_Number2__c = null;
                            modirec.modigie__Best_Time_to_Call_Alternate_Number1__c = null;
                            modirec.modigie__Best_Time_to_Call_Alternate_Number2__c = null;
                            modiRec.modigie__Get_Modigie_Job_Source__c = getModigieJobSource;
                
                            modiList.add(modiRec);
                        }
                        */
                    }
                    
                    if (!modiList.isEmpty()){
                        Database.UpsertResult[] saveResults = database.upsert(modiList, false);
                        //if(flsCheck('modigie__Error_Log__c'))
                        ErrorLogClass.createErrorLog(modiList, 'modigie__Parent_Id__c', saveResults, 'Get Modigie', getModigieJobSource);
                        //error Log
                        //error doesn't Matters when creating modigie service log
                        //if(flsCheck('modigie__Modigie_Service__c'))
                        ModigieServiceClass.createModigieServiceRecord(modiList, objType, getModigieJobSource, 'Get Modigie');
                    }
                
                }else if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
                    //check which record failed and retry, for proper use case only
                    EmailServiceClass.sendResponseError('SalesEngagementBatchClass', response.getStatusCode(), response.getBody());
                }
            }else{
                System.debug('Security Warning - Modigie FLS Failed for Running User!');
            }
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('SalesEngagementBatchClass Error', e);
        }
    }

    public void finish(Database.BatchableContext bc) {
        //update ruleSet Limit with Counter
        //also delete 'in queue' modigie record of deleted Lead/Contact
        try{
            if(!isQueue){
                updateAllAtFinish();
            }
            updateCounter();
            if(isQueue){
                if(!improvedMapNextRecordToRule.isEmpty()){
                    String nextObjType = 'Lead';
                    if(objType == 'Lead'){
                        nextObjType = 'Contact';
                    }
                    SalesEngagementBatchClass modiAsync = new SalesEngagementBatchClass(improvedMapNextRecordToRule, mapRuleSets, nextObjType);
                    Database.executeBatch(modiAsync, b_size);
                }
            }
            if(apiCalledUpdateCredits){
                System.Queueable job = new CreditInfoQueableClass();
                System.enqueueJob(job);
            }
            //SFD-64
            Id currentUserId = UserInfo.getUserId();
            List<PermissionSetAssignment> isRunningUserCA = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :currentUserId AND ((PermissionSet.PermissionsCustomizeApplication = true) OR (PermissionSet.Label = 'Modigie Admin' AND PermissionSet.namespaceprefix = 'modigie')) LIMIT 2];
            if(isRunningUserCA.size() == 2 && !Test.isRunningTest()){
                BatchJobsScheluderClass.scheduleForOneMinute();
            }
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('SalesEngagementBatchClass Error', e);
        }
    }

    private class SalesEngagementBatchClassException extends Exception{}

    //Needs to be updated
    public static Boolean Check(){
        return true;
        //wif( FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') 
        //w&& FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') 
        //w&& FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Jobid__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Jobid__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Jobid__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Validation_Key__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Validation_Key__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Validation_Key__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Status__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Status__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Status__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Lead__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Lead__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Lead__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Parent_Id__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Parent_Id__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Parent_Id__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Validation_Date_Get_Mobile_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Validation_Date_Get_Mobile_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Validation_Date_Get_Mobile_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Get_Modigie_Job_Status__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Get_Modigie_Job_Status__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Get_Modigie_Job_Status__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Get_Mobile_Campaign_User__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Get_Mobile_Campaign_User__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Get_Mobile_Campaign_User__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Campaign_Id_GetMobileNumber__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Campaign_Id_GetMobileNumber__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Campaign_Id_GetMobileNumber__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Mobile__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Mobile__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Mobile__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Modigie_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Modigie_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Modigie_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Line_Activity_Modigie_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Modigie_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Modigie_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Modigie_Val_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Modigie_Val_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Modigie_Val_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Phone_Type_Modigie_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Modigie_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Modigie_Validated_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Phone_Type_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__LinkedIn_Url_Get_Mobile_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__LinkedIn_Url_Get_Mobile_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__LinkedIn_Url_Get_Mobile_Number__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Current_Title_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Current_Title_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Current_Title_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Current_Employer_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Current_Employer_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Current_Employer_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Current_Country_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Current_Country_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Current_Country_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Company_Name_Matches_Records_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Company_Name_Matches_Records_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Company_Name_Matches_Records_Get_Modigie__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Mobile_2__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Mobile_2__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Mobile_2__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Mobile_3__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Mobile_3__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Mobile_3__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Accuracy_Match_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate1__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate1__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate1__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate2__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate2__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Line_Activity_Alternate2__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number1__c' ) 
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number2__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Best_Time_to_Call_Alternate_Number2__c' )
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Rule_Set_Logic__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Logic__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Logic__c' )
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Rule_Set_Id__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Id__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Id__c' )
        //w&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Rule_Set_Name__c' ) 
        //w&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Name__c' ) 
        //w&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie__c', 'modigie__Rule_Set_Name__c' ) ) {
        //w    return true;
        //w}
        //wreturn false;
    }

    public void updateAllAtFinish(){
        try{
            ModigieStaticReferenceHelper.isSalesEngagementBatchRunning = true;
            List<sObject> allowCallAgain = new List<sObject>();
            /*
            for(Id i_temp: allListId){
                if(objType == 'Lead'){
                    Lead tempS = new Lead(Id = i_temp, modigie__Modigie_Is_Active__c = false);
                    allowCallAgain.add(tempS);
                }else if(objType == 'Contact'){
                    Contact tempS = new Contact(Id = i_temp, modigie__Modigie_Is_Active__c = false, modigie__Converted_From_Lead__c = false);
                    allowCallAgain.add(tempS);
                }
            }
            */
            if(objType == 'Lead'){
                List<Lead> tempLeadList = [SELECT Id FROM Lead WHERE Id = :allListId FOR UPDATE];
                for(Lead leadRec: tempLeadList){
                    leadRec.modigie__Modigie_Is_Active__c = false;
                    allowCallAgain.add(leadRec);
                }
            }else if(objType == 'Contact'){
                List<Contact> tempConList = [SELECT Id FROM Contact WHERE Id = :allListId FOR UPDATE];
                for(Contact conRec: tempConList){
                    conRec.modigie__Modigie_Is_Active__c = false;
                    allowCallAgain.add(conRec);
                }
            }
            if( FieldLevelSecurityCheck.canReadObject('Lead')  
            && FieldLevelSecurityCheck.canUpdateObject('Lead') 
            && FieldLevelSecurityCheck.canReadObject('Contact')  
            && FieldLevelSecurityCheck.canUpdateObject('Contact')
            && FieldLevelSecurityCheck.canReadField( 'Lead', 'modigie__Modigie_Is_Active__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'Lead', 'modigie__Modigie_Is_Active__c' ) 
            && FieldLevelSecurityCheck.canReadField( 'Contact', 'modigie__Modigie_Is_Active__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'Contact', 'modigie__Modigie_Is_Active__c' ) 
            && FieldLevelSecurityCheck.canReadField( 'Contact', 'modigie__Converted_From_Lead__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'Contact', 'modigie__Converted_From_Lead__c' ) ){
                if(!allowCallAgain.isEmpty()){
                    Database.SaveResult[] saveResults = Database.update(allowCallAgain);
                    //ErrorLogClass.createErrorLog(allowCallAgain, 'Id', saveResults, 'Get Modigie', getModigieJobSource);
                }
            }
        }catch(Exception exc){
            EmailServiceClass.sendErrorEmail('SalesEngagementBatchClass Error!', exc);
        }
    }

    public void updateCounter(){
        List<modigie__Modigie_Rule_Sets__c> updateModiRuleSets = [SELECT Id, modigie__Rule_Set_Name__c , modigie__Email_Limit_Sent__c, modigie__Limit__c, modigie__Usage__c, modigie__isLimit__c, modigie__Maintain_Queue__c, modigie__isActive__c FROM modigie__Modigie_Rule_Sets__c WHERE modigie__isActive__c = true FOR UPDATE];
        Boolean needsUpdate = false;
        for(modigie__Modigie_Rule_Sets__c tempRec: updateModiRuleSets){
            Id ruleId = tempRec.Id;
            if(mapRuleCounter.containsKey(ruleId)){
                Integer tempUsage = 0;
                if(tempRec.modigie__Usage__c != null)
                    tempUsage = Integer.valueOf(tempRec.modigie__Usage__c);
                tempRec.modigie__Usage__c = tempUsage + mapRuleCounter.get(ruleId);
                needsUpdate = true;
            }
        }
        if(needsUpdate){
            update updateModiRuleSets;
        }
        NotificationServiceClass.sendEmailRuleSetLimit(updateModiRuleSets);
    }

}