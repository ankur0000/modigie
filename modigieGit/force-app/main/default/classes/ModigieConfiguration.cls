/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date   6 Feb 2020
*  @name    ModigieConfiguration
*  @description This class is used by "ModigieConfigurationComponent" when user perform action on Configuration page.
***********************************************************************/
public with sharing class ModigieConfiguration 
{
    
    /************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date   6 Feb 2020
*  @name   getToken
*  @description This method perform API callout to get Access token when user login with username & password
*  @Parameters Username, Password
*  @return Returns User Email & Access token.
***********************************************************************/ 
    
//     @AuraEnabled
//     public static void getToken(Map<String,Object> resMap)
//     {
//         try
//         {
            
//             Map<String,Object> argMap = resMap;
            
//             List<modigie__Modigie_Credentials__c> lstModigieCredential = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Customer_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c,modigie__Validation_Key__c,About_Modigie__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1];
            
            
            
//             String privateKey =  String.valueOf(argMap.get('privateKey'));
//             privateKey = privateKey.replace('\n','');
//             if(!lstModigieCredential.isEmpty()){
                
                
                
//                 lstModigieCredential[0].modigie__Customer_Id__c = (String)argMap.get('customerId');
//                 lstModigieCredential[0].modigie__Credits_Account_Id__c = (String)argMap.get('creditsId');
//                 lstModigieCredential[0].modigie__API_Key__c = (String)argMap.get('apiKey');
//                 lstModigieCredential[0].modigie__Service_Account_Credentials__c = (String)argMap.get('serviceCredentials');
//                 lstModigieCredential[0].modigie__Private_key__c = privateKey;
//                 lstModigieCredential[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
// //                  if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credentials__c')&&
// // FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Credentials__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__Customer_Id__c')&&
// // FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credentials__c', 'modigie__Customer_Id__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__Credits_Account_Id__c')&&
// // FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credentials__c', 'modigie__Credits_Account_Id__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__API_Key__c')&&
// // FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credentials__c', 'modigie__API_Key__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__Service_Account_Credentials__c')&&
// // FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credentials__c', 'modigie__Service_Account_Credentials__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__Private_key__c')&&
// // FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credentials__c', 'modigie__Private_key__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__Validation_Key__c')&&
// // FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credentials__c', 'modigie__Validation_Key__c')){  
//                 update lstModigieCredential[0];
// //                  }
// // else{
// // throw new ModigieConfigurationException('User does not have permission to edit modigie credential record.');
// // }
//             }
            
            
//             else
//             {
                
//                 modigie__Modigie_Credentials__c accToken = new modigie__Modigie_Credentials__c();
//                 accToken.modigie__Customer_Id__c = (String)argMap.get('customerId');
//                 accToken.modigie__Credits_Account_Id__c = (String)argMap.get('creditsId');
//                 accToken.modigie__Service_Account_Credentials__c = (String)argMap.get('serviceCredentials');
//                 accToken.modigie__API_Key__c = (String)argMap.get('apiKey');
//                 accToken.modigie__Private_key__c = privateKey;
//                 accToken.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
// //                 if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credentials__c')&&
// // FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Credentials__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__Customer_Id__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credentials__c', 'modigie__Customer_Id__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__Credits_Account_Id__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credentials__c', 'modigie__Credits_Account_Id__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__API_Key__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credentials__c', 'modigie__API_Key__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__Service_Account_Credentials__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credentials__c', 'modigie__Service_Account_Credentials__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__Private_key__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credentials__c', 'modigie__Private_key__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c', 'modigie__Validation_Key__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credentials__c', 'modigie__Validation_Key__c')){       
//                 insert accToken;
// //                  }
// // else{
// // throw new ModigieConfigurationException('User does not have permission to edit modigie credential record.');
// // }
//             }

//             //30 Sep 2021
//             String currentUserId = UserInfo.getUserId();
// //             if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Configurator__c')&&
// // FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Configurator__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Modigie_Configurator__c', 'modigie__ConfigurerId__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Configurator__c', 'modigie__ConfigurerId__c')){
//             List<modigie__Modigie_Configurator__c> configUser = [SELECT Id FROM modigie__Modigie_Configurator__c WITH SECURITY_ENFORCED LIMIT 1];
//             if(configUser.isEmpty()){
//                 modigie__Modigie_Configurator__c newConfigUser = new modigie__Modigie_Configurator__c();
//                 newConfigUser.modigie__ConfigurerId__c = currentUserId;
//                 insert newConfigUser;
//             }else{
//                 configUser[0].modigie__ConfigurerId__c = currentUserId;
//                 update configUser[0];
//             }
//             //}
//             //end 30 Sep 2021
            
//             List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
//             if(lstPbs.isEmpty()){
//                 Map<String,String> tempMap = new Map<String,String>();
//                 tempMap.put('selectedFieldsContact','Mobile,');
//                 tempMap.put('selectedFieldsLead','Mobile,');
                
// //                  if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
// // FieldLevelSecurityCheck.canCreateObject('modigie__Process_Builder_Switch__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Contact_Assigned_to_New_Account__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Contact_Assigned_to_New_Account__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Get_linkedin_campaign__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Get_linkedin_campaign__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Get_linkedin_url__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Get_linkedin_url__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Get_Modigie_Campaign_Invocable_Limits__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Get_Modigie_Campaign_Invocable_Limits__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Get_Modigie_Campaign_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Get_Modigie_Campaign_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Get_Modigie_Invocable_Limit__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Get_Modigie_Invocable_Limit__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Get_Modigie_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Get_Modigie_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Get_Phone_Insights__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Get_Phone_Insights__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Get_Phone_Insights_Phone_Number_Selected__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Get_Phone_Insights_Phone_Number_Selected__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Hot_Lead_Rating__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Hot_Lead_Rating__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Lead_From_Web__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Lead_From_Web__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Limits_No_Limits_Selection__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Limits_No_Limits_Selection__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Linkedin_Url_Campaign_Limits__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Linkedin_Url_Campaign_Limits__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__LinkedIn_Url_Campaign_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__LinkedIn_Url_Campaign_Usage__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__LinkedIn_Url_Invocable_Limits__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__LinkedIn_Url_Invocable_Limits__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__LinkedIn_Url_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__LinkedIn_Url_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Modigie_Phone_Insights_Invocable_Limit__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Modigie_Phone_Insights_Invocable_Limit__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Modigie_Phone_Insights_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Modigie_Phone_Insights_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__No_Mobile_Information__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__No_Mobile_Information__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__No_Mobile_Information_campaign__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__No_Mobile_Information_campaign__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Opp_Contact_Enrichment_Invocable_Limit__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Opp_Contact_Enrichment_Invocable_Limit__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Opp_Contact_Enrichment_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Opp_Contact_Enrichment_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Opportunity_Contact_Enrichment__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Opportunity_Contact_Enrichment__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Phone_Insights_Data_Maintenance__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Phone_Insights_Data_Maintenance__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Phone_Insights_Data_Maintenance_Limits__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Phone_Insights_Data_Maintenance_Limits__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Phone_Insights_Data_Maintenance_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Phone_Insights_Data_Maintenance_Usage__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Selected_time_interval_phone_insights__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Selected_time_interval_phone_insights__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Selected_time_interval_validate_employer__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Selected_time_interval_validate_employer__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Unresponsive_Lead_Invocable_Limits__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Unresponsive_Lead_Invocable_Limits__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Unresponsive_Lead_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Unresponsive_Lead_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Unresponsive_Lead_Toggle__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Unresponsive_Lead_Toggle__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_Data_Maintenance_Lmt__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_Data_Maintenance_Lmt__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_campaign__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_campaign__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Validate_employer_campaign_Limits__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Validate_employer_campaign_Limits__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Validate_employer_campaign_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Validate_employer_campaign_Usage__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_Data_Maintenance__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_Data_Maintenance__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_Data_Maintenance_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_Data_Maintenance_Usage__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Unresponsive_Lead_Verify_Employer_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Unresponsive_Lead_Verify_Employer_Usage__c')&&

// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_Invocable_Limit__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_Invocable_Limit__c')&&
// // FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_Invocable_Usage__c')&&
// // FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Validate_Employer_Invocable_Usage__c')){
                
//                 modigie__Process_Builder_Switch__c pbs = new modigie__Process_Builder_Switch__c();
//                 pbs.modigie__Contact_Assigned_to_New_Account__c = false;
//                 pbs.modigie__Get_linkedin_campaign__c = false;
//                 pbs.modigie__Get_linkedin_url__c = false;
//                 pbs.modigie__Get_Modigie_Campaign_Invocable_Limits__c = 0;
//                 pbs.modigie__Get_Modigie_Campaign_Invocable_Usage__c = 0;
//                 pbs.modigie__Get_Modigie_Invocable_Limit__c = 0;
//                 pbs.modigie__Get_Modigie_Invocable_Usage__c = 0;
//                 pbs.modigie__Get_Phone_Insights__c = false;
//                 pbs.modigie__Get_Phone_Insights_Phone_Number_Selected__c = JSON.serialize(tempMap);
//                 pbs.modigie__Hot_Lead_Rating__c = false;
//                 pbs.modigie__Lead_From_Web__c = false;
//                 pbs.modigie__Limits_No_Limits_Selection__c = 'No Limits';
//                 pbs.modigie__Linkedin_Url_Campaign_Limits__c = 0;
//                 pbs.modigie__LinkedIn_Url_Campaign_Usage__c = 0;
//                 pbs.modigie__LinkedIn_Url_Invocable_Limits__c = 0;
//                 pbs.modigie__LinkedIn_Url_Invocable_Usage__c = 0;
//                 pbs.modigie__Modigie_Phone_Insights_Invocable_Limit__c = 0;
//                 pbs.modigie__Modigie_Phone_Insights_Invocable_Usage__c = 0;
//                 pbs.modigie__No_Mobile_Information__c = false;
//                 pbs.modigie__No_Mobile_Information_campaign__c = false;
//                 pbs.modigie__No_Phone_Information__c = false;
//                 pbs.modigie__Opp_Contact_Enrichment_Invocable_Limit__c = 0;
//                 pbs.modigie__Opp_Contact_Enrichment_Invocable_Usage__c = 0;
//                 pbs.modigie__Opportunity_Contact_Enrichment__c = false;
//                 pbs.modigie__Phone_Insights_Data_Maintenance__c = false;
//                 pbs.modigie__Phone_Insights_Data_Maintenance_Limits__c = 0;
//                 pbs.modigie__Phone_Insights_Data_Maintenance_Usage__c = 0;
//                 pbs.modigie__Selected_time_interval_phone_insights__c='Half-yearly';
//                 pbs.modigie__Selected_time_interval_validate_employer__c='Half-yearly';
//                 pbs.modigie__Unresponsive_Lead_Invocable_Limits__c = 0;
//                 pbs.modigie__Unresponsive_Lead_Invocable_Usage__c = 0;
//                 pbs.modigie__Unresponsive_Lead_Toggle__c = false;
//                 pbs.modigie__Validate_Employer_Data_Maintenance_Lmt__c = 0;
//                 pbs.modigie__Validate_Employer__c = false;
//                 pbs.modigie__Validate_Employer_campaign__c = false;
//                 pbs.modigie__Validate_employer_campaign_Limits__c = 0;
//                 pbs.modigie__Validate_employer_campaign_Usage__c = 0;
//                 pbs.modigie__Validate_Employer_Data_Maintenance__c = false;
//                 pbs.modigie__Validate_Employer_Data_Maintenance_Usage__c = 0;
//                 pbs.modigie__Validate_Employer_Invocable_Limit__c = 0;
//                 pbs.modigie__Validate_Employer_Invocable_Usage__c = 0;
//                 pbs.modigie__Validate_Employer_Invocable_Usage__c = 0;
//                 pbs.modigie__Unresponsive_Lead_Verify_Employer_Usage__c = 0;
//                 pbs.modigie__Limit_User_for_Modigie_Ad_hoc__c = false;
//                 pbs.modigie__Unresponsive_Lead_Get_Modigie_Usage__c = 0;
//                 pbs.modigie__Opportunity_Contact_Get_Modigie_Usage__c = 0;
//                 pbs.modigie__Opportunity_Contact_Get_Modigie_Limit__c = 0;
//                 pbs.modigie__Unresponsive_Lead_Verify_Employer_Limit__c = 0;
//                 pbs.modigie__Unresponsive_Lead_Get_Modigie_Limit__c = 0;
//                 pbs.modigie__Dynamic_Criteria_Automation_Usage__c = 0;
//                 pbs.modigie__Dynamic_Criteria_Automation_Limit__c = 0;
//                 pbs.modigie__Is_Active_Contact_Alt_LinkedIn_Url__c = false;
//                 pbs.modigie__Is_Active_Lead_Alt_LinkedIn_Url__c = false;
//                 insert pbs;
//                 //  }
//             }
            
            
// //               System.Queueable job = new CreditInfoQueableClass();
// // System.enqueueJob(job);
            
//             List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Services Batch Job%' WITH SECURITY_ENFORCED];
//             List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
            
//             for(CronTrigger ct : lstCt){
//                 System.abortJob((String)ct.Id);
//             }
            
//             String jobId = BatchJobsScheluderClass.scheduleMe(0,1,'Interval');
            
            
//             //  List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Abort jobs garbage collector' WITH SECURITY_ENFORCED];
//             // List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
            
//             //if(lstCt.size() == 0){
//             //    System.schedule('Abort jobs garbage collector', '0 0 * * * ?', new AbortJobsBatchClass());
//             //}
            
//             lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'User and Invocable Modigie Limits Reset' WITH SECURITY_ENFORCED]; 
//             lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
            
//             if(lstCt.isEmpty()){
//                 System.schedule('User and Invocable Modigie Limits Reset', '0 00 00 * * ?', new ModigieLimitResetClass());
//             }
            
//             lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Modigie Batch Class Error Reset' WITH SECURITY_ENFORCED]; 
//             lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
            
//             if(lstCt.size() == 0){
//                 System.schedule('Modigie Batch Class Error Reset', '0 00 00 * * ?', new ModigieBatchClassErrorReset());
//             }

//             lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Get Modigie for Queue' WITH SECURITY_ENFORCED]; 
//             lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
            
//             if(lstCt.size() == 0){
//                 System.schedule('Get Modigie for Queue', '0 30 00 * * ?', new SalesEngagementScheduleClass());
//             }
            
//         }
//         catch(Exception e)
//         {
//             throw new ModigieConfigurationException(e.getMessage());
//         }
//     }
    
    /************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date   6 Feb 2020
*  @name   checkToken
*  @description This Method checks Access Token exist or not.
*  @return Returns username & token.
***********************************************************************/  
    @AuraEnabled
    public static Map<String, Object> checkToken()
    {
        try{
            Map<String, Object> credMap = new Map<String, Object>();
            
            
            
            Boolean var = Schema.sObjectType.modigie__Modigie_Service_Account__mdt.isCreateable();
            if(var){
                credMap.put('TokenCreate', 'true');
                credMap.put('baseUrl', System.URL.getSalesforceBaseUrl().toExternalForm());
                credMap.put('userName', UserInfo.getUserName());
                credMap.put('orgId', UserInfo.getOrganizationId());
                credMap.put('isProduction', ![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox);
            }
            else{
                credMap.put('TokenCreate', 'false'); 
                credMap.put('baseUrl', System.URL.getSalesforceBaseUrl().toExternalForm());
                credMap.put('userName', UserInfo.getUserName());
                credMap.put('orgId', UserInfo.getOrganizationId());
                credMap.put('isProduction', ![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox);
            }
            
            // List<modigie__Modigie_Credentials__c> lstModigieCredential = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Customer_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1];
            List<modigie__Modigie_Service_Account__mdt> lstModigieCredential = ModigieApiUtils.getServiceAccountDetails();
            List<modigie__creditAccountUsers__c> cau = [SELECT Id, Name, modigie__Credit_Id__c FROM modigie__creditAccountUsers__c
                                                  WHERE modigie__User_Id__c =: Userinfo.getUserId() LIMIT 1];
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

            if(lstModigieCredential.size() == 1){
                credMap.put('customerId', lstModigieCredential[0].modigie__Customer_ID__c);
                credMap.put('apiKey', lstModigieCredential[0].modigie__API_Key__c);
                credMap.put('creditsId', creditAccountId);
                credMap.put('serviceCredential', lstModigieCredential[0].modigie__Email__c);
                credMap.put('privateKey', lstModigieCredential[0].modigie__Private_key__c);
                
            }
            System.debug(credMap);
            return credMap;
        }
        catch(System.QueryException e){
            throw new ModigieConfigurationException('You do not have permission to query modigie credentials.');
        }
        catch(Exception e){
            throw new ModigieConfigurationException(e.getMessage());
        }
        
    }
    
    
    
    /************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date   13 July 2020
*  @name   scheduleBatchClass 
*  @description This method executes scheduler class which run batch classes to fetch result of pending jobs.
*  @Parameters Hours(Integer), minutes(Integer)
*********************************************************************** */
    
    @AuraEnabled
    public static String scheduleBatchClass(Integer hours,Decimal minutes, String types){
        try{
            System.debug(hours+'---'+minutes+'---'+types);
            List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Services Batch Job%' WITH SECURITY_ENFORCED];
            List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
            
            for(CronTrigger ct : lstCt){
                System.abortJob((String)ct.Id);
            }
            
            String jobId = BatchJobsScheluderClass.scheduleMe(hours,minutes,types);
            System.debug(jobId);
            return jobId;
        }
        catch(System.QueryException e){
            throw new ModigieConfigurationException('User does not have permission to abort the previous jobs.');
        }
        catch(Exception e){
            throw new ModigieConfigurationException(e.getMessage());
        }
    } 
    
    
    @AuraEnabled
    public static String abortModigieJobs(String strObj){
        
        try{
            
            
            
            Map<String,Object> obj = (Map<String,Object>)JSON.deserializeUntyped(strObj);
            
            
            
            
            
            Boolean abortAll = true;
            
            for(String key : obj.keySet()){
                if(!(Boolean)obj.get(key)){
                    abortAll = false;
                }
            }
            
            if(abortAll){
                List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Services Batch Job%' WITH SECURITY_ENFORCED];
                List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
                
                for(CronTrigger ct : lstCt){
                    System.abortJob((String)ct.Id);
                }
            }
            return 'success';
        }
        catch(System.QueryException e){
            throw new ModigieConfigurationException('User does not have permission to query process builder switch custom settings.');
        }
        catch(Exception e){
            throw new ModigieConfigurationException(e.getMessage());
        }
        
        
    }
    
    @AuraEnabled
    public static String getJobTimeDetails(){
        try{
            Integer jobCount = [SELECT count() FROM CronJobDetail WHERE Name LIKE 'Modigie Services Batch Job%' WITH SECURITY_ENFORCED];
            if(jobCount > 0){
                System.debug('line 460 inside if');
                List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Modigie Services Batch Job by time' WITH SECURITY_ENFORCED LIMIT 1];
                Integer hours = 0;
                Decimal minutes = 0; 
                Boolean isInterval = false;
                if(lstCjd.size() > 0){
                    List<CronTrigger> lstCt = [SELECT Id, CronJobDetailId, CronExpression, CreatedDate FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED];
                    
                    
                    String cronExp = lstCt[0].CronExpression;
                    List<String>lstCronExp = cronExp.split(' ');
                    
                    String minute = lstCronExp[1];
                    String hour = lstCronExp[2];
                    
                    
                    if(hour != '*'){
                        hours = Integer.valueOf(hour);
                    }
                    minutes = Integer.valueOf(minute);
                    
                }
                
                else{
                    List<modigie__Scheduled_Classes_Interval_Information__c> scheduledIntervalInfo = [SELECT modigie__Hours__c, modigie__Minutes__c FROM modigie__Scheduled_Classes_Interval_Information__c WITH SECURITY_ENFORCED LIMIT 1];
                    if(scheduledIntervalInfo.size() == 0){
                        return null;
                    }
                    hours = (Integer)scheduledIntervalInfo[0].modigie__Hours__c;
                    minutes = scheduledIntervalInfo[0].modigie__Minutes__c;
                    isInterval = true;
                }
                
                Map<String,Object> result = new Map<String,Object>();
                
                
                result.put('Hour', hours);
                result.put('Minute', minutes);
                result.put('Interval',isInterval);
                
                return JSON.serialize(result);
            }
            else {
                System.debug('line 503 inside else');
                List<modigie__Scheduled_Classes_Interval_Information__c> scheduledIntervalInfo = [SELECT modigie__Hours__c, modigie__Minutes__c FROM modigie__Scheduled_Classes_Interval_Information__c WITH SECURITY_ENFORCED LIMIT 1];
                System.debug('line 505 '+scheduledIntervalInfo.size());    
                if(scheduledIntervalInfo.size() == 0){
                        return null;
                    }
                    Integer hours = (Integer)scheduledIntervalInfo[0].modigie__Hours__c;
                    Decimal minutes = scheduledIntervalInfo[0].modigie__Minutes__c;
                    Boolean isInterval = true;
                    Map<String,Object> result = new Map<String,Object>();
                
                
                    result.put('Hour', hours);
                    result.put('Minute', minutes);
                    result.put('Interval',isInterval);
                    
                    return JSON.serialize(result);
                // return null;
            }
            
            
        }
        catch(Exception e){
            
            throw new ModigieConfigurationException(e.getMessage());
        }
        
    } 
    
    @AuraEnabled
    public static string getScheduleJobsInfo(){
        try{
            
            
            Map<String,Boolean> result = new Map<String,Boolean>();
            
            return JSON.serialize(result);
        }
        catch(System.QueryException e){
            throw new ModigieConfigurationException('User does not have permission to read batch job information.');
        }
        catch(Exception e){
            throw new ModigieConfigurationException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void saveCustomerId(String customerId){
        try {
            System.debug('CustomerId'+customerId);
            Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
            fieldWithValuesMap.put('modigie__Customer_ID__c', customerId);
            CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap); 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Integer getRemainingCreditsInfo(){
        List<modigie__Modigie_Credit__c> modiCredit = [SELECT  modigie__Remaining_Credits__c FROM modigie__Modigie_Credit__c WITH SECURITY_ENFORCED LIMIT 1];
        if(modiCredit.size() > 0){
            return (Integer)modiCredit[0].modigie__Remaining_Credits__c;
        }
        return null;
    }
    
    @AuraEnabled
    public static String getUserAndCredetialInfo(){
        try{
            List<PermissionSetAssignment> lstUser = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId =:UserInfo.getUserId() AND PermissionSet.Name = 'Modigie_Admin' AND PermissionSet.NamespacePrefix = 'modigie'];
            if(lstUser.size() == 0){
                return 'Not an Modigie Admin';
            }
            Map<String,Object> resultMap = new Map<String,Object>();
            // List<modigie__Modigie_Credentials__c> lstCredentials = [SELECT Id, modigie__Service_Account_Credentials__c, modigie__Private_key__c, modigie__Customer_Id__c, modigie__Credits_Account_Id__c, modigie__Api_key__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1 ];   
            List<modigie__Modigie_Service_Account__mdt> modigieServiceAcc = [SELECT Id, DeveloperName, Label, modigie__Private_Key__c, modigie__API_Key__c, modigie__Email__c, modigie__Customer_ID__c FROM modigie__Modigie_Service_Account__mdt WITH SECURITY_ENFORCED LIMIT 1 ]; 
            if(modigieServiceAcc.size() == 0){
                throw new ModigieConfigurationException('You are not an authorized user.');
            }
            User userobj = [SELECT Id, Username, Name, CompanyName, Email FROM User where Id = :UserInfo.getUserId() WITH SECURITY_ENFORCED LIMIT 1];    
            
            resultMap.put('CredentialInfo',modigieServiceAcc[0]);
            resultMap.put('UserInfo',userObj);
            resultMap.put('OrganizationInfo',UserInfo.getOrganizationId());
            resultMap.put('OrganizationName',UserInfo.getOrganizationName());
            return JSON.serialize(resultMap);
        }
        catch(Exception e){
            throw new ModigieConfigurationException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void killScheduledBatchJobs(){
        try{
            
            List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Services Batch Job%' OR Name in ('User and Invocable Modigie Limits Reset', 'Modigie Batch Class Error Reset', 'Get Modigie for Queue') WITH SECURITY_ENFORCED];
            List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
            
            for(CronTrigger ct : lstCt){
                System.abortJob((String)ct.Id);
            }
            List<modigie__Scheduled_Classes_Interval_Information__c> intervalInfo = [SELECT modigie__Hours__c, modigie__Minutes__c FROM modigie__Scheduled_Classes_Interval_Information__c WITH SECURITY_ENFORCED LIMIT 1];
                if(intervalInfo.size() > 0){
                    delete intervalInfo;
                }
        }
        catch(Exception e){
            throw new ModigieConfigurationException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<User> getActiveUsers(){
        System.debug('asdkjfdsajfjdaslkfajdsf');
        try {
            List<PermissionSet> listId = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin' LIMIT 1];
            if(listId .isEmpty()){
                return null;
            }
            List<User> userList = [SELECT Id, Name FROM User WHERE isActive = true AND Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId IN :listId)];
            system.debug(userList);
            return userList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void unexpectedExceptionSave(String exceptionType, String selectedUsers){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_UnexpectedException__c, modigie__Users_Opted_For_SecurityException__c, modigie__Users_Opted_For_NoDataFoundException__c, modigie__Users_Opted_For_EmailException__c, modigie__Users_Opted_For_CalloutException__c, modigie__Users_Opted_For_DMLException__c, modigie__Users_Opted_For_AllException__c, modigie__Users_Opted_For_CalloutResponse__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(exceptionType+'-----------'+selectedUsers);
            if(exceptionType == 'Unexpected Exception' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c = selectedUsers;
                update lstPbs;
            }
            else if(exceptionType == 'Security Exception' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_SecurityException__c = selectedUsers;
                update lstPbs;
            }
            else if(exceptionType == 'NoDataFound Exception' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_NoDataFoundException__c = selectedUsers;
                update lstPbs;
            }
            else if(exceptionType == 'Email Exception' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_EmailException__c = selectedUsers;
                update lstPbs;
            }
            // else if(exceptionType == 'Limit Exception' && lstPbs.size() > 0){
            //     lstPbs[0].modigie__Users_Opted_For_LimitException__c = selectedUsers;
            //     update lstPbs;
            // }
            else if(exceptionType == 'Callout Exception' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_CalloutException__c = selectedUsers;
                update lstPbs;
            }
            else if(exceptionType == 'Dml Exception' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_DMLException__c = selectedUsers;
                update lstPbs;
            }
            else if(exceptionType == 'All Exception' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_AllException__c = selectedUsers;
                update lstPbs;
            }
            else if(exceptionType == 'Callout Response' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_CalloutResponse__c = selectedUsers;
                update lstPbs;
            }
            else if(exceptionType == 'Credit Error' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_CreditError__c = selectedUsers;
                update lstPbs;
            }
            else if(exceptionType == 'Invocable Limit' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_InvocableLimitExceeded__c = selectedUsers;
                update lstPbs;
            }
            else if(exceptionType == 'Adhoq Limit' && lstPbs.size() > 0){
                lstPbs[0].modigie__Users_Opted_For_AdhoqLimitReached__c = selectedUsers;
                update lstPbs;
            }

            // if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
            //            FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
            //            FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Selected_Opportunity_Stages__c')&&
            //            FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c', 'modigie__Selected_Opportunity_Stages__c')){
                           
            //            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static String getSelectedUsersCreditError(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_CreditError__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_CreditError__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);

            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSelectedUsersInvocableLimit(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_InvocableLimitExceeded__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_InvocableLimitExceeded__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);

            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSelectedUsersAdhoqLimit(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_AdhoqLimitReached__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_AdhoqLimitReached__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);

            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSelectedUsersCalloutResponse(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_CalloutResponse__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_CalloutResponse__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);

            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSelectedUsersUnexpected(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_UnexpectedException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);

            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSelectedUsersSecurity(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_SecurityException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_SecurityException__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);

            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSelectedUsersNoDataFound(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_NoDataFoundException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_NoDataFoundException__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);

            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSelectedUsersEmail(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_EmailException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_EmailException__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);

            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // @AuraEnabled
    // public static String getSelectedUsersLimit(){
    //     try {
    //         List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_LimitException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
    //         string str = lstPbs[0].modigie__Users_Opted_For_LimitException__c;
    //         // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
    //         return str;
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }

    @AuraEnabled
    public static String getSelectedUsersCallout(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_CalloutException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_CalloutException__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);

            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSelectedUsersDml(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_DMLException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_DMLException__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);

            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSelectedUsersAll(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__Users_Opted_For_AllException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            string str = lstPbs[0].modigie__Users_Opted_For_AllException__c;
            // List<User> userList = [SELECT Name FROM User WHERE Id IN lstPbs[0].modigie__Users_Opted_For_UnexpectedException__c];
            List<Id> listId = new List<Id>();
            try{
                listId = (List<Id>)JSON.deserialize(str, List<Id>.class);
            }
            catch(exception e){}
            if(listId.isEmpty()){
                return '';
            }

            List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            
            List<User> userList = [SELECT Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :listId AND PermissionSetId IN :ps) AND isActive = true];
            List<Id> ids = new List<Id>();
            for(User u: userList){
                ids.add(u.Id);
            }
            if(ids.isEmpty()){
                return '';
            }
            str = JSON.serialize(ids);
            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCheckBoxForAdhoqLimit(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__AdhoqLimitReached__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__AdhoqLimitReached__c = !checkBox;
            upsert newMc;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCheckBoxForInvocableLimit(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__InvocableLimitExceeded__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__InvocableLimitExceeded__c = !checkBox;
            upsert newMc;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCheckBoxForCreditError(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__CreditError__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__CreditError__c = !checkBox;
            upsert newMc;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCheckBoxForCalloutResponse(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__CalloutResponse__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__CalloutResponse__c = !checkBox;
            upsert newMc;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCheckBoxForUnexpected(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__UnexpectedException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__UnexpectedException__c = !checkBox;
            upsert newMc;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCheckBoxForSecurity(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__SecurityException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__SecurityException__c = !checkBox;
            upsert newMc;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCheckBoxForNoDataFound(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__NoDataFoundException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__NoDataFoundException__c = !checkBox;
            upsert newMc;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCheckBoxForEmail(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__EmailException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__EmailException__c = !checkBox;
            upsert newMc;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // @AuraEnabled
    // public static void saveCheckBoxForLimit(Boolean checkBox){
    //     System.debug(checkBox);
    //     try {
    //         List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__LimitException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
    //         System.debug(lstPbs);
    //         if(lstPbs.size() > 0){
    //             lstPbs[0].modigie__LimitException__c = !checkBox;
    //             // System.debug(lstPbs[0].modigie__UnexpectedException__c);
    //                    update lstPbs;            
    //     }
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }

    @AuraEnabled
    public static void saveCheckBoxForCallout(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__CalloutException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__CalloutException__c = !checkBox;
            upsert newMc; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCheckBoxForDml(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__DMLException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__DMLException__c = !checkBox;
            upsert newMc;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCheckBoxForAll(Boolean checkBox){
        System.debug(checkBox);
        try {
            modigie__Message_Center__c newMC = new modigie__Message_Center__c();
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__AllException__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            System.debug(lstPbs);
            if(lstPbs.size() > 0){
                newMC.Id = lstPbs[0].Id;           
            }
            newMC.modigie__AllException__c = !checkBox;
            upsert newMc;
           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,Boolean> getAllCheckBoxes(){
        try {
            List<modigie__Message_Center__c> lstPbs = [SELECT Id, modigie__UnexpectedException__c, modigie__SecurityException__c, modigie__NoDataFoundException__c, modigie__EmailException__c, modigie__CalloutException__c, modigie__DMLException__c, modigie__AllException__c, modigie__CalloutResponse__c, modigie__CreditError__c, modigie__InvocableLimitExceeded__c, modigie__AdhoqLimitReached__c FROM modigie__Message_Center__c WITH SECURITY_ENFORCED  LIMIT 1];
            Map<String,Boolean> strList = new Map<String,Boolean>();
            for(modigie__Message_Center__c key: lstPbs){
                strList.put('modigie__UnexpectedException__c', key.modigie__UnexpectedException__c);
                strList.put('modigie__SecurityException__c', key.modigie__SecurityException__c);
                strList.put('modigie__NoDataFoundException__c', key.modigie__NoDataFoundException__c);
                strList.put('modigie__EmailException__c', key.modigie__EmailException__c);
                // strList.put('modigie__LimitException__c', key.modigie__LimitException__c);
                strList.put('modigie__CalloutException__c', key.modigie__CalloutException__c);
                strList.put('modigie__DMLException__c', key.modigie__DMLException__c);
                strList.put('modigie__AllException__c', key.modigie__AllException__c);
                strList.put('modigie__CalloutResponse__c', key.modigie__CalloutResponse__c);
                strList.put('modigie__CreditError__c', key.modigie__CreditError__c);
                strList.put('modigie__InvocableLimitExceeded__c', key.modigie__InvocableLimitExceeded__c);
                strList.put('modigie__AdhoqLimitReached__c', key.modigie__AdhoqLimitReached__c);
            }
            return strList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getRedirectUrl(){
        try {
            List<modigie__Modigie_Callout_Info__mdt> calloutInfo = ModigieApiUtils.getCalloutInfoDetails('Autorize_Application_Redirect_Url');
            return calloutInfo[0].modigie__Endpoint_Url__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    
    
    private class ModigieConfigurationException extends Exception{}
    
}