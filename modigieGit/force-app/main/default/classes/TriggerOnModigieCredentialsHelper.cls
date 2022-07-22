/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    11 Sep 2020
*  @name    TriggerOnModigieCredentialsHelper
*  @description This class is used by TriggerOnModigieCredentials to update validation key.
***********************************************************************/

public with sharing class TriggerOnModigieCredentialsHelper {
    public static void check(List<modigie__Modigie_Credentials__c> listofrecords)
    {
        try
        {
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credentials__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credentials__c','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credentials__c','modigie__Validation_Key__c'))
            {
                for(modigie__Modigie_Credentials__c mc : listofrecords)
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