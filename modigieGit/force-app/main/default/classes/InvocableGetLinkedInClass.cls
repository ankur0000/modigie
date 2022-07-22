global with sharing class InvocableGetLinkedInClass 
{
    global static boolean var = true;
    @InvocableMethod
    global static void getRecordId(List<String> lstIds)
    {   
        try{
            if(var){
                var = false;
            
                String recordId = lstIds[0];
                
                List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
                
                
                List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
                tokenList = [SELECT Name, modigie__Credits_Account_Id__c,modigie__API_Key__c,modigie__Service_Account_Credentials__c,modigie__Private_Key__c FROM modigie__Modigie_Credentials__c  WITH SECURITY_ENFORCED LIMIT 1];
                if(tokenList.size() > 0)
                    {
                String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                String privateKey = tokenList[0].modigie__Private_Key__c;
                String APIkey = tokenList[0].modigie__API_Key__c;
                String serviceAccountCred = tokenList[0].modigie__Service_Account_Credentials__c;
                
                    
                
                    
                        InvocableGetLinkedInClass.runCallout(recordId,  creditId, privateKey, serviceAccountCred, APIkey);
                    }
            }
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('InvocableGetLinkedInClass', e);
        }
    } 
    
    @future(Callout=true)
    public static void runCallout(String recordId, String creditId, String privateKey, String serviceAccountCred, String APIkey)
    {
        
         try{
            Id recid = recordId;
            
            String sobjectType = recid.getSObjectType().getDescribe().getName();
            
            String query = 'SELECT Id,FirstName,LastName,MobilePhone,Email,modigie__linkedin_url__c,';
            
            Continuation con = new Continuation(120);
            
            if(sobjectType?.equalsIgnoreCase('Contact') == true){
                query += 'AccountId FROM Contact';
            }
            
            else if(sobjectType?.equalsIgnoreCase('Lead') == true){
                query += 'Company,Street,PostalCode,City,State,Country FROM Lead';
            }
            
            query += ' WHERE Id = :recid WITH SECURITY_ENFORCED LIMIT 1';
            
                List<SObject> lstSobj = Database.query(query);
               
                if(lstSobj.size() > 0 && (lstSobj[0].get('FirstName') != null && lstSobj[0].get('LastName') != null &&  lstSobj[0].get('Email') != null && ((sobjectType?.equalsIgnoreCase('Contact') == true && lstSobj[0].get('AccountId')!= null)||(sobjectType?.equalsIgnoreCase('Lead') == true && lstSobj[0].get('Company')!= null)))){
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setMethod('POST');

                    String accessToken = 'Bearer ' + jwtapex.get_access_token(serviceAccountCred,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',privateKey);
                    //String accessToken = 'Bearer ' + jwtapex.get_access_token(serviceAccountCred,'https://modigie-engage-backend-kyaxv4ttua-uc.a.run.app',privateKey);
                    request.setHeader('Content-Type', 'application/json'); 
                    request.setHeader('Authorization', accessToken);
                    request.setHeader('x-api-key', APIkey); 
                    request.setEndpoint('https://modigie-engage-gateway-bqqdnyh5lq-uc.a.run.app/api/v1/linkedInUrlJobs'); //Production Environment Endpoints
                    //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/linkedInUrlJobs?key=' + APIkey); //Staging Environment Endpoints

                    
                    Map<String,Object> outerMap = new Map<String,Object>();
                    
                    outerMap.put('creditsId', creditId);
                   
                    
                    Map<String,Object> sinCon = new Map <String,Object>();
                    
                    if(lstSobj[0].get('FirstName') != null){
                        sinCon.put('firstName',lstSobj[0].get('FirstName'));    
                    }
                    
                    if(lstSobj[0].get('LastName') != null){
                        sinCon.put('lastName',lstSobj[0].get('LastName'));
                    }
                    
                    if(sobjectType?.equalsIgnoreCase('Contact') == true){
                        String accId = lstSobj[0].get('AccountId').toString();
                        
                               List<Account> acc = [SELECT Name FROM Account WHERE Id = :accId WITH SECURITY_ENFORCED LIMIT 1];
                               sinCon.put('company', acc[0].Name);
                    }
                    
                    else if(sobjectType?.equalsIgnoreCase('Lead') == true){
                        sinCon.put('company', lstSobj[0].get('Company'));
                    }
                    
                    if(lstSobj[0].get('Email') != null){
                        sinCon.put('companyEmail', lstSobj[0].get('Email'));
                    }
                    
                 
                    
                    if(lstSobj[0].get('MobilePhone') != null){
                        sinCon.put('mobilePhone',lstSobj[0].get('MobilePhone'));
                    }
                    
                    if(lstSobj[0].get('modigie__linkedin_url__c') != null){
                        sinCon.put('linkedInUrl',lstSobj[0].get('modigie__linkedin_url__c'));
                    }
                    

                    Map<String,String> customParaMap = new Map<String,String>();

                    customParaMap.put('name', 'recordIdAndOrgId');
                    customParaMap.put('value', lstSobj[0].get('Id') + UserInfo.getOrganizationId());

                    List<Map<String,String>> lstMap = new List<Map<String,String>>();

                    lstMap.add(customParaMap);
                    sinCon.put('customParameters',lstMap);
                    
                    outerMap.put('contacts',new List<Map<String,Object>>{sinCon});
                    
                    
                    request.setBody(JSON.serialize(outerMap));
                    
                    request.setTimeout(120000);
                    
                    HttpResponse response = http.send(request);
                    
                    if (response.getStatusCode() == 202){
                        String resMap = response.getBody();
                        String jobid;
                        String modiRecId;
                        List<modigie__Modigie__c> listToUpsert = new List<modigie__Modigie__c>();
                        
                        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(resMap);
                        Map<String,Object> jobData = (Map<String,Object>)responseMap.get('job');
                        jobid = responseMap.get('id').toString();
                        
                        Map<String, String> securityMap = new Map<String, String>();
                        securityMap.put('modigie__Linkedin_Job_Id__c', 'modigie__Modigie__c');
                        securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
                        securityMap.put('modigie__Get_LinkedIn_Job_Status__c', 'modigie__Modigie__c');
                        securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
                        securityMap.put('modigie__Validation_Date_Get_LinkedIn__c', 'modigie__Modigie__c');
                        securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
                        securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
                        securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
                        
                        Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap); 
                        
                        List<modigie__Modigie__c>    mrec = [Select Name, modigie__Job_start__c, modigie__Job_end__c, modigie__Jobid__c, modigie__Mobile__c, modigie__Status__c, modigie__Contact__c, modigie__Lead__c,modigie__Validation_Date_Get_Mobile_Number__c, modigie__Validation_Key__c, modigie__Parent_Id__c,modigie__Get_Modigie_Job_Status__c FROM modigie__Modigie__c Where modigie__Parent_Id__c =: recid WITH SECURITY_ENFORCED LIMIT 1];
                        if(mrec.size() == 1){
                            
                            mrec[0].modigie__Linkedin_Job_Id__c = jobid;
                            mrec[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                            String statusGetModigie = responseMap.get('status').toString();
                            statusGetModigie = statusGetModigie.substring(0, 1).toUpperCase() + statusGetModigie.substring(1, statusGetModigie.length());
                            mrec[0].modigie__Get_LinkedIn_Job_Status__c = statusGetModigie;
                            mrec[0].modigie__Linkedin_Status__c = 'In process'; 
                            mrec[0].modigie__Validation_Date_Get_LinkedIn__c = Date.today();
                            mrec[0].modigie__Parent_Id__c = recid;
                            
                           
                            listToUpsert.add(mrec[0]);
                            modiRecId = mrec[0].Id;
                            
                        }
                        else if(mrec.size() == 0){
                            
                            modigie__Modigie__c modirec = new modigie__Modigie__c();
                            
                            modirec.modigie__Linkedin_Job_Id__c = jobid;
                            modirec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                            
                            if(sobjectType?.equalsIgnoreCase('Contact') == true){
                                modirec.modigie__Contact__c = recid;
                            }
                            else if(sobjectType?.equalsIgnoreCase('Lead') == true){
                                modirec.modigie__Lead__c = recid;
                            }
                            String statusGetModigie = responseMap.get('status').toString();
                            
                            statusGetModigie = statusGetModigie.substring(0, 1).toUpperCase() + statusGetModigie.substring(1, statusGetModigie.length());
                            
                            modirec.modigie__Get_LinkedIn_Job_Status__c = statusGetModigie;
                          
                            modirec.modigie__Linkedin_Status__c = 'In process';
                            modirec.modigie__Validation_Date_Get_LinkedIn__c = Date.today();
                            modirec.modigie__Parent_Id__c = recid;
                            
                           
                            listToUpsert.add(modirec); 
                            modiRecId = modirec.Id;
                        }
                        
                        if(check){
                            upsert listToUpsert;
                        }
                        System.Queueable job = new CreditInfoQueableClass();
                        System.enqueueJob(job);
                    }
                    else{
                        if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
                            EmailServiceClass.sendResponseError('InvocableGetLinkedInClass', response.getStatusCode(), response.getBody());
                        }
                        Map<String, String> errorLogSecurityMap = new Map<String, String>();
                        errorLogSecurityMap.put('modigie__Description__c', 'modigie__Error_Log__c');
                        errorLogSecurityMap.put('modigie__Error_Code__c', 'modigie__Error_Log__c');
                        errorLogSecurityMap.put('modigie__Modigie_Service__c', 'modigie__Error_Log__c');
                        errorLogSecurityMap.put('modigie__Validation_Key__c', 'modigie__Error_Log__c');
                        errorLogSecurityMap.put('modigie__Contact__c', 'modigie__Error_Log__c');
                        errorLogSecurityMap.put('modigie__Lead__c', 'modigie__Error_Log__c');
                        Boolean check = FieldLevelSecurityCheck.checkSecurity(errorLogSecurityMap);
                        
                        modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
                        String jsonResponse = response.getBody();
                        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                        modigieErrorLog.modigie__Description__c = (String)responseMap.get('message');
                        modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
                        modigieErrorLog.modigie__Modigie_Service__c = 'Get LinkedIn';
                        modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                        if(sobjectType?.equalsIgnoreCase('Contact') == true){
                            modigieErrorLog.modigie__Contact__c = recid;
                        }
                        else if(sobjectType?.equalsIgnoreCase('Lead') == true){
                            modigieErrorLog.modigie__Lead__c = recid;
                        }
                        
                        if(check){
                            insert modigieErrorLog;
                        }

                        Set <String> messages = new Set<String>{(String)responseMap.get('message')};
                        if(!Test.isRunningTest()){
                        	EmailServiceClass.sendEmailForCampaign(messages);        
                        }
                    }
                } 
            
        
        
            }
            catch(Exception e){
            }
            
        
    }
    public class InvocableException extends Exception{}
}