/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    6 Feb 2020
*  @name    LeadAndContactEscalation
*  @description This class is used by "LeadAndContactEscalation.cmp" to make callout 
					when user press escalate button on Contact or Lead.
***********************************************************************/
public with sharing class LeadAndContactEscalation 
{

/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    6 Feb 2020
*  @name   escalateRecord 
*  @description Check Modigie record should escalate or not
*  @Parameters Modigie Id
*  @return Returns status of Escalation.
***********************************************************************/ 
    // @Depricated
    // public static Object escalateRecord(String recid)
    // {
    //     try
    //     {
    //         Continuation con = new Continuation(60);
            
    //         List<User> userobj = new List<User>();
            
    //         List<modigie__Modigie__c> mrec = new List<modigie__Modigie__c>();
            
    //         String jobid;
            
    //         if(LeadAndContactEscalation.canReadObject('User') &&
    //            LeadAndContactEscalation.canReadField('User','Username') &&
    //            LeadAndContactEscalation.canReadField('User','Name') &&
    //            LeadAndContactEscalation.canReadField('User','CompanyName') &&
    //            LeadAndContactEscalation.canReadField('User','Email'))
    //         {
    //             userobj = [SELECT Id, Username, Name, CompanyName, Email FROM User where Id = :UserInfo.getUserId() LIMIT 1];
    //         }
    //         else
    //         {
    //             throw new LeadAndContactEscalationException('User does not have needed permissions for User object and/or fields.');
    //         }
            
           
            
         
    //         return con;
    //     }
    //     catch(Exception e)
    //     {
    //         return e.getMessage();
    //     }
    // }
    
    // // Callback method
    // @Depricated
    // public static Object processResponse(List<String> labels, Object state) 
    // {
    //     try
    //     {
    //         HttpResponse response = Continuation.getResponse(labels[0]);
    //         String result = response.getBody();
    //         return JSON.serialize(result);
    //     }
    //     catch(Exception e)
    //     {
    //         return e.getMessage();
    //     }
    // }
    
    // @Depricated
    // public static String updateOnEscalation(String response, String recid)
    // {
    //     try
    //     {
    //         List<modigie__Modigie__c> mrec = new List<modigie__Modigie__c>();
            
    //         Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(response);
    //         String status = String.valueOf(resMap.get('status'));
            
    //         if(LeadAndContactEscalation.canReadObject('modigie__Modigie__c') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','Name') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','modigie__Jobid__c') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','modigie__Status__c') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','modigie__Validation_Key__c'))
    //         {
    //             mrec = [Select Name, modigie__Jobid__c, modigie__Validation_Date_Get_Mobile_Number__c, modigie__Status__c, modigie__Validation_Key__c From modigie__Modigie__c WHERE id =: recid LIMIT 1];
    //         }
    //         else
    //         {
    //             throw new LeadAndContactEscalationException('User does not have needed permissions for Modigie object and/or fields.');
    //         }
            
    //         if(LeadAndContactEscalation.canReadObject('modigie__Modigie__c') &&
    //            LeadAndContactEscalation.canUpdateObject('modigie__Modigie__c') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','modigie__Status__c') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
    //            LeadAndContactEscalation.canUpdateField('modigie__Modigie__c','modigie__Status__c') &&
    //            LeadAndContactEscalation.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c') &&
    //            LeadAndContactEscalation.canUpdateField('modigie__Modigie__c','modigie__Validation_Key__c'))
    //         {
    //             mrec[0].modigie__Status__c = 'In Escalation';
    //             mrec[0].modigie__Validation_Date_Get_Mobile_Number__c = System.now();
    //             mrec[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                
    //             update mrec[0];
    //         }
    //         return status;
    //     }
    //     catch(Exception e)
    //     {
    //         return e.getMessage();
    //     }
    // }
    
    // @Depricated
    // public static string checkModigieRecord(ID recid)
    // {
    //     try
    //     {
    //         String result;
            
    //         List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
            
    //         if(LeadAndContactEscalation.canReadObject('modigie__Modigie__c') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','Name') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','modigie__Status__c') &&
    //            LeadAndContactEscalation.canReadField('modigie__Modigie__c','modigie__Contact__c'))
    //         {
    //             modiList = [SELECT Name, modigie__Contact__c, modigie__Status__c FROM modigie__Modigie__c WHERE Id =: recid LIMIT 1];
    //         }
    //         else
    //         {
    //             throw new LeadAndContactEscalationException('User does not have needed permissions for Modigie object and/or fields.');
    //         }
            
    //         if(modiList.size() == 1)
    //         {
    //             if(modiList[0].modigie__Status__c == 'Validated')
    //             {
    //                 result = 'Validated';
    //             }
    //             else if(modiList[0].modigie__Status__c == 'In Escalation')
    //             {
    //                 result = 'In Escalation';
    //             }
    //             else if(modiList[0].modigie__Status__c == 'Not Available')
    //             {
    //                 result = 'Not Available';
    //             }
    //             else
    //             {
    //                 result = 'Requires More Research';
    //             }
    //         }
    //         return result;
    //     }
    //     catch(Exception e)
    //     {
    //         return e.getMessage();
    //     }
    // }
    
    // public static Boolean canReadObject(String objectName)
    // {
    //     Schema.DescribeSObjectResult sObjResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
    //     return sObjResult.isAccessible();
    // }
    
    // public static Boolean canReadField(String objectName, String fieldName)
    // {
    //     Schema.DescribeFieldResult sObjFieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
    //     return sObjFieldResult.isAccessible();
    // }
    // public static Boolean canCreateObject(String objectName)
    // {
    //     Schema.DescribeSObjectResult sObjResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
    //     return sObjResult.isCreateable();
    // }
    // public static Boolean canCreateField(String objectName, String fieldName)
    // {
    //     Schema.DescribeFieldResult sObjFieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
    //     return sObjFieldResult.isCreateable();
    // }
    // public static Boolean canUpdateObject(String objectName)
    // {
    //     Schema.DescribeSObjectResult sObjResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
    //     return sObjResult.isUpdateable();
    // }
    // public static Boolean canUpdateField(String objectName, String fieldName)
    // {
    //     Schema.DescribeFieldResult sObjFieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
    //     return sObjFieldResult.isUpdateable(); 
    // }
    
    // public class LeadAndContactEscalationException extends Exception{}
    
}