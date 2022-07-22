/************************************************************************ 
*  @authors     Tarun Gyanchandani
*  @date        6 Feb 2020
*  @name        PostInstallClass
*  @description This class runs after the package is installed in an org.
***********************************************************************/
global without sharing class PostInstallClass implements InstallHandler  
{
/************************************************************************ 
*  @authors     Rikky Malviya
*  @date        10 Feb 2022
*  @name        onInstall
*  @description This method is used to create Default Rule Set, and disable Non-Used Boolean
***********************************************************************/
    
    global void onInstall(InstallContext context)
    {
        try{
            Id orgId = UserInfo.getOrganizationId();
            String[] toAddresses = new String[]{'support@modigie.com','support-salesforce@modigie.com'};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Modigie Post Install Script Email');
            mail.setSubject('Modigie Package has been Installed');
            String emailBody = 'Hi, \nThis mail is sent to Modigie Support to review automated Post Install Steps.';
            try{
                if(context.previousVersion() != null){
                    if(context.previousVersion().compareTo(new Version(1,69)) < 0){
                        modigie__Process_Builder_Switch__c pbs = modigie__Process_Builder_Switch__c.getOrgDefaults();
                        if(pbs != null){
                            Map<String, modigie__Modigie_Automation_Criteria_Contact__c> maccMap = modigie__Modigie_Automation_Criteria_Contact__c.getAll();
                            Map<String, modigie__Modigie_Automation_Criteria_Lead__c> maclMap = modigie__Modigie_Automation_Criteria_Lead__c.getAll();
                            if(!maccMap.isEmpty() || !maclMap.isEmpty()){
                                List<modigie__Modigie_Rule_Sets__c> mrsl = [SELECT Id FROM modigie__Modigie_Rule_Sets__c LIMIT 1];
                                modigie__Modigie_Rule_Sets__c mrs = new modigie__Modigie_Rule_Sets__c();
                                if(mrsl.isEmpty()){
                                    //Which it should be
                                    Boolean defaultMaintainQueue = false;
                                    Integer defaultLimit = 100;
                                    Integer defaultUsage = 0;
                                    Integer defaultLeadLogicType = 1;
                                    String defaultLeadLogic = '';
                                    Integer defaultContactLogicType = 1;
                                    String defaultContactLogic = '';
                                    Boolean defaultIsLimit = true;
                                    
                                    try{
                                        defaultMaintainQueue = pbs.modigie__Maintain_Queue_Sales_Engagement__c;
                                        if(defaultMaintainQueue == null){defaultMaintainQueue = false;}
                                    }catch(Exception ignore){}
                                    try{
                                        defaultLimit = (Integer)pbs.modigie__Dynamic_Criteria_Automation_Limit__c;
                                        if(defaultLimit == null){defaultLimit = 100;}
                                    }catch(Exception ignore){}
                                    try{
                                        defaultUsage = (Integer)pbs.modigie__Dynamic_Criteria_Automation_Usage__c;
                                        if(defaultUsage == null){defaultUsage = 0;}
                                    }catch(Exception ignore){}
                                    try{
                                        defaultLeadLogicType = (Integer)pbs.modigie__Dynamic_Lead_Logic_Type__c;
                                        if(defaultLeadLogicType == null){defaultLeadLogicType = 1;}
                                    }catch(Exception ignore){}
                                    try{
                                        defaultLeadLogic = pbs.modigie__Dynamic_Lead_Custom_Logic__c;
                                        if(defaultLeadLogic == null){defaultLeadLogic = '';}
                                    }catch(Exception ignore){}
                                    try{
                                        defaultContactLogicType = (Integer)pbs.modigie__Dynamic_Contact_Logic_Type__c;
                                        if(defaultContactLogicType == null){defaultContactLogicType = 1;}
                                    }catch(Exception ignore){}
                                    try{
                                        defaultContactLogic = pbs.modigie__Dynamic_Contact_Custom_Logic__c;
                                        if(defaultContactLogic == null){defaultContactLogic = '';}
                                    }catch(Exception ignore){}
                                    try{
                                        defaultIsLimit = (pbs.modigie__Limits_No_Limits_Selection__c.contains('No') ? false : true);
                                        if(defaultIsLimit == null){defaultIsLimit = true;}
                                    }catch(Exception ignore){}
                                    
                                    String uniqueString = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));

                                    if(FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Rule_Sets__c') 
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','Name')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__Rule_Set_Name__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__Rule_Set_Description__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__isActive__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__Maintain_Queue__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__isLimit__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__Limit__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__Usage__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__Lead_Logic_Type__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__Lead_Custom_Logic__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__Contact_Logic_Type__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__Contact_Custom_Logic__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__OnlyOnCreate__c')
                                      && FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Rule_Sets__c','modigie__Email_Limit_Sent__c')
                                      && FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Automation_Criteria_Lead__c') 
                                      && FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Automation_Criteria_Contact__c') 
                                      && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Automation_Criteria_Lead__c','modigie__Field_Order__c')
                                      && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Automation_Criteria_Contact__c','modigie__Field_Order__c')
                                      && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Automation_Criteria_Lead__c','modigie__Rule_Set_Id__c')
                                      && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Automation_Criteria_Contact__c','modigie__Rule_Set_Id__c')
                                    ){
                                        mrs.Name = uniqueString;
                                        mrs.modigie__Rule_Set_Name__c = 'Primary Rule Set';
                                        mrs.modigie__Rule_Set_Description__c = 'Legacy Automation Criteria';
                                        mrs.modigie__isActive__c = false;
                                        mrs.modigie__Maintain_Queue__c = defaultMaintainQueue;
                                        mrs.modigie__isLimit__c = defaultIsLimit;
                                        mrs.modigie__Limit__c = defaultLimit;
                                        mrs.modigie__Usage__c = defaultUsage;
                                        mrs.modigie__Lead_Logic_Type__c = defaultLeadLogicType;
                                        mrs.modigie__Lead_Custom_Logic__c = defaultLeadLogic;
                                        mrs.modigie__Contact_Logic_Type__c = defaultContactLogicType;
                                        mrs.modigie__Contact_Custom_Logic__c = defaultContactLogic;
                                        mrs.modigie__OnlyOnCreate__c = false;
                                        mrs.modigie__Email_Limit_Sent__c = false;
                                        insert mrs;
                                        List<modigie__Modigie_Automation_Criteria_Lead__c> maclList = new List<modigie__Modigie_Automation_Criteria_Lead__c>();
                                        List<modigie__Modigie_Automation_Criteria_Contact__c> maccList = new List<modigie__Modigie_Automation_Criteria_Contact__c>();
                                        for(String maclId : maclMap.keySet()){
                                            modigie__Modigie_Automation_Criteria_Lead__c macl = maclMap.get(maclId);
                                            try{
                                                macl.modigie__Field_Order__c = Integer.valueOf(macl.Name);
                                            }catch(Exception exc){
                                                //ignore
                                            }
                                            macl.modigie__Rule_Set_Id__c = mrs.Id;
                                            maclList.add(macl);
                                        }
                                        for(String maccId : maccMap.keySet()){
                                            modigie__Modigie_Automation_Criteria_Contact__c macc = maccMap.get(maccId);
                                            try{
                                                macc.modigie__Field_Order__c = Integer.valueOf(macc.Name);
                                            }catch(Exception exc){
                                                //ignore
                                            }
                                            macc.modigie__Rule_Set_Id__c = mrs.Id;
                                            maccList.add(macc);
                                        }
                                        if(!maclList.isEmpty()){
                                            update maclList;
                                        }
                                        if(!maccList.isEmpty()){
                                            update maccList;
                                        }
                                    }
                                }else{
                                    emailBody += '\nIgnore MRS found!';
                                }
                            }else{
                                emailBody += '\nNo Child Criteria!';
                            }
                        }else{
                            emailBody += '\nNo PBS found!';
                        }
                        if(FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c') 
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Get_Phone_Insights__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Validate_Employer__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Get_linkedin_url__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__No_Mobile_Information__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Validate_Employer_campaign__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Get_linkedin_campaign__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Get_Phone_Insights_Campaign__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Data_Maintenance_LimitsNoLimitsSelection__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__ProactiveHighVeloctyPipeline_Visibility__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Dynamic_Criteria_Automation__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Limits_No_Limits_Selection__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Get_Phone_Insights__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Validate_Employer__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Get_linkedin_url__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__No_Mobile_Information__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Validate_Employer_campaign__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Get_linkedin_campaign__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Get_Phone_Insights_Campaign__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Data_Maintenance_LimitsNoLimitsSelection__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__ProactiveHighVeloctyPipeline_Visibility__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Dynamic_Criteria_Automation__c')
                        ){
                            List<modigie__Process_Builder_Switch__c> mpbsL = [SELECT modigie__Get_Phone_Insights__c, modigie__Validate_Employer__c, modigie__Get_linkedin_url__c, modigie__No_Mobile_Information__c, modigie__No_Mobile_Information_campaign__c, modigie__Validate_Employer_campaign__c, modigie__Get_linkedin_campaign__c, modigie__Get_Phone_Insights_Campaign__c, modigie__Opportunity_Contact_Get_Modigie__c, modigie__Limits_No_Limits_Selection__c FROM modigie__Process_Builder_Switch__c LIMIT 1];
                            if(!mpbsL.isEmpty()){
                                mpbsL[0].modigie__Get_Phone_Insights__c = false;
                                mpbsL[0].modigie__Validate_Employer__c = false;
                                mpbsL[0].modigie__Get_linkedin_url__c = false; 
                                mpbsL[0].modigie__No_Mobile_Information__c = false; 
                                mpbsL[0].modigie__No_Mobile_Information_campaign__c = false; 
                                mpbsL[0].modigie__Validate_Employer_campaign__c = false; 
                                mpbsL[0].modigie__Get_linkedin_campaign__c = false; 
                                mpbsL[0].modigie__Get_Phone_Insights_Campaign__c = false;  
                                mpbsL[0].modigie__Data_Maintenance_LimitsNoLimitsSelection__c = mpbsL[0].modigie__Limits_No_Limits_Selection__c;
                                mpbsL[0].modigie__ProactiveHighVeloctyPipeline_Visibility__c = false;
                                mpbsL[0].modigie__Dynamic_Criteria_Automation__c = false;
                                update mpbsL;
                            }
                        }
                    }
                    if(context.previousVersion().compareTo(new Version(1,69, 3)) < 0){
                        if(FieldLevelSecurityCheck.canUpdateObject('modigie__TOM__c') 
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__Lead_Priority_4__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__Lead_Priority_5__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__Lead_Priority_6__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__Lead_Reset_Priority_1__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__Lead_Reset_Priority_2__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__Contact_Priority_4__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__Contact_Priority_5__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__Contact_Priority_6__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__Contact_Reset_Priority_1__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__Contact_Reset_Priority_2__c')
                            && FieldLevelSecurityCheck.canReadField('modigie__TOM__c','modigie__isActive__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__Lead_Priority_4__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__Lead_Priority_5__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__Lead_Priority_6__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__Lead_Reset_Priority_1__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__Lead_Reset_Priority_2__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__Contact_Priority_4__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__Contact_Priority_5__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__Contact_Priority_6__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__Contact_Reset_Priority_1__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__Contact_Reset_Priority_2__c')
                            && FieldLevelSecurityCheck.canUpdateField('modigie__TOM__c','modigie__isActive__c')
                        ){
                            List<modigie__TOM__c> tomList = [SELECT Id, modigie__isActive__c, modigie__Lead_Priority_4__c, modigie__Lead_Priority_5__c, modigie__Lead_Priority_6__c, modigie__Contact_Priority_4__c, modigie__Contact_Priority_5__c, modigie__Contact_Priority_6__c, modigie__Lead_Reset_Priority_1__c, modigie__Lead_Reset_Priority_2__c, modigie__Contact_Reset_Priority_1__c, modigie__Contact_Reset_Priority_2__c FROM modigie__TOM__c WHERE SetupOwnerId = :orgId LIMIT 1];
                            if(!tomList.isEmpty()){
                                tomList[0].modigie__Lead_Priority_4__c = null;
                                tomList[0].modigie__Lead_Priority_5__c = null;
                                tomList[0].modigie__Lead_Priority_6__c = null;
                                tomList[0].modigie__Lead_Reset_Priority_1__c = null;
                                tomList[0].modigie__Lead_Reset_Priority_2__c = null;
                                tomList[0].modigie__Contact_Priority_4__c = null;
                                tomList[0].modigie__Contact_Priority_5__c = null;
                                tomList[0].modigie__Contact_Priority_6__c = null;
                                tomList[0].modigie__Contact_Reset_Priority_1__c = null;
                                tomList[0].modigie__Contact_Reset_Priority_2__c = null;
                                tomList[0].modigie__isActive__c = false;
                                update tomList;
                            }
                        }
                    }
                    //SFD-54
                    if(context.previousVersion().compareTo(new Version(1, 70)) < 0){
                        List<modigie__Process_Builder_Switch__c> mpbsL = [SELECT modigie__Validate_Employer_Data_Maintenance__c FROM modigie__Process_Builder_Switch__c WHERE modigie__Validate_Employer_Data_Maintenance__c = true];
                        if(!mpbsL.isEmpty()){
                            mpbsL[0].modigie__Validate_Employer_Data_Maintenance__c = false;
                            update mpbsL;
                        }
                        //Abort Data Maintenance Jobs
                        List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Verify Employer Data Maintenance%' WITH SECURITY_ENFORCED];
                        List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
                        for(CronTrigger ct : lstCt){
                            System.abortJob((String)ct.Id);
                        }
                        List<modigie__Modigie_Credentials__c> modigieCredentialList = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Customer_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1];
                        if(!modigieCredentialList.isEmpty()){
                            Map<String, String> fieldWithValuesMap = new Map<String, String>();
                            fieldWithValuesMap.put('modigie__Customer_ID__c', modigieCredentialList[0].modigie__Customer_Id__c);
                            fieldWithValuesMap.put('modigie__API_Key__c', modigieCredentialList[0].modigie__Api_key__c);
                            fieldWithValuesMap.put('modigie__Email__c', modigieCredentialList[0].modigie__Service_Account_Credentials__c);
                            fieldWithValuesMap.put('modigie__Private_Key__c', modigieCredentialList[0].modigie__Private_key__c);
                            CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);
                            //Create a default Credit Account
                            String uniqueStringforName = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
                            modigie__creditAccountDetails__c creditAccDetail = new modigie__creditAccountDetails__c();
                            creditAccDetail.Name = uniqueStringforName;
                            creditAccDetail.modigie__Credit_Id__c = modigieCredentialList[0].modigie__Credits_Account_Id__c;
                            creditAccDetail.modigie__Balance__c = null;
                            creditAccDetail.modigie__Currency_Code__c = null;
                            creditAccDetail.modigie__Status__c = 'active';
                            creditAccDetail.modigie__Title__c = 'Legacy Credit Account';
                            creditAccDetail.modigie__StopUntilTime__c = null;
                            creditAccDetail.modigie__Default__c = true;
                            insert creditAccDetail;
                            List<modigie__Modigie_Rule_Sets__c> existingRuleSets = [SELECT Id, modigie__CreditId__c, modigie__Credit_Record_Id__c, modigie__Credit_Title__c, modigie__isPerformance__c FROM modigie__Modigie_Rule_Sets__c WHERE modigie__CreditId__c = null];
                            List<modigie__Modigie_Rule_Sets__c> updateRuleSets = new List<modigie__Modigie_Rule_Sets__c>();
                            for(modigie__Modigie_Rule_Sets__c mrs : existingRuleSets){
                                mrs.modigie__Credit_Record_Id__c = creditAccDetail.Id;
                                mrs.modigie__CreditId__c = creditAccDetail.modigie__Credit_Id__c;
                                mrs.modigie__Credit_Title__c = creditAccDetail.modigie__Title__c;
                                mrs.modigie__isPerformance__c = false;
                                updateRuleSets.add(mrs);
                            }
                            if(!updateRuleSets.isEmpty()){
                                update updateRuleSets;
                            }
                        }
                    }
                }
            }catch(Exception error){
                system.debug(error.getMessage() + error.getStackTraceString());
                emailBody += '\n\nPlease check the error message - ' + error.getMessage();
                if(error.getCause()!= null){
                    emailBody += '\nError Cause : ' + error.getCause();
                }
                emailBody += '\nStack Trace : ' + error.getStackTraceString();
            }
            emailBody += '\n\nOrganization Name : ' + UserInfo.getOrganizationName() + '\nOrganization Id : ' + orgId;
            mail.setPlainTextBody(emailBody);
            Messaging.sendEmail(new Messaging.Email[] { mail });
        }catch(Exception ep){
            system.debug(ep.getMessage() + ep.getStackTraceString());
        }
    }
}