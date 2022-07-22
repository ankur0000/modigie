@isTest
public class leadlistviewclassTest {
    
    @isTest
    public static void test1(){
        List<Lead> leadList = new List<Lead>();
        
        Lead l = new Lead();
        l.FirstName = 'Test';
        l.LastName = 'Lead';
        l.Company = 'Test Company';
        leadList.add(l);
        
        insert leadList;
        system.assert(leadList.size()>0);
        
        Test.StartTest(); 
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(leadList);
        leadlistviewclass leadview = new leadlistviewclass(sc);
        Test.StopTest();
    }

}