@isTest
public class ScheduledContactBatchTest
{
    @isTest
    public static void main()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='vaibhav@cyntexa.com', 
                          EmailEncodingKey='UTF-8', LastName='Vaibhav Vyas', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='vaibv@modigie.com');
        insert u;
        
        
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        list<Contact> clist = new list<Contact>();
        list<Lead> llist = new list<Lead>();
        
        Lead l = new Lead();
        l.FirstName = 'Test';
        l.LastName = 'Lead';
        l.Company='Testing';
        l.Email = 'testlead@nomail.com';
        llist.add(l);
        insert llist ;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.modigie__linkedin_url__c = 'test.linkein.com';
        con.AccountId = acc.Id;
        con.modigie__Modigie_Verified_Number__c = '12234';
        con.MobilePhone = '3453';
        
        clist.add(con);
        
        
        insert clist;
        
        Integer len = 11;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String jobid = str.substring(0, len);
        
        
        
        Modigie__c modi2 = new Modigie__c();
        modi2.Contact__c = con.id;
        modi2.Jobid__c = jobid;
        modi2.Status__c = 'Validated';
        modi2.Date_Last_Updated__c = Date.today();
        modi2.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert modi2;
        
        Modigie__c modi3 = new Modigie__c();
        modi3.Lead__c = l.id;
        modi3.Jobid__c = jobid;
        //modi3.Status__c = 'In Escalation';
        modi3.Date_Last_Updated__c = Date.today();
        modi3.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert modi3;
        
        Modigie__c modi4 = new Modigie__c();
        modi4.Lead__c = l.id;
        modi4.Jobid__c = jobid;
        modi4.Status__c = 'In process';
        modi4.Date_Last_Updated__c = Date.today();
        modi4.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert modi4;
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToCheckEscalation());
        ScheduleToCheckEscalationStatus s = new ScheduleToCheckEscalationStatus();
        String sch = '0  00 1 3 * ?';
       system.schedule('test',sch,s);
        test.stopTest();
    }
}