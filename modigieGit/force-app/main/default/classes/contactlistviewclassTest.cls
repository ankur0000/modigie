@isTest
public class contactlistviewclassTest {
    
    @isTest
    public static void test1(){
        
        List<Contact> conList = new List<Contact>();
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        system.assert(acc.Name == 'Test Account');
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.AccountId = acc.Id;
        conList.add(con);
        
        insert conList;
        system.assert(conList.size()>0);
        
        Test.StartTest(); 
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(conList);
        contactlistviewclass conview = new contactlistviewclass(sc);
        Test.StopTest();
    }

}