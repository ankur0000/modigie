@isTest
public class TriggerOnLeadTest 
{

    @testSetup
    public static void makeData()
    {
        modigie__Process_Builder_Switch__c pbs = new modigie__Process_Builder_Switch__c();
        pbs.modigie__Is_Active_Lead_Alt_LinkedIn_Url__c = true;
        pbs.modigie__Lead_Alt_LinkedIn_Url_Field_Name__c = 'modigie__Test_Alternate_Linked_Url__c';
        insert pbs;
    }

    @isTest
    public static void test1()
    {
        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'lead';
        l.Company = 'test company';
        l.modigie__Modigie_Verified_Number__c = '2353456457';
        l.IsConverted = false;
        
        insert l;
        System.assert(l.FirstName == 'test');
        
        l.FirstName = null;
        Test.startTest();
        update l;
        System.assert(l.FirstName == null);
        
        Test.stopTest();
        List<Lead> lds = [select id,modigie__Modigie_Verified_Number__c,FirstName from Lead];
        System.assertEquals('2353456457',lds.get(0).modigie__Modigie_Verified_Number__c);
    }
    
    @isTest
    public static void test2()
    {
        Integer len = 11;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String jobid = str.substring(0, len);
        
        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'lead';
        l.Company = 'test company';
        l.modigie__Modigie_Verified_Number__c = '2353456457';
        insert l;
        System.assert(l.Company == 'test company');
        
        Modigie__c modirec = new Modigie__c();
        modirec.Lead__c = l.id;
        modirec.Jobid__c = jobid;
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        delete l;
        System.assert(l.modigie__Modigie_Verified_Number__c == '2353456457');
    }
    
    @isTest
    public static void test3()
    {
        Integer len = 11;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String jobid = str.substring(0, len);
        
        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'lead';
        l.Company = 'test company';
        l.modigie__Validation_Key__c = 'modigie__Validation_Key__c';
        l.modigie__Modigie_Verified_Number__c = '2353456457';
        insert l;
        System.assert(l.FirstName == 'test');
        
        delete l;
        System.assert(l.modigie__Modigie_Verified_Number__c == '2353456457');
        
        Test.startTest();
        undelete l;
        Test.stopTest();
        System.assert(l.FirstName == 'test');
    }
    
    @isTest
    public static void test4()
    {
        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'lead';
        l.Company = 'test company';
        l.modigie__Modigie_Verified_Number__c = '2353456457';
        l.IsConverted = false;
        
        insert l;
        System.assert(l.FirstName == 'test');
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
    }

    @isTest
    public static void test5()
    {
        List<PermissionSetAssignment> pml = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() AND PermissionSet.Name in ('Modigie_Admin', 'Modigie_Automation_User', 'Modigie_User')];
       Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        
       	Lead ld = new Lead(lastName = 'Test', modigie__Test_Alternate_Linked_Url__c = 'https://www.linkedin.com/in/test1', Company = 'Test Account');
        insert ld;
        Lead getLd = [SELECT modigie__linkedin_url__c FROM Lead Where Id = :ld.Id];
        if(pml.isEmpty()){
            System.assert(getLd.modigie__linkedin_url__c == null);
        }else{
            System.assert(getLd.modigie__linkedin_url__c == 'https://www.linkedin.com/in/test1');
        }
        getLd.modigie__Test_Alternate_Linked_Url__c = 'https://www.linkedin.com/in/test2';
        update getLd;
        getLd = [SELECT modigie__linkedin_url__c FROM Lead Where Id = :getLd.Id];
    }

    @isTest
    public static void testTom()
    {
        Date today = Date.today();
        modigie__TOM__c tom = new modigie__TOM__c(modigie__startDate__c = today, modigie__endDate__c = today, modigie__isActive__c = true, modigie__Lead_Priority_4__c = 'mobilephone', modigie__Lead_Priority_5__c = 'phone', modigie__Lead_Priority_6__c = '');
        insert tom;
        RuleSetFactoryTest.insertTomCriteria();
        List<Lead> ld = new List<Lead>();
        ld.add(new lead(lastName = 'Test', Company = 'Test', Email = 'test@test.com', mobilephone = '43626', phone = '6235352'));
        ld.add(new lead(lastName = 'Non', Company = 'Enrich', Email = 'test@test.com', mobilephone = '43626', phone = '6235352'));
        insert ld;
        System.assert(ld[0].Id != null);
    }
}