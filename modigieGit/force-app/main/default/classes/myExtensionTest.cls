@isTest
public class myExtensionTest {	 
    static testMethod void first(){
        Test.startTest();
        
        Account obj = new Account(Name ='Test');
        insert obj;
        system.assert(obj.Name == 'Test');
        
        PageReference pageRef = Page.ModigieConfigurationVFPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(obj.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        myExtension testAccPlan = new myExtension(sc);
        
        Test.stopTest();
    }
}