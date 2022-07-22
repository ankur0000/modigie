public with sharing class UserLimitsCompController {
    @AuraEnabled
    public static String fetchUserProfileData(String searchTerm,String searchObject,List<Map<String,Object>> dataMap){
     
        List<Id> userIds = new List<Id>();
        List<Id> profileIds = new List<Id>();
        
        for(Map<String,Object> mMap : dataMap){
            if(mMap.get('SelectedOptionId') != null){
                if(mMap.get('searchObject') != null){
                    if(mMap.get('searchObject')?.toString()?.equalsIgnoreCase('User') == true){
                        userIds.add((Id)mMap.get('SelectedOptionId'));
                    }
                    else if(mMap.get('searchObject')?.toString()?.equalsIgnoreCase('Profile') == true){
                        profileIds.add((Id)mMap.get('SelectedOptionId'));
                    }
                }
            }
        }
        
        
        List<String> modigiePermissionSets = new List<String>{'Modigie_Admin','Modigie_User'};
       	List<sObject> result = new List<sObject>();
        String query = 'SELECT Name FROM ';// + 'Profile WHERE Name Like \'%' + searchTerm + '%\'';
        if(searchObject?.equalsIgnoreCase('User') == true){
        	query += 'User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name IN :modigiePermissionSets) AND Name Like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' AND Id NOT IN :userIds WITH SECURITY_ENFORCED';
        	result = Database.query(query);
        }
        else if(searchObject?.equalsIgnoreCase('Profile') == true){
            query = 'SELECT Name,(Select Name from Users WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name IN :modigiePermissionSets)) FROM Profile WHERE Name Like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' AND Id NOT IN :profileIds WITH SECURITY_ENFORCED';
            List<Profile> lstPro = Database.query(query);
            //List<Profile> lstPro = [SELECT Name,(Select Name from Users WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name IN :modigiePermissionSets)) FROM Profile];
            for(Profile pro : lstPro){
                if(pro.Users.size() > 0){
                    result.add(pro);
                }
            }
        }
        
        //query += ' AND Name Like \'%' + searchTerm + '%\'';
      //  result = Database.query(query);
        if(result.size() > 0){
        	return JSON.serialize(result);    
        }
        else{
            return null;
        }
        
    }
    
    @AuraEnabled
    public static void storeUserProfileLimits(List<Map<String,Object>> dataMap){
        List<modigie__Profile_and_user_modigie_limits__c> deleteAllRecords = [SELECT name FROM modigie__Profile_and_user_modigie_limits__c WITH SECURITY_ENFORCED LIMIT 50000];
        if(deleteAllRecords.size() > 0){
            if(FieldLevelSecurityCheck.canReadObject('modigie__Profile_and_user_modigie_limits__c') &&
            FieldLevelSecurityCheck.canDeleteObject('modigie__Profile_and_user_modigie_limits__c')){
                delete deleteAllRecords;
            }
        }
        
        List<modigie__Profile_and_user_modigie_limits__c> lstModigieLimits = new List<modigie__Profile_and_user_modigie_limits__c>();
        for(Map<String,Object> mMap : dataMap){
        	modigie__Profile_and_user_modigie_limits__c modigieLimits = new modigie__Profile_and_user_modigie_limits__c();
            modigieLimits.Name = mMap.get('SelectedOptionId').toString();
            modigieLimits.modigie__User_or_Profile_Id__c = mMap.get('SelectedOptionId').toString();
            modigieLimits.modigie__User_or_Profile_Name__c = mMap.get('SelectedOptionValue').toString();
            modigieLimits.modigie__User_Or_Profile__c = mMap.get('searchObject').toString();
            modigieLimits.modigie__Limit_of_modigie_callouts__c = Integer.valueOf(mMap.get('numberOfLimits'));
            lstModigieLimits.add(modigieLimits);
        }
        
        if(lstModigieLimits.size() > 0){
            if(FieldLevelSecurityCheck.canReadObject('modigie__Profile_and_user_modigie_limits__c') &&
            FieldLevelSecurityCheck.canCreateObject('modigie__Profile_and_user_modigie_limits__c') &&
            FieldLevelSecurityCheck.canUpdateObject('modigie__Profile_and_user_modigie_limits__c') &&
            FieldLevelSecurityCheck.canReadField('modigie__Profile_and_user_modigie_limits__c', 'Name') &&
            FieldLevelSecurityCheck.canCreateField('modigie__Profile_and_user_modigie_limits__c', 'Name') &&
            FieldLevelSecurityCheck.canReadField('modigie__Profile_and_user_modigie_limits__c', 'modigie__User_or_Profile_Id__c') &&
            FieldLevelSecurityCheck.canCreateField('modigie__Profile_and_user_modigie_limits__c', 'modigie__User_or_Profile_Id__c') &&
            FieldLevelSecurityCheck.canReadField('modigie__Profile_and_user_modigie_limits__c', 'modigie__User_or_Profile_Name__c') &&
            FieldLevelSecurityCheck.canCreateField('modigie__Profile_and_user_modigie_limits__c', 'modigie__User_or_Profile_Name__c') &&
            FieldLevelSecurityCheck.canReadField('modigie__Profile_and_user_modigie_limits__c', 'modigie__User_Or_Profile__c') &&
            FieldLevelSecurityCheck.canCreateField('modigie__Profile_and_user_modigie_limits__c', 'modigie__User_Or_Profile__c') &&
            FieldLevelSecurityCheck.canReadField('modigie__Profile_and_user_modigie_limits__c', 'modigie__Limit_of_modigie_callouts__c') &&
            FieldLevelSecurityCheck.canCreateField('modigie__Profile_and_user_modigie_limits__c', 'modigie__Limit_of_modigie_callouts__c')){
                insert lstModigieLimits;
            }
        }
    }
    
    @AuraEnabled
    public static String getUserProfileLimitsData(){
		List<modigie__Profile_and_user_modigie_limits__c> lstModigieLimits = [SELECT modigie__User_or_Profile_Id__c, modigie__User_or_Profile_Name__c, modigie__User_Or_Profile__c, modigie__Limit_of_modigie_callouts__c FROM modigie__Profile_and_user_modigie_limits__c WITH SECURITY_ENFORCED LIMIT 50000];
        if(lstModigieLimits.size() == 0){
            return null;
        }
        return JSON.serialize(lstModigieLimits);
    }
    
    @AuraEnabled
    public static Boolean getAdhocLimitData(){
		List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                    if(lstPbs.isEmpty()){
                        throw new UserLimitsCompControllerException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
                    }
                    else if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null){
                        throw new UserLimitsCompControllerException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
                    }
        return lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c;
    }
    
    @AuraEnabled
    public static void setAdHocLimitData(Boolean adHocLimit){
     List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
        if(lstPbs.isEmpty())
            throw new UserLimitsCompControllerException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
        else if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_Hoc__c == null)
            throw new UserLimitsCompControllerException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
        
        lstPbs[0].modigie__Limit_User_for_Modigie_Ad_Hoc__c = adHocLimit;

        update lstPbs;
            }
    
    private class UserLimitsCompControllerException extends Exception{}
}