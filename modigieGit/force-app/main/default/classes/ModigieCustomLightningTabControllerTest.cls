@isTest
public class ModigieCustomLightningTabControllerTest 
{
    @isTest
    public static void test1(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Time timeChange = Time.newInstance(11,12,12,0); 
        Time timeChange1 = Time.newInstance(11,13,12,0); 
        modigie__Modigie__c mm = new modigie__Modigie__c();
        mm.modigie__Status__c = 'Not started';
        mm.modigie__Job_start__c = timeChange;   
        mm.modigie__Job_end__c = timeChange1;
        mm.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        mm.modigie__Parent_Id__c = acc.Id;
        insert mm;
        test.startTest();
        ModigieCustomLightningTabController obj = new ModigieCustomLightningTabController();
        System.assertNotEquals(obj,null);
        test.stopTest();        
    }
    
}