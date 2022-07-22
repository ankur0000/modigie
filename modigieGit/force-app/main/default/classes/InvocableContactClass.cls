global with sharing class InvocableContactClass 
{
    global static boolean var = true;
    @InvocableMethod
    global static void getRecordId(List<String> lstIds)
    {
      /*  if(var){
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
                
               
            }
            else
            {
                throw new InvocableException('User does not have needed permissions for Modigie Credit object and/or fields.');
            }
        }*/
        
    }
    
    @future(Callout=true)
    public static void runCallout(String recordId, String userToken, String useremail)
    {
      /*  try
        {
            String jobid;
            String companyname;
            
            List<Contact> conList = new List<Contact>();
            List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
            
            // Generate 11 digit jobid 
            Integer len = 11;
            String str = string.valueof(Math.abs(Crypto.getRandomLong()));
            jobid = str.substring(0, len);
            
            
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credit__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','Name') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Used__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Purchased__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Remaining__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c'))
            {
                modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c LIMIT 1];
            }
            else
                            {
                                throw new InvocableException('User does not have needed permissions for Modigie Credit object and/or fields.');
                            }
            
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
               FieldLevelSecurityCheck.canReadField('Account','Name'))
            {
                conList = [SELECT Id, Account.Name, FirstName, LastName, Email, modigie__Modigie_Verified_Number__c, modigie__linkedin_url__c, modigie__Company_URL__c, modigie__Validation_Key__c FROM Contact Where Id =: recordId LIMIT 1];
                
                
                companyname = conList[0].Account.Name;
                if(companyname != null && companyname.contains(' '))
                    companyname= companyname.replaceAll(' ', '');
                
                if(conList[0].FirstName == null || conList[0].FirstName == '' || conList[0].FirstName == 'undefined')
                    conList[0].FirstName = 'NA';
                
                
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');
                request.setHeader('Content-Length', '4096');
                request.setBody('');
                request.setEndpoint('https://script.google.com/macros/s/AKfycbwDks3QIefh2jzEWIjoiR2--gE_CwownQ9IQwdo28bwVoPl2jom/exec?user_email='+useremail+'&user_token='+userToken+'&jobid='+jobid+'&fname='+conList[0].FirstName+'&lname='+conList[0].LastName+'&email='+conList[0].Email+'&company='+companyname+'&linkedin_url='+conList[0].modigie__linkedin_url__c+'&para_1=&para_2=&para_3=&type=validation&job_type=new');
                request.setTimeout(120000);
                
                String jobstart = Datetime.now().format('hh:mm:ss');
                String[] strTimeSplit = jobstart.split(':');
                Time startjob = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                 ,Integer.valueOf(strTimeSplit[1]) //min
                                                 ,Integer.valueOf(strTimeSplit[2]) //sec
                                                 ,0); 
                
                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200)
                {
                    //String jsonResponse = '{"status": "VALIDATED","credits_left": 97,"user": {"user_email": "shihankatupwork@gmail.com","user_token": "e3d900bc7a5da3d33dba097cd0eb3e15cb45de4a2c35bae0f89f0f3329dc823f"},"person": {"first_name": "Brian","last_name": "Read","email": "brianread@umpquabank.com","company": "Umpqua Bank","linkedin_url": "https://www.linkedin.com/in/brian-j-read-65569a8"},"results": {"jobid": "33322211106","client": "shihankhan.com","phones": ["5098636716"]},"optional": {"parameter_1": "sk_api_006","parameter_2": "sk_6","parameter_3": "sk_test_6"}}';
                    String jsonResponse = response.getBody();
                    
                    Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                    Map<String,Object> result_data = (Map<String,Object>)resMap.get('results');
                    object status = resMap.get('status');
                    Object credits = resMap.get('credits_left');
                    String phoneNumber = String.valueOf(result_data.get('phones'));
                    phoneNumber = phoneNumber.replaceAll('\\p{P}','');
                    
                    
                    String jobend = Datetime.now().format('hh:mm:ss');
                    String[] strTimeSplit1 = jobend.split(':');
                    Time endjob = Time.newInstance( Integer.valueOf(strTimeSplit1[0]) //hour
                                                   ,Integer.valueOf(strTimeSplit1[1]) //min
                                                   ,Integer.valueOf(strTimeSplit1[2]) //sec
                                                   ,0); 
                    
                    if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Jobid__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Job_start__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Job_end__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Parent_Id__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c') &&
                       FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Jobid__c')&&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Validation_Key__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Status__c') &&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Job_start__c') &&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Job_end__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Contact__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Mobile__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Parent_Id__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c'))
                    {
                        
                        modigie__Modigie__c modirec = new modigie__Modigie__c();
                        modirec.modigie__Job_start__c = startjob;
                        modirec.modigie__Job_end__c = endjob;
                        modirec.modigie__Jobid__c = jobid;
                        modirec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                        if(String.valueOf(status) == 'UNVALIDATED')
                            modirec.modigie__Status__c = 'Not Available';
                        else
                            modirec.modigie__Status__c = String.valueOf(status);
                        modirec.modigie__Contact__c = recordId;
                        modirec.modigie__Mobile__c = phoneNumber;
                        modirec.modigie__Parent_Id__c = recordId;
                        modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
                        
                        insert modirec;
                        
                    }
                    else
                            {
                                throw new InvocableException('User does not have needed permissions for Modigie object and/or fields.');
                            }
                    
                    if(status != 'Unvalidated' && status != 'Not Available')
                    {
                        if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credit__c') &&
                           FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','Name') &&
                           FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Used__c') &&
                           FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Validation_Key__c') &&
                           FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Purchased__c')&&
                           FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c')&&
                           FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Credit__c') &&
                           FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Used__c')&&
                           FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Validation_Key__c')&&
                           FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c'))
                        {
                            modiCredit[0].modigie__Used__c = (modiCredit[0].modigie__Purchased__c) - Integer.valueOf(credits);
                            modiCredit[0].modigie__Date_Last_Synced__c = date.today();
                            modiCredit[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                            
                            update modiCredit[0];
                        }
                        
                    }
                    
                    conList[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    conList[0].Modigie_Verified_Number__c = phoneNumber;
                    
                    update conList[0];
                    
                }
                else if(response.getStatusCode() == 302)
                {
                    String reqq = response.getHeader('Location');
                    HttpRequest request1 = new HttpRequest();
                    request1.setTimeout(120000);
                    request1.setMethod('GET');
                    request1.setEndpoint(reqq);
                    response = http.send(request1);
                    
                    
                    String jsonResponse = response.getBody();
                    
                    Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(String.escapeSingleQuotes(jsonResponse));
                    Map<String,Object> result_data = (Map<String,Object>)resMap.get('results');
                    object status = resMap.get('status');
                    Object credits = resMap.get('credits_left');
                    String phoneNumber = String.valueOf(result_data.get('phones'));
                    phoneNumber = phoneNumber.replaceAll('\\p{P}','');
                    
                    
                    String jobend = Datetime.now().format('hh:mm:ss');
                    String[] strTimeSplit1 = jobend.split(':');
                    Time endjob = Time.newInstance( Integer.valueOf(strTimeSplit1[0]) //hour
                                                   ,Integer.valueOf(strTimeSplit1[1]) //min
                                                   ,Integer.valueOf(strTimeSplit1[2])                                //sec
                                                   ,0); 
                    
                    if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Jobid__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Job_start__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Job_end__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Parent_Id__c') &&
                       FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c') &&
                       FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Jobid__c')&&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Validation_Key__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Status__c') &&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Job_start__c') &&
                       FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Job_end__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Contact__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Mobile__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Parent_Id__c') &&
                       FieldLevelSecurityCheck.canCreateField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c'))
                    {
                        
                        modigie__Modigie__c modirec = new modigie__Modigie__c();
                        modirec.modigie__Job_start__c = startjob;
                        modirec.modigie__Job_end__c = endjob;
                        modirec.modigie__Jobid__c = jobid;
                        modirec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                        if(String.valueOf(status) == 'UNVALIDATED')
                            modirec.modigie__Status__c = 'Not Available';
                        else
                            modirec.modigie__Status__c = String.valueOf(status);
                        modirec.modigie__Contact__c = recordId;
                        modirec.modigie__Mobile__c = phoneNumber;
                        modirec.modigie__Parent_Id__c = recordId;
                        modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
                        
                        insert modirec;
                        
                    }
                    
                    
                    if(status != 'Unvalidated' && status != 'Not Available')
                    {
                        if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credit__c') &&
                           FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','Name') &&
                           FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Used__c') &&
                           FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Validation_Key__c') &&
                           FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Purchased__c')&&
                           FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c')&&
                           FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Credit__c') &&
                           FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Used__c')&&
                           FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Validation_Key__c')&&
                           FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c'))
                        {
                            modiCredit[0].modigie__Used__c = (modiCredit[0].modigie__Purchased__c) - Integer.valueOf(credits);
                            modiCredit[0].modigie__Date_Last_Synced__c = date.today();
                            modiCredit[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                            
                            update modiCredit[0];
                        }
                    }
                    
                    conList[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    conList[0].Modigie_Verified_Number__c = phoneNumber;
                    
                    update conList[0];
                    
                }
            }
            
        }
        
        catch(Exception e)
        {
        }*/
    }
    public class InvocableException extends Exception{}
}