global without sharing class GetPhoneIntelligenceBatchClass implements 
Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
    global Integer recordsProcessed = 0;
    List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();
    global modigie__Modigie_Credentials__c tokenList = new modigie__Modigie_Credentials__c();
    Set<String> notificationReceiver = new Set<String>();
    Set<String> campaignForNotification = new Set<String>();
    Set<String> campaignOutForNotification = new Set<String>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {  
        modigieCredential = ModigieApiUtils.getServiceAccountDetails();
        //return Database.getQueryLocator('SELECT Id, modigie__Phone_Intelligence_Status__c , modigie__Get_Phone_Intelligence_Job_Id__c ,  modigie__Get_Phone_Intelligence_Job_Status__c ,modigie__Validation_Key__c,modigie__Validation_Date_Mobile__c ,modigie__Phone_Name_Match__c ,modigie__Line_Activity__c ,modigie__Phone_Type__c ,modigie__Best_Time_to_Call__c ,modigie__Day_of_Week_Detail__c ,modigie__Contact__r.Id,modigie__Lead__r.Id FROM modigie__Modigie__c WHERE modigie__Get_Phone_Intelligence_Job_Status__c IN (\'Accepted\',\'Started\') WITH SECURITY_ENFORCED');
        return Database.getQueryLocator('SELECT Id, modigie__Parent_Id__c, modigie__Campaign_Id_GetPhoneInsight__c, modigie__Get_Phone_Insight_Campaign_User__c, modigie__Validation_Date_Alternate_Number2__c, modigie__Validation_Date_Alternate_Number1__c, modigie__Validation_Date_Modigie_Val_Phone_Number__c, modigie__Validation_Date_Other_Phone__c, modigie__Validation_Date_Phone__c, modigie__Locale_Overall_Best_Time_to_Call_Mobile__c, modigie__Locale_Overall_Best_Time_to_Call_Phone__c, modigie__Locale_Overall_Best_Time_to_Call_O__c, modigie__Phone_Insights_User_Locale_Mobile__c, modigie__Phone_Insights_User_Locale_Other_Phone__c, modigie__Phone_Insights_User_Locale_Phone__c, modigie__Validation_Date_Mobile__c, modigie__Verified_Phone_Get_Phone_Insights_OPhone__c, modigie__Verified_Phone_Get_Phone_Insights_Alt2__c, modigie__Verified_Phone_Get_Phone_Insights_Alt1__c, modigie__Verified_Phone_Get_Phone_Insights_ValNum__c, modigie__Verified_Phone_Get_Phone_Insights_Phone__c, modigie__Verified_Phone_Get_Phone_Insights__c, modigie__Phone_Intelligence_Status_Other_Phone__c, modigie__Phone_Intelligence_Status_Alt_Number2__c, modigie__Phone_Intelligence_Status_Alt_Number1__c, modigie__Phone_Intelligence_Status_Modigie_Number__c, modigie__Phone_Intelligence_Status_Phone__c, modigie__Phone_Intelligence_Status__c, modigie__Best_Time_to_Call_Phone_Other_Phone__c, modigie__Best_Time_to_Call_Alternate_Number2__c, modigie__Best_Time_to_Call_Alternate_Number1__c, modigie__Best_Time_to_Call_Validated_Number__c, modigie__Best_Time_to_Call_Phone__c, modigie__Best_Time_to_Call__c, modigie__Phone_Type_Other_Phone__c, modigie__Phone_Type_Alternate_Number2__c, modigie__Phone_Type_Alternate_Number1__c, modigie__Phone_Type_Modigie_Validated_Number__c, modigie__Phone_Type_Phone__c, modigie__Phone_Type__c, modigie__Line_Activity_Other_Phone__c, modigie__Line_Activity_Alternate2__c, modigie__Line_Activity_Alternate1__c, modigie__Line_Activity_Modigie_Validated_Number__c, modigie__Line_Activity_Phone__c, modigie__Line_Activity__c, modigie__Get_Phone_Intelligence_Job_Status_OPhone__c, modigie__Get_Phone_Intelligence_Job_Status_Alt2__c, modigie__Get_Phone_Intelligence_Job_Status_Alt1__c, modigie__Get_Phone_Intelligence_Job_Status_ValNum__c, modigie__Get_Phone_Intelligence_Job_Status_Phone__c, modigie__Get_Phone_Intelligence_Job_Status__c, modigie__Get_Phone_Intelligence_Job_Id_Alternate2__c, modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c, modigie__Get_Phone_Intelligence_Job_Id_Alternate1__c, modigie__Get_Phone_Intelligence_Job_Id_Val_Number__c, modigie__Get_Phone_Intelligence_Job_Id_Phone__c, modigie__Get_Phone_Intelligence_Job_Id__c, modigie__Day_of_Week_Detail_Other_Phone__c, modigie__Day_of_Week_Detail_Alternate_Number2__c, modigie__Day_of_Week_Detail_Alternate_Number1__c, modigie__Day_of_Week_Detail_Modigie_Val_Number__c, modigie__Day_of_Week_Detail_Phone__c, modigie__Day_of_Week_Detail__c, modigie__Accuracy_Match_Other_Phone__c, modigie__Accuracy_Match_Alternate_Number2__c, modigie__Accuracy_Match_Alternate_Number1__c, modigie__Accuracy_Match_Modigie_Validated_Number__c, modigie__Accuracy_Match_Phone__c, modigie__Phone_Name_Match__c ,modigie__Contact__r.Id,modigie__Lead__r.Id FROM modigie__Modigie__c WHERE modigie__Phone_Intelligence_Status__c = \'In process\'  OR modigie__Phone_Intelligence_Status_Phone__c = \'In process\'  OR modigie__Phone_Intelligence_Status_Other_Phone__c = \'In process\' WITH SECURITY_ENFORCED');
        
        
    }
    global void execute(Database.BatchableContext bc, List<modigie__Modigie__c> scope){
        // process each batch of records
        try{
            System.debug('19 --> scope ' + scope);
            System.debug('20 --> scope.size() ' + scope.size());
            Organization org = [SELECT Id, TimeZoneSidKey FROM Organization WITH SECURITY_ENFORCED LIMIT 1];
            Map<String, String> bestTimeAllMap = new Map<String, String>();
            bestTimeAllMap.put('1','12am - 2am');
            bestTimeAllMap.put('2','2am - 4am');
            bestTimeAllMap.put('3','4am - 6am');
            bestTimeAllMap.put('4','6am - 8am');
            bestTimeAllMap.put('5','8am - 10am');
            bestTimeAllMap.put('6','10am - 12pm');
            bestTimeAllMap.put('7','12pm - 2pm');
            bestTimeAllMap.put('8','2pm - 4pm');
            bestTimeAllMap.put('9','4pm - 6pm');
            bestTimeAllMap.put('10','6pm - 8pm');
            bestTimeAllMap.put('11','8pm - 10pm');
            bestTimeAllMap.put('12','10pm - 12am');
            
            Set <String> setJobId = new Set<String>();
            
            for(modigie__Modigie__c modi : scope){
                if(modi.modigie__Get_Phone_Intelligence_Job_Id__c != null) 
                    setJobId.add(modi.modigie__Get_Phone_Intelligence_Job_Id__c); 
                
                if(modi.modigie__Get_Phone_Intelligence_Job_Id_Phone__c != null) 
                    setJobId.add(modi.modigie__Get_Phone_Intelligence_Job_Id_Phone__c); 
                
                if(modi.modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c != null) 
                    setJobId.add(modi.modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c); 
            }
            
            Map<String,List<Object>> data = new Map<String,List<Object>>();
            
            List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'PhoneIntelligence Job Read' LIMIT 1];
            String targetAudience, endpoint, contentType;
            if(!calloutInfo.isEmpty()){
                endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
                targetAudience = calloutInfo[0].modigie__targetAud__c;
                contentType = calloutInfo[0].modigie__Content_Type__c;
            }

            String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Email__c,targetAudience,modigieCredential[0].modigie__Private_Key__c);
            
            
            for(String jobId : setJobId){
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setMethod('GET');
                //String accessToken = 'Bearer ' + jwtapex.get_access_token(tokenList.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-kyaxv4ttua-uc.a.run.app',tokenList.modigie__Private_Key__c);
                request.setHeader('Content-Type', contentType); 
                request.setHeader('Authorization', accessToken);
                
                request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c); 
                
                request.setEndpoint(endpoint + jobId); //Production Environment Endpoints
                //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/phoneIntelJobs/' + jobId + '?key=' + tokenList.modigie__API_Key__c); //Staging Environment Endpoints
                request.setTimeout(120000);
                HttpResponse response = http.send(request);
                System.debug('64 -->> ' + response.getStatusCode());
                if(response.getStatusCode() == 200){
                    Map<String,Object> mMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                    List<Object> contacts = (List<Object>) mMap.get('results');
                    for(Object contact : contacts){
                        Map<String,Object> mapCon = (Map<String,Object>)contact;
                        mapCon.put('id', mMap.get('id'));
                        List<Object> customParameters = (List<Object>) mapCon.get('customParameters');
                        if(customParameters.size() > 0){
                            for(Object obj : customParameters){
                                Map<String,Object> customParaSin = (Map<String,Object>) obj;
                                
                                
                                if(customParaSin?.get('name')?.toString()?.equalsIgnoreCase('recordIdAndOrgId') == true){
                                    if(data.containsKey(customParaSin.get('value')+'')){
                                        data.get(customParaSin.get('value')+'').add(mapCon);
                                    }
                                    else {
                                        data.put(customParaSin.get('value')+'',new List<Object>{mapCon});
                                    }
                                    
                                    
                                }
                                
                            }
                            
                        }
                    }
                    
                }else if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
                    EmailServiceClass.sendResponseError('GetPhoneIntelligenceBatchClass', response.getStatusCode(), response.getBody());
                }
                
                
            }
            
            
            
            List<modigie__Modigie_Tab_Refresh__e> lstObjEvent = new List<modigie__Modigie_Tab_Refresh__e>();
            
            for(modigie__Modigie__c modi : scope){
                
                
                List<Object> lstObj = new List<Object>();
                
                // if(modi.modigie__Contact__c != null){
                //     lstObj =  (List<Object>)data.get(modi.Contact__c + UserInfo.getOrganizationId());
                // }
                // else if(modi.modigie__Lead__c != null){
                //     lstObj =  (List<Object>)data.get(modi.Lead__c + UserInfo.getOrganizationId());
                // }

                if(modi.modigie__Parent_Id__c != null){
                    lstObj =  (List<Object>)data.get(modi.modigie__Parent_Id__c + UserInfo.getOrganizationId());
                }
                System.debug('121 lstObj --> ' + lstObj);
                if(lstObj != null){
                    for(Object obj : lstObj){
                        Map<String,Object> temp = (Map<String,Object>)obj;
                        if(temp != null){
                            if(temp?.get('status')?.toString()?.equalsIgnoreCase('done') == true){
                                lstObjEvent.add(new modigie__Modigie_Tab_Refresh__e(modigie__LeadOrContactRecordId__c = modi.modigie__Parent_Id__c));
                                System.debug('128 temp.get(\'verifiedPhone\') --> ' + temp.get('verifiedPhones'));
                                if(temp.get('verifiedPhones') != null){
                                    
                                    List<Object> verifiedPhones = (List<Object>)temp.get('verifiedPhones');
                                    System.debug('131 --> verifiedPhones --> ' + verifiedPhones);
                                    for(Object sinVerifiedPhone : verifiedPhones){
                                        Boolean isValidated = false;
                                        String phoneTypeValue = '',phoneInServiceValue='',accuracyMatchValue='',phoneNumberValue='',overallBestTimeValue='', overallBestTimeValueLocale='',dayOfWeekDetailValue='',statusValue='',carrierNameValue='';
                                        
                                        Map<String,Object> verifiedPhone =     (Map<String,Object>)sinVerifiedPhone;
                                        
                                        if(verifiedPhone.get('carrierName') != null){
                                            carrierNameValue = (String)verifiedPhone.get('carrierName');
                                            isValidated = true;
                                        }
                                        if(verifiedPhone.get('phoneInService') != null){
                                            Map<String,Object> phoneInService = (Map<String,Object>)verifiedPhone.get('phoneInService');
                                            if(phoneInService.get('code') != null && phoneInService.get('code') != ''){
                                                phoneInServiceValue = phoneInService.get('text').toString();
                                                //modi.modigie__Line_Activity__c = phoneInService.get('text').toString();
                                                isValidated = true;
                                            }
                                            
                                        }
                                        if(verifiedPhone.get('phoneType') != null){
                                            phoneTypeValue = String.valueOf(verifiedPhone.get('phoneType'));
                                            phoneTypeValue = phoneTypeValue.substring(0, 1).toUpperCase() + phoneTypeValue.substring(1, phoneTypeValue.length());
                                            isValidated=true;
                                        }
                                        if(verifiedPhone.get('phoneToNameLinkage') != null){
                                            
                                            Map<String,Object> phoneToNameLinkage = (Map<String,Object>)verifiedPhone.get('phoneToNameLinkage');
                                            if(phoneToNameLinkage.get('code') != null && phoneToNameLinkage.get('code') != ''){
                                                accuracyMatchValue = phoneToNameLinkage.get('text').toString();
                                                //modi.modigie__Phone_Name_Match__c = phoneToNameLinkage.get('text').toString();
                                                isValidated=true;
                                            }
                                            
                                        }
                                        if(verifiedPhone.get('phoneNumber') != null){
                                            
                                            Map<String,Object> phoneNumber = (Map<String,Object>)verifiedPhone.get('phoneNumber');
                                            if(phoneNumber.get('intlFormat') != null && phoneNumber.get('intlFormat') != ''){
                                                phoneNumberValue = phoneNumber.get('intlFormat').toString();
                                                //modi.modigie__Verified_Phone_Get_Phone_Insights__c = phoneNumber.get('intlNumber').toString();
                                                isValidated = true;
                                            }
                                            
                                        }
                                        if(verifiedPhone.get('callWindows') != null){
                                            
                                            List<Object> callWindows = (List<Object>)verifiedPhone.get('callWindows');
                                            
                                            
                                            if(!callWindows.isEmpty()){
                                                isValidated = true;
                                                Map<String,Object> sinCallWindow = (Map<String,Object>)callWindows[0];
                                                String strUser = '';
                                                String str = sinCallWindow.get('code').toString();
                                                String result = '';
                                                if(str?.equalsIgnoreCase('0') == true){
                                                    result = 'NA'; 
                                                }   
                                                
                                                else{
                                                    Integer hour;
                                                    Integer hourUser;
                                                    if(str?.equalsIgnoreCase('1') == true){
                                                        hour = 0;
                                                    }
                                                    else{
                                                        hour = Integer.valueOf(str) * 2 -2;
                                                    }
                                                    
                                                    Date myDate = date.newinstance(0, 0, 0);
                                                    Time myTime = Time.newInstance(hour, 0, 0, 0);
                                                    DateTime dtt = DateTime.newInstanceGmt(myDate, myTime);
                                                    
                                                    
                                                    
                                                    User usr = [SELECT TimeZoneSidKey FROM User WHERE Id = :UserInfo.getUserId() WITH SECURITY_ENFORCED LIMIT 1];
                                                    
                                                    
                                                    String strConvertedDateUser = dtt.format('HH',usr.TimeZoneSidKey);
                                                    
                                                    String strConvertedDate = dtt.format('HH', org.TimeZoneSidKey); 
                                                    
                                                    
                                                    
                                                    hour = Integer.valueOf(strConvertedDate);
                                                    hourUser = Integer.valueOf(strConvertedDateUser);
                                                    
                                                    
                                                    if(hour == 0){
                                                        str = '1';
                                                    }
                                                    
                                                    else{
                                                        str = String.valueOf((hour / 2) + 1);
                                                    }
                                                    
                                                    if(bestTimeAllMap.get(str) != null){
                                                        result = bestTimeAllMap.get(str);
                                                    }else{
                                                        result = 'NA';
                                                    }
                                                    
                                                    if(hourUser == 0){
                                                        strUser = '1';
                                                    }
                                                    else{
                                                        strUser = String.valueOf((hourUser / 2) + 1);
                                                    }
                                                    
                                                    if(bestTimeAllMap.get(strUser) != null){
                                                        overallBestTimeValueLocale = bestTimeAllMap.get(strUser);
                                                    }
                                                    else{
                                                        overallBestTimeValueLocale = 'NA';
                                                    }
                                                    
                                                    
                                                }   
                                                
                                                
                                                overallBestTimeValue = result;
                                                //modi.modigie__Best_Time_to_Call__c = result;
                                                //  callWindows.remove(0);
                                                dayOfWeekDetailValue = '';
                                                //modi.modigie__Day_of_Week_Detail__c = '';
                                                for(Object callWindow : callWindows){
                                                    sinCallWindow = (Map<String,Object>)callWindow;
                                                    dayOfWeekDetailValue += sinCallWindow.get('code').toString() + ';';
                                                    //modi.modigie__Day_of_Week_Detail__c += sinCallWindow.get('code').toString() + ';';
                                                }   
                                            }
                                        }
                                        if(isValidated){
                                            statusValue = 'Validated';
                                            //modi.modigie__Phone_Intelligence_Status__c = 'Validated';
                                        }
                                        
                                        else{
                                            statusValue = 'Not Available';
                                            //modi.modigie__Phone_Intelligence_Status__c = 'Not Available';
                                        }
                                        
                                        TimeZone tz = UserInfo.getTimeZone();
                                        String displayName = tz.getDisplayName();
                                        System.debug('276 --> modi.modigie__Verified_Phone_Get_Phone_Insights__c ' + modi.modigie__Verified_Phone_Get_Phone_Insights__c);
                                        if(modi.modigie__Verified_Phone_Get_Phone_Insights__c != null){
                                            System.debug('278 -->> ' +modi?.modigie__Verified_Phone_Get_Phone_Insights__c?.replaceAll('[^0-9]', '')?.equalsIgnoreCase(phoneNumberValue.replaceAll('[^0-9]', '')));
                                            if(modi?.modigie__Verified_Phone_Get_Phone_Insights__c?.replaceAll('[^0-9]', '')?.equalsIgnoreCase(phoneNumberValue.replaceAll('[^0-9]', '')) == true){
                                                modi.modigie__Line_Activity__c = phoneInServiceValue;
                                                modi.modigie__Phone_Type__c = phoneTypeValue;
                                                modi.modigie__Phone_Name_Match__c = accuracyMatchValue;
                                                modi.modigie__Best_Time_to_Call__c = overallBestTimeValue;
                                                modi.modigie__Day_of_Week_Detail__c = dayOfWeekDetailValue;
                                                modi.modigie__Phone_Intelligence_Status__c = statusValue;
                                                modi.modigie__Carrier_Name_Mobile__c = carrierNameValue;
                                                if(overallBestTimeValueLocale != ''){
                                                    modi.modigie__Locale_Overall_Best_Time_to_Call_Mobile__c = overallBestTimeValueLocale;
                                                    modi.modigie__Phone_Insights_User_Locale_Mobile__c = displayName;
                                                }
                                            }
                                        }
                                        
                                        
                                        if(modi.modigie__Verified_Phone_Get_Phone_Insights_Phone__c != null){
                                            if(modi?.modigie__Verified_Phone_Get_Phone_Insights_Phone__c?.replaceAll('[^0-9]', '')?.equalsIgnoreCase(phoneNumberValue.replaceAll('[^0-9]', '')) == true){
                                                modi.modigie__Line_Activity_Phone__c = phoneInServiceValue;
                                                modi.modigie__Phone_Type_Phone__c = phoneTypeValue;
                                                modi.modigie__Accuracy_Match_Phone__c = accuracyMatchValue;
                                                modi.modigie__Best_Time_to_Call_Phone__c = overallBestTimeValue;
                                                modi.modigie__Day_of_Week_Detail_Phone__c = dayOfWeekDetailValue;
                                                modi.modigie__Phone_Intelligence_Status_Phone__c = statusValue;
                                                modi.modigie__Carrier_Name_Phone__c = carrierNameValue;
                                                if(overallBestTimeValueLocale != ''){
                                                    modi.modigie__Locale_Overall_Best_Time_to_Call_Phone__c = overallBestTimeValueLocale;
                                                    modi.modigie__Phone_Insights_User_Locale_Phone__c = displayName;
                                                }
                                            }
                                        }
                                        
                                        if(modi.modigie__Verified_Phone_Get_Phone_Insights_OPhone__c != null){
                                            if(modi?.modigie__Verified_Phone_Get_Phone_Insights_OPhone__c?.replaceAll('[^0-9]', '')?.equalsIgnoreCase(phoneNumberValue.replaceAll('[^0-9]', '')) == true){
                                                modi.modigie__Line_Activity_Other_Phone__c = phoneInServiceValue;
                                                modi.modigie__Phone_Type_Other_Phone__c = phoneTypeValue;
                                                modi.modigie__Accuracy_Match_Other_Phone__c = accuracyMatchValue;
                                                modi.modigie__Best_Time_to_Call_Phone_Other_Phone__c = overallBestTimeValue;
                                                modi.modigie__Day_of_Week_Detail_Other_Phone__c = dayOfWeekDetailValue;
                                                modi.modigie__Phone_Intelligence_Status_Other_Phone__c = statusValue;
                                                modi.modigie__Carrier_Name_Other_Phone__c = carrierNameValue;
                                                if(overallBestTimeValueLocale != ''){
                                                    modi.modigie__Locale_Overall_Best_Time_to_Call_O__c = overallBestTimeValueLocale;
                                                    modi.modigie__Phone_Insights_User_Locale_Other_Phone__c = displayName;
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                                
                                else{
                                    List<Object> customParameters = (List<Object>)temp.get('customParameters');
                                    if(customParameters.size() > 0){
                                        String inputNumbers='';
                                        for(Object customParai : customParameters){
                                            Map<String,Object> customParaSin = (Map<String,Object>) customParai;
                                            if(customParaSin.get('name').toString()?.equalsIgnoreCase('lstNumbers') == true){
                                                inputNumbers = customParaSin.get('value').toString();
                                            }
                                        }
                                        if(inputNumbers.containsIgnoreCase('Mobile')){
                                            modi.modigie__Phone_Intelligence_Status__c = 'Not available'; 
                                        }
                                        if(inputNumbers.containsIgnoreCase('Phone')){
                                            modi.modigie__Phone_Intelligence_Status_Phone__c = 'Not available';    
                                        }
                                        if(inputNumbers.containsIgnoreCase('Other')){
                                            modi.modigie__Phone_Intelligence_Status_Other_Phone__c = 'Not available';    
                                        }
                                    }
                                }
                            }
                            
                            String status = temp.get('status').toString();
                            status = status.substring(0, 1).toUpperCase() + status.substring(1, status.length());
                            
                            String name = temp.get('name').toString();
                            if(temp.get('id') != null){
                                if(modi.modigie__Get_Phone_Intelligence_Job_Id__c?.equalsIgnoreCase(temp.get('id').toString()) == true){
                                    if(!modi.modigie__Get_Phone_Intelligence_Job_Status__c?.equalsIgnoreCase(status) == true){
                                        modi.modigie__Get_Phone_Intelligence_Job_Status__c = status;
                                        modi.modigie__Validation_Date_Mobile__c  = System.now();
                                        if(status?.equalsIgnoreCase('unavailable') == true){
                                            modi.modigie__Phone_Intelligence_Status__c = 'Unavailable';
                                        }
                                    }
                                    modi.modigie__Name_Get_Phone_Insights_Mobile__c = name;
                                }
                                if(modi.modigie__Get_Phone_Intelligence_Job_Id_Phone__c?.equalsIgnoreCase(temp.get('id').toString()) == true){
                                    if(!modi.modigie__Get_Phone_Intelligence_Job_Status_Phone__c?.equalsIgnoreCase(status) == true){
                                        modi.modigie__Get_Phone_Intelligence_Job_Status_Phone__c = status;
                                        modi.modigie__Validation_Date_Phone__c  = System.now();
                                        if(status?.equalsIgnoreCase('unavailable') == true){
                                            modi.modigie__Phone_Intelligence_Status_Phone__c = 'Unavailable';
                                        }
                                    }
                                    modi.modigie__Name_Get_Phone_Insights_Phone__c = name;
                                }
                                if(modi.modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c?.equalsIgnoreCase(temp.get('id').toString()) == true){
                                    if(!modi.modigie__Get_Phone_Intelligence_Job_Status_OPhone__c?.equalsIgnoreCase(status) == true){
                                        modi.modigie__Get_Phone_Intelligence_Job_Status_OPhone__c = status;
                                        modi.modigie__Validation_Date_Other_Phone__c  = System.now();
                                        if(status?.equalsIgnoreCase('unavailable') == true){
                                            modi.modigie__Phone_Intelligence_Status_Other_Phone__c = 'Unavailable';
                                        }
                                    }
                                    modi.modigie__Name_Get_Phone_Insights_Other_Phone__c = name;
                                }
                            }
                            //Fixing Repeating Jobs Here
                            
                            if(temp.get('status')?.toString()?.equalsIgnoreCase('done') == true){
                                if(modi.modigie__Phone_Intelligence_Status__c.equalsIgnoreCase('In Process') == true){
                                    modi.modigie__Phone_Intelligence_Status__c = 'Not available';
                                    // 
                                }
                                if(modi.modigie__Phone_Intelligence_Status_Phone__c.equalsIgnoreCase('In Process') == true){
                                    modi.modigie__Phone_Intelligence_Status_Phone__c = 'Not available';
                                    //   
                                }
                                if(modi.modigie__Phone_Intelligence_Status_Other_Phone__c.equalsIgnoreCase('In Process') == true){
                                    modi.modigie__Phone_Intelligence_Status_Other_Phone__c = 'Not available';
                                    //    
                                }
                            }
                            
                        }
                    }
                    
                } 
                if(modi.modigie__Campaign_Id_GetPhoneInsight__c != null){
                    if(campaignOutForNotification.contains(modi.modigie__Campaign_Id_GetPhoneInsight__c)){
                        
                    }
                    else{
                        if(modi?.modigie__Get_Phone_Intelligence_Job_Status__c?.equalsIgnoreCase('done') == true || modi?.modigie__Get_Phone_Intelligence_Job_Status_Phone__c?.equalsIgnoreCase('done') == true || modi?.modigie__Get_Phone_Intelligence_Job_Status_OPhone__c?.equalsIgnoreCase('done') == true){
                            //if(modi.modigie__Get_Phone_Intelligence_Job_Status__c == 'done'){
                            campaignForNotification.add(modi.modigie__Campaign_Id_GetPhoneInsight__c);
                            notificationReceiver.add(modi.modigie__Get_Phone_Insight_Campaign_User__c);
                        }
                        
                    }
                }
                modi.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            }
            
            
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c')&&
               FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Lead__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Lead__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Contact__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Contact__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Verified_Phone_Get_Phone_Insights__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Line_Activity__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Line_Activity__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Type__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Type__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Name_Match__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Name_Match__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_to_Call__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_to_Call__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Carrier_Name_Mobile__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Carrier_Name_Mobile__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Locale_Overall_Best_Time_to_Call_Mobile__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Locale_Overall_Best_Time_to_Call_Mobile__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Insights_User_Locale_Mobile__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Insights_User_Locale_Mobile__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Verified_Phone_Get_Phone_Insights_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Line_Activity_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Line_Activity_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Type_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Type_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Accuracy_Match_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Accuracy_Match_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_to_Call_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_to_Call_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Carrier_Name_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Carrier_Name_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Locale_Overall_Best_Time_to_Call_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Locale_Overall_Best_Time_to_Call_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Insights_User_Locale_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Insights_User_Locale_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Verified_Phone_Get_Phone_Insights_OPhone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Type_Other_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Type_Other_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Accuracy_Match_Other_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Accuracy_Match_Other_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Best_Time_to_Call_Phone_Other_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Best_Time_to_Call_Phone_Other_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Other_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Day_of_Week_Detail_Other_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status_Other_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status_Other_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Carrier_Name_Other_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Carrier_Name_Other_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Locale_Overall_Best_Time_to_Call_O__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Locale_Overall_Best_Time_to_Call_O__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Insights_User_Locale_Other_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Insights_User_Locale_Other_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Id__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Validation_Date_Mobile__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Validation_Date_Mobile__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Name_Get_Phone_Insights_Mobile__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Name_Get_Phone_Insights_Mobile__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Validation_Date_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Validation_Date_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Phone_Intelligence_Status_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Name_Get_Phone_Insights_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Name_Get_Phone_Insights_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Validation_Date_Other_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Validation_Date_Other_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Name_Get_Phone_Insights_Other_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Name_Get_Phone_Insights_Other_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Campaign_Id_GetPhoneInsight__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Campaign_Id_GetPhoneInsight__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Insight_Campaign_User__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Get_Phone_Insight_Campaign_User__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Line_Activity_Other_Phone__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Line_Activity_Other_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Id_Phone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c') && 
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c', 'modigie__Validation_Key__c') && 
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c', 'modigie__Validation_Key__c')){
                    System.debug('499 scope--> ' + scope[0].modigie__Phone_Intelligence_Status__c);
                    String jobType = 'Get Phone Insights';
                    String jobSource = 'Data Pickup';
                    if(!scope.isEmpty()){
                        //Database.update(scope,false);  
                        Database.SaveResult[] saveResults = database.update(scope, false);
                        ErrorLogClass.createErrorLog(scope, 'Id', saveResults, jobType, jobSource);  
                    }
                   if(!lstObjEvent.isEmpty()){
                       EventBus.publish(lstObjEvent);     
                   }
               }
            
            
            
        }
        catch(Exception e){
            //call here Error Email
            EmailServiceClass.sendErrorEmail('GetPhoneIntelligenceBatchClass Error', e);
            System.debug('GetPhoneIntelligenceBatchClass -->' + e.getLineNumber());
            /*List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [SELECT Id, modigie__Error_Message__c FROM modigie__Modigie_Batch_Class_Internal_Error_List__c];
            List<String> lstStrErr = new List<String>();
            for(modigie__Modigie_Batch_Class_Internal_Error_List__c batchClassError : lstBatchClassError){
                lstStrErr.add(batchClassError.modigie__Error_Message__c);
            }
            
            if(!lstStrErr.contains(e.getMessage())){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                
                List<User> lstUser = [SELECT Id, Email FROM User WHERE isActive = true AND Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Modigie_Admin') AND Profile.Name = 'System Administrator' WITH SECURITY_ENFORCED];
                
                List<String> toAddresses = new List<String>();
                
                for(User usrObj : lstUser){
                    toAddresses.add(usrObj.Email);
                }
                
                List<String> ccAddresses = new List<String>{'support@modigie.com','pratik@cyntexa.com','ashishsharma@cyntexa.com'};
                    
                    if(!toAddresses.isEmpty()){
                        mail.setToAddresses(toAddresses);
                        mail.setCcAddresses(ccAddresses);
                        mail.saveAsActivity= false;
                        mail.setSubject('Modigie : GetPhoneInsightsBatchClass Error');
                        String emailBody = 'Please check the error message - ' + e.getMessage();
                        emailBody += '\nLine Number : ' + e.getLineNumber();
                        emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
                        emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
                        mail.setPlainTextBody(emailBody);
                        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        insert new modigie__Modigie_Batch_Class_Internal_Error_List__c(Name =String.valueOf(lstBatchClassError.size()+1), modigie__Error_Message__c = e.getMessage());
                    }
            }*/
            
        }
    }   
    
    global void finish(Database.BatchableContext bc){
        //add here
        // call some utility to send email
        if(campaignForNotification.size() > 0){
            String notificationTitle = 'Get Phone Insights Service Result Campaign';
            String notificationBody = 'Modigie Data for Get Phone Insights Service has been returned.';
            NotificationServiceClass.sendNotification(notificationTitle, notificationBody, notificationReceiver, campaignForNotification);
        }
        
    }
    private class GetPhoneIntelligenceBatchClassException extends Exception{}
}