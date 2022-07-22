public with sharing class LimitsMapClass {
    public static Map<Id,Integer> getProfileUserLimitsData(){
        try{
            List<modigie__Profile_and_user_modigie_limits__c> modigieUserProfileLimits = [SELECT modigie__User_or_Profile_Id__c,modigie__Limit_of_modigie_callouts__c,modigie__User_Or_Profile__c FROM modigie__Profile_and_user_modigie_limits__c];
        List<Id> profileIds = new List<Id>();
        for(modigie__Profile_and_user_modigie_limits__c modigieLimits : modigieUserProfileLimits){
            if(modigieLimits.modigie__User_Or_Profile__c?.equalsIgnoreCase('Profile') == true){
                profileIds.add(modigieLimits.modigie__User_or_Profile_Id__c);
            }
        }
        Map<Id,Profile> profileUserMap = new Map<Id,Profile>();

        if(profileIds.size() > 0){
            profileUserMap = new Map<Id,Profile>([SELECT Id, (SELECT Id FROM Users) FROM Profile WHERE Id IN :profileIds]);
        }

        Map<Id,Integer> resultMap = new Map<Id,Integer>();

        for(modigie__Profile_and_user_modigie_limits__c modigieLimits : modigieUserProfileLimits){
            if(modigieLimits.modigie__User_Or_Profile__c?.equalsIgnoreCase('User') == true){
                resultMap.put(modigieLimits.modigie__User_or_Profile_Id__c, (Integer)modigieLimits.modigie__Limit_of_modigie_callouts__c);
            }
            else if(modigieLimits.modigie__User_Or_Profile__c?.equalsIgnoreCase('Profile') == true){
                if(profileUserMap.get(modigieLimits.modigie__User_or_Profile_Id__c) != null){
                    Profile pro = profileUserMap.get(modigieLimits.modigie__User_or_Profile_Id__c);
                    for(User usr : pro.Users){
                        if(!resultMap.containsKey(usr.Id)){
                            resultMap.put(usr.Id,(Integer)modigieLimits.modigie__Limit_of_modigie_callouts__c);
                        }
                    }
                }
            }
        }
        return resultMap;
        }
        catch(Exception e){
            throw new APILimitException(e.getMessage() + 'Line number -->> ' + e.getLineNumber() + ' ' + e.getCause() + ' ' + e.getStackTraceString());
        }
        
    }

    @AuraEnabled
    public static String sendAPILimitData(){
        try{
            Map<String, Object> resultMap = new Map<String, Object>();
        List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c FROM modigie__Process_Builder_Switch__c LIMIT 1];
        if(lstPbs.isEmpty()){
            throw new APILimitException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
        }
        else if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null){
            throw new APILimitException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
        }
        
        if(!lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c){
            return JSON.serialize(new Map<String,Object>{'Ad_Hoc_Limits' => false});
        }
        
        
        
        String userId = UserInfo.getUserId();

        List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieUsage = [SELECT modigie__User_Id__c, modigie__Number_of_modigie_callouts_in_a_day__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WHERE modigie__User_Id__c = :userId LIMIT 1];
        
        Map<Id,Integer> userToLimitsMap = LimitsMapClass.getProfileUserLimitsData();
        System.debug('----------->'+userToLimitsMap.containsKey(userId));
        if(userToLimitsMap
           .containsKey(userId)){
            resultMap.put('Ad_Hoc_Limits',true);
            resultMap.put('Total_API_Limit', userToLimitsMap.get(userId));
            if(modigieUsage.size() > 0){
                resultMap.put('Used_API_Limit', (Integer)modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c);
            }
            else{
                resultMap.put('Used_API_Limit', 0);
            }
        }
        else{
            resultMap.put('Ad_Hoc_Limits',false);
            //throw new APILimitException('You do not have permission to make callouts. Please contact administrator.');
        }
        
        return JSON.serialize(resultMap);
        }
        catch(Exception e){
            throw new APILimitException(e.getMessage() + 'Line number -->> ' + e.getLineNumber() + ' ' + e.getCause() + ' ' + e.getStackTraceString());
        }
        
    }

    private class APILimitException Extends Exception{}
}