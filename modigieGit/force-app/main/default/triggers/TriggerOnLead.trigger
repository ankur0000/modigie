trigger TriggerOnLead on Lead (before delete, after undelete, before insert, before update, after insert, after update)  // after insert
{
    Map<String, Object> permissionMap = ModigieLightningTabController.getOrgStopUntilTimeAndReason();
    if(Boolean.valueOf(permissionMap.get('isStopCallouts'))){
        return;
    }
    ModigieTriggerOverride__c triggerOverride = ModigieTriggerOverride__c.getInstance();
    if(triggerOverride.OverrideAll__c || triggerOverride.LeadTriggerOverride__c  || ModigieStaticReferenceHelper.isTOMunTOMBatchClassRunning){
        return;
    }

    Datetime timeAnHourEarly = DateTime.now().addHours(-1);

    Boolean shouldAutomationFire = true;
    if(ModigieStaticReferenceHelper.isSalesEngagementBatchRunning || ModigieStaticReferenceHelper.isGetModigieBatchRunning || ModigieStaticReferenceHelper.isUpdateFromModigie || Boolean.valueOf(permissionMap.get('isCreditAccountStopped')) || Boolean.valueOf(permissionMap.get('isSelectedCreditAccountInactive'))){
        shouldAutomationFire = false;
    }

    Boolean isModigieAutomationUser = false;
    Id currentUserId = UserInfo.getUserId();
    /*List<PermissionSet> mAU = [SELECT Id FROM PermissionSet WHERE namespaceprefix = 'modigie' AND label = 'Modigie Automation User'];
    if(!mAU.isEmpty()){
        List<User> currentUser = [SELECT Id FROM User WHERE Id in (SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :currentUserId AND PermissionSetId = :mAU[0].Id) LIMIT 1];
        if(!currentUser.isEmpty()){
            isModigieAutomationUser = true;
        }
    }*/
    List<PermissionSetAssignment> automationUser = [SELECT AssigneeId, PermissionSet.Label FROM PermissionSetAssignment WHERE AssigneeId = :currentUserId AND PermissionSet.Label in ('Modigie Automation User') AND PermissionSet.namespaceprefix = 'modigie' LIMIT 1];
    if(!automationUser.isEmpty()){
        isModigieAutomationUser = true;
    }else{
        List<PermissionSetAssignment> modigieUser = [SELECT AssigneeId, PermissionSet.Label FROM PermissionSetAssignment WHERE AssigneeId = :currentUserId AND PermissionSet.Label in ('Modigie User', 'Modigie Admin', 'Modigie Automation User') AND PermissionSet.namespaceprefix = 'modigie' LIMIT 1];
        if(modigieUser.isEmpty()){
            return;
        }
    }
    /*
    //To remove autoamtionUser SOQL
    for(PermissionSetAssignment psaMU: modigieUser){
        if(psaMU.PermissionSet.Label == 'Modigie Automation User'){
            isModigieAutomationUser = true;
        }
    }
    */
    
    //SFD-64
    List<modigie__Modigie_Service_Account__mdt> modigieCredentialList = ModigieApiUtils.getServiceAccountDetails();
    // List<modigie__Modigie_Credentials__c> modigieCredentialList = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1];
    if(modigieCredentialList.isEmpty()){
        return;
    }

    Boolean jobAutomationFLS = false;
    Boolean checkOriginUpdate = false;
    //Boolean tomAutomationFLS = false;

    if(TriggerOnLeadHelper.initialFilteringFlsCheck() &&
        FieldLevelSecurityCheck.canReadObject('Lead')&&
        FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Modigie_Is_New__c')&&
        FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Modigie_Is_New__c')&&
        FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Modigie_Is_Active__c')&&
        FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Modigie_Is_Active__c'))
    {
        jobAutomationFLS = true;
    }

    /*
    if(FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Is_Tom_Running__c')&&
        FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Is_Tom_Running__c'))
    {
        tomAutomationFLS = true;
    }
    */

    if(FieldLevelSecurityCheck.canReadObject('Lead')&&
        FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Modigie_Verified_Number__c')&&
        FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Alternate_Mobile_Phone_Available__c')&&
        FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Validation_Key__c')&&
        FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Validation_Key__c')&&
        FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Converted_From_Lead__c')&&
        FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Converted_From_Lead__c'))
    {
        checkOriginUpdate = true;
    }

    Boolean canChangeActiveField = false;
    if(shouldAutomationFire && isModigieAutomationUser){// && !ModigieStaticReferenceHelper.calledOnInitialFilter){
        canChangeActiveField = true;
    }

    Boolean tomActive = false;
    String firstFieldTOM = null;
    Boolean firstFieldOverwriteTOM = false;
    String secondFieldTOM = null;
    Boolean secondFieldOverwriteTOM = false;
    List<String> tomDrawnList = new List<String>();

    try{
        modigie__TOM__c tom = modigie__TOM__c.getInstance();
        if(tom.modigie__isActive__c && System.today() <= tom.modigie__endDate__c && System.today() >= tom.modigie__startDate__c) {
            tomActive = true;
            Boolean permissionPass = true;
            //TOM - draw value to
            if(tom.modigie__Lead_Reset_Priority_1__c != null && tom.modigie__Lead_Reset_Priority_1__c != ''){
                firstFieldTOM = tom.modigie__Lead_Reset_Priority_1__c;
                if(!FieldLevelSecurityCheck.canUpdateField('Lead', firstFieldTOM)){
                    permissionPass = false;
                }
            }else{
                tomActive = false;
            }
            if(tom.modigie__Lead_Priority_2__c == 'overwrite'){
                firstFieldOverwriteTOM = true;
            }
            if(tom.modigie__Lead_Reset_Priority_2__c != null && tom.modigie__Lead_Reset_Priority_2__c != ''){
                secondFieldTOM = tom.modigie__Lead_Reset_Priority_2__c;
                if(!FieldLevelSecurityCheck.canUpdateField('Lead', secondFieldTOM)){
                    permissionPass = false;
                }
            }
            if(tom.modigie__Lead_Priority_3__c == 'overwrite'){
                secondFieldOverwriteTOM = true;
            }
            //TOM - draw value from
            if(tom.modigie__Lead_Priority_1__c != null && tom.modigie__Lead_Priority_1__c != ''){
                tomDrawnList.add(tom.modigie__Lead_Priority_1__c);
                if(!FieldLevelSecurityCheck.canReadField('Lead', tom.modigie__Lead_Priority_1__c)){
                    permissionPass = false;
                }
            }
            if(tom.modigie__Lead_Priority_4__c != null && tom.modigie__Lead_Priority_4__c != ''){
                tomDrawnList.add(tom.modigie__Lead_Priority_4__c);
                if(!FieldLevelSecurityCheck.canReadField('Lead', tom.modigie__Lead_Priority_4__c)){
                    permissionPass = false;
                }
            }
            if(tom.modigie__Lead_Priority_5__c != null && tom.modigie__Lead_Priority_5__c != ''){
                tomDrawnList.add(tom.modigie__Lead_Priority_5__c);
                if(!FieldLevelSecurityCheck.canReadField('Lead', tom.modigie__Lead_Priority_5__c)){
                    permissionPass = false;
                }
            }
            if(tom.modigie__Lead_Priority_6__c != null && tom.modigie__Lead_Priority_6__c != ''){
                tomDrawnList.add(tom.modigie__Lead_Priority_6__c);
                if(!FieldLevelSecurityCheck.canReadField('Lead', tom.modigie__Lead_Priority_6__c)){
                    permissionPass = false;
                }
            }
            if(!permissionPass){
                System.debug('TOM FLS Error!');
                tomActive = false;
            }
        }
    }catch(Exception exp){
        System.debug(exp.getMessage());
        tomActive = false;
    }
    if(!tomActive){
        System.debug('TOM ACTIVE FALSE');
    }
            
    System.debug('shouldAutomationFire->'+shouldAutomationFire);
    System.debug('isModigieAutomationUser->'+isModigieAutomationUser);
    
    System.debug('In the Lead Modigie trigger');
    if (Trigger.isBefore){
        
        System.debug('Trigger.isBeofreInsert -->' + Trigger.isInsert);
        System.debug('Trigger.isBeofreUpdate -->' + Trigger.isUpdate);
        if (Trigger.isUpdate && TriggerOnLeadHelper.preventRecursion){
            System.debug('In before update');
            TriggerOnLeadHelper.preventRecursion = false;

            for(Lead ld : Trigger.new){
                if(jobAutomationFLS){
                    if(ld.modigie__Modigie_Is_New__c){
                        ld.modigie__Modigie_Is_New__c = false;
                        System.debug('is new false');
                    }
                    if((!ld.modigie__Modigie_Is_Active__c || ld.LastModifiedDate < timeAnHourEarly) && TriggerOnLeadHelper.initialFilteringCheck(ld) && canChangeActiveField){
                        ModigieStaticReferenceHelper.initialFiltering.add(ld.Id);
                        ld.modigie__Modigie_Is_Active__c = true;
                    }
                }

                /*
                if(tomAutomationFLS && !ld.modigie__Is_Tom_Running__c && !ModigieStaticReferenceHelper.isTOMunTOMBatchClassRunning){
                    ModigieStaticReferenceHelper.initialFilteringTom.add(ld.Id);
                    ld.modigie__Is_Tom_Running__c = true;
                }
                */

                if(tomActive){
                    Boolean updateTomDate = false;
                    //max loop size is 4, min is 1
                    for(String phoneField : tomDrawnList){
                        System.debug('phone-' + ld.get(phoneField) + ';'+firstFieldTOM);
                        if(ld.get(phoneField) != null && ld.get(firstFieldTOM) == ld.get(phoneField)){
                            break;
                        }else if(ld.get(phoneField) != Null && ( ld.get(firstFieldTOM) == Null || ( firstFieldOverwriteTOM && ( ld.get(firstFieldTOM) != ld.get(phoneField) ) ) ) ){
                            ld.put(firstFieldTOM, ld.get(phoneField));
                            System.debug(firstFieldTOM + '-' + ld.get(phoneField));
                            updateTomDate = true;
                            break;
                        }
                    }
                    if(secondFieldTOM != null){
                        if( ld.get(firstFieldTOM) != Null && ( ld.get(secondFieldTOM) == Null || ( secondFieldOverwriteTOM && ld.get(firstFieldTOM) != ld.get(secondFieldTOM) ) ) ){
                            ld.put(secondFieldTOM, ld.get(firstFieldTOM));
                            System.debug(secondFieldTOM + '-' + ld.get(firstFieldTOM));
                            updateTomDate = true;
                        }
                    }
                    if(updateTomDate){
                        ld.modigie__Tom_Date__c = System.today();
                    }
                }

                if(checkOriginUpdate){
                    //To Update Old Lead's to have default true value for modigie__Converted_From_Lead__c field, so it can map true to Contact when it gets converted!
                    if(!ld.modigie__Converted_From_Lead__c){
                        ld.modigie__Converted_From_Lead__c = true;
                    }

                    Boolean keyVerified = false;
                    if(ld.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey'){
                        ld.modigie__Validation_Key__c = '';
                        keyVerified = true;
                    }

                    if((ld.modigie__Modigie_Verified_Number__c != trigger.oldMap.get(ld.Id).modigie__Modigie_Verified_Number__c) || 
                        (ld.modigie__Alternate_Mobile_Phone_Available__c != trigger.oldMap.get(ld.Id).modigie__Alternate_Mobile_Phone_Available__c))
                    {
                        if(!keyVerified){
                            ld.addError('You can not update the Lead');
                        }
                    }
                }
            }
            
            if(FieldLevelSecurityCheck.canReadObject('Lead')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__LinkedIn_Url__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__LinkedIn_Url__c'))
            {
                TriggerOnLeadHelper.updateLinkedin(trigger.new);
            }
            
            /*
            if(FieldLevelSecurityCheck.canReadObject('Lead')&&
               FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Tom_Date__c'))
            {
                TriggerOnLeadHelper.updateDynamicCritriaCheckboxTom(Trigger.oldMap, Trigger.new);
            }
            */
        }
        
        if(trigger.isInsert) {
            for(Lead ld : Trigger.new){
                if(jobAutomationFLS){
                    if(TriggerOnLeadHelper.initialFilteringCheck(ld) && canChangeActiveField){
                        ld.modigie__Modigie_Is_Active__c = true;
                    }
                    ld.modigie__Modigie_Is_New__c = true;
                }
                /*
                if(tomAutomationFLS){
                    ld.modigie__Is_Tom_Running__c = true;
                }
                */
            }

            if(FieldLevelSecurityCheck.canReadObject('Lead')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__LinkedIn_Url__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__LinkedIn_Url__c')) {
                TriggerOnLeadHelper.updateLinkedin(trigger.new);
            }
        }
    }
    else if(Trigger.isAfter)
    {
        System.debug('After Trigger.isUpdate --> ' + Trigger.isUpdate);
        System.debug('After Trigger.isInsert --> ' + Trigger.isInsert);

        if(Trigger.isUndelete && TriggerOnLeadHelper.preventRecursion)
        {
            System.debug('Trigger.Undelete');
            TriggerOnLeadHelper.preventRecursion = false;
            
            if(FieldLevelSecurityCheck.canReadObject('Lead') &&
               FieldLevelSecurityCheck.canReadField('Lead','modigie__Modigie_Verified_Number__c'))
            {
                List<Lead> leadList = new List<Lead>();
                
                for(Lead l : Trigger.new)
                {
                    if((l.modigie__Modigie_Verified_Number__c != null))
                        leadList.add(l);
                }
                
                if(!leadList.isEmpty())
                    TriggerOnLeadHelper.updateValidateNumber(leadList);
            }
        }
        
        else if((Trigger.isInsert || Trigger.isUpdate) && TriggerOnLeadHelper.aPreventRecursion){
            Boolean jobAutomationInsertCheck = false;
            System.debug('after insert first criteria -> '+ (TriggerOnLeadHelper.initialFilteringFlsCheck() && Trigger.isInsert && canChangeActiveField));
            if(TriggerOnLeadHelper.initialFilteringFlsCheck() && Trigger.isInsert && canChangeActiveField){
                jobAutomationInsertCheck = true;
            }

            for(Lead ld : Trigger.new){
                if(jobAutomationInsertCheck && TriggerOnLeadHelper.initialFilteringCheck(ld) && ld.modigie__Modigie_Is_Active__c){
                    ModigieStaticReferenceHelper.initialFiltering.add(ld.Id);
                }
                
                /*
                if(Trigger.isInsert && !ModigieStaticReferenceHelper.isTOMunTOMBatchClassRunning && ld.modigie__Is_Tom_Running__c){
                    ModigieStaticReferenceHelper.initialFilteringTom.add(ld.Id);
                }
                */
            }

            if(jobAutomationInsertCheck){
                System.debug('Initial Filtering Check ->'+ModigieStaticReferenceHelper.initialFiltering);
            }

            if(Trigger.isUpdate){
                System.debug('isAfterUpdate called');
                TriggerOnLeadHelper.aPreventRecursion = false;
                
                if(FieldLevelSecurityCheck.canReadObject('Lead')&&
                FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Modigie_Verified_Number__c')&&
                FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Alternate_Mobile_Phone_Available__c')&&
                FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Validation_Key__c')&&
                FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Validation_Key__c')&&
                FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c'))
                {
                    TriggerOnLeadHelper.updateModigieOnLeadConvert(trigger.new,trigger.old);
                }
            }

            //Job Automation Call
            if(!ModigieStaticReferenceHelper.initialFiltering.isEmpty() && canChangeActiveField){
                System.debug('Initial Filtering In Call -> '+ModigieStaticReferenceHelper.initialFiltering);
                System.debug('Called on Initial Filtering -> '+ModigieStaticReferenceHelper.calledOnInitialFilter);
                InvocableModigieAutomationCall.getRecordId(ModigieStaticReferenceHelper.initialFiltering);
                ModigieStaticReferenceHelper.calledOnInitialFilter = true;
                ModigieStaticReferenceHelper.initialFiltering = new List<Id>();
            }

            //Tom - UnTOM Call
            /*
            if(!ModigieStaticReferenceHelper.initialFilteringTom.isEmpty() && !ModigieStaticReferenceHelper.calledOnInitialFilterTom && !ModigieStaticReferenceHelper.isTOMunTOMBatchClassRunning){
                System.debug('TOM Initial Filtering In Call -> '+ ModigieStaticReferenceHelper.initialFilteringTom);
                System.debug('TOM Called on Initial Filtering -> '+ModigieStaticReferenceHelper.calledOnInitialFilterTom);
                InvocableTomAutomationCall.getRecordId(ModigieStaticReferenceHelper.initialFilteringTom);
                ModigieStaticReferenceHelper.calledOnInitialFilterTom = true;
            }
            */
            /*
            modigie__TOM__c tom = modigie__TOM__c.getInstance();
            if(tom.modigie__isActive__c && Date.Today() <= tom.modigie__endDate__c && Date.Today() >= tom.modigie__startDate__c) {
                if(!ModigieStaticReferenceHelper.calledOnInitialFilterTom){
                    List<Id> tomListIds = new List<Id>(Trigger.newMap.keySet());
                    System.debug('TOM Initial Filtering In Call -> '+ tomListIds);
                    System.debug('TOM Called on Initial Filtering -> '+ModigieStaticReferenceHelper.calledOnInitialFilterTom);
                    InvocableTomAutomationCall.getRecordId(tomListIds);
                    ModigieStaticReferenceHelper.calledOnInitialFilterTom = true;
                }
            }
            */
        }
        
    }
    
}