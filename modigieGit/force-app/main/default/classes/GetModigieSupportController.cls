public with sharing class GetModigieSupportController {
    
    @AuraEnabled
    public static String getUsedServicesInfo(Id recId,String objectType){
        try{

            List<modigie__Modigie_Service_Account__mdt> lstCredentials = ModigieApiUtils.getServiceAccountDetails();
            if(lstCredentials.size() > 0){
                Map<String,Boolean> dataMap = new Map<String, Boolean>{'GetModigie' => true, 'GetLinkedIn' => true, 'GetPhoneIntelligence' => true, 'VerifyEmployer' => true,'MobileStatus'=> true,'PhoneStatus'=>true,'OtherStatus'=>true};
                List<modigie__Modigie__c> modiLst = new List<modigie__Modigie__c>();
                if(objectType != 'Modigie'){
                    modiLst = [SELECT Id, modigie__Status__c, modigie__Phone_Intelligence_Status_Phone__c, modigie__Phone_Intelligence_Status_Other_Phone__c, modigie__Contact__c, modigie__Linkedin_Status__c, modigie__Validate_Employer_Status__c, modigie__Phone_Intelligence_Status__c FROM modigie__Modigie__c WHERE modigie__Parent_Id__c  = :recId WITH SECURITY_ENFORCED];
                }

                else{
                    modiLst = [SELECT Id, modigie__Status__c, modigie__Phone_Intelligence_Status_Phone__c, modigie__Phone_Intelligence_Status_Other_Phone__c, modigie__Contact__c, modigie__Linkedin_Status__c, modigie__Validate_Employer_Status__c, modigie__Phone_Intelligence_Status__c FROM modigie__Modigie__c WHERE Id  = :recId WITH SECURITY_ENFORCED];
                }
                
            

                if(modiLst.size() > 0){
                    
                    if(modiLst[0].modigie__Contact__c != null){
                        dataMap.put('isContact',true);
                    }

                    if(modiLst[0].modigie__Status__c != null && modiLst[0].modigie__Status__c != 'Not started' && modiLst[0].modigie__Status__c != 'Unavailable'){
                        dataMap.put('GetModigie', false);
                    }
                    if(modiLst[0].modigie__Linkedin_Status__c != null && modiLst[0].modigie__Linkedin_Status__c != 'Not started' && modiLst[0].modigie__Linkedin_Status__c != 'Unavailable'){
                        dataMap.put('GetLinkedIn', false);
                    }
                    if((modiLst[0].modigie__Phone_Intelligence_Status__c != null && modiLst[0].modigie__Phone_Intelligence_Status__c != 'Not started' && modiLst[0].modigie__Phone_Intelligence_Status__c != 'Unavailable') || (modiLst[0].modigie__Phone_Intelligence_Status_Phone__c != null && modiLst[0].modigie__Phone_Intelligence_Status_Phone__c != 'Not started' && modiLst[0].modigie__Phone_Intelligence_Status_Phone__c != 'Unavailable') || (modiLst[0].modigie__Phone_Intelligence_Status_Other_Phone__c != null && modiLst[0].modigie__Phone_Intelligence_Status_Other_Phone__c != 'Not started' && modiLst[0].modigie__Phone_Intelligence_Status_Other_Phone__c != 'Unavailable')){
                        dataMap.put('GetPhoneIntelligence', false);
                        if(modiLst[0].modigie__Phone_Intelligence_Status__c != null && modiLst[0].modigie__Phone_Intelligence_Status__c != 'Not started' && modiLst[0].modigie__Phone_Intelligence_Status__c != 'Unavailable'){
                            dataMap.put('MobileStatus',false);
                        }
                        if(modiLst[0].modigie__Phone_Intelligence_Status_Phone__c != null && modiLst[0].modigie__Phone_Intelligence_Status_Phone__c != 'Not started' && modiLst[0].modigie__Phone_Intelligence_Status_Phone__c != 'Unavailable'){
                            dataMap.put('PhoneStatus',false);
                        }
                        if(modiLst[0].modigie__Phone_Intelligence_Status_Other_Phone__c != null && modiLst[0].modigie__Phone_Intelligence_Status_Other_Phone__c != 'Not started' && modiLst[0].modigie__Phone_Intelligence_Status_Other_Phone__c != 'Unavailable'){
                            dataMap.put('OtherStatus',false);
                        }
                    }
                    
                    if(modiLst[0].modigie__Validate_Employer_Status__c != null && modiLst[0].modigie__Validate_Employer_Status__c != 'Not started' && modiLst[0].modigie__Validate_Employer_Status__c != 'Unavailable'){
                        dataMap.put('VerifyEmployer', false);
                    }

                    
                }
                return JSON.serialize(dataMap);
            }
            else{
                throw new GetModigieSupportControllerException('You are not an authorized user.');
            }
        }
        catch(System.QueryException e){
            throw new GetModigieSupportControllerException('You do not have permission to query lead, contact or modigie fields.');  
        }
        catch(Exception e){
            throw new GetModigieSupportControllerException(e.getMessage());  
        }
    }
    @AuraEnabled
    public static String getInformationofUser(Id recId,String calledFrom)
    {
        try{
            modigie__Modigie__c obj;
            String sobjectType = '';
            Map<String,Object> resultMap = new Map<String,Object>();

            if(calledFrom?.equalsIgnoreCase('Modigie') == true){
                obj = [SELECT id,modigie__Parent_Id__c FROM modigie__Modigie__c WHERE id = :recId WITH SECURITY_ENFORCED];
                recId = obj.modigie__Parent_Id__c;
            }
            
            
            sobjectType = recId.getSObjectType().getDescribe().getName();
            
            if(sobjectType?.equalsIgnoreCase('Contact') == true){
                obj = [SELECT Id,modigie__JOB_ID__c,modigie__Modigie_Validated_Mobile_Contact_Number__c, modigie__Linkedin_URL__c, modigie__Linkedin_Job_Id__c, modigie__Validate_Employer_Job_Id__c, modigie__Get_Phone_Intelligence_Job_Id__c,modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c,modigie__Get_Phone_Intelligence_Job_Id_Phone__c,modigie__Verified_Phone_Get_Phone_Insights__c,modigie__Lead__c,modigie__Contact__c,modigie__Phone_Name_Match__c, modigie__Line_Activity__c, modigie__Phone_Type__c, modigie__Best_Time_to_Call__c,modigie__Current_Employer__c, modigie__Current_Title__c,modigie__Current__c,modigie__Contact__r.FirstName,modigie__Contact__r.LastName,modigie__Contact__r.Email,modigie__Contact__r.modigie__Modigie_Verified_Number__c,modigie__Contact__r.modigie__linkedin_url__c,modigie__Contact__r.Account.Name, modigie__Validation_Date_Verify_Employer__c,modigie__Validation_Date_Get_LinkedIn__c,modigie__Validation_Date_Get_Mobile_Number__c, modigie__Validation_Date_Mobile__c, modigie__Validation_Date_Phone__c, modigie__Validation_Date_Other_Phone__c, modigie__Name_Get_LinkedIn__c, modigie__Name_Get_Mobile_Number__c, modigie__Name_Verify_Employer__c, modigie__Name_Get_Phone_Insights_Mobile__c, modigie__Name_Get_Phone_Insights_Phone__c, modigie__Name_Get_Phone_Insights_Other_Phone__c FROM modigie__Modigie__c WHERE modigie__Parent_Id__c = :recId WITH SECURITY_ENFORCED LIMIT 1];
            }

            else if(sobjectType?.equalsIgnoreCase('Lead') == true){
                obj = [SELECT Id,modigie__JOB_ID__c,modigie__Modigie_Validated_Mobile_Contact_Number__c, modigie__Linkedin_URL__c, modigie__Linkedin_Job_Id__c, modigie__Validate_Employer_Job_Id__c, modigie__Get_Phone_Intelligence_Job_Id__c,modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c,modigie__Get_Phone_Intelligence_Job_Id_Phone__c,modigie__Verified_Phone_Get_Phone_Insights__c,modigie__Lead__c,modigie__Contact__c,modigie__Phone_Name_Match__c, modigie__Line_Activity__c, modigie__Phone_Type__c, modigie__Best_Time_to_Call__c,modigie__Current_Employer__c, modigie__Current_Title__c,modigie__Current__c,modigie__Lead__r.FirstName,modigie__Lead__r.LastName,modigie__Lead__r.Email,modigie__Lead__r.modigie__Modigie_Verified_Number__c,modigie__Lead__r.modigie__linkedin_url__c,modigie__Lead__r.Company, modigie__Validation_Date_Verify_Employer__c,modigie__Validation_Date_Get_LinkedIn__c,modigie__Validation_Date_Get_Mobile_Number__c, modigie__Validation_Date_Mobile__c, modigie__Validation_Date_Phone__c, modigie__Validation_Date_Other_Phone__c, modigie__Name_Get_LinkedIn__c, modigie__Name_Get_Mobile_Number__c, modigie__Name_Verify_Employer__c, modigie__Name_Get_Phone_Insights_Mobile__c, modigie__Name_Get_Phone_Insights_Phone__c, modigie__Name_Get_Phone_Insights_Other_Phone__c FROM modigie__Modigie__c WHERE modigie__Parent_Id__c = :recId WITH SECURITY_ENFORCED LIMIT 1];
            }
            
            User userobj = [SELECT Id, Username, Name, CompanyName, Email FROM User where Id = :UserInfo.getUserId() WITH SECURITY_ENFORCED LIMIT 1];
                
            resultMap.put('Data',obj); 
            resultMap.put('User',userobj);
            
            return JSON.serialize(resultMap);
        }
        catch(System.QueryException e){
            throw new GetModigieSupportControllerException('You do not have permission to query lead, contact or modigie fields.');
        }
        catch(Exception e){
            throw new GetModigieSupportControllerException(e.getMessage());
        }
    }
    private class GetModigieSupportControllerException extends Exception{}
}