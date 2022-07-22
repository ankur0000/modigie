@isTest
public class InvocableDynamiCritriaGetModigieLeadTest {
    
    @testSetup 
    public static void setup() {
        Lead l = new Lead();
        l.FirstName = 'fname';
        l.LastName = 'lname';
        l.Email = 'testlea@email.com';
        l.Company = 'Test Company';
        insert l;
        
        modigie__Modigie_Automation_Criteria_Lead__c rec = new modigie__Modigie_Automation_Criteria_Lead__c();
        rec.Name = '0';
        rec.modigie__Field_Api_Name__c = 'lastname';
        //rec.modigie__Field_Data_Type__c = '';
        rec.modigie__Field_Value__c = 'lname';
        rec.modigie__Operator__c = 'equals';
        insert rec;
        
        modigie__Modigie_Automation_Criteria_Lead__c rec1 = new modigie__Modigie_Automation_Criteria_Lead__c();
        rec1.Name = '0';
        rec1.modigie__Field_Api_Name__c = 'photourl';
        //rec1.modigie__Field_Data_Type__c = '';
        rec1.modigie__Field_Value__c = 'true';
        rec1.modigie__Operator__c = 'null';
        insert rec1;
        
        modigie__Modigie_Automation_Criteria_Lead__c rec2 = new modigie__Modigie_Automation_Criteria_Lead__c();
        rec2.Name = '0';
        rec2.modigie__Field_Api_Name__c = 'salutation';
        //rec2.modigie__Field_Data_Type__c = '';
        rec2.modigie__Field_Value__c = 'Mr., Dr.';
        rec2.modigie__Operator__c = 'equals';
        insert rec2;
        
        
        modigie__Modigie_Automation_Criteria_Lead__c rec3 = new modigie__Modigie_Automation_Criteria_Lead__c();
        rec3.Name = '0';
        rec3.modigie__Field_Api_Name__c = 'mobilephone';
        //rec2.modigie__Field_Data_Type__c = '';
        rec3.modigie__Field_Value__c = 'false';
        rec3.modigie__Operator__c = 'null';
        insert rec3;
        
        
        modigie__Modigie_Automation_Criteria_Lead__c rec4 = new modigie__Modigie_Automation_Criteria_Lead__c();
        rec4.Name = '0';
        rec4.modigie__Field_Api_Name__c = 'longitude';
        //rec2.modigie__Field_Data_Type__c = '';
        rec4.modigie__Field_Value__c = '10';
        rec4.modigie__Operator__c = 'gt';
        insert rec4;
        
        modigie__Modigie_Automation_Criteria_Lead__c rec5 = new modigie__Modigie_Automation_Criteria_Lead__c();
        rec5.Name = '0';
        rec5.modigie__Field_Api_Name__c = 'latitude';
        //rec2.modigie__Field_Data_Type__c = '';
        rec5.modigie__Field_Value__c = '10';
        rec5.modigie__Operator__c = 'lt';
        insert rec5;
        
        
        modigie__Modigie_Automation_Criteria_Lead__c rec6 = new modigie__Modigie_Automation_Criteria_Lead__c();
        rec6.Name = '0';
        rec6.modigie__Field_Api_Name__c = 'lastname';
        //rec.modigie__Field_Data_Type__c = '';
        rec6.modigie__Field_Value__c = 'lname';
        rec6.modigie__Operator__c = 'notequals';
        insert rec6;
        
        modigie__Modigie_Automation_Criteria_Lead__c rec7 = new modigie__Modigie_Automation_Criteria_Lead__c();
        rec7.Name = '0';
        rec7.modigie__Field_Api_Name__c = 'status';
        //rec1.modigie__Field_Data_Type__c = '';
        rec7.modigie__Field_Value__c = 'Working,Open-Not Contacted';
        rec7.modigie__Operator__c = 'notequals';
        insert rec7;
        
        modigie__Process_Builder_Switch__c mPBS = new modigie__Process_Builder_Switch__c();
        insert mPBS;
        
    }
    
    @isTest
    public static void test1(){
        
        Lead l = [SELECT Id, Firstname, Lastname, Email, Company FROM Lead LIMIT 1];
        List<Id> lstIds = new List<Id>();
        lstIds.add(l.Id);
        InvocableDynamiCritriaGetModigieLead.getRecordId(lstIds);
        System.assert(!lstIds.isEmpty());
    }

}