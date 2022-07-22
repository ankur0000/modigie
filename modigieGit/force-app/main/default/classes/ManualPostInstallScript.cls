global with sharing class ManualPostInstallScript {
    global static void syncOldRuleSet(){
        try{
            modigie__Process_Builder_Switch__c pbs = modigie__Process_Builder_Switch__c.getOrgDefaults();
            if(pbs != null){
                Map<String, modigie__Modigie_Automation_Criteria_Contact__c> maccMap = modigie__Modigie_Automation_Criteria_Contact__c.getAll();
                Map<String, modigie__Modigie_Automation_Criteria_Lead__c> maclMap = modigie__Modigie_Automation_Criteria_Lead__c.getAll();
                if(!maccMap.isEmpty() || !maclMap.isEmpty()){
                    List<modigie__Modigie_Rule_Sets__c> mrsl = [SELECT Id FROM modigie__Modigie_Rule_Sets__c];
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
                    }else{
                        System.debug('Ignore MRS found!');
                    }
                }else{
                    System.debug('No Child Criteria!');
                }
            }else{
                System.debug('No PBS found!');
            }
            List<modigie__Process_Builder_Switch__c> mpbsL = [SELECT modigie__Get_Phone_Insights__c, modigie__Validate_Employer__c, modigie__Get_linkedin_url__c, modigie__No_Mobile_Information__c, modigie__No_Mobile_Information_campaign__c, modigie__Validate_Employer_campaign__c, modigie__Get_linkedin_campaign__c, modigie__Get_Phone_Insights_Campaign__c, modigie__Opportunity_Contact_Get_Modigie__c, modigie__Limits_No_Limits_Selection__c FROM modigie__Process_Builder_Switch__c];
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

        }catch(Exception ex){
            EmailServiceClass.sendErrorEmail('ManualPostInstallScript Error', ex);
        }
    }
}