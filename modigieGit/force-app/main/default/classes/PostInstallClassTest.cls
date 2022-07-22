@isTest
private with sharing class PostInstallClassTest 
{
    @testSetup 
    public static void setup(){
		Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
		

        system.schedule('Modigie Verify Employer Data Maintenance Job 1', '0 0 0 1 1 ? *', new ValidateEmployerSchedulableClass());
        system.schedule('Modigie Verify Employer Data Maintenance Job 2', '0 0 0 1 4 ? *', new ValidateEmployerSchedulableClass());
        system.schedule('Modigie Verify Employer Data Maintenance Job 3', '0 0 0 1 7 ? *', new ValidateEmployerSchedulableClass());
        system.schedule('Modigie Verify Employer Data Maintenance Job 4', '0 0 0 1 10 ? *', new ValidateEmployerSchedulableClass());

        
    }

    @isTest           
    public static void test()
    {	
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        PostInstallClass postinstall  = new PostInstallClass();
        Test.testInstall(postinstall , null);
    }

    @isTest
    public static void testKnown(){
        modigie__Modigie_Automation_Criteria_Lead__c newLeadCrit = new modigie__Modigie_Automation_Criteria_Lead__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        modigie__Modigie_Automation_Criteria_Contact__c newContCrit = new modigie__Modigie_Automation_Criteria_Contact__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        insert newLeadCrit;
        insert newContCrit;
        modigie__Process_Builder_Switch__c mPBS = new modigie__Process_Builder_Switch__c();
        insert mPBS;
        PostInstallClass postinstall  = new PostInstallClass();
        Test.testInstall(postinstall, new Version(1,70), false);
        Test.testInstall(postinstall, new Version(1,71,1), false);
        Test.testInstall(postinstall, null);
        Test.testInstall(postinstall, new Version(1,68), false);
        modigie__TOM__c tom = new modigie__TOM__c(SetupOwnerId = UserInfo.getOrganizationId(), modigie__startDate__c = Date.Today(), modigie__endDate__c = Date.Today().addDays(14), modigie__isActive__c = true, modigie__Contact_Priority_4__c = 'testfield');
        insert tom;
        Test.testInstall(postinstall, new Version(1,69,2), false);
        System.assertEquals(null, [SELECT Id, modigie__Contact_Priority_4__c FROM modigie__TOM__c WHERE Id= :tom.Id].modigie__Contact_Priority_4__c);
        List<modigie__creditAccountDetails__c> accountDetails = [SELECT Id, Name, Credit_Id__c, Default__c, isPerformance__c, Status__c, Title__c, StopUntilTime__c, Balance__c, Currency_Code__c, Reason__c FROM modigie__creditAccountDetails__c LIMIT 1];
        //System.assert(accountDetails[0].Credit_Id__c != null);
    }

    @isTest
    public static void testUnKnown(){
        modigie__Modigie_Automation_Criteria_Lead__c newLeadCrit = new modigie__Modigie_Automation_Criteria_Lead__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        modigie__Modigie_Automation_Criteria_Contact__c newContCrit = new modigie__Modigie_Automation_Criteria_Contact__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        insert newLeadCrit;
        insert newContCrit;
        modigie__Process_Builder_Switch__c mPBS = new modigie__Process_Builder_Switch__c();
        insert mPBS;
        modigie__TOM__c tom = new modigie__TOM__c(SetupOwnerId = UserInfo.getOrganizationId(), modigie__startDate__c = Date.Today(), modigie__endDate__c = Date.Today().addDays(14), modigie__isActive__c = true, modigie__Contact_Priority_4__c = 'testfield');
        insert tom;
        PostInstallClass postinstall  = new PostInstallClass();
        Test.testInstall(postinstall, null);
        Test.testInstall(postinstall, new Version(1,28), true);
        System.assertEquals(null, [SELECT Id, modigie__Contact_Priority_4__c FROM modigie__TOM__c WHERE Id= :tom.Id].modigie__Contact_Priority_4__c);
    }
}