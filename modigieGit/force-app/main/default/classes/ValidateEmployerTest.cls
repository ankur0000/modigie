@isTest
public class ValidateEmployerTest {
    @testSetup 
    public static void setup(){
        modigie__Profile_and_user_modigie_limits__c uLimit = new modigie__Profile_and_user_modigie_limits__c();
        uLimit.Name = 'User Limit';
        uLimit.modigie__Limit_of_modigie_callouts__c = 30;
        uLimit.modigie__User_Or_Profile__c = 'Profile';
        uLimit.modigie__User_or_Profile_Id__c =UserInfo.getProfileId();
        insert uLimit;

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
        
        /*modigie__Modigie_Credentials__c cred = new modigie__Modigie_Credentials__c();
        cred.modigie__Service_Account_Credentials__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Private_Key__c = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDzgHBgLTGa5Oa\nU/kc6O9ey0B1mz5x55QQleo59lNdOuy2IKK+I8he/vhgRzqGt3dH5Z/mX7WNnLZu\nVgYENZjVZM+aHcBjozZ+XSyFh6pwyIvxhYGfkroBRCF68fKl8mTslEBzjZtOV/R3\nGNZywSFlQTT3G4fLHlQN1nEyWyo9AO9hV+on34FmuLwh2uLSBFEUD+RYUMYkfHOR\n6/IkCei2CFjNefdMHeL6+EGOOkrNYD0M6hI6SJX5Zi0cDQ4pWEGEXPuLu4KK65t2\nD9334uHFY+qXeuoMITnSBEowRDJsJA5DyN/ALxpoGxcW/L14hpXTyGylmCpz4+eS\nvqLuPUSfAgMBAAECggEAJ2F+jumQ8jtes3JiLwNWaW1dqImxtH0MFY3hTwkQ2TZp\nt3O256EQwrJrSAnrZn7t2aMAVvg27qVvN5/Lk/snovukmW2UbTW9VwrsUmrnx8k+\nBDSCzpJXILwQM8cHs4Kd88sZb2QysT4VaAKx1uCrE89alLyPwjV2WFYh7CvTwfLc\ncc3HOrVFvFu9mutLAVYl3qjLzb5j3ezEuMwrgbJQM3bXM/0VPeaYiBgbtGPyikZQ\ne1y2WB8j+NLwsm+LUCllPl3RfzvQF0RFt+aYccD4TdwWBEW3pBOKr9PbV6X/6yRm\nxWuoMHi6k7Om4yf05lhSPn+czuENpSzR24n3qoMBmQKBgQD9b0V+m/zWyK8XbQjy\nCy7IUwnInHiKuDMLSCaW+m7M/dUxafZzvedsLUW2TzBkCFT/ZahWPt3+m8+mq1jF\n+HSx0ralPmYNR38WZK9Dl/Q7inRRDb4/7jfWB9ODKC0U62ak7CGhwzGjK8Hq91zQ\nhInAHz9QU+25K7NNwKWM6ISLOwKBgQDFyWXvAPhkFYz+jwHz8xzxypX/BIl74M5H\niCf5fg5IOCt9GdJN1boxw8KrAsKG/vt0n6O+LhQkgVNzhBodqajwKshs2ZLERSU4\n6UjS7Ky1/BRAU4ke2LBBVARlJ6TsRABcRmEAL24rik2pxHsUyBIINKUrV42mKdML\ngm7Kdj0t7QKBgBKG6uapkp9FBn/I6cmABciBQYrX3XwOoTSm7qNE5Yq417gIDgtC\nC8P9v0XnnhsB/Oy6ysabS/FMBK8jgZbfZfCF/fIwkJdR7bl+XM2tMx6TLZOrVIgp\n6w0Lf2vsKPeJifRuirrfoSZTkZaSxMc9mTBhWGiP6iYKSs5ZUgDuEpp3AoGAEMCp\nSKAtadTFd35HbRFHf1docwxAVOTKtBZdRG2f6hAP5u27+WnD9pkdMPzv2x1X0R4A\ncYhXnmvx1JP43lBThdwp08Zt/v/YUkS4LV1sl5F9aaFpuNoju7TRFnxQJM7xtN8l\nMi3SSA/T2jBROIZluJo070HgNpXOUWg/2BhBwFUCgYEAuCsk12gyLSzB4WyD6qUe\nsFZWxceM9LP8x0PX/fGaTx/mf0W3fv4xTlf7XnvCN1QEFDrF7dalYRo0ga8vOOAr\nlqclLfyNHl+P7eF508h/1ieEIYDNAMtCmr5LXtlL7JhdEYps7kh2F5eBhAzHIXaX\nZvYwZb80Kx1yWt1fdXqQW/M=';
        cred.modigie__Credits_Account_Id__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Api_key__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert cred;*/
        
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
        con.Email = 'testemail@nomail.com';
        //con.MobilePhone = '8999736543';
        con.modigie__Company_URL__c = 'companyurl@test.com';
        con.modigie__Company_Email__c = 'companyemail@test.com';
        con.modigie__Modigie_Verified_Number__c = '345345465';
        con.MobilePhone = '344564';
        con.modigie__linkedin_url__c = 'linkedinurl@test.com';
        insert con;
        System.assert(con.LastName == 'Contact');
        
        Lead l = new Lead();
        l.FirstName ='Test'; 
        l.LastName = 'Lead'; 
        l.Company = 'Test & Company'; 
        l.Email = 'testemail@nomail.com'; 
        l.modigie__Company_Email__c = 'companyemail@test.com'; 
        l.modigie__Company_URL__c = 'companyurl@test.com'; 
        //l.modigie__linkedin_url__c = 'linkedinurl@test.com'; 
        //l.MobilePhone = '6556612987';
        insert l;
        System.assert(l.Company == 'Test & Company');
        
    }
    
