/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    11 Sep 2020
*  @name    TriggerOnModigieCredentials
*  @description This trigger is used to prevent insertion,updation and deletion of modigie credentials records through user interface.
***********************************************************************/
trigger TriggerOnModigieCredentials on modigie__Modigie_Credentials__c (before insert, before update,before delete) {      
    if (Trigger.isBefore)
    {
        if (Trigger.isInsert)
        {
            // Process before insert
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credentials__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c','modigie__Validation_Key__c'))
            {
            List<modigie__Modigie_Credentials__c> mcinsertlist = new List<modigie__Modigie_Credentials__c>();
            
                for(modigie__Modigie_Credentials__c mc : Trigger.new)
                {
                    if(mc.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey')
                    {
                        mcinsertlist.add(mc);
                    }
                    else
                    {
                        mc.addError('You can not insert the record');
                    }
                }
                TriggerOnModigieCredentialsHelper.check(mcinsertlist);
            }
            
        } 
        else if (Trigger.isUpdate) 
        {
            // Process before update
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credentials__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c','modigie__Validation_Key__c'))
            {
            List<modigie__Modigie_Credentials__c> mcupdatelist = new List<modigie__Modigie_Credentials__c>();
            
                for(modigie__Modigie_Credentials__c mc : Trigger.new)
                {
                    if(mc.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey')
                    {
                        mcupdatelist.add(mc);
                    }
                    else
                    {
                        mc.addError('You can not update the record');
                    }
                }
                TriggerOnModigieCredentialsHelper.check(mcupdatelist);
            }
            
        }
        else if (trigger.isDelete)
        {
            for(modigie__Modigie_Credentials__c acc: Trigger.old){
                acc.AddError('You Cannot Delete the record');
            }
        }
    }
}