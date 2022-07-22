public with sharing class TriggerOnContactHelper 
{
    public static Boolean preventRecursion = true;
    public static Boolean aPreventRecursion = true;
    /*public static void check(List<Contact> triggernew)
    {
        try
        {
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c'))
            {
                List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
                List<modigie__Modigie__c> modiListToUpdate = new List<modigie__Modigie__c>();
                
                
                modiList = [SELECT Name, modigie__Contact__c, modigie__Parent_Id__c, modigie__Status__c FROM modigie__Modigie__c WHERE modigie__Contact__c IN :triggernew WITH SECURITY_ENFORCED];
                
              /*  for(modigie__Modigie__c modi : modiList)
                {
                    modi.modigie__Contact__c = null;
                    modi.modigie__Parent_Id__c = null;
                    modi.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    modiListToUpdate.add(modi);
                }
                if(modiListToUpdate.size() > 0){
                    
                    
                    if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
                       FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Contact__c')&&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Key__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Parent_Id__c') &&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Parent_Id__c'))
                    {
                        update modiListToUpdate;
                    }
                }
                if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c') &&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
                   FieldLevelSecurityCheck.canDeleteObject('modigie__Modigie__c'))
                {
                    if(!modiList.isEmpty()){
                    	delete modiList;    
                    }
                    
                }
            }
        }
        catch(Exception e)
        {
        }
    }*/

    public static void updateValidateNumber(List<Contact> triggernew)
    {
        try
        {
            List<Contact> conList = new List<Contact>();
            if(FieldLevelSecurityCheck.canReadObject('Contact') &&
               FieldLevelSecurityCheck.canUpdateObject('Contact') &&
               FieldLevelSecurityCheck.canReadField('Contact','Id')&&
               FieldLevelSecurityCheck.canReadField('Contact','modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Contact','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Validation_Key__c') &&
               FieldLevelSecurityCheck.canReadField('Contact','modigie__Alternate_Mobile_Phone_Available__c') &&
               FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Alternate_Mobile_Phone_Available__c'))
            {
                
                for(Contact con : triggernew)
                {  
                    Contact cont = new Contact(Id = con.Id);
                    cont.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    cont.modigie__Alternate_Mobile_Phone_Available__c='';
                    cont.modigie__Modigie_Verified_Number__c = '';
                    conList.add(cont);
                }
                if(!conList.isEmpty()){
                    update conList;
                }
            }
        }
        catch(Exception e)
        {
        }
    }
    
    /*public static void updateDynamicCritriaCheckbox(Map<Id,Contact> oldMap, List<Contact> triggerNew){
        try{
            List<modigie__Modigie_Automation_Criteria_Contact__c> lstConCriteria = [SELECT modigie__Field_Api_Name__c, modigie__Field_Value_Should_Changed__c  FROM modigie__Modigie_Automation_Criteria_Contact__c];
            System.debug('lstConCriteria before update trigger --> ' + lstConCriteria);
            /*if(lstConCriteria.isEmpty()){
                for(Lead ld : triggerNew){
                    ld.modigie__Is_Dynamic_Criteria_Field_Values_Changed__c = true;    
                }   
            }
            if(!lstConCriteria.isEmpty()){
                for(Contact con : triggerNew){
                    con.modigie__Is_Dynamic_Criteria_Field_Values_Changed__c = false;
                    for(modigie__Modigie_Automation_Criteria_Contact__c conCriteria : lstConCriteria){
                        if(oldMap.get(con.Id) != null && oldMap.get(con.Id).get(conCriteria.modigie__Field_Api_Name__c) != con.get(conCriteria.modigie__Field_Api_Name__c)){
                            con.modigie__Is_Dynamic_Criteria_Field_Values_Changed__c = true;
                            break;
                        }
                    }
                }    
            }
            
        }
        catch(Exception e){
            //call here Error Email
            System.debug('e.getLineNumber() --> ' + e.getLineNumber());
            System.debug('e.getMessage() --> ' + e.getMessage());
            EmailServiceClass.sendErrorEmail('TriggerOnContactHelper Error', e);
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
                        mail.setSubject('Modigie : TriggerOnContactHelper Error');
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
    public static void updateDynamicCritriaCheckboxTom(Map<Id,Contact> oldMap, List<Contact> triggerNew){
        try{
            List<modigie__TOM_Criteria__c> tomCriteriaList = [SELECT Id FROM modigie__TOM_Criteria__c WHERE modigie__isTom__c = true];
            if(!tomCriteriaList.isEmpty()){
                List<modigie__Modigie_Automation_Criteria_Contact__c> lstContactCriteria = [SELECT modigie__Field_Api_Name__c, modigie__Field_Value_Should_Changed__c  FROM modigie__Modigie_Automation_Criteria_Contact__c WHERE modigie__Tom_Id__c = :tomCriteriaList[0].Id];
                
                Boolean checkDynamicFlsTom = false;
                if(!lstContactCriteria.isEmpty()){
                    for(modigie__Modigie_Automation_Criteria_Contact__c conCriteria : lstContactCriteria){
                        try{
                            if(FieldLevelSecurityCheck.canReadField('Contact', conCriteria.modigie__Field_Api_Name__c)){
                                checkDynamicFlsTom = true;
                            }else{
                                checkDynamicFlsTom = false;
                                break;
                            }
                        }catch(Exception te){
                            throw new TriggerOnContactHelperException('Modigie Warning - Tom dynamic field FLS check failed!');
                        }
                    }

                    for(Contact con : triggerNew){
                        if(con.modigie__Tom_Date__c != null){
                            con.modigie__Is_Dynamic_Criteria_Field_Values_Changed__c = false;
                            if(checkDynamicFlsTom){
                                for(modigie__Modigie_Automation_Criteria_Contact__c conCriteria : lstContactCriteria){
                                    if(oldMap.get(con.Id) != null && oldMap.get(con.Id).get(conCriteria.modigie__Field_Api_Name__c) != con.get(conCriteria.modigie__Field_Api_Name__c)){
                                        con.modigie__Is_Dynamic_Criteria_Field_Values_Changed__c = true;
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
            EmailServiceClass.sendErrorEmail('TriggerOnContactHelper Error', e);
        }
    }
    
    public static void updateLinkedin(List<Contact> triggerNew){
        List<modigie__Process_Builder_Switch__c> altLinkedInSetting = getModigieButton.getAltLinkedInSetting(
            'Contact'
        );
    
        if (
            altLinkedInSetting != null &&
            !altLinkedInSetting.isEmpty() &&
            altLinkedInSetting[0]
            .modigie__Is_Active_Contact_Alt_LinkedIn_Url__c != null &&
            altLinkedInSetting[0]
            .modigie__Is_Active_Contact_Alt_LinkedIn_Url__c &&
            altLinkedInSetting[0]
            .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c != null
        ) {
        
            for(Contact con: triggerNew) {
                if (
                    con != null &&
                    con.get(
                        altLinkedInSetting[0]
                        .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
                    ) != null &&
                    getModigieButton.checkValidLinkedInUrl(
                        (String) con.get(
                            altLinkedInSetting[0]
                            .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
                        )
                    ) &&
                    con.get(
                        altLinkedInSetting[0]
                        .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
                    ) != con.modigie__LinkedIn_Url__c &&
                    !String.valueOf(
                        con.get(
                            altLinkedInSetting[0]
                            .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
                        )
                    )
                    .containsIgnoreCase('/sales/')
                ) {
                    con.modigie__LinkedIn_Url__c = String.valueOf(
                        con.get(
                            altLinkedInSetting[0]
                            .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
                        )
                    );
                }
            }
            
        }
    }

    public static void populateHiddenMobileField(List<Contact> conList){
        try{
            String objType = 'Contact';
            modigie__TOM__c tom = modigie__TOM__c.getInstance();
            if(tom.modigie__isActive__c && Date.Today() <= tom.modigie__endDate__c && Date.Today() >= tom.modigie__startDate__c) {
                List<String> fields = new List<String>();
                if(tom.modigie__Contact_Priority_1__c != null && tom.modigie__Contact_Priority_1__c != ''){
                    fields.add(tom.modigie__Contact_Priority_1__c);
                }
                if(tom.modigie__Contact_Priority_2__c != null && tom.modigie__Contact_Priority_2__c != ''){
                    fields.add(tom.modigie__Contact_Priority_2__c);
                }
                if(tom.modigie__Contact_Priority_3__c != null && tom.modigie__Contact_Priority_3__c != ''){
                    fields.add(tom.modigie__Contact_Priority_3__c);
                }
                if(tom.modigie__Contact_Priority_4__c != null && tom.modigie__Contact_Priority_4__c != ''){
                    fields.add(tom.modigie__Contact_Priority_4__c);
                }
                if(tom.modigie__Contact_Priority_5__c != null && tom.modigie__Contact_Priority_5__c != ''){
                    fields.add(tom.modigie__Contact_Priority_5__c);
                }
                if(tom.modigie__Contact_Priority_6__c != null && tom.modigie__Contact_Priority_6__c != ''){
                    fields.add(tom.modigie__Contact_Priority_6__c);
                }

                System.debug('fields ->' +fields);

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
                        System.debug('FLS Checked for TOM');
                        for(Contact l: conList){
                            //(Max. trigger) times 6 (Max. Fields Selected, Min. 3) = 1200 Loop Count!
                            List<String> fromList = new List<String>();
                            for(String field : fields){
                                String tempPhone = (String)l.get(field);
                                if(tempPhone != null && tempPhone != ''){
                                    fromList.add(tempPhone);
                                }
                            }
                            System.debug('fromList->' +fromList);
                            List<String> to = new List<String>{'modigie__TOM_Priority_Mobile_1__c', 'modigie__TOM_Priority_Mobile_2__c', 'modigie__TOM_Priority_Mobile_3__c'};
                            List<String> toE164 = new List<String>{'modigie__TOM_Priority_Map_To_Dialer_1__c', 'modigie__TOM_Priority_Map_To_Dialer_2__c', 'modigie__TOM_Priority_Map_To_Dialer_3__c'};
                            Integer iterateCount = 0;

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

    public static Boolean initialFilteringCheck(Contact con){
        if((con.FirstName != Null && con.FirstName != '') && 
            (con.LastName != Null && con.LastName != '') && 
            (con.AccountId != Null) && 
            ((con.modigie__LinkedIn_Url__c != Null && con.modigie__LinkedIn_Url__c != '') || 
            (con.Email != Null && con.Email != ''))&&
            (con.modigie__Modigie_Verified_Number__c == Null)&&
            ((!con.modigie__Converted_From_Lead__c && con.modigie__Modigie_Is_New__c) ||
            (!con.modigie__Modigie_Is_New__c)))
        {
            return true;
        }else{
            return false;
        }
    }

    public static Boolean initialFilteringFlsCheck(){
        if(FieldLevelSecurityCheck.canReadObject('Contact') &&
            FieldLevelSecurityCheck.canReadField('Contact','FirstName') &&
            FieldLevelSecurityCheck.canReadField('Contact','LastName') &&
            FieldLevelSecurityCheck.canReadField('Contact','AccountId') &&
            FieldLevelSecurityCheck.canReadField('Contact','Email') &&
            FieldLevelSecurityCheck.canReadField('Contact','modigie__LinkedIn_Url__c') &&
            FieldLevelSecurityCheck.canReadField('Contact','modigie__Modigie_Verified_Number__c') &&
            FieldLevelSecurityCheck.canReadField('Contact','modigie__LinkedIn_Url__c') &&
            FieldLevelSecurityCheck.canReadField('Contact','modigie__Converted_From_Lead__c'))
        {
            return true;
        }else{
            return false;
        }
    }
    
    /*public static void preventUpdateModigieNumber(List<Contact> triggerNew, Map<Id,Contact> triggerOldMap){
        TriggerOnContactHelper.preventRecursion = false;
            if(FieldLevelSecurityCheck.canReadObject('Contact')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Validation_Key__c'))
            {
                for(Contact con : triggerNew)
                {
                    if((con.modigie__Modigie_Verified_Number__c != triggerOldMap.get(con.Id).modigie__Modigie_Verified_Number__c) || (con.modigie__Alternate_Mobile_Phone_Available__c != triggerOldMap.get(con.Id).modigie__Alternate_Mobile_Phone_Available__c))
                    {
                        if(con.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey')
                        {
                            con.modigie__Validation_Key__c = '';
                        }
                        else
                        {
                            con.addError('You can not update the contact');
                        }
                    }
                }
            }
    }*/

    private class TriggerOnContactHelperException extends Exception{}
}