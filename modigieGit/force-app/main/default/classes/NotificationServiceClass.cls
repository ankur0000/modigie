public with sharing class NotificationServiceClass {
    
    public static void sendNotification(String notificationTitle, String notificationBody, Set<String> notificationReceiver, Set<String> campaignForNotification){
        
        List<String> lStrings = new List<String>(campaignForNotification);
        List<CustomNotificationType > notification = [SELECT Id, CustomNotifTypeName, DeveloperName from CustomNotificationType WHERE DeveloperName = 'Callout_Completion_Notification' WITH SECURITY_ENFORCED LIMIT 1];
        
        Messaging.CustomNotification obj = new Messaging.CustomNotification();
        obj.setNotificationTypeId(notification[0].Id);
        
        obj.setTitle(notificationTitle);
        obj.setBody(notificationBody);
        
        for(Integer i=0;i<lStrings.size();i++){
            obj.setTargetId(lStrings[i]);
            obj.send(notificationReceiver);
        }
    }
    
    public static void sendNotification(String notificationTitle, String adminId){
        
        List<User> lstUsr = [SELECT isActive FROM User WHERE Id = :adminId AND isActive = true WITH SECURITY_ENFORCED];
        
        if(lstUsr.size() > 0){
                List<CustomNotificationType > notification = [SELECT Id, CustomNotifTypeName, DeveloperName from CustomNotificationType WHERE DeveloperName = 'Callout_Completion_Notification'  WITH SECURITY_ENFORCED LIMIT 1];
                
                Messaging.CustomNotification obj = new Messaging.CustomNotification();
                obj.setNotificationTypeId(notification[0].Id);
                
                obj.setTitle(notificationTitle);
                obj.setBody('Invocable Limits Exceeded.');
                
                Set<String> notificationReceiver = new Set<String>();
                notificationReceiver.add(adminId);
                
                obj.setTargetId((String)UserInfo.getUserId());
                obj.send(notificationReceiver);
            
        }
        
    }
    //Limit Functionality
    public static void sendEmailLimitReached(String notificationTitle, String limField, Decimal lim, Decimal usage, Integer size, String adminId){

        
            
        //List<modigie__Modigie_Configurator__c> mc = [SELECT modigie__ConfigurerId__c FROM modigie__Modigie_Configurator__c];

        //String configuratorId = mc[0].modigie__ConfigurerId__c;

        //List<User> lstUsr = [SELECT isActive, Email FROM User WHERE Id = :adminId AND isActive = true WITH SECURITY_ENFORCED];

        //List<User> lstUsr = [SELECT isActive, Email FROM User WHERE Id = :configuratorId];
        String wildcard = limField+'%';

        List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [
            SELECT Id, modigie__Error_Message__c
            FROM modigie__Modigie_Batch_Class_Internal_Error_List__c
            WHERE modigie__Error_Message__c LIKE :wildcard
        ];
        //List<String> lstStrErr = new List<String>();
        Integer maxLimitSent = 0;
        for (
        modigie__Modigie_Batch_Class_Internal_Error_List__c batchClassError : lstBatchClassError
        ) {
            String subStr = batchClassError.modigie__Error_Message__c;
            Integer currentLimitSent = Integer.valueOf(subStr.substringAfter('-'));
            if(maxLimitSent< currentLimitSent){
                maxLimitSent = currentLimitSent;
            }
            //lstStrErr.add(batchClassError.modigie__Error_Message__c);
        }

        List<String> toAddresses = new List<String>();
        
        System.debug('Inside the SendEmailLimitReached----------->');
            toAddresses.add('Support@modigie.com');
            /*if(lstUsr.size() > 0){
                toAddresses.add(lstUsr[0].Email);
            }*/
            try{
                toAddresses.addAll(EmailServiceClass.allMailToSend('InvocableLimitExceeded'));
            }catch(Exception exec){}
            
            String message = limField+'-'+lim;
            
        if (!toAddresses.isEmpty() && (lim > maxLimitSent)/** && is Email Sent Already NOT*/) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.saveAsActivity = false;
            mail.setSubject((notificationTitle+': Limit Reached'));
            String emailBody = '\nField : ' + limField;
            emailBody += '\nLimit : ' + lim;
            emailBody += '\nUsage : ' + usage;
            emailBody += '\nSize Requested : ';
            if(size>0){
                emailBody += size;
            }else{
                emailBody += 'N/A';
            }
            emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
            emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
            mail.setPlainTextBody(emailBody);
            try{
                if(FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Batch_Class_Internal_Error_List__c')){
                    insert new modigie__Modigie_Batch_Class_Internal_Error_List__c(
                        Name = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:sssZ')+Integer.valueof((Math.random() * 100)),
                        modigie__Error_Message__c = message
                    );
                }
                NotificationServiceClass.sendNotification(notificationTitle, adminId);
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
            }catch(Exception excep){}
            /**Set Email Sent Already to true for Notification Title */
        }
    }

    public static void sendAdhoqEmailLimitReached(Integer tLimit){ 
        
        //List<User> lstUsr = [SELECT isActive, Email FROM User WHERE Id = :adminId AND isActive = true WITH SECURITY_ENFORCED];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
        //List<modigie__Modigie_Configurator__c> mc = [SELECT modigie__ConfigurerId__c FROM modigie__Modigie_Configurator__c];
        //System.debug('------------------->'+mc);
        //String configuratorId = mc[0].modigie__ConfigurerId__c;

        //List<User> lstUsr = [SELECT isActive, Emaial FROM User WHERE Id = :configuratorId];
        
        List<String> toAddresses = new List<String>();
    
    
        toAddresses.add('Support@modigie.com');
        /*if(lstUsr.size() > 0){
            toAddresses.add(lstUsr[0].Email);
        }*/
        try{
            toAddresses.addAll(EmailServiceClass.allMailToSend('AdhoqLimitReached'));
        }catch(Exception exec){}
        
        if (!toAddresses.isEmpty()) {
            //fields
            List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieUsage = [SELECT modigie__User_Id__c, modigie__Number_of_modigie_callouts_in_a_day__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WHERE modigie__User_Id__c = :UserInfo.getUserId() LIMIT 1];
            Integer usgByUser = (Integer)modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c;

            List<modigie__Profile_and_user_modigie_limits__c> modigieUserProfileLimits = [SELECT modigie__User_or_Profile_Id__c,modigie__Limit_of_modigie_callouts__c,modigie__User_Or_Profile__c FROM modigie__Profile_and_user_modigie_limits__c WHERE modigie__User_or_Profile_Id__c = :UserInfo.getUserId() OR modigie__User_or_Profile_Id__c = :UserInfo.getProfileId()];
            List<Id> profileIds = new List<Id>();
            Integer usrLimit;
            Integer profLimit;
            Boolean profLimZero = false;
            Boolean userLimZero = false;
            for(modigie__Profile_and_user_modigie_limits__c modigieLimits : modigieUserProfileLimits){
                if(modigieLimits.modigie__User_Or_Profile__c?.equalsIgnoreCase('Profile') == true){
                    profLimit = (Integer)modigieLimits.modigie__Limit_of_modigie_callouts__c;
                    profLimZero = ((profLimit - usgByUser) <= 0);
                }else{
                    usrLimit = (Integer)modigieLimits.modigie__Limit_of_modigie_callouts__c;
                    userLimZero = ((usrLimit - usgByUser) <= 0);
                }
            }
            //mail
            mail.setToAddresses(toAddresses);
            mail.saveAsActivity = false;
            String subject = 'Adhoc Limit Reached for ';
            String emailBody = '';
            String forUserProfile;
            if(userLimZero){
                subject += 'User : ' + UserInfo.getName();
                forUserProfile = UserInfo.getName();
                emailBody += '\nUser Name : ' + UserInfo.getName();
                emailBody += '\nUser Id : ' + UserInfo.getUserId();
                emailBody += '\nUser Limit : ' + usrLimit;
                emailBody += '\nCurrently Used : ' + usgByUser;
            }else if(profLimZero){
                Id profId = UserInfo.getProfileId();
                List<Profile> prof = [SELECT Name FROM Profile WHERE Id = :profId];
                
                subject += 'Profile : ' + prof[0].Name;
                forUserProfile = prof[0].Name;
                emailBody += '\nProfile Name : ' + prof[0].Name;
                emailBody += '\nProfile Id : ' + UserInfo.getProfileId();
                emailBody += '\nProfile Limit : ' + profLimit;
                emailBody += '\nUser Name : ' + UserInfo.getName();
                emailBody += '\nUser Id : ' + UserInfo.getUserId();
                emailBody += '\nCurrently Used : ' + usgByUser;
            }
            mail.setSubject(subject);
            
            emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
            emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
            mail.setPlainTextBody(emailBody);
            String message = 'Adhoc Limit Reached For '+forUserProfile+'-'+tLimit;
            String wildcard = 'Adhoc Limit Reached For '+forUserProfile+'%';

            List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [
                SELECT Id, modigie__Error_Message__c
                FROM modigie__Modigie_Batch_Class_Internal_Error_List__c
                WHERE modigie__Error_Message__c LIKE :wildcard
            ];
            //List<String> lstStrErr = new List<String>();
            Integer maxLimitSent = 0;
            for (
            modigie__Modigie_Batch_Class_Internal_Error_List__c batchClassError : lstBatchClassError
            ) {
                String subStr = batchClassError.modigie__Error_Message__c;
                Integer currentLimitSent = Integer.valueOf(subStr.substringAfter('-'));
                if(maxLimitSent< currentLimitSent){
                    maxLimitSent = currentLimitSent;
                }
                //lstStrErr.add(batchClassError.modigie__Error_Message__c);
            }
            if(tLimit > maxLimitSent){
                try{
                    if(FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Batch_Class_Internal_Error_List__c')){
                        insert new modigie__Modigie_Batch_Class_Internal_Error_List__c(
                            Name = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:sssZ')+Integer.valueof((Math.random() * 100)),
                            modigie__Error_Message__c = message
                        );
                    }
                    sendNotification(wildcard.SubStringBefore('%'), UserInfo.getUserId());
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
                }catch(Exception exce){}
            }
        }
    }

    
    public static void adhoqLimitCheck(){
        //get User and it's Usage
        //get Limit
        //If Limit - Usage <= 0, send email

        String usg = LimitsMapClass.sendAPILimitData();
        Map<String, Object> usgMap = (Map<String, Object>) JSON.deserializeUntyped(usg);
        Boolean lmtToggle = (Boolean) usgMap.get('Ad_Hoc_Limits');
        if(lmtToggle){
            Integer tLmt= (Integer) usgMap.get('Total_API_Limit');
            Integer uLmt= (Integer) usgMap.get('Used_API_Limit');
            System.debug(tLmt+'-'+uLmt);
            if((tLmt-uLmt)<=0){
                sendAdhoqEmailLimitReached(tLmt);
            }
        }
    }

    public static void sendEmailRuleSetLimit(List<modigie__Modigie_Rule_Sets__c> updatedRuleSets){
        System.debug('Inside the SendEmailRuleSetLimit----------->');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>();
        List<modigie__Modigie_Rule_Sets__c> reUpdateRuleSets = new List<modigie__Modigie_Rule_Sets__c>();

        toAddresses.add('support@modigie.com');
        toAddresses.add('support-salesforce@modigie.com');
        try{
            toAddresses.addAll(EmailServiceClass.allMailToSend('InvocableLimitExceeded'));
        }catch(Exception exec){}
        mail.setToAddresses(toAddresses);
        mail.saveAsActivity = false;
        mail.setSubject('Modigie Job Automation Limit Reached');
        String emailBody = 'Hello User,<br /><br />The daily Automation limit for Get Modigie has exceeded for following Rule Sets.<br /><br /><table style="border-collapse: collapse;"><tr><th style="padding: 8px 24px;text-align: left;border-bottom: 1px solid #DDD;">Rule Set Name</th><th style="padding: 8px 24px;text-align: left;border-bottom: 1px solid #DDD;">Limit Per Day</th><th style="padding: 8px 24px;text-align: left;border-bottom: 1px solid #DDD;">Maintain Queue</th></tr>';
        String errorBody = 'Modigie Job Automation Limit Reached -';
        for(modigie__Modigie_Rule_Sets__c mrs: updatedRuleSets){
            if(!mrs.modigie__Email_Limit_Sent__c && mrs.modigie__isLimit__c && (mrs.modigie__Limit__c == mrs.modigie__Usage__c)){
                modigie__Modigie_Rule_Sets__c tempMRS = new modigie__Modigie_Rule_Sets__c(Id = mrs.Id, modigie__Email_Limit_Sent__c = true);
                reUpdateRuleSets.add(tempMRS);
                emailBody += '<tr><td style="padding: 8px 24px;text-align: left;border-bottom: 1px solid #DDD;">' + mrs.modigie__Rule_Set_Name__c + '</td><td style="padding: 8px 24px;text-align: left;border-bottom: 1px solid #DDD;">' + mrs.modigie__Limit__c + '</td><td style="padding: 8px 24px;text-align: left;border-bottom: 1px solid #DDD;">' + (mrs.modigie__Maintain_Queue__c ? 'Yes' : 'No') + '</td></tr>';
                errorBody += ' ' + mrs.modigie__Rule_Set_Name__c + ' : ' + mrs.modigie__Limit__c + ' : ' + (mrs.modigie__Maintain_Queue__c ? 'Yes' : 'No') + ';';
            }
        }
        emailBody += '</table><br /><br />Please have your Manager or System Admin review your queue and determine if you should increase your daily limit to accommodate your needs.<br />You can also contact Modigie to do this for you at <a href="mailto:support@modigie.com" target="_blank">support@modigie.com</a>.<br /><br /><br />Organization Name : ' + UserInfo.getOrganizationName() + '<br />Organization Id : ' + UserInfo.getOrganizationId() + '<br /><br />Thanks,<br />Modigie Automation<br /><span style="display:none">' + UserInfo.getUserName() + '</span>';
        mail.setHtmlBody(emailBody);
        System.debug('HTML ->' + emailBody);

        if(!reUpdateRuleSets.isEmpty()){
            if(false && FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Rule_Sets__c') &&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Rule_Sets__c','modigie__Email_Limit_Sent__c') &&
                FieldLevelSecurityCheck.canupdateField('modigie__Modigie_Rule_Sets__c','modigie__Email_Limit_Sent__c') &&
                FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Rule_Sets__c'))
            {
                update reUpdateRuleSets;
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
            }else{
                Integer maxWidth = 255;
                errorBody = 'EmailLog- ' + errorBody;
                String message = errorBody.abbreviate(maxWidth);
                System.debug('Message -> ' + message);
                String errorMessage = '%'+message+'%';
                List<modigie__Error_Log__c> lstBatchClassErrorLog = [
                    SELECT Id, modigie__Job_Id__c 
                    FROM modigie__Error_Log__c 
                    WHERE modigie__Job_Id__c LIKE :errorMessage AND 
                    CreatedDate = TODAY
                ];

                if(lstBatchClassErrorLog.size() < 2){
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
                    if(FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') && 
                        FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Job_Id__c') && 
                        FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Validation_Key__c') && 
                        FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Description__c') )
                    {
                        insert new modigie__Error_Log__c(
                            modigie__Job_Id__c = message,
                            modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey',
                            modigie__Description__c = 'Please check job id to check message.'
                        );
                    }
                }
            }
        }
    }


}