public with sharing class TriggerOnLeadHelper 
{
    public static Boolean preventRecursion = true;
    public static Boolean aPreventRecursion = true;
    /*public static void check(List<Lead> triggernew)
    {
        try{
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Lead__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c'))
            {
                List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
                //List<modigie__Modigie__c> modiListToUpdate = new List<modigie__Modigie__c>();
                
                
                modiList = [SELECT Name, modigie__Lead__c, modigie__Status__c,modigie__Parent_Id__c FROM modigie__Modigie__c WHERE modigie__Lead__c IN :triggernew WITH SECURITY_ENFORCED];
                
                
                /* for(modigie__Modigie__c modi : modiList)
                {
                    modi.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    modiListToUpdate.add(modi);
                    }

                    if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Lead__c') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
                    FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
                    FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Lead__c')&&
                    FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Key__c'))
                    {
                    // update modiListToUpdate;
                    }
                    else{
                    throw new TriggerOnLeadHelperException('You does not have permission to edit modigie record.');
                }
                
                if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Lead__c') &&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
                   FieldLevelSecurityCheck.canDeleteObject('modigie__Modigie__c')){
                       if(!modiList.isEmpty())
                           delete modiList;
                   }
                else{
                    throw new TriggerOnLeadHelperException('You does not have permission to delete modigie record.');   
                }
            }
        }
        catch(System.QueryException e){
            throw new TriggerOnLeadHelperException('You do not have permission to query lead, contact or modigie fields.');
        }
        catch(Exception e){
            throw new TriggerOnLeadHelperException(e.getMessage());
        }
    }*/
    
    public static void updateValidateNumber(List<Lead> triggernew)
    {
        try
        {
            List<Lead> leadList = new List<Lead>();
            
            if(FieldLevelSecurityCheck.canReadObject('Lead') &&
               FieldLevelSecurityCheck.canUpdateObject('Lead') &&
               FieldLevelSecurityCheck.canReadField('Lead','Id')&&
               FieldLevelSecurityCheck.canReadField('Lead','modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Lead','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Validation_Key__c'))
            {
                for(Lead l : triggernew)
                {
                    Lead lea = new Lead(Id = l.Id);
                    lea.modigie__Modigie_Verified_Number__c = '';
                    lea.modigie__Alternate_Mobile_Phone_Available__c='';
                    lea.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    leadList.add(lea);
                }
                update leadList;
            }
        }
        catch(Exception e)
        {
        }
    }
    
    public static void updateModigieOnLeadConvert(List<Lead> triggerNew,List<Lead> triggerOld){
        try
        {
            System.debug('insideUpdateLeadConvert');
            if(FieldLevelSecurityCheck.canReadObject('Lead')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c'))
            {
                List<modigie__Modigie__c> lstModigie = [SELECT Id, modigie__Verified_Phone_Get_Phone_Insights__c, modigie__Contact__c, modigie__Lead__c, modigie__Mobile__c, modigie__Status__c, modigie__Date_Last_Updated__c, modigie__Validation_Key__c, modigie__Jobid__c, modigie__Job_start__c, modigie__Company_Name_Matches_Public_Records__c, modigie__Modigie_Validated_Mobile_Contact_Number__c, modigie__StatusFormula__c, modigie__JOB_ID__c, modigie__Job_end__c, modigie__Response_time__c, modigie__Parent_Id__c, modigie__Linkedin_URL__c, modigie__Phone_Name_Match__c, modigie__Line_Activity__c, modigie__Phone_Type__c, modigie__Best_Time_to_Call__c, modigie__Day_of_Week_Detail__c, modigie__LinkedIn_Url_Get_Mobile_Number__c, modigie__Current_Employer__c, modigie__Current_Title__c, modigie__Current__c, modigie__LinkedIn_Url_Verify_Employer__c, modigie__Linkedin_Validation_Date__c, modigie__Get_Number_Intelligence_Date__c, modigie__Currrent_Employer_Validation_Date__c, modigie__Linkedin_Job_Id__c, modigie__Linkedin_Status__c, modigie__Street_Address__c, modigie__City__c, modigie__State__c, modigie__Get_Modigie_Job_Status__c, modigie__Get_Modigie_Id__c, modigie__Get_LinkedIn_Job_Status__c, modigie__Validate_Employer_Job_Status__c, modigie__Validate_Employer_Job_Id__c, modigie__Get_Phone_Intelligence_Job_Id__c, modigie__Get_Phone_Intelligence_Job_Status__c, modigie__Validate_Employer_Status__c, modigie__Phone_Intelligence_Status__c, modigie__Name_Get_Mobile_Number__c, modigie__Name_Get_LinkedIn__c, modigie__Name_Verify_Employer__c, modigie__Name_Get_Phone_Insights_Mobile__c, modigie__Name_Get_Phone_Insights_Phone__c, modigie__Zip__c, modigie__Country__c, modigie__Name_Get_Phone_Insights_Other_Phone__c, modigie__Mobile_Phone_Formula__c, modigie__Carrier_Name_Mobile__c, modigie__Carrier_Name_Phone__c, modigie__Carrier_Name_Other_Phone__c, modigie__Current_Employer_Get_Modigie__c, modigie__Company_Name_Matches_Records_Get_Modigie__c, modigie__Current_Title_Get_Modigie__c, modigie__Current_Country_Get_Modigie__c, modigie__Mobile_2__c, modigie__Mobile_3__c, modigie__Accuracy_Match_Phone__c, modigie__Accuracy_Match_Modigie_Validated_Number__c, modigie__Accuracy_Match_Alternate_Number1__c, modigie__Accuracy_Match_Alternate_Number2__c, modigie__Accuracy_Match_Other_Phone__c, modigie__Day_of_Week_Detail_Phone__c, modigie__Day_of_Week_Detail_Modigie_Val_Number__c, modigie__Day_of_Week_Detail_Alternate_Number1__c, modigie__Day_of_Week_Detail_Alternate_Number2__c, modigie__Day_of_Week_Detail_Other_Phone__c, modigie__Get_Phone_Intelligence_Job_Id_Phone__c, modigie__Get_Phone_Intelligence_Job_Id_Val_Number__c, modigie__Get_Phone_Intelligence_Job_Id_Alternate1__c, modigie__Get_Phone_Intelligence_Job_Id_Alternate2__c, modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c, modigie__Get_Phone_Intelligence_Job_Status_Phone__c, modigie__Get_Phone_Intelligence_Job_Status_ValNum__c, modigie__Get_Phone_Intelligence_Job_Status_Alt1__c, modigie__Get_Phone_Intelligence_Job_Status_Alt2__c, modigie__Get_Phone_Intelligence_Job_Status_OPhone__c, modigie__Line_Activity_Phone__c, modigie__Line_Activity_Modigie_Validated_Number__c, modigie__Line_Activity_Alternate1__c, modigie__Line_Activity_Alternate2__c, modigie__Line_Activity_Other_Phone__c, modigie__Phone_Type_Phone__c, modigie__Phone_Type_Modigie_Validated_Number__c, modigie__Phone_Type_Alternate_Number1__c, modigie__Phone_Type_Alternate_Number2__c, modigie__Phone_Type_Other_Phone__c, modigie__Best_Time_to_Call_Phone__c, modigie__Best_Time_to_Call_Validated_Number__c, modigie__Best_Time_to_Call_Alternate_Number1__c, modigie__Best_Time_to_Call_Alternate_Number2__c, modigie__Best_Time_to_Call_Phone_Other_Phone__c, modigie__Phone_Intelligence_Status_Phone__c, modigie__Phone_Intelligence_Status_Modigie_Number__c, modigie__Phone_Intelligence_Status_Alt_Number1__c, modigie__Phone_Intelligence_Status_Alt_Number2__c, modigie__Phone_Intelligence_Status_Other_Phone__c, modigie__Verified_Phone_Get_Phone_Insights_Phone__c, modigie__Verified_Phone_Get_Phone_Insights_ValNum__c, modigie__Verified_Phone_Get_Phone_Insights_Alt1__c, modigie__Verified_Phone_Get_Phone_Insights_Alt2__c, modigie__Verified_Phone_Get_Phone_Insights_OPhone__c, modigie__Get_Number_Intelligence_Date_Phone__c, modigie__Get_Number_Intelligence_Date_Val_Number__c, modigie__Get_Number_Intelligence_Date_Alt1__c, modigie__Get_Number_Intelligence_Date_Alt2__c, modigie__Get_Number_Intelligence_Date_Other_Phone__c, modigie__Validation_Date_Get_Mobile_Number__c, modigie__Validation_Date_Get_LinkedIn__c, modigie__Validation_Date_Mobile__c, modigie__Validation_Date_Verify_Employer__c, modigie__Validation_Date_Phone__c, modigie__Validation_Date_Other_Phone__c, modigie__Validation_Date_Modigie_Val_Phone_Number__c, modigie__Validation_Date_Alternate_Number1__c, modigie__Validation_Date_Alternate_Number2__c, modigie__User_GetModigieMobile__c, modigie__Campaign_Id_GetLinkedin__c, modigie__Campaign_Id_GetPhoneInsight__c, modigie__Campaign_Id_VerifyEmployer__c, modigie__Campaign_Id_GetMobileNumber__c, modigie__Get_Linkedin_Campaign_User__c, modigie__Get_Mobile_Campaign_User__c, modigie__Get_Phone_Insight_Campaign_User__c, modigie__Verify_Employer_Campaign_User__c, modigie__User_GetLinkedin__c, modigie__User_VerifyEmployer__c, modigie__User_PhoneInsights__c, modigie__Best_time_to_call_tuesday__c, modigie__Best_time_to_call_wednesday__c, modigie__Best_time_to_call_thursday__c, modigie__Best_time_to_call_friday__c, modigie__Best_time_to_call_timezone__c, modigie__Locale_Overall_Best_Time_to_Call_Mobile__c, modigie__Locale_Overall_Best_Time_to_Call_Phone__c, modigie__Locale_Overall_Best_Time_to_Call_O__c, modigie__Phone_Insights_User_Locale_Mobile__c, modigie__Phone_Insights_User_Locale_Phone__c, modigie__Phone_Insights_User_Locale_Other_Phone__c, modigie__Formatted_Mobile_Number__c, modigie__Formatted_Phone_Number__c, modigie__Formatted_Other_Phone_Number__c, modigie__Business_Email_1__c, modigie__Business_Email_2__c, modigie__Business_Email_3__c, modigie__Business_Email_4__c, modigie__Private_Email_1__c, modigie__Private_Email_2__c FROM modigie__Modigie__c WHERE modigie__Lead__c = :triggerNew AND modigie__Status__c != 'In process' AND modigie__Linkedin_Status__c != 'In process' AND modigie__Validate_Employer_Status__c != 'In process' AND modigie__Phone_Intelligence_Status__c != 'In process' AND modigie__Phone_Intelligence_Status_Phone__c != 'In process' AND modigie__Phone_Intelligence_Status_Other_Phone__c != 'In process' WITH SECURITY_ENFORCED];
                
                Map<Id,modigie__Modigie__c> mapModigie = new Map<Id,modigie__Modigie__c>();
                
                for(modigie__Modigie__c modigie : lstModigie){
                    mapModigie.put(modigie.modigie__Lead__c,modigie);
                }
                
                List<modigie__Modigie__c> lstModigietoInsert = new List<modigie__Modigie__c>();
                Integer index = 0;
                
                System.debug('triggerNew --> ' + triggerNew);
                
                for(Lead ld : triggerNew){
                    System.debug('triggerOld[index].isConverted == false --> ' + triggerOld[index].isConverted);
                    System.debug('triggerNew[index].isConverted == true ' + triggerNew[index].isConverted);
                    if(triggerOld[index].isConverted == false && triggerNew[index].isConverted == true){
                        
                        if(triggerNew[index].ConvertedContactId != null){
                            Id convConId = triggerNew[index].ConvertedContactId;
                            modigie__Modigie__c temp = new modigie__Modigie__c();
                            if(mapModigie.containsKey(ld.Id)){
                                temp = mapModigie.get(ld.Id);
                                temp.Id = null;
                                try{
                                    temp.Id = [SELECT Id FROM modigie__Modigie__c WHERE modigie__Contact__c = :convConId WITH SECURITY_ENFORCED].Id;
                                }catch(Exception e){}
                                temp.modigie__Lead__c = null;
                                temp.modigie__Contact__c = convConId;
                                temp.modigie__Parent_Id__c = convConId;
                                temp.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                                lstModigietoInsert.add(temp);
                            }
                        }
                    }
                    index++;
                }
                
                if(!lstModigietoInsert.isEmpty()){
                    if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                       FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Lead__c')&&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Lead__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c')&&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Contact__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Parent_Id__c')&&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Parent_Id__c')&&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c')&&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Validation_Key__c'))
                    {
                        upsert lstModigietoInsert;
                    }
                }
            }
        }
        catch(Exception e)
        {
        }
    }
    
    /*public static void updateDynamicCritriaCheckbox(Map<Id,Lead> oldMap, List<Lead> triggerNew){
        try{
            List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT modigie__Field_Api_Name__c, modigie__Field_Value_Should_Changed__c  FROM modigie__Modigie_Automation_Criteria_Lead__c];
            System.debug('lstLeadCriteria before update trigger --> ' + lstLeadCriteria);
            /*
            if(lstLeadCriteria.isEmpty()){
                for(Lead ld : triggerNew){
                    ld.modigie__Is_Dynamic_Criteria_Field_Values_Changed__c = true;    
                }   
            }
            if(!lstLeadCriteria.isEmpty()){
                for(Lead ld : triggerNew){
                    ld.modigie__Is_Dynamic_Criteria_Field_Values_Changed__c = false;
                    for(modigie__Modigie_Automation_Criteria_Lead__c ldCriteria : lstLeadCriteria){
                        if(oldMap.get(ld.Id) != null && oldMap.get(ld.Id).get(ldCriteria.modigie__Field_Api_Name__c) != ld.get(ldCriteria.modigie__Field_Api_Name__c)){
                            ld.modigie__Is_Dynamic_Criteria_Field_Values_Changed__c = true;
                            break;
                        }
                    }
                }    
            }
            
        }
        catch(Exception e){
            System.debug('e.getLineNumber() --> ' + e.getLineNumber());
            System.debug('e.getMessage() --> ' + e.getMessage());
            //call here Error Email
            EmailServiceClass.sendErrorEmail('TriggerOnLeadHelper Error', e);
            /*try{
                List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [SELECT Id, modigie__Error_Message__c FROM modigie__Modigie_Batch_Class_Internal_Error_List__c];
                List<String> lstStrErr = new List<String>();
                for(modigie__Modigie_Batch_Class_Internal_Error_List__c batchClassError : lstBatchClassError){
                    lstStrErr.add(batchClassError.modigie__Error_Message__c);
                }
                
                if(!lstStrErr.contains(e.getMessage())){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> toAddresses = new List<String>();
                    toAddresses.add('pratik@cyntexa.com');
                    toAddresses.add('ashishsharma@cyntexa.com');
                    if(!toAddresses.isEmpty()){
                        mail.setToAddresses(toAddresses);
                        mail.saveAsActivity= false;
                        mail.setSubject('Modigie : TriggerOnLeadHelper Error');
                        String emailBody = 'Please check the error message - ' + e.getMessage();
                        emailBody += '\nLine Number : ' + e.getLineNumber();
                        emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
                        emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
                        mail.setPlainTextBody(emailBody);
                        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        insert new modigie__Modigie_Batch_Class_Internal_Error_List__c(Name =String.valueOf(lstBatchClassError.size()+1), modigie__Error_Message__c = e.getMessage());
                    }
                }
                System.debug('e.getLineNumber() --> ' + e.getLineNumber());    
            }
            catch(Exception exx){
                
            }
        }
        
    }*/

    //Reuse same field
    public static void updateDynamicCritriaCheckboxTom(Map<Id,Lead> oldMap, List<Lead> triggerNew){
        try{
            List<modigie__TOM_Criteria__c> tomCriteriaList = [SELECT Id FROM modigie__TOM_Criteria__c WHERE modigie__isTom__c = true];
            if(!tomCriteriaList.isEmpty()){
                List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT modigie__Field_Api_Name__c, modigie__Field_Value_Should_Changed__c  FROM modigie__Modigie_Automation_Criteria_Lead__c WHERE modigie__Tom_Id__c = :tomCriteriaList[0].Id];
                
                Boolean checkDynamicFlsTom = false;
                if(!lstLeadCriteria.isEmpty()){
                    for(modigie__Modigie_Automation_Criteria_Lead__c ldCriteria : lstLeadCriteria){
                        try{
                            if(FieldLevelSecurityCheck.canReadField('Lead', ldCriteria.modigie__Field_Api_Name__c)){
                                checkDynamicFlsTom = true;
                            }else{
                                checkDynamicFlsTom = false;
                                break;
                            }
                        }catch(Exception te){
                            throw new TriggerOnLeadHelperException('Modigie Warning - Tom dynamic field FLS check failed!');
                        }
                    }

                    for(Lead ld : triggerNew){
                        if(ld.modigie__Tom_Date__c != null){
                            ld.modigie__Is_Dynamic_Criteria_Field_Values_Changed__c = false;
                            if(checkDynamicFlsTom){
                                for(modigie__Modigie_Automation_Criteria_Lead__c ldCriteria : lstLeadCriteria){
                                    if(oldMap.get(ld.Id) != null && oldMap.get(ld.Id).get(ldCriteria.modigie__Field_Api_Name__c) != ld.get(ldCriteria.modigie__Field_Api_Name__c)){
                                        ld.modigie__Is_Dynamic_Criteria_Field_Values_Changed__c = true;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        catch(Exception e){
            EmailServiceClass.sendErrorEmail('TriggerOnLeadHelper Error', e);
        }
    }
    
    public static void updateLinkedin(List<Lead> triggerNew){
        List<modigie__Process_Builder_Switch__c> altLinkedInSetting = getModigieButton.getAltLinkedInSetting(
            'Lead'
        );
        
        if (
            altLinkedInSetting != null &&
            !altLinkedInSetting.isEmpty() &&
            altLinkedInSetting[0]
            .modigie__Is_Active_Lead_Alt_LinkedIn_Url__c != null &&
            altLinkedInSetting[0]
            .modigie__Is_Active_Lead_Alt_LinkedIn_Url__c &&
            altLinkedInSetting[0]
            .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c != null
        ) {
            
            for(Lead ld: triggerNew){
                if (
                    ld != null &&
                    ld.get(
                        altLinkedInSetting[0]
                        .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
                    ) != null &&
                    getModigieButton.checkValidLinkedInUrl(
                        (String) ld.get(
                            altLinkedInSetting[0]
                            .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
                        )
                    ) &&
                    ld.get(
                        altLinkedInSetting[0]
                        .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
                    ) != ld.modigie__LinkedIn_Url__c &&
                    !String.valueOf(
                        ld.get(
                            altLinkedInSetting[0]
                            .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
                        )
                    )
                    .containsIgnoreCase('/sales/')
                ) {
                    ld.modigie__LinkedIn_Url__c = String.valueOf(
                        ld.get(
                            altLinkedInSetting[0]
                            .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
                        )
                    );
                }
            }
        }
    }

    public static void populateHiddenMobileField(List<Lead> conList){
        try{
            String objType = 'Lead';
            modigie__TOM__c tom = modigie__TOM__c.getInstance();
            if(tom.modigie__isActive__c && Date.Today() <= tom.modigie__endDate__c && Date.Today() >= tom.modigie__startDate__c) {
                List<String> fields = new List<String>();
                if(tom.modigie__Lead_Priority_1__c != null && tom.modigie__Lead_Priority_1__c != ''){
                    fields.add(tom.modigie__Lead_Priority_1__c);
                }
                if(tom.modigie__Lead_Priority_2__c != null && tom.modigie__Lead_Priority_2__c != ''){
                    fields.add(tom.modigie__Lead_Priority_2__c);
                }
                if(tom.modigie__Lead_Priority_3__c != null && tom.modigie__Lead_Priority_3__c != ''){
                    fields.add(tom.modigie__Lead_Priority_3__c);
                }
                if(tom.modigie__Lead_Priority_4__c != null && tom.modigie__Lead_Priority_4__c != ''){
                    fields.add(tom.modigie__Lead_Priority_4__c);
                }
                if(tom.modigie__Lead_Priority_5__c != null && tom.modigie__Lead_Priority_5__c != ''){
                    fields.add(tom.modigie__Lead_Priority_5__c);
                }
                if(tom.modigie__Lead_Priority_6__c != null && tom.modigie__Lead_Priority_6__c != ''){
                    fields.add(tom.modigie__Lead_Priority_6__c);
                }

                System.debug('fields ->'+fields);

                Boolean checkDynamicFlsTom = false;
                for(String field: fields){
                    if(FieldLevelSecurityCheck.canReadField(objType, field) && 
                        FieldLevelSecurityCheck.canUpdateField(objType, field))
                    {
                        checkDynamicFlsTom = true;
                    }else{
                        checkDynamicFlsTom = false;
                        break;
                    }
                }

                if(checkDynamicFlsTom){
                    if(FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Mobile_1__c') && 
                        FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Mobile_1__c') && 
                        FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Mobile_2__c') && 
                        FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Mobile_2__c') && 
                        FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Mobile_3__c') && 
                        FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Mobile_3__c') && 
                        FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Map_To_Dialer_1__c') && 
                        FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Map_To_Dialer_1__c') && 
                        FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Map_To_Dialer_2__c') && 
                        FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Map_To_Dialer_2__c') && 
                        FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Map_To_Dialer_3__c') && 
                        FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Map_To_Dialer_3__c'))
                    {
                        System.debug('fls checked for tom');
                        for(Lead l: conList){
                            //(Max. trigger) times 6 (Max. Fields Selected, Min. 3) = 1200 Loop Count!
                            List<String> fromList = new List<String>();
                            for(String field : fields){
                                String tempPhone = (String)l.get(field);
                                if(tempPhone != null && tempPhone != ''){
                                    fromList.add(tempPhone);
                                }
                            }
                            List<String> to = new List<String>{'modigie__TOM_Priority_Mobile_1__c', 'modigie__TOM_Priority_Mobile_2__c', 'modigie__TOM_Priority_Mobile_3__c'};
                            List<String> toE164 = new List<String>{'modigie__TOM_Priority_Map_To_Dialer_1__c', 'modigie__TOM_Priority_Map_To_Dialer_2__c', 'modigie__TOM_Priority_Map_To_Dialer_3__c'};
                            Integer iterateCount = 0;

                            System.debug('fromList -> '+ fromList);
                            //(Max. trigger) times 3 (Max. Allowed, Min. 0) = 600 Loop Count!
                            for(String tempPhone : fromList){
                                if(tempPhone != (String)l.get(to[iterateCount])){
                                    l.put(to[iterateCount], tempPhone);
                                    String pattern = '[^0-9]';
                                    String tempPhoneE164 = tempPhone.replaceAll(pattern, '');
                                    if(tempPhoneE164.startsWith('1')){
                                        tempPhoneE164 = '+' + tempPhoneE164;
                                    }else{
                                        tempPhoneE164 = '+1' + tempPhoneE164;
                                    }
                                    l.put(toE164[iterateCount], tempPhoneE164);
                                }
                                if(iterateCount == 2){
                                    break;
                                }
                                iterateCount++;
                            }
                            Integer reduceCount = 2;
                            
                            //(Max. trigger) times 3 (Max. Allowed, Min. 0) = 600 Loop Count!
                            while(reduceCount >= fromList.size()){
                                l.put(to[reduceCount], '');
                                l.put(toE164[reduceCount], '');
                                reduceCount--;
                            }
                        }
                    }
                }
            }
        }catch(Exception e){}
    }

    public static Boolean initialFilteringCheck(Lead ld){
        if((ld.FirstName != Null && ld.FirstName != '') && 
            (ld.LastName != Null && ld.LastName != '') && 
            (ld.Company != Null && ld.Company != '') && 
            ((ld.modigie__LinkedIn_Url__c != Null && ld.modigie__LinkedIn_Url__c != '') || 
            (ld.Email != Null && ld.Email != ''))&&
            (ld.modigie__Modigie_Verified_Number__c == Null))
        {
            return true;
        }else{
            return false;
        }
    }

    public static Boolean initialFilteringFlsCheck(){
        if(FieldLevelSecurityCheck.canReadObject('Lead') &&
            FieldLevelSecurityCheck.canReadField('Lead','FirstName') &&
            FieldLevelSecurityCheck.canReadField('Lead','LastName') &&
            FieldLevelSecurityCheck.canReadField('Lead','Company') &&
            FieldLevelSecurityCheck.canReadField('Lead','Email') &&
            FieldLevelSecurityCheck.canReadField('Lead','modigie__LinkedIn_Url__c') &&
            FieldLevelSecurityCheck.canReadField('Lead','modigie__Modigie_Verified_Number__c'))
        {
            return true;
        }else{
            return false;
        }
    }
    
    private class TriggerOnLeadHelperException extends Exception{}
    
}