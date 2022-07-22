public with sharing class AuthorizationClass {
    public static Boolean flag = false;
    public static Map<String, modigie__creditAccountDetails__c> mMap = new Map<String, modigie__creditAccountDetails__c>();
     public static List<String> insertedCreditIds = new List<String>();
     public static List<modigie__creditAccountDetails__c> creditAccountDetailsToInsert = new List<modigie__creditAccountDetails__c>();
     public static Set<String> creditAccountsFromGCP = new Set<String>();
    @AuraEnabled
    public static List<Map<String, Object>> getCreditAccountDetails(){
        try {
            List<modigie__creditAccountDetails__c> accountDetails = [SELECT Id, Name, Credit_Id__c, Default__c, isPerformance__c, Status__c, Title__c, StopUntilTime__c, Balance__c, Currency_Code__c, Reason__c FROM modigie__creditAccountDetails__c ORDER BY Name ASC];
            List<Map<String, Object>> returnValue = new List<Map<String, Object>>();
            for(modigie__creditAccountDetails__c detail: accountDetails){
                Boolean showTooltip = false;
                if(detail.StopUntilTime__c > DateTime.now()){
                    System.debug('stopped.........');
                    showTooltip = true;
                }
                Map<String,Object> tempMap = new Map<String, Object>();
                tempMap.put('Id',detail.Id);
                tempMap.put('Name',detail.Name);
                tempMap.put('modigie__Credit_Id__c',getEncryptedId(detail.Credit_Id__c));
                tempMap.put('modigie__Default__c',detail.Default__c);
                tempMap.put('modigie__isPerformance__c',detail.isPerformance__c);
                tempMap.put('modigie__Title__c',detail.Title__c);
                tempMap.put('modigie__Status__c', detail.Status__c);
                tempMap.put('modigie__Balance__c',detail.Balance__c);
                tempMap.put('modigie__Currency_Code__c', detail.Currency_Code__c);
                tempMap.put('modigie__Reason__c', detail.Reason__c);
                tempMap.put('modigie__StopUntilTime__c', detail.StopUntilTime__c);
                tempMap.put('showTooltip', showTooltip);
                
                returnValue.add(tempMap);
            }
            System.debug(returnValue);
            return returnValue;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static String getEncryptedId(String original) {
        String secured;
        if(original != null){
            String regExp = '(?<=.{4}).*(?=.{4})';
            String replacement = 'X'.repeat(original.length()-8);
            secured = original.replaceFirst(regExp, replacement);
        }
        return secured;
    }
    @AuraEnabled
    public static List<User> GetUser(String searchTerm, String creditRecordId, List<String> selectedIds, Boolean isPerformance)
    {
        List<modigie__creditAccountUsers__c> assignedUsers = [SELECT Id, Name, modigie__Credit_RecordId__c, modigie__User_Id__c, modigie__User_Name__c FROM modigie__creditAccountUsers__c WHERE modigie__Credit_RecordId__c !=: creditRecordId AND modigie__isPerformance__c = :isPerformance];
        List<String> alreadySelectedUsers = new List<String>();
        for(modigie__creditAccountUsers__c user: assignedUsers){
            alreadySelectedUsers.add(user.modigie__User_Id__c);
        }
        List<String> modigiePermissionSets = new List<String>();
        if(isPerformance == true){
            modigiePermissionSets = new List<String>{'Modigie_Automation_User'};
                }
        else{
            modigiePermissionSets = new List<String>{'Modigie_Admin','Modigie_User','Modigie_Automation_User'};
                }
        List<sObject> result = new List<sObject>();
        String query = 'SELECT Name FROM ';// + 'Profile WHERE Name Like \'%' + searchTerm + '%\'';
        
        query += 'User WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name IN :modigiePermissionSets) AND  name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' AND Id NOT IN :selectedIds AND Id NOT IN :alreadySelectedUsers LIMIT 1000';
        result = Database.query(query);
        
        if(result.size() > 0){
            return result;
        }
        else{
            return null;
        }
    }
    
    @AuraEnabled
    public static void saveCheckboxChange(Id creditRecordId){
        try {
            List<modigie__creditAccountDetails__c> creditAccountDetail = [SELECT Name, Id, modigie__Default__c FROM modigie__creditAccountDetails__c];
            for(modigie__creditAccountDetails__c cad: creditAccountDetail){
                if(cad.Id == creditRecordId){
                    cad.modigie__Default__c = true;
                }
                else{
                    cad.modigie__Default__c = false;
                }
            }
            if(creditAccountDetail.size() > 0){
                update creditAccountDetail;
                List<modigie__creditAccountUsers__c> creditAccountUserList = [SELECT Id FROM modigie__creditAccountUsers__c WHERE modigie__Credit_RecordId__c = :creditRecordId];
                if(!creditAccountUserList.isEmpty()){
                    delete creditAccountUserList;
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void saveToggleChange(Id creditRecordId){
        try {
            List<modigie__creditAccountDetails__c> creditAccountDetail = [SELECT Name, Id, modigie__Status__c FROM modigie__creditAccountDetails__c];
            for(modigie__creditAccountDetails__c cad: creditAccountDetail){
                if(cad.Id == creditRecordId){
                    if(cad.modigie__Status__c == 'active'){
                        cad.modigie__Status__c = 'inactive';
                    }
                    else if(cad.modigie__Status__c == 'inactive'){
                        cad.modigie__Status__c = 'active';
                    }
                }
            }
            if(creditAccountDetail.size() > 0){
                update creditAccountDetail;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<modigie__creditAccountDetails__c> getCreditId(){
        List<modigie__creditAccountDetails__c> modigieCreditAccountList = [SELECT Id, modigie__Credit_Id__c , modigie__Title__c, modigie__isPerformance__c, modigie__Balance__c, modigie__Currency_Code__c, modigie__StopUntilTime__c, modigie__Reason__C FROM modigie__creditAccountDetails__c WHERE modigie__isPerformance__c = false AND isDeleted = false];
        return modigieCreditAccountList;
    }
    
    @AuraEnabled
    public static String saveAssignUserDetails(List<Object> details, List<String> defaultSelected, List<Object> recordsToDelete, Boolean isPerformance){
        try {
            
            List<modigie__creditAccountUsers__c> creditAccountUserDetails = new List<modigie__creditAccountUsers__c>();
            List<modigie__creditAccountDetails__c> creditAccountDetails = [SELECT Id, Name, modigie__Credit_Id__c FROM modigie__creditAccountDetails__c];
            List<String> listToDelete = new List<String>();
            List<modigie__creditAccountUsers__c> listToInsert = new List<modigie__creditAccountUsers__c>();
            String creditId;
            if(!details.isEmpty()){
                for (Object detail : details) {
                    Map<Object,Object> recordDetail = (Map<Object,Object>) detail;
                    
                    for(modigie__creditAccountDetails__c cad: creditAccountDetails){
                        if(cad.Id == recordDetail.get('recordId').toString()){
                            creditId = cad.modigie__Credit_Id__c;
                        }
                    }
                    if(!defaultSelected.contains(recordDetail.get('userId').toString())){
                        String uniqueString = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
                        
                        modigie__creditAccountUsers__c cad = new modigie__creditAccountUsers__c(Name = uniqueString, modigie__Credit_RecordId__c = recordDetail.get('recordId').toString(), modigie__User_Id__c = recordDetail.get('userId').toString(), modigie__CreditId_Name__c = recordDetail.get('creditTitle').toString(), modigie__User_Name__c = recordDetail.get('userName').toString(), modigie__isPerformance__c = isPerformance, modigie__Credit_Id__c = creditId);
                        listToInsert.add(cad);
                    }
                }
            }
            
            System.debug('record to be inserted'+ listToInsert);
            if(!listToInsert.isEmpty()){
                insert listToInsert;
            }
            for(Object del: recordsToDelete){
                Map<Object,Object> d = (Map<Object,Object>) del;
                listToDelete.add(d.get('value').toString());
            }
            List<modigie__creditAccountUsers__c> recordsToBeDeleted = [SELECT Id, Name FROM modigie__creditAccountUsers__c WHERE modigie__User_Id__c IN :listToDelete AND modigie__isPerformance__c =: isPerformance];
            System.debug('listToDelete'+recordsToBeDeleted);
            if(!recordsToBeDeleted.isEmpty()){
                delete recordsToBeDeleted;
            }
            if(recordsToBeDeleted.isEmpty() && details.isEmpty()){
                recordsToBeDeleted = [SELECT Id, Name FROM modigie__creditAccountUsers__c WHERE modigie__User_Id__c IN :defaultSelected AND modigie__isPerformance__c =: isPerformance];
                delete recordsToBeDeleted;
            }
            return 'hi';  
        } catch (Exception e) {
            system.debug(e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<modigie__creditAccountUsers__c> getAssignedUsers(){
        try {
            List<modigie__creditAccountUsers__c> assignedUserDetails = [SELECT Id, Name, modigie__Credit_RecordId__c, modigie__User_Id__c, modigie__isPerformance__c, modigie__User_Name__c, modigie__CreditId_Name__c FROM modigie__creditAccountUsers__c WHERE modigie__isPerformance__c = false];
            return assignedUserDetails;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static String getAssignee(String recordId){
        List<id> UList = new List<id>();
        
        system.debug('hello'+ recordId);
        List<modigie__creditAccountUsers__c	> getAssignee  = [SELECT modigie__Credit_RecordId__c , 	modigie__User_Id__c FROM modigie__creditAccountUsers__c	WHERE modigie__Credit_RecordId__c = :recordId ];
        system.debug('assignee list '+ getAssignee );
        for(modigie__creditAccountUsers__c mca : getAssignee){
            UList.add(mca.modigie__User_Id__c);
        }
        system.debug('list...' + UList);
        List<PermissionSetAssignment> userInfo = [SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.ProfileId, PermissionSet.Profile.Name, AssigneeId, Assignee.Name , Assignee.isActive, Assignee.Username FROM PermissionSetAssignment WHERE AssigneeId IN :UList];      
        system.debug('user name '+ userInfo);  
        
        Map<string , Object> userDetailsWithPermissionSets  = new Map<string , Object>();
        List<String> PermissionSetsName  = new List<String>();
        for(PermissionSetAssignment psa : userInfo){
            if(!userDetailsWithPermissionSets.keySet().contains(psa.Assignee.Username)){
                PermissionSetsName.clear();
            }
            
            if(psa.PermissionSet.Name == 'Modigie_Admin'){
                PermissionSetsName.add('MA');
            }
            else if(psa.PermissionSet.Name == 'Modigie_User'){
                PermissionSetsName.add('MU');
            }
            else if(psa.PermissionSet.Name == 'Modigie_Automation_User'){
                PermissionSetsName.add('MAU');
            }
            
            
            string Obj =  '{"userid" :"' + psa.AssigneeId + '","isActive" :"' + psa.Assignee.isActive + '", "PermissionSetName" :"'+ PermissionSetsName +'", "Username": "'+psa.Assignee.Name+'"}';
            userDetailsWithPermissionSets.put( psa.Assignee.Username,Obj);
            
        }
        System.debug('map..... '+userDetailsWithPermissionSets);
        return JSON.serialize(userDetailsWithPermissionSets);
    }
    @AuraEnabled
    public static string createNewCreditId(string creditTitle){

        system.debug('new credit id: '+ creditTitle);
        String result;
        String developerName = 'Create_Credit_Account';
            List<modigie__Modigie_Service_Account__mdt> serviceAccDetail = ModigieApiUtils.getServiceAccountDetails();
            List<modigie__Modigie_Callout_Info__mdt> calloutInfo = ModigieApiUtils.getCalloutInfoDetails(developerName);
            if(!serviceAccDetail.isEmpty() && !calloutInfo.isEmpty()){
                String serviceAccCredential = serviceAccDetail[0].modigie__Email__c;
                String targetAud = calloutInfo[0].modigie__targetAud__c;
                String privateKey = serviceAccDetail[0].modigie__Private_Key__c;
                String endpointUrl = calloutInfo[0].modigie__Endpoint_Url__c;
                String customerId = serviceAccDetail[0].modigie__Customer_ID__c;
                String apiKey = serviceAccDetail[0].modigie__API_Key__c;
                endpointUrl = endpointUrl.replace('{customerId}',customerId);
                String accessToken = jwtapex.get_access_token(serviceAccCredential,targetAud,privateKey);
                String reqbody='{"title":"'+creditTitle+'"}';
            
                HTTPResponse resp = ModigieApiUtils.executeAPI(accessToken, 'POST', apiKey, endpointUrl,reqbody);
                if(resp.getStatus()=='Created'){
                ModigieJsonWrapper.itemsWrapper responce=ModigieJsonUtils.createCreditAccount(resp.getBody());
                String uniqueStringforName = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
        
                modigie__creditAccountDetails__c creditaccdetail=new modigie__creditAccountDetails__c();
                    creditaccdetail.Name=uniqueStringforName;
                creditaccdetail.modigie__Balance__c=decimal.valueOf(responce.balance.amount);
                creditaccdetail.modigie__Credit_Id__c=responce.id;
                creditaccdetail.modigie__Currency_Code__c=responce.currency_x.code;
                creditaccdetail.modigie__Status__c=responce.status;
                creditaccdetail.modigie__Title__c=responce.title;
                if(responce.quota.stopUntilTime!=null){
                    Datetime dt = DateTime.parse(responce.quota.stopUntilTime);
                creditaccdetail.modigie__StopUntilTime__c=dt; 
                }
                Database.SaveResult sr = Database.insert(creditaccdetail, false);
                    if (sr.isSuccess()) {
                        result = 'Success';
                    }
                    else {
                        result = 'Fail';
                    }
                }
                else{
                    System.debug('response===>'+resp.getBody());
                    return String.valueOf(resp.getBody());
                }
            }
        return result;
    }
    
    @AuraEnabled
    public static String refreshCreditIds(){
        try {
            insertedCreditIds.clear();
            creditAccountDetailsToInsert.clear();

            String developerName = 'Get_Credit_Info';
            List<modigie__Modigie_Service_Account__mdt> serviceAccDetail = ModigieApiUtils.getServiceAccountDetails();
            List<modigie__Modigie_Callout_Info__mdt> calloutInfo = ModigieApiUtils.getCalloutInfoDetails(developerName);
            if(!serviceAccDetail.isEmpty() && !calloutInfo.isEmpty()){
                HttpRequest req = new HttpRequest();
                String serviceAccCredential = serviceAccDetail[0].modigie__Email__c;
                String targetAud = calloutInfo[0].modigie__targetAud__c;
                String privateKey = serviceAccDetail[0].modigie__Private_Key__c;
                String endpointUrl = calloutInfo[0].modigie__Endpoint_Url__c;
                String customerId = serviceAccDetail[0].modigie__Customer_ID__c;
                String apiKey = serviceAccDetail[0].modigie__API_Key__c;
                endpointUrl = endpointUrl.replace('{customerId}',customerId)+'?pageSize=20';
                
                System.debug(endpointUrl);
                String accessToken = jwtapex.get_access_token(serviceAccCredential,targetAud,privateKey);
                System.debug(accessToken);
                for(modigie__creditAccountDetails__c creditAccDetails: [SELECT Id, Name, modigie__Credit_Id__c FROM modigie__creditAccountDetails__c]){
                    flag = true;
                    insertedCreditIds.add(creditAccDetails.modigie__Credit_Id__c);
                    mMap.put(creditAccDetails.modigie__Credit_Id__c, creditAccDetails);
                }
                System.HttpResponse resp = getCreditAccountApiCallout(accessToken, apiKey, endpointUrl, null);  
                if(resp.getStatusCode() == 200){
                    return 'Success';
                }
                else{
                    return String.valueOf(resp.getBody());
                }
            }
            
            // System.debug(resp);
            return 'Fail';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    // @AuraEnabled
    public static System.HttpResponse getCreditAccountApiCallout(String accessToken, String apiKey, String endpointUrl, String pageToken){
        System.debug('pageToken line number 333' + pageToken);
        try {
            String newEndpointUrl=endpointUrl;
            if(pageToken != null){
                newEndpointUrl = newEndpointUrl + '&pageToken=' + pageToken;
                System.debug('line number 338 newEndpointUrl' + newEndpointUrl);
            }
            // apiKey = 'zyz';
            HTTPResponse response = ModigieApiUtils.executeAPI(accessToken, 'GET', apiKey, newEndpointUrl,'');
            System.debug(response);
            if(response.getStatusCode() == 200){
                ModigieJsonWrapper.creditListWrapper apiResponse = ModigieJsonUtils.getCreditList(response.getBody());
                // List<ModigieJsonWrapper.itemsWrapper> itemsWrapper = apiResponse.items;
                System.debug('line number 346 pagetoken ' + apiResponse.pageToken);

                for(ModigieJsonWrapper.itemsWrapper item: apiResponse.items){
                    // Map<String, Object> singleItem = JSON.deserializeUntyped(item) ;
                    System.debug('319------->'+item.status);
                    String uniqueStringforName = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
                    Boolean isPerformance = false;
                    if(item.contract.contractType != 'pay-per-use'){
                        isPerformance = true;
                    }
                    Datetime stopUntilTime = Datetime.now();
                    if(item.quota.stopUntilTime!=null){
                        stopUntilTime = DateTime.parse(item.quota.stopUntilTime); 
                    }
                    
                    if(!insertedCreditIds.contains(item.id)){
                        modigie__creditAccountDetails__c newCreditAccountIds = new modigie__creditAccountDetails__c(Name = uniqueStringforName, modigie__Credit_Id__c = item.id,
                                                                                                                    modigie__Title__c = item.title, modigie__Status__c = item.status,
                                                                                                                    modigie__isPerformance__c = isPerformance, modigie__Balance__c = Decimal.valueOf(item.balance.amount),
                                                                                                                    modigie__Currency_Code__c = item.balance.currency_x.code);
                        if(item.quota.stopUntilTime!=null){
                            newCreditAccountIds.modigie__StopUntilTime__c = stopUntilTime;
                        }
                        creditAccountDetailsToInsert.add(newCreditAccountIds);
                    }
                    else{
                        modigie__creditAccountDetails__c cad = mMap.get(item.id);
                        cad.modigie__Title__c = item.title;
                        cad.modigie__Status__c = item.status;
                        cad.modigie__isPerformance__c = isPerformance;
                        if(item.quota.stopUntilTime!=null){
                            cad.modigie__StopUntilTime__c = stopUntilTime;
                        }
                        cad.modigie__Currency_Code__c = item.balance.currency_x.code;
                        cad.modigie__Balance__c = Decimal.valueOf(item.balance.amount);
                        mMap.put(item.id, cad);
                    }
                    creditAccountsFromGCP.add(item.id);
                }
            
                pageToken = apiResponse.pageToken;
                if(pageToken != null){
                    System.debug('line number 373 pageToken' + pageToken);
                    getCreditAccountApiCallout(accessToken, apiKey, endpointUrl, pageToken);
                }
                else{
                    if(!mMap.values().isEmpty()){
                        update mMap.values();
                    }
                    if(!creditAccountDetailsToInsert.isEmpty()){
                        creditAccountDetailsToInsert[0].modigie__Default__c = true;
                        System.debug('line number 380 creditAccountDetailsToInsert' + creditAccountDetailsToInsert[0]);
                        insert creditAccountDetailsToInsert ;
                    }
                }
                System.debug('creditAccountsFromGCP---->'+creditAccountsFromGCP);
                List<modigie__creditAccountDetails__c> creditAccountToDeactivate = [SELECT Id, modigie__Credit_Id__c, modigie__Default__c FROM modigie__creditAccountDetails__c WHERE modigie__Credit_Id__c NOT IN :creditAccountsFromGCP];
                for(modigie__creditAccountDetails__c cadItem: creditAccountToDeactivate){
                    cadItem.modigie__Status__c = 'inactive';
                    if(cadItem.modigie__Default__c == true){
                        System.debug('Send Email for inactive credit account------>'+cadItem.modigie__Credit_Id__c);
                        EmailServiceClass.sendEmailForDefaultInactiveCreditAccount(cadItem.modigie__Credit_Id__c);
                    }
                }
                System.debug(creditAccountToDeactivate);
                if(!creditAccountToDeactivate.isEmpty()){
                    update creditAccountToDeactivate;
                }
            }
            else{
                return response;
            }
            return response;
        } catch (Exception e) {
            System.debug(e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string authenticateCredentials(String apiKey, String serviceAccCredential, String privateKey){
        try {
            String developerName = 'Get_Credit_Info';
            List<modigie__Modigie_Service_Account__mdt> serviceAccDetail = ModigieApiUtils.getServiceAccountDetails();
            List<modigie__Modigie_Callout_Info__mdt> calloutInfo = ModigieApiUtils.getCalloutInfoDetails(developerName);
            HttpRequest req = new HttpRequest();
            
            if(!serviceAccDetail.isEmpty() && !calloutInfo.isEmpty()){
                String targetAud = calloutInfo[0].modigie__targetAud__c;
                String endpointUrl = calloutInfo[0].modigie__Endpoint_Url__c;
                String customerId = serviceAccDetail[0].modigie__Customer_ID__c;
                endpointUrl = endpointUrl.replace('{customerId}',customerId)+'?pageSize=1';
                
                String accessToken = jwtapex.get_access_token(serviceAccCredential,targetAud,privateKey);
                System.debug('accessToken------>'+accessToken);
                HTTPResponse response = ModigieApiUtils.executeAPI(accessToken, 'GET', apiKey, endpointUrl,'');
                if(response.getStatusCode() == 200){
                    return 'Success';
                }
            }
            return 'Fail';

        } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static void saveAuthenticationCredentials(String apiKey, String serviceAccCredential, String privateKey,String updateTime){
        try {
           // modigie__Modigie_Service_Account__mdt serviceAccountToUpdate = ModigieApiUtils.getServiceAccountDetails();
            Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
            fieldWithValuesMap.put('modigie__API_Key__c', apiKey);
            fieldWithValuesMap.put('modigie__Email__c', serviceAccCredential);
            fieldWithValuesMap.put('modigie__Private_Key__c', privateKey);
            
            modigie__Modigie_Service_Account__mdt mc = modigie__Modigie_Service_Account__mdt.getInstance('Default_Service_Credential');
            Boolean isupdate=false;
            if(mc!=null)
            {
                
                if(updateTime!=null)
                {
                    if(mc.modigie__Credential_Update_Time__c!=null)
                    {
                        Datetime dt = ModigieApiUtils.datetimeparser(updateTime);
                        if(dt>mc.modigie__Credential_Update_Time__c)
                        {
                            fieldWithValuesMap.put('modigie__Credential_Update_Time__c', dt);
                            isupdate=true;
                        }
                    }
                    else
                    {
                         Datetime dt = ModigieApiUtils.datetimeparser(updateTime);
                    
                    	fieldWithValuesMap.put('modigie__Credential_Update_Time__c', dt);
                        isupdate=true;
                    }
                }
            }
            else
            {
                if(updateTime!=null)
            	{
                    Datetime dt = ModigieApiUtils.datetimeparser(updateTime);
                    
                    fieldWithValuesMap.put('modigie__Credential_Update_Time__c', dt);
                }
                isupdate=true;
            }
            System.debug(fieldWithValuesMap+'------>'+isUpdate);
			if(isupdate)
            {
            CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
            } 
       } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static modigie__Modigie_Service_Account__mdt getAuthenticationDetails(){
        try {
            List<modigie__Modigie_Service_Account__mdt> serviceAccDetail = new List<modigie__Modigie_Service_Account__mdt>();
            serviceAccDetail = ModigieApiUtils.getServiceAccountDetails();
            return serviceAccDetail[0];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}