public with sharing class ModigieServicesAsychronousSchedulable implements Schedulable{
    private String modigieService;
    private List<String> lstIds = new List<String>();
    List<modigie__Modigie_Service_Account__mdt> tokenList = ModigieApiUtils.getServiceAccountDetails();
    public ModigieServicesAsychronousSchedulable(List<String> lstIds, String modigieService) {
        this.lstIds = lstIds;
        this.modigieService = modigieService;
    }
    public void execute(SchedulableContext ctx) {
        try{
            List<modigie__creditAccountUsers__c> cau = [SELECT Id, Name, modigie__Credit_Id__c FROM modigie__creditAccountUsers__c
                                                  WHERE modigie__User_Id__c =: Userinfo.getUserId() LIMIT 1];
            String creditAccountId;
            if(!cau.isEmpty()){
                creditAccountId = cau[0].modigie__Credit_Id__c;
            }
            else{
                List<modigie__creditAccountDetails__c> cad = [SELECT Id, Name, modigie__Credit_Id__c, modigie__Default__c FROM modigie__creditAccountDetails__c
                                                        WHERE modigie__Default__c = true LIMIT 1];
                if(!cad.isEmpty()){
                creditAccountId = cad[0].modigie__Credit_Id__c;
                }
            }
            
            Integer b_size;
            try{
                b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                if(b_size > 100 || b_size < 1){
                    b_size = 100;
                }
            }catch(Exception e){
                b_size = 100;
            }
            //DataBase.executeBatch(new GetModigieBatchClass());
            if(modigieService == 'Sales Engagement Batch Class'){
                if(tokenList.size() > 0){
                    if(!lstIds.isEmpty()){
                        String objType = ((Id)lstIds[0]).getSObjectType().getDescribe().getName();
                        if(objType == 'Lead' || objType == 'Contact'){
                            SalesEngagementBatchClass modiAsync = new SalesEngagementBatchClass(lstIds, objType);
                            Database.executeBatch(modiAsync, b_size); 
                        }else{
                            System.debug('Modigie Warning - Only Lead/Contact Id\'s Allowed!');
                        }
                    }
                }else{
                    System.debug('Modigie Warning - Token Missing!');
                }
            }
            else if(modigieService == 'Tom unTOM Batch Class'){
                if(tokenList.size() > 0){
                    if(!lstIds.isEmpty()){
                        String objType = ((Id)lstIds[0]).getSObjectType().getDescribe().getName();
                        if(objType == 'Lead' || objType == 'Contact'){
                            TOMunTOMBatchClass modiAsync = new TOMunTOMBatchClass(lstIds, objType);
                            Database.executeBatch(modiAsync, b_size);
                        }else{
                            System.debug('Modigie T.O.M. Warning - Only Lead/Contact Id\'s Allowed!');
                        }
                    }
                }else{
                    System.debug('Modigie Warning - Token Missing!');
                }
            }
            
            else if(modigieService == 'Get Modigie Contact'){
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Get_Modigie_Invocable_Limit__c, modigie__Get_Modigie_Invocable_Usage__c, modigie__Limits_No_Limits_Selection__c, modigie__Get_Modigie_Invocable_Limit_A__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                
                if(pbs.size() > 0){
                    if((pbs[0].modigie__Get_Modigie_Invocable_Limit__c >= pbs[0].modigie__Get_Modigie_Invocable_Usage__c + lstIds.size()) || pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true){
                        if(tokenList.size() > 0){
                            List<Contact> conLst = [SELECT Id, Account.Name,Email, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, modigie__Company_URL__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :lstIds AND FirstName != null AND Account.Name != null AND Email != null WITH SECURITY_ENFORCED];
                            if(!conLst.isEmpty()){
                                ContactBatchForGetModigieButton batchable = new ContactBatchForGetModigieButton(conLst,0);
                                Database.executeBatch(batchable,b_size);    
                            }
                            
                        }        
                    }
                    else{
                        //There are Multiple Instances here           
                        //Limit Functionality
                        //NotificationServiceClass.sendNotification('Get Modigie',pbs[0].modigie__Get_Modigie_Invocable_Limit_A__c);
                        NotificationServiceClass.sendEmailLimitReached('Get Modigie', 'modigie__Get_Modigie_Invocable_Limit__c', pbs[0].modigie__Get_Modigie_Invocable_Limit__c, pbs[0].modigie__Get_Modigie_Invocable_Usage__c, lstIds.size(), pbs[0].modigie__Get_Modigie_Invocable_Limit_A__c);
                        
                    }
                }
            }
            
            else if(modigieService == 'Get Modigie Lead'){
                
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Get_Modigie_Invocable_Limit__c, modigie__Get_Modigie_Invocable_Usage__c, modigie__Limits_No_Limits_Selection__c, modigie__Get_Modigie_Invocable_Limit_A__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                if(pbs.size() > 0){
                    if((pbs[0].modigie__Get_Modigie_Invocable_Limit__c >= pbs[0].modigie__Get_Modigie_Invocable_Usage__c + lstIds.size()) || pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true){
                        if(tokenList.size() > 0){
                            // String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                            String privateKey = tokenList[0].modigie__Private_Key__c;
                            String APIkey = tokenList[0].modigie__API_Key__c;
                            String serviceAccountCred = tokenList[0].modigie__Email__c;
                            List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds WITH SECURITY_ENFORCED];
                            if(!ldLst.isEmpty()){
                                LeadBatchForGetModigieButton batchable = new LeadBatchForGetModigieButton(ldLst, 0);
                                Database.executeBatch(batchable,b_size);    
                            }
                            
                        }    
                    }
                    else{
                        //NotificationServiceClass.sendNotification('Get Modigie', pbs[0].modigie__Get_Modigie_Invocable_Limit_A__c);
                        NotificationServiceClass.sendEmailLimitReached('Get Modigie', 'modigie__Get_Modigie_Invocable_Limit__c', pbs[0].modigie__Get_Modigie_Invocable_Limit__c, pbs[0].modigie__Get_Modigie_Invocable_Usage__c, lstIds.size(), pbs[0].modigie__Get_Modigie_Invocable_Limit_A__c);
                    }
                }
            }
            
            else if(modigieService == 'Get Linkedin Contact'){
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Limits_No_Limits_Selection__c, modigie__LinkedIn_Url_Invocable_Limits__c, modigie__LinkedIn_Url_Invocable_Usage__c,modigie__LinkedIn_Url_Invocable_Limits_A__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                
                if(pbs.size() > 0){
                    if((pbs[0].modigie__LinkedIn_Url_Invocable_Limits__c	 >= pbs[0].modigie__LinkedIn_Url_Invocable_Usage__c + lstIds.size()) || pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true){
                        if(tokenList.size() > 0)
                        {
                            // String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                            String privateKey = tokenList[0].modigie__Private_Key__c;
                            String APIkey = tokenList[0].modigie__API_Key__c;
                            String serviceAccountCred = tokenList[0].modigie__Email__c;
                            List<Contact> conLst = [SELECT Id, Account.Name,Email,Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, modigie__Company_URL__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :lstIds WITH SECURITY_ENFORCED];
                            if(!conLst.isEmpty()){
                                ContactBatchForGetLinkedinButton batchable = new ContactBatchForGetLinkedinButton(conLst,0);
                                Database.executeBatch(batchable,b_size);    
                            }
                        }
                    }
                    else{
                        NotificationServiceClass.sendNotification('LinkedIn URL',pbs[0].modigie__LinkedIn_Url_Invocable_Limits_A__c);
                    }
                }
            }
            
            else if(modigieService == 'Get Linkedin Lead'){
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Limits_No_Limits_Selection__c, modigie__LinkedIn_Url_Invocable_Limits__c, modigie__LinkedIn_Url_Invocable_Usage__c, modigie__LinkedIn_Url_Invocable_Limits_A__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                
                if(pbs.size() > 0){
                    if((pbs[0].modigie__LinkedIn_Url_Invocable_Limits__c	 >= pbs[0].modigie__LinkedIn_Url_Invocable_Usage__c + lstIds.size()) || pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true){
                        if(tokenList.size() > 0)
                        {
                            // String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                            String privateKey = tokenList[0].modigie__Private_Key__c;
                            String APIkey = tokenList[0].modigie__API_Key__c;
                            String serviceAccountCred = tokenList[0].modigie__Email__c;
                            List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email,Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds WITH SECURITY_ENFORCED];
                            if(!ldLst.isEmpty()){
                                LeadBatchForGetLinkedInButton batchable = new LeadBatchForGetLinkedInButton(ldLst,0);
                                Database.executeBatch(batchable,b_size);    
                            }
                            
                        }
                    }
                    else{
                        NotificationServiceClass.sendNotification('LinkedIn URL',pbs[0].modigie__LinkedIn_Url_Invocable_Limits_A__c);
                    }
                }
            }
            
            else if(modigieService == 'Verify Employer Contact/Lead'){
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Limits_No_Limits_Selection__c, modigie__Validate_Employer_Invocable_Limit__c, modigie__Validate_Employer_Invocable_Usage__c, modigie__Validate_Employer_Invocable_Limit_A__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                
                if(pbs.size() > 0){
                    if(pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true  || (pbs[0].modigie__Validate_Employer_Invocable_Limit__c >= pbs[0].modigie__Validate_Employer_Invocable_Usage__c + lstIds.size())){
                        if(tokenList.size() > 0){
                            List<Contact> conLst = [SELECT Id, Account.Name,modigie__Company_Email__c, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, Email, modigie__Modigie_Verified_Number__c, modigie__Company_URL__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :lstIds WITH SECURITY_ENFORCED];
                            List<Lead> ldLst = [SELECT Id, FirstName, LastName, modigie__Company_Email__c,Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone, modigie__Modigie_Verified_Number__c, (SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds WITH SECURITY_ENFORCED];
                            List<sObject> lstSobj = new List<sObject>();
                            lstSobj.addAll(conLst);
                            lstSobj.addAll(ldLst);
                            if(!lstSobj.isEmpty()){
                                VerifyEmployerDataMaintainenceClass batchable = new VerifyEmployerDataMaintainenceClass(lstSobj, 0);
                                Database.executeBatch(batchable,b_size);    
                            }
                            
                        } 
                    }
                    else{
                        //NotificationServiceClass.sendNotification('Verify Employer',pbs[0].modigie__Validate_Employer_Invocable_Limit_A__c);
                        NotificationServiceClass.sendEmailLimitReached('Verify Employer', 'modigie__Validate_Employer_Invocable_Limit__c', pbs[0].modigie__Validate_Employer_Invocable_Limit__c, pbs[0].modigie__Validate_Employer_Invocable_Usage__c, lstIds.size(), pbs[0].modigie__Validate_Employer_Invocable_Limit_A__c);
                    }
                }
            }
            
            else if(modigieService == 'Get Phone Insights Contact/Lead'){
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Get_linkedin_url__c, modigie__Validate_Employer__c, modigie__Limits_No_Limits_Selection__c, modigie__Modigie_Phone_Insights_Invocable_Limit__c, modigie__Modigie_Phone_Insights_Invocable_Usage__c, modigie__Modigie_Phone_Insights_Invocable_Limit_A__c,modigie__No_Mobile_Information__c  FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                
                List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
                
                if(pbs.size() > 0){
                    if((pbs[0].modigie__Modigie_Phone_Insights_Invocable_Limit__c >= pbs[0].modigie__Modigie_Phone_Insights_Invocable_Usage__c + lstIds.size()) || pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true){
                        
                        if(tokenList.size() > 0)
                        {            
                            // String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                            String privateKey = tokenList[0].modigie__Private_Key__c;
                            String APIkey = tokenList[0].modigie__API_Key__c;
                            String serviceAccountCred = tokenList[0].modigie__Email__c;
                            
                            modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c WITH SECURITY_ENFORCED LIMIT 1];
                            
                            List<SObject> scope = new List<SObject>();
                            List<Contact> conLst = [SELECT Id, FirstName, LastName, Email, AccountId, modigie__linkedin_url__c,MobilePhone, Phone, OtherPhone FROM Contact WHERE Id IN :lstIds WITH SECURITY_ENFORCED];
                            List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__linkedin_url__c,MobilePhone, Phone FROM Lead WHERE Id IN :lstIds WITH SECURITY_ENFORCED];
                            scope.addAll(conLst);
                            scope.addAll(ldLst);
                            
                            if(pbs[0].modigie__No_Mobile_Information__c || pbs[0].modigie__Get_linkedin_url__c || pbs[0].modigie__Validate_Employer__c){ 
                                
                                String hour = String.valueOf(Datetime.now().hour());
                                String min = String.valueOf(Datetime.now().minute() + 1); 
                                
                                String ss = String.valueOf(Datetime.now().second());
                                
                                //parse to cron expression
                                String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
                                
                                if(Integer.valueOf(min) > 59 || Test.isRunningTest()){
                                    min = String.valueOf((Integer.valueOf(min)-60));
                                    hour = String.valueOf((Integer.valueOf(hour) + 1));
                                }
                                
                                if(Integer.valueOf(hour) > 23 || Test.isRunningTest()){
                                    hour = String.valueOf((Integer.valueOf(hour) - 24));
                                }
                                InvocablePhoneInsightsSchedulableClass SC = new InvocablePhoneInsightsSchedulableClass(scope,0);
                                System.schedule('Invocable Phone Insights Job ' + hour + ': ' + min + ' : ' + ss, nextFireTime, SC);
                            }
                            
                            else{
                                if(!scope.isEmpty()){
                                    GetPhoneInsightsJobRequestBatchClass batchable = new GetPhoneInsightsJobRequestBatchClass(scope, 0);
                                    Database.executeBatch(batchable,b_size);    
                                }
                                
                                //InvocableGetPhoneInsights.runCallout(lstIds,   creditId, privateKey, serviceAccountCred, APIkey);
                            }
                            
                        }
                    }
                    else{
                        //NotificationServiceClass.sendNotification('Modigie Phone Insights',pbs[0].modigie__Modigie_Phone_Insights_Invocable_Limit_A__c);
                        NotificationServiceClass.sendEmailLimitReached('Modigie Phone Insights', 'modigie__Get_Phone_Insights_Campaign_Limits__c', pbs[0].modigie__Modigie_Phone_Insights_Invocable_Limit__c, pbs[0].modigie__Modigie_Phone_Insights_Invocable_Usage__c, lstIds.size(), pbs[0].modigie__Modigie_Phone_Insights_Invocable_Limit_A__c);
                    }
                }            
            }
            
            else if(modigieService == 'Get Modigie Contact Campaign'){
                if(tokenList.size() > 0){
                    // String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                    String privateKey = tokenList[0].modigie__Private_Key__c;
                    String APIkey = tokenList[0].modigie__API_Key__c;
                    String serviceAccountCred = tokenList[0].modigie__Email__c;
                    
                    List<Contact> conLst = [SELECT Id, Account.Name,Email, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, modigie__Company_URL__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :lstIds WITH SECURITY_ENFORCED];
                    if(!conLst.isEmpty()){
                        ContactBatchForGetModigieButton batchable = new ContactBatchForGetModigieButton(conLst,4);
                        Database.executeBatch(batchable, b_size);    
                    }
                }
            }
            
            else if(modigieService == 'Get Modigie Lead Campaign'){
                if(tokenList.size() > 0){
                    // String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                    String privateKey = tokenList[0].modigie__Private_Key__c;
                    String APIkey = tokenList[0].modigie__API_Key__c;
                    String serviceAccountCred = tokenList[0].modigie__Email__c;
                    List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds WITH SECURITY_ENFORCED];
                    if(!ldLst.isEmpty()){
                        LeadBatchForGetModigieButton batchable = new LeadBatchForGetModigieButton(ldLst,3);
                        Database.executeBatch(batchable,b_size);    
                    }
                    
                }
            }
            
            else if(modigieService == 'Get Linkedin Contact Campaign'){
                if(tokenList.size() > 0)
                {
                    // String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                    String privateKey = tokenList[0].modigie__Private_Key__c;
                    String APIkey = tokenList[0].modigie__API_Key__c;
                    String serviceAccountCred = tokenList[0].modigie__Email__c;
                    
                    
                    List<Contact> conLst = [SELECT Id, Account.Name,Email,Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, modigie__Company_URL__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :lstIds WITH SECURITY_ENFORCED];
                    if(!conLst.isEmpty()){
                        ContactBatchForGetLinkedinButton batchable = new ContactBatchForGetLinkedinButton(conLst,2);
                        Database.executeBatch(batchable,b_size);    
                    }
                    
                }
            }
            
            else if(modigieService == 'Get Linkedin Lead Campaign'){
                if(tokenList.size() > 0)
                {
                    // String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                    String privateKey = tokenList[0].modigie__Private_Key__c;
                    String APIkey = tokenList[0].modigie__API_Key__c;
                    String serviceAccountCred = tokenList[0].modigie__Email__c;
                    
                    List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email,Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds WITH SECURITY_ENFORCED];
                    if(!ldLst.isEmpty()){
                        LeadBatchForGetLinkedInButton batchable = new LeadBatchForGetLinkedInButton(ldLst,2);
                        Database.executeBatch(batchable,b_size);    
                    }
                    
                }
            }
            
            else if(modigieService == 'Verify Employer Campaign'){
                if(tokenList.size() > 0){
                    // String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                    String privateKey = tokenList[0].modigie__Private_Key__c;
                    String APIkey = tokenList[0].modigie__API_Key__c;
                    String serviceAccountCred = tokenList[0].modigie__Email__c;
                    
                    List<Contact> conLst = [SELECT Id, Account.Name,modigie__Company_Email__c, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, Email, modigie__Modigie_Verified_Number__c, modigie__Company_URL__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :lstIds WITH SECURITY_ENFORCED];
                    List<Lead> ldLst = [SELECT Id, FirstName, LastName, modigie__Company_Email__c,Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone, modigie__Modigie_Verified_Number__c, (SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds WITH SECURITY_ENFORCED];
                    List<sObject> lstSobj = new List<sObject>();
                    lstSobj.addAll(conLst);
                    lstSobj.addAll(ldLst);
                    if(!lstSobj.isEmpty()){
                        VerifyEmployerDataMaintainenceClass batchable = new VerifyEmployerDataMaintainenceClass(lstSobj,4);
                        Database.executeBatch(batchable, b_size);    
                    }
                    
                }
            }
            
            else if(modigieService == 'Unresponsive Lead Get Modigie'){
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT Id, modigie__Selected_Lead_Status__c, modigie__Unresponsive_Lead_Get_Modigie_A__c, modigie__Unresponsive_Lead_Get_Modigie_Limit__c, modigie__Unresponsive_Lead_Get_Modigie_Usage__c, modigie__Limits_No_Limits_Selection__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED  LIMIT 1];
                if(pbs.size() > 0){
                    if((pbs[0].modigie__Unresponsive_Lead_Get_Modigie_Limit__c >= pbs[0].modigie__Unresponsive_Lead_Get_Modigie_Usage__c + lstIds.size()) || pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true){
                        List <String> statusList = (List<String>)JSON.deserializeStrict(pbs[0].modigie__Selected_Lead_Status__c,List<String>.class);
                        List <lead> leadList = [select Id, FirstName, LastName, Email, Company, status, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c from lead where status IN :statusList AND Id IN :lstIds];
                        if(!leadList.isEmpty()){
                            LeadBatchForGetModigieButton batchable = new LeadBatchForGetModigieButton(leadList, 1);
                            Database.executeBatch(batchable,b_size);    
                        }
                        
                    }
                    else{
                        //NotificationServiceClass.sendNotification('Unresponsive Lead Get Modigie',pbs[0].modigie__Unresponsive_Lead_Get_Modigie_A__c);
                        NotificationServiceClass.sendEmailLimitReached('Unresponsive Lead Get Modigie', 'modigie__Unresponsive_Lead_Get_Modigie_Limit__c', pbs[0].modigie__Unresponsive_Lead_Get_Modigie_Limit__c, pbs[0].modigie__Unresponsive_Lead_Get_Modigie_Usage__c, lstIds.size(), pbs[0].modigie__Unresponsive_Lead_Get_Modigie_A__c);
                    }
                }
            }
            
            else if(modigieService == 'Unresponsive Lead Verify Employer'){
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT Id, modigie__Selected_Lead_Status__c, modigie__Unresponsive_Lead_Verify_Employer_A__c, modigie__Unresponsive_Lead_Verify_Employer_Limit__c, modigie__Unresponsive_Lead_Verify_Employer_Usage__c,modigie__Limits_No_Limits_Selection__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED  LIMIT 1];
                if(pbs.size() > 0){
                    if((pbs[0].modigie__Unresponsive_Lead_Verify_Employer_Limit__c >= pbs[0].modigie__Unresponsive_Lead_Verify_Employer_Usage__c + lstIds.size()) || pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true){
                        List <String> statusList = (List<String>)JSON.deserializeStrict(pbs[0].modigie__Selected_Lead_Status__c,List<String>.class);
                        
                        System.debug('status list is :::: ' +statusList);
                        
                        // List<Object> statusList = (List<Object>)JSON.deserializeUntyped(lstPbs[0].modigie__Selected_Lead_Status__c);
                        List <lead> leadList = [select Id, FirstName, LastName, Email, Company, status, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c from lead where status IN :statusList AND Id IN :lstIds];
                        System.debug('leads are :::: ' +leadList);
                        if(!leadList.isEmpty()){
                            VerifyEmployerDataMaintainenceClass batchable = new VerifyEmployerDataMaintainenceClass(leadList, 1);
                            Database.executeBatch(batchable,b_size);    
                        }
                    }else{
                        //notification and email
                        //NotificationServiceClass.sendNotification('Unresponsive Lead Verify Employer',pbs[0].modigie__Unresponsive_Lead_Verify_Employer_A__c);
                        NotificationServiceClass.sendEmailLimitReached('Unresponsive Lead Verify Employer', 'modigie__Unresponsive_Lead_Verify_Employer_Limit__c', pbs[0].modigie__Unresponsive_Lead_Verify_Employer_Limit__c, pbs[0].modigie__Unresponsive_Lead_Verify_Employer_Usage__c, lstIds.size(), pbs[0].modigie__Unresponsive_Lead_Verify_Employer_A__c);
                    }
                }
            }
            
            else if(modigieService == 'Invocable Opportunity Contact Role'){
                if(tokenList.size() > 0){
                    
                    List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Selected_Opportunity_Stages__c, modigie__Opportunity_Contact_Get_Modigie_Limit__c, modigie__Opportunity_Contact_Get_Modigie_Usage__c, modigie__Opportunity_Contact_Get_Modigie_A__c, modigie__Limits_No_Limits_Selection__c	 FROM modigie__Process_Builder_Switch__c LIMIT 1];
                    
                    List <string> strList = new List <string>();
                    
                    for(modigie__Process_Builder_Switch__c s : pbs)
                    {
                        strList.add(s.modigie__Selected_Opportunity_Stages__c );
                    }
                    
                    String str = strList[0];
                    str = str.replaceAll('[\\[\\](){}"]','');
                    
                    List<String> strlist1 = str.split(',');
                    
                    
                    List<opportunity> selectedStageOpp = [select id, stageName from opportunity WHERE stageName IN :strList1 AND id = :lstIds];
                    
                    List<id>oppId = new List<id>();
                    for(opportunity o : selectedStageOpp)
                    {
                        oppId.add(o.Id);
                    }
                    
                    List<Contact> conLst = [SELECT Id, Account.Name,Email, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, modigie__Company_URL__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Contact WHERE Id IN (SELECT ContactId FROM OpportunityContactRole WHERE OpportunityId IN :oppId) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c != 'Not started' AND modigie__Status__c != 'Unavailable') AND FirstName != null AND Email != null AND Account.Name != null];
                    if(conLst.size() > 0){
                        
                        
                        if(pbs.size() > 0){
                            System.debug('pbs[0]' + pbs[0]);
                            if((pbs[0].modigie__Opportunity_Contact_Get_Modigie_Limit__c >= pbs[0].modigie__Opportunity_Contact_Get_Modigie_Usage__c + conLst.size()) || pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true){
                                ContactBatchForGetModigieButton batchable = new ContactBatchForGetModigieButton(conLst,2);
                                Database.executeBatch(batchable,b_size);    
                            }else{
                                //send notification and email
                                //NotificationServiceClass.sendNotification('Opportunity Contact Enrichment', pbs[0].modigie__Opportunity_Contact_Get_Modigie_A__c);
                                NotificationServiceClass.sendEmailLimitReached('Opportunity Contact Enrichment', 'modigie__Opportunity_Contact_Get_Modigie_Limit__c', pbs[0].modigie__Opportunity_Contact_Get_Modigie_Limit__c, pbs[0].modigie__Opportunity_Contact_Get_Modigie_Usage__c, conLst.size(), pbs[0].modigie__Opportunity_Contact_Get_Modigie_A__c);
                            }
                        }
                    }
                    
                }
            }
            else if(modigieService == 'Dynamic Criteria Get Modigie Lead'){
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Dynamic_Criteria_Automation_Limit__c, modigie__Dynamic_Criteria_Automation_Usage__c, modigie__Limits_No_Limits_Selection__c, modigie__Dynamic_Criteria_Automation_A__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                List<Lead> lstLead = [SELECT Id, FirstName, LastName, Email, Company, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds AND FirstName != null AND LastName != null AND Company != null AND (Email != null OR modigie__linkedin_url__c != null) AND Id NOT IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Status__c != null) WITH SECURITY_ENFORCED];
                if(!lstLead.isEmpty() && !pbs.isEmpty()){
                    if(pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c == null){
                        pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c = 0;
                        update pbs;
                    }
                    if(pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c == null){
                        pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c = 0;
                        update pbs;
                    }
                    if(pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true ||(pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c >= pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c + lstLead.size())){
                        if(!tokenList.isEmpty()){
                            //  List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds WITH SECURITY_ENFORCED];
                            
                            
                            LeadBatchForGetModigieButton batchable = new LeadBatchForGetModigieButton(lstLead, 4);
                            Database.executeBatch(batchable,b_size);    
                            
                            
                        }    
                    }
                    else{
                        //NotificationServiceClass.sendNotification('Sales Engagement Automation Module', pbs[0].modigie__Dynamic_Criteria_Automation_A__c);
                        NotificationServiceClass.sendEmailLimitReached('Sales Engagement Automation Module', 'modigie__Dynamic_Criteria_Automation_Limit__c', pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c, pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c, lstLead.size(), pbs[0].modigie__Dynamic_Criteria_Automation_A__c);
                    }
                }    
            }
            else if(modigieService == 'Dynamic Criteria Get Modigie Contact'){
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Dynamic_Criteria_Automation_Limit__c, modigie__Dynamic_Criteria_Automation_Usage__c, modigie__Limits_No_Limits_Selection__c, modigie__Dynamic_Criteria_Automation_A__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                List<Contact> lstCon = [SELECT Id, FirstName, LastName, Email, Account.Name, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Contact WHERE Id In :lstIds AND FirstName != null AND LastName != null AND Account.Name != null AND (Email != null OR modigie__linkedin_url__c != null) AND Id NOT IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c != null)  WITH SECURITY_ENFORCED];
                
                if(!lstCon.isEmpty() && !pbs.isEmpty()){
                    if(pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c == null){
                        pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c = 0;
                        update pbs;
                    }
                    if(pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c == null){
                        pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c = 0;
                        update pbs;
                    }
                    if(pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true ||(pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c >= pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c + lstCon.size())){
                        if(!tokenList.isEmpty()){
                            //  List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds WITH SECURITY_ENFORCED];
                            
                            
                            ContactBatchForGetModigieButton batchable = new ContactBatchForGetModigieButton(lstCon, 4);
                            Database.executeBatch(batchable,b_size);    
                            
                            
                        }    
                    }
                    else{
                        //NotificationServiceClass.sendNotification('Sales Engagement Automation Module', pbs[0].modigie__Dynamic_Criteria_Automation_A__c);
                        NotificationServiceClass.sendEmailLimitReached('Sales Engagement Automation Module', 'modigie__Dynamic_Criteria_Automation_Limit__c', pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c, pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c, lstCon.size(), pbs[0].modigie__Dynamic_Criteria_Automation_A__c);
                    }
                }    
            }
            
        }
        catch(Exception e){
            //call here Error Email
            EmailServiceClass.sendErrorEmail('ModigieServicesAsychronousSchedulable Error', e);
            /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>{'pratik@cyntexa.com','ashishsharma@cyntexa.com'};
                if(!toAddresses.isEmpty()){
                    mail.setToAddresses(toAddresses);
                    mail.saveAsActivity= false;
                    mail.setSubject('Modigie : ModigieServicesAsychronousSchedulable Error');
                    String emailBody = 'Please check the error message - ' + e.getMessage();
                    emailBody += '\nLine Number : ' + e.getLineNumber();
                    emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
                    emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
                    mail.setPlainTextBody(emailBody);
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }*/
        }
        finally{
            CronTrigger ct = [SELECT PreviousFireTime  FROM CronTrigger WHERE Id = :ctx.getTriggerId() WITH SECURITY_ENFORCED];
            System.abortJob(ct.Id);    
        }
    }
}