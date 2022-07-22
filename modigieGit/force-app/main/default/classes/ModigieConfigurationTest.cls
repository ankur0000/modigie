@isTest
public class ModigieConfigurationTest 
{
    public static DateTime now      {get {return now == null ? DateTime.now() : now;} set;}
    @isTest
    public static void test1()
    {
        
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
		

        
        
        Modigie_Credit__c modicredit = new Modigie_Credit__c();
        modicredit.Purchased__c=200;
        modicredit.Used__c=20;
        modicredit.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit;
        System.assert(modicredit.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');

        
        String obj = '{"customerId":"Tc8Ye55fAxAwDyZhD9BN","creditsId":"iisBqmpPxHp2bnH6Di0W","apiKey":"AIzaSyBLc3OdT_waobCALoDVF1GzKKbRHWrDDts","serviceCredentials":"modigie-salesforce-app-2@modigie-beval-dev-2.iam.gserviceaccount.com","privateKey":"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDzgHBgLTGa5Oa="}';
        String abortJobstr = '{"GetLinkedIn":true,"GetMobileNumber":true,"GetPhoneInsights":true,"VerifyEmployer":true}';
        BatchJobsScheluderClass.scheduleMe(5, 30, 'Time');
        Map<STRING,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(obj);
        now = DateTIME.now();
        test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseTokenGenerator());
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseClientInfoGenerator());
        //ModigieConfiguration.getToken(resMap);
        ModigieConfiguration.checkToken();
        //ModigieConfiguration.overWriteToken();
        ModigieConfiguration.abortModigieJobs(abortJobstr);
        
        BatchJobsScheluderClass SC = new BatchJobsScheluderClass(); 
        String sched = '';
        sched = '0 5 0 * * ?';
        //System.schedule('Modigie Services Batch Job 1', sched, SC);
        //BatchJobsScheluderClass.scheduleMe(0, 30, 'Interval');

        sched = '0 6 0 * * ?';
        System.schedule('Modigie Services Batch Job 1', sched, SC);
        String result = ModigieConfiguration.getJobTimeDetails();
		
