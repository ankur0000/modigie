/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    6 Feb 2020
*  @name    GetModigieButton
*  @description This class is used to make callout when user press Get Modigie Button.
***********************************************************************/
trigger TriggerOnModigieCredit on Modigie_Credit__c (before insert, before update, before delete) 
{
    if (Trigger.isBefore)
    {
        if (Trigger.isInsert)
        {
            // Process before insert
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credit__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Validation_Key__c'))
            {
                List<modigie__Modigie_Credit__c> mcinsertlist = new List<modigie__Modigie_Credit__c>();
                
                for(modigie__Modigie_Credit__c mc : Trigger.new)
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
                TriggerOnModigieCreditHelper.check(mcinsertlist);
            }
            
        } 
        else if (Trigger.isUpdate) 
        {
            // Process before update
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credit__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Validation_Key__c'))
            {
                List<modigie__Modigie_Credit__c> mcupdatelist = new List<modigie__Modigie_Credit__c>();
                
                for(modigie__Modigie_Credit__c mc : Trigger.new)
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
                TriggerOnModigieCreditHelper.check(mcupdatelist);
            }
            
        }
        else if (trigger.isDelete)
        {
            for(Modigie_Credit__c acc: Trigger.old){
                acc.AddError('Cannot Delete the record');
            }
        }
    }
    
}