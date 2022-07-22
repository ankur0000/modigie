global with sharing class AbortJobsBatchClass implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts,Schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC){

            DateTime dt = System.now();
            Decimal hour = 6;
            dt = dt - hour/24;
            //List<Lead> lstCon = [SELECT Name,LastModifiedDate FROM Lead WHERE LastModifiedDate < :dt];
            String query = 'SELECT modigie__Validation_Key__c,modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c,modigie__Get_Phone_Intelligence_Job_Id_Phone__c,modigie__Get_Phone_Intelligence_Job_Id__c,modigie__Jobid__c,modigie__Linkedin_Job_Id__c,modigie__Validate_Employer_Job_Id__c,modigie__Get_Modigie_Job_Status__c, modigie__Get_LinkedIn_Job_Status__c, modigie__Validate_Employer_Job_Status__c, modigie__Get_Phone_Intelligence_Job_Status__c, modigie__Get_Phone_Intelligence_Job_Status_Phone__c, modigie__Get_Phone_Intelligence_Job_Status_ValNum__c, modigie__Get_Phone_Intelligence_Job_Status_Alt1__c, modigie__Get_Phone_Intelligence_Job_Status_Alt2__c, modigie__Get_Phone_Intelligence_Job_Status_OPhone__c,modigie__Status__c, modigie__Linkedin_Status__c, modigie__Validate_Employer_Status__c, modigie__Phone_Intelligence_Status__c, modigie__Phone_Intelligence_Status_Phone__c, modigie__Phone_Intelligence_Status_Modigie_Number__c, modigie__Phone_Intelligence_Status_Alt_Number1__c, modigie__Phone_Intelligence_Status_Alt_Number2__c, modigie__Phone_Intelligence_Status_Other_Phone__c,modigie__Validation_Date_Get_Mobile_Number__c, modigie__Validation_Date_Get_LinkedIn__c, modigie__Validation_Date_Verify_Employer__c, modigie__Validation_Date_Mobile__c, modigie__Validation_Date_Phone__c, modigie__Validation_Date_Other_Phone__c, modigie__Validation_Date_Modigie_Val_Phone_Number__c, modigie__Validation_Date_Alternate_Number1__c, modigie__Validation_Date_Alternate_Number2__c FROM modigie__Modigie__c WHERE (modigie__Status__c = \'In process\'AND modigie__Validation_Date_Get_Mobile_Number__c < :dt) OR (modigie__Linkedin_Status__c = \'In process\'AND modigie__Validation_Date_Get_LinkedIn__c < :dt) OR (modigie__Validate_Employer_Status__c = \'In process\'AND modigie__Validation_Date_Verify_Employer__c < :dt) OR (modigie__Phone_Intelligence_Status__c = \'In process\'AND modigie__Validation_Date_Mobile__c < :dt) OR (modigie__Phone_Intelligence_Status_Phone__c = \'In process\'AND modigie__Validation_Date_Phone__c < :dt) OR (modigie__Phone_Intelligence_Status_Other_Phone__c = \'In process\'AND modigie__Validation_Date_Other_Phone__c < :dt) WITH SECURITY_ENFORCED';
            return Database.getQueryLocator(query);

        
    }
      
        global void execute(Database.BatchableContext BC, List<sObject> scope){
           
        }
      
        global void finish(Database.BatchableContext BC){
           /* try{
                System.Queueable job = new CreditInfoQueableClass();
                System.enqueueJob(job);
            }
            catch(Exception e){
                throw new AbortJobsBatchClassException(e.getMessage());
            }*/
        }
        global void execute(SchedulableContext sc){
           
        }
        private class AbortJobsBatchClassException extends Exception{}
}