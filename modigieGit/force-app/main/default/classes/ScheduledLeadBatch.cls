/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    6 Feb 2020
*  @name    ScheduledLeadBatch
*  @description This class runs in every 24 hours to check status of Lead related modigie records which are in escalation.
***********************************************************************/
global with sharing class ScheduledLeadBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful 
{
    // List<Lead> leadList = new List<Lead>();
    // List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
    // Map<String, modigie__Modigie__c> modiMap = new Map<String, modigie__Modigie__c>();
    
    // public ScheduledLeadBatch(List<Lead> schLeadList)
    // {
    //     leadList = schLeadList;
    // }


    global List<Lead> start(Database.BatchableContext bc) 
    {
        return null;
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope)
    {
        // try
        // {
        //     List<User> userobj = new List<User>();
            
            
        //     if(FieldLevelSecurityCheck.canReadObject('User') &&
        //        FieldLevelSecurityCheck.canReadField('User','Username') &&
        //        FieldLevelSecurityCheck.canReadField('User','Name') &&
        //        FieldLevelSecurityCheck.canReadField('User','CompanyName') &&
        //        FieldLevelSecurityCheck.canReadField('User','Email'))
        //     {
        //         userobj = [SELECT Id, Username, Name, CompanyName, Email FROM User where Id = :UserInfo.getUserId() LIMIT 1];
        //     }
            
           
            
        //     for(Lead leadRec : scope)
        //     {
        //         List<modigie__Modigie__c> mlist = leadRec.Modigie__r;
        //         for(modigie__Modigie__c modiRec : mlist)
        //         {
        //             modiMap.put(modiRec.modigie__Lead__c, modiRec);
        //         }
        //     }
            
        //     for (Lead leadRec : scope)
        //     {
        //         modigie__Modigie__c mrec = modiMap.get(leadRec.Id);
                
        //         String companyname = leadRec.Company;
        //         if(companyname != null && companyname.contains(' '))
        //             companyname= companyname.replaceAll( ' ', '');
                
        //         Http http = new Http();
        //         HttpRequest request = new HttpRequest();
        //         request.setMethod('POST');
        //         request.setHeader('Content-Length', '4096');
        //         request.setBody('');
                
        //         request.setTimeout(120000);
                
        //         HttpResponse response = http.send(request);
                
        //         if (response.getStatusCode() == 200)
        //         {
        //             String jsonResponse = response.getBody();
        //             Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        //             Map<String,Object> result_data = (Map<String,Object>)resMap.get('results');
        //             object status = resMap.get('status');
                    
        //             if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
        //                FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile__c') &&
        //                FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
        //                FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c') &&
        //                FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c')&&
        //                FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
        //                FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Key__c') &&
        //                FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Status__c') &&
        //                FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Mobile__c') &&
        //                FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c'))
        //             {
        //                 modigie__Modigie__c modiRec = modiMap.get(leadRec.Id);
        //                 modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
        //                 modiRec.modigie__Status__c = String.valueOf(status);
        //                 modiRec.modigie__Mobile__c = String.valueOf(result_data.get('phones'));
        //                 modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                        
        //                 modiList.add(modiRec);
        //             }
        //         }
        //         else if(response.getStatusCode() == 302)
        //         {
        //             String reqq = response.getHeader('Location');
        //             HttpRequest request1 = new HttpRequest();
        //             request1.setTimeout(120000);
        //             request1.setMethod('GET');
        //             request1.setEndpoint(reqq);
        //             response = http.send(request1);
                    
        //             String jsonResponse = response.getBody();
        //             if(jsonResponse.containsIgnoreCase('Unvalidated'))
        //             {
        //                 if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
        //                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
        //                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c') &&
        //                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c')&&
        //                    FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
        //                    FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Key__c') &&
        //                    FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Status__c') &&
        //                    FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c'))
        //                 {
        //                     modigie__Modigie__c modiRec = modiMap.get(leadRec.Id);
        //                     modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
        //                     modiRec.modigie__Status__c = 'Unvalidated';
        //                     modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        //                     modiList.add(modiRec);
        //                 }
        //             }
        //             else
        //             {
                        
                        
        //                 Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        //                 Map<String,Object> result_data = (Map<String,Object>)resMap.get('results');
        //                 object status = resMap.get('status');
                        
        //                 if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
        //                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile__c') &&
        //                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
        //                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c') &&
        //                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c')&&
        //                    FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
        //                    FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Key__c') &&
        //                    FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Status__c') &&
        //                    FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Mobile__c') &&
        //                    FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c'))
        //                 {
        //                     modigie__Modigie__c modiRec = modiMap.get(leadRec.Id);
        //                     modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
        //                     modiRec.modigie__Status__c = String.valueOf(status);
        //                     modiRec.modigie__Mobile__c = String.valueOf(result_data.get('phones'));
        //                     modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                            
        //                     modiList.add(modiRec);
        //                 }
        //             }
        //         }
                
        //         //}
        //     }
        // }
        // catch(Exception e)
        // {
        // }
    }  
    
    global void finish(Database.BatchableContext bc)
    {
        // try
        // {
        //     if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
        //        FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile__c') &&
        //        FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
        //        FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c') &&
        //        FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c')&&
        //        FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
        //        FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Key__c') &&
        //        FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Status__c') &&
        //        FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Mobile__c') &&
        //        FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c'))
        //     {
        //         update modiList;
        //     }
        // }
        // catch(Exception e)
        // {
        // }
    }    
}