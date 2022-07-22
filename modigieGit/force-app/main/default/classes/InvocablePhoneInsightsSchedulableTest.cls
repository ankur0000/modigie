@isTest
public class InvocablePhoneInsightsSchedulableTest {
    @isTest
    public static void test1(){

        List<String> idList = new List<String>();
        
        modigie__Process_Builder_Switch__c pbs = new modigie__Process_Builder_Switch__c();
        pbs.modigie__Get_Phone_Insights_Phone_Number_Selected__c = '{"selectedFieldsLead":"Phone,Mobile,","selectedFieldsContact":"Phone,Other,"}';
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
        insert pbs;
        System.assertEquals(pbs.modigie__Linkedin_Url_Campaign_Limits__c, 10);
        
        modigie__Modigie_Credentials__c cred = new modigie__Modigie_Credentials__c();
        cred.modigie__Service_Account_Credentials__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Private_Key__c = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDzgHBgLTGa5Oa\nU/kc6O9ey0B1mz5x55QQleo59lNdOuy2IKK+I8he/vhgRzqGt3dH5Z/mX7WNnLZu\nVgYENZjVZM+aHcBjozZ+XSyFh6pwyIvxhYGfkroBRCF68fKl8mTslEBzjZtOV/R3\nGNZywSFlQTT3G4fLHlQN1nEyWyo9AO9hV+on34FmuLwh2uLSBFEUD+RYUMYkfHOR\n6/IkCei2CFjNefdMHeL6+EGOOkrNYD0M6hI6SJX5Zi0cDQ4pWEGEXPuLu4KK65t2\nD9334uHFY+qXeuoMITnSBEowRDJsJA5DyN/ALxpoGxcW/L14hpXTyGylmCpz4+eS\nvqLuPUSfAgMBAAECggEAJ2F+jumQ8jtes3JiLwNWaW1dqImxtH0MFY3hTwkQ2TZp\nt3O256EQwrJrSAnrZn7t2aMAVvg27qVvN5/Lk/snovukmW2UbTW9VwrsUmrnx8k+\nBDSCzpJXILwQM8cHs4Kd88sZb2QysT4VaAKx1uCrE89alLyPwjV2WFYh7CvTwfLc\ncc3HOrVFvFu9mutLAVYl3qjLzb5j3ezEuMwrgbJQM3bXM/0VPeaYiBgbtGPyikZQ\ne1y2WB8j+NLwsm+LUCllPl3RfzvQF0RFt+aYccD4TdwWBEW3pBOKr9PbV6X/6yRm\nxWuoMHi6k7Om4yf05lhSPn+czuENpSzR24n3qoMBmQKBgQD9b0V+m/zWyK8XbQjy\nCy7IUwnInHiKuDMLSCaW+m7M/dUxafZzvedsLUW2TzBkCFT/ZahWPt3+m8+mq1jF\n+HSx0ralPmYNR38WZK9Dl/Q7inRRDb4/7jfWB9ODKC0U62ak7CGhwzGjK8Hq91zQ\nhInAHz9QU+25K7NNwKWM6ISLOwKBgQDFyWXvAPhkFYz+jwHz8xzxypX/BIl74M5H\niCf5fg5IOCt9GdJN1boxw8KrAsKG/vt0n6O+LhQkgVNzhBodqajwKshs2ZLERSU4\n6UjS7Ky1/BRAU4ke2LBBVARlJ6TsRABcRmEAL24rik2pxHsUyBIINKUrV42mKdML\ngm7Kdj0t7QKBgBKG6uapkp9FBn/I6cmABciBQYrX3XwOoTSm7qNE5Yq417gIDgtC\nC8P9v0XnnhsB/Oy6ysabS/FMBK8jgZbfZfCF/fIwkJdR7bl+XM2tMx6TLZOrVIgp\n6w0Lf2vsKPeJifRuirrfoSZTkZaSxMc9mTBhWGiP6iYKSs5ZUgDuEpp3AoGAEMCp\nSKAtadTFd35HbRFHf1docwxAVOTKtBZdRG2f6hAP5u27+WnD9pkdMPzv2x1X0R4A\ncYhXnmvx1JP43lBThdwp08Zt/v/YUkS4LV1sl5F9aaFpuNoju7TRFnxQJM7xtN8l\nMi3SSA/T2jBROIZluJo070HgNpXOUWg/2BhBwFUCgYEAuCsk12gyLSzB4WyD6qUe\nsFZWxceM9LP8x0PX/fGaTx/mf0W3fv4xTlf7XnvCN1QEFDrF7dalYRo0ga8vOOAr\nlqclLfyNHl+P7eF508h/1ieEIYDNAMtCmr5LXtlL7JhdEYps7kh2F5eBhAzHIXaX\nZvYwZb80Kx1yWt1fdXqQW/M=';
        cred.modigie__Credits_Account_Id__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Api_key__c = GetModigieButtonTest.generateRandomString(72);
        cred.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert cred;
        System.assertEquals(cred.modigie__Validation_Key__c, 'Modigie_Credit__c@Cyntexakey');

        Account acc = new Account(Name = 'Test Account');
        insert acc;
        System.assertEquals(acc.Name, 'Test Account');
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.modigie__linkedin_url__c = 'test.linkein.com';
        con.AccountId = acc.Id;
        con.MobilePhone = '7654333322';
        con.Phone = '7654333390';
        con.OtherPhone = '5342789012';
        insert con;
        System.assertEquals(con.modigie__linkedin_url__c, 'test.linkein.com');
        idList.add(con.Id);
        
        Lead ld = new Lead();
        ld.FirstName = 'Test';
        ld.LastName = 'Test';
        ld.company = 'Company';
        ld.MobilePhone = '7654333312';
        ld.Phone = '7647633312';
        ld.modigie__linkedin_url__c = 'test.linkein.com';
        insert ld;
        System.assertEquals(ld.modigie__linkedin_url__c, 'test.linkein.com');
        idList.add(ld.Id);
        
        List<sObject> lstSobj = new List<sObject>();
        lstSobj.add(con);
        lstSobj.add(ld);
        Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
       
        InvocablePhoneInsightsSchedulableClass SC = new InvocablePhoneInsightsSchedulableClass(lstSobj,0); 
        System.schedule('Schedule', sched, SC);
        Test.stopTest();
    }

}