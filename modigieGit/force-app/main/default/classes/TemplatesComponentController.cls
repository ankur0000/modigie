public with sharing class TemplatesComponentController {
    
    @AuraEnabled
    public static String getProcessStates(){
        try{
           List<modigie__Process_Builder_Switch__c> processSwitch = [SELECT modigie__ProactiveHighVeloctyPipeline_Visibility__c, modigie__Data_Maintenance_LimitsNoLimitsSelection__c, modigie__Opportunity_Request_Limit__c, modigie__Opportunity_Limits_No_Limits_Selection__c, modigie__Send_Limit_Reached_Email_To_All_Admin__c, modigie__Populate_Lead_Mobile_Field__c, modigie__Populate_Contact_Mobile_Field__c, modigie__Maintain_Queue_Sales_Engagement__c, modigie__Dynamic_Criteria_Automation__c, modigie__Dynamic_Criteria_Automation_Limit__c, modigie__Dynamic_Criteria_Automation_Usage__c, modigie__Dynamic_Criteria_Automation_A__c, modigie__Selected_Opportunity_Stages__c, modigie__Unresponsive_Lead_Get_LinkedIn_URL__c, modigie__Unresponsive_Lead_Get_LinkedIn_URL_A__c, modigie__Unresponsive_Lead_Get_LinkedIn_URL_Limit__c, modigie__Unresponsive_Lead_Get_LinkedIn_URL_Usage__c, modigie__Unresponsive_Lead_Get_Phone_Insights__c, modigie__Unresponsive_Lead_Get_Phone_Insights_A__c, modigie__Unresponsive_Lead_Get_Phone_Insights_Lim__c, modigie__Unresponsive_Lead_Get_Phone_Insights_Usa__c, modigie__Unresponsive_Lead_Get_Modigie__c, modigie__Unresponsive_Lead_Get_Modigie_A__c, modigie__Unresponsive_Lead_Get_Modigie_Limit__c, modigie__Unresponsive_Lead_Get_Modigie_Usage__c, modigie__Lead_Status_Working_Get_LinkedIn_URL__c, modigie__Lead_Status_Working_Get_LinkedIn_URL_A__c, modigie__Lead_Status_Working_Get_LinkedIn_URL_Lim__c, modigie__Lead_Status_Working_Get_LinkedIn_URL_Usa__c, modigie__Lead_Status_Working_Get_Phone_Insights__c, modigie__Lead_Status_Working_Get_Phone_Insights_A__c, modigie__Lead_Status_Working_Get_Phone_Insights_L__c, modigie__Lead_Status_Working_Get_Phone_Insights_U__c, modigie__Lead_Status_Working_Verify_Employer__c, modigie__Lead_Status_Working_Verify_Employer_A__c, modigie__Lead_Status_Working_Verify_Employer_Limi__c, modigie__Lead_Status_Working_Verify_Employer_Usag__c, modigie__Lead_Status_Working_Get_Modigie__c, modigie__Lead_Status_Working_Get_Modigie_A__c, modigie__Lead_Status_Working_Get_Modigie_Limit__c, modigie__Lead_Status_Working_Get_Modigie_Usage__c, modigie__Unreachable_Get_LinkedIn_URL__c, modigie__Unreachable_Get_LinkedIn_URL_A__c, modigie__Unreachable_Get_LinkedIn_URL_Limit__c, modigie__Unreachable_Get_LinkedIn_URL_Usage__c, modigie__Unreachable_Get_Phone_Insights__c, modigie__Unreachable_Get_Phone_Insights_A__c, modigie__Unreachable_Get_Phone_Insights_Limit__c, modigie__Unreachable_Get_Phone_Insights_Usage__c, modigie__Unreachable_Verify_Employer__c, modigie__Unreachable_Verify_Employer_A__c, modigie__Unreachable_Verify_Employer_Limit__c, modigie__Unreachable_Verify_Employer_Usage__c, modigie__Unreachable_Get_Modigie__c, modigie__Unreachable_Get_Modigie_A__c, modigie__Unreachable_Get_Modigie_Limit__c, modigie__Unreachable_Get_Modigie_Usage__c, modigie__Opportunity_Contact_Get_LinkedIn_Usage__c, modigie__Opportunity_Contact_Get_LinkedIn_Limit__c, modigie__Opportunity_Contact_Get_LinkedIn_A__c, modigie__Opportunity_Contact_Get_LinkedIn__c,modigie__Opportunity_Contact_Get_Phone_Insights__c, modigie__Opportunity_Contact_Get_Phone_Insights_A__c, modigie__Opportunity_Contact_Get_Phone_Insights_L__c, modigie__Opportunity_Contact_Get_Phone_Insights_U__c, modigie__Opportunity_Contact_Get_Modigie__c, modigie__Opportunity_Contact_Get_Modigie_A__c, modigie__Opportunity_Contact_Get_Modigie_Limit__c, modigie__Opportunity_Contact_Get_Modigie_Usage__c, modigie__Validate_Employer_Data_Maintenance_Lmt_A__c, modigie__Validate_Employer_Data_Maintenance_Usage__c, modigie__Unresponsive_Lead_Verify_Employer__c, modigie__Unresponsive_Lead_Verify_Employer_A__c, modigie__Unresponsive_Lead_Verify_Employer_Limit__c, modigie__Unresponsive_Lead_Verify_Employer_Usage__c, modigie__Get_Phone_Insights_Campaign__c, modigie__Get_Phone_Insights_Campaign_Limits__c,  modigie__Limits_No_Limits_Selection__c, modigie__Selected_Lead_Status__c, modigie__Get_linkedin_campaign__c, modigie__Linkedin_Url_Campaign_Limits__c, modigie__Validate_employer_campaign_Limits__c, modigie__Get_Modigie_Campaign_Invocable_Limits__c, modigie__Validate_Employer_Data_Maintenance_Lmt__c,  modigie__Phone_Insights_Data_Maintenance_Limits__c, modigie__Unresponsive_Lead_Invocable_Limits__c, modigie__Opp_Contact_Enrichment_Invocable_Limit__c, modigie__LinkedIn_Url_Invocable_Limits__c, modigie__Validate_Employer_Invocable_Limit__c, modigie__Modigie_Phone_Insights_Invocable_Limit__c, modigie__Validate_Employer_campaign__c, modigie__No_Mobile_Information_campaign__c, modigie__Selected_time_interval_phone_insights__c,modigie__Selected_time_interval_validate_employer__c,modigie__Validate_Employer_Data_Maintenance__c,modigie__Phone_Insights_Data_Maintenance__c,modigie__Unresponsive_Lead_Toggle__c,modigie__Get_Phone_Insights__c, modigie__Get_linkedin_url__c, modigie__No_Mobile_Information__c, modigie__No_Phone_Information__c, modigie__Validate_Employer__c, modigie__Opportunity_Contact_Enrichment__c,modigie__Get_Modigie_Invocable_Limit__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
            Map<String,Object> mMap = new Map<String,Object>();
            if(processSwitch.size() > 0){
                mMap.put('Get_Phone_Insights',  processSwitch[0].modigie__Get_Phone_Insights__c);
                mMap.put('Get_linkedin_url',  processSwitch[0].modigie__Get_linkedin_url__c);
                mMap.put('No_Mobile_Information',  processSwitch[0].modigie__No_Mobile_Information__c);
                mMap.put('No_Phone_Information',  processSwitch[0].modigie__No_Phone_Information__c);
                mMap.put('Validate_Employer',  processSwitch[0].modigie__Validate_Employer__c);  //modigie__Opportunity_Contact_Enrichment__c
                mMap.put('Opportunity_Contact_Enrichment',  processSwitch[0].modigie__Opportunity_Contact_Enrichment__c);
                mMap.put('Unresponsive_Lead_Toggle',  processSwitch[0].modigie__Unresponsive_Lead_Toggle__c);
                mMap.put('Phone_Insights_Data_Maintenance',  processSwitch[0].modigie__Phone_Insights_Data_Maintenance__c);
                mMap.put('Validate_Employer_Data_Maintenance',  processSwitch[0].modigie__Validate_Employer_Data_Maintenance__c);
                mMap.put('Selected_time_interval_phone_insights',  processSwitch[0].modigie__Selected_time_interval_phone_insights__c);
                mMap.put('Selected_time_interval_validate_employer',  processSwitch[0].modigie__Selected_time_interval_validate_employer__c);
                mMap.put('No_Mobile_Information_campaign',  processSwitch[0].modigie__No_Mobile_Information_campaign__c);
                mMap.put('Validate_Employer_campaign',  processSwitch[0].modigie__Validate_Employer_campaign__c);
                mMap.put('Get_linkedin_campaign',  processSwitch[0].modigie__Get_linkedin_campaign__c);
                mMap.put('Get_Modigie_Invocable_Limit',  processSwitch[0].modigie__Get_Modigie_Invocable_Limit__c);
                mMap.put('Modigie_Phone_Insights_Invocable_Limit',processSwitch[0].modigie__Modigie_Phone_Insights_Invocable_Limit__c);
                mMap.put('Validate_Employer_Invocable_Limit',processSwitch[0].modigie__Validate_Employer_Invocable_Limit__c);
                mMap.put('LinkedIn_Url_Invocable_Limits',processSwitch[0].modigie__LinkedIn_Url_Invocable_Limits__c);
                mMap.put('Opp_Contact_Enrichment_Invocable_Limit',processSwitch[0].modigie__Opp_Contact_Enrichment_Invocable_Limit__c);
                mMap.put('Unresponsive_Lead_Invocable_Limits',processSwitch[0].modigie__Unresponsive_Lead_Invocable_Limits__c);
                mMap.put('Phone_Insights_Data_Maintenance_Limits',processSwitch[0].modigie__Phone_Insights_Data_Maintenance_Limits__c);
                mMap.put('Validate_Employer_Data_Maintenance_Lmt',processSwitch[0].modigie__Validate_Employer_Data_Maintenance_Lmt__c);
                mMap.put('Get_Modigie_Campaign_Invocable_Limits',processSwitch[0].modigie__Get_Modigie_Campaign_Invocable_Limits__c);
                mMap.put('Validate_employer_campaign_Limits',processSwitch[0].modigie__Validate_employer_campaign_Limits__c);
                mMap.put('Linkedin_Url_Campaign_Limits',processSwitch[0].modigie__Linkedin_Url_Campaign_Limits__c);
                mMap.put('Limits_No_Limits_Selection',processSwitch[0].modigie__Limits_No_Limits_Selection__c);
                mMap.put('Selected_Lead_Status', processSwitch[0].modigie__Selected_Lead_Status__c );
                mMap.put('Selected_Opportunity_Stages', processSwitch[0].modigie__Selected_Opportunity_Stages__c );
                mMap.put('Maintain_Queue_Sales_Engagement', processSwitch[0].modigie__Maintain_Queue_Sales_Engagement__c );
                
                mMap.put('Get_Phone_Insights_Campaign', processSwitch[0].modigie__Get_Phone_Insights_Campaign__c);
                mMap.put('Get_Phone_Insights_Campaign_Limits', processSwitch[0].modigie__Get_Phone_Insights_Campaign_Limits__c);

                mMap.put('Unresponsive_Lead_Verify_Employer', processSwitch[0].modigie__Unresponsive_Lead_Verify_Employer__c);
                mMap.put('Unresponsive_Lead_Verify_Employer_A', processSwitch[0].modigie__Unresponsive_Lead_Verify_Employer_A__c);
                mMap.put('Unresponsive_Lead_Verify_Employer_Limit', processSwitch[0].modigie__Unresponsive_Lead_Verify_Employer_Limit__c);
                mMap.put('Unresponsive_Lead_Verify_Employer_Usage', processSwitch[0].modigie__Unresponsive_Lead_Verify_Employer_Usage__c);



                //mMap.put('Validate_Employer_Data_Maintenance', processSwitch[0].modigie__Validate_Employer_Data_Maintenance__c);
                //mMap.put('Validate_Employer_Data_Maintenance_Lmt_A', processSwitch[0].modigie__Validate_Employer_Data_Maintenance_Lmt_A__c );
                //mMap.put('Validate_Employer_Data_Maintenance_Lmt', processSwitch[0].modigie__Validate_Employer_Data_Maintenance_Lmt__c );
                mMap.put('Validate_Employer_Data_Maintenance_Usage', processSwitch[0].modigie__Validate_Employer_Data_Maintenance_Usage__c);


                mMap.put('Opportunity_Contact_Get_Modigie', processSwitch[0].modigie__Opportunity_Contact_Get_Modigie__c);
                mMap.put('Opportunity_Contact_Get_Modigie_A', processSwitch[0].modigie__Opportunity_Contact_Get_Modigie_A__c);
                mMap.put('Opportunity_Contact_Get_Modigie_Limit', processSwitch[0].modigie__Opportunity_Contact_Get_Modigie_Limit__c);
                mMap.put('Opportunity_Contact_Get_Modigie_Usage', processSwitch[0].modigie__Opportunity_Contact_Get_Modigie_Usage__c);

                mMap.put('Opportunity_Contact_Get_Phone_Insights', processSwitch[0].modigie__Opportunity_Contact_Get_Phone_Insights__c);
                mMap.put('Opportunity_Contact_Get_Phone_Insights_A', processSwitch[0].modigie__Opportunity_Contact_Get_Phone_Insights_A__c);
                mMap.put('Opportunity_Contact_Get_Phone_Insights_L', processSwitch[0].modigie__Opportunity_Contact_Get_Phone_Insights_L__c);
                mMap.put('Opportunity_Contact_Get_Phone_Insights_U', processSwitch[0].modigie__Opportunity_Contact_Get_Phone_Insights_U__c);

                mMap.put('Opportunity_Contact_Get_LinkedIn', processSwitch[0].modigie__Opportunity_Contact_Get_LinkedIn__c);
                mMap.put('Opportunity_Contact_Get_LinkedIn_A', processSwitch[0].modigie__Opportunity_Contact_Get_LinkedIn_A__c);
                mMap.put('Opportunity_Contact_Get_LinkedIn_Limit', processSwitch[0].modigie__Opportunity_Contact_Get_LinkedIn_Limit__c);
                mMap.put('Opportunity_Contact_Get_LinkedIn_Usage', processSwitch[0].modigie__Opportunity_Contact_Get_LinkedIn_Usage__c);

                mMap.put('Unreachable_Get_Modigie', processSwitch[0].modigie__Unreachable_Get_Modigie__c);
                mMap.put('Unreachable_Get_Modigie_A', processSwitch[0].modigie__Unreachable_Get_Modigie_A__c);
                mMap.put('Unreachable_Get_Modigie_Limit', processSwitch[0].modigie__Unreachable_Get_Modigie_Limit__c);
                mMap.put('Unreachable_Get_Modigie_Usage', processSwitch[0].modigie__Unreachable_Get_Modigie_Usage__c);


                mMap.put('Unreachable_Verify_Employer', processSwitch[0].modigie__Unreachable_Verify_Employer__c);
                mMap.put('Unreachable_Verify_Employer_A', processSwitch[0].modigie__Unreachable_Verify_Employer_A__c);
                mMap.put('Unreachable_Verify_Employer_Limit', processSwitch[0].modigie__Unreachable_Verify_Employer_Limit__c);
                mMap.put('Unreachable_Verify_Employer_Usage', processSwitch[0].modigie__Unreachable_Verify_Employer_Usage__c);


                mMap.put('Unreachable_Get_Phone_Insights', processSwitch[0].modigie__Unreachable_Get_Phone_Insights__c);
                mMap.put('Unreachable_Get_Phone_Insights_A', processSwitch[0].modigie__Unreachable_Get_Phone_Insights_A__c);
                mMap.put('Unreachable_Get_Phone_Insights_Limit', processSwitch[0].modigie__Unreachable_Get_Phone_Insights_Limit__c);
                mMap.put('Unreachable_Get_Phone_Insights_Usage', processSwitch[0].modigie__Unreachable_Get_Phone_Insights_Usage__c);

                mMap.put('Unreachable_Get_LinkedIn_URL', processSwitch[0].modigie__Unreachable_Get_LinkedIn_URL__c);
                mMap.put('Unreachable_Get_LinkedIn_URL_A', processSwitch[0].modigie__Unreachable_Get_LinkedIn_URL_A__c);
                mMap.put('Unreachable_Get_LinkedIn_URL_Limit', processSwitch[0].modigie__Unreachable_Get_LinkedIn_URL_Limit__c);
                mMap.put('Unreachable_Get_LinkedIn_URL_Usage', processSwitch[0].modigie__Unreachable_Get_LinkedIn_URL_Usage__c);

                mMap.put('Lead_Status_Working_Get_Modigie', processSwitch[0].modigie__Lead_Status_Working_Get_Modigie__c);
                mMap.put('Lead_Status_Working_Get_Modigie_A', processSwitch[0].modigie__Lead_Status_Working_Get_Modigie_A__c);
                mMap.put('Lead_Status_Working_Get_Modigie_Limit', processSwitch[0].modigie__Lead_Status_Working_Get_Modigie_Limit__c);
                mMap.put('Lead_Status_Working_Get_Modigie_Usage', processSwitch[0].modigie__Lead_Status_Working_Get_Modigie_Usage__c);

                mMap.put('Lead_Status_Working_Verify_Employer', processSwitch[0].modigie__Lead_Status_Working_Verify_Employer__c);
                mMap.put('Lead_Status_Working_Verify_Employer_A', processSwitch[0].modigie__Lead_Status_Working_Verify_Employer_A__c);
                mMap.put('Lead_Status_Working_Verify_Employer_Limi', processSwitch[0].modigie__Lead_Status_Working_Verify_Employer_Limi__c);
                mMap.put('Lead_Status_Working_Verify_Employer_Usag', processSwitch[0].modigie__Lead_Status_Working_Verify_Employer_Usag__c);

                mMap.put('Lead_Status_Working_Get_Phone_Insights', processSwitch[0].modigie__Lead_Status_Working_Get_Phone_Insights__c);
                mMap.put('Lead_Status_Working_Get_Phone_Insights_A', processSwitch[0].modigie__Lead_Status_Working_Get_Phone_Insights_A__c);
                mMap.put('Lead_Status_Working_Get_Phone_Insights_L', processSwitch[0].modigie__Lead_Status_Working_Get_Phone_Insights_L__c);
                mMap.put('Lead_Status_Working_Get_Phone_Insights_U', processSwitch[0].modigie__Lead_Status_Working_Get_Phone_Insights_U__c);


                mMap.put('Lead_Status_Working_Get_LinkedIn_URL', processSwitch[0].modigie__Lead_Status_Working_Get_LinkedIn_URL__c);
                mMap.put('Lead_Status_Working_Get_LinkedIn_URL_A', processSwitch[0].modigie__Lead_Status_Working_Get_LinkedIn_URL_A__c);
                mMap.put('Lead_Status_Working_Get_LinkedIn_URL_Lim', processSwitch[0].modigie__Lead_Status_Working_Get_LinkedIn_URL_Lim__c);
                mMap.put('Lead_Status_Working_Get_LinkedIn_URL_Usa', processSwitch[0].modigie__Lead_Status_Working_Get_LinkedIn_URL_Usa__c);

                mMap.put('Unresponsive_Lead_Get_Modigie', processSwitch[0].modigie__Unresponsive_Lead_Get_Modigie__c);
                mMap.put('Unresponsive_Lead_Get_Modigie_A', processSwitch[0].modigie__Unresponsive_Lead_Get_Modigie_A__c);
                mMap.put('Unresponsive_Lead_Get_Modigie_Limit', processSwitch[0].modigie__Unresponsive_Lead_Get_Modigie_Limit__c);
                mMap.put('Unresponsive_Lead_Get_Modigie_Usage', processSwitch[0].modigie__Unresponsive_Lead_Get_Modigie_Usage__c);

                mMap.put('Unresponsive_Lead_Get_Phone_Insights', processSwitch[0].modigie__Unresponsive_Lead_Get_Phone_Insights__c);
                mMap.put('Unresponsive_Lead_Get_Phone_Insights_A', processSwitch[0].modigie__Unresponsive_Lead_Get_Phone_Insights_A__c);
                mMap.put('Unresponsive_Lead_Get_Phone_Insights_Lim', processSwitch[0].modigie__Unresponsive_Lead_Get_Phone_Insights_Lim__c);
                mMap.put('Unresponsive_Lead_Get_Phone_Insights_Usa', processSwitch[0].modigie__Unresponsive_Lead_Get_Phone_Insights_Usa__c);


                mMap.put('Unresponsive_Lead_Get_LinkedIn_URL', processSwitch[0].modigie__Unresponsive_Lead_Get_LinkedIn_URL__c);
                mMap.put('Unresponsive_Lead_Get_LinkedIn_URL_A', processSwitch[0].modigie__Unresponsive_Lead_Get_LinkedIn_URL_A__c);
                mMap.put('Unresponsive_Lead_Get_LinkedIn_URL_Limit', processSwitch[0].modigie__Unresponsive_Lead_Get_LinkedIn_URL_Limit__c);
                mMap.put('Unresponsive_Lead_Get_LinkedIn_URL_Usage', processSwitch[0].modigie__Unresponsive_Lead_Get_LinkedIn_URL_Usage__c);
                

                mMap.put('Dynamic_Criteria_Automation', processSwitch[0].modigie__Dynamic_Criteria_Automation__c);
                mMap.put('Dynamic_Criteria_Automation_A', processSwitch[0].modigie__Dynamic_Criteria_Automation_A__c);
                mMap.put('Dynamic_Criteria_Automation_Limit', processSwitch[0].modigie__Dynamic_Criteria_Automation_Limit__c);
                mMap.put('Dynamic_Criteria_Automation_Usage', processSwitch[0].modigie__Dynamic_Criteria_Automation_Usage__c);

                mMap.put('Populate_Lead_Mobile_Field', processSwitch[0].modigie__Populate_Lead_Mobile_Field__c);
                mMap.put('Populate_Contact_Mobile_Field', processSwitch[0].modigie__Populate_Contact_Mobile_Field__c);
                mMap.put('Opportunity_Limits_No_Limits_Selection', processSwitch[0].modigie__Opportunity_Limits_No_Limits_Selection__c);
                mMap.put('Opportunity_Request_Limit', processSwitch[0].modigie__Opportunity_Request_Limit__c);
                mMap.put('Data_Maintenance_LimitsNoLimitsSelection', processSwitch[0].modigie__Data_Maintenance_LimitsNoLimitsSelection__c);
                mMap.put('ProactiveHighVeloctyPipeline_Visibility', processSwitch[0].modigie__ProactiveHighVeloctyPipeline_Visibility__c);
                // mMap.put('Send_Limit_Reached_Email_To_All_Admin', processSwitch[0].modigie__Send_Limit_Reached_Email_To_All_Admin__c);


                return JSON.serialize(mMap);
            }
            else{
                throw new TemplatesComponentControllerException('Please reauthorize and submit the credentials.');
            }
        }
        catch(System.QueryException e){
            throw new TemplatesComponentControllerException('User does not have permission to query process builder switch custom settings.');
        }
        catch(Exception e){
            throw new TemplatesComponentControllerException(e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static void changeProcessToggle(String fieldName,Boolean switchState){
    	try{
            String query = 'SELECT modigie__' + fieldName + '__c,modigie__Selected_time_interval_phone_insights__c,modigie__Selected_time_interval_validate_employer__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1';
            
            Map<String, String> securityMap = new Map<String, String>();
            securityMap.put('modigie__' + fieldName + '__c' , 'modigie__Process_Builder_Switch__c');
            
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);


            List<modigie__Process_Builder_Switch__c> processSwitch = Database.query(query);
            
                // [SELECT modigie__Lead_From_Web__c FROM modigie__Process_Builder_Switch__c LIMIT 1];
        
            processSwitch[0].put('modigie__'+fieldName+'__c',switchState);
            
            if(check){
                if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
                FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__'+fieldName+'__c')&&
                FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__'+fieldName+'__c')){
                    update processSwitch;
                }
            }
            else{
                throw new TemplatesComponentControllerException('User does not have permission to query process builder switch custom settings.');
            }
            System.debug('FieldName -->>' + fieldName);
        
          /*  if(fieldName?.equalsIgnoreCase('Phone_Insights_Data_Maintenance') == true){
                if(switchState){
                    changeTimeBasedMaintainence('Selected_time_interval_phone_insights',(String)processSwitch[0].get('modigie__Selected_time_interval_phone_insights__c'));
                }
                else{
                    List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Phone Insights Data Maintenance%' WITH SECURITY_ENFORCED];
                    List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
                    
                    for(CronTrigger ct : lstCt){
                        System.abortJob((String)ct.Id);
                    }  
                }
            }*/
            if(fieldName?.equalsIgnoreCase('Validate_Employer_Data_Maintenance') == true){
                System.debug('Field Name -->>> ' + fieldName);
                if(switchState){
                    changeTimeBasedMaintainence('Selected_time_interval_validate_employer',(String)processSwitch[0].get('modigie__Selected_time_interval_validate_employer__c'));
                }
                else{
                    List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Verify Employer Data Maintenance%' WITH SECURITY_ENFORCED];
                    List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
                    
                    for(CronTrigger ct : lstCt){
                        System.abortJob((String)ct.Id);
                    }
                }   
            }
            else if(fieldName?.equalsIgnoreCase('Unresponsive_Lead_Get_Modigie') == true || fieldName?.equalsIgnoreCase('Unresponsive_Lead_Verify_Employer')){
                if(switchState){
                    List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Unresposive Lead Schedule' WITH SECURITY_ENFORCED];
                    List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
                    
                    for(CronTrigger ct : lstCt){
                        System.abortJob((String)ct.Id);
                    }
                    UnresponsiveLeadScheduleClass.scheduleMe();           
                }
                else{
                    List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Unresposive Lead Schedule' WITH SECURITY_ENFORCED];
                    List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
                    
                    for(CronTrigger ct : lstCt){
                        System.abortJob((String)ct.Id);
                    }
                }
            }
        }
        catch(System.QueryException e){
            throw new TemplatesComponentControllerException('User does not have permission to query process builder switch custom settings.');
        }
        catch(Exception e){
            throw new TemplatesComponentControllerException(e.getMessage());
        }   
    }
    
    @AuraEnabled
    public static void changeTimeBasedMaintainence(String fieldName,String value){
        try{   
            String query = 'SELECT modigie__' + fieldName + '__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1';
            
            Map<String, String> securityMap = new Map<String, String>();
            securityMap.put('modigie__' + fieldName + '__c' , 'modigie__Process_Builder_Switch__c');
            
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);

            List<modigie__Process_Builder_Switch__c> processSwitch = Database.query(query);

            if(processSwitch.size() > 0){
                processSwitch[0].put('modigie__'+fieldName+'__c',value);
                //System.debug(fieldName+'-->'+value);
                if(fieldName == 'Data_Maintenance_LimitsNoLimitsSelection'){
                    if(value == 'Limits'){
                		processSwitch[0].put('modigie__Maintain_Queue_Sales_Engagement__c',true);
                    }else if(value == 'No Limits'){
                        processSwitch[0].put('modigie__Maintain_Queue_Sales_Engagement__c',false);
                    }
                }
            }
            

            if(check){
                if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
                FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__'+fieldName+'__c')&&
                FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__'+fieldName+'__c')){
                    if(fieldName == 'Data_Maintenance_LimitsNoLimitsSelection'){
                        if(FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Maintain_Queue_Sales_Engagement__c')&&
                        FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Maintain_Queue_Sales_Engagement__c')){
                        	update processSwitch;
                        }
                    }else{
                        update processSwitch;
                    }
                }
            }
            else{
                throw new TemplatesComponentControllerException('User does not have permission to query process builder switch custom settings.');
            }
            
      /*  if(fieldName?.equalsIgnoreCase('Selected_time_interval_phone_insights') == true){
                
                List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Phone Insights Data Maintenance%' WITH SECURITY_ENFORCED];
                List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
                
                for(CronTrigger ct : lstCt){
                    System.abortJob((String)ct.Id);
                }
            
                if(value?.equalsIgnoreCase('Monthly') == true){
                    system.schedule('Modigie Phone Insights Data Maintenance Job 1', '0 0 0 1 * ? *', new PhoneInsightsSchedulableClass());
                }
                
                else if(value?.equalsIgnoreCase('Quarterly') == true){
                    system.schedule('Modigie Phone Insights Data Maintenance Job 1', '0 0 0 1 1 ? *', new PhoneInsightsSchedulableClass());
                    system.schedule('Modigie Phone Insights Data Maintenance Job 2', '0 0 0 1 4 ? *', new PhoneInsightsSchedulableClass());
                    system.schedule('Modigie Phone Insights Data Maintenance Job 3', '0 0 0 1 7 ? *', new PhoneInsightsSchedulableClass());
                    system.schedule('Modigie Phone Insights Data Maintenance Job 4', '0 0 0 1 10 ? *', new PhoneInsightsSchedulableClass());
                }
            
                else if(value?.equalsIgnoreCase('Yearly') == true){
                    system.schedule('Modigie Phone Insights Data Maintenance Job 1', '0 0 0 1 1 ? *', new PhoneInsightsSchedulableClass());
                }
                else if(value?.equalsIgnoreCase('Half - yearly') == true){
                    system.schedule('Modigie Phone Insights Data Maintenance Job 1', '0 0 0 1 1 ? *', new PhoneInsightsSchedulableClass());
                    system.schedule('Modigie Phone Insights Data Maintenance Job 2', '0 0 0 1 7 ? *', new PhoneInsightsSchedulableClass());
                }
            }*/
            
            if(fieldName?.equalsIgnoreCase('Selected_time_interval_validate_employer') == true){
                System.debug('In scheduling if');
                List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Verify Employer Data Maintenance%' WITH SECURITY_ENFORCED];
                List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
                
                for(CronTrigger ct : lstCt){
                    System.abortJob((String)ct.Id);
                }
                System.debug(value);
                System.debug(value?.equalsIgnoreCase('Half - yearly'));
                if(value?.equalsIgnoreCase('Monthly') == true){
                    system.schedule('Modigie Verify Employer Data Maintenance Job 1', '0 0 0 1 * ? *', new ValidateEmployerSchedulableClass());
                }
                
                else if(value?.equalsIgnoreCase('Quarterly') == true){
                    system.schedule('Modigie Verify Employer Data Maintenance Job 1', '0 0 0 1 1 ? *', new ValidateEmployerSchedulableClass());
                    system.schedule('Modigie Verify Employer Data Maintenance Job 2', '0 0 0 1 4 ? *', new ValidateEmployerSchedulableClass());
                    system.schedule('Modigie Verify Employer Data Maintenance Job 3', '0 0 0 1 7 ? *', new ValidateEmployerSchedulableClass());
                    system.schedule('Modigie Verify Employer Data Maintenance Job 4', '0 0 0 1 10 ? *', new ValidateEmployerSchedulableClass());
                }
            
                else if(value?.equalsIgnoreCase('Yearly') == true){
                    system.schedule('Modigie Verify Employer Data Maintenance Job 1', '0 0 0 1 1 ? *', new ValidateEmployerSchedulableClass());
                }
                else if(value?.equalsIgnoreCase('Half - yearly') == true){
                    system.schedule('Modigie Verify Employer Data Maintenance Job 1', '0 0 0 1 1 ? *', new ValidateEmployerSchedulableClass());
                    system.schedule('Modigie Verify Employer Data Maintenance Job 2', '0 0 0 1 7 ? *', new ValidateEmployerSchedulableClass());
                }
            }
        } 
        catch(System.QueryException e){
            throw new TemplatesComponentControllerException('User does not have permission to query process builder switch custom settings.');
        }
        catch(Exception e){
            throw new TemplatesComponentControllerException(e.getMessage());
        }   
    }
    
    @AuraEnabled
    public static void setInvocableLimits(String fieldName,Integer value){
        try{
            String query = 'SELECT modigie__' + fieldName + '__c';    //FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1';
            
            System.debug('FIELD NAME --->>' + fieldName);
            if(fieldName?.equalsIgnoreCase('Get_Modigie_Campaign_Invocable_Limits') == true || fieldName?.equalsIgnoreCase('Get_Modigie_Invocable_Limit') == true  || fieldName?.equalsIgnoreCase('Linkedin_Url_Campaign_Limits') == true  || fieldName?.equalsIgnoreCase('LinkedIn_Url_Invocable_Limits') == true || fieldName?.equalsIgnoreCase('Modigie_Phone_Insights_Invocable_Limit') == true  ||  fieldName?.equalsIgnoreCase('Phone_Insights_Data_Maintenance_Limits') == true  || fieldName?.equalsIgnoreCase('Unresponsive_Lead_Invocable_Limits') == true  || fieldName?.equalsIgnoreCase('Validate_employer_campaign_Limits') == true  || fieldName?.equalsIgnoreCase('Validate_Employer_Invocable_Limit') == true  || fieldName?.equalsIgnoreCase('Validate_Employer_Data_Maintenance_Lmt') == true){
                query += ', modigie__' + fieldName + '_A__c';
            }
            else if(fieldName?.equalsIgnoreCase('Unresponsive_Lead_Get_Modigie_Limit') == true){
                query += ', modigie__Unresponsive_Lead_Get_Modigie_A__c';
            }
            else if(fieldName?.equalsIgnoreCase('Unresponsive_Lead_Verify_Employer_Limit') == true){
                query += ', modigie__Unresponsive_Lead_Verify_Employer_A__c';
            }
            else if(fieldName?.equalsIgnoreCase('Opportunity_Contact_Get_Modigie_Limit') == true){
                query += ', modigie__Opportunity_Contact_Get_Modigie_A__c';
            }
            else if(fieldName?.equalsIgnoreCase('Dynamic_Criteria_Automation_Limit') == true){
                query += ', modigie__Dynamic_Criteria_Automation_A__c';
            }

            query += ' FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1';

            Map<String, String> securityMap = new Map<String, String>();
            securityMap.put('modigie__' + fieldName + '__c' , 'modigie__Process_Builder_Switch__c');
            
           // Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);

            List<modigie__Process_Builder_Switch__c> processSwitch = Database.query(query);
            
            if(processSwitch.size() > 0){
                processSwitch[0].put('modigie__'+fieldName+'__c',value);
                if(fieldName?.equalsIgnoreCase('Get_Modigie_Campaign_Invocable_Limits') == true  || fieldName?.equalsIgnoreCase('Get_Modigie_Invocable_Limit') == true || fieldName?.equalsIgnoreCase('Linkedin_Url_Campaign_Limits') == true || fieldName?.equalsIgnoreCase('LinkedIn_Url_Invocable_Limits') == true || fieldName?.equalsIgnoreCase('Modigie_Phone_Insights_Invocable_Limit') == true || fieldName?.equalsIgnoreCase('Opp_Contact_Enrichment_Invocable_Limit') == true || fieldName?.equalsIgnoreCase('Phone_Insights_Data_Maintenance_Limits') == true || fieldName?.equalsIgnoreCase('Unresponsive_Lead_Invocable_Limits') == true || fieldName?.equalsIgnoreCase('Validate_employer_campaign_Limits') == true || fieldName?.equalsIgnoreCase('Validate_Employer_Invocable_Limit') == true || fieldName?.equalsIgnoreCase('Validate_Employer_Data_Maintenance_Lmt') == true){
                    processSwitch[0].put('modigie__'+fieldName+'_A__c',UserInfo.getUserId());
                }    
            }
            
        //   if(check){
            if(fieldName?.equalsIgnoreCase('Unresponsive_Lead_Get_Modigie_Limit') == true){
                if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
                FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Unresponsive_Lead_Get_Modigie_A__c')&&
                FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Unresponsive_Lead_Get_Modigie_A__c')){
                    update processSwitch;
                }
            }
            else if(fieldName?.equalsIgnoreCase('Unresponsive_Lead_Verify_Employer_Limit') == true){
                if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
                FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Unresponsive_Lead_Verify_Employer_A__c')&&
                FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Unresponsive_Lead_Verify_Employer_A__c')){
                    update processSwitch;
                }
            }
            else if(fieldName?.equalsIgnoreCase('Opportunity_Contact_Get_Modigie_Limit') == true){
                update processSwitch;    
            }

            else if(fieldName?.equalsIgnoreCase('Dynamic_Criteria_Automation_Limit') == true){
                processSwitch[0].put('modigie__Dynamic_Criteria_Automation_A__c',UserInfo.getUserId());
                update processSwitch;
            }
            
            else{
                if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
                FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__'+fieldName+'_A__c')&&
                FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__'+fieldName+'_A__c')){
                    update processSwitch;
                }
            }
            
            
              
            
            
          //  }
           // else{
             //   throw new TemplatesComponentControllerException('You does not have permission to edit modigie job automation settings.');
            //}
        }   
        catch(Exception e){
            System.debug('Error in Templates Component -- > ' + e.getLineNumber());
            throw new TemplatesComponentControllerException(e.getMessage());
        } 
    }
    
    @AuraEnabled
    public static void setPhoneNumberForInsights(String data){
    	try{
            List<modigie__Process_Builder_Switch__c> lstSwitch =  [SELECT Id, modigie__Get_Phone_Insights_Phone_Number_Selected__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
            
            if(lstSwitch.size() > 0){
                lstSwitch[0].modigie__Get_Phone_Insights_Phone_Number_Selected__c = data;
            }
            else{
                modigie__Process_Builder_Switch__c element = new modigie__Process_Builder_Switch__c(modigie__Get_Phone_Insights_Phone_Number_Selected__c = data);
                lstSwitch.add(element);
            }
            if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
               FieldLevelSecurityCheck.canCreateObject('modigie__Process_Builder_Switch__c')&&
               FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Get_Phone_Insights_Phone_Number_Selected__c')&&
               FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Get_Phone_Insights_Phone_Number_Selected__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c', 'modigie__Get_Phone_Insights_Phone_Number_Selected__c')){
                   upsert lstSwitch;
               }
            else{
                throw new TemplatesComponentControllerException('User does not have permission to query process builder switch custom settings.');
            }
        }
        catch(System.QueryException e){
            throw new TemplatesComponentControllerException('User does not have permission to query process builder switch custom settings.');
        }
        catch(Exception e){
            throw new TemplatesComponentControllerException(e.getMessage());
        }   
    }
    
    @AuraEnabled
    public static String getPhoneNumberForInsights(){
        try{
            List<modigie__Process_Builder_Switch__c> lstSwitch =  [SELECT Id, modigie__Get_Phone_Insights_Phone_Number_Selected__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
            
            if(lstSwitch.size() > 0){
                return lstSwitch[0].modigie__Get_Phone_Insights_Phone_Number_Selected__c;
            }
            else{
                Map<String,String> tempMap = new Map<String,String>();
                
                tempMap.put('selectedFieldsContact','Mobile,');
                tempMap.put('selectedFieldsLead','Mobile');
                
                modigie__Process_Builder_Switch__c element = new modigie__Process_Builder_Switch__c(modigie__Get_Phone_Insights_Phone_Number_Selected__c = JSON.serialize(tempMap));
      

                if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
                   FieldLevelSecurityCheck.canCreateObject('modigie__Process_Builder_Switch__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Get_Phone_Insights_Phone_Number_Selected__c')&&
                   FieldLevelSecurityCheck.canCreateField('modigie__Process_Builder_Switch__c', 'modigie__Get_Phone_Insights_Phone_Number_Selected__c')){
                       insert element;
                   }
                else{
                    throw new TemplatesComponentControllerException('User does not have permission to query process builder switch custom settings.');
                }
                return JSON.serialize(tempMap);
            }
        }
        catch(System.QueryException e){
            throw new TemplatesComponentControllerException('User does not have permission to query process builder switch custom settings.');
        }
        catch(Exception e){
            throw new TemplatesComponentControllerException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List <string> fetchLeadStages()
    {
        List<String> leadStages = new List<String>();
		Schema.DescribeFieldResult fieldResult = Lead.Status.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			leadStages.add(pickListVal.getLabel());
		}     
		return leadStages;
    }
    
    @AuraEnabled
    public static void getLeadStages(String strList)
    {
        
        List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Selected_Lead_Status__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED  LIMIT 1];
        
        if(lstPbs.size() > 0){
            lstPbs[0].modigie__Selected_Lead_Status__c = strList;
            
            if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
               FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Selected_Lead_Status__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c', 'modigie__Selected_Lead_Status__c')){
                   update lstPbs;
               }
        }
        else{
        }
    }
    
    
    
    
    @AuraEnabled
    public static List <string> fetchOppStages()
    {
        List<String> oppStages = new List<String>();
		Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			oppStages.add(pickListVal.getLabel());
		}     
		return oppStages;
    }
    
    @AuraEnabled
    public static void getOppStages(String strList, String opportunityLimitsNoLimits, Integer opportunityRequestLimit)
    {
        
        List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Selected_Opportunity_Stages__c, modigie__Opportunity_Limits_No_Limits_Selection__c, modigie__Opportunity_Request_Limit__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED  LIMIT 1];
        
        if(lstPbs.size() > 0){
            lstPbs[0].modigie__Selected_Opportunity_Stages__c = strList;
            lstPbs[0].modigie__Opportunity_Limits_No_Limits_Selection__c = opportunityLimitsNoLimits;
            lstPbs[0].modigie__Opportunity_Request_Limit__c = opportunityRequestLimit;
            
            if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
               FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Selected_Opportunity_Stages__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c', 'modigie__Selected_Opportunity_Stages__c')){
                   update lstPbs;
               }
        }
    }
    @AuraEnabled
    public static void setMaintainQueue(Boolean maintainQueueState){
        
        List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT modigie__Maintain_Queue_Sales_Engagement__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED  LIMIT 1];
        
        if(!lstPbs.isEmpty()){
            lstPbs[0].modigie__Maintain_Queue_Sales_Engagement__c = maintainQueueState;
            
            if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
               FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c', 'modigie__Maintain_Queue_Sales_Engagement__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c', 'modigie__Maintain_Queue_Sales_Engagement__c')){
                   update lstPbs;
               }
        }
        
    }

    @AuraEnabled
    public static Map<String, Object> getAnalysisData(String rulesetId){
        try {
            Map<String, Object> resultMap = RuleSetClass.getAnalysis(rulesetId);
            System.debug(resultMap);
            return resultMap; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    
    // ----------------   create new ruleset fumctions ----------------
    
    @AuraEnabled
    public static string saveRulesetDetails(Map<String,String> rulesetDetails, List<List<Map<String,String>>> criteriaList, String editRulesetId){
        try {
           system.debug('hello value...... '+ rulesetDetails.get('creditRecordId'));
            String creditRecordId =  rulesetDetails.get('creditRecordId');
            Boolean onlyOnCreate = false, isLimit = false, maintainQueue = false, isActive = false, isPerformance = false;
            Integer numberOfRequests = 0, leadSelectedLogic = 0, contactSelectedLogic = 0;
            System.debug('details------'+rulesetDetails);
            if(rulesetDetails.get('isPerformance') == 'true'){
                isPerformance = true;
            }
            if(rulesetDetails.get('automationTrigger') == '1'){
                onlyOnCreate = true;
            }
            if(rulesetDetails.get('Limits_No_Limits_Selection') == 'Limits'){
                isLimit = true;
            }
            if(rulesetDetails.get('maintainQueue') == 'true'){
                maintainQueue = true;
            }
            if(rulesetDetails.get('isActive') == 'true'){
                isActive = true;
            }
            if(rulesetDetails.get('numberOfRequests') != null){
                numberOfRequests = Integer.valueOf(rulesetDetails.get('numberOfRequests'));
            }
            
            if(rulesetDetails.get('leadSelectedLogic') != null){
                leadSelectedLogic = Integer.valueOf(rulesetDetails.get('leadSelectedLogic'));
            }

            if(rulesetDetails.get('contactSelectedLogic') != null){
                contactSelectedLogic = Integer.valueOf(rulesetDetails.get('contactSelectedLogic'));
            }
            System.debug('------>'+ creditRecordId);
            modigie__creditAccountDetails__c creditDetail = new modigie__creditAccountDetails__c();
            if(isPerformance){
                creditDetail = [SELECT modigie__Credit_Id__c , modigie__Title__c, modigie__isPerformance__c FROM modigie__creditAccountDetails__c WHERE modigie__isPerformance__c = true ];
            }
            else{
                creditDetail = [SELECT modigie__Credit_Id__c , modigie__Title__c FROM modigie__creditAccountDetails__c WHERE Id =: creditRecordId ];
            }

            if(editRulesetId != null && editRulesetId != 'undefined'){
                System.debug('Editing the ruleSet from here');
                //edit ------- update
                modigie__Modigie_Rule_Sets__c ruleset = [SELECT modigie__isActive__c, modigie__isLimit__c, modigie__OnlyOnCreate__c, modigie__Contact_Logic_Type__c, modigie__Contact_Custom_Logic__c, modigie__Maintain_Queue__c, modigie__Lead_Logic_Type__c, modigie__Lead_Custom_Logic__c, modigie__Limit__c, Id, Name, modigie__Rule_Set_Name__c, modigie__Rule_Set_Description__c , modigie__CreditId__c , modigie__Credit_Record_Id__c , modigie__Credit_Title__c FROM modigie__Modigie_Rule_Sets__c WHERE Id =: editRulesetId LIMIT 1];
                
                system.debug('final value... '+creditDetail );

                ruleset.modigie__Rule_Set_Name__c = rulesetDetails.get('title');
                ruleset.modigie__Rule_Set_Description__c = rulesetDetails.get('description');

                if(numberOfRequests > ruleset.modigie__Limit__c){
                    ruleset.modigie__Email_Limit_Sent__c = false;
                }
                ruleset.modigie__Limit__c = numberOfRequests;
                ruleset.modigie__Lead_Custom_Logic__c = rulesetDetails.get('leadLogic');
                ruleset.modigie__Lead_Logic_Type__c = leadSelectedLogic;
                ruleset.modigie__Maintain_Queue__c = maintainQueue;
                ruleset.modigie__Contact_Custom_Logic__c = rulesetDetails.get('contactLogic');
                ruleset.modigie__Contact_Logic_Type__c	= contactSelectedLogic;
                ruleset.modigie__OnlyOnCreate__c = onlyOnCreate;
                ruleset.modigie__isLimit__c = isLimit;
                ruleset.modigie__CreditId__c = creditDetail.modigie__Credit_Id__c;
                ruleset.modigie__Credit_Title__c = creditDetail.modigie__Title__c;
                ruleSet.modigie__Credit_Record_Id__c = creditRecordId;
                ruleset.modigie__isPerformance__c = isPerformance;

                // ruleset.modigie__isActive__c = isActive;

                update ruleset;

                // editRulesetId = editRulesetId.subString(0,15);

                List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT Id, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__Rule_Set_Id__c FROM modigie__Modigie_Automation_Criteria_Lead__c WHERE modigie__Rule_Set_Id__c =: editRulesetId];
                
                if(!lstLeadCriteria.isEmpty()){
                    delete lstLeadCriteria;
                }

                List<modigie__Modigie_Automation_Criteria_Lead__c> insertCriteriaLead = new List<modigie__Modigie_Automation_Criteria_Lead__c>();
                
                if(!criteriaList[0].isEmpty()){
                    Integer i = 0;
                    for(Map<String,String> leadCriteria : criteriaList[0]){
                        String uniqueStringForLead = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
                        insertCriteriaLead.add(new modigie__Modigie_Automation_Criteria_Lead__c(Name = uniqueStringForLead, modigie__Field_Order__c = i, modigie__Field_Value__c = leadCriteria.get('CriteriaValue'), modigie__Operator__c = leadCriteria.get('SelectedOperator'), modigie__Field_Api_Name__c = leadCriteria.get('SelectedField'), modigie__Rule_Set_Id__c = editRulesetId));
                        i++;
                    }
                    
                    insert insertCriteriaLead;
                }


                List<modigie__Modigie_Automation_Criteria_Contact__c> lstConCriteria = [SELECT Id, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__Rule_Set_Id__c FROM modigie__Modigie_Automation_Criteria_Contact__c WHERE modigie__Rule_Set_Id__c =: editRulesetId];
                
                if(!lstConCriteria.isEmpty()){
                    delete lstConCriteria;
                }
                
                
                List<modigie__Modigie_Automation_Criteria_Contact__c> insertCriteriaCon = new List<modigie__Modigie_Automation_Criteria_Contact__c>();
                
                if(!criteriaList[1].isEmpty()){
                    Integer i = 0;
                    for(Map<String,String> conCriteria : criteriaList[1]){
                        String uniqueStringForContact = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
                        insertCriteriaCon.add(new modigie__Modigie_Automation_Criteria_Contact__c(Name = uniqueStringForContact, modigie__Field_Order__c = i, modigie__Field_Value__c = conCriteria.get('CriteriaValue'), modigie__Operator__c = conCriteria.get('SelectedOperator'), modigie__Field_Api_Name__c = conCriteria.get('SelectedField'), modigie__Rule_Set_Id__c = editRulesetId));
                        i++;
                    }
                    
                    insert insertCriteriaCon;
                }
            }
            else{
                //create -------- insert

            

                String uniqueString = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
                System.debug(uniqueString);

                modigie__Modigie_Rule_Sets__c newRuleset = new modigie__Modigie_Rule_Sets__c(
                    Name = uniqueString,
                    modigie__Rule_Set_Name__c = rulesetDetails.get('title'),
                    modigie__Rule_Set_Description__c = rulesetDetails.get('description'),
                    modigie__Limit__c = numberOfRequests,
                    modigie__Lead_Custom_Logic__c = rulesetDetails.get('leadLogic'),
                    modigie__Lead_Logic_Type__c = leadSelectedLogic,
                    modigie__Maintain_Queue__c = maintainQueue,
                    modigie__Contact_Custom_Logic__c = rulesetDetails.get('contactLogic'),
                    modigie__Contact_Logic_Type__c	= contactSelectedLogic,
                    modigie__OnlyOnCreate__c = onlyOnCreate,
                    modigie__isLimit__c = isLimit,
                    modigie__isActive__c = isActive,
                    modigie__Credit_Title__c = creditDetail.modigie__Title__c,
                    modigie__CreditId__c = creditDetail.modigie__Credit_Id__c,
                    modigie__Credit_Record_Id__c = creditRecordId,
                    modigie__isPerformance__c = isPerformance
                    
                    );
                // insert newRuleset;
                Database.SaveResult sr = Database.insert(newRuleset);
                String rulesetId;
                if(sr.isSuccess()){
                    rulesetId = sr.getId();
                    // rulesetId = rulesetId.subString(0,15);
                    // rulesetId = 'a0E1U00000JsLuQ';
                    // return rulesetId;
                }

                System.debug(criteriaList);

                List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT Id, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__Rule_Set_Id__c FROM modigie__Modigie_Automation_Criteria_Lead__c WHERE modigie__Rule_Set_Id__c =: rulesetId];
                
                if(!lstLeadCriteria.isEmpty()){
                    delete lstLeadCriteria;
                }

                List<modigie__Modigie_Automation_Criteria_Lead__c> insertCriteriaLead = new List<modigie__Modigie_Automation_Criteria_Lead__c>();
                
                if(!criteriaList[0].isEmpty()){
                    Integer i = 0;
                    for(Map<String,String> leadCriteria : criteriaList[0]){
                        String uniqueStringForLead = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
                        insertCriteriaLead.add(new modigie__Modigie_Automation_Criteria_Lead__c(Name = uniqueStringForLead + i, modigie__Field_Order__c = i, modigie__Field_Value__c = leadCriteria.get('CriteriaValue'), modigie__Operator__c = leadCriteria.get('SelectedOperator'), modigie__Field_Api_Name__c = leadCriteria.get('SelectedField'), modigie__Rule_Set_Id__c = rulesetId));
                        i++;
                    }
                    
                    insert insertCriteriaLead;
                }


                List<modigie__Modigie_Automation_Criteria_Contact__c> lstConCriteria = [SELECT Id, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__Rule_Set_Id__c FROM modigie__Modigie_Automation_Criteria_Contact__c WHERE modigie__Rule_Set_Id__c =: rulesetId];
                
                if(!lstConCriteria.isEmpty()){
                    delete lstConCriteria;
                }
                
                
                List<modigie__Modigie_Automation_Criteria_Contact__c> insertCriteriaCon = new List<modigie__Modigie_Automation_Criteria_Contact__c>();
                
                if(!criteriaList[1].isEmpty()){
                    Integer i = 0;
                    String uniqueStringForContact = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
                    for(Map<String,String> conCriteria : criteriaList[1]){
                        insertCriteriaCon.add(new modigie__Modigie_Automation_Criteria_Contact__c(Name = uniqueStringForContact + i, modigie__Field_Order__c = i, modigie__Field_Value__c = conCriteria.get('CriteriaValue'), modigie__Operator__c = conCriteria.get('SelectedOperator'), modigie__Field_Api_Name__c = conCriteria.get('SelectedField'), modigie__Rule_Set_Id__c = rulesetId));
                        i++;
                    }
                    
                    insert insertCriteriaCon;
                }
            }
            

            

            return 'hii';
        } catch (Exception e) {
            system.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Object> getAllRulesets(Boolean isPerformance){
        try {
            List<modigie__Modigie_Rule_Sets__c> rulesetList = [SELECT Name, Id, modigie__Rule_Set_Name__c, modigie__Rule_Set_Description__c, modigie__isActive__c, modigie__OnlyOnCreate__c, modigie__Credit_Title__c FROM modigie__Modigie_Rule_Sets__c WHERE modigie__isPerformance__c =: isPerformance ORDER BY CreatedDate];
            System.debug(rulesetList);
            return rulesetList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string deleteTheRuleset(String rulesetId){
        try {
            List<modigie__Modigie_Rule_Sets__c> deletableRuleset = [SELECT Id, Name FROM modigie__Modigie_Rule_Sets__c WHERE Id =: rulesetId];
            System.debug(deletableRuleset);
            if(!deletableRuleset.isEmpty()){
                delete deletableRuleset;
            }
            // rulesetId = rulesetId.subString(0,15);
            List<modigie__Modigie_Automation_Criteria_Lead__c> deletableLeadCriteria = [SELECT Id, Name, modigie__Rule_Set_Id__c FROM modigie__Modigie_Automation_Criteria_Lead__c WHERE modigie__Rule_Set_Id__c =: rulesetId];
            System.debug(deletableLeadCriteria);
            if(!deletableLeadCriteria.isEmpty()){
                delete deletableLeadCriteria;
            }

            List<modigie__Modigie_Automation_Criteria_Contact__c> deletableContactCriteria = [SELECT Id, Name, modigie__Rule_Set_Id__c FROM modigie__Modigie_Automation_Criteria_Contact__c WHERE modigie__Rule_Set_Id__c =: rulesetId];
            System.debug(deletableContactCriteria);
            if(!deletableContactCriteria.isEmpty()){
                delete deletableContactCriteria;
            }
            return rulesetId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static modigie__Modigie_Rule_Sets__c changeStatus(String rulesetId){
        try {
            modigie__Modigie_Rule_Sets__c ruleset = [SELECT Id, modigie__Rule_Set_Name__c, modigie__isActive__c FROM modigie__Modigie_Rule_Sets__c WHERE Id =: rulesetId LIMIT 1];
            ruleset.modigie__isActive__c = !ruleset.modigie__isActive__c;
            update ruleset;
            return ruleset;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }        

    @AuraEnabled
    public static string saveStatus(){
        try {
            modigie__Process_Builder_Switch__c pbs = [SELECT Name, Id, modigie__Opportunity_Contact_Get_Modigie__c FROM modigie__Process_Builder_Switch__c LIMIT 1];
            pbs.modigie__Opportunity_Contact_Get_Modigie__c = !pbs.modigie__Opportunity_Contact_Get_Modigie__c;
            update pbs;
            return 'hii';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Object> getUnlockTimeAndReason(){
        try {
            modigie__TOM__c unlockDetails = [SELECT modigie__Performance_Rulesets_UnlockReason__c, modigie__Performance_Rulesets_UnlockUntilTime__c FROM modigie__TOM__c LIMIT 1];
            Boolean showWarningMessage = false;
            System.debug('unclock time---->'+unlockDetails.modigie__Performance_Rulesets_UnlockUntilTime__c);
            if(unlockDetails.modigie__Performance_Rulesets_UnlockUntilTime__c == null){
                showWarningMessage = true;
            }
            else if(unlockDetails.modigie__Performance_Rulesets_UnlockUntilTime__c < DateTime.now()){
                System.debug('stopped.........');
                showWarningMessage = true;
            }
            System.debug(unlockDetails.modigie__Performance_Rulesets_UnlockReason__c);
            String unlockReason;
            if(unlockDetails.modigie__Performance_Rulesets_UnlockUntilTime__c != null){
                unlockReason = 'Ruleset changes are only allowed until: ' + unlockDetails.modigie__Performance_Rulesets_UnlockUntilTime__c.format('MM/dd/yyyy, hh:mm:ss a',UserInfo.getTimeZone().getID()) + '. ';
            }
            else{
                unlockReason = 'You can change the rulesets.';
            }

            if(unlockDetails.modigie__Performance_Rulesets_UnlockReason__c != null){
                unlockReason += unlockDetails.modigie__Performance_Rulesets_UnlockReason__c;
            }
            Map<String,Object> resultMap = new Map<String,Object>();
            resultMap.put('showWarningMessage',showWarningMessage);
            resultMap.put('reasonString', unlockReason);
            // resultMap.put('isValuesPresent', isValuesPresent);
            return resultMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    private class TemplatesComponentControllerException extends Exception{}
}