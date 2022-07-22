/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    6 Feb 2020
*  @name    TriggerOnModigieHelper
*  @description This class is used by TriggerOnModigie to update validation key & Modigie validated number field on Contact/Lead.
***********************************************************************/
public with sharing class TriggerOnModigieHelper 
{
    public static Boolean preventRecursion = true;
    public static void check(List<modigie__Modigie__c> listofrecords)
    {
        try
        {
            List<Contact> conList = new List<Contact>();
            List<Lead> leadList = new List<Lead>();
            
            Set<ID> setOfContactIds = new Set<ID>();
            Set<ID> setOfLeadIds = new Set<ID>();
            
            for(modigie__Modigie__c modigie : listofrecords)
            {
                if(modigie.modigie__Lead__c != null){
                    setOfLeadIds.add(modigie.modigie__Lead__c);
                }
                else if(modigie.modigie__Contact__c != null){
                    setOfContactIds.add(modigie.modigie__Contact__c);
                }
            }
            
            //Reposition this
            if(FieldLevelSecurityCheck.canReadObject('Contact') &&
               FieldLevelSecurityCheck.canReadField('Contact','FirstName')&&
               FieldLevelSecurityCheck.canReadField('Contact','LastName') &&
               FieldLevelSecurityCheck.canReadField('Contact','modigie__Modigie_Verified_Number__c') &&
               FieldLevelSecurityCheck.canReadField('Contact','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canReadObject('Lead') &&
               FieldLevelSecurityCheck.canReadField('Lead','FirstName')&&
               FieldLevelSecurityCheck.canReadField('Lead','LastName') &&
               FieldLevelSecurityCheck.canReadField('Lead','modigie__Modigie_Verified_Number__c') &&
               FieldLevelSecurityCheck.canReadField('Lead','modigie__Validation_Key__c'))
            {
                Map<ID, Contact> conMap = new Map<ID, Contact>([SELECT Id, FirstName, LastName, modigie__Modigie_Verified_Number__c, modigie__Validation_Key__c FROM Contact WHERE Id In :setOfContactIds WITH SECURITY_ENFORCED]);
                Map<ID, Lead> leadMap = new Map<ID, Lead>([SELECT Id, FirstName, LastName, modigie__Modigie_Verified_Number__c, modigie__Validation_Key__c FROM Lead WHERE Id In :setOfLeadIds WITH SECURITY_ENFORCED]);
                
                for(modigie__Modigie__c mc : listofrecords)
                {
                    mc.modigie__Validation_Key__c = '';
                    
                    if(mc.modigie__Contact__c != null)
                    {
                        Contact conRec = conMap.get(mc.modigie__Contact__c);
                        conRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                        conRec.modigie__Modigie_Verified_Number__c = mc.modigie__Mobile__c;
                        conRec.modigie__Alternate_Mobile_Number1__c = mc.modigie__Mobile_2__c;
                        conRec.modigie__Alternate_Mobile_Number2__c = mc.modigie__Mobile_3__c;
                        //conRec.modigie__Modigie_Employment_Matches__c = mc.modigie__Company_Name_Matches_Public_Records__c;
                        if(mc.modigie__Company_Name_Matches_Public_Records__c == 'No'){
                            conRec.modigie__Modigie_Employment_Changed__c = true;
                        }
                        //conRec.modigie__Modigie_Current_Employer__c = mc.modigie__Current_Employer__c;
                        conList.add(conRec);
                    }
                    else if(mc.modigie__Lead__c != null)
                    {
                        Lead leadRec = leadMap.get(mc.modigie__Lead__c);
                        leadRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                        leadRec.modigie__Modigie_Verified_Number__c = mc.modigie__Mobile__c;
                        leadRec.modigie__Alternate_Mobile_Number_1__c = mc.modigie__Mobile_2__c;
                        leadRec.modigie__Alternate_Mobile_Number_2__c = mc.modigie__Mobile_3__c;
                        //leadRec.modigie__Modigie_Employment_Matches__c = mc.modigie__Company_Name_Matches_Public_Records__c;
                        if(mc.modigie__Company_Name_Matches_Public_Records__c == 'No'){
                            leadRec.modigie__Modigie_Employment_Changed__c = true;
                        }
                        //leadRec.modigie__Modigie_Current_Employer__c = mc.modigie__Current_Employer__c;
                        leadList.add(leadRec);
                    }
                }
            }
            
            if(!System.isFuture())
            {
                
                ModigieStaticReferenceHelper.isUpdateFromModigie = true;
                if(!conList.isEmpty())
                {
                    if(FieldLevelSecurityCheck.canReadObject('Contact') &&
                       FieldLevelSecurityCheck.canReadField('Contact','modigie__Modigie_Verified_Number__c') &&
                       FieldLevelSecurityCheck.canReadField('Contact','modigie__Validation_Key__c') &&
                       FieldLevelSecurityCheck.canReadField('Contact','modigie__Alternate_Mobile_Number_1__c') &&
                       FieldLevelSecurityCheck.canReadField('Contact','modigie__Alternate_Mobile_Number_2__c') &&
                       FieldLevelSecurityCheck.canReadField('Contact','modigie__Modigie_Employment_Changed__c') &&
                       FieldLevelSecurityCheck.canUpdateObject('Contact') &&
                       FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Modigie_Verified_Number__c') &&
                       FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Validation_Key__c') &&
                       FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Alternate_Mobile_Number_1__c') &&
                       FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Alternate_Mobile_Number_1__c') &&
                       FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Modigie_Employment_Changed__c'))
                    {
                        update conList;
                    }
                    
                }
                if(!leadList.isEmpty()){
                    if(FieldLevelSecurityCheck.canReadObject('Lead') &&
                       FieldLevelSecurityCheck.canReadField('Lead','modigie__Modigie_Verified_Number__c') &&
                       FieldLevelSecurityCheck.canReadField('Lead','modigie__Validation_Key__c') &&
                       FieldLevelSecurityCheck.canReadField('Lead','modigie__Alternate_Mobile_Number_1__c') &&
                       FieldLevelSecurityCheck.canReadField('Lead','modigie__Alternate_Mobile_Number_2__c') &&
                       FieldLevelSecurityCheck.canReadField('Lead','modigie__Modigie_Employment_Changed__c') &&
                       FieldLevelSecurityCheck.canUpdateObject('Lead') &&
                       FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Modigie_Verified_Number__c')&&
                       FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Validation_Key__c') &&
                       FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Alternate_Mobile_Number_1__c') &&
                       FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Alternate_Mobile_Number_1__c') &&
                       FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Modigie_Employment_Changed__c'))
                    {
                        update leadList;
                    }
                }
                
            }
        }
        catch(Exception e){}
    }
    
    public static void onModigieUndelete(List<modigie__Modigie__c> triggerNew){
        for(modigie__Modigie__c modi : triggerNew){
            if(modi.modigie__Contact__c == null && modi.modigie__Lead__c == null){
                modi.addError('You cannot restore this record');
            }
        }
    }
}