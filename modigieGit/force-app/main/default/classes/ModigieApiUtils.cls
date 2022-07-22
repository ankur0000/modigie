public class ModigieApiUtils {
    
    public static HTTPResponse executeAPI(String accessToken, String methodType, String apiKey, String endpointUrl, String reqBody) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer '+ accessToken);         
        req.setEndpoint(endpointUrl);
        req.setMethod(methodType);
        if(methodType=='POST' && reqBody!=''){
            req.setBody(reqBody);
            req.setHeader('Content-Type','application/json');
        }
        req.setHeader('x-api-key', apiKey);
        
        req.setTimeout(120000);
        Http http = new Http();
        HTTPResponse resp = new HTTPResponse();        
        resp = http.send(req);
        
        return resp;
    }
    
    @AuraEnabled
    public static List<modigie__Modigie_Service_Account__mdt> getServiceAccountDetails(){
        try {
            List<modigie__Modigie_Service_Account__mdt> modigieServiceAcc = new List<modigie__Modigie_Service_Account__mdt>();
            modigieServiceAcc = [SELECT modigie__Customer_ID__c, modigie__Email__c, modigie__API_Key__c,
                                 modigie__Private_Key__c, Id FROM modigie__Modigie_Service_Account__mdt LIMIT 1] ;
            return modigieServiceAcc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<modigie__Modigie_Callout_Info__mdt> getCalloutInfoDetails(String developerName){
        try {
            List<modigie__Modigie_Callout_Info__mdt> calloutInfoDetails = new List<modigie__Modigie_Callout_Info__mdt>();
            calloutInfoDetails = [SELECT modigie__targetAud__c, Id, modigie__Endpoint_Url__c FROM modigie__Modigie_Callout_Info__mdt WHERE DeveloperName = :developerName LIMIT 1];
            return calloutInfoDetails;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*Public static void create_Credit_Account(String str)
{
String developerName = 'Create_Credit_Account';
modigie__Modigie_Service_Account__mdt serviceAccDetail = ModigieApiUtils.getServiceAccountDetails();
modigie__Modigie_Callout_Info__mdt calloutInfo = ModigieApiUtils.getCalloutInfoDetails(developerName);
System.debug(serviceAccDetail);
System.debug(calloutInfo);
HttpRequest req = new HttpRequest();


String serviceAccCredential = serviceAccDetail.modigie__Email__c;
String targetAud = calloutInfo.modigie__targetAud__c;
String privateKey = serviceAccDetail.modigie__Private_Key__c;
String endpointUrl = calloutInfo.modigie__Endpoint_Url__c;
String customerId = serviceAccDetail.modigie__Customer_ID__c;
String apiKey = serviceAccDetail.modigie__API_Key__c;
endpointUrl = endpointUrl.replace('{customerId}',customerId);

system.debug('endpointUrl'+endpointUrl);

String accessToken = jwtapex.get_access_token(serviceAccCredential,targetAud,privateKey);
System.debug(accessToken);

String reqbody='{"title":"'+str+'"}';
system.debug('reqbody'+reqbody);
system.debug('apiKey'+apiKey);

HTTPResponse resp = ModigieApiUtils.executeAPI(accessToken, 'POST', apiKey, endpointUrl,reqbody);
system.debug('resp'+resp);
system.debug('getStatus()'+resp.getStatus());
if(resp.getStatus()=='Created')
{
ModigieJsonWrapper.itemsWrapper responce=ModigieJsonUtils.createCreditAccount(resp.getBody());
String uniqueStringforName = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));

modigie__creditAccountDetails__c creditaccdetail=new modigie__creditAccountDetails__c();
creditaccdetail.Name=uniqueStringforName;
creditaccdetail.modigie__Balance__c=decimal.valueOf(responce.balance.amount);
creditaccdetail.modigie__Credit_Id__c=responce.contract.id;
creditaccdetail.modigie__Currency_Code__c=responce.currency_x.code;
creditaccdetail.modigie__Status__c=responce.status;
creditaccdetail.modigie__Title__c=responce.title;
if(responce.quota.stopUntilTime!=null)
{
Datetime dt =datetimeparser(responce.quota.stopUntilTime);
//Datetime dt = DateTime.parse(responce.quota.stopUntilTime);
creditaccdetail.modigie__StopUntilTime__c=dt; 
}
insert creditaccdetail;
}
}*/
    
    Public static void createCredit_Account(ModigieJsonWrapper.itemsWrapper body)
    {
        String modigieBalance= body.balance?.amount;
        String modigieCreditId=body.id;
        String modigieCurrencyCode=body.currency_x?.code;
        String modigieStatus=body.status;
        String modigieTitle=body.title;
        String modigieStopUntilTime=body.quota?.stopUntilTime;
        String modigiereason=body.quota?.stopReason?.message;
        String modigieupdateTime=body.updateTime;
        Boolean isupdate=false;
        list<modigie__creditAccountDetails__c> creditaccdetail=[Select id,name,modigie__updateTime__c,modigie__Default__c,modigie__Status__c from modigie__creditAccountDetails__c where modigie__Credit_Id__c=:modigieCreditId limit 1];	
        
        if(creditaccdetail.isEmpty())
        {
            System.debug('inside if');
            String uniqueStringforName = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
            
            modigie__creditAccountDetails__c creditaccdetailn=new modigie__creditAccountDetails__c();
            creditaccdetailn.Name=uniqueStringforName;
            if(modigieStopUntilTime!=null)
            {
                Datetime dt = datetimeparser(modigieupdateTime);
                creditaccdetail[0].modigie__updateTime__c=dt; 
            }
            creditaccdetail.add(creditaccdetailn);
            isupdate=true;
        }
        else
        {
            System.debug('inside else');
            if(modigieupdateTime!=null)
            {
                System.debug('line 130');
                if(creditaccdetail[0].modigie__updateTime__c!=null)
                {
                    Datetime dt = datetimeparser(modigieupdateTime);
                    if(dt>creditaccdetail[0].modigie__updateTime__c)
                    {
                        creditaccdetail[0].modigie__updateTime__c=dt;
                        isupdate=true;
                    }
                }
                else
                {
                    Datetime dt = datetimeparser(modigieupdateTime);
                    creditaccdetail[0].modigie__updateTime__c=dt;
                    isupdate=true;
                }
            }
            
            if( creditaccdetail[0].modigie__Default__c==true && creditaccdetail[0].modigie__Status__c=='active' && modigieStatus=='inactive')
            {
                EmailServiceClass.sendEmailForDefaultInactiveCreditAccount(modigieCreditId);
            }
        }
        
        if(modigieBalance != null){
            creditaccdetail[0].modigie__Balance__c=decimal.valueOf(modigieBalance);
        }
        else{
            creditaccdetail[0].modigie__Balance__c = null;
        }
        
        creditaccdetail[0].modigie__Credit_Id__c=modigieCreditId;
        creditaccdetail[0].modigie__Currency_Code__c=modigieCurrencyCode;
        creditaccdetail[0].modigie__Status__c=modigieStatus;
        creditaccdetail[0].modigie__Title__c=modigieTitle;
        if(modigiereason!=null)
        {
            modigiereason=modigiereason.replace('<code>', '');
            modigiereason=modigiereason.replace('</code>', '');
            if(modigiereason.length()>255)
            {
                modigiereason = modigiereason.substring(0, 255);
                
            }
        }
        
        creditaccdetail[0].modigie__Reason__c=modigiereason;
        if(modigieStopUntilTime==null || modigieStopUntilTime=='')
        {
            creditaccdetail[0].modigie__StopUntilTime__c=null;
            
        }
        else
        {
            Datetime dt =datetimeparser(modigieStopUntilTime);
            creditaccdetail[0].modigie__StopUntilTime__c=dt; 
        }
        System.debug('isupdate'+isupdate);
        if(isupdate)
        {
            System.debug('ready to upsert');
            upsert creditaccdetail;
        }
    }
    
    
    Public static void create_Repository(ModigieJsonWrapper.repositoryWrapper body)
    {
        String  fromTime=body.featureConfig?.tom?.fromTime;
        String untilTime=body.featureConfig?.tom?.untilTime;
        String unlockUntilTime=body.featureConfig?.Performance?.rulesets?.unlockUntilTime;
        String unlockReason=body.featureConfig?.Performance?.rulesets?.unlockReason?.message;
        String stopUntilTime=body.quota?.stopUntilTime;
        String stopReason=body.quota?.stopReason?.message;
        String updateTime=body.updateTime;
        String status = body.status;
        
        system.debug('quota'+body);
        list<modigie__TOM__c> settinglist=new list<modigie__TOM__c>();
        modigie__TOM__c settings = modigie__TOM__c.getOrgDefaults();
        system.debug('settings'+settings);
        Boolean isupdate=false;
        if(settings.SetupOwnerId==null)
        {
            settings= new modigie__TOM__c(SetupOwnerId = UserInfo.getOrganizationId(),modigie__isActive__c=true);
            if(updateTime!=null)
            {
                Datetime dt=datetimeparser(updateTime);
                
                settings.modigie__Repository_Update_Time__c=dt;
                isupdate=true;
            }
            //settinglist.add(tom);
        }
        else
        {
            if(settings.modigie__Repository_Update_Time__c!=null)
            {
                if(updateTime!=null)
                {
                    Datetime dt=datetimeparser(updateTime);
                    if(dt>settings.modigie__Repository_Update_Time__c)
                    {
                        settings.modigie__Repository_Update_Time__c=dt;
                        isupdate=true;
                    }
                }
            }
            else
            {
                if(updateTime!=null)
                {
                    Datetime dt=datetimeparser(updateTime);
                    
                    settings.modigie__Repository_Update_Time__c=dt;
                    isupdate=true;
                }
            }
        }
        if(isupdate)
        {
            settings.modigie__startDate__c= datetimeparser(fromTime).Date(); 
            settings.modigie__endDate__c=datetimeparser(untilTime).Date();
            if(unlockUntilTime==null || unlockUntilTime=='')
            {
                settings.modigie__Performance_Rulesets_UnlockUntilTime__c=null;
            }
            else
            {
                settings.modigie__Performance_Rulesets_UnlockUntilTime__c=datetimeparser(unlockUntilTime);
            }
            if(unlockReason != null){
                if(unlockReason.length()>255)
                {
                    unlockReason = unlockReason.substring(0, 255);
                    
                }
            }
            
            settings.modigie__Performance_Rulesets_UnlockReason__c=unlockReason;
            if(stopUntilTime==null || stopUntilTime=='')
            {
                settings.modigie__Org_Stop_Until_Time__c=null;
            }
            else
            {
                
                settings.modigie__Org_Stop_Until_Time__c=datetimeparser(stopUntilTime);
            }
            if(stopReason != null){
                if(stopReason.length()>255)
                {
                    stopReason = stopReason.substring(0, 255);
                    
                }
            }
            
            settings.modigie__Org_Stop_Reason__c=stopReason;
            settings.modigie__Repository_Status__c = status;
            
            upsert settings;
            if(status == 'authorized' || status == 'confirmed' || status == 'active' || status == 'paused'){
                List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Services Batch Job%' WITH SECURITY_ENFORCED];
                List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
                
                for(CronTrigger ct : lstCt){
                    System.abortJob((String)ct.Id);
                }
            }
            else if(status == 'inactive'){
                BatchJobsScheluderClass.scheduleMe(0,1,'Interval');
            }
        }
    }
    
    public static Datetime datetimeparser(String Datestr)
    {
        Datestr=Datestr.replace('T',' ');
        Datestr=Datestr.replace('Z','');
        Datetime dt = Datetime.valueOfGMT(Datestr);
        return dt;
    }

    public static List<Map<String, Object>> setNewPayload(Map<String, Object> outerMap, List<Map<String, Object>> newTempLstObj, String objType){
        System.debug('Oldmap'+newTempLstObj);
        List<Map<String, Object>> items = new List<Map<String, Object>>();
        for(Map<String, Object> tempObject: newTempLstObj){
            Map<String, Object> item = new Map<String, Object>();
            item.put('firstName', tempObject.get('firstName'));
            item.put('lastName', tempObject.get('lastName'));
            Map<String, Object> company = new Map<String, Object>();
            company.put('title', tempObject.get('company'));
            item.put('company', company);
            List<Map<String, Object>> emailAddresses = new List<Map<String, Object>>();
            Map<String, Object> emailAddress = new Map<String, Object>();
            Map<String, Object> userFormat = new Map<String, Object>();
            userFormat.put('userFormat', tempObject.get('companyEmail'));
            emailAddress.put('emailAddress', userFormat);
            List<String> rels = new List<String>();
            rels.add('business');
            emailAddress.put('rels', rels);
            emailAddress.put('origin', 'salesforce-email');
            emailAddresses.add(emailAddress);
            item.put('emailAddresses', emailAddresses);
            
            List<Map<String, Object>> phoneNumbers = new List<Map<String, Object>>();
            List<String> mobilePhoneList = (List<String>)tempObject.get('mobilePhones');
            if(mobilePhoneList != null){
                for(String phone: mobilePhoneList){
                    Map<String, Object> phoneNumber = new Map<String, Object>();
                    Map<String, Object> userFormatPhone = new Map<String, Object>();
                    userFormatPhone.put('userFormat', phone);
                    phoneNumber.put('phoneNumber', userFormatPhone);
                    List<String> relsPhone = new List<String>();
                    relsPhone.add('business');
                    phoneNumber.put('rels', relsPhone);
                    phoneNumber.put('origin', 'salesforce-phone');
                    phoneNumbers.add(phoneNumber);
                }
            }
            
            item.put('phoneNumbers', phoneNumbers);

            List<Map<String, Object>> urls = new List<Map<String, Object>>();
            Map<String, Object> url = new Map<String, Object>();
            Map<String, Object> userFormatEmail = new Map<String, Object>();
            userFormatEmail.put('userFormat', tempObject.get('linkedInUrl'));
            url.put('url', userFormatEmail);
            List<String> relsEmail = new List<String>();
            relsEmail.add('linkedInUser');
            url.put('rels', relsEmail);
            url.put('origin', 'salesforce-url');
            urls.add(url);
            item.put('urls', urls);

            List<Map<String, Object>> customParams = (List<Map<String, Object>>)tempObject.get('customParameters');
            String recordId = customParams[0].get('value').toString().subString(0,18);
            item.put('id', recordId);
            item.put('objectType', objType);

            Map<String, Object> syncTrigger = new Map<String, Object>();
            Map<String, Object> creditAccount = new Map<String, Object>();
            creditAccount.put('id', outerMap.get('creditsId'));
            syncTrigger.put('creditAccount', creditAccount);
            Map<String, Object> ruleset = new Map<String, Object>();
            ruleset.put('id', tempObject.get('rulesetId'));
            syncTrigger.put('ruleset', ruleset);
            item.put('syncTrigger', syncTrigger);

            Map<String, Object> progress = new Map<String, Object>();
            Map<String, Object> job = new Map<String, Object>();
            job.put('jobType', tempObject.get('jobSubType'));
            progress.put('job', job);
            item.put('progress', progress);

            items.add(item);
            
        }
        System.debug('newMap '+ items);
        return items;
    }
}