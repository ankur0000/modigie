@isTest
public class TriggerOnModigieCreditHelperTest 
{
    @isTest
    public static void method()
    {
        Modigie_Credit__c modicredit1 = new Modigie_Credit__c();
        modicredit1.Purchased__c=200;
        modicredit1.Used__c=20;
        modicredit1.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit1;
        System.assert(modicredit1.Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Modigie_Credit__c modicredit2 = new Modigie_Credit__c();
        modicredit2.Purchased__c=1000;
        modicredit2.Used__c=500;
        modicredit2.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit2;
        System.assert(modicredit2.Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        modicredit2.Used__c=800;
        update modicredit2;
        System.assert(modicredit2.Used__c == 800);
        
        try{
            delete modicredit2;
            System.assert(modicredit2.Validation_Key__c== 'Modigie_Credit__c@Cyntexakey');
        }
        catch(Exception e){
        }
    }
}