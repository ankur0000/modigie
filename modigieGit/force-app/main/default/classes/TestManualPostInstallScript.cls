@isTest
public class TestManualPostInstallScript {
    @isTest
    public static void testSyncOldRuleSet(){
        modigie__Modigie_Automation_Criteria_Lead__c newLeadCrit = new modigie__Modigie_Automation_Criteria_Lead__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        modigie__Modigie_Automation_Criteria_Contact__c newContCrit = new modigie__Modigie_Automation_Criteria_Contact__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        insert newLeadCrit;
        insert newContCrit;
        modigie__Process_Builder_Switch__c mPBS = new modigie__Process_Builder_Switch__c();
        insert mPBS;
        ManualPostInstallScript.syncOldRuleSet();
        List<modigie__Modigie_Rule_Sets__c> mrs = [SELECT Id FROM modigie__Modigie_Rule_Sets__c LIMIT 1];
        System.assert(!mrs.isEmpty());
    }
}