/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    17 July 2020
*  @name    TriggerOnErrorLog
*  @description This Trigger prevents the user for creating and editing the record on User Interface.
***********************************************************************/

trigger TriggerOnErrorLog on modigie__Error_Log__c (before insert, before update,  before delete,after undelete) { 
     if (Trigger.isBefore)
    {
        if (Trigger.isInsert)
        {
            if(FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Validation_Key__c'))
            {
            List<modigie__Error_Log__c> mcinsertlist = new List<modigie__Error_Log__c>();
            // Process before insert or update
            
                for(modigie__Error_Log__c mc : Trigger.new)
                {
                    if(mc.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey')
                    {
                        mcinsertlist.add(mc);
                    }
                    
                    else{
                        mc.addError('You can not insert the record');
                    }
                }
                TriggerOnErrorLogHelper.check(mcinsertlist);
            }
            
        } 
        
        if (Trigger.isUpdate)
        {
            if(FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Validation_Key__c'))
            {
            List<modigie__Error_Log__c> mcupdatelist = new List<modigie__Error_Log__c>();
            // Process before insert or update
            
                for(modigie__Error_Log__c mc : Trigger.new)
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
                 TriggerOnErrorLogHelper.check(mcupdatelist);
            }
           
        } 
        
        
    }
}