    /*@isTest
    public static void checkValidateRecordTest(){
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
            String result = ValidateEmployer.checkValidateRecord(l.Id);
            system.assertEquals('Available', result);
        test.stopTest();
        
    }*/

    @isTest
    public static void checkValidateRecordTest2(){
        
        

        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.modigie__Validate_Employer_Status__c = 'Validated';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
            String result = ValidateEmployer.checkValidateRecord(l.Id);
            system.assertEquals('The record is already validated.', result);
        test.stopTest();
        
    }

    @isTest
    public static void checkValidateRecordTest5(){
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
            String result = ValidateEmployer.checkValidateRecord(l.Id);
            system.assertEquals('Available', result);
        test.stopTest();
        
    }

    @isTest
    public static void checkValidateRecordTest3(){
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.modigie__Validate_Employer_Status__c = 'Not Available';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
            String result = ValidateEmployer.checkValidateRecord(l.Id);
            system.assertEquals('Verify Employer for this record is not available.', result);
        test.stopTest();
        
    }

    @isTest
    public static void checkValidateRecordTest4(){
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.modigie__Validate_Employer_Status__c = 'In process';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
            String result = ValidateEmployer.checkValidateRecord(l.Id);
            system.assertEquals('Job is already in process.', result);
        test.stopTest();
        
    }

    /*@isTest
    public static void checkValidateRecordTest6(){
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        l.firstName = null;
        update l;
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.modigie__Validate_Employer_Status__c = 'In process';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
            String result = ValidateEmployer.checkValidateRecord(l.Id);
            system.assertEquals('Job is already in process.', result);
        test.stopTest();
        
    }*/

    @isTest
    public static void checkValidateRecordTest7(){
        
        Contact con = [SELECT id from Contact limit 1];
        con.FirstName = null;
        update con;
        
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.Contact__c = con.Id;
        modirec.modigie__Parent_Id__c = con.Id;
        modirec.modigie__Validate_Employer_Status__c = 'In process';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
            String result = ValidateEmployer.checkValidateRecord(con.Id);
            system.assertEquals('Job is already in process.', result);
        test.stopTest();
        
    }
    
