public with sharing class ContactBatchForModigieLinkedInMapping implements Database.Batchable<sObject>{
    String altLinkedInApiName;
    List<Contact> conLst = new List<Contact>();
    String campaignId;
    String accessToken;

    public ContactBatchForModigieLinkedInMapping(List<Contact> conLst,String recId, String accessToken, String altLinkedInApiName) {
        this.conLst = conLst;
        campaignId = recId;
        this.accessToken = accessToken;
        this.altLinkedInApiName = altLinkedInApiName;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, modigie__linkedin_url__c , ' + altLinkedInApiName + ' FROM Contact WHERE Id IN :conLst AND ' + altLinkedInApiName + ' != null WITH SECURITY_ENFORCED');
    }
    public void execute(Database.BatchableContext bc, List<Contact> scope){
        
            try{
                List<Contact> conToUpdate = new List<Contact>();

                for(Contact con : scope){
                    if(FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__linkedin_url__c') && FieldLevelSecurityCheck.canReadField('Contact', altLinkedInApiName) && con.modigie__linkedin_url__c != String.valueOf(con.get(altLinkedInApiName)) && GetModigieButton.checkValidLinkedInUrl(String.valueOf(con.get(altLinkedInApiName)) )){
                        con.modigie__linkedin_url__c = String.valueOf(con.get(altLinkedInApiName));
                        conToUpdate.add(con);
                    }
                }  
                if(!conToUpdate.isEmpty())
                update conToUpdate;
            }
            catch(Exception e){
                //call here Error Email
                EmailServiceClass.sendErrorEmail('ContactBatchForModigieLinkedInMapping Error', e);
                /*
                try{
                    List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [SELECT Id, modigie__Error_Message__c FROM modigie__Modigie_Batch_Class_Internal_Error_List__c];
                    List<String> lstStrErr = new List<String>();
                    for(modigie__Modigie_Batch_Class_Internal_Error_List__c batchClassError : lstBatchClassError){
                        lstStrErr.add(batchClassError.modigie__Error_Message__c);
                    }
                    
                    if(!lstStrErr.contains(e.getMessage())){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<String> toAddresses = new List<String>();
                        toAddresses.add('pratik@cyntexa.com');
                        toAddresses.add('ashishsharma@cyntexa.com');
                        if(!toAddresses.isEmpty()){
                            mail.setToAddresses(toAddresses);
                            mail.saveAsActivity= false;
                            mail.setSubject('Modigie : ContactBatchForModigieLinkedInMapping Error');
                            String emailBody = 'Please check the error message - ' + e.getMessage();
                            emailBody += '\nLine Number : ' + e.getLineNumber();
                            emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
                            emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
                            mail.setPlainTextBody(emailBody);
                            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            insert new modigie__Modigie_Batch_Class_Internal_Error_List__c(Name =String.valueOf(lstBatchClassError.size()+1), modigie__Error_Message__c = e.getMessage());
                        }
                    }
                    System.debug('e.getLineNumber() --> ' + e.getLineNumber());    
                }
                catch(Exception exx){
                    
                }*/
                
                //throw new InvocableDynamiCritriaGetModigieLeadException(e.getMessage());
            }
    }
    public void finish(Database.BatchableContext bc){
        ContactBatchForGetModigieButton batchable = new ContactBatchForGetModigieButton(conLst,campaignId,accessToken);
        Integer b_size = 100;
        try{
            b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
            if(b_size > 100 || b_size < 1){
                b_size = 100;
            }
        }catch(Exception e){}
        Database.executeBatch(batchable, b_size);
    }
}