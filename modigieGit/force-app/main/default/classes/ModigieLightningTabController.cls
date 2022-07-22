public with sharing class ModigieLightningTabController {
    @AuraEnabled
    public static Object getModigieInformationCustom(Id recid){
        try{

           // String sObjectType = recid.getSObjectType().getDescribe().getName();
            List <modigie__Modigie__c> lstModigie = [SELECT Id, modigie__Employment_Ends_Get_Modigie__c, modigie__Employment_Ends_Verify_Employer__c, modigie__Formatted_Other_Phone_Number__c, modigie__Formatted_Phone_Number__c, modigie__Formatted_Mobile_Number__c, modigie__Validation_Date_Alternate_Number2__c, modigie__Current_Title_Get_Modigie__c, modigie__Validation_Date_Alternate_Number1__c, modigie__Validation_Date_Modigie_Val_Phone_Number__c,modigie__Validation_Date_Other_Phone__c, modigie__Validation_Date_Phone__c,modigie__Linkedin_URL__c, modigie__Phone_Type_Alternate_Number2__c, modigie__Phone_Type_Alternate_Number1__c, modigie__Phone_Type_Phone__c,modigie__Phone_Type_Modigie_Validated_Number__c,modigie__Phone_Type_Other_Phone__c,modigie__Validation_Date_Get_LinkedIn__c, modigie__Validation_Date_Mobile__c, modigie__Validation_Date_Verify_Employer__c, modigie__Validation_Date_Get_Mobile_Number__c, modigie__Status__c, modigie__Linkedin_Status__c, modigie__Phone_Intelligence_Status__c, modigie__Validate_Employer_Status__c, modigie__Mobile__c,modigie__Mobile_2__c,modigie__Mobile_3__c,  modigie__Company_Name_Matches_Public_Records__c,modigie__Current_Employer__c, modigie__Current_Title__c, modigie__Current__c, modigie__Phone_Name_Match__c, modigie__Line_Activity__c, modigie__Phone_Type__c, modigie__Best_Time_to_Call__c,modigie__Day_of_Week_Detail__c,modigie__Verified_Phone_Get_Phone_Insights__c,modigie__Accuracy_Match_Phone__c, modigie__Accuracy_Match_Modigie_Validated_Number__c, modigie__Accuracy_Match_Alternate_Number1__c, modigie__Accuracy_Match_Alternate_Number2__c, modigie__Accuracy_Match_Other_Phone__c,   modigie__Day_of_Week_Detail_Phone__c, modigie__Day_of_Week_Detail_Modigie_Val_Number__c, modigie__Day_of_Week_Detail_Alternate_Number1__c, modigie__Day_of_Week_Detail_Alternate_Number2__c, modigie__Day_of_Week_Detail_Other_Phone__c, modigie__Line_Activity_Phone__c, modigie__Line_Activity_Modigie_Validated_Number__c, modigie__Line_Activity_Alternate1__c, modigie__Line_Activity_Alternate2__c, modigie__Line_Activity_Other_Phone__c,  modigie__Best_Time_to_Call_Phone__c, modigie__Best_Time_to_Call_Validated_Number__c, modigie__Best_Time_to_Call_Alternate_Number1__c, modigie__Best_Time_to_Call_Alternate_Number2__c, modigie__Best_Time_to_Call_Phone_Other_Phone__c,  modigie__Phone_Intelligence_Status_Phone__c, modigie__Phone_Intelligence_Status_Modigie_Number__c, modigie__Phone_Intelligence_Status_Alt_Number1__c, modigie__Phone_Intelligence_Status_Alt_Number2__c, modigie__Phone_Intelligence_Status_Other_Phone__c, modigie__Verified_Phone_Get_Phone_Insights_Phone__c, modigie__Verified_Phone_Get_Phone_Insights_ValNum__c, modigie__Verified_Phone_Get_Phone_Insights_Alt1__c, modigie__Verified_Phone_Get_Phone_Insights_Alt2__c, modigie__Verified_Phone_Get_Phone_Insights_OPhone__c, modigie__Get_Number_Intelligence_Date_Phone__c, modigie__Get_Number_Intelligence_Date_Val_Number__c, modigie__Get_Number_Intelligence_Date_Alt1__c, modigie__Get_Number_Intelligence_Date_Alt2__c, modigie__Get_Number_Intelligence_Date_Other_Phone__c,modigie__LinkedIn_Url_Get_Mobile_Number__c,modigie__LinkedIn_Url_Verify_Employer__c, modigie__Carrier_Name_Mobile__c, modigie__Carrier_Name_Phone__c, modigie__Carrier_Name_Other_Phone__c,modigie__Current_Country_Get_Modigie__c, modigie__Current_Employer_Get_Modigie__c,modigie__Company_Name_Matches_Records_Get_Modigie__c,modigie__Business_Email_1__c,modigie__Business_Email_2__c,modigie__Business_Email_3__c,modigie__Business_Email_4__c,modigie__Private_Email_1__c,modigie__Private_Email_2__c FROM modigie__Modigie__c WHERE modigie__Parent_Id__c  = :recid WITH SECURITY_ENFORCED LIMIT 1];
            
            List <String> statusField = new List<String>{'modigie__Phone_Intelligence_Status__c','modigie__Phone_Intelligence_Status_Phone__c','modigie__Phone_Intelligence_Status_Other_Phone__c'};

            String phoneInsightsHeadingString = 'Get Phone Insights';

            
            
            if(lstModigie.size() == 1){
                System.debug('Lst Modigie Data -->> ' + lstModigie[0].modigie__Company_Name_Matches_Public_Records__c);
                System.debug('Lst Modigie Data (get modigie) -->> ' + lstModigie[0].modigie__Company_Name_Matches_Records_Get_Modigie__c);

                List<Map<String,Object>> result = new List<Map<String,Object>>();

                Map<String,Object> obj = new Map<String,Object>();

                List<PermissionSetAssignment> lstUser = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId =:UserInfo.getUserId() AND PermissionSet.NamespacePrefix = 'modigie' AND PermissionSet.Name in ('Modigie_Admin', 'Modigie_User', 'Modigie_Automation_User')];
                if(lstUser.size() == 0){
                    obj.put('ModigieUser', false);
                }else{
                    obj.put('ModigieUser', true);
                }

                Integer notStarted=0,inProcess=0,notAvailable=0,validated=0;
                
                for(String statusFld : statusField){
                    String status = (String)lstModigie[0].get(statusFld);
                    if(status?.equalsIgnoreCase('Not Available') == true){
                        notAvailable++;
                    }
                    else if(status?.equalsIgnoreCase('Not started') == true || status?.equalsIgnoreCase('Unavailable') == true){
                        notStarted++;
                    }
                    else if(status?.equalsIgnoreCase('Validated') == true){
                        validated++;
                    }

                    else if(status?.equalsIgnoreCase('In process') == true){
                        inProcess++;
                    }
                }
                
                phoneInsightsHeadingString = 'Get Phone Insights -';
                if(validated > 0){
                    phoneInsightsHeadingString += ' ' + validated + ' Validated,';
                }
                
                if(inProcess > 0){
                    phoneInsightsHeadingString += ' ' + inProcess +  ' In process,';
                }
                if(notStarted > 0){
                    phoneInsightsHeadingString += ' ' + notStarted +  ' Not started,';
                }
                if(notAvailable > 0){
                    phoneInsightsHeadingString += ' ' + notAvailable +  ' Not available,';
                }
                String phoneInsightsMainStatus = '';
                if(inProcess > 0){
                    phoneInsightsMainStatus = 'In process (See status below)';
                }
                else if(validated > 0 || notAvailable > 0){
                    phoneInsightsMainStatus='Completed';
                }
                else{
                    phoneInsightsMainStatus = 'Not started';
                }
                obj.put('ModigieData', lstModigie[0]);
                obj.put('phoneInsightsMainStatus',phoneInsightsMainStatus);
                result.add(obj);
                if(lstModigie[0].modigie__Phone_Intelligence_Status__c != 'Not started' && lstModigie[0].modigie__Phone_Intelligence_Status__c != null && lstModigie[0].modigie__Phone_Intelligence_Status__c != 'Unavailable'){
                    obj = new Map<String,Object>();
                    obj.put('ValidatedPhoneNumber', 'Mobile - ' + lstModigie[0].modigie__Formatted_Mobile_Number__c);
                    obj.put('AccuracyMatch',lstModigie[0].modigie__Phone_Name_Match__c);
                    obj.put('NumberType', lstModigie[0].modigie__Phone_Type__c);
                    //obj.put('OverallBestTimeToCall', lstModigie[0].modigie__Verified_Phone_Get_Phone_Insights__c);
                    if(lstModigie[0].modigie__Line_Activity__c != null && !lstModigie[0]?.modigie__Line_Activity__c?.containsIgnoreCase('Inactive') == true){
                        obj.put('LineActivity', lstModigie[0].modigie__Line_Activity__c);
                    }
                    obj.put('Status', lstModigie[0].modigie__Phone_Intelligence_Status__c);
                    if(lstModigie[0].modigie__Validation_Date_Mobile__c != null){
                        obj.put('ValidationDate', lstModigie[0].modigie__Validation_Date_Mobile__c.Date());
                    }
                    if(lstModigie[0].modigie__Day_of_Week_Detail__c != null && lstModigie[0].modigie__Day_of_Week_Detail__c != ''){
                    	obj.put('DayOfWeekDetail', getTimeWindow(lstModigie[0].modigie__Day_of_Week_Detail__c));    
                    }
                    
                    if(lstModigie[0].modigie__Carrier_Name_Mobile__c != null){
                        obj.put('CarrierName', lstModigie[0].modigie__Carrier_Name_Mobile__c); 
                    }
                    result.add(obj);
                }
                if(lstModigie[0].modigie__Phone_Intelligence_Status_Phone__c != 'Not started' && lstModigie[0].modigie__Phone_Intelligence_Status_Phone__c != null && lstModigie[0].modigie__Phone_Intelligence_Status_Phone__c != 'Unavailable'){
                    obj = new Map<String,Object>();
                    obj.put('ValidatedPhoneNumber', 'Phone - ' + lstModigie[0].modigie__Formatted_Phone_Number__c);
                    obj.put('AccuracyMatch',lstModigie[0].modigie__Accuracy_Match_Phone__c);
                    obj.put('NumberType', lstModigie[0].modigie__Phone_Type_Phone__c);
                    //obj.put('OverallBestTimeToCall', lstModigie[0].modigie__Verified_Phone_Get_Phone_Insights__c);
                    if(lstModigie[0].modigie__Line_Activity_Phone__c != null &&!lstModigie[0]?.modigie__Line_Activity_Phone__c?.containsIgnoreCase('Inactive') == true){
                        obj.put('LineActivity', lstModigie[0].modigie__Line_Activity_Phone__c);
                    }
                    obj.put('Status', lstModigie[0].modigie__Phone_Intelligence_Status_Phone__c);
                    if(lstModigie[0].modigie__Validation_Date_Phone__c !=  null){
                        obj.put('ValidationDate', lstModigie[0].modigie__Validation_Date_Phone__c.Date());
                    }
                    if(lstModigie[0].modigie__Day_of_Week_Detail_Phone__c != null && lstModigie[0].modigie__Day_of_Week_Detail_Phone__c != ''){
                    	obj.put('DayOfWeekDetail', getTimeWindow(lstModigie[0].modigie__Day_of_Week_Detail_Phone__c));    
                    }
                    
                    if(lstModigie[0].modigie__Carrier_Name_Phone__c != null){
                        obj.put('CarrierName', lstModigie[0].modigie__Carrier_Name_Phone__c);
                    }
                    result.add(obj);
                }
                if(lstModigie[0].modigie__Phone_Intelligence_Status_Other_Phone__c != 'Not started' && lstModigie[0].modigie__Phone_Intelligence_Status_Other_Phone__c != null && lstModigie[0].modigie__Phone_Intelligence_Status_Other_Phone__c != 'Unavailable'){
                    obj = new Map<String,Object>();
                    obj.put('ValidatedPhoneNumber', 'Other Phone - ' + lstModigie[0].modigie__Formatted_Other_Phone_Number__c);
                    obj.put('AccuracyMatch',lstModigie[0].modigie__Accuracy_Match_Other_Phone__c);
                    obj.put('NumberType', lstModigie[0].modigie__Phone_Type_Other_Phone__c);
                    //obj.put('OverallBestTimeToCall', lstModigie[0].modigie__Verified_Phone_Get_Phone_Insights__c);
                    if(lstModigie[0].modigie__Line_Activity_Other_Phone__c != null &&!lstModigie[0]?.modigie__Line_Activity_Other_Phone__c?.containsIgnoreCase('Inactive') == true){
                        obj.put('LineActivity', lstModigie[0].modigie__Line_Activity_Other_Phone__c);
                    }
                    obj.put('Status', lstModigie[0].modigie__Phone_Intelligence_Status_Other_Phone__c);
                    if(lstModigie[0].modigie__Validation_Date_Other_Phone__c != null){
                        obj.put('ValidationDate', lstModigie[0].modigie__Validation_Date_Other_Phone__c.Date());
                    }
                    if(lstModigie[0].modigie__Day_of_Week_Detail_Other_Phone__c != null && lstModigie[0].modigie__Day_of_Week_Detail_Other_Phone__c != ''){
                    	obj.put('DayOfWeekDetail', getTimeWindow(lstModigie[0].modigie__Day_of_Week_Detail_Other_Phone__c));    
                    }
                    
                    if(lstModigie[0].modigie__Carrier_Name_Other_Phone__c != null){
                        obj.put('CarrierName', lstModigie[0].modigie__Carrier_Name_Other_Phone__c);
                    }
                    result.add(obj);
                } 
                if(lstModigie[0].modigie__Status__c != 'Not started' && lstModigie[0].modigie__Status__c != null){
                    obj = new Map<String,Object>();
                    obj.put('ValidatedPhoneNumber', 'Modigie Validated Mobile Number - ' + lstModigie[0].modigie__Mobile__c);
                    if(lstModigie[0].modigie__Accuracy_Match_Modigie_Validated_Number__c != null){
                        obj.put('AccuracyMatch',lstModigie[0].modigie__Accuracy_Match_Modigie_Validated_Number__c);
                    }
                    if(lstModigie[0].modigie__Phone_Type_Modigie_Validated_Number__c != null){
                        obj.put('NumberType', lstModigie[0].modigie__Phone_Type_Modigie_Validated_Number__c);
                    }
                    if(lstModigie[0].modigie__Line_Activity_Modigie_Validated_Number__c != null && !lstModigie[0]?.modigie__Line_Activity_Modigie_Validated_Number__c.containsIgnoreCase('Inactive') == true){
                        obj.put('LineActivity', lstModigie[0].modigie__Line_Activity_Modigie_Validated_Number__c);
                    }
                    if(lstModigie[0].modigie__Day_of_Week_Detail_Modigie_Val_Number__c != null && lstModigie[0].modigie__Day_of_Week_Detail_Modigie_Val_Number__c != ''){
                        obj.put('DayOfWeekDetail', getTimeWindow(lstModigie[0].modigie__Day_of_Week_Detail_Modigie_Val_Number__c));
                    }

                    result.add(obj);
                }
                if(lstModigie[0].modigie__Mobile_2__c != null){
                    obj = new Map<String,Object>();
                    obj.put('ValidatedPhoneNumber', 'Modigie Alternate Mobile Number 1 - ' +  lstModigie[0].modigie__Mobile_2__c);
                    obj.put('ValidatedPhoneNumberValue', lstModigie[0].modigie__Mobile_2__c);
                    if(lstModigie[0].modigie__Accuracy_Match_Alternate_Number1__c != null){
                        obj.put('AccuracyMatch',lstModigie[0].modigie__Accuracy_Match_Alternate_Number1__c);
                    }
                    if(lstModigie[0].modigie__Phone_Type_Alternate_Number1__c != null){
                        obj.put('NumberType', lstModigie[0].modigie__Phone_Type_Alternate_Number1__c);
                    } 
                    //obj.put('OverallBestTimeToCall', lstModigie[0].modigie__Verified_Phone_Get_Phone_Insights__c);
                    if(lstModigie[0].modigie__Line_Activity_Alternate1__c != null && !lstModigie[0]?.modigie__Line_Activity_Alternate1__c?.containsIgnoreCase('Inactive') == true){
                        
                        obj.put('LineActivity', lstModigie[0].modigie__Line_Activity_Alternate1__c);
                    }
                    
                    if(lstModigie[0].modigie__Day_of_Week_Detail_Alternate_Number1__c != null && lstModigie[0].modigie__Day_of_Week_Detail_Alternate_Number1__c != ''){
                        obj.put('DayOfWeekDetail', getTimeWindow(lstModigie[0].modigie__Day_of_Week_Detail_Alternate_Number1__c));
                    }
                    result.add(obj);
                }
                if(lstModigie[0].modigie__Mobile_3__c != null){
                    obj = new Map<String,Object>();
                    obj.put('ValidatedPhoneNumber', 'Modigie Alternate Mobile Number 2 - ' +  lstModigie[0].modigie__Mobile_3__c);
                    obj.put('ValidatedPhoneNumberValue',lstModigie[0].modigie__Mobile_3__c);
                    if(lstModigie[0].modigie__Accuracy_Match_Alternate_Number2__c != null){
                        obj.put('AccuracyMatch',lstModigie[0].modigie__Accuracy_Match_Alternate_Number2__c);
                    }
                    if(lstModigie[0].modigie__Phone_Type_Alternate_Number2__c != null){
                        obj.put('NumberType', lstModigie[0].modigie__Phone_Type_Alternate_Number2__c);
                    }
                    //obj.put('OverallBestTimeToCall', lstModigie[0].modigie__Verified_Phone_Get_Phone_Insights__c);
                    if(lstModigie[0].modigie__Line_Activity_Alternate2__c != null && !lstModigie[0]?.modigie__Line_Activity_Alternate2__c?.containsIgnoreCase('Inactive') == true){
                        obj.put('LineActivity', lstModigie[0].modigie__Line_Activity_Alternate2__c);
                    }
                    
                    if(lstModigie[0].modigie__Day_of_Week_Detail_Alternate_Number2__c != null && lstModigie[0].modigie__Day_of_Week_Detail_Alternate_Number2__c != ''){
                        obj.put('DayOfWeekDetail', getTimeWindow(lstModigie[0].modigie__Day_of_Week_Detail_Alternate_Number2__c));
                    }

                    result.add(obj);
                }
                //return JSON.serialize(result);

                system.debug('result is ::: ' +result);
                return result;
            }
                
            else{
                List<PermissionSetAssignment> lstUser = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId =:UserInfo.getUserId() AND PermissionSet.NamespacePrefix = 'modigie' AND PermissionSet.Name in ('Modigie_Admin', 'Modigie_User', 'Modigie_Automation_User')];
                if(lstUser.size() == 0){
                    return 'Non Modigie User and No Record Available';
                }else{
                    return 'No Record Available';
                }
            }
        
            
        }
    	
        catch(System.QueryException e){
            throw new ModigieLightningTabControllerException('You do not have permission to query lead, contact or modigie fields.');
        }
        
        catch(Exception e){
            throw new ModigieLightningTabControllerException(e.getMessage());
        }
    }

    public static String getTimeWindow(String callWindow){
        List<String> lstStr = callWindow.split(';');
        String result = '';
        for(String str : lstStr){
            Integer hour;
            if(str?.equalsIgnoreCase('1') == true){
                hour = 0;
            }
            else{
                hour = Integer.valueOf(str) * 2 -2;
            } 
            Datetime gmt = Datetime.newInstanceGmt(0, 0, 0, hour, 0, 0);
            hour = Integer.valueOf(gmt.hour());

            if(hour == 0){
                str = '1';
            }
            else{
                str = String.valueOf((hour / 2) + 1);
            }
            result += str + ';';
        }
        return result;
    }
    
	@AuraEnabled
   public static string getTimeZone()
   {
       //TimeZone tz = UserInfo.getTimeZone().getDisplayName();
       String timeZone = String.valueOf(UserInfo.getTimeZone().getDisplayName());
       return timeZone;
   }

   @AuraEnabled
   public static String updateBestTimeToCall(Id recId, List<String> arr){
       try {
           if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c')
            && FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c')
            && FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_Monday__c')
            && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_Monday__c')
            && FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_Tuesday__c')
            && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_Tuesday__c')
            && FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_Wednesday__c')
            && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_Wednesday__c')
            && FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_Thursday__c')
            && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_Thursday__c')
            && FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_Friday__c')
            && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_Friday__c')
            && FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Validation_Key__c')
            && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Validation_Key__c')
           ){
                List <modigie__Modigie__c> lstModigie = [SELECT Id, modigie__Best_Time_Monday__c, modigie__Best_Time_Tuesday__c, modigie__Best_Time_Wednesday__c, modigie__Best_Time_Thursday__c, modigie__Best_Time_Friday__c, modigie__Validation_Key__c FROM modigie__Modigie__c WHERE modigie__Parent_Id__c  = :recid LIMIT 1];
                System.debug(lstModigie[0].modigie__Validation_Key__c);
                lstModigie[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                System.debug(recId);
                for(Integer i = 0; i < arr.size(); i++){
                    switch on i {
                        when 0 {		// when block 2
                            lstModigie[0].modigie__Best_Time_Monday__c = arr[i];
                            System.debug(arr[i]);
                        }
                        when 1 {		// when block 1
                            lstModigie[0].modigie__Best_Time_Tuesday__c = arr[i];
                            System.debug(arr[i]);
                        }	
                        when 2 {		// when block 2
                            lstModigie[0].modigie__Best_Time_Wednesday__c = arr[i];
                            System.debug(arr[i]);
                        }
                        when 3 {		// when block 3
                            lstModigie[0].modigie__Best_Time_Thursday__c = arr[i];
                            System.debug(arr[i]);
                        }
                        when 4 {		// when block 1
                            lstModigie[0].modigie__Best_Time_Friday__c = arr[i];
                            System.debug(arr[i]);
                        }	
                        
                        
                        when else {		  // default block, optional
                            System.debug('arr[i]');
                        }
                    }
                }
                System.debug(lstModigie);
                Database.SaveResult[] updateresult = Database.update(lstmodigie, false);
                for(Database.SaveResult r: updateresult){
                    if(!r.isSuccess()){
                        System.debug(r.getErrors());
                    }
                }
                System.debug(lstModigie);
           }
           return 'No Best Time';
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }

   @AuraEnabled
   public static Map<String, Object> getOrgStopUntilTimeAndReason(){
       try {
        modigie__TOM__c tomDetails = modigie__TOM__c.getInstance();
        Boolean isStopCallouts = false;
        String reasonString, selectedCreditAccountInactiveReason, defaultInactiveReason, stopUntilTime, stopReason;
        Boolean isDefaultInactive = false;
        Boolean isSelectedCreditAccountInactive = false, isCreditAccountStopped = false;
        if(tomDetails.modigie__Org_Stop_Until_Time__c != null){
            if(tomDetails.modigie__Org_Stop_Until_Time__c > DateTime.now()){
                isStopCallouts = true;
            }
            reasonString = 'Modigie Callouts are disabled until '+ tomDetails.modigie__Org_Stop_Until_Time__c.format('MM/dd/yyyy hh:mm:ss a',UserInfo.getTimeZone().getID()) + '. ';
            if(tomDetails.modigie__Org_Stop_Reason__c != null){
                reasonString += tomDetails.modigie__Org_Stop_Reason__c;
            }
        }
        
        String userId = UserInfo.getUserId();
        List<modigie__creditAccountUsers__c> cau = [SELECT Id, Name, modigie__Credit_Id__c FROM modigie__creditAccountUsers__c WHERE modigie__User_Id__c =: userId AND modigie__isPerformance__c = false LIMIT 1];
        if(!cau.isEmpty()){
           System.debug(cau[0].modigie__Credit_Id__c);
            List<modigie__creditAccountDetails__c> cad = [SELECT Id, Name, modigie__Reason__c, modigie__Status__c, modigie__StopUntilTime__c FROM modigie__creditAccountDetails__c WHERE modigie__Credit_Id__c =: cau[0].modigie__Credit_Id__c LIMIT 1];
            System.debug(cad);
            if(!cad.isEmpty()){
                if(cad[0].modigie__Status__c == 'inactive'){
                    isSelectedCreditAccountInactive = true;
                }
                if(cad[0].modigie__StopUntilTime__c == null){
                    isCreditAccountStopped = false;
                }
                else if(cad[0].modigie__StopUntilTime__c > DateTime.now()){
                    isCreditAccountStopped = true;
                    stopUntilTime = String.valueOf(cad[0].modigie__StopUntilTime__c);
                    stopReason = 'Credit Account is disabled until '+ cad[0].modigie__StopUntilTime__c.format('MM/dd/yyyy hh:mm:ss a',UserInfo.getTimeZone().getID()) + ', ' + cad[0].modigie__Reason__c;
                }
                
                
            }
        }
        else{
            List<modigie__creditAccountDetails__c> defaultCreditAccount = [SELECT Id, Name, modigie__Reason__c, modigie__Status__c, modigie__StopUntilTime__c FROM modigie__creditAccountDetails__c WHERE modigie__Default__c = true LIMIT 1];
            if(!defaultCreditAccount.isEmpty()){
                if(defaultCreditAccount[0].modigie__Status__c == 'inactive'){
                    isSelectedCreditAccountInactive = true;
                }
                if(defaultCreditAccount[0].modigie__StopUntilTime__c == null){
                    isCreditAccountStopped = false;
                }
                else if(defaultCreditAccount[0].modigie__StopUntilTime__c > DateTime.now()){
                    isCreditAccountStopped = true;
                    stopUntilTime = String.valueOf(defaultCreditAccount[0].modigie__StopUntilTime__c);
                    stopReason = 'Credit Account is disabled until '+ defaultCreditAccount[0].modigie__StopUntilTime__c.format('MM/dd/yyyy hh:mm:ss a',UserInfo.getTimeZone().getID()) + ', ' + defaultCreditAccount[0].modigie__Reason__c;
                }
                

                // isDefaultInactive = true;
                // defaultInactiveReason = defaultCreditAccount[0].modigie__Reason__c;
            }
        }
        
        
        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('isStopCallouts', isStopCallouts);
        returnMap.put('reasonString', reasonString);
        // returnMap.put('isDefaultInactive', isDefaultInactive);
        // returnMap.put('defaultInactiveReason', defaultInactiveReason);
        returnMap.put('isSelectedCreditAccountInactive', isSelectedCreditAccountInactive);
        returnMap.put('selectedCreditAccountInactiveReason', selectedCreditAccountInactiveReason);
        returnMap.put('stopUntilTime', stopUntilTime);
        returnMap.put('stopReason', stopReason);
        returnMap.put('isCreditAccountStopped', isCreditAccountStopped);

        System.debug(returnMap);
        return returnMap;
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }

    private class ModigieLightningTabControllerException extends Exception{}
}