global with sharing class InvocableGetModigieContactClass 
{
    global static boolean var = true;
    @InvocableMethod
    global static void getRecordId(List<String> lstIds)
    {
        try{
            if(var){
                var = false;
                String userToken;
                String useremail;
                String recordId = lstIds[0];
                
                List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
                
                List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
                
                
                
                if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credit__c') &&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','Name') &&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Used__c') &&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Purchased__c') &&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Remaining__c') &&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Validation_Key__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c'))
                {
                    modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c LIMIT 1];
                    
                    
                    if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c'))
                    {
                        modiList = [SELECT Name, modigie__Contact__c, modigie__Status__c FROM modigie__Modigie__c WHERE modigie__Contact__c =: recordId LIMIT 1];
                    }
                    
            //     if(tokenList.size() > 0 && modiCredit.size() > 0 && modiCredit[0].modigie__Remaining__c > 0 && modiList.size() == 0)
                    {
                        InvocableGetModigieContactClass.runCallout(recordId, userToken, useremail);
                    }
                }
                else
                {
                    throw new InvocableException('User does not have needed permissions for Modigie Credit object and/or fields.');
                }
            }
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('InvocableGetModigieContactClass', e);
        }
        
    }
    
    @future(Callout=true)
    public static void runCallout(String recordId, String userToken, String useremail)
    {
       /* try
        {
            List<Contact> conList = new List<Contact>();
            List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
            Boolean canMakeCallout = false;
            // Generate 11 digit jobid 
            
            
            
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credit__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','Name') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Used__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Purchased__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Remaining__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c')){
                modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c LIMIT 1];
            }
            else{
                throw new InvocableException('User does not have needed permissions for Modigie Credit object and/or fields.');
            }
            
            Id recId = recordId;
            String sobjectType = recId.getSObjectType().getDescribe().getName();
            
            if(sobjectType?.equalsIgnoreCase('Contact') == true){
            
            
                if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Get_Modigie_Job_Status__c')){
                                    
                        List<modigie__Modigie__c>   modiList = [SELECT Name, modigie__Contact__c, modigie__Status__c,modigie__Get_Modigie_Job_Status__c FROM modigie__Modigie__c WHERE modigie__Contact__c =:recordId LIMIT 1];
                        
                        if(modiList.size() == 1){
                            
                            if(modiList[0].modigie__Get_Modigie_Job_Status__c == null){
                                canMakeCallout = true;    
                            }
                        }
                        
                        else if(modiList.size() == 0){
                            canMakeCallout = true;
                        }
                    }
                            
                    else{
                        throw new InvocableException('User does not have needed permissions for Modigie object and/or fields.');
                    }
                
                
                


                    if(canMakeCallout){
                        if(FieldLevelSecurityCheck.canReadObject('Contact') &&
                        FieldLevelSecurityCheck.canReadField('Contact','AccountId') &&
                        FieldLevelSecurityCheck.canReadField('Contact','FirstName') &&
                        FieldLevelSecurityCheck.canReadField('Contact','LastName') &&
                        FieldLevelSecurityCheck.canReadField('Contact','Email')&&
                        FieldLevelSecurityCheck.canReadField('Contact','modigie__linkedin_url__c')&&
                        FieldLevelSecurityCheck.canReadField('Contact','modigie__Company_URL__c')&&
                        FieldLevelSecurityCheck.canReadField('Contact','modigie__Modigie_Verified_Number__c')&&
                        FieldLevelSecurityCheck.canReadField('Contact','modigie__Validation_Key__c')&&
                        FieldLevelSecurityCheck.canReadObject('Account') &&
                        FieldLevelSecurityCheck.canReadField('Account','Name')){
                        
                                List<modigie__Modigie__c> modiList = [SELECT Name, modigie__Contact__c, modigie__Status__c,modigie__Get_Modigie_Job_Status__c FROM modigie__Modigie__c WHERE modigie__Contact__c =: recordId LIMIT 1];
                            
                                conList = [SELECT Id,  FirstName, LastName, Email, modigie__Modigie_Verified_Number__c,MobilePhone, modigie__linkedin_url__c, modigie__Company_URL__c, modigie__Validation_Key__c,Account.Name,Account.BillingCity,Account.BillingStreet,Account.BillingPostalCode,Account.BillingState,Account.BillingCountry FROM Contact Where Id =: recordId LIMIT 1];
                                
                                Http http = new Http();
                                HttpRequest request = new HttpRequest();
                                request.setMethod('POST');
                                request.setHeader('accept', 'application/json');
                                request.setHeader('Content-Type', ' application/json');
                                request.setEndpoint('https://virtserver.swaggerhub.com/Qyberion/val/1.0.0/jobrequests');
                                request.setTimeout(120000);

                                Map<String,Object> outerMap = new Map<String,Object>();
                                
                                        
                                outerMap.put('custom1', 'String');
                                outerMap.put('custom2', 'String');
                                outerMap.put('custom3', 'String');

                                Map<String,Object> sinCon = new Map <String,Object>();
                                        
                                        if(conList[0].FirstName != null){
                                            sinCon.put('firstName',conList[0].FirstName);    
                                        }
                                        
                                        if(conList[0].LastName != null){
                                            sinCon.put('lastName',conList[0].LastName);
                                        }
                                        
                                        if(conList[0].Account.Name != null){
                                            sinCon.put('company',conList[0].Account.Name);
                                        }
                                    
                                        
                                        if(conList[0].email != null){
                                            sinCon.put('otherEmails',new List <String>{conList[0].email});    
                                        }
                                        
                                        if(conList[0].MobilePhone != null){
                                            sinCon.put('mobilePhone',conList[0].MobilePhone);
                                        }
                                        
                                        
                                        Map<String,Object> companyAddress = new Map<String,Object>();
                                    
                                        if(conList[0].Account.BillingStreet != null){
                                            companyAddress.put('streetLine',conList[0].Account.BillingStreet);
                                        }

                                                                                                        

                                        if(conList[0].Account.BillingPostalCode != null){
                                            companyAddress.put('zip',conList[0].Account.BillingPostalCode);
                                        }
                                        
                                        if(conList[0].Account.BillingCity != null){
                                            companyAddress.put('city',conList[0].Account.BillingCity);   
                                        }
                                        
                                        if(conList[0].Account.BillingState != null){
                                            companyAddress.put('state',conList[0].Account.BillingState);   
                                        }
                                        
                                        if(conList[0].Account.BillingCountry != null){
                                            companyAddress.put('country',conList[0].Account.BillingCountry);
                                        }
                                        
                                        sinCon.put('companyAddress',companyAddress);
                                        
                                        if(conList[0].modigie__linkedin_url__c != null){
                                            sinCon.put('linkedInUrl',conList[0].modigie__linkedin_url__c);    
                                        }
                                        
                                        sinCon.put('custom1','string');
                                        
                                        outerMap.put('contacts',new List<Map<String,Object>>{sinCon});
                                        
                                        
                                        request.setBody(JSON.serialize(outerMap));

                                        HttpResponse response = http.send(request);

                                        String jsonResponse = response.getBody();
                                        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                                        Map<String,Object> jobData = (Map<String,Object>)responseMap.get('job');
                                        String jobid = jobData.get('id').toString();

                                        modigie__Modigie__c modiRec = new modigie__Modigie__c();

                                        if(modiList.size() > 0){
                                            modiRec.Id = modiList[0].Id;
                                        }

                                        modirec.modigie__Validation_Date_Get_Mobile_Number__c = Date.today();
                                        modiRec.modigie__Status__c = 'In process';
                                        modiRec.modigie__Jobid__c = jobid;
                                        modiRec.modigie__Contact__c = conList[0].id;
                                        modiRec.modigie__Parent_Id__c = conList[0].id;
                                    
                                        
                                        String status = jobData.get('status').toString();

                                        status = status.substring(0, 1).toUpperCase() + status.substring(1, status.length());
                                        

                                        modiRec.modigie__Get_Modigie_Job_Status__c = status;
                                        
                                        modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                                        
                                        upsert modiRec;

                    }
                }
        
            }

            
            
            else if(sobjectType?.equalsIgnoreCase('Lead') == true){
                
                
                if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c') &&
                    FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Get_Modigie_Job_Status__c')){
                                    
                        List<modigie__Modigie__c>   modiList = [SELECT Name, modigie__Contact__c, modigie__Status__c,modigie__Get_Modigie_Job_Status__c FROM modigie__Modigie__c WHERE modigie__Lead__c =:recordId LIMIT 1];
                        
                        if(modiList.size() == 1){
                            
                            if(modiList[0].modigie__Get_Modigie_Job_Status__c == null){
                                canMakeCallout = true;    
                            }
                        }
                        
                        else if(modiList.size() == 0){
                            canMakeCallout = true;
                        }
                    }
                            
                    else{
                        throw new InvocableException('User does not have needed permissions for Modigie object and/or fields.');
                    }
                
                
                


                    if(canMakeCallout){
                        if(FieldLevelSecurityCheck.canReadObject('Lead') &&
                        
                        FieldLevelSecurityCheck.canReadField('Lead','FirstName') &&
                        FieldLevelSecurityCheck.canReadField('Lead','LastName') &&
                        FieldLevelSecurityCheck.canReadField('Lead','Email')&&
                        FieldLevelSecurityCheck.canReadField('Lead','modigie__linkedin_url__c')&&
                        FieldLevelSecurityCheck.canReadField('Lead','modigie__Company_URL__c')&&
                        FieldLevelSecurityCheck.canReadField('Lead','modigie__Modigie_Verified_Number__c')&&
                        FieldLevelSecurityCheck.canReadField('Lead','modigie__Validation_Key__c')){
                        
                                List<modigie__Modigie__c> modiList = [SELECT Name, modigie__Lead__c, modigie__Status__c,modigie__Get_Modigie_Job_Status__c FROM modigie__Modigie__c WHERE modigie__Lead__c =: recordId LIMIT 1];
                            
                                
                                
                                List <Lead> ldList = [SELECT Id, FirstName, LastName, Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone FROM Lead Where Id =: recordId LIMIT 1];
                                
                                Http http = new Http();
                                HttpRequest request = new HttpRequest();
                                request.setMethod('POST');
                                request.setHeader('accept', 'application/json');
                                request.setHeader('Content-Type', ' application/json');
                                request.setEndpoint('https://virtserver.swaggerhub.com/Qyberion/val/1.0.0/jobrequests');
                                request.setTimeout(120000);

                                Map<String,Object> outerMap = new Map<String,Object>();
                                        
                                outerMap.put('custom1', 'String');
                                outerMap.put('custom2', 'String');
                                outerMap.put('custom3', 'String');

                                Map<String,Object> sinCon = new Map <String,Object>();
                                        
                                        if(ldList[0].FirstName != null){
                                            sinCon.put('firstName',ldList[0].FirstName);    
                                        }
                                        
                                        if(ldList[0].LastName != null){
                                            sinCon.put('lastName',ldList[0].LastName);
                                        }
                                        
                                        if(ldList[0].company != null){
                                            sinCon.put('company',ldList[0].company);
                                        }
                                    
                                        
                                        if(ldList[0].email != null){
                                            sinCon.put('otherEmails',new List <String>{ldList[0].email});    
                                        }
                                        
                                        if(ldList[0].MobilePhone != null){
                                            sinCon.put('mobilePhone',ldList[0].MobilePhone);
                                        }
                                        
                                        
                                       
                                        
                                        if(ldList[0].modigie__linkedin_url__c != null){
                                            sinCon.put('linkedInUrl',ldList[0].modigie__linkedin_url__c);    
                                        }
                                        
                                        sinCon.put('custom1','string');
                                        
                                        outerMap.put('contacts',new List<Map<String,Object>>{sinCon});
                                        
                                        
                                        request.setBody(JSON.serialize(outerMap));

                                        HttpResponse response = http.send(request);

                                        String jsonResponse = response.getBody();
                                        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                                        Map<String,Object> jobData = (Map<String,Object>)responseMap.get('job');
                                        String jobid = jobData.get('id').toString();

                                        modigie__Modigie__c modiRec = new modigie__Modigie__c();

                                        if(modiList.size() > 0){
                                            modiRec.Id = modiList[0].Id;
                                        }

                                        modirec.modigie__Validation_Date_Get_Mobile_Number__c = Date.today();
                                        modiRec.modigie__Status__c = 'In process';
                                        modiRec.modigie__Jobid__c = jobid;
                                        modiRec.modigie__Lead__c = ldList[0].id;
                                        modiRec.modigie__Parent_Id__c = ldList[0].id;
                                    
                                        
                                        String status = jobData.get('status').toString();

                                        status = status.substring(0, 1).toUpperCase() + status.substring(1, status.length());
                                        

                                        modiRec.modigie__Get_Modigie_Job_Status__c = status;
                                        
                                        modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                                        
                                        upsert modiRec;

                    }
                }
            }
        }
        
        catch(Exception e)
        {
        }*/
    }
    public class InvocableException extends Exception{}
}