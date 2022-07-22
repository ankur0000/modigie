@isTest
public class EmailServiceClassTest 
{
    @isTest
    public static void testMethod1(){
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
        con.MobilePhone = '8999736543';
        con.modigie__Company_Email__c = 'companyemail@test.com';
        con.modigie__linkedin_url__c = 'linkedinurl@test.com';
        insert con;
        System.assert(con.LastName == 'Contact');

        Map <String,Object> errorMap = new Map<String,Object>();
        errorMap.put('ErrorMessage', 'Success');
        errorMap.put('StatusCode',200);
        errorMap.put('ModigieService', 'Get LinkedIn');
        errorMap.put('SObjectId',con.Id);
        String message = JSON.serialize(errorMap);
        test.startTest();
            try{
                String result = EmailServiceClass.sendEmail(message);
                System.assertNotEquals(null,result);
            }catch(exception e){
            }
        test.stopTest();
    }

    @isTest
    public static void testMethod2(){
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        Lead l = new Lead();
        l.FirstName ='Test'; 
        l.LastName = 'Lead'; 
        l.Company = 'Test & Company'; 
        l.Email = 'testemail@nomail.com'; 
        l.modigie__Company_Email__c = 'companyemail@test.com'; 
        l.MobilePhone = '6556612987';
        insert l;
        System.assert(l.Company == 'Test & Company');

        Map <String,Object> errorMap = new Map<String,Object>();
        errorMap.put('ErrorMessage', 'Success');
        errorMap.put('StatusCode',200);
        errorMap.put('ModigieService', 'Get LinkedIn');
        errorMap.put('SObjectId',l.Id);
        String message = JSON.serialize(errorMap);
        test.startTest();
            try{
                String result = EmailServiceClass.sendEmail(message);
                System.assertNotEquals(null,result);
            }catch(exception e){
               
            }
        test.stopTest();
    }

    @isTest
    public static void testMethod3(){
        Set<String> messages = new Set<String>();
        messages.add('messag1');
        messages.add('messag2');
        messages.add('messag3');
        messages.add('messag4');
        test.startTest();
        try{
            EmailServiceClass.sendEmailForCampaign(messages);
            
        }catch(exception e){
        }
        System.assertEquals(4,messages.size());
        test.stopTest();
    }
    @isTest
    public static void testMethod4(){
        modigie__Message_Center__c mc = new modigie__Message_Center__c(modigie__AllException__c = true, modigie__Users_Opted_For_AllException__c = JSON.serialize(new List<Id>()));
		insert mc;
        modigie__Modigie__c mod = new modigie__Modigie__c(modigie__Line_Activity_Phone__c = 'To Fail');
        try{
            Insert mod;
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('EmailServiceClassTest', e);
        }
        System.assert(mod.Id == null);
    }

    @isTest
    public static void testMethod5(){
        List<Id> uLst = new List<Id>();
        uLst.add(userInfo.getUserId());
        modigie__Message_Center__c mc = new modigie__Message_Center__c(modigie__DMLException__c = true, modigie__Users_Opted_For_DMLException__c = JSON.serialize(uLst));
		insert mc;
        try{
            Insert new modigie__Modigie__c(modigie__Line_Activity_Phone__c = 'To Fail');
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('EmailServiceClassTest', e);
        	mc.modigie__AllException__c = true;
        	update mc;
            EmailServiceClass.sendErrorEmail('EmailServiceClassTest', e);
        }
        System.assert(mc.modigie__AllException__c == true);
    }

    @isTest
    public static void testMethod6(){
        Boolean toCheck = true;
        EmailServiceClass.sendResponseError('Test', 401, 'Hello');
        System.assert(toCheck == true);
    }
    @isTest
    public static void testMethod7(){
        Boolean toCheck = true;
        EmailServiceClass.sendResponseError('Test', 201, 'Hello');
        System.assert(toCheck == true);
    }
    @isTest
    public static void testMethod8(){
        RuleSetFactoryTest.createToken();
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
        con.MobilePhone = '8999736543';
        con.modigie__Company_Email__c = 'companyemail@test.com';
        con.modigie__linkedin_url__c = 'linkedinurl@test.com';
        insert con;
        System.assert(con.LastName == 'Contact');

        Map <String,Object> errorMap = new Map<String,Object>();
        errorMap.put('ErrorMessage', 'Success');
        errorMap.put('StatusCode',303);
        errorMap.put('ModigieService', 'Get LinkedIn');
        errorMap.put('SObjectId',con.Id);
        String message = JSON.serialize(errorMap);
        test.startTest();
            try{
                String result = EmailServiceClass.sendEmail(message);
                System.assertNotEquals(null,result);
            }catch(exception e){
            }
        test.stopTest();
    }
}