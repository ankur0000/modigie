trigger TriggerOnContact on Contact (before update, before delete, after undelete, before insert, after insert, after update) 
{
    Map<String, Object> permissionMap = ModigieLightningTabController.getOrgStopUntilTimeAndReason();
    if(Boolean.valueOf(permissionMap.get('isStopCallouts'))){
        return;
    }

    ModigieTriggerOverride__c triggerOverride = ModigieTriggerOverride__c.getInstance();
    if(triggerOverride.OverrideAll__c || triggerOverride.ContactTriggerOverride__c || ModigieStaticReferenceHelper.isTOMunTOMBatchClassRunning){
        return;
    }

    Datetime timeAnHourEarly = DateTime.now().addHours(-1);

    Boolean shouldAutomationFire = true;
    if(ModigieStaticReferenceHelper.isSalesEngagementBatchRunning || ModigieStaticReferenceHelper.isGetModigieBatchRunning || ModigieStaticReferenceHelper.isUpdateFromModigie  || Boolean.valueOf(permissionMap.get('isCreditAccountStopped')) || Boolean.valueOf(permissionMap.get('isSelectedCreditAccountInactive'))){
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
    
    //SFD-64
    List<modigie__Modigie_Service_Account__mdt> modigieCredentialList = ModigieApiUtils.getServiceAccountDetails();
    // List<modigie__Modigie_Credentials__c> modigieCredentialList = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1];
    if(modigieCredentialList.isEmpty()){
        return;
    }
    
    Boolean jobAutomationFLS = false;
    Boolean checkOriginUpdate = false;
    //Boolean tomAutomationFLS = false;

    if(TriggerOnContactHelper.initialFilteringFlsCheck() &&
        FieldLevelSecurityCheck.canReadObject('Contact')&&
        FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Modigie_Is_New__c')&&
        FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Modigie_Is_New__c')&&
        FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Modigie_Is_Active__c')&&
        FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Modigie_Is_Active__c'))
    {
        jobAutomationFLS = true;
    }

    /*
    if(FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Is_Tom_Running__c')&&
        FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Is_Tom_Running__c'))
    {
        tomAutomationFLS = true;
    }
    */

    if(FieldLevelSecurityCheck.canReadObject('Contact')&&
        FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Modigie_Verified_Number__c')&&
        FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Alternate_Mobile_Phone_Available__c')&&
        FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Validation_Key__c')&&
        FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Validation_Key__c'))
    {
        checkOriginUpdate = true;
    }

    Boolean canChangeActiveField = false;
    if(shouldAutomationFire && isModigieAutomationUser){// && !ModigieStaticReferenceHelper.calledOnInitialFilterContact){
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
            if(tom.modigie__Contact_Reset_Priority_1__c != null && tom.modigie__Contact_Reset_Priority_1__c != ''){
                firstFieldTOM = tom.modigie__Contact_Reset_Priority_1__c;
                if(!FieldLevelSecurityCheck.canUpdateField('Contact', firstFieldTOM)){
                    permissionPass = false;
                }
            }else{
                tomActive = false;
            }
            if(tom.modigie__Contact_Priority_2__c == 'overwrite'){
                firstFieldOverwriteTOM = true;
            }
            if(tom.modigie__Contact_Reset_Priority_2__c != null && tom.modigie__Contact_Reset_Priority_2__c != ''){
                secondFieldTOM = tom.modigie__Contact_Reset_Priority_2__c;
                if(!FieldLevelSecurityCheck.canUpdateField('Contact', secondFieldTOM)){
                    permissionPass = false;
                }
            }
            if(tom.modigie__Contact_Priority_3__c == 'overwrite'){
                secondFieldOverwriteTOM = true;
            }
            //TOM - draw value from
            if(tom.modigie__Contact_Priority_1__c != null && tom.modigie__Contact_Priority_1__c != ''){
                tomDrawnList.add(tom.modigie__Contact_Priority_1__c);
                if(!FieldLevelSecurityCheck.canReadField('Contact', tom.modigie__Contact_Priority_1__c)){
                    permissionPass = false;
                }
            }
            if(tom.modigie__Contact_Priority_4__c != null && tom.modigie__Contact_Priority_4__c != ''){
                tomDrawnList.add(tom.modigie__Contact_Priority_4__c);
                if(!FieldLevelSecurityCheck.canReadField('Contact', tom.modigie__Contact_Priority_4__c)){
                    permissionPass = false;
                }
            }
            if(tom.modigie__Contact_Priority_5__c != null && tom.modigie__Contact_Priority_5__c != ''){
                tomDrawnList.add(tom.modigie__Contact_Priority_5__c);
                if(!FieldLevelSecurityCheck.canReadField('Contact', tom.modigie__Contact_Priority_5__c)){
                    permissionPass = false;
                }
            }
            if(tom.modigie__Contact_Priority_6__c != null && tom.modigie__Contact_Priority_6__c != ''){
                tomDrawnList.add(tom.modigie__Contact_Priority_6__c);
                if(!FieldLevelSecurityCheck.canReadField('Contact', tom.modigie__Contact_Priority_6__c)){
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

    System.debug('In the Contact Modigie trigger');
    if (Trigger.isBefore)
    {
        System.debug('Trigger.isBeofreInsert -->' + Trigger.isInsert);
        System.debug('Trigger.isBeofreUpdate -->' + Trigger.isUpdate);
        if (Trigger.isUpdate && TriggerOnContactHelper.preventRecursion)
        {

            System.debug('In before update');
            TriggerOnContactHelper.preventRecursion = false;
            for(Contact con : Trigger.new){
                if(con.modigie__Converted_From_Lead__c){
                    con.modigie__Modigie_Is_Active__c = false;
                    con.modigie__Converted_From_Lead__c = false;
                }
                if(jobAutomationFLS)
                {
                    if(con.modigie__Modigie_Is_New__c){
                        con.modigie__Modigie_Is_New__c = false;
                        System.debug('is new false');
                    }
                    if((!con.modigie__Modigie_Is_Active__c || con.LastModifiedDate < timeAnHourEarly) && TriggerOnContactHelper.initialFilteringCheck(con) && canChangeActiveField){
                        ModigieStaticReferenceHelper.initialFilteringContact.add(con.Id);
                        con.modigie__Modigie_Is_Active__c = true;
                        System.debug('Is Active made true in Update');
                    }
                }

                /*
                if(tomAutomationFLS && !con.modigie__Is_Tom_Running__c && !ModigieStaticReferenceHelper.isTOMunTOMBatchClassRunning){
                    ModigieStaticReferenceHelper.initialFilteringContactTom.add(con.Id);
                    con.modigie__Is_Tom_Running__c = true;
                }*/
            
                if(tomActive){
                    Boolean updateTomDate = false;
                    //max loop size is 4, min is 1
                    for(String phoneField : tomDrawnList){
                        System.debug('phone-' + con.get(phoneField) + ';'+firstFieldTOM);
                        if(con.get(phoneField) != null && con.get(firstFieldTOM) == con.get(phoneField)){
                            break;
                        }else if(con.get(phoneField) != Null && ( con.get(firstFieldTOM) == Null || ( firstFieldOverwriteTOM && ( con.get(firstFieldTOM) != con.get(phoneField) ) ) ) ){
                            con.put(firstFieldTOM, con.get(phoneField));
                            System.debug(firstFieldTOM + '-' + con.get(phoneField));
                            updateTomDate = true;
                            break;
                        }
                    }
                    if(secondFieldTOM != null){
                        if(con.get(firstFieldTOM) != Null && ( con.get(secondFieldTOM) == Null || ( secondFieldOverwriteTOM && con.get(firstFieldTOM) != con.get(secondFieldTOM) ) ) ){
                            con.put(secondFieldTOM, con.get(firstFieldTOM));
                            System.debug(secondFieldTOM + '-' + con.get(firstFieldTOM));
                            updateTomDate = true;
                        }
                    }
                    if(updateTomDate){
                        con.modigie__Tom_Date__c = System.today();
                    }
                }

                if(checkOriginUpdate)
                {
                    Boolean keyVerified = false;
                    if(con.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey'){
                        con.modigie__Validation_Key__c = '';
                        keyVerified = true;
                    }

                    if((con.modigie__Modigie_Verified_Number__c != trigger.oldMap.get(con.Id).modigie__Modigie_Verified_Number__c) || (con.modigie__Alternate_Mobile_Phone_Available__c != trigger.oldMap.get(con.Id).modigie__Alternate_Mobile_Phone_Available__c))
                    {
                        if(!keyVerified){
                            con.addError('You can not update the Contact');
                        }
                    }
                }
            }

            if(FieldLevelSecurityCheck.canReadObject('Contact')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__LinkedIn_Url__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__LinkedIn_Url__c')) 
            {
                TriggerOnContactHelper.updateLinkedin(trigger.new);
            }

            /*
            if(FieldLevelSecurityCheck.canReadObject('Contact')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Is_Dynamic_Criteria_Field_Values_Changed__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Is_Dynamic_Criteria_Field_Values_Changed__c')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Tom_Date__c'))
            {
                TriggerOnContactHelper.updateDynamicCritriaCheckboxTom(Trigger.oldMap, Trigger.new);
            }
            */
        } 
        
        if(trigger.isInsert) {

            for(Contact con : Trigger.new){
                if(jobAutomationFLS){
                    if(TriggerOnContactHelper.initialFilteringCheck(con) && canChangeActiveField){
                        con.modigie__Modigie_Is_Active__c = true;
                        System.debug('Is Active made true in Insert');
                    }
                    con.modigie__Modigie_Is_New__c = true;
                }
                /*
                if(tomAutomationFLS){
                    con.modigie__Is_Tom_Running__c = true;
                }*/
            }

            if(FieldLevelSecurityCheck.canReadObject('Contact')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__LinkedIn_Url__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__LinkedIn_Url__c'))
            {
                TriggerOnContactHelper.updateLinkedin(trigger.new);
            }

        }
    }
    else if(Trigger.isAfter)
    {
        System.debug('After Trigger.isUpdate --> ' + Trigger.isUpdate);
        System.debug('After Trigger.isInsert --> ' + Trigger.isInsert);

        if(Trigger.isUndelete && TriggerOnContactHelper.preventRecursion)
        {     

            System.debug('Trigger.Undelete');
            TriggerOnContactHelper.preventRecursion = false;

            if(FieldLevelSecurityCheck.canReadObject('Contact') &&
               FieldLevelSecurityCheck.canReadField('Contact','modigie__Modigie_Verified_Number__c'))
            {
                
                List<Contact> conList = new List<Contact>();

                for(Contact con : Trigger.new)
                {
                    if(con.modigie__Modigie_Verified_Number__c != null)
                        conList.add(con);
                }
                
                if(!conList.isEmpty())
                    TriggerOnContactHelper.updateValidateNumber(conList);
            }

        }

        else if((Trigger.isUpdate || Trigger.isInsert) && TriggerOnContactHelper.aPreventRecursion){
            Boolean jobAutomationInsertCheck = false;            
            System.debug('after insert first criteria -> '+ (TriggerOnContactHelper.initialFilteringFlsCheck() && Trigger.isInsert && canChangeActiveField));
            if(TriggerOnContactHelper.initialFilteringFlsCheck() && Trigger.isInsert && canChangeActiveField){
                jobAutomationInsertCheck = true;
            }

            for(Contact con : Trigger.new){
                if(jobAutomationInsertCheck && TriggerOnContactHelper.initialFilteringCheck(con) && con.modigie__Modigie_Is_Active__c){
                    ModigieStaticReferenceHelper.initialFilteringContact.add(con.Id);
                }
                /*
                if(Trigger.isInsert && !ModigieStaticReferenceHelper.isTOMunTOMBatchClassRunning && con.modigie__Is_Tom_Running__c){
                    ModigieStaticReferenceHelper.initialFilteringContactTom.add(con.Id);
                }
                */
            }

            if(jobAutomationInsertCheck){
                System.debug('Initial Filtering Check ->'+ModigieStaticReferenceHelper.initialFilteringContact);
            }

            //Job Automation Call
            if(!ModigieStaticReferenceHelper.initialFilteringContact.isEmpty() && canChangeActiveField){
                System.debug('Initial Filtering In Call -> '+ModigieStaticReferenceHelper.initialFilteringContact);
                System.debug('Called on Initial Filtering -> '+ModigieStaticReferenceHelper.calledOnInitialFilterContact);
                InvocableModigieAutomationCall.getRecordId(ModigieStaticReferenceHelper.initialFilteringContact);
                ModigieStaticReferenceHelper.calledOnInitialFilterContact = true;
                ModigieStaticReferenceHelper.initialFilteringContact = new List<Id>();
            }

            //Tom - UnTOM Call
            /*
            if(!ModigieStaticReferenceHelper.initialFilteringContactTom.isEmpty() && !ModigieStaticReferenceHelper.calledOnInitialFilterContactTom && !ModigieStaticReferenceHelper.isTOMunTOMBatchClassRunning){
                System.debug('TOM Initial Filtering In Call -> '+ ModigieStaticReferenceHelper.initialFilteringContactTom);
                System.debug('TOM Called on Initial Filtering -> '+ModigieStaticReferenceHelper.calledOnInitialFilterContactTom);
                InvocableTomAutomationCall.getRecordId(ModigieStaticReferenceHelper.initialFilteringContactTom);
                ModigieStaticReferenceHelper.calledOnInitialFilterContactTom = true;
            }*/

            //Tom - UnTOM Call
            /*
            modigie__TOM__c tom = modigie__TOM__c.getInstance();
            if(tom.modigie__isActive__c && Date.Today() <= tom.modigie__endDate__c && Date.Today() >= tom.modigie__startDate__c) {
                if(!ModigieStaticReferenceHelper.calledOnInitialFilterContactTom){
                    List<Id> tomListIds = new List<Id>(Trigger.newMap.keySet());
                    System.debug('TOM Initial Filtering In Call -> '+ tomListIds);
                    System.debug('TOM Called on Initial Filtering -> '+ModigieStaticReferenceHelper.calledOnInitialFilterContactTom);
                    InvocableTomAutomationCall.getRecordId(tomListIds);
                    ModigieStaticReferenceHelper.calledOnInitialFilterContactTom = true;
                }
            }
            */
        }
    }
}