@isTest
public class TestErrorLogClass {
    
    @isTest
    public static void TestUpsert() {
        RuleSetFactoryTest.createToken();
        RuleSetFactoryTest.createObjectRecords(5, 'Lead');
        List<Lead> leadList = [SELECT Id, LastName FROM Lead];
        for(Lead l: leadList){
            l.lastName = '';
        }
        Database.UpsertResult[] saveResults = database.upsert(leadList, false);
        Test.startTest();
        ErrorLogClass.createErrorLog(leadList, 'Id', saveResults, 'Test', 'Test');
        Test.stopTest();
        System.assert(!saveResults.isEmpty());
    }
    @isTest
    public static void TestInsert() {
        List<Lead> leadList = new List<Lead>();
        for(Integer i=1; i<6; i++){
            leadList.add(new Lead(FirstName = 'Test'));
        }
        Database.SaveResult[] saveResults = database.insert(leadList, false);
        Test.startTest();
        ErrorLogClass.createErrorLog(leadList, 'Id', saveResults, 'Test', 'Test');
        Test.stopTest();
        System.assert(!saveResults.isEmpty());
    }
    @isTest
    public static void TestDelete() {
        RuleSetFactoryTest.createObjectRecords(5, 'Lead');
        List<Lead> leadList = [SELECT Id, LastName FROM Lead];
        Database.DeleteResult[] saveResults = database.delete(leadList, false);
        Test.startTest();
        ErrorLogClass.createErrorLog(leadList, 'Id', saveResults, 'Test', 'Test');
        Test.stopTest();
        System.assert(!saveResults.isEmpty());
    }
}