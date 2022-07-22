@isTest
public class ModigieServicesAsychronousTest {
    
    @testSetup
    public static void testSetup(){
        modigie__Process_Builder_Switch__c pbs = new modigie__Process_Builder_Switch__c();
        pbs.modigie__Get_Phone_Insights_Phone_Number_Selected__c = '{"selectedFieldsLead":"Phone,Mobile,","selectedFieldsContact":"Phone,Other,"}';
        pbs.modigie__Limits_No_Limits_Selection__c  = 'Limits';
        pbs.modigie__Get_Modigie_Invocable_Usage__c = 0;
        pbs.modigie__Unresponsive_Lead_Invocable_Usage__c = 0;
        pbs.modigie__Phone_Insights_Data_Maintenance_Usage__c = 0;
        pbs.modigie__Validate_Employer_Data_Maintenance_Usage__c = 0;
        pbs.modigie__Get_Modigie_Campaign_Invocable_Usage__c = 0;
        pbs.modigie__Validate_employer_campaign_Usage__c = 0;
        pbs.modigie__LinkedIn_Url_Campaign_Usage__c = 0;
        pbs.modigie__Modigie_Phone_Insights_Invocable_Usage__c = 0;
        pbs.modigie__Validate_Employer_Invocable_Usage__c = 0;
        pbs.modigie__LinkedIn_Url_Invocable_Usage__c = 0;
        pbs.modigie__Opp_Contact_Enrichment_Invocable_Usage__c  = 0;
        pbs.modigie__Get_Modigie_Invocable_Limit__c = 10;
        pbs.modigie__Modigie_Phone_Insights_Invocable_Limit__c = 10;
        pbs.modigie__Validate_Employer_Invocable_Limit__c = 10;
        pbs.modigie__LinkedIn_Url_Invocable_Limits__c = 10;
        pbs.modigie__Opp_Contact_Enrichment_Invocable_Limit__c = 10;
        pbs.modigie__Unresponsive_Lead_Invocable_Limits__c = 10;
        pbs.modigie__Phone_Insights_Data_Maintenance_Limits__c = 10;
        pbs.modigie__Validate_Employer_Data_Maintenance_Lmt__c = 10;
        pbs.modigie__Get_Modigie_Campaign_Invocable_Limits__c = 10;
        pbs.modigie__Validate_employer_campaign_Limits__c = 10;
        pbs.modigie__Linkedin_Url_Campaign_Limits__c = 10;
        insert pbs;
        System.assertEquals(pbs.modigie__Linkedin_Url_Campaign_Limits__c, 10);
        
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	   
        
         Account acc = new Account(Name = 'Test Account');
        insert acc;
        System.assertEquals(acc.Name, 'Test Account');
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.modigie__linkedin_url__c = 'test.linkein.com';
        con.AccountId = acc.Id;
        con.MobilePhone = '7654333322';
        con.Phone = '7654333390';
        con.OtherPhone = '5342789012';
        con.Email = 'test@gmail.com';
        insert con;
        System.assertEquals(con.modigie__linkedin_url__c, 'test.linkein.com');
        
        
        Lead ld = new Lead();
        ld.FirstName = 'Test';
        ld.LastName = 'Test';
        ld.company = 'Company';
        ld.MobilePhone = '7654333312';
        ld.Phone = '7647633312';
        ld.modigie__linkedin_url__c = 'test.linkein.com';
        insert ld;
        System.assertEquals(ld.modigie__linkedin_url__c, 'test.linkein.com');
        
    }
    
    
    @isTest
    public static void test1(){
       
       List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Get Modigie Contact'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    
    @isTest
    public static void test2(){
       
       List<Lead> lstLead = [SELECT Id FROM Lead];
        
        List<String> lstIds = new List<String>{lstLead[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Get Modigie Lead'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    
    @isTest
    public static void test3(){
       
       List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Get Linkedin Contact'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    
    @isTest
    public static void test4(){
       
       List<Lead> lstLead = [SELECT Id FROM Lead];
        
        List<String> lstIds = new List<String>{lstLead[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Get Linkedin Lead'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test5(){
       
       List<Lead> lstLead = [SELECT Id FROM Lead];
        List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstLead[0].Id,lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Verify Employer Contact/Lead'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    
    @isTest
    public static void test6(){
       
       List<Lead> lstLead = [SELECT Id FROM Lead];
        List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstLead[0].Id,lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Get Phone Insights Contact/Lead'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test7(){
       
      
        List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Get Modigie Contact Campaign'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test8(){
       
       List<Lead> lstLead = [SELECT Id FROM Lead];
        
        
        List<String> lstIds = new List<String>{lstLead[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Get Modigie Lead Campaign'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    
    @isTest
    public static void test9(){
       
       
        List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Get Linkedin Contact Campaign'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test10(){
       
       List<Lead> lstLead = [SELECT Id FROM Lead];
        List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstLead[0].Id,lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Get Linkedin Lead Campaign'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test11(){
       
       List<Lead> lstLead = [SELECT Id FROM Lead];
        List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstLead[0].Id,lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Verify Employer Campaign'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test12(){
       
       List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Sales Engagement Batch Class'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test13(){
       
       List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Unresponsive Lead Verify Employer'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test14(){
       
       List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Invocable Opportunity Contact Role'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test15(){
       
       List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Dynamic Criteria Get Modigie Lead'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test16(){
       
       List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Dynamic Criteria Get Modigie Contact'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
    @isTest
    public static void test17(){
       
       List<Contact> lstContact = [SELECT Id FROM Contact];
        
        List<String> lstIds = new List<String>{lstContact[0].Id};
        
       Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        
        ModigieServicesAsychronousSchedulable SC = new ModigieServicesAsychronousSchedulable(lstIds,'Unresponsive Lead Get Modigie'); 
        Id jobId = System.schedule('Schedule', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
}