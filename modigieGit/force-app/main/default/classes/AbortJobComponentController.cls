public with sharing class AbortJobComponentController {
    /*
    @Depricated
    public static String getInProcessJobInformation(Id recId){
        Map<String,Boolean> dataMap = new Map<String, Boolean>{'GetModigie' => true, 'GetLinkedIn' => true, 'GetPhoneIntelligence' => true, 'VerifyEmployer' => true};
        List<modigie__Modigie__c> modiLst = [SELECT Id, modigie__Status__c, modigie__Linkedin_Status__c, modigie__Validate_Employer_Status__c, modigie__Phone_Intelligence_Status__c FROM modigie__Modigie__c WHERE modigie__Parent_Id__c  = :recId WITH SECURITY_ENFORCED];
        
        if(modiLst.size() > 0){
            
            if(modiLst[0].modigie__Status__c == 'In process'){
                dataMap.put('GetModigie', false);
            }
            if(modiLst[0].modigie__Linkedin_Status__c == 'In process'){
                dataMap.put('GetLinkedIn', false);
            }
            if(modiLst[0].modigie__Phone_Intelligence_Status__c == 'In process'){
                dataMap.put('GetPhoneIntelligence', false);
            }
            if(modiLst[0].modigie__Validate_Employer_Status__c == 'In process'){
                dataMap.put('VerifyEmployer', false);
            }
        }

        return JSON.serialize(dataMap);
    }

    @AuraEnabled
    public static String abortJob(Id recId,String service){
        try{
            List<modigie__Modigie__c> modiLst = [SELECT Id, modigie__Validation_Key__c, modigie__Linkedin_Status__c, modigie__Get_LinkedIn_Job_Status__c, modigie__Linkedin_Job_Id__c, modigie__Validation_Date_Get_LinkedIn__c, modigie__Status__c, modigie__JOB_ID__c, modigie__Get_Modigie_Job_Status__c, modigie__Validation_Date_Get_Mobile_Number__c, modigie__Validate_Employer_Status__c, modigie__Validate_Employer_Job_Id__c, modigie__Validate_Employer_Job_Status__c, modigie__Validation_Date_Verify_Employer__c, modigie__Phone_Intelligence_Status__c, modigie__Get_Phone_Intelligence_Job_Id__c, modigie__Get_Phone_Intelligence_Job_Status__c, modigie__Validation_Date_Mobile__c  FROM modigie__Modigie__c WHERE modigie__Parent_Id__c  = :recId WITH SECURITY_ENFORCED];
            String message = '';
            if(service == 'GetLinkedIn'){
                message = 'Get LinkedIn';
                modiLst[0].modigie__Linkedin_Status__c = 'Not started';
                modiLst[0].modigie__Get_LinkedIn_Job_Status__c = modiLst[0].modigie__Linkedin_Job_Id__c = null;
                modiLst[0].modigie__Validation_Date_Get_LinkedIn__c = null;
            }

            else if(service == 'GetModigieMobile'){
                message = 'Get mobile number';
                modiLst[0].modigie__Status__c = 'Not started';
                modiLst[0].modigie__Jobid__c = modiLst[0].modigie__Get_Modigie_Job_Status__c = null;
                modiLst[0].modigie__Validation_Date_Get_Mobile_Number__c = null;
            }

            else if(service == 'VerifyEmployer'){
                message = 'Verify employer';
                modiLst[0].modigie__Validate_Employer_Status__c = 'Not started';
                modiLst[0].modigie__Validate_Employer_Job_Id__c = modiLst[0].modigie__Validate_Employer_Job_Status__c = null;
                modiLst[0].modigie__Validation_Date_Verify_Employer__c = null;
            }
            else if(service == 'GetPhoneIntelligence'){
                message = 'Get phone insights';
                modiLst[0].modigie__Phone_Intelligence_Status__c = 'Not started';
                modiLst[0].modigie__Get_Phone_Intelligence_Job_Id__c = modiLst[0].modigie__Get_Phone_Intelligence_Job_Status__c = null;
                modiLst[0].modigie__Validation_Date_Mobile__c = null;
            }
            
            modiLst[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            update modiLst;
            message += ' job aborted successfully.';
            return message;
        }

        catch(Exception e){
            return e.getMessage();
        }
    }*/
}