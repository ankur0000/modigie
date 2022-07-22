public with sharing class GetPhoneInsightsCampaignButton {
    public GetPhoneInsightsCampaignButton(){

    }

    @AuraEnabled
    public static String getMobileInformation(Id recid){ 
        try{
            List<modigie__Modigie_Service_Account__mdt> lstCredentials = ModigieApiUtils.getServiceAccountDetails();
        
            if(lstCredentials.size() > 0){
                Map<String,Object> result = new Map<String,Object>{'MobileCon' => true, 'PhoneCon' => true, 'OtherPhone' => true, 'ModigieValNumberCon' => true,'Alternate1Con' => true,'Alternate2Con'=>true,'MobileLead' => true, 'PhoneLead' => true, 'ModigieValNumberLead' => true,'Alternate1Lead' => true,'Alternate2Lead'=>true};

                List<sObject> conLst = [SELECT Id, MobilePhone, Phone, OtherPhone, modigie__Modigie_Verified_Number__c FROM Contact WHERE Id IN (SELECT ContactId FROM CampaignMember WHERE CampaignId = :recid AND ContactId !=null) WITH SECURITY_ENFORCED];

                List<sObject> ldLst = [SELECT Id, MobilePhone, Phone, modigie__Modigie_Verified_Number__c FROM Lead WHERE Id IN (SELECT LeadId FROM CampaignMember WHERE CampaignId = :recid AND LeadId !=null) WITH SECURITY_ENFORCED];

                List<sObject> lstSobj = new List<sObject>();
                lstSobj.addAll(conLst);
                lstSobj.addAll(ldLst);


                List<modigie__Modigie__c> lstModigie = [SELECT id,modigie__Contact__c,modigie__Lead__c,modigie__Mobile_2__c,modigie__Mobile_3__c FROM modigie__Modigie__c WHERE modigie__Lead__c IN :lstSobj OR modigie__Contact__c IN :lstSobj WITH SECURITY_ENFORCED];


                Map<String,modigie__Modigie__c> mapModigie = new Map<String,modigie__Modigie__c>();

                for(modigie__Modigie__c modigie : lstModigie){
                    if(modigie.modigie__Contact__c != null){
                        mapModigie.put(modigie.modigie__Contact__c,modigie);
                    }
                    else if(modigie.modigie__Lead__c != null){
                        mapModigie.put(modigie.modigie__Lead__c,modigie);
                    }        
                }
                
                for(SObject sObj : lstSobj){
                    ID recordId = (ID)sObj.get('Id');
                    String sobjectType = recordId.getSObjectType().getDescribe().getName();

                    String objectSuffix = '';

                    if(sobjectType?.equalsIgnoreCase('Contact') == true){
                        objectSuffix = 'Con';
                    }
                    else if(sobjectType?.equalsIgnoreCase('Lead') == true){
                        objectSuffix = 'Lead';
                    }

                    if(sObj.get('MobilePhone') != null){
                        result.put('Mobile' + objectSuffix, false); 
                    }
                    if(sObj.get('Phone') != null){
                        result.put('Phone' + objectSuffix, false);
                    }
                    if(sobjectType?.equalsIgnoreCase('Contact') == true){
                        if(sObj.get('OtherPhone') != null){
                            result.put('OtherPhone',false);
                        }
                    }
                    if(sObj.get('modigie__Modigie_Verified_Number__c') != null){
                        result.put('ModigieValNumber' + objectSuffix, false);
                    }
                    if(mapModigie.get((String)sObj.get('Id')) != null){
                        modigie__Modigie__c modigie = mapModigie.get((String)sObj.get('Id'));
                        if(modigie.modigie__Mobile_2__c != null){
                            result.put('Alternate1' + objectSuffix, false);
                        }
                        if(modigie.modigie__Mobile_3__c != null){
                            result.put('Alternate2' + objectSuffix, false);
                        }   
                    }
                }
                return JSON.serialize(result);
            }
            else{
                throw new GetPhoneInsightsCampaignButtonException('You are not an authorized user.');
            }
        }
        catch(LimitException e)
        {
            throw new GetPhoneInsightsCampaignButtonException('You cannot process more than 50,000 records.');
           
        }
        catch(Exception e)
        {
            throw new GetPhoneInsightsCampaignButtonException(e.getMessage());
        } 
    }

    @AuraEnabled
    public static List<Id> requestPhoneIntelJobs(Id recid,String inputNumbers, String syncNewOrAll){
        try{

        
        Map<String, String> securityMap = new Map<String, String>();
        Map<String, String> securityCampaignMemberMap = new Map<String, String>();
        

            securityCampaignMemberMap.put('CampaignId', 'CampaignMember');
            securityCampaignMemberMap.put('ContactId', 'CampaignMember');
            securityCampaignMemberMap.put('LeadId', 'CampaignMember');
            
            securityMap.put('AccountId', 'Contact');
            securityMap.put('FirstName', 'Contact');
            securityMap.put('LastName', 'Contact');
            securityMap.put('Email', 'Contact');
            securityMap.put('MobilePhone', 'Contact');
            securityMap.put('modigie__linkedin_url__c', 'Contact');
            securityMap.put('Phone', 'Contact');
            securityMap.put('OtherPhone', 'Contact');
            securityMap.put('Name', 'Account');
            securityMap.put('FirstName', 'Lead');
            securityMap.put('LastName', 'Lead');
            securityMap.put('Email', 'Lead');
            securityMap.put('Company', 'Lead');
            securityMap.put('MobilePhone', 'Lead');
            securityMap.put('modigie__linkedin_url__c', 'Lead');
            securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');

            Boolean checkMember = FieldLevelSecurityCheck.checkSecurityForRead(securityCampaignMemberMap);
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            if(check && checkMember){
                Map<String,Object> mapInputNumbers = (Map<String,Object>)JSON.deserializeUntyped(inputNumbers);
        
                Map<String,Object> result = new Map<String,Object>{'isContact'=>false,'Mobile' => true, 'Phone' => true, 'OtherPhone' => true, 'ModigieValNumber' => true,'Alternate1' => true,'Alternate2'=>true,'MobileNumber'=>'','PhoneNumber'=>'','OtherNumber'=>'','ModigieNumber'=>'','AlternateNumber1'=>'','AlternateNumber2'=>''};
        
                
                String queryForCon = 'SELECT Id, FirstName, LastName, Email, AccountId, modigie__linkedin_url__c,MobilePhone, Phone, OtherPhone FROM Contact WHERE Id IN (SELECT ContactId FROM CampaignMember WHERE CampaignId = :recid AND ContactId !=null) AND (';
                String queryForLead = 'SELECT Id, FirstName, LastName, Email, Company, modigie__linkedin_url__c,MobilePhone, Phone FROM Lead WHERE Id IN (SELECT LeadId FROM CampaignMember WHERE CampaignId = :recid AND LeadId !=null) AND (';
        
                String whereClauseContact = '', whereClauseLead='';
                
                
                if(mapInputNumbers.get('selectedFieldsContact').toString().containsIgnoreCase('Mobile')){
                    queryForCon += ' MobilePhone != null OR';
                }
        
                if(mapInputNumbers.get('selectedFieldsLead').toString().containsIgnoreCase('Mobile')){
                    queryForLead += ' MobilePhone != null OR';
                }
        
        
                if(mapInputNumbers.get('selectedFieldsContact').toString().containsIgnoreCase('Phone')){
                    queryForCon += ' Phone != null OR';
                }
        
                if(mapInputNumbers.get('selectedFieldsLead').toString().containsIgnoreCase('Phone')){
                    queryForLead += ' Phone != null OR';
                }
        
                if(mapInputNumbers.get('selectedFieldsContact').toString().containsIgnoreCase('Other')){
                    queryForCon += ' OtherPhone != null OR';
                }
        
                
               
                List<sObject> lstSobj = new List<sObject>();
        
                if(queryForCon.lastIndexOf('OR') != -1){
                    queryForCon = queryForCon.substring(0,queryForCon.lastIndexOf('OR'));
                    queryForCon += ')';
                    queryForCon += ' WITH SECURITY_ENFORCED';
                    List<sObject> conLst = Database.query(queryForCon);
                    lstSobj.addAll(conLst);
                }
        
                if(queryForLead.lastIndexOf('OR') != -1){
                    queryForLead = queryForLead.substring(0,queryForLead.lastIndexOf('OR'));
                    queryForLead += ')';
                    queryForLead += ' WITH SECURITY_ENFORCED';
                    List<SObject> ldLst = Database.query(queryForLead);
                    lstSobj.addAll(ldLst);
                }
                
        
                List<modigie__Modigie__c> lstModigie = [SELECT id,modigie__Contact__c,modigie__Lead__c,modigie__Mobile_2__c,modigie__Mobile_3__c FROM modigie__Modigie__c WHERE modigie__Lead__c IN :lstSobj OR modigie__Contact__c IN :lstSobj WITH SECURITY_ENFORCED];
        
        
                Map<String,modigie__Modigie__c> mapModigie = new Map<String,modigie__Modigie__c>();
        
                for(modigie__Modigie__c modigie : lstModigie){
                    if(modigie.modigie__Contact__c != null){
                        mapModigie.put(modigie.modigie__Contact__c,modigie);
                    }
                    else if(modigie.modigie__Lead__c != null){
                        mapModigie.put(modigie.modigie__Lead__c,modigie);
                    }        
                }
        
        
                List<Id> lstBatchJobsIds = new List<Id>();

                List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                if(lstPbs.isEmpty()){
                    throw new GetPhoneInsightsCampaignButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
                }
                else if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null){
                    throw new GetPhoneInsightsCampaignButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
                }
    
                if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c){

                String userId = UserInfo.getUserId();

                List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieUsage = [SELECT modigie__User_Id__c, modigie__Number_of_modigie_callouts_in_a_day__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WHERE modigie__User_Id__c = :userId WITH SECURITY_ENFORCED LIMIT 1];
                
                Integer dailyCallout = 0;
    
                if(modigieUsage.size() > 0){
                    dailyCallout = (Integer)modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c;
                }
    
                Map<Id,Integer> userToLimitsMap = LimitsMapClass.getProfileUserLimitsData();
    
                if(userToLimitsMap.containsKey(userId)){
                    if(userToLimitsMap.get(userId) < (dailyCallout + lstSobj.size())){
                        throw new GetPhoneInsightsCampaignButtonException('You do not have enough daily limit to call modigie services.');
                    }
                }
                else{
                    //throw new GetPhoneInsightsCampaignButtonException('You are not assigned limits for modigie services, please contact your system administrator.');
                }
            }
                
                if(lstSobj.size() > 0){
                    Integer b_size = 100;
                    try{
                        b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                        if(b_size > 100 || b_size < 1){
                            b_size = 100;
                        }
                    }catch(Exception e){}
                    GetPhoneInsightsJobRequestBatchClass b1 = new GetPhoneInsightsJobRequestBatchClass(lstSobj,inputNumbers,recid,syncNewOrAll);
                    Id jobId =Database.executeBatch(b1,b_size); 
            
                    lstBatchJobsIds.add(jobId);
                }

                else{
                    throw new GetPhoneInsightsCampaignButtonException('No lead/contact found having selected phone numbers.');
                }
        
                return lstBatchJobsIds;
            } 
            else {
                throw new GetPhoneInsightsCampaignButtonException('User does not have the required object edit permissions.');
            }
        }
        catch(ServerErrorException e){
            throw new ServerErrorException(e.getMessage());
        }
        catch(Exception e)
        {
            Map <String,Object> errorMap = new Map<String,Object>();
            errorMap.put('DisplayMessage', e.getMessage());
            throw new GetPhoneInsightsCampaignButtonException(JSON.serialize(errorMap));
        } 
    }
    private class GetPhoneInsightsCampaignButtonException extends Exception{}
}