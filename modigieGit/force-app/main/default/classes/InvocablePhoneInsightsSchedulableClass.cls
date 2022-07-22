global with sharing class InvocablePhoneInsightsSchedulableClass implements Schedulable, Database.AllowsCallouts, Database.stateful{
    
    List<String> lstIds = new List<String>();
    Integer automationCode;
    List<SObject> scope = new List<SObject>();
    
    public InvocablePhoneInsightsSchedulableClass(List<SObject> scope, Integer automationCode) {
        this.scope = scope;
        //lstIds = listOfIds;
        this.automationCode = automationCode;
    }
    global void execute(SchedulableContext sc){
        CronTrigger ct = [SELECT PreviousFireTime  FROM CronTrigger WHERE Id = :sc.getTriggerId() WITH SECURITY_ENFORCED];
        if(!scope.isEmpty()){
            Integer b_size = 100;
            try{
                b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                if(b_size > 100 || b_size < 1){
                    b_size = 100;
                }
            }catch(Exception e){}
        	GetPhoneInsightsJobRequestBatchClass batchable = new GetPhoneInsightsJobRequestBatchClass(scope, automationCode);
       	 	Database.executeBatch(batchable,b_size);    
        }
        
        // makeCallout(JSON.serialize(lstIds));
        System.abortJob(ct.Id);
        
    } 

/*    @future(callout=true)
    private static void makeCallout(String lstIdsStr){
        
        List<String> listOfIds = (List<String>)JSON.deserialize(lstIdsStr, List<String>.class);

        List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
        tokenList = [SELECT Name, modigie__Credits_Account_Id__c,modigie__API_Key__c,modigie__Service_Account_Credentials__c,modigie__Private_Key__c FROM modigie__Modigie_Credentials__c  WITH SECURITY_ENFORCED LIMIT 1];
        if(tokenList.size() > 0)
        {            
            String creditId = tokenList[0].modigie__Credits_Account_Id__c;
            String privateKey = tokenList[0].modigie__Private_Key__c;
            String APIkey = tokenList[0].modigie__API_Key__c;
            String serviceAccountCred = tokenList[0].modigie__Service_Account_Credentials__c;
            
            List<modigie__Error_Log__c> lstErrorLog = new List<modigie__Error_Log__c>();
            Map<String,Object> mapInputNumbers = new Map<String,Object>();
            Set<String> emailMessages = new Set<String>();
            String campaignId;
            
            List<modigie__Process_Builder_Switch__c> lstSwitch = [SELECT Id, modigie__Get_Phone_Insights_Phone_Number_Selected__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
            
            if(lstSwitch.size() > 0){
                mapInputNumbers = (Map<String,Object>)JSON.deserializeUntyped(lstSwitch[0].modigie__Get_Phone_Insights_Phone_Number_Selected__c);
            }
            List<SObject> scope = new List<SObject>();
            List<Contact> conLst = [SELECT Id, FirstName, LastName, Email, AccountId, modigie__linkedin_url__c,MobilePhone, Phone, OtherPhone FROM Contact WHERE Id IN :listOfIds WITH SECURITY_ENFORCED];
            List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__linkedin_url__c,MobilePhone, Phone FROM Lead WHERE Id IN :listOfIds WITH SECURITY_ENFORCED];
            scope.addAll(conLst);
            scope.addAll(ldLst);
            
            
            Set<Id> setOfKeysIds = new Set<Id>();
            for(SObject sco : scope){
                setOfKeysIds.add((Id)sco.get('Id')); 
            }
            
            Map<Id,Contact> conMap = new Map<Id,Contact>([SELECT id,Account.Name FROM Contact WHERE Id in :setOfKeysIds WITH SECURITY_ENFORCED]);
            
            Map<ID, Lead> leadMap = new Map<ID, Lead>();
            
            Map<String,Object> outerMap = new Map<String,Object>();
            
            List<modigie__Modigie__c> lstModigie = [SELECT Id, modigie__Verified_Phone_Get_Phone_Insights__c, modigie__Contact__c, modigie__Lead__c, modigie__Validation_Key__c, modigie__Parent_Id__c, modigie__Get_Phone_Intelligence_Job_Id__c, modigie__Get_Phone_Intelligence_Job_Status__c, modigie__Phone_Intelligence_Status__c, modigie__Mobile_2__c, modigie__Mobile_3__c, modigie__Get_Phone_Intelligence_Job_Id_Phone__c, modigie__Get_Phone_Intelligence_Job_Id_Val_Number__c, modigie__Get_Phone_Intelligence_Job_Id_Alternate1__c, modigie__Get_Phone_Intelligence_Job_Id_Alternate2__c, modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c, modigie__Get_Phone_Intelligence_Job_Status_Phone__c, modigie__Get_Phone_Intelligence_Job_Status_ValNum__c, modigie__Get_Phone_Intelligence_Job_Status_Alt1__c, modigie__Get_Phone_Intelligence_Job_Status_Alt2__c, modigie__Get_Phone_Intelligence_Job_Status_OPhone__c, modigie__Phone_Intelligence_Status_Phone__c, modigie__Phone_Intelligence_Status_Modigie_Number__c, modigie__Phone_Intelligence_Status_Alt_Number1__c, modigie__Phone_Intelligence_Status_Alt_Number2__c, modigie__Phone_Intelligence_Status_Other_Phone__c, modigie__Verified_Phone_Get_Phone_Insights_Phone__c, modigie__Verified_Phone_Get_Phone_Insights_ValNum__c, modigie__Verified_Phone_Get_Phone_Insights_Alt1__c, modigie__Verified_Phone_Get_Phone_Insights_Alt2__c, modigie__Verified_Phone_Get_Phone_Insights_OPhone__c, modigie__Validation_Date_Mobile__c, modigie__Validation_Date_Phone__c, modigie__Validation_Date_Other_Phone__c, modigie__Validation_Date_Modigie_Val_Phone_Number__c, modigie__Validation_Date_Alternate_Number1__c, modigie__Validation_Date_Alternate_Number2__c, modigie__Best_Time_to_Call_Phone_Other_Phone__c, modigie__Best_Time_to_Call_Alternate_Number2__c, modigie__Best_Time_to_Call_Alternate_Number1__c, modigie__Best_Time_to_Call_Validated_Number__c, modigie__Best_Time_to_Call_Phone__c, modigie__Phone_Type_Other_Phone__c, modigie__Phone_Type_Alternate_Number2__c, modigie__Phone_Type_Alternate_Number1__c, modigie__Phone_Type_Modigie_Validated_Number__c, modigie__Phone_Type_Phone__c, modigie__Line_Activity_Other_Phone__c, modigie__Line_Activity_Alternate2__c, modigie__Line_Activity_Alternate1__c, modigie__Line_Activity_Modigie_Validated_Number__c, modigie__Line_Activity_Phone__c, modigie__Day_of_Week_Detail_Other_Phone__c, modigie__Day_of_Week_Detail_Alternate_Number2__c, modigie__Day_of_Week_Detail_Alternate_Number1__c, modigie__Day_of_Week_Detail_Modigie_Val_Number__c, modigie__Day_of_Week_Detail_Phone__c, modigie__Accuracy_Match_Other_Phone__c, modigie__Accuracy_Match_Alternate_Number2__c, modigie__Accuracy_Match_Alternate_Number1__c, modigie__Accuracy_Match_Modigie_Validated_Number__c, modigie__Accuracy_Match_Phone__c, modigie__Best_Time_to_Call__c, modigie__Day_of_Week_Detail__c, modigie__Phone_Type__c, modigie__Line_Activity__c, modigie__Phone_Name_Match__c FROM modigie__Modigie__c WHERE modigie__Lead__c IN :setOfKeysIds OR modigie__Contact__c IN :setOfKeysIds WITH SECURITY_ENFORCED];
            
            Map<String,modigie__Modigie__c> mapModigie = new Map<String,modigie__Modigie__c>();
            
            for(modigie__Modigie__c modigie : lstModigie){
                if(modigie.modigie__Contact__c != null){
                    mapModigie.put(modigie.modigie__Contact__c,modigie);
                }
                else if(modigie.modigie__Lead__c != null){
                    mapModigie.put(modigie.modigie__Lead__c,modigie);
                }        
            }
            
            
            outerMap.put('creditsId', creditId);

            Map<String,String> jobCustomParameter = new Map<String,String>();
            jobCustomParameter.put('name','Called from automation');
            jobCustomParameter.put('value','New Lead creation get phone insights');
            outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
    
            List <Map<String,Object>> lstCon = new List<Map<String,Object>>();
            for(SObject sObj : scope)
            {
                
                String sobjectType = sObj.getSObjectType().getDescribe().getName();
                String finalInputNumbers = '';
                String numberTypeSended = '';
                
                modigie__Modigie__c modigieRecToUpsert = mapModigie.get((String)sObj.get('Id'));
                
                if(modigieRecToUpsert == null){
                    modigieRecToUpsert = new modigie__Modigie__c();
                    modigieRecToUpsert.modigie__Parent_Id__c = (String)sObj.get('Id');
                }
                
                if(sobjectType?.equalsIgnoreCase('Contact') == true){
                    finalInputNumbers = mapInputNumbers.get('selectedFieldsContact').toString();
                    modigieRecToUpsert.modigie__Contact__c = (String)sObj.get('Id');
                }
                
                else if(sobjectType?.equalsIgnoreCase('Lead') == true){
                    finalInputNumbers = mapInputNumbers.get('selectedFieldsLead').toString();
                    modigieRecToUpsert.modigie__Lead__c = (String)sObj.get('Id');
                }
                
                Map<String,Object> sinCon = new Map <String,Object>();
                Boolean haveAtleastOnePhone = false;
                if(sObj.get('FirstName') != null){
                    sinCon.put('firstName',sObj.get('FirstName'));      
                }
                
                if(sObj.get('LastName') != null){
                    sinCon.put('lastName',sObj.get('LastName'));
                }
                
                
                if(sobjectType?.equalsIgnoreCase('Contact') == true){
                    if(sObj.get('AccountId') != null){
                        Contact con = conMap.get((Id)sObj.get('Id'));
                        //String accId = sObj.get('AccountId').toString();
                        //List<Account> acc = [SELECT Name FROM Account WHERE Id = :accId WITH SECURITY_ENFORCED LIMIT 1]; 
                        sinCon.put('company', con.Account.Name);
                    }
                }
                
                else if(sobjectType?.equalsIgnoreCase('Lead') == true){
                    if(sObj.get('Company') != null){
                        sinCon.put('company',sObj.get('Company'));
                    }
                }
                if(sObj.get('modigie__linkedin_url__c') != null){
                    sinCon.put('linkedInUrl',sObj.get('modigie__linkedin_url__c'));
                }
                
                List <String> lstMobileNumber = new List<String>();
                
                if(finalInputNumbers.containsIgnoreCase('Mobile,')){
                    if(sObj.get('MobilePhone') != null){
                        
                        String mobileNumber = (String)sObj.get('MobilePhone');
                        
                        if(!mobileNumber.startsWith('+')){
                            if(mobileNumber.startsWith('1'))
                            {
                                mobileNumber = '+' + mobileNumber;
                            }
                            else{
                                mobileNumber = '+1' + mobileNumber;
                            }
                            
                        }
                        
                        modigieRecToUpsert.modigie__Verified_Phone_Get_Phone_Insights__c = mobileNumber;
                        modigieRecToUpsert.modigie__Formatted_Mobile_Number__c = FormatPhone((String)sObj.get('MobilePhone'));
                        
                        modigieRecToUpsert.modigie__Phone_Intelligence_Status__c = 'Batch Process';
                        haveAtleastOnePhone=true;
                        lstMobileNumber.add(mobileNumber);
                        numberTypeSended += 'Mobile,';
                    }
                }
                
                if(finalInputNumbers.containsIgnoreCase('Phone,')){
                    if(sObj.get('Phone') != null){
                        
                        String mobileNumber = (String)sObj.get('Phone');
                        
                        if(!mobileNumber.startsWith('+')){
                            if(mobileNumber.startsWith('1'))
                            {
                                mobileNumber = '+' + mobileNumber;
                            }
                            else{
                                mobileNumber = '+1' + mobileNumber;
                            }
                            
                        }
                        
                        modigieRecToUpsert.modigie__Verified_Phone_Get_Phone_Insights_Phone__c = mobileNumber;
                        modigieRecToUpsert.modigie__Formatted_Phone_Number__c = FormatPhone((String)sObj.get('Phone'));
                        
                        modigieRecToUpsert.modigie__Phone_Intelligence_Status_Phone__c = 'Batch Process';
                        lstMobileNumber.add(mobileNumber);
                        //sinCon.put('mobilePhone',lstSobj[0].get('MobilePhone')); 
                        haveAtleastOnePhone=true;
                        numberTypeSended += 'Phone,';
                    }
                }
                
                if(finalInputNumbers.containsIgnoreCase('Other,')){
                    if(sObj.get('OtherPhone') != null){
                        
                        String mobileNumber = (String)sObj.get('OtherPhone');
                        
                        if(!mobileNumber.startsWith('+')){
                            if(mobileNumber.startsWith('1'))
                            {
                                mobileNumber = '+' + mobileNumber;
                            }
                            else{
                                mobileNumber = '+1' + mobileNumber;
                            }
                            
                        }
                        
                        
                        modigieRecToUpsert.modigie__Verified_Phone_Get_Phone_Insights_OPhone__c = mobileNumber;
                        modigieRecToUpsert.modigie__Formatted_Other_Phone_Number__c = FormatPhone((String)sObj.get('OtherPhone'));
                        
                        
                        modigieRecToUpsert.modigie__Phone_Intelligence_Status_Other_Phone__c = 'Batch Process';
                        
                        
                        lstMobileNumber.add(mobileNumber);
                        //sinCon.put('mobilePhone',lstSobj[0].get('MobilePhone')); 
                        haveAtleastOnePhone=true;
                        numberTypeSended += 'Other,';

                        
                    }
                }
                
                
                
                if(lstMobileNumber.size() > 0){
                    sinCon.put('mobilePhones',lstMobileNumber);
                }
                
                if(sObj.get('Email') != null){
                    
                    sinCon.put('companyEmail', sObj.get('Email'));
                }
                
                
                Map<String,String> customParaMap = new Map<String,String>();
                
                customParaMap.put('name', 'recordIdAndOrgId');
                customParaMap.put('value', sObj.get('Id') + UserInfo.getOrganizationId());
                
                Map<String,String> customParaMap2 = new Map<String,String>();
                
                Integer requestId = Math.round((Math.random() * (9000) + 1000));
                
                customParaMap2.put('name', 'uniqueId');
                
                customParaMap2.put('value', requestId+'');
                
                List<Map<String,String>> lstMap = new List<Map<String,String>>();
                
                lstMap.add(customParaMap);
                lstMap.add(customParaMap2);
                lstMap.add(new Map<String,String>{'name'=>'lstNumbers','value'=>numberTypeSended});
                sinCon.put('customParameters',lstMap);
                if(haveAtleastOnePhone){
                    lstCon.add(sinCon);
                    if(modigieRecToUpsert.get('Id') == null){
                        lstModigie.add(modigieRecToUpsert);
                    }
                    
                }
                
            }
            
            outerMap.put('contacts',lstCon);
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            
            String accessToken = 'Bearer ' + jwtapex.get_access_token(serviceAccountCred,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',privateKey);
            //String accessToken = 'Bearer ' + jwtapex.get_access_token(serviceAccountCred,'https://modigie-engage-backend-kyaxv4ttua-uc.a.run.app',privateKey);
            request.setHeader('Content-Type', ' application/json');
            request.setHeader('Authorization', accessToken);
            request.setHeader('x-api-key', APIkey); 
            request.setEndpoint('https://modigie-engage-gateway-bqqdnyh5lq-uc.a.run.app/api/v1/phoneIntelJobs');  //Production Environment Endpoints
            //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/phoneIntelJobs?key=' + APIkey); //Staging Environment Endpoints
            
            request.setBody(JSON.serialize(outerMap));
            
            request.setTimeout(60000);
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 202){
                String jsonResponse = response.getBody();
                Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                
                String jobid = responseMap.get('id').toString();
                
                
                       
                       
                       for(modigie__Modigie__c modigie : lstModigie){
                           String statusGetModigie = responseMap.get('status').toString();
                           statusGetModigie = statusGetModigie.substring(0, 1).toUpperCase() + statusGetModigie.substring(1, statusGetModigie.length());
                           
                           if(modigie.modigie__Phone_Intelligence_Status__c?.equalsIgnoreCase('Batch Process') == true){
                               
                               modigie.modigie__Phone_Name_Match__c = '';
                               modigie.modigie__Line_Activity__c = '';
                               modigie.modigie__Phone_Type__c='';
                               modigie.modigie__Best_Time_to_Call__c='';
                               modigie.modigie__Day_of_Week_Detail__c='';
                               modigie.modigie__Validation_Date_Mobile__c = System.now();
                               modigie.modigie__Get_Phone_Intelligence_Job_Id__c	 = jobid;    
                               modigie.modigie__Get_Phone_Intelligence_Job_Status__c = statusGetModigie;
                               modigie.modigie__Phone_Intelligence_Status__c = 'In process'; 
                               
                           }
                           
                           if(modigie.modigie__Phone_Intelligence_Status_Phone__c?.equalsIgnoreCase('Batch Process') == true){
                               modigie.modigie__Accuracy_Match_Phone__c='';
                               modigie.modigie__Line_Activity_Phone__c='';
                               modigie.modigie__Phone_Type_Phone__c='';
                               modigie.modigie__Best_Time_to_Call_Phone__c='';
                               modigie.modigie__Day_of_Week_Detail_Phone__c='';
                               modigie.modigie__Validation_Date_Phone__c = System.now();
                               modigie.modigie__Get_Phone_Intelligence_Job_Id_Phone__c	 = jobid;    
                               modigie.modigie__Get_Phone_Intelligence_Job_Status_Phone__c = statusGetModigie;
                               modigie.modigie__Phone_Intelligence_Status_Phone__c = 'In process';
                               
                           }
                           
                           if(modigie.modigie__Phone_Intelligence_Status_Other_Phone__c?.equalsIgnoreCase('Batch Process') == true){
                               modigie.modigie__Line_Activity_Other_Phone__c='';
                               modigie.modigie__Accuracy_Match_Other_Phone__c = '';
                               modigie.modigie__Phone_Type_Other_Phone__c='';
                               modigie.modigie__Best_Time_to_Call_Phone_Other_Phone__c='';
                               modigie.modigie__Day_of_Week_Detail_Other_Phone__c='';
                               modigie.modigie__Validation_Date_Other_Phone__c = System.now();
                               modigie.modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c	 = jobid;    
                               modigie.modigie__Get_Phone_Intelligence_Job_Status_OPhone__c = statusGetModigie;
                               modigie.modigie__Phone_Intelligence_Status_Other_Phone__c = 'In process';
                               
                           }
                           
                           //modigie.modigie__Get_Phone_Insight_Campaign_User__c = UserInfo.getUserId();
                           //modigie.modigie__Campaign_Id_GetPhoneInsight__c = campaignId;
                           modigie.modigie__User_PhoneInsights__c = UserInfo.getUserId();
                           modigie.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                           
                       }
                       if(lstModigie.size() > 0){
                        if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Name_Match__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Line_Activity__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Type__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_to_Call__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Validation_Date_Mobile__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Id__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Accuracy_Match_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Line_Activity_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Type__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_to_Call__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Validation_Date_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Id_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Line_Activity_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Accuracy_Match_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Type_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_to_Call_Phone_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Validation_Date_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__User_PhoneInsights__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Validation_Key__c')&&
                       FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Name_Match__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Line_Activity__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Type__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_to_Call__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Validation_Date_Mobile__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Id__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Accuracy_Match_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Line_Activity_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Type__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_to_Call__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Validation_Date_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Id_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Line_Activity_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Accuracy_Match_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Type_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_to_Call_Phone_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Validation_Date_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status_Other_Phone__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__User_PhoneInsights__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Validation_Key__c')){   
                       
                        upsert lstModigie;
                   }
                       }
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Limits_No_Limits_Selection__c, modigie__Modigie_Phone_Insights_Invocable_Limit__c, modigie__Modigie_Phone_Insights_Invocable_Usage__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                if(pbs.size() > 0){
                    if(pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('Limits') == true){
                        pbs[0].modigie__Modigie_Phone_Insights_Invocable_Usage__c += lstCon.size();
                        
                        if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
                           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Modigie_Phone_Insights_Invocable_Usage__c')&&
                           FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
                           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Modigie_Phone_Insights_Invocable_Usage__c')){
                               
                               update pbs;
                           }
                        
                    }
                }
                
            }
            else{
                Map<String, String> securityMap = new Map<String, String>();
                securityMap.put('modigie__Description__c', 'modigie__Error_Log__c');
                securityMap.put('modigie__Error_Code__c', 'modigie__Error_Log__c');
                securityMap.put('modigie__Modigie_Service__c', 'modigie__Error_Log__c');
                securityMap.put('modigie__Validation_Key__c', 'modigie__Error_Log__c');
                
                Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
                
                for(modigie__Modigie__c modigie : lstModigie){
                    modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
                    String jsonResponse = response.getBody();
                    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                    modigieErrorLog.modigie__Description__c = (String)responseMap.get('message');
                    modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
                    if(campaignId != null){
                        modigieErrorLog.modigie__Modigie_Service__c = 'Get Phone Insights';
                    }
                    else{
                        modigieErrorLog.modigie__Modigie_Service__c = 'Phone Insights Data Maintenance';
                    }
                    modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    emailMessages.add((String)responseMap.get('message'));
                    if(check){
                        lstErrorLog.add(modigieErrorLog);
                    }
                }
                if(check){
                    if(lstErrorLog.size() > 0)
                    if(FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c')&&
                    FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c')&&
                    FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Description__c')&&
                    FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Description__c')&&
                    FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Error_Code__c')&&
                    FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Error_Code__c')&&
                    FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Modigie_Service__c')&&
                    FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Modigie_Service__c')&&
                    FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Validation_Key__c')&&
                    FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Validation_Key__c')){
                        insert lstErrorLog;
                    }
                }
            }
            
            System.Queueable job = new CreditInfoQueableClass();
            System.enqueueJob(job);
            
            if(emailMessages.size() > 0){
                EmailServiceClass.sendEmailForCampaign(emailMessages);
            }
        }
    
       /* List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Invocable Phone Insights Job%'];
    	List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd]);
     	for(CronTrigger ct : lstCt){
        	System.abortJob((String)ct.Id);
    	} 
    } 
    private static String FormatPhone(String Phone) {
        string nondigits = '[^0-9]';
        string PhoneDigits;
        
        // remove all non numeric
        PhoneDigits = Phone;
        
        // 10 digit: reformat with dashes
        if (PhoneDigits.length() == 10) 
            return '(' + PhoneDigits.substring(0,3) + ') ' +
            PhoneDigits.substring(3,6) + '-' +
            PhoneDigits.substring(6,10);
        // 11 digit: if starts with 1, format as 10 digit 
        if (PhoneDigits.length() == 11) {
            if (PhoneDigits.substring(0,1)?.equalsIgnoreCase('1') == true) {
                return '(' +PhoneDigits.substring(1,4) + ') ' +
                    PhoneDigits.substring(4,7) + '-' +
                    PhoneDigits.substring(7,11);
            }
        }
        
        // if it isn't a 10 or 11 digit number, return the original because
        // it may contain an extension or special information
        return( Phone );
    }*/
}