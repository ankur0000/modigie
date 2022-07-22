@isTest
public class ValidateEmployerCampaignButtonTest {
    @testSetup 
    public static void setup(){

		modigie__Process_Builder_Switch__c pbs = new modigie__Process_Builder_Switch__c();
        pbs.modigie__Limits_No_Limits_Selection__c  = 'Limits';
        pbs.modigie__Limit_User_for_Modigie_Ad_hoc__c = true;
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
        System.assert(pbs.modigie__Linkedin_Url_Campaign_Limits__c == 10);
        
        
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	

        Account acc = new Account(Name = 'Test Account');
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'Test State';
        acc.BillingCountry = 'Test Country';
        acc.BillingPostalCode = '23564';
        insert acc;
        System.assert(acc.Name == 'Test Account');

        Time timeChange = Time.newInstance(11,12,12,0); 
        Time timeChange1 = Time.newInstance(11,13,12,0);
        modigie__Modigie__c mm = new modigie__Modigie__c();
        mm.modigie__Status__c = 'In Process';
        mm.modigie__Linkedin_Status__c = 'In Process';
        mm.modigie__Phone_Intelligence_Status__c = 'In Process';
        mm.modigie__Validate_Employer_Status__c = 'In Process';
        mm.modigie__Validation_Date_Get_Mobile_Number__c = System.now().addDays(-1);
        mm.modigie__Job_start__c = timeChange;   
        mm.modigie__Job_end__c = timeChange1;
        mm.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        mm.modigie__Parent_Id__c = acc.Id;
        insert mm;
        System.assert(mm.modigie__Status__c != 'Not Started');

        modigie__Modigie_Credit__c mrec = new modigie__Modigie_Credit__c(modigie__Purchased__c = 10,modigie__Validation_Key__c='Modigie_Credit__c@Cyntexakey',modigie__Used__c=20,modigie__Date_Last_Synced__c=System.today());
        insert mrec;
        System.assert(mrec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        
        
        
         Map<String, Object> calloutInfo = new Map<String, Object>();
        calloutInfo.put('modigie__Endpoint_Url__c', GetModigieButtonTest.generateRandomString(72));
        calloutInfo.put('modigie__targetAud__c', 'test@invalid.test');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Callout_Info__mdt.Verify_Employer_Job_Create','Verify_Employer_Job_Create',calloutInfo);            
	
            List<modigie__Modigie_Callout_Info__mdt> calloutInfo1 = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Verify Employer Job Create' LIMIT 1];
        
        system.debug('calloutInfo1'+calloutInfo1);
        
    }
    
    @isTest
    public static void test1()
    {
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
        
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
        System.assert(uLimit.Name == 'User Limit');
            
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
            con.Email = 'testemail@nomail.com';
            con.MobilePhone = '8999736543';
            con.AccountId  = acc.Id;
            con.modigie__Company_URL__c = 'companyurl@test.com';
            con.modigie__Company_Email__c = 'companyemail@test.com';
            con.modigie__linkedin_url__c = 'linkedin@test.com';
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
        String result = ValidateEmployerCampaignButton.CampaignCallout(camRec.Id);
        System.assertNotEquals(null, result);
        List<Id> resultId = ValidateEmployerCampaignButton.campaignCalloutForNewMembers(camRec.Id);
        System.assertNotEquals(null, resultId);
        test.stopTest();
    }
    
    @isTest
    public static void test2()
    {
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Modigie__c> modiList = new List<Modigie__c>();
        List<CampaignMember> camConMember = new List<CampaignMember>();
        List<CampaignMember> camLeadMember = new List<CampaignMember>();
        
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
        System.assert(uLimit.Name == 'User Limit');
                
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        
        for(integer i=0;i<5;i++)
        {
            Lead l = new Lead();
            l.FirstName = 'Test';
            l.LastName = 'Lead'+i;
            l.Company = 'Test & Company'; 
            l.Email = 'testemail@nomail.com'; 
            l.modigie__Company_Email__c = 'companyemail@test.com'; 
            l.modigie__Company_URL__c = 'companyurl@test.com';
            l.modigie__linkedin_url__c = 'linkedin@test.com';
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
        String result = ValidateEmployerCampaignButton.CampaignCallout(camRec.Id);
        System.assertNotEquals(null, result);
        List<Id> resultId = ValidateEmployerCampaignButton.campaignCalloutForNewMembers(camRec.Id);
        System.assertNotEquals(null, resultId);
        test.stopTest();
    }
}