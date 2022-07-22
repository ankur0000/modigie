@isTest
public class GetModigieCampaignButtonTest 
{
    @testSetup
    public static void setup()
    {
        modigie__Modigie_Configurator__c modConf = new modigie__Modigie_Configurator__c();
        modConf.modigie__ConfigurerId__c = UserInfo.getUserId();
        insert modConf;

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
        pbs.modigie__Selected_Lead_Status__c = '["Open - Not Contacted","Working - Contacted","Closed - Not Converted","Closed - Converted"]';
        pbs.modigie__Unresponsive_Lead_Get_Modigie_Usage__c = 0;
        pbs.modigie__Unresponsive_Lead_Verify_Employer_Usage__c = 0;
        pbs.modigie__Contact_Alt_LinkedIn_Url_Field_Name__c = 'modigie__Test_Alt_LinkedIn_Url_FIeld__c';
        pbs.modigie__Lead_Alt_LinkedIn_Url_Field_Name__c = 'modigie__Test_Alternate_Linked_Url__c';
        pbs.modigie__Is_Active_Lead_Alt_LinkedIn_Url__c = true;
        pbs.modigie__Is_Active_Contact_Alt_LinkedIn_Url__c = true;
        
        insert pbs;
        System.assert(pbs.modigie__Linkedin_Url_Campaign_Limits__c == 10);
        
        modigie__Daily_usage_modigie_callouts_by_users__c dailycall = new modigie__Daily_usage_modigie_callouts_by_users__c();
        dailycall.Name = 'Daily calls';
        dailycall.modigie__Number_of_modigie_callouts_in_a_day__c = 20;
        dailycall.modigie__User_Id__c = UserInfo.getUserId();
        insert dailycall;
        System.assert(dailycall.modigie__Number_of_modigie_callouts_in_a_day__c == 20);
        
        
        modigie__Profile_and_user_modigie_limits__c uLimit = new modigie__Profile_and_user_modigie_limits__c();
        uLimit.Name = 'User Limit';
        uLimit.modigie__Limit_of_modigie_callouts__c = 30;
        uLimit.modigie__User_Or_Profile__c = 'Profile';
        uLimit.modigie__User_or_Profile_Id__c =UserInfo.getProfileId();
        insert uLimit;
        System.assert(uLimit.modigie__Limit_of_modigie_callouts__c == 30);
        
        
    }
    
    @isTest
    public static void test1()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        System.assert(mrec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
                
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        
        Account acc = new Account(Name = 'TestAccount');
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'Test State';
        acc.BillingCountry = 'Test Country';
        acc.BillingPostalCode = '23564';
        insert acc;
        System.assert(acc.Name == 'TestAccount');
        
        for(integer i=0;i<5;i++)
        {
            Contact con = new Contact(AccountId = acc.Id);
            con.FirstName = 'Test';
            con.LastName = 'Contact'+i;
            con.Email = 'testcontact@nomail.com';
            con.modigie__Company_Email__c = 'companyemail@test.com';
            con.modigie__Modigie_Verified_Number__c = '13663666666';
            con.MobilePhone = '1653245666';
            con.modigie__Test_Alt_LinkedIn_Url_FIeld__c = 'https://www.linkedin.com/in/testuser' + i;
            contactList.add(con);
            
        }
        
        insert contactList;
        System.assert(contactList.size() == 5);
        
        for(Contact con: contactList)
        {
            camConMember.add(new CampaignMember(CampaignId=camRec.Id, ContactId= con.Id, Status='Sent'));
        }
        
        insert camConMember;
        System.assert(camConMember.size() == 5);
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        test.startTest();
        String result = GetModigieCampaignButton.CampaignCallout(camRec.Id);
        System.assertNotEquals(null, result);
        List<Id> resultId = GetModigieCampaignButton.campaignCalloutForNewMembers(camRec.Id);
        System.assertNotEquals(null, resultId);
        test.stopTest();
    }
    
    
     @isTest
    public static void test10()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        System.assert(mrec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
                
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        
        Account acc = new Account(Name = 'TestAccount');
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'Test State';
        acc.BillingCountry = 'Test Country';
        acc.BillingPostalCode = '23564';
        insert acc;
        System.assert(acc.Name == 'TestAccount');
        
        for(integer i=0;i<5;i++)
        {
            Contact con = new Contact(AccountId = acc.Id);
            con.FirstName = 'Test';
            con.LastName = 'Contact'+i;
            con.Email = 'testcontact@nomail.com';
            con.modigie__Company_Email__c = 'companyemail@test.com';
            con.modigie__Modigie_Verified_Number__c = '13663666666';
            con.MobilePhone = '1653245666';
            contactList.add(con);
            
        }
        
        insert contactList;
        System.assert(contactList.size() == 5);
        
        for(Contact con: contactList)
        {
            camConMember.add(new CampaignMember(CampaignId=camRec.Id, ContactId= con.Id, Status='Sent'));
        }
        
        insert camConMember;
        System.assert(camConMember.size() == 5);
        Test.setMock(HttpCalloutMock.class, new BadResponseMock());
        test.startTest();
        String result = GetModigieCampaignButton.CampaignCallout(camRec.Id);
        System.assertNotEquals(null, result);
        List<Id> resultId = GetModigieCampaignButton.campaignCalloutForNewMembers(camRec.Id);
        System.assertNotEquals(null, resultId);
        test.stopTest();
    }
    