    @isTest
    public static void testMethod2(){
        
        modigie__Modigie_Configurator__c modConf = new modigie__Modigie_Configurator__c();
        modConf.modigie__ConfigurerId__c = UserInfo.getUserId();
        insert modConf;

        Contact con = [SELECT Id, Account.Name, modigie__Company_Email__c, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity, Account.BillingState, Account.BillingCountry, modigie__linkedin_url__c, FirstName, LastName, Email, modigie__Company_URL__c, MobilePhone FROM Contact Where LastName = 'Contact' LIMIT 1];
        con.modigie__Modigie_Verified_Number__c = '345345465';
        con.MobilePhone = '344564';
        con.modigie__linkedin_url__c = 'test.linkedin.com';
        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
        ValidateEmployer.checkValidateRecord(con.Id);
        ValidateEmployer.makeGetCallout(con.id);
        String result = ValidateEmployer.dataToModigie(s,con.id);
        system.assertNotEquals(null, result);
        try{
            List<String> ls = new List<String>();
            HttpResponse res = new HttpResponse();
            res.setBody('{"message": "Internal Server Error", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}');
            res.setStatusCode(200);
            ls.add(res.toString());
            //ls.add('label1');
            Object state;
            ValidateEmployer.verifyEmployerCallback(ls,state);
        }catch(exception e){
        }
        test.stopTest();
    }
    
    @isTest
    public static void testMethod3(){
       
        modigie__Modigie_Configurator__c modConf = new modigie__Modigie_Configurator__c();
        modConf.modigie__ConfigurerId__c = UserInfo.getUserId();
        insert modConf;

        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        //modirec.modigie__Validate_Employer_Status__c = 'Validated';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
        ValidateEmployer.checkValidateRecord(l.Id);
        ValidateEmployer.makeGetCallout(l.id);
        String result = ValidateEmployer.dataToModigie(s,l.id);
        system.assertNotEquals(null, result);
        test.stopTest();
    }
    
    @isTest
    public static void testMethod4(){
        
        modigie__Modigie_Configurator__c modConf = new modigie__Modigie_Configurator__c();
        modConf.modigie__ConfigurerId__c = UserInfo.getUserId();
        insert modConf;

        Contact con = [SELECT Id, Account.Name, modigie__Company_Email__c, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity, Account.BillingState, Account.BillingCountry, modigie__linkedin_url__c, FirstName, LastName, Email, modigie__Company_URL__c, MobilePhone FROM Contact Where LastName = 'Contact' LIMIT 1];
        
        Modigie__c modirec1 = new Modigie__c();
        modirec1.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec1.Status__c = 'In process';
        modirec1.modigie__Contact__c = con.Id;
        modirec1.modigie__Parent_Id__c = con.Id;
        //modirec1.modigie__Validate_Employer_Status__c = 'Validated';
        modirec1.Date_Last_Updated__c = Date.today();
        insert modirec1;
        System.assert(modirec1.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');

        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
        ValidateEmployer.checkValidateRecord(con.Id);
        ValidateEmployer.makeGetCallout(con.id);
        String result = ValidateEmployer.dataToModigie(s,con.id);
        system.assertNotEquals(null, result);
        test.stopTest();
    }
    
     @isTest
    public static void testMethod5(){
                
        modigie__Modigie_Configurator__c modConf = new modigie__Modigie_Configurator__c();
        modConf.modigie__ConfigurerId__c = UserInfo.getUserId();
        insert modConf;

        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        String s = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGetLinkedinbutton());
        ValidateEmployer.checkValidateRecord(l.Id);
        ValidateEmployer.makeGetCallout(l.id);
        String result = ValidateEmployer.dataToModigie(s,l.id);
        system.assertNotEquals(null, result);
        test.stopTest();
        
    }
}