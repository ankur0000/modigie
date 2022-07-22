global with sharing class InvocableOpportunityContactRoleClass { 
    global static boolean var = true;
    @InvocableMethod
    global static void getRecordId(List<String> lstIds){
        try{ 
            System.debug('In opp contact enrichment');
            if(FieldLevelSecurityCheck.canReadObject('Contact')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Validation_Key__c'))
            {
                if(System.isBatch()){
                    Datetime timeToSchedule = System.now().addMinutes(2);
                    ModigieServicesAsychronousSchedulable schedulable = new ModigieServicesAsychronousSchedulable(lstIds,'Invocable Opportunity Contact Role');
                    System.schedule('Invocable OpportunityContactRole Batch Class ' + System.now().addMinutes(2) + Math.round((Math.random() * (9000) + 1000)), timeToSchedule.second() + ' ' + timeToSchedule.minute() + ' ' + timeToSchedule.hour() + ' ' + timeToSchedule.day() + ' ' + timeToSchedule.month() + ' ? ' + timeToSchedule.year(), schedulable);
                }
                else{
                    List<modigie__Modigie_Service_Account__mdt> lstCredential = ModigieApiUtils.getServiceAccountDetails();
                    if(lstCredential.size() > 0){
                        
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
                                    Integer b_size = 100;
                                    try{
                                        b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                                        if(b_size > 100 || b_size < 1){
                                            b_size = 100;
                                        }
                                    }catch(Exception e){}
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
            }
            
        }
        catch(ServerErrorException e){
            //?
            Map <String,Object> errorMap = (Map <String,Object>)JSON.deserializeUntyped(e.getMessage());
            errorMap.put('ModigieService','Get Modigie'); 
            System.debug(e.getMessage());
            
            EmailServiceClass.sendEmail(JSON.serialize(errorMap));
        }
        catch(Exception e){
            EmailServiceClass.sendErrorEmail('InvocableOpportunityContactRoleClass', e);
            System.debug(e.getMessage());
        }  
    }
    
}