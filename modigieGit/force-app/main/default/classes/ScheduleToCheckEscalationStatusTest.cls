@isTest
public class ScheduleToCheckEscalationStatusTest {
    @isTest
    public static void method(){
          
        
      	RuleSetFactoryTest.createToken();
        Lead l = new Lead();
        l.FirstName = 'Test';
        l.LastName = 'Lead';
        l.Company='Testing';
        l.Email = 'testlead@nomail.com';
        insert l ;
        list<contact> clist = new list<contact>();
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'testcontact@nomail.com';
        insert con;
        clist.add(con);
        
        Integer len = 11;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        Decimal jobid = Decimal.valueOf(str.substring(0, len));
        
        
        Modigie__c modi = new Modigie__c();
        modi.Lead__c = l.Id;
        modi.Contact__c=con.id;
        modi.Jobid__c = String.valueOf(jobid);
        modi.Status__c = 'In process';
        modi.Date_Last_Updated__c = Date.today();
        modi.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert modi;
        
        test.startTest();
        ScheduleToCheckEscalationStatus s = new ScheduleToCheckEscalationStatus();
        String sch = '0  00 1 3 * ?';
        system.schedule('test',sch,s);
        test.stopTest();
    }
}