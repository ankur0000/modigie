@isTest
public class TemplatesComponentControllerTest {
    public static testMethod void getProcessStatesTest(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;  
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Half - yearly');
        Test.startTest();
        String result = TemplatesComponentController.getProcessStates();
        System.assertNotEquals(NULL, result);
        Test.stopTest();
    }
    
    public static testMethod void changeProcessToggleTest(){
        
        Account acc = new Account(Name = 'TestAccount');
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'Test State';
        acc.BillingCountry = 'Test Country';
        acc.BillingPostalCode = '23564';
        insert acc;
        System.assert(acc.Name == 'TestAccount');
        
        Contact con = new Contact(AccountId = acc.Id);
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'testcontact@nomail.com';
        con.modigie__Company_Email__c = 'companyemail@test.com';
        insert con;
        system.assert(con.modigie__Company_Email__c == 'companyemail@test.com');
        
        Lead l = new Lead();
        l.FirstName ='Test'; 
        l.LastName = 'Lead'; 
        l.Company = 'Test & Company'; 
        l.Email = 'testemail@nomail.com'; 
        l.modigie__Company_Email__c = 'companyemail@test.com'; 
        l.modigie__Company_URL__c = 'companyurl@test.com'; 
        l.modigie__linkedin_url__c = 'linkedinurl@test.com'; 
        l.MobilePhone = '6556612987';
        insert l;
        system.assert(l.MobilePhone == '6556612987');
        
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
        ps.modigie__Get_Phone_Insights_Phone_Number_Selected__c = '{"selectedFieldsContact":"Mobile,","selectedFieldsLead":"Mobile,"}';
        ps.modigie__Limits_No_Limits_Selection__c  = 'Limits';
        ps.modigie__Get_Modigie_Invocable_Usage__c = 0;
        ps.modigie__Unresponsive_Lead_Invocable_Usage__c = 0;
        ps.modigie__Phone_Insights_Data_Maintenance_Usage__c = 0;
        ps.modigie__Validate_Employer_Data_Maintenance_Usage__c = 0;
        ps.modigie__Get_Modigie_Campaign_Invocable_Usage__c = 0;
        ps.modigie__Validate_employer_campaign_Usage__c = 0;
        ps.modigie__LinkedIn_Url_Campaign_Usage__c = 0;
        ps.modigie__Modigie_Phone_Insights_Invocable_Usage__c = 0;
        ps.modigie__Validate_Employer_Invocable_Usage__c = 0;
        ps.modigie__LinkedIn_Url_Invocable_Usage__c = 0;
        ps.modigie__Opp_Contact_Enrichment_Invocable_Usage__c  = 0;
        ps.modigie__Get_Modigie_Invocable_Limit__c = 10;
        ps.modigie__Modigie_Phone_Insights_Invocable_Limit__c = 10;
        ps.modigie__Validate_Employer_Invocable_Limit__c = 10;
        ps.modigie__LinkedIn_Url_Invocable_Limits__c = 10;
        ps.modigie__Opp_Contact_Enrichment_Invocable_Limit__c = 10;
        ps.modigie__Unresponsive_Lead_Invocable_Limits__c = 10;
        ps.modigie__Phone_Insights_Data_Maintenance_Limits__c = 10;
        ps.modigie__Validate_Employer_Data_Maintenance_Lmt__c = 10;
        ps.modigie__Get_Modigie_Campaign_Invocable_Limits__c = 10;
        ps.modigie__Validate_employer_campaign_Limits__c = 10;
        ps.modigie__Linkedin_Url_Campaign_Limits__c = 10;
        insert ps;
        system.assert(ps.modigie__Linkedin_Url_Campaign_Limits__c == 10);
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Phone_Insights_Data_Maintenance', false);
        Test.stopTest();
       // TemplatesComponentController.changeProcessToggle('Phone_Insights_Data_Maintenance', true);
        
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Phone_Insights_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(false, pbs.get(0).modigie__Phone_Insights_Data_Maintenance__c);
    }
    public static testMethod void changeProcessToggleTest2(){
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        system.assert(acc.Name == 'Test Account');
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.modigie__linkedin_url__c = 'test.linkein.com';
        con.AccountId = acc.Id;
        con.modigie__Modigie_Verified_Number__c = '12234';
        con.MobilePhone = '3453';
        insert con;
        system.assert(con.MobilePhone == '3453');
        
        Lead ld = new Lead();
        ld.FirstName = 'Test';
        ld.LastName = 'Test';
        ld.company = 'Company';
        ld.modigie__Modigie_Verified_Number__c = '12234';
        ld.MobilePhone = '3453';
        ld.modigie__linkedin_url__c = 'test.linkein.com';
        insert ld;
        system.assert(ld.modigie__linkedin_url__c == 'test.linkein.com');
        
        Time timeChange = Time.newInstance(11,12,12,0); 
        Time timeChange1 = Time.newInstance(11,13,12,0); 
        modigie__Modigie__c mm = new modigie__Modigie__c();
        // mm.modigie__Status__c = 'Not started';
        mm.modigie__Job_start__c = timeChange;   
        mm.modigie__Contact__c = con.Id;
        // mm.modigie__Lead__c = ld.Id;
        mm.modigie__Job_end__c = timeChange1;
        mm.modigie__Validate_Employer_Status__c = 'Not started';
        mm.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert mm;
        system.assert(mm.Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Half - yearly');
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Validate_Employer_Data_Maintenance', false);
        TemplatesComponentController.setInvocableLimits('Get_Modigie_Campaign_Invocable_Limits',5);
        
        TemplatesComponentController.setInvocableLimits('Unresponsive_Lead_Get_Modigie_Limit',5);
        
        TemplatesComponentController.setInvocableLimits('Unresponsive_Lead_Verify_Employer_Limit',5);
        // try{
        //     TemplatesComponentController.changeProcessToggle('Validate_Employer_Data_Maintenance', true);
        // }catch(exception e){
        // }
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Validate_Employer_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(false, pbs.get(0).modigie__Validate_Employer_Data_Maintenance__c);
    }
    public static testMethod void changeProcessToggleTest3(){
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = false;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Half - yearly');
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        try{
            TemplatesComponentController.changeProcessToggle('Unresponsive_Lead_Toggle', false);
        }catch(exception e){
        }
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Unresponsive_Lead_Toggle__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(false, pbs.get(0).modigie__Unresponsive_Lead_Toggle__c);
    }
    
    public static testMethod void changeProcessToggleTest4(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Monthly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Monthly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Monthly');
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Phone_Insights_Data_Maintenance', true);
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Phone_Insights_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(true, pbs.get(0).modigie__Phone_Insights_Data_Maintenance__c);
    }
    
    public static testMethod void changeProcessToggleTest5(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Quarterly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Quarterly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Quarterly');
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Phone_Insights_Data_Maintenance', true);
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Phone_Insights_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(true, pbs.get(0).modigie__Phone_Insights_Data_Maintenance__c);
    }
    
    public static testMethod void changeProcessToggleTest6(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Quarterly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Quarterly');
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Phone_Insights_Data_Maintenance', true);
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Phone_Insights_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(true, pbs.get(0).modigie__Phone_Insights_Data_Maintenance__c);
    }
    
    public static testMethod void changeProcessToggleTest60(){
        Test.startTest();
        Boolean isExceptionOccure = false;
        try{
            TemplatesComponentController.changeProcessToggle('SPhone_Insights_Data_Maintenance', true);
        }catch(exception e){
            isExceptionOccure = true;
            System.assertEquals(true,isExceptionOccure);
            
        }
        Test.stopTest();
        
    }
    
    public static testMethod void changeProcessToggleTest7(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Monthly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Monthly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Monthly');
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Validate_Employer_Data_Maintenance', true);
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Validate_Employer_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(true, pbs.get(0).modigie__Validate_Employer_Data_Maintenance__c);
    }
    
    public static testMethod void changeProcessToggleTest8(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Quarterly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Quarterly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Quarterly');
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Validate_Employer_Data_Maintenance', true);
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Validate_Employer_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(true, pbs.get(0).modigie__Validate_Employer_Data_Maintenance__c);
    }
    
    public static testMethod void changeProcessToggleTest9(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Yearly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Yearly');
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Validate_Employer_Data_Maintenance', true);
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Validate_Employer_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(true, pbs.get(0).modigie__Validate_Employer_Data_Maintenance__c);
    }
    
    public static testMethod void changeProcessToggleTest10(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Half - yearly');
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Validate_Employer_Data_Maintenance', true);
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Validate_Employer_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(true, pbs.get(0).modigie__Validate_Employer_Data_Maintenance__c);
    }
    
    public static testMethod void setPhoneNumberForInsightsTest(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Half - yearly');
        Test.startTest();
        TemplatesComponentController.setPhoneNumberForInsights('{"selectedFieldsContact":"Mobile,","selectedFieldsLead":"Mobile,"}');
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [SELECT Id,modigie__Get_Phone_Insights_Phone_Number_Selected__c FROM modigie__Process_Builder_Switch__c];
        System.assertEquals('{"selectedFieldsContact":"Mobile,","selectedFieldsLead":"Mobile,"}', pbs.get(0).modigie__Get_Phone_Insights_Phone_Number_Selected__c);       
    }
    
    public static testMethod void setPhoneNumberForInsightsTest2(){
        Test.startTest();
        TemplatesComponentController.setPhoneNumberForInsights('{"selectedFieldsContact":"Mobile,","selectedFieldsLead":"Mobile,"}');
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [SELECT Id,modigie__Get_Phone_Insights_Phone_Number_Selected__c FROM modigie__Process_Builder_Switch__c];
        System.assertEquals('{"selectedFieldsContact":"Mobile,","selectedFieldsLead":"Mobile,"}', pbs.get(0).modigie__Get_Phone_Insights_Phone_Number_Selected__c);       
    }
    
    public static testMethod void getPhoneNumberForInsightsTest(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
        ps.modigie__Get_Phone_Insights_Phone_Number_Selected__c = '{"selectedFieldsContact":"Mobile,","selectedFieldsLead":"Mobile,"}';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Half - yearly');
        Test.startTest();
        String result = TemplatesComponentController.getPhoneNumberForInsights();
        System.assertEquals('{"selectedFieldsContact":"Mobile,","selectedFieldsLead":"Mobile,"}', result);       
        Test.stopTest();
    }
    
    public static testMethod void getPhoneNumberForInsightsTest2(){
        
        Test.startTest();
        TemplatesComponentController.getPhoneNumberForInsights();
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [SELECT Id FROM modigie__Process_Builder_Switch__c];
        System.assertEquals(1, pbs.size());       
    }
    
    public static testMethod void changeProcessToggleNewTest(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = true;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Monthly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Monthly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Monthly');
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Validate_Employer_Data_Maintenance', true);
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Validate_Employer_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(true, pbs.get(0).modigie__Validate_Employer_Data_Maintenance__c);
    }
    
    public static testMethod void changeProcessToggleNewTest2(){
        
        Test.startTest();
        Boolean isExceptionOccure = false;
        try{
            TemplatesComponentController.changeProcessToggle('Validate_Employer_Data_Maintenance', true);
        }catch(exception e){
            isExceptionOccure = true;
            System.assertEquals(true,isExceptionOccure);
            
        }
        Test.stopTest();
    }
    
    public static testMethod void changeProcessToggleNewTest3(){
        
        /*Account a = new account(name = 'test');
        insert a;
        
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.Firstname = 'test';
        c.LastName = 'test';
        c.Email = 'abc@xyz.com';
        c.modigie__linkedin_url__c = 'https://www.linkedin.com';
        insert c;
        
        Lead l = new Lead();
        l.Firstname = 'test';
        l.LastName = 'test';
        l.company = 'test';
        l.Status = 'Open - Not Contacted';
        l.modigie__linkedin_url__c = 'https://www.linkedin.com';
        insert l;*/
        
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Limits_No_Limits_Selection__c  = 'Limits';
        ps.modigie__Phone_Insights_Data_Maintenance_Usage__c = 0;
        ps.modigie__Phone_Insights_Data_Maintenance_Limits__c = 10;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = true;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Monthly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Monthly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Monthly');
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Phone_Insights_Data_Maintenance', true);
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Validate_Employer_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(true, pbs.get(0).modigie__Validate_Employer_Data_Maintenance__c);
    }
    
    public static testMethod void changeProcessToggleNewTest4(){
        
        /*Account a = new account(name = 'test');
        insert a;
        
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.Firstname = 'test';
        c.LastName = 'test';
        c.Email = 'abc@xyz.com';
        c.modigie__linkedin_url__c = 'https://www.linkedin.com';
        insert c;
        
        Lead l = new Lead();
        l.Firstname = 'test';
        l.LastName = 'test';
        l.company = 'test';
        l.Status = 'Open - Not Contacted';
        l.modigie__linkedin_url__c = 'https://www.linkedin.com';
        insert l;*/
        
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Limits_No_Limits_Selection__c  = 'Limits';
        ps.modigie__Phone_Insights_Data_Maintenance_Usage__c = 0;
        ps.modigie__Phone_Insights_Data_Maintenance_Limits__c = 1;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = true;
        ps.modigie__Selected_time_interval_phone_insights__c = 'Monthly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Monthly';
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Monthly');
        Test.startTest();
        TemplatesComponentController.changeProcessToggle('Phone_Insights_Data_Maintenance', true);
        Test.stopTest();
        List<modigie__Process_Builder_Switch__c> pbs = [select id, modigie__Validate_Employer_Data_Maintenance__c from modigie__Process_Builder_Switch__c];
        System.assertEquals(true, pbs.get(0).modigie__Validate_Employer_Data_Maintenance__c);
    }

    
    public static testMethod void testCheckFieldExistance(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Get_Phone_Insights__c = true;
        ps.modigie__Get_linkedin_url__c = true;
        ps.modigie__No_Phone_Information__c = false;
        ps.modigie__Validate_Employer__c = false;
        ps.modigie__Opportunity_Contact_Enrichment__c = true;
        ps.modigie__Unresponsive_Lead_Toggle__c = true;
        ps.modigie__Phone_Insights_Data_Maintenance__c = true;
        ps.modigie__Validate_Employer_Data_Maintenance__c = false;  
        ps.modigie__Selected_time_interval_phone_insights__c = 'Half - yearly';
        ps.modigie__Selected_time_interval_validate_employer__c = 'Half - yearly';
        ps.modigie__Is_Active_Contact_Alt_LinkedIn_Url__c = false;
		ps.modigie__Is_Active_Lead_Alt_LinkedIn_Url__c = false;
        insert ps;
        system.assert(ps.modigie__Selected_time_interval_validate_employer__c == 'Half - yearly');
        Test.startTest();
       		SelectLinkedinFieldController.checkFieldExistence();
       Test.stopTest();
    }
    
    public static testMethod void testSaveAltFieldSettings(){
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Is_Active_Contact_Alt_LinkedIn_Url__c = false;
		ps.modigie__Is_Active_Lead_Alt_LinkedIn_Url__c = false;
        insert ps;
		
        Map<String,Object> inputMap = new Map<String,Object>{'modigie__Lead_Alt_LinkedIn_Url_Field_Name__c'=>'Test_Alternate_Linked_Url', 'modigie__Contact_Alt_LinkedIn_Url_Field_Name__c'=>'Test_LinkedIn_Api_Name', 'modigie__Is_Active_Contact_Alt_LinkedIn_Url__c'=>false, 'modigie__Is_Active_Lead_Alt_LinkedIn_Url__c'=>false};
        Test.startTest();
        	SelectLinkedinFieldController.saveAltFieldSettings(JSON.serialize(inputMap));
        Test.stopTest();
        modigie__Process_Builder_Switch__c pbs = [SELECT modigie__Lead_Alt_LinkedIn_Url_Field_Name__c, modigie__Contact_Alt_LinkedIn_Url_Field_Name__c FROM modigie__Process_Builder_Switch__c WHERE Id = :ps.Id];
        System.assert(pbs.modigie__Lead_Alt_LinkedIn_Url_Field_Name__c == 'Test_Alternate_Linked_Url' && pbs.modigie__Contact_Alt_LinkedIn_Url_Field_Name__c == 'Test_LinkedIn_Api_Name');
    }
    public static testMethod void testNewMethods(){
        modigie__Modigie_Rule_Sets__c ruleset = new modigie__Modigie_Rule_Sets__c();
        ruleset.Name = '2022-02-07T14:32:14.527+0000963';
        ruleset.modigie__Rule_Set_Name__c = 'ruleset1';
        insert ruleset;
        modigie__Process_Builder_Switch__c ps = new modigie__Process_Builder_Switch__c();
        ps.modigie__Opportunity_Contact_Get_Modigie__c = true;
        insert ps;
        
        modigie__Modigie_Rule_Sets__c getruleset = [SELECT Name, Id, modigie__Rule_Set_Name__c FROM modigie__Modigie_Rule_Sets__c LIMIT 1];
        Test.startTest();
        Map<String, Object> analysisData = TemplatesComponentController.getAnalysisData(getruleset.Id);
        modigie__Modigie_Rule_Sets__c returnedRuleset = TemplatesComponentController.changeStatus(getruleset.Id);
        String status = TemplatesComponentController.saveStatus();
        List<Object> allRulesets = TemplatesComponentController.getAllRulesets(false);
        String result = TemplatesComponentController.deleteTheRuleset(getruleset.Id);
        test.stopTest();
        List<modigie__Modigie_Rule_Sets__c> mrsL = [SELECT Id FROM modigie__Modigie_Rule_Sets__c WHERE Id = :getruleset.Id LIMIT 1];
        System.assert(mrsL.isEmpty());
    }
    @isTest
    public static void testForNewMethod(){
        modigie__Modigie_Automation_Criteria_Lead__c newLeadCrit = new modigie__Modigie_Automation_Criteria_Lead__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        modigie__Modigie_Automation_Criteria_Contact__c newContCrit = new modigie__Modigie_Automation_Criteria_Contact__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        insert newLeadCrit;
        insert newContCrit;
        modigie__Process_Builder_Switch__c mPBS = new modigie__Process_Builder_Switch__c();
        insert mPBS;
        List<List<map<string,string>>> criteriaList = new List<List<map<string,string>>>();
        List<map<string,string>> leadCriteriaList = new List<map<string,string>>();
        List<map<string,string>> contactCriteriaList = new List<map<string,string>>();
        leadCriteriaList.add(new map<string,string>{'CriteriaValue'=>'newComp','SelectedField'=>'modigie__Company_URL__c','SelectedOperator'=>'equals'});
        contactCriteriaList.add(new map<string,string>{'CriteriaValue'=>'newComp','SelectedField'=>'modigie__Company_URL__c','SelectedOperator'=>'equals'});
        criteriaList.add(leadCriteriaList);
        criteriaList.add(contactCriteriaList);
        
        List<String> logicCriteria = new List<String>();
        logicCriteria.add('2');
        logicCriteria.add('');
        logicCriteria.add('3');
        logicCriteria.add('1 OR 1');
        
        modigie__Modigie_Rule_Sets__c ruleset = new modigie__Modigie_Rule_Sets__c();
        ruleset.Name = '2022-02-07T14:32:14.527+0000963';
        ruleset.modigie__Rule_Set_Name__c = 'ruleset1';
        insert ruleset;
        //modigie__creditAccountDetails__c creditDetail = [SELECT modigie__Credit_Id__c , modigie__Title__c FROM modigie__creditAccountDetails__c limit 1 ];
		modigie__creditAccountDetails__c creditDetail = new modigie__creditAccountDetails__c();
        creditDetail.name='test';
        creditDetail.modigie__Credit_Id__c='123445675653';
        insert creditDetail;
        map<string,string> rulesetDetails = new map<string,string>{'title' => 'title',
                'description' => 'description',
                'automationTrigger' => '1',
                'numberOfRequests'=> '2',
                'maintainQueue'=> 'true',
                'Limits_No_Limits_Selection'=> 'Limits',
                'leadSelectedLogic'=> '1',
                'contactSelectedLogic'=> '1',
                'leadLogic'=> '',
                'contactLogic'=> '',
                'isActive'=> 'true',
            'creditRecordId' =>creditDetail.id};
        String editRulesetId = null;
        String result = TemplatesComponentController.saveRulesetDetails(rulesetDetails, criteriaList, editRulesetId);
        editRulesetId = ruleset.Id;
        String result2 = TemplatesComponentController.saveRulesetDetails(rulesetDetails, criteriaList, editRulesetId);
        
        System.assert(result != null && result2 != null);
        
        
        modigie__TOM__c tom;
        tom= new modigie__TOM__c(SetupOwnerId = UserInfo.getOrganizationId(),modigie__isActive__c=true);
        tom.modigie__endDate__c=Date.today()+5;
        tom.modigie__Performance_Rulesets_UnlockUntilTime__c=Datetime.now();
        tom.modigie__startDate__c=Date.today();
        insert tom;
        TemplatesComponentController.getUnlockTimeAndReason();
    }
}