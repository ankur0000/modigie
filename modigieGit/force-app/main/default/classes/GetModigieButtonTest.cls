@isTest
public class GetModigieButtonTest 
{
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
        
        Contact con = new Contact(AccountId = acc.Id);
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        //con.Email = 'testemail@nomail.com';
        con.MobilePhone = '8999736543';
        con.modigie__Company_URL__c = 'companyurl@test.com';
        con.modigie__Company_Email__c = 'companyemail@test.com';
        con.modigie__linkedin_url__c = 'linkedinurl@test.com';
        insert con;
        System.assert(con.LastName == 'Contact');
        
        Lead l = new Lead();
        l.FirstName ='Test'; 
        l.LastName = 'Lead'; 
        l.Company = 'Test & Company'; 
        //l.Email = 'testemail@nomail.com'; 
        l.modigie__Company_Email__c = 'companyemail@test.com'; 
        l.modigie__Company_URL__c = 'companyurl@test.com'; 
        l.modigie__linkedin_url__c = 'linkedinurl@test.com'; 
        l.MobilePhone = '6556612987';
        insert l;
        System.assert(l.Company == 'Test & Company');
        
        
        
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
        
    }
    
    @isTest
    public static void testMethod1(){
        modigie__Daily_usage_modigie_callouts_by_users__c dailyCallRecord = [Select Name, modigie__Number_of_modigie_callouts_in_a_day__c, modigie__User_Id__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WHERE Name = 'Daily calls' LIMIT 1];
                
        modigie__Profile_and_user_modigie_limits__c userLimit = [Select Name, modigie__Limit_of_modigie_callouts__c, modigie__User_Or_Profile__c, modigie__User_or_Profile_Id__c FROM modigie__Profile_and_user_modigie_limits__c WHERE Name = 'User Limit' LIMIT 1];
        
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToGetModigie());
        GetModigieButton.makeGetCallout(l.id);
        GetModigieButton.dataToModigie(s,l.id);
        String result = GetModigieButton.checkValidateRecord(l.id);
        System.assertEquals('Job is already in process.',result);
        test.stopTest();
    }
    
    @isTest
    public static void testMethod2()
    {
        
        Contact con = [SELECT Id, Account.Name, modigie__Company_Email__c, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity, Account.BillingState, Account.BillingCountry, modigie__linkedin_url__c, FirstName, LastName, Email, modigie__Company_URL__c, MobilePhone FROM Contact Where LastName = 'Contact' LIMIT 1];
        
        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToGetModigie());
        GetModigieButton.makeGetCallout(con.id);
        GetModigieButton.dataToModigie(s,con.id);
        String result = GetModigieButton.checkValidateRecord(con.id);
        System.assertEquals('Job is already in process.',result);
        test.stopTest();
        
    }
    
    @isTest
    public static void method3()
    {
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.modigie__Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToGetModigie());
        GetModigieButton.makeGetCallout(l.id);
        GetModigieButton.dataToModigie(s,l.id);
        String result = GetModigieButton.checkValidateRecord(l.id);
        System.assertEquals('Job is already in process.', result);
        test.stopTest();
    }
    
    @isTest
    public static void method4()
    {
        
        
        Contact con = [SELECT Id, Account.Name, modigie__Company_Email__c, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity, Account.BillingState, Account.BillingCountry, modigie__linkedin_url__c, FirstName, LastName, Email, modigie__Company_URL__c, MobilePhone FROM Contact Where LastName = 'Contact' LIMIT 1];
        
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.modigie__Contact__c = con.Id;
        modirec.modigie__Parent_Id__c = con.Id;
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToGetModigie());
        GetModigieButton.makeGetCallout(con.id);
        GetModigieButton.dataToModigie(s,con.id);
        String result = GetModigieButton.checkValidateRecord(con.id);
        System.assertEquals('Job is already in process.', result);
        test.stopTest();
    }
    
   @isTest
    public static void testMethod5()
    {
        
        Contact con = [SELECT Id, Account.Name, modigie__Company_Email__c, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity, Account.BillingState, Account.BillingCountry, modigie__linkedin_url__c, FirstName, LastName, Email, modigie__Company_URL__c, MobilePhone FROM Contact Where LastName = 'Contact' LIMIT 1];
        
        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "message": "Internal sever error", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToGetModigie());
        GetModigieButton.makeGetCallout(con.id);
        GetModigieButton.dataToModigie(s,con.id);
        String result = GetModigieButton.checkValidateRecord(con.id);
        System.assertEquals('Available',result);
        test.stopTest();
        
    }
    
    @isTest
    public static void testMethod6(){
        
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "message": "Internal server error", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToGetModigie());
        GetModigieButton.makeGetCallout(l.id);
        GetModigieButton.dataToModigie(s,l.id);
        String result = GetModigieButton.checkValidateRecord(l.id);
        System.assertEquals('Available',result);
        try{
            List<String> ls = new List<String>();
            ls.add('label1');
            Object state;
            GetModigieButton.modigieCallback(ls,state);
        }catch(exception e){
        }
        test.stopTest();
    }

    @isTest
    public static void method7()
    {
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.modigie__Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        // Test.setMock(HttpCalloutMock.class, new BadResponseMock());
        try{
            GetModigieButton.makeGetCallout(l.id);
            GetModigieButton.dataToModigie(s,l.id);
            String result = GetModigieButton.checkValidateRecord(l.id);
        }catch(exception e){
            System.assertEquals('{"DisplayMessage":"Methods defined as TestMethod do not support Web service callouts"}', e.getMessage());
        }
        test.stopTest();
    }
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
}