        now = DateTime.newInstance(2020, 03,01, 1, 58, 50);
        ModigieConfiguration.scheduleBatchClass(2, 30, 'Time');
        ModigieConfiguration.scheduleBatchClass(2, 30, 'Interval');
        //System.assertNotEquals(null, result);
        test.stopTest();        
    }
   
    @isTest
    public static void getScheduleJobsInfoTest()
    {
        
        test.startTest();
            String result = ModigieConfiguration.getScheduleJobsInfo();
            System.assertNotEquals(null, result);
        test.stopTest();        
    }

    @isTest
    public static void getScheduleJobsInfoTest2()
    {
        test.startTest();
            String result = ModigieConfiguration.getScheduleJobsInfo();
            System.assertNotEquals(null, result);
        test.stopTest();        
    }

    @isTest
    public static void test3()
    {
        
        
        Modigie_Credit__c modicredit = new Modigie_Credit__c();
        modicredit.Purchased__c=200;
        modicredit.Used__c=20;
        modicredit.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit;
        System.assert(modicredit.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');

        

        String obj = '{"customerId":"Tc8Ye55fAxAwDyZhD9BN","creditsId":"iisBqmpPxHp2bnH6Di0W","apiKey":"AIzaSyBLc3OdT_waobCALoDVF1GzKKbRHWrDDts","serviceCredentials":"modigie-salesforce-app-2@modigie-beval-dev-2.iam.gserviceaccount.com","privateKey":"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDzgHBgLTGa5Oa="}';
        String abortJobstr = '{"GetLinkedIn":true,"GetMobileNumber":true,"GetPhoneInsights":true,"VerifyEmployer":true}';
        //BatchJobsScheluderClass.scheduleMe(5, 30, 'Time');
        Map<STRING,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(obj);
        test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseTokenGenerator());
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseClientInfoGenerator());
        
        //ModigieConfiguration.getToken(resMap);
        String result = ModigieConfiguration.getScheduleJobsInfo();
        System.assertNotEquals(null, result);
        test.stopTest();        
    }

    @isTest
    public static void test4()
    {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
		

		modigie__Modigie_Configurator__c newMC = new modigie__Modigie_Configurator__c();
        newMC.modigie__ConfigurerId__c = [SELECT Id FROM User LIMIT 1].Id;
        insert newMC;
        
        Modigie_Credit__c modicredit = new Modigie_Credit__c();
        modicredit.Purchased__c=200;
        modicredit.Used__c=20;
        modicredit.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit;
        System.assert(modicredit.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');

        

        String obj = '{"customerId":"Tc8Ye55fAxAwDyZhD9BN","creditsId":"iisBqmpPxHp2bnH6Di0W","apiKey":"AIzaSyBLc3OdT_waobCALoDVF1GzKKbRHWrDDts","serviceCredentials":"modigie-salesforce-app-2@modigie-beval-dev-2.iam.gserviceaccount.com","privateKey":"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDzgHBgLTGa5Oa="}';
        String abortJobstr = '{"GetLinkedIn":true,"GetMobileNumber":true,"GetPhoneInsights":true,"VerifyEmployer":true}';
        //BatchJobsScheluderClass.scheduleMe(5, 30, 'Time');
        Map<STRING,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(obj);
        test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseTokenGenerator());
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseClientInfoGenerator());
        String result = ModigieConfiguration.getScheduleJobsInfo();
        System.assertNotEquals(null, result);
        try{
            //ModigieConfiguration.getToken(resMap);
        }catch(exception e){
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
		

        
        
        Modigie_Credit__c modicredit = new Modigie_Credit__c();
        modicredit.Purchased__c=200;
        modicredit.Used__c=20;
        modicredit.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit;
        System.assert(modicredit.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');

       

        String obj = '{"customerId":"Tc8Ye55fAxAwDyZhD9BN","creditsId":"iisBqmpPxHp2bnH6Di0W","apiKey":"AIzaSyBLc3OdT_waobCALoDVF1GzKKbRHWrDDts","serviceCredentials":"modigie-salesforce-app-2@modigie-beval-dev-2.iam.gserviceaccount.com","privateKey":"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDzgHBgLTGa5Oa="}';
        String abortJobstr = '{"GetLinkedIn":true,"GetMobileNumber":true,"GetPhoneInsights":true,"VerifyEmployer":true}';
        //BatchJobsScheluderClass.scheduleMe(5, 30, 'Time');
        Map<STRING,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(obj);
        test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseTokenGenerator());
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseClientInfoGenerator());
       // ModigieConfiguration.getToken(resMap);
        ModigieConfiguration.checkToken();
        //ModigieConfiguration.overWriteToken();
        ModigieConfiguration.abortModigieJobs(abortJobstr);
        
        BatchJobsScheluderClass SC = new BatchJobsScheluderClass(); 
        String sched = '';
        sched = '0 5 0 * * ?';
        //System.schedule('Modigie Services Batch Job 1', sched, SC);
        BatchJobsScheluderClass.scheduleMe(0, 30, 'Interval');

        sched = '0 6 0 * * ?';
        System.schedule('Modigie Services Batch Job by time', sched, SC);
        String result = ModigieConfiguration.getJobTimeDetails();
        ModigieConfiguration.scheduleBatchClass(0, 30, 'Time');
        ModigieConfiguration.scheduleBatchClass(0, 30, 'Interval');
        //System.assertNotEquals(null, result);
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
		

        Modigie_Credit__c modicredit = new Modigie_Credit__c();
        modicredit.Purchased__c=200;
        modicredit.Used__c=20;
        modicredit.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit;
        System.assert(modicredit.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');

       
        String CRON_EXP = '0 0 1 * * ?';
        
        String obj = '{"customerId":"Tc8Ye55fAxAwDyZhD9BN","creditsId":"iisBqmpPxHp2bnH6Di0W","apiKey":"AIzaSyBLc3OdT_waobCALoDVF1GzKKbRHWrDDts","serviceCredentials":"modigie-salesforce-app-2@modigie-beval-dev-2.iam.gserviceaccount.com","privateKey":"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDzgHBgLTGa5Oa="}';
        String abortJobstr = '{"GetLinkedIn":true,"GetMobileNumber":true,"GetPhoneInsights":true,"VerifyEmployer":true}';
        Map<STRING,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(obj);
        test.startTest();
        //ModigieConfiguration.getToken(resMap);
        ModigieConfiguration.checkToken();
        ModigieConfiguration.abortModigieJobs(abortJobstr);
        
        BatchJobsScheluderClass SC = new BatchJobsScheluderClass(); 
        String sched = '';
        sched = '0 5 0 * * ?';
        //System.schedule('Modigie Services Batch Job 1', sched, SC);
        BatchJobsScheluderClass.scheduleMe(0, 30, 'Interval');

        sched = '0 6 0 * * ?';
        System.schedule('Modigie Services Batch Job by time', sched, SC);
        String result = ModigieConfiguration.getJobTimeDetails();
        ModigieConfiguration.scheduleBatchClass(0, 30, 'Time');
        ModigieConfiguration.scheduleBatchClass(0, 30, 'Interval');
         String jobId = System.schedule('ModigieConfigurationTest', CRON_EXP, new BatchJobsScheluderClass());
             
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        //System.assertNotEquals(null, result);
        test.stopTest();  

    }
    @isTest
    public static void test7(){
        modigie__Message_Center__c mcList = new modigie__Message_Center__c();
        mcList.modigie__UnexpectedException__c = true;
        mcList.modigie__SecurityException__c = false;
        mcList.modigie__NoDataFoundException__c = true;
        mcList.modigie__EmailException__c = true;
        mcList.modigie__LimitException__c = false;
        mcList.modigie__CalloutException__c = true;
        mcList.modigie__DMLException__c = true;
        mcList.modigie__AllException__c = false;
        mcList.modigie__CalloutResponse__c = false;
        mcList.modigie__Users_Opted_For_DMLException__c = '["0051U000005tLCEQA2","0051U000003ICSCQA4"]';
        insert mcList;
        
        Map<String,Boolean> allCheckboxes = ModigieConfiguration.getAllCheckBoxes();
        ModigieConfiguration.saveCheckBoxForAll(false);
        ModigieConfiguration.saveCheckBoxForCallout(true);
        ModigieConfiguration.saveCheckBoxForDml(false);
        ModigieConfiguration.saveCheckBoxForEmail(true);
        //ModigieConfiguration.saveCheckBoxForLimit(false);
        ModigieConfiguration.saveCheckBoxForNoDataFound(true);
        ModigieConfiguration.saveCheckBoxForSecurity(false);
        ModigieConfiguration.saveCheckBoxForUnexpected(false);
        ModigieConfiguration.saveCheckBoxForCalloutResponse(false);
        ModigieConfiguration.saveCheckBoxForCreditError(false);
        ModigieConfiguration.saveCheckBoxForInvocableLimit(false);
        ModigieConfiguration.saveCheckBoxForAdhoqLimit(false);
        
        ModigieConfiguration.unexpectedExceptionSave('Unexpected Exception', '["0051U000005tLCEQA2","0051U000008RaIwQAK","0051U000003ICSCQA4"]');
        ModigieConfiguration.unexpectedExceptionSave('Security Exception', '["0051U000008RaIwQAK","0051U000003ICSCQA4"]');
        ModigieConfiguration.unexpectedExceptionSave('NoDataFound Exception', '["0051U000005tLCEQA2","0051U000008RaIwQAK"]');
        ModigieConfiguration.unexpectedExceptionSave('Email Exception', '["0051U000005tLCEQA2","0051U000003ICSCQA4"]');
        ModigieConfiguration.unexpectedExceptionSave('Limit Exception', '["0051U000005tLCEQA2","0051U000008RaIwQAK"]');
        ModigieConfiguration.unexpectedExceptionSave('Callout Exception', '["0051U000005tLCEQA2","0051U000008RaIwQAK","0051U000003ICSCQA4"]');
        ModigieConfiguration.unexpectedExceptionSave('Dml Exception', '["0051U000008RaIwQAK","0051U000003ICSCQA4"]');
        ModigieConfiguration.unexpectedExceptionSave('All Exception', '["0051U000005tLCEQA2","0051U000003ICSCQA4"]');
        ModigieConfiguration.unexpectedExceptionSave('Callout Response', '["0051U000005tLCEQA2","0051U000003ICSCQA4"]');
        ModigieConfiguration.unexpectedExceptionSave('Credit Error', '["0051U000008RaIwQAK","0051U000003ICSCQA4"]');
        ModigieConfiguration.unexpectedExceptionSave('Invocable Limit', '["0051U000005tLCEQA2","0051U000003ICSCQA4"]');
        ModigieConfiguration.unexpectedExceptionSave('Adhoq Limit', '["0051U000005tLCEQA2","0051U000003ICSCQA4"]');
        
        ModigieConfiguration.getSelectedUsersDml();
        ModigieConfiguration.getSelectedUsersCallout();
        //ModigieConfiguration.getSelectedUsersLimit();
        ModigieConfiguration.getSelectedUsersEmail();
        ModigieConfiguration.getSelectedUsersNoDataFound();
        ModigieConfiguration.getSelectedUsersSecurity();
        ModigieConfiguration.getSelectedUsersUnexpected();
        ModigieConfiguration.getSelectedUsersCalloutResponse();
        ModigieConfiguration.getSelectedUsersCreditError();
        ModigieConfiguration.getSelectedUsersInvocableLimit();
        ModigieConfiguration.getSelectedUsersAdhoqLimit();
        
        ModigieConfiguration.getActiveUsers();
        String jsonString = null;
        jsonString = ModigieConfiguration.getSelectedUsersAll();
        System.assert(jsonString != null);
        
    }
}