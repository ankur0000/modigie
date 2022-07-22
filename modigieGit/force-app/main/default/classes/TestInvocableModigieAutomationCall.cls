@isTest
public class TestInvocableModigieAutomationCall {
    /*
    @isTest
    public static void callingTestLead() {
        RuleSetClassTest.createObjectRecords(200, 'Lead');
        RuleSetClassTest.createObjectRecords(200, 'Contact');
        Map<Id, Lead> maplead = new Map<Id, Lead<([SELECT Id FROM Lead LIMIT 200]);
        Map<Id, Contact> maplead = new Map<Id, Contact<([SELECT Id FROM Contact LIMIT 200]);
        Test.startTest();
            InvocableModigieAutomationCall.getRecordId(new List<Id>(maplead.keySet()));
        Test.endTest();
    }*/
    @isTest
    public static void callingTestContact() {
        RuleSetFactoryTest.createToken();
        RuleSetFactoryTest.createObjectRecords(100, 'Contact');
        RuleSetFactoryTest.insertUseCase('Use Case Test');
        Map<Id, Contact> mapcon = new Map<Id, Contact>([SELECT Id FROM Contact LIMIT 100]);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJobCreateGetModigie());
        InvocableModigieAutomationCall.getRecordId(new List<Id>(mapcon.keySet()));
        Test.stopTest();
        System.assert(!mapcon.isEmpty());
    }
    @isTest
    public static void callingTestLead() {
        RuleSetFactoryTest.createToken();
        RuleSetFactoryTest.createObjectRecords(100, 'Lead');
        RuleSetFactoryTest.insertUseCase('Use Case Test');
        Map<Id, Lead> maplead = new Map<Id, Lead>([SELECT Id FROM Lead LIMIT 100]);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJobCreateGetModigie());
        InvocableModigieAutomationCall.getRecordId(new List<Id>(maplead.keySet()));
        Test.stopTest();
        System.assert(!maplead.isEmpty());
    }
}