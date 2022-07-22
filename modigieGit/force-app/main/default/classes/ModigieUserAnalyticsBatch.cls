//Modigie User Analytics @Rikky Malviya
public class ModigieUserAnalyticsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful,Schedulable {
    
    public String userAnalyticsCSV = 'Id,Name,Email,Title,Profile,User Role,Modigie User,Modigie Automation User,Modigie Admin,PPU Credit,PFP Credit\n';
    public String creditDetailCSV = 'Title, CreditId, Status, IsDefault, IsPerformance, StopUntilTime\n';
    public Map<Id, UserData> userAnalyticsMap = new Map<Id, UserData>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query = 'SELECT AssigneeId, Assignee.Name, Assignee.Profile.Name, Assignee.UserRole.Name, PermissionSet.Label, Assignee.Title, Assignee.Email FROM PermissionSetAssignment WHERE PermissionSet.namespacePrefix = \'modigie\' AND PermissionSet.Label in (\'Modigie User\',\'Modigie Automation User\',\'Modigie Admin\')';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<PermissionSetAssignment> scope){
        
        try{
            for(PermissionSetAssignment objRec: scope){
                Id objRecUserId = (Id)objRec.get('AssigneeId');
                if(userAnalyticsMap.containsKey(objRecUserId)){
                    userAnalyticsMap.put(objRecUserId, new UserData(userAnalyticsMap.get(objRecUserId), objRec));
                }else{
                    userAnalyticsMap.put(objRecUserId, new UserData(objRec));
                }
            }
        }catch(Exception e){
            //
        }
        
    }
    
    public void finish(Database.BatchableContext bc) {
        
        //Map<Id, User> CAMap = new Map<Id, User>([SELECT ID FROM USER WHERE ID IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.PermissionsCustomizeApplication = true) AND ID = :userAnalyticsMap.keySet()]);
        //Query User with Credit, and PerformanceCredit, also know which one is default at this point of time
        List<modigie__creditAccountUsers__c> cauList = [SELECT modigie__Credit_Id__c, modigie__CreditId_Name__c, modigie__isPerformance__c, modigie__User_Id__c FROM modigie__creditAccountUsers__c WHERE modigie__User_Id__c = :userAnalyticsMap.keySet()];
        Map<Id, UserCreditData> cauMap = new Map<Id, UserCreditData>();
        for(modigie__creditAccountUsers__c cau: cauList){
            if(cauMap.containsKey((Id)cau.modigie__User_Id__c)){
                cauMap.put((Id)cau.modigie__User_Id__c, new userCreditData(cauMap.get((Id)cau.modigie__User_Id__c), cau));
            }else{
                cauMap.put((Id)cau.modigie__User_Id__c, new userCreditData(cau));
            }
        }
		//Default Query to generate this
		List<modigie__creditAccountDetails__c> defaultPPUCredit = [SELECT modigie__Title__c, modigie__Credit_Id__c, modigie__isPerformance__c FROM modigie__creditAccountDetails__c WHERE modigie__Default__c = true];
        String defaultPPUCreditString = null;
		String PFPCreditString = null;
		if(defaultPPUCredit.size() == 1){
			modigie__creditAccountDetails__c mcd = defaultPPUCredit[0];
			defaultPPUCreditString = mcd.modigie__Title__c + '/' + AuthorizationClass.getEncryptedId(mcd.modigie__Credit_Id__c);
		}
        for(Id userId : userAnalyticsMap.keySet()){
            UserData u = userAnalyticsMap.get(userId);
            userAnalyticsCSV += u.User_Id + ',';
            userAnalyticsCSV += u.User_Name + ',';
            userAnalyticsCSV += u.User_Email + ',';
            userAnalyticsCSV += u.User_Title + ',';
            userAnalyticsCSV += u.Profile_Name + ',';
            userAnalyticsCSV += u.UserRole_Name + ',';
            userAnalyticsCSV += (u.Modigie_User == true ? 'Yes' : 'No') + ',';
            userAnalyticsCSV += (u.Modigie_Automation_User == true ? 'Yes' : 'No') + ',';
            userAnalyticsCSV += (u.Modigie_Admin == true ? 'Yes' : 'No') + ',';
            if(cauMap.containsKey(userId)){
                userCreditData ucd = cauMap.get(userId);
                userAnalyticsCSV += (ucd.creditPPU != null ? ucd.CreditPPU : defaultPPUCreditString) + ',';
                userAnalyticsCSV += ucd.creditPFP + '\n';
            }else{
				String nullString = null;
                userAnalyticsCSV += defaultPPUCreditString + ',';
                userAnalyticsCSV += nullString + '\n';
            }
        }

        List<modigie__creditAccountDetails__c> credList = [SELECT modigie__Title__c, modigie__Credit_Id__c, modigie__Default__c, modigie__isPerformance__c, modigie__Status__c, modigie__StopUntilTime__c FROM modigie__creditAccountDetails__c LIMIT 500];
        //Map<Id, UserCreditData> credMap = new Map<Id, UserCreditData>();
        for(modigie__creditAccountDetails__c cred: credList){
            /*if(credMap.containsKey((Id)cred.modigie__User_Id__c)){
                credMap.put((Id)cred.modigie__User_Id__c, new userCreditData(credMap.get((Id)cred.modigie__User_Id__c), cred));
            }else{
                credMap.put((Id)cred.modigie__User_Id__c, new userCreditData(cred));
            }*/
            creditDetailCSV += cred.modigie__Title__c + ',';
            creditDetailCSV += cred.modigie__Credit_Id__c + ',';
            creditDetailCSV += cred.modigie__Status__c + ',';
            creditDetailCSV += (cred.modigie__Default__c == true ? 'Yes' : 'No') + ',';
            creditDetailCSV += (cred.modigie__isPerformance__c == true ? 'Yes' : 'No') + ',';
            creditDetailCSV += cred.modigie__StopUntilTime__c + '\n';
        }

        Messaging.EmailFileAttachment creditDetailCSVFile = new Messaging.EmailFileAttachment();
        blob creditDetailCSVBlob = Blob.valueOf(creditDetailCSV);
        string creditDetailCSVName = UserInfo.getOrganizationName() + ' - ' + UserInfo.getOrganizationId() + ' - Credit Data.csv';
        creditDetailCSVFile.setFileName(creditDetailCSVName);
        creditDetailCSVFile.setBody(creditDetailCSVBlob);

        Messaging.EmailFileAttachment userAnalyticsCSVFile = new Messaging.EmailFileAttachment();
        blob userAnalyticsCSVBlob = Blob.valueOf(userAnalyticsCSV);
        String subject = UserInfo.getOrganizationName() + ' - ' + UserInfo.getOrganizationId() + ' - Modigie User Analytics';
        string userAnalyticsCSVName = subject + ' Data.csv';
        userAnalyticsCSVFile.setFileName(userAnalyticsCSVName);
        userAnalyticsCSVFile.setBody(userAnalyticsCSVBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'gajendra@cyntexa.com','harshyadav@cyntexa.com', 'rikkymalviya@modigie.com', 'ankur@cyntexa.com'};
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setPlainTextBody(subject);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{userAnalyticsCSVFile, creditDetailCSVFile});
        try{
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }catch(Exception ex){}
        
    }
    
    public void execute(SchedulableContext SC) {
        database.executebatch(new ModigieUserAnalyticsBatch());
    }
    
    public class UserData {
		public String User_Id;
		public String User_Name;
		public String Profile_Name;
		public String UserRole_Name;
		public String User_Title;
		public String User_Email;
        public String Credit_Detail;
        public Boolean Performance_User;
		public Boolean Modigie_User;
		public Boolean Modigie_Admin;
		public Boolean Modigie_Automation_User;
		public UserData(PermissionSetAssignment psa) {
            User_Id = (String)psa.get('AssigneeId');
            User_Name = (String)(psa.Assignee.Name);
            Profile_Name = (String)(psa.Assignee.Profile.Name);
            UserRole_Name = (String)(psa.Assignee.UserRole.Name);
            User_Title = (String)(psa.Assignee.Title);
            User_Email = (String)(psa.Assignee.Email);
            String PermLabel = (String)(psa.PermissionSet.Label);
            switch on PermLabel {
                when 'Modigie Admin' {
                    Modigie_Admin = true;
                }
                when 'Modigie User' {
                    Modigie_User = true;
                }
                when 'Modigie Automation User' {
                    Modigie_Automation_User = true;
                }
            }
		}
        public UserData(UserData u, PermissionSetAssignment psa){
            User_Id = u.User_Id;
            User_Name = u.User_Name;
            Profile_Name = u.Profile_Name;
            UserRole_Name = u.UserRole_Name;
            User_Title = u.User_Title;
            User_Email = u.User_Email;
            Modigie_User = u.Modigie_User;
            Modigie_Admin = u.Modigie_Admin;
            Modigie_Automation_User = u.Modigie_Automation_User;
            
            String PermLabel = (String)(psa.PermissionSet.Label);
            switch on PermLabel {
                when 'Modigie Admin' {
                    Modigie_Admin = true;
                }
                when 'Modigie User' {
                    Modigie_User = true;
                }
                when 'Modigie Automation User' {
                    Modigie_Automation_User = true;
                }
            }
        }
	}
    public class UserCreditData {
        public String User_Id;
        public String creditPPU;
        public String creditPFP;
        public UserCreditData(modigie__creditAccountUsers__c cau) {
            if(cau.modigie__isPerformance__c){
                creditPFP = cau.modigie__CreditId_Name__c + '/' + AuthorizationClass.getEncryptedId(cau.modigie__Credit_Id__c);
            }else{
            	creditPPU = cau.modigie__CreditId_Name__c + '/' + AuthorizationClass.getEncryptedId(cau.modigie__Credit_Id__c);
            }
            User_Id = (Id)cau.modigie__User_Id__c;
        }
        public UserCreditData(userCreditData ucd, modigie__creditAccountUsers__c cau) {
            User_Id = ucd.User_Id;
            creditPPU = ucd.creditPPU;
            creditPFP = ucd.creditPFP;
            if(cau.modigie__isPerformance__c){
                creditPFP = cau.modigie__CreditId_Name__c + '/' + AuthorizationClass.getEncryptedId(cau.modigie__Credit_Id__c);
            }else{
            	creditPPU = cau.modigie__CreditId_Name__c + '/' + AuthorizationClass.getEncryptedId(cau.modigie__Credit_Id__c);
            }
        }
    }
}