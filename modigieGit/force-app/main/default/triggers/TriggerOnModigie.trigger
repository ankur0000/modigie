/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    6 Feb 2020
*  @name    GetModigieButton
*  @description This class is used to make callout when user press Get Modigie Button.
***********************************************************************/
trigger TriggerOnModigie on Modigie__c (before insert, before update, after undelete)
{
    if (Trigger.isBefore)
    {
        if (Trigger.isInsert && TriggerOnModigieHelper.preventRecursion) 
        {
            TriggerOnModigieHelper.preventRecursion = false;
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c'))
            {
                // Process before insert
                List<modigie__Modigie__c> mcinsertlist = new List<modigie__Modigie__c>();
                
                for(modigie__Modigie__c mc : Trigger.new)
                {
                    if(mc.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey')
                    {
                        mcinsertlist.add(mc);
                        mc.modigie__Validation_Key__c = '';
                    }
                    else
                    {
                        mc.addError('You can not insert the record');
                    }
                }
                if(!ModigieStaticReferenceHelper.isGetModigieBatchRunning && !ModigieStaticReferenceHelper.isSalesEngagementBatchRunning){
                    //Only Works for Lead Conversion?
                    TriggerOnModigieHelper.check(mcinsertlist);
                }
            }
            
            
        } 
        else if (Trigger.isUpdate && TriggerOnModigieHelper.preventRecursion) 
        {
            TriggerOnModigieHelper.preventRecursion = false;

            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c'))
            {
                // Process before update
                List<modigie__Modigie__c> mcupdatelist = new List<modigie__Modigie__c>();
               // List<modigie__Modigie__c> mcphoneupdatelist = new List<modigie__Modigie__c>();
                
                for(modigie__Modigie__c mc : Trigger.new)
                {
                    modigie__Modigie__c oldOpp = Trigger.oldMap.get(mc.Id);
                    
                    if(mc.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey')
                    {
                        mcupdatelist.add(mc);
                        mc.modigie__Validation_Key__c = '';
                    }
                    
                    else
                    {
                        mc.addError('You can not update the record');
                    }
                }
                if(!ModigieStaticReferenceHelper.isGetModigieBatchRunning && !ModigieStaticReferenceHelper.isSalesEngagementBatchRunning){
                    TriggerOnModigieHelper.check(mcupdatelist);
                }
                //TriggerOnModigieHelper.check(mcphoneupdatelist);
            }
            
        }  
        
        // else if(Trigger.isDelete)
        // {
        //     for(Modigie__c acc: Trigger.old){
        //         if(acc.modigie__Contact__c == null && acc.modigie__Lead__c == null){
        //         }
        //         else
        //             acc.AddError('Cannot Delete the record');
        //     }
        // }
    }
    
    else if(Trigger.isAfter){
        TriggerOnModigieHelper.onModigieUndelete(trigger.new);
    }
}