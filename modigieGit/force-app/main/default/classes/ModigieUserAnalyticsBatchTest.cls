@ISTest
public class ModigieUserAnalyticsBatchTest 
{
    @IsTest
    public static void testmethod1()
    {
		PermissionSet ps=[select id from PermissionSet where Label='Modigie User' AND namespacePrefix='modigie'];
        
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='testusr11@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testusr11modigie@testorg.com');



//Assigning to the User
        
        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId());
            PermissionSetAssignment permAssg = new PermissionSetAssignment(AssigneeId=u.id,PermissionSetId=ps.id);
			insert permAssg;
			
            
            modigie__creditAccountUsers__c cau=new modigie__creditAccountUsers__c();
            cau.modigie__User_Id__c=u.id;
            cau.name='test';
            insert cau;
            
            modigie__creditAccountUsers__c cau1=new modigie__creditAccountUsers__c();
            cau1.modigie__User_Id__c=u.id;
            cau1.name='test';
            insert cau1;
            
            modigie__creditAccountDetails__c madd=new modigie__creditAccountDetails__c();
            madd.name='test';
            madd.modigie__Default__c=true;
            insert madd;
            
            
        }
        
        Database.executeBatch(new ModigieUserAnalyticsBatch());
        String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, new ModigieUserAnalyticsBatch());
        //system.scheduleBatch(new ModigieUserAnalyticsBatch(), 'test', 2);
    }

}