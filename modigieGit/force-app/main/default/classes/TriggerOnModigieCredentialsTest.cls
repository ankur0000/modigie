@isTest
public class TriggerOnModigieCredentialsTest {
    public static testMethod void ModigieCredentialsInsertionTest(){
        modigie__Modigie_Credentials__c mmc = new modigie__Modigie_Credentials__c();
        mmc.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        Test.startTest();
        insert mmc;
        system.assert(mmc.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Test.stopTest();
        List<modigie__Modigie_Credentials__c> cres = [SELECT modigie__Validation_Key__c FROM modigie__Modigie_Credentials__c];
        System.assertEquals(NULL,cres.get(0).modigie__Validation_Key__c);
    }

    public static testMethod void ModigieCredentialsUpdateTest(){
        modigie__Modigie_Credentials__c mmc = new modigie__Modigie_Credentials__c();
        mmc.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert mmc;
        system.assert(mmc.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');

        Test.startTest();
        mmc.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        update mmc;
        system.assert(mmc.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Test.stopTest();
        List<modigie__Modigie_Credentials__c> cres = [SELECT modigie__Validation_Key__c FROM modigie__Modigie_Credentials__c];
        System.assertEquals(NULL,cres.get(0).modigie__Validation_Key__c);
    }

    public static testMethod void ModigieCredentialsDeleteTest(){
        modigie__Modigie_Credentials__c mmc = new modigie__Modigie_Credentials__c();
        mmc.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert mmc;
        system.assert(mmc.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');

        try{
            Delete mmc;
            system.assert(mmc.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
            throw new MyException('Cannot Delete the record');
        }catch(exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Cannot Delete the record') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
    public class MyException extends Exception {}
}