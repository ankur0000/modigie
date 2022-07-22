@isTest
public class InvocableGetLinkedInClassTest 
{
    @testSetup 
    public static void setup(){
        modigie__Modigie_Credentials__c cred = new modigie__Modigie_Credentials__c();
        cred.modigie__Service_Account_Credentials__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Private_Key__c = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDzgHBgLTGa5Oa\nU/kc6O9ey0B1mz5x55QQleo59lNdOuy2IKK+I8he/vhgRzqGt3dH5Z/mX7WNnLZu\nVgYENZjVZM+aHcBjozZ+XSyFh6pwyIvxhYGfkroBRCF68fKl8mTslEBzjZtOV/R3\nGNZywSFlQTT3G4fLHlQN1nEyWyo9AO9hV+on34FmuLwh2uLSBFEUD+RYUMYkfHOR\n6/IkCei2CFjNefdMHeL6+EGOOkrNYD0M6hI6SJX5Zi0cDQ4pWEGEXPuLu4KK65t2\nD9334uHFY+qXeuoMITnSBEowRDJsJA5DyN/ALxpoGxcW/L14hpXTyGylmCpz4+eS\nvqLuPUSfAgMBAAECggEAJ2F+jumQ8jtes3JiLwNWaW1dqImxtH0MFY3hTwkQ2TZp\nt3O256EQwrJrSAnrZn7t2aMAVvg27qVvN5/Lk/snovukmW2UbTW9VwrsUmrnx8k+\nBDSCzpJXILwQM8cHs4Kd88sZb2QysT4VaAKx1uCrE89alLyPwjV2WFYh7CvTwfLc\ncc3HOrVFvFu9mutLAVYl3qjLzb5j3ezEuMwrgbJQM3bXM/0VPeaYiBgbtGPyikZQ\ne1y2WB8j+NLwsm+LUCllPl3RfzvQF0RFt+aYccD4TdwWBEW3pBOKr9PbV6X/6yRm\nxWuoMHi6k7Om4yf05lhSPn+czuENpSzR24n3qoMBmQKBgQD9b0V+m/zWyK8XbQjy\nCy7IUwnInHiKuDMLSCaW+m7M/dUxafZzvedsLUW2TzBkCFT/ZahWPt3+m8+mq1jF\n+HSx0ralPmYNR38WZK9Dl/Q7inRRDb4/7jfWB9ODKC0U62ak7CGhwzGjK8Hq91zQ\nhInAHz9QU+25K7NNwKWM6ISLOwKBgQDFyWXvAPhkFYz+jwHz8xzxypX/BIl74M5H\niCf5fg5IOCt9GdJN1boxw8KrAsKG/vt0n6O+LhQkgVNzhBodqajwKshs2ZLERSU4\n6UjS7Ky1/BRAU4ke2LBBVARlJ6TsRABcRmEAL24rik2pxHsUyBIINKUrV42mKdML\ngm7Kdj0t7QKBgBKG6uapkp9FBn/I6cmABciBQYrX3XwOoTSm7qNE5Yq417gIDgtC\nC8P9v0XnnhsB/Oy6ysabS/FMBK8jgZbfZfCF/fIwkJdR7bl+XM2tMx6TLZOrVIgp\n6w0Lf2vsKPeJifRuirrfoSZTkZaSxMc9mTBhWGiP6iYKSs5ZUgDuEpp3AoGAEMCp\nSKAtadTFd35HbRFHf1docwxAVOTKtBZdRG2f6hAP5u27+WnD9pkdMPzv2x1X0R4A\ncYhXnmvx1JP43lBThdwp08Zt/v/YUkS4LV1sl5F9aaFpuNoju7TRFnxQJM7xtN8l\nMi3SSA/T2jBROIZluJo070HgNpXOUWg/2BhBwFUCgYEAuCsk12gyLSzB4WyD6qUe\nsFZWxceM9LP8x0PX/fGaTx/mf0W3fv4xTlf7XnvCN1QEFDrF7dalYRo0ga8vOOAr\nlqclLfyNHl+P7eF508h/1ieEIYDNAMtCmr5LXtlL7JhdEYps7kh2F5eBhAzHIXaX\nZvYwZb80Kx1yWt1fdXqQW/M=';
        cred.modigie__Credits_Account_Id__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Api_key__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert cred;
        
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
        con.modigie__Company_URL__c = 'companyurl@test.com';
        con.modigie__Company_Email__c = 'companyemail@test.com';
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
        l.modigie__linkedin_url__c = 'linkedinurl@test.com'; 
        l.MobilePhone = '6556612987';
        insert l;
        System.assert(l.Company == 'Test & Company');
        
      
    }
    
