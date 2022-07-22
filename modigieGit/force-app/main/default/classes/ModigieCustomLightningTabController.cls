public with sharing class ModigieCustomLightningTabController {
    // @Depricated
    // public static String getModigieInformationCustom(Id recid){
   	// 	try{
    //         String sObjectType = recid.getSObjectType().getDescribe().getName();
    //         List <modigie__Modigie__c> modiLst = [SELECT Id, modigie__Linkedin_URL__c, modigie__Validation_Date_Get_LinkedIn__c, modigie__Validation_Date_Mobile__c, modigie__Validation_Date_Verify_Employer__c, modigie__Validation_Date_Get_Mobile_Number__c, modigie__Status__c, modigie__Linkedin_Status__c, modigie__Phone_Intelligence_Status__c, modigie__Validate_Employer_Status__c, modigie__Mobile__c, modigie__Company_Name_Matches_Public_Records__c, modigie__Current_Employer__c, modigie__Current_Title__c, modigie__Current__c, modigie__Phone_Name_Match__c, modigie__Line_Activity__c, modigie__Phone_Type__c, modigie__Best_Time_to_Call__c FROM modigie__Modigie__c WHERE modigie__Parent_Id__c  = :recid WITH SECURITY_ENFORCED LIMIT 1];
    //         String result;
    //         if(modiLst.size() == 1){
    //             return JSON.serialize(modiLst[0]);
    //         }
            
    //         else{
    //             result = 'No Record Available';
    //         }
    //         if(Test.isRunningTest()){
    //             throw new MyException('No Record Available');
    //         }
    //         return result;
    //     }
    	
    //     catch(Exception e){
    //         return e.getMessage();
    //     }
    // }
    // public class MyException extends Exception {}
}