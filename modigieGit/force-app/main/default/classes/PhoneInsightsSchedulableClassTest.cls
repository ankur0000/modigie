@isTest
private class PhoneInsightsSchedulableClassTest { 
    @testSetup 
    static void setup() {
        
        modigie__Modigie_Configurator__c modConf = new modigie__Modigie_Configurator__c();
        modConf.modigie__ConfigurerId__c = UserInfo.getUserId();
        insert modConf;

        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        
        
       	Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
		
        
        // Lead ld = new Lead();
        // ld.FirstName = 'Test';
        // ld.LastName = 'Test';
        // ld.company = 'Company';
        // ld.modigie__Modigie_Verified_Number__c = '12234';
        // ld.MobilePhone = '3453';
        // ld.modigie__linkedin_url__c = 'test.linkein.com';
        // insert ld;
        Time timeChange = Time.newInstance(11,12,12,0); 
        Time timeChange1 = Time.newInstance(11,13,12,0); 
        modigie__Modigie__c mm = new modigie__Modigie__c();
        // mm.modigie__Status__c = 'Not started';
        mm.modigie__Job_start__c = timeChange;   
        // mm.modigie__Contact__c = con.Id;
        // mm.modigie__Lead__c = ld.Id;
        mm.modigie__Job_end__c = timeChange1;
        mm.modigie__Validate_Employer_Status__c = 'In Process';
        mm.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert mm;
        
        modigie__Process_Builder_Switch__c pbs = new modigie__Process_Builder_Switch__c();
        
        
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
        pbs.modigie__Unresponsive_Lead_Toggle__c = true;
        pbs.modigie__Get_Phone_Insights__c = true;
        pbs.modigie__Get_linkedin_url__c = true;
        pbs.modigie__No_Phone_Information__c = false;
        pbs.modigie__Validate_Employer__c = false;
        pbs.modigie__Opportunity_Contact_Enrichment__c = true;
        pbs.modigie__Unresponsive_Lead_Toggle__c = true;
        pbs.modigie__Phone_Insights_Data_Maintenance__c = true;
        pbs.modigie__Validate_Employer_Data_Maintenance__c = true;
        pbs.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        pbs.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
       	pbs.modigie__Get_Phone_Insights_Phone_Number_Selected__c = '{"selectedFieldsLead":"Phone,Mobile,Other","selectedFieldsContact":"Phone,Other,Mobile,"}';
        insert pbs;
    }
    
    @isTest
    static void unitTest1(){
        /*modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = true;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
        insert ps;*/
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.modigie__linkedin_url__c = 'test.linkein.com';
        con.AccountId = acc.Id;
        // con.modigie__Modigie_Verified_Number__c = '12234';
        con.MobilePhone = '3453';
        //insert con;
        
        Lead ld = new Lead();
        ld.FirstName = 'Test';
        ld.LastName = 'Test';
        ld.company = 'Company';
        // ld.modigie__Modigie_Verified_Number__c = '12234';
        ld.MobilePhone = '3453';
        ld.modigie__linkedin_url__c = 'test.linkein.com';
        //insert ld;
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        PhoneInsightsSchedulableClass SC = new PhoneInsightsSchedulableClass(); 
        Id jobId = System.schedule('Schedule', sched, SC);
       
        
        // System.assertEquals(con.FirstName,'Test');
        Test.stopTest();
        System.assert(jobId != null);
    }
    
    
    @isTest
    static void unitTest2(){
        /*modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = true;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
        insert ps;*/
        
        
        
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
        insert con;
        
        Lead ld = new Lead();
        ld.FirstName = 'Test';
        ld.LastName = 'Test';
        ld.company = 'Company';
         ld.modigie__Modigie_Verified_Number__c = '12234';
        ld.MobilePhone = '3453';
        ld.modigie__linkedin_url__c = 'test.linkein.com';
       // insert ld;
        
        modigie__Process_Builder_Switch__c pbs = [SELECT modigie__Phone_Insights_Data_Maintenance_Limits__c, modigie__Phone_Insights_Data_Maintenance_Usage__c FROM modigie__Process_Builder_Switch__c LIMIT 1];
        pbs.modigie__Phone_Insights_Data_Maintenance_Limits__c=0;
        pbs.modigie__Phone_Insights_Data_Maintenance_Usage__c=0;
        
        update pbs;
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        PhoneInsightsSchedulableClass SC = new PhoneInsightsSchedulableClass(); 
        Id jobId = System.schedule('Schedule', sched, SC);
       
        
        // System.assertEquals(con.FirstName,'Test');
        Test.stopTest();
        System.assert(jobId != null);
    }
    // @isTest
    // static void unitTest2(){
    
    //     Lead ld = new Lead();
    //     ld.FirstName = 'Test';
    //     ld.LastName = 'Test';
    //     ld.company = 'Company';
    //     // ld.modigie__Modigie_Verified_Number__c = '12234';
    //     ld.MobilePhone = '3453';
    //     ld.modigie__linkedin_url__c = 'test.linkein.com';
    //     insert ld;
    //     Test.setMock(HttpCalloutMock.class, new JwtapexMock());
    //     Test.startTest();
    //         try{
    //             String sched = '0 00 00 * * ?';  //Every Day at Midnight
    //         PhoneInsightsSchedulableClass SC = new PhoneInsightsSchedulableClass(); 
    //         System.schedule('Schedule', sched, SC);
    //         }catch(exception e){
    
    //         }
    //     Test.stopTest();
    // }
}