    @isTest
    public static void testMethod1(){
        modigie__Modigie_Credentials__c cred = new modigie__Modigie_Credentials__c();
        cred.modigie__Service_Account_Credentials__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Private_Key__c = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDzgHBgLTGa5Oa\nU/kc6O9ey0B1mz5x55QQleo59lNdOuy2IKK+I8he/vhgRzqGt3dH5Z/mX7WNnLZu\nVgYENZjVZM+aHcBjozZ+XSyFh6pwyIvxhYGfkroBRCF68fKl8mTslEBzjZtOV/R3\nGNZywSFlQTT3G4fLHlQN1nEyWyo9AO9hV+on34FmuLwh2uLSBFEUD+RYUMYkfHOR\n6/IkCei2CFjNefdMHeL6+EGOOkrNYD0M6hI6SJX5Zi0cDQ4pWEGEXPuLu4KK65t2\nD9334uHFY+qXeuoMITnSBEowRDJsJA5DyN/ALxpoGxcW/L14hpXTyGylmCpz4+eS\nvqLuPUSfAgMBAAECggEAJ2F+jumQ8jtes3JiLwNWaW1dqImxtH0MFY3hTwkQ2TZp\nt3O256EQwrJrSAnrZn7t2aMAVvg27qVvN5/Lk/snovukmW2UbTW9VwrsUmrnx8k+\nBDSCzpJXILwQM8cHs4Kd88sZb2QysT4VaAKx1uCrE89alLyPwjV2WFYh7CvTwfLc\ncc3HOrVFvFu9mutLAVYl3qjLzb5j3ezEuMwrgbJQM3bXM/0VPeaYiBgbtGPyikZQ\ne1y2WB8j+NLwsm+LUCllPl3RfzvQF0RFt+aYccD4TdwWBEW3pBOKr9PbV6X/6yRm\nxWuoMHi6k7Om4yf05lhSPn+czuENpSzR24n3qoMBmQKBgQD9b0V+m/zWyK8XbQjy\nCy7IUwnInHiKuDMLSCaW+m7M/dUxafZzvedsLUW2TzBkCFT/ZahWPt3+m8+mq1jF\n+HSx0ralPmYNR38WZK9Dl/Q7inRRDb4/7jfWB9ODKC0U62ak7CGhwzGjK8Hq91zQ\nhInAHz9QU+25K7NNwKWM6ISLOwKBgQDFyWXvAPhkFYz+jwHz8xzxypX/BIl74M5H\niCf5fg5IOCt9GdJN1boxw8KrAsKG/vt0n6O+LhQkgVNzhBodqajwKshs2ZLERSU4\n6UjS7Ky1/BRAU4ke2LBBVARlJ6TsRABcRmEAL24rik2pxHsUyBIINKUrV42mKdML\ngm7Kdj0t7QKBgBKG6uapkp9FBn/I6cmABciBQYrX3XwOoTSm7qNE5Yq417gIDgtC\nC8P9v0XnnhsB/Oy6ysabS/FMBK8jgZbfZfCF/fIwkJdR7bl+XM2tMx6TLZOrVIgp\n6w0Lf2vsKPeJifRuirrfoSZTkZaSxMc9mTBhWGiP6iYKSs5ZUgDuEpp3AoGAEMCp\nSKAtadTFd35HbRFHf1docwxAVOTKtBZdRG2f6hAP5u27+WnD9pkdMPzv2x1X0R4A\ncYhXnmvx1JP43lBThdwp08Zt/v/YUkS4LV1sl5F9aaFpuNoju7TRFnxQJM7xtN8l\nMi3SSA/T2jBROIZluJo070HgNpXOUWg/2BhBwFUCgYEAuCsk12gyLSzB4WyD6qUe\nsFZWxceM9LP8x0PX/fGaTx/mf0W3fv4xTlf7XnvCN1QEFDrF7dalYRo0ga8vOOAr\nlqclLfyNHl+P7eF508h/1ieEIYDNAMtCmr5LXtlL7JhdEYps7kh2F5eBhAzHIXaX\nZvYwZb80Kx1yWt1fdXqQW/M=';
        cred.modigie__Credits_Account_Id__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Api_key__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert cred;
        List<String> strList = new List<String>();
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        strList.add(l.Id);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockResponseInvocableGetLinkedInClass());
        InvocableGetLinkedInClass.getRecordId(strList);
        test.stopTest();
        List<modigie__Modigie__c> modigies = [select id from modigie__Modigie__c];
        System.assertEquals(false,modigies.size()>0);
        
    }
    
    @isTest
    public static void testMethod2(){
        List<String> strList = new List<String>();
        
        Contact con = [SELECT Id, Account.Name, modigie__Company_Email__c, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity, Account.BillingState, Account.BillingCountry, modigie__linkedin_url__c, FirstName, LastName, Email, modigie__Company_URL__c, MobilePhone FROM Contact Where LastName = 'Contact' LIMIT 1];
        strList.add(con.Id);
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        test.startTest();
        InvocableGetLinkedInClass.getRecordId(strList);
        test.stopTest();
        List<modigie__Modigie__c> modigies = [select id from modigie__Modigie__c];
        System.assertEquals(true,modigies.size()>0);
    }
    
    @isTest
    public static void testMethod3(){
        List<String> strList = new List<String>();
        
        Lead l = [SELECT FirstName, LastName, Company, Email, modigie__Company_Email__c, modigie__Company_URL__c, modigie__linkedin_url__c, MobilePhone FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        strList.add(l.Id);
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.Lead__c = l.Id;
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        test.startTest();

        InvocableGetLinkedInClass.getRecordId(strList);
        test.stopTest();
        List<modigie__Modigie__c> modigies = [select id from modigie__Modigie__c];
        System.assertEquals(true,modigies.size()>0);
    }
    
    @isTest
    public static void testMethod4(){
        List<String> strList = new List<String>();
        
        Contact con = [SELECT Id, Account.Name, modigie__Company_Email__c, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity, Account.BillingState, Account.BillingCountry, modigie__linkedin_url__c, FirstName, LastName, Email, modigie__Company_URL__c, MobilePhone FROM Contact Where LastName = 'Contact' LIMIT 1];
        strList.add(con.Id);
        Modigie__c modirec1 = new Modigie__c();
        modirec1.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec1.Status__c = 'In process';
        modirec1.modigie__Parent_Id__c = con.Id;
        modirec1.modigie__Contact__c = con.Id;
        modirec1.Date_Last_Updated__c = Date.today();
        insert modirec1;
        System.assert(modirec1.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
		Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        test.startTest();
        
        InvocableGetLinkedInClass.getRecordId(strList);
        test.stopTest();
        List<modigie__Modigie__c> modigies = [select id from modigie__Modigie__c];
        System.assertEquals(true,modigies.size()>0);
    }
    
    @isTest
    public static void testMethod5(){
        List<String> strList = new List<String>();
        
        Contact con = [SELECT Id, Account.Name, modigie__Company_Email__c, Account.BillingStreet, Account.BillingPostalCode, Account.BillingCity, Account.BillingState, Account.BillingCountry, modigie__linkedin_url__c, FirstName, LastName, Email, modigie__Company_URL__c, MobilePhone FROM Contact Where LastName = 'Contact' LIMIT 1];
        strList.add(con.Id);
        Modigie__c modirec1 = new Modigie__c();
        modirec1.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec1.Status__c = 'In process';
        modirec1.modigie__Parent_Id__c = con.Id;
        modirec1.modigie__Contact__c = con.Id;
        modirec1.Date_Last_Updated__c = Date.today();
        insert modirec1;
        System.assert(modirec1.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
		Test.setMock(HttpCalloutMock.class, new BadResponseMock());
        test.startTest();
            try{
                InvocableGetLinkedInClass.getRecordId(strList);
            }catch(exception e){
            }
        test.stopTest();
        List<modigie__Modigie__c> modigies = [select id from modigie__Modigie__c];
        System.assertEquals(true,modigies.size()>0);
    }
    
}