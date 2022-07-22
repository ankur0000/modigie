@isTest
public class TestModigieServiceClass {
    
    @isTest
    public static void testCreateModigieServiceRecord() {
        RuleSetFactoryTest.createToken();
        String objType = 'Lead';
        String useCase = 'Test';
        RuleSetFactoryTest.insertUseCase(useCase);
        List<modigie__Modigie__c> modiList = RuleSetFactoryTest.createCalled(useCase, objType);
        Test.startTest();
        ModigieServiceClass.createModigieServiceRecord(modiList, objType, 'Test', 'Test');
        objType = 'Contact';
        modiList = RuleSetFactoryTest.createCalled(useCase, objType);
        ModigieServiceClass.createModigieServiceRecord(modiList, objType, 'Test', 'Test');
        Test.stopTest();
        List<modigie__Modigie_Service__c> ms = [SELECT Id FROM modigie__Modigie_Service__c LIMIT 1];
        System.assert(!ms.isEmpty());
    }
}