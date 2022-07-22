public with sharing class EmailServiceClass {
    @AuraEnabled
    public static String sendEmail(String message){
        try{
            
            Map<String,Object> errorMap = (Map<String,Object>)JSON.deserializeUntyped(message);
            String emailBody = '';
            
                modigie__Error_Log__c errorLog = new modigie__Error_Log__c();
                
                if(errorMap.get('SObjectId') != null){
                    Id sObjectId = (Id)errorMap.get('SObjectId');
                    String sobjectType = sObjectId.getSObjectType().getDescribe().getName();
                    if(sobjectType?.equalsIgnoreCase('Contact') == true){
                        errorLog.modigie__Contact__c = sObjectId;
                    }
                    else if(sobjectType?.equalsIgnoreCase('Lead') == true){
                        errorLog.modigie__Lead__c = sObjectId;
                    }
                    else if(sobjectType?.equalsIgnoreCase('Campaign')){
                        errorLog.modigie__Campaign__c = sObjectId;
                    }
                }
                
                if(errorMap.get('ErrorMessage') != null){
                    errorLog.modigie__Description__c = (String)errorMap.get('ErrorMessage');
                    emailBody += 'Error : ' + (String)errorMap.get('ErrorMessage');
                }
                if(errorMap.get('StatusCode') != null){
                    errorLog.modigie__Error_Code__c =  (Integer)errorMap.get('StatusCode');
                    emailBody += '\nStatus Code : ' + (Integer)errorMap.get('StatusCode');
                }
                
                if(errorMap.get('JobId') != null){
                    errorLog.modigie__Job_Id__c = (String)errorMap.get('JobId');
                    emailBody += '\nCallout Type : GET';
                    emailBody += '\nJob Id : ' + (String)errorMap.get('JobId');
                }
                else{
                    emailBody += '\nCallout Type : POST';    
                }
                
                if(errorMap.get('ModigieService') != null){
                    errorLog.modigie__Modigie_Service__c = (String)errorMap.get('ModigieService');
                    emailBody += '\nModigie Service : ' + (String)errorMap.get('ModigieService');    
                }
                
                errorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                if(FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c')&&
               FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Description__c')&&
               FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Description__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Error_Code__c')&&
               FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Error_Code__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Modigie_Service__c')&&
               FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Modigie_Service__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Campaign__c')&&
               FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Campaign__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Contact__c')&&
               FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Contact__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Lead__c')&&
               FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Lead__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Job_Id__c')&&
               FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Job_Id__c'))
                {
                    insert errorLog;
                }   
                else{
                    throw new EmailServiceClassException('User does not have permission to edit error log object.');
                }
            if(errorMap.get('StatusCode') != null && (Integer)errorMap.get('StatusCode') == 301){
                String errorMessage = '%'+(String)errorMap.get('ErrorMessage')+'%';
                List<modigie__Modigie_Batch_Class_Internal_Error_List__c> ErrorLst = [SELECT Id, modigie__Error_Message__c FROM modigie__Modigie_Batch_Class_Internal_Error_List__c WHERE modigie__Error_Message__c like :errorMessage];
                //List<modigie__Modigie_Batch_Class_Internal_Error_List__c> ErrorLst = [SELECT Id, modigie__Error_Message__c FROM modigie__Modigie_Batch_Class_Internal_Error_List__c];
                //List<String> ErrLst = new List<String>();
                //
                //for(modigie__Modigie_Batch_Class_Internal_Error_List__c ErrorStr : ErrorLst){
                //    ErrLst.add(ErrorStr.modigie__Error_Message__c);
                //}
                //
                //if(!ErrLst.contains((String)errorMap.get('ErrorMessage'))){
                if(ErrorLst.isEmpty()){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    //List<User> lstUser = [SELECT Id, Email FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true WITH SECURITY_ENFORCED];
                    /*List<User> lstUser = new List<User>();
                    lstUser = [SELECT Id, Email FROM User WHERE isActive = true AND Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Modigie_Admin') AND Profile.Name = 'System Administrator' WITH SECURITY_ENFORCED];
                    
                    for(User usrObj : lstUser){
                        ccAddresses.add(usrObj.Email);
                    }
                    */
                    List<String> ccAddresses = new List<String>();
                    String[] toAddresses = new String[] {'support@modigie.com'};
                    mail.setToAddresses(toAddresses);
                    try{
                        ccAddresses.addAll(allMailToSend('CreditError'));
                    }catch(Exception exec){}
                    mail.setCcAddresses(ccAddresses);
                    mail.saveAsActivity= false;
                    mail.setSubject('Credit Error');
                    mail.setPlainTextBody(emailBody);
                    //List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
            else{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                //List<User> lstUser = [SELECT Id, Email FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true WITH SECURITY_ENFORCED];
                List<User> lstUser = new List<User>();

                
                    lstUser = [SELECT Id, Email FROM User WHERE isActive = true AND Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Modigie_Admin') AND Profile.Name = 'System Administrator' WITH SECURITY_ENFORCED];
                
               
                List<String> ccAddresses = new List<String>();
                
                for(User usrObj : lstUser){
                    ccAddresses.add(usrObj.Email);
                }
                
                String[] toAddresses = new String[] {'support@modigie.com'};
                    
                mail.setToAddresses(toAddresses);
                mail.setCcAddresses(ccAddresses);
                mail.saveAsActivity= false;
                mail.setSubject('Server Error');
                
                mail.setPlainTextBody(emailBody);
             //  List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
                return errorLog.Id;
            
        }
        catch(System.QueryException e){
            throw new EmailServiceClassException('You do not have permission to query user object fields.');
        }
        catch(Exception e){
            return e.getMessage();   
        }
    }
    public static void sendEmailForCampaign(Set<String> setOfMessages){
        try{
            List<User> lstUser = new List<User>();
            
           
                lstUser = [SELECT Id, Email FROM User WHERE isActive = true AND Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Modigie_Admin') AND Profile.Name = 'System Administrator' WITH SECURITY_ENFORCED];
            


            for(String message : setOfMessages){
                
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> ccAddresses = new List<String>();
                
                for(User usrObj : lstUser){
                    ccAddresses.add(usrObj.Email);
                }
                
                String[] toAddresses = new String[] {'support@modigie.com'};
                    
                mail.setToAddresses(toAddresses);
                mail.setCcAddresses(ccAddresses);
                mail.saveAsActivity= false;
                mail.setSubject('Server Error');
                mail.setPlainTextBody(message);
               // List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
            }
        }
        catch(System.QueryException e){
            throw new EmailServiceClassException('You do not have permission to query user fields.');
        }
        catch(Exception e){
            System.debug('e.getMessage' + e.getMessage());
        }
    }
    
    public static void sendResponseError(String origin, Integer statCode, String message){
        try {        
            Integer maxWidth = 255;
            message = 'EmailLog- ' + message;
            message = message.abbreviate(maxWidth);        
            String apiName = 'CalloutResponse'; //Sub- String of API Name of the Custom Setting.
            System.debug('Exception Type -->' + 'CalloutResponse');
            String errorMessage = '%'+message+'%';
            /*
            List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [
            SELECT Id, modigie__Error_Message__c
            FROM modigie__Modigie_Batch_Class_Internal_Error_List__c 
            WHERE modigie__Error_Message__c LIKE :errorMessage
            ];
            */
            List<modigie__Error_Log__c> lstBatchClassErrorLog = [
                SELECT Id, modigie__Job_Id__c 
                FROM modigie__Error_Log__c 
                WHERE modigie__Job_Id__c LIKE :errorMessage AND 
                CreatedDate = TODAY
            ];
            //List<String> lstStrErr = new List<String>();
            //for (
            //modigie__Modigie_Batch_Class_Internal_Error_List__c batchClassError : lstBatchClassError
            //) {
            //lstStrErr.add(batchClassError.modigie__Error_Message__c);
            //}
            //List<String> IgnoreListContainslist = new List<String>{'BatchJobsSchedulerClass scheduleForOneMinute', 'BatchJobsSchedulerClass Error', 'ContactBatchForGetModigieButton Error', 'IntervalScheduler Class', 'ModigieServicesAsychronousSchedulable Error'};
            
            //if (!lstStrErr.contains(message)){// || IgnoreListContainslist.contains(origin)) {
            /*
            if(lstBatchClassError.isEmpty()){
            */
            if(lstBatchClassErrorLog.isEmpty()){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> toAddresses = new List<String>();
                toAddresses.add('support@modigie.com');
                toAddresses.add('support-salesforce@modigie.com');
                if(statCode == 401 || statCode == 402 || statCode == 403){
                    try{
                        toAddresses.addAll(allMailToSend('CalloutResponse'));
                    }catch(Exception exec){}
                }

                mail.setToAddresses(toAddresses);
                mail.saveAsActivity = false;
                mail.setSubject(
                'Modigie : '+origin+' Error'
                );
                String emailBody = '\nResponse Body: ' + message;
                emailBody += '\nResponse Status Code: ' + statCode;
                emailBody +=
                '\nOrganization Name : ' + UserInfo.getOrganizationName();
                emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
                mail.setPlainTextBody(emailBody);
                /*
                if (!toAddresses.isEmpty() &&
                 FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Batch_Class_Internal_Error_List__c') 
                ) {
                    insert new modigie__Modigie_Batch_Class_Internal_Error_List__c(
                    Name = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:sssZ'),
                    modigie__Error_Message__c = message
                    );
                }
                */
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(
                    new List<Messaging.SingleEmailMessage>{ mail }
                );
                if(!toAddresses.isEmpty() && 
                    FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') && 
                    FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Job_Id__c') && 
                    FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Validation_Key__c') && 
                    FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Description__c') )
                {
                    insert new modigie__Error_Log__c(
                        modigie__Job_Id__c = message,
                        modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey',
                        modigie__Description__c = 'Please check job id to check error.'
                    );
                }
            }
        } catch (Exception exx) { }
    }

    public static void sendErrorEmail(String origin, Exception error){
        try {
            Integer maxWidth = 255;
            String message = 'EmailLog- ' + error.getMessage();
            message = message.abbreviate(maxWidth);
            String errorMessage = '%'+message+'%';
            System.debug('Exception Type -->' + error.getTypeName());
            /*
            List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [
              SELECT Id, modigie__Error_Message__c
              FROM modigie__Modigie_Batch_Class_Internal_Error_List__c 
              WHERE modigie__Error_Message__c LIKE :errorMessage
            ];
            */
            List<modigie__Error_Log__c> lstBatchClassErrorLog = [
                SELECT Id, modigie__Job_Id__c 
                FROM modigie__Error_Log__c 
                WHERE modigie__Job_Id__c LIKE :errorMessage AND 
                CreatedDate = TODAY
            ];
            //List<String> lstStrErr = new List<String>();
            //for (
            //  modigie__Modigie_Batch_Class_Internal_Error_List__c batchClassError : lstBatchClassError
            //) {
            //  lstStrErr.add(batchClassError.modigie__Error_Message__c);
            //}
            List<String> IgnoreListContainslist = new List<String>{'BatchJobsSchedulerClass scheduleForOneMinute', 'BatchJobsSchedulerClass Error', 'ContactBatchForGetModigieButton Error', 'IntervalScheduler Class', 'ModigieServicesAsychronousSchedulable Error'};
            //
            ////To Limit IgnoreListContainsList Error Messages to Minimum of 10
            //Integer ignoreListSendCount = 0;
            //if(IgnoreListContainslist.contains(origin)){
            //    String errMsg = error.getMessage();
            //    for(String tempString : lstStrErr){
            //      if(tempString.equals(errMsg)){
            //        ignoreListSendCount++;
            //        if(ignoreListSendCount == 5){
            //            break;
            //        }
            //      }
            //    }
            //}
            //
            //if (!lstStrErr.contains(error.getMessage()) || (IgnoreListContainslist.contains(origin)) && ignoreListSendCount < 5) {
            /*
            if(lstBatchClassError.isEmpty() || (IgnoreListContainslist.contains(origin) && lstBatchClassError.size()<=5) ){
            */
            if(lstBatchClassErrorLog.isEmpty() || (IgnoreListContainslist.contains(origin) && lstBatchClassErrorLog.size()<=5) ){
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              List<String> toAddresses = new List<String>();
              toAddresses.add('support@modigie.com');
              toAddresses.add('support-salesforce@modigie.com');
              try{
                    if(origin != 'SalesEngagementBatchClass Error!'){
                        toAddresses.addAll(allMailToSend(error.getTypeName()));
                    }
              }catch(Exception exec){}

              mail.setToAddresses(toAddresses);
              mail.saveAsActivity = false;
              mail.setSubject(
                'Modigie : '+origin
              );
              String emailBody = 'Please check the error message - ' + error.getMessage();
              if(error.getCause()!= null){
                  emailBody += '\nError Cause : ' + error.getCause();
              }
              emailBody += '\nStack Trace : ' + error.getStackTraceString();
              emailBody +=
                '\nOrganization Name : ' + UserInfo.getOrganizationName();
              emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
              mail.setPlainTextBody(emailBody);
              /*
              if (!toAddresses.isEmpty() &&
                FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Batch_Class_Internal_Error_List__c')
              ) {
                insert new modigie__Modigie_Batch_Class_Internal_Error_List__c(
                  Name = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:sssZ'),
                  modigie__Error_Message__c = error.getMessage()
                );
              }
              */
              List<Messaging.SendEmailResult> results = Messaging.sendEmail(
                new List<Messaging.SingleEmailMessage>{ mail }
              );
              if(origin != 'SalesEngagementBatchClass Error!' && 
                !toAddresses.isEmpty() && 
                FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') && 
                FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Job_Id__c') && 
                FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Validation_Key__c') && 
                FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Description__c') )
              {
                insert new modigie__Error_Log__c(
                    modigie__Job_Id__c = message,
                    modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey',
                    modigie__Description__c = 'Please check job id to check error.'
                );
              }
            }
            System.debug('e.getLineNumber() --> ' +  error.getLineNumber());
            System.debug('e.Stack Trace : ' + error.getStackTraceString());
            System.debug('error --> ' +  error.getMessage());
        } catch (Exception exx) {
            //System.debug('Email Error -->' + exx);
        }
    }

    public static Set<String> allMailToSend(String eType){
        try{
            Boolean isException = false;
            if(eType.contains('System.')){
                isException = true;
                eType = eType.remove('System.');
            }
            List<modigie__Message_Center__c> messageCenter = new List<modigie__Message_Center__c>();
            try{
                System.debug(eType);
                String qry = 'SELECT modigie__Users_Opted_For_AllException__c, modigie__AllException__c, modigie__Users_Opted_For_'+eType+'__c, modigie__'+eType+'__c FROM modigie__Message_Center__c';
                messageCenter = Database.query(qry);
            }catch(Exception ex){
                //Only some eType is considered in this code
                return null;
            }
            if(messageCenter.isEmpty()){
                return null;
            }
            List<Id> userIds = new List<Id>();
            //All Exception doesn't work for non Exception Error.
            if(messageCenter[0].modigie__AllException__c && isException){
                userIds.addAll( (List<String>) System.JSON.deserialize(messageCenter[0].modigie__Users_Opted_For_AllException__c, List<String>.class));
            }else if(messageCenter[0].get('modigie__'+eType+'__c')==true){
                userIds.addAll( (List<String>) System.JSON.deserialize((String) messageCenter[0].get('modigie__Users_Opted_For_'+eType+'__c'), List<String>.class));
            }else{
                //Opted out of Everything
                return null;
            }
            if(userIds.isEmpty()){
                //No User selected
                return null;
            }
            //make sure the users have modigie admin
            List<PermissionSet> MAdminPS = [SELECT Id FROM PermissionSet WHERE NamespacePrefix = 'modigie' AND Label = 'Modigie Admin'];
            List<User> userList = [SELECT Email FROM User WHERE Id in :userIds AND isActive = true AND Id in (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId IN :MAdminPS)];
            if(userList.isEmpty()){
                //No Active User selected
                return null;
            }
            Set<String> mailSet = new Set<String>();
            for(User u: userList){
                mailSet.add(u.Email);
            }
            return mailSet;
        }catch(Exception exx){
            return null;
        }
    }

    public static void sendEmailForDefaultInactiveCreditAccount(String creditAccountId){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'amitnamdev@cyntexa.com','harshyadav@cyntexa.com','ankur@cyntexa.com','gajendra@cyntexa.com'};
        message.subject = 'Subject Test Message';
        message.plainTextBody = 'The credit account with id '+creditAccountId + ' is inactive.';
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        try{
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
        catch(Exception e){
            //do nothing
        }
    }

    private class EmailServiceClassException extends Exception{}
}