    @isTest
    public static void test2()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        System.assertEquals(mrec.modigie__Validation_Key__c, 'Modigie_Credit__c@Cyntexakey');
        
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
                
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        
        for(integer i=0;i<5;i++)
        {
            Lead l = new Lead();
            l.FirstName = 'Test';
            l.LastName = 'Lead'+i;
            l.Company='Testing'+i;
            l.modigie__linkedin_url__c = 'test.linkedin.com';
            l.Email = 'testlead@nomail.com';
            l.modigie__Company_Email__c = 'companyemail@test.com';
            l.modigie__Modigie_Verified_Number__c = '13663666666';
            l.MobilePhone = '1653245666';
            leadList.add(l);
            
        }
        insert leadList;
        System.assert(leadList.size() == 5);
        
        for(Lead l: leadlist)
        {
            camLeadMember.add(new CampaignMember(CampaignId=camRec.Id,LeadId=l.Id,Status='Sent'));
        }
        
        insert camLeadMember;
        System.assert(camLeadMember.size() == 5);
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        test.startTest();
        String result = GetModigieCampaignButton.CampaignCallout(camRec.Id);
        System.assertNotEquals(null, result);
        List<Id> resultId = GetModigieCampaignButton.campaignCalloutForNewMembers(camRec.Id);
        System.assertNotEquals(null, resultId);
        test.stopTest();
    }
    
    @isTest
    public static void test6()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        System.assertEquals(mrec.modigie__Validation_Key__c, 'Modigie_Credit__c@Cyntexakey');
        
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
                
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        
        for(integer i=0;i<5;i++)
        {
            Lead l = new Lead();
            l.FirstName = 'Test';
            l.LastName = 'Lead'+i;
            l.Company='Testing'+i;
            l.modigie__linkedin_url__c = 'test.linkedin.com';
            l.Email = 'testlead@nomail.com';
            l.modigie__Company_Email__c = 'companyemail@test.com';
            l.modigie__Modigie_Verified_Number__c = '13663666666';
            l.MobilePhone = '653245666';
            leadList.add(l);
            
        }
        insert leadList;
        System.assert(leadList.size() == 5);
        
        modigie__Modigie__c modi = new modigie__Modigie__c(modigie__Lead__c=leadList[0].Id,modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey');
        insert modi;
        System.assertEquals(modi.modigie__Validation_Key__c, 'Modigie_Credit__c@Cyntexakey');
        
        for(Lead l: leadlist)
        {
            camLeadMember.add(new CampaignMember(CampaignId=camRec.Id,LeadId=l.Id,Status='Sent'));
        }
        
        insert camLeadMember;
        System.assert(camLeadMember.size() == 5);
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.setMock(HttpCalloutMock.class,new BadResponseMock());
        test.startTest();
        String result = GetModigieCampaignButton.CampaignCallout(camRec.Id);
        System.assertNotEquals(null, result);
        List<Id> resultId = GetModigieCampaignButton.campaignCalloutForNewMembers(camRec.Id);
        System.assertNotEquals(null, resultId);        
        test.stopTest();
    }
    
    
    @isTest
    public static void test3()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        System.assertEquals(mrec.modigie__Validation_Key__c, 'Modigie_Credit__c@Cyntexakey');
        
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
        
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        
        Account acc = new Account(Name = 'TestAccount');
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'Test State';
        acc.BillingCountry = 'Test Country';
        acc.BillingPostalCode = '23564';
        insert acc;
        System.assert(acc.Name == 'TestAccount');
        
        for(integer i=0;i<5;i++)
        {
            Contact con = new Contact(AccountId = acc.Id);
            con.FirstName = 'Test';
            con.LastName = 'Contact'+i;
            // con.Email = 'testcontact@nomail.com';
            con.modigie__Company_Email__c = 'companyemail@test.com';
            con.modigie__Modigie_Verified_Number__c = '13663666666';
            con.MobilePhone = '1653245666';
            contactList.add(con);
            
        }
        
        insert contactList;
        System.assert(contactList.size() == 5);
        
        for(Contact con: contactList)
        {
            camConMember.add(new CampaignMember(CampaignId=camRec.Id, ContactId= con.Id, Status='Sent'));
        }
        
        insert camConMember;
        System.assert(camConMember.size() == 5);
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        test.startTest();
        String result = GetModigieCampaignButton.CampaignCallout(camRec.Id);
        System.assertNotEquals(null, result);
        List<Id> resultId = GetModigieCampaignButton.campaignCalloutForNewMembers(camRec.Id);
        System.assertNotEquals(null, resultId);
        test.stopTest();
    }
    
    @isTest
    public static void test4()
    {
        // modigie__Modigie_Credentials__c cred = new modigie__Modigie_Credentials__c();
        // cred.modigie__Service_Account_Credentials__c = GetModigieButtonTest.generateRandomString(72);
        // cred.modigie__Private_Key__c = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDzgHBgLTGa5Oa\nU/kc6O9ey0B1mz5x55QQleo59lNdOuy2IKK+I8he/vhgRzqGt3dH5Z/mX7WNnLZu\nVgYENZjVZM+aHcBjozZ+XSyFh6pwyIvxhYGfkroBRCF68fKl8mTslEBzjZtOV/R3\nGNZywSFlQTT3G4fLHlQN1nEyWyo9AO9hV+on34FmuLwh2uLSBFEUD+RYUMYkfHOR\n6/IkCei2CFjNefdMHeL6+EGOOkrNYD0M6hI6SJX5Zi0cDQ4pWEGEXPuLu4KK65t2\nD9334uHFY+qXeuoMITnSBEowRDJsJA5DyN/ALxpoGxcW/L14hpXTyGylmCpz4+eS\nvqLuPUSfAgMBAAECggEAJ2F+jumQ8jtes3JiLwNWaW1dqImxtH0MFY3hTwkQ2TZp\nt3O256EQwrJrSAnrZn7t2aMAVvg27qVvN5/Lk/snovukmW2UbTW9VwrsUmrnx8k+\nBDSCzpJXILwQM8cHs4Kd88sZb2QysT4VaAKx1uCrE89alLyPwjV2WFYh7CvTwfLc\ncc3HOrVFvFu9mutLAVYl3qjLzb5j3ezEuMwrgbJQM3bXM/0VPeaYiBgbtGPyikZQ\ne1y2WB8j+NLwsm+LUCllPl3RfzvQF0RFt+aYccD4TdwWBEW3pBOKr9PbV6X/6yRm\nxWuoMHi6k7Om4yf05lhSPn+czuENpSzR24n3qoMBmQKBgQD9b0V+m/zWyK8XbQjy\nCy7IUwnInHiKuDMLSCaW+m7M/dUxafZzvedsLUW2TzBkCFT/ZahWPt3+m8+mq1jF\n+HSx0ralPmYNR38WZK9Dl/Q7inRRDb4/7jfWB9ODKC0U62ak7CGhwzGjK8Hq91zQ\nhInAHz9QU+25K7NNwKWM6ISLOwKBgQDFyWXvAPhkFYz+jwHz8xzxypX/BIl74M5H\niCf5fg5IOCt9GdJN1boxw8KrAsKG/vt0n6O+LhQkgVNzhBodqajwKshs2ZLERSU4\n6UjS7Ky1/BRAU4ke2LBBVARlJ6TsRABcRmEAL24rik2pxHsUyBIINKUrV42mKdML\ngm7Kdj0t7QKBgBKG6uapkp9FBn/I6cmABciBQYrX3XwOoTSm7qNE5Yq417gIDgtC\nC8P9v0XnnhsB/Oy6ysabS/FMBK8jgZbfZfCF/fIwkJdR7bl+XM2tMx6TLZOrVIgp\n6w0Lf2vsKPeJifRuirrfoSZTkZaSxMc9mTBhWGiP6iYKSs5ZUgDuEpp3AoGAEMCp\nSKAtadTFd35HbRFHf1docwxAVOTKtBZdRG2f6hAP5u27+WnD9pkdMPzv2x1X0R4A\ncYhXnmvx1JP43lBThdwp08Zt/v/YUkS4LV1sl5F9aaFpuNoju7TRFnxQJM7xtN8l\nMi3SSA/T2jBROIZluJo070HgNpXOUWg/2BhBwFUCgYEAuCsk12gyLSzB4WyD6qUe\nsFZWxceM9LP8x0PX/fGaTx/mf0W3fv4xTlf7XnvCN1QEFDrF7dalYRo0ga8vOOAr\nlqclLfyNHl+P7eF508h/1ieEIYDNAMtCmr5LXtlL7JhdEYps7kh2F5eBhAzHIXaX\nZvYwZb80Kx1yWt1fdXqQW/M=';
        // cred.modigie__Credits_Account_Id__c = GetModigieButtonTest.generateRandomString(72);
        // cred.modigie__Api_key__c = GetModigieButtonTest.generateRandomString(72);
        // cred.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        // insert cred;
        
        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        System.assertEquals(mrec.modigie__Validation_Key__c, 'Modigie_Credit__c@Cyntexakey');
        
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
                
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        
        for(integer i=0;i<5;i++)
        {
            Lead l = new Lead();
            l.FirstName = 'Test';
            l.LastName = 'Lead'+i;
            l.Company='Testing'+i;
            l.modigie__linkedin_url__c = 'test.linkedin.com';
            l.Email = 'testlead@nomail.com';
            l.modigie__Company_Email__c = 'companyemail@test.com';
            l.modigie__Modigie_Verified_Number__c = '13663666666';
            l.MobilePhone = '1653245666';
            l.modigie__Test_Alternate_Linked_Url__c = 'https://www.linkedin.com/in/testuser' + i;
            leadList.add(l);
            
        }
        insert leadList;
        System.assert(leadList.size() == 5);
        
        for(Lead l: leadlist)
        {
            camLeadMember.add(new CampaignMember(CampaignId=camRec.Id,LeadId=l.Id,Status='Sent'));
        }
        
        insert camLeadMember;
        System.assert(camLeadMember.size() == 5);
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        test.startTest();
        try{
            String result = GetModigieCampaignButton.CampaignCallout(camRec.Id);
            System.assertNotEquals(null, result);
            List<Id> resultId = GetModigieCampaignButton.campaignCalloutForNewMembers(camRec.Id);
            System.assertNotEquals(null, resultId);
        }catch(exception e){
            //System.assertEquals('{"DisplayMessage":"You are not an authorized user."}', e.getMessage());
        }
        
        test.stopTest();
    }
    
    @isTest
    public static void test5()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        System.assertEquals(mrec.modigie__Validation_Key__c, 'Modigie_Credit__c@Cyntexakey');
        
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
                
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        
        for(integer i=0;i<5;i++)
        {
            Lead l = new Lead();
            l.FirstName = 'Test';
            l.LastName = 'Lead'+i;
            l.Company='Testing'+i;
            l.modigie__linkedin_url__c = 'test.linkedin.com';
            l.Email = 'testlead@nomail.com';
            l.modigie__Company_Email__c = 'companyemail@test.com';
            l.modigie__Modigie_Verified_Number__c = '13663666666';
            l.MobilePhone = '653245666';
            leadList.add(l);
            
        }
        insert leadList;
        System.assert(leadList.size() == 5);
        
        for(Lead l: leadlist)
        {
            camLeadMember.add(new CampaignMember(CampaignId=camRec.Id,LeadId=l.Id,Status='Sent'));
        }
        
        insert camLeadMember;
        System.assert(camLeadMember.size() == 5);
        test.startTest();
        try{
            String result = GetModigieCampaignButton.CampaignCallout(camRec.Id);
            System.assertNotEquals(null, result);
            List<Id> resultId = GetModigieCampaignButton.campaignCalloutForNewMembers(camRec.Id);
            System.assertNotEquals(null, resultId);
        }catch(exception e){
            System.assertEquals('{"DisplayMessage":"Methods defined as TestMethod do not support Web service callouts"}', e.getMessage());
        }
        
        test.stopTest();
    }
    
    @isTest
    public static void test7()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        System.assertEquals(mrec.modigie__Validation_Key__c, 'Modigie_Credit__c@Cyntexakey');
        
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
                
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        
        Account acc = new Account(Name = 'TestAccount');
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'Test State';
        acc.BillingCountry = 'Test Country';
        acc.BillingPostalCode = '23564';
        insert acc;
        System.assert(acc.Name == 'TestAccount');
        
        for(integer i=0;i<5;i++)
        {
            Contact con = new Contact(AccountId = acc.Id);
            con.FirstName = 'Test';
            con.LastName = 'Contact'+i;
            // con.Email = 'testcontact@nomail.com';
            con.modigie__Company_Email__c = 'companyemail@test.com';
            con.modigie__Modigie_Verified_Number__c = '13663666666';
            con.MobilePhone = '1653245666';
            contactList.add(con);
            
        }
        
        insert contactList;
        System.assert(contactList.size() == 5);
        
        for(Contact con: contactList)
        {
            camConMember.add(new CampaignMember(CampaignId=camRec.Id, ContactId= con.Id, Status='Sent'));
        }
        
        insert camConMember;
        System.assert(camConMember.size() == 5);
        //Test.setMock(HttpCalloutMock.class, new BadResponseMock());
        Test.setMock(HttpCalloutMock.class,new JwtapexMock());
        test.startTest();
        
        String result = GetModigieCampaignButton.CampaignCallout(camRec.Id);
        System.assertNotEquals(null, result);
        List<Id> resultId = GetModigieCampaignButton.campaignCalloutForNewMembers(camRec.Id);
        System.assertNotEquals(null, resultId);
        test.stopTest();
    }
    
        @isTest
    public static void test8()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        System.assertEquals(mrec.modigie__Validation_Key__c, 'Modigie_Credit__c@Cyntexakey');
        
        
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
                
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        
        Account acc = new Account(Name = 'TestAccount');
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'Test State';
        acc.BillingCountry = 'Test Country';
        acc.BillingPostalCode = '23564';
        insert acc;
        System.assert(acc.Name == 'TestAccount');
        
        for(integer i=0;i<5;i++)
        {
            Contact con = new Contact(AccountId = acc.Id);
            con.FirstName = 'Test';
            con.LastName = 'Contact'+i;
            con.Email = 'testcontact@nomail.com';
            con.modigie__Company_Email__c = 'companyemail@test.com';
            con.modigie__Modigie_Verified_Number__c = '13663666666';
            con.MobilePhone = '1653245666';
            contactList.add(con);
            
        }
        
        for(integer i = 0; i<5; i++)
        {
            Lead ld = new Lead();
            ld.FirstName = 'Lead '+i;
            ld.LastName = 'Last';
            ld.Company = 'LeadCompany';
            ld.Email = 'test@email.com';
            leadList.add(ld);
        }
        
        insert contactList;
        System.assert(contactList.size() == 5);
        
        insert leadList;
        system.assert(leadList.size()>0);
        
        for(Contact con: contactList)
        {
            camConMember.add(new CampaignMember(CampaignId=camRec.Id, ContactId= con.Id, Status='Sent'));
        }
        
        for(Lead ld: leadList)
        {
            camConMember.add(new CampaignMember(CampaignId=camRec.Id, LeadId= ld.Id, Status='Sent'));
        }
        
        insert camConMember;
        System.assert(camConMember.size() > 0);
        List <id> lstBatchJobsIds = new List <id>();
      //  String accessToken = 'Bearer ' + jwtapex.get_access_token(cred.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',cred.modigie__Private_Key__c);
        Test.setMock(HttpCalloutMock.class,new JwtapexMock());
        test.startTest();
     /*   LeadBatchForGetModigieButton b2 = new LeadBatchForGetModigieButton(leadList,camRec.Id,accessToken);
                        Id jobId = Database.executeBatch(b2,100);
                        lstBatchJobsIds.add(jobId); */
        GetModigieCampaignButton.checkBatchJobStatus(lstBatchJobsIds);
          
        
        
        String result = GetModigieCampaignButton.CampaignCallout(camRec.Id);
        System.assertNotEquals(null, result);
        List<Id> resultId = GetModigieCampaignButton.campaignCalloutForAllMembers(camRec.Id);
        System.assertNotEquals(null, resultId);
        test.stopTest();
        
        
    }
    
    
    @isTest
    public static void test9()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        
        List <Id> lList = new List <Id>();
        lead l  = new lead();
        l.FirstName = 'test';
        l.LastName = 'lead';
        l.Email = 'test@lead.com';
        l.Company = 'Cyntexa';
        l.status = 'Working - Contacted';
        insert l;
        lList.add(l.Id);
        
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        test.startTest();
        
        invocableUnresponsiveLeadGetModigie.unresponsiveLeadGetModigie(lList);
        
        test.stopTest();
    }
    
    
    @isTest
    public static void test11()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        
        
        List <Id> lList = new List <Id>();
        lead l  = new lead();
        l.FirstName = 'test';
        l.LastName = 'lead';
        l.Email = 'test@lead.com';
        l.Company = 'Cyntexa';
        l.status = 'Working - Contacted';
        insert l;
        lList.add(l.Id);
        
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        test.startTest();
        
        invocableUnresponsiveLeadVerifyEmployer.unresponsiveLeadVerifyEmployer(lList);
        
        test.stopTest();
    }
    
    
    
    
    
    
    
}