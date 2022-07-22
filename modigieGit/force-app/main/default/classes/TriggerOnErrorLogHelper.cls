/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    11 Sep 2020
*  @name    TriggerOnErrorLogHelper
*  @description This trigger is used to prevent insertion,updation and deletion of error logs records through user interface.
***********************************************************************/
public with sharing class TriggerOnErrorLogHelper {
	public static void check(List<modigie__Error_Log__c> listofrecords)
    {
        try
        {
            for(modigie__Error_Log__c mc : listofrecords)
            {
                if(FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c') &&
                   FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Validation_Key__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Error_Log__c','modigie__Validation_Key__c'))
                {
                    mc.modigie__Validation_Key__c = '';
                }
            }
        }
        catch(Exception e)
        {
        }
    }	
}