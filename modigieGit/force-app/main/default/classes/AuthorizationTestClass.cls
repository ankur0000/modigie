@isTest
private class AuthorizationTestClass {
    @testSetup 
    public static void setup()
    {
        
        modigie__creditAccountDetails__c mcad = new modigie__creditAccountDetails__c();
      //  mcad.Id ='1';
        mcad.Name = 'Ram';
        mcad.Credit_Id__c = '2';
        mcad.Default__c = true;
        mcad.isPerformance__c = true;
        mcad.Status__c = 'Active';
        mcad.Title__c = 'hello';
        mcad.StopUntilTime__c  =  Datetime.now().addDays(-1);
        insert mcad; 
        
        modigie__creditAccountDetails__c mcad1 = new modigie__creditAccountDetails__c();
       // mcad.Id ='1';
        mcad1.Name = 'Ankur';
        mcad1.Credit_Id__c = '2';
       mcad1.Default__c = false;
        mcad1.isPerformance__c = true;
       mcad1.Status__c = 'Inactive';
        mcad1.Title__c = 'hello';
        mcad1.StopUntilTime__c  =  Datetime.now().addDays(-1);
       insert mcad1; 
       
        modigie__creditAccountUsers__c mcau = new modigie__creditAccountUsers__c();
        mcau.name = '1';
        mcau.modigie__Credit_RecordId__c = mcad.Id;
        mcau.modigie__User_Id__c = '0051U000005tfupQAA';
        mcau.modigie__isPerformance__c = true;
        mcau.modigie__User_Name__c = 'vaibhav vyas';
        mcau.modigie__CreditId_Name__c = 'Modigie Developer';
        insert mcau;
        
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        user userRecord = new user();
        userRecord.FirstName = 'vaibhav';
        userRecord.LastName = 'vyas';
        userRecord.email = 'vaibhav@cynytexa.com';
        userRecord.Username ='vaibhavtest@testorg.com';
        userRecord.Alias = 'vvyas';
        userRecord.TimeZoneSidKey= 'America/New_York';
        userRecord.LocaleSidKey = 'en_US';
        userRecord.EmailEncodingKey = 'UTF-8';
        userRecord.ProfileId = p.Id;
        userRecord.LanguageLocaleKey = 'en_US';
        insert userRecord;
        
        System.runAs(new User(Id = Userinfo.getUserId())){
        PermissionSet ps = [SELECT Id, Name, Label FROM PermissionSet WHERE Name = 'Modigie_Admin' LIMIT 1];
	  	system.debug('setss name... '+ ps );
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = userRecord.Id;
        psa.PermissionSetId = ps.Id;
            system.debug('check... '+ psa);
        insert psa;
            
        }
        
    }
    @isTest
     static void accList(){
         List<Object> objList=new List<Object>();
         List<Object> objList1=new List<Object>();
       
       //  String str2='{"userId":"1234567890123456","recordId":"1234567890123456","userName":"Vaibhav Vyas","creditTitle":"First Credit Id"}';
        // Object o=(Object)str2;
         //objList.add(o);
         
        // String serviceMainReq = '{"Id":"'+smer.Id+'","Name":"test service Extension Request","Status__c":"Submitted","Onsite_Contact__c":"'+smer.Onsite_Contact__c+'"}';
		
         
       List<Map<String, Object>> value = AuthorizationClass.getCreditAccountDetails();
         
         //Test.startTest();
        //  System.assertNotEquals(expected, actual);
        // Test.stopTest();
         AuthorizationClass.getEncryptedId('X83087654678902u32');
         Test.startTest();
         System.assertEquals('X830XXXXXXXXXX2u32', AuthorizationClass.getEncryptedId('X83087654678902u32'));
         Test.stopTest();
        String creditRecId =[select id from modigie__creditAccountDetails__c where name='Ram' Limit 1].Id;
         String creditRecIdDefaultFalse =[select id from modigie__creditAccountDetails__c where Default__c = false ].Id;
         system.debug('sdgjds....' + creditRecId);
        String creditRecId1 =string.valueOf([select id from modigie__creditAccountDetails__c where name='Ram' Limit 1]);
        list<string> strList=new List<string>();
        strList.add(creditRecId1);
        list<string> userId=new List<string>{'0051U000005tLCEQA2' ,'0051U000005tfupQAA'};
        objList=[select id,Name from user where id in :userId];
        objList1=[select id,name from modigie__creditAccountDetails__c where id=:creditRecId];
       // list<modigie__creditAccountUsers__c> userDetails=[select Id  name, modigie__Credit_RecordId__c,modigie__User_Id__c,modigie__User_Name__c, modigie__isPerformance__c, modigie__CreditId_Name__c from modigie__creditAccountUsers__c WHERE modigie__isPerformance__c = false];
        AuthorizationClass.GetUser('Ram','545x65e654545',userId,true);
         AuthorizationClass.saveCheckboxChange(creditRecId);
         AuthorizationClass.saveCheckboxChange(creditRecIdDefaultFalse);
         
        AuthorizationClass.saveToggleChange(creditRecId);
         AuthorizationClass.getCreditId();
         //modigie__creditAccountDetails__c instance = new modigie__creditAccountDetails__c();
         //instance.modigie__Title__c	 = 'First Credit Id';
         
         //ser us = new user();
         //us.FirstName = 'vaibhav';
         //us.LastName = 'vyas';
         
        Map<Object, Object> newMap = new Map<Object, Object>();
        newMap.put('userId','0051U000005tLCEQA2');
        newMap.put('userName','Vaibhav Vyas');
        newMap.put('recordId','a0K1U00000Imi3qUAB');
         newMap.put('creditTitle','First Credit Id');
		Object objSMR = (Object)newMap;
         
         list<object> lst = new list<object>();
                lst.add(objSMR);
         
         system.debug('list important... '+ lst);
         
         
        // Map<Object, Object> newMap1 = new Map<Object, Object>();
         
         //newMap.put('userId','0051U000003ICSCQA4');
         
		//Object objSMR1 = (Object)newMap1;
         
         list<String> lst1 = new list<String>();
                lst1.add('0051U000003ICSCQA4');  
         
         
          Map<Object, Object> newMap2 = new Map<Object, Object>();
         
         newMap2.put('label','Vaibhav Vyas');
         newMap2.put('value','0051U000005tfupQAA');
         
		Object objSMR2 = (Object)newMap2;
         
         list<object> lst2 = new list<object>();
                lst2.add(objSMR2); 
         
         
         
         
         AuthorizationClass.saveAssignUserDetails(lst,lst1,lst2,true);
         AuthorizationClass.getAssignedUsers();
         AuthorizationClass.getAssignee(creditRecId);
         AuthorizationClass.getAuthenticationDetails();
         AuthorizationClass.saveAuthenticationCredentials('AIzaSyAdjrvymTLQLiq1j5jJDJPC3Mh4Y9NdhZM', 'demo-customer-acme@modigie-backend-us-1.iam.gserviceaccount.com', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA=', null);
         AuthorizationClass.saveAuthenticationCredentials('AIzaSyAdjrvymTLQLiq1j5jJDJPC3Mh4Y9NdhZM', 'demo-customer-acme@modigie-backend-us-1.iam.gserviceaccount.com', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA=', '2022-06-25T10:00:00.000Z');
         AuthorizationClass.authenticateCredentials('AIzaSyAdjrvymTLQLiq1j5jJDJPC3Mh4Y9NdhZM', 'demo-customer-acme@modigie-backend-us-1.iam.gserviceaccount.com', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA=');
         //AuthorizationClass.getNewCreditId('ModigieDefault');
         
     }
        @isTest
     static void accList1(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AuthorizationClassMock());
         AuthorizationClass.refreshCreditIds();
         Test.stopTest();
         
     }
    
            @isTest
     static void accList2(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AuthorizationClassMock());
         AuthorizationClass.createNewCreditId('Test');
         Test.stopTest();
         
     }
    
    
Public class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    Public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id_token":"Created"."id_token":"test"}');
        res.setStatus('Created');
        res.setStatusCode(200);
        return res;
    }
}
}