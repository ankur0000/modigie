public with sharing class ListViewGetLinkedInBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
  List<modigie__Error_Log__c> lstErrorLog = new List<modigie__Error_Log__c>();
  List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();
  String accessToken;
  String targetAudience, endpoint, contentType;
  List<sObject> sObjectList = new List<sObject>();
  Set<String> emailMessages = new Set<String>();
  String objectname;

  public ListViewGetLinkedInBatchClass(
    List<sObject> sobjList,
    String accToken,
    String objectname1
  ) {
    try {
      modigieCredential = ModigieApiUtils.getServiceAccountDetails();
      List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'LinkedIn Job Create' LIMIT 1];
      
      if(!calloutInfo.isEmpty()){
        endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
        targetAudience = calloutInfo[0].modigie__targetAud__c;
        contentType = calloutInfo[0].modigie__Content_Type__c;
      }

      accessToken = accToken;
      sObjectList = sobjList;
      objectname = objectname1;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get LinkedIn');
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new ListViewGetLinkedInBatchClassException(
        'You are not an authorized user.'
      );
    } catch (Exception e) {
      throw new ListViewGetLinkedInBatchClassException(e.getMessage());
    }
  }
  public List<sObject> start(Database.BatchableContext bc) {
    return sObjectList;
  }

  public void execute(Database.BatchableContext bc, List<sObject> scope) {
    if (objectname?.equalsIgnoreCase('Contact') == true) {
      try {
        List<User> userobj = new List<User>();
        List<Contact> conList = new List<Contact>();

        for (sObject con : scope) {
          Contact c = (Contact) con;
          conList.add(c);
        }

        Map<String, Object> outerMap = new Map<String, Object>();

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
        outerMap.put('creditsId', creditAccountId);
        String currentPackageVersion = String.valueOf(System.requestVersion());
        if(System.requestVersion().patch() != null){
            currentPackageVersion += '.' + System.requestVersion().patch();
        } 
        List<Map<String, Object>> lstJobLevelCustomParameters = new List<Map<String, Object>>{
          new Map<String, Object>{
            'name' => 'modigie-client-name',
            'value' => 'sfdc'
          },
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-version',
            'value' => currentPackageVersion
          },
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-org',
            'value' => UserInfo.getOrganizationId()
          },
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-adhoq',
            'value' => 'list-view'
          }
        };
        outerMap.put('customParameters', lstJobLevelCustomParameters);

        List<Map<String, Object>> lstCon = new List<Map<String, Object>>();

        //for(Contact con : [SELECT Id, Account.Name, FirstName, LastName, Email, modigie__linkedin_url__c, modigie__Company_URL__c FROM Contact WHERE Id In :setOfContactIds])
        for (Contact con : conList) {
          Map<String, Object> sinCon = new Map<String, Object>();

          if (con.FirstName != null) {
            sinCon.put('firstName', con.FirstName);
          }

          if (con.LastName != null) {
            sinCon.put('lastName', con.LastName);
          }

          if (con.Account.Name != null) {
            sinCon.put('company', con.Account.Name);
          }

          if (con.MobilePhone != null) {
            sinCon.put('mobilePhone', con.MobilePhone);
          }

          Map<String, Object> companyAddress = new Map<String, Object>();

          if (con.Account.BillingStreet != null) {
            companyAddress.put('streetLine', con.Account.BillingStreet);
          }

          if (con.Account.BillingPostalCode != null) {
            companyAddress.put('zip', con.Account.BillingPostalCode);
          }

          if (con.Account.BillingCity != null) {
            companyAddress.put('city', con.Account.BillingCity);
          }

          if (con.Account.BillingState != null) {
            companyAddress.put('state', con.Account.BillingState);
          }

          if (con.Account.BillingCountry != null) {
            companyAddress.put('country', con.Account.BillingCountry);
          }

          sinCon.put('companyAddress', companyAddress);

          if (con.modigie__linkedin_url__c != null) {
            sinCon.put('linkedInUrl', con.modigie__linkedin_url__c);
          }

          sinCon.put('companyEmail', con.Email);

          Map<String, String> customParaMap = new Map<String, String>();

          customParaMap.put('name', 'recordIdAndOrgId');
          customParaMap.put('value', con.Id + UserInfo.getOrganizationId());

          Map<String, String> customParaMap2 = new Map<String, String>();

          // Integer requestId = Math.round((Math.random() * (9000) + 1000));

          // customParaMap2.put('name', 'uniqueId');

          // customParaMap2.put('value', requestId+'');

          List<Map<String, String>> lstMap = new List<Map<String, String>>();

          lstMap.add(customParaMap);
          lstMap.add(customParaMap2);
          sinCon.put('customParameters', lstMap);

          lstCon.add(sinCon);
          //contactMap.put(con.Id, con);
        }

        outerMap.put('contacts', lstCon);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        // request.setHeader('Content-Length', '4096');
        //request.setHeader('accept', 'application/json');
        request.setHeader('Content-Type', contentType);
        request.setHeader('Authorization', accessToken);

        request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);
        request.setEndpoint(
          endpoint
        ); //Production Environment Endpoints
        //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/linkedInUrlJobs?key=' + modigieCredential.modigie__API_Key__c); //Staging Environment Endpoints

        request.setBody(JSON.serialize(outerMap));

        request.setTimeout(120000);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 202) {
          String jsonResponse = response.getBody();
          Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
            jsonResponse
          );

          String jobid = responseMap.get('id').toString();

          for (Contact con : conList) {
            modigie__Modigie__c modiRec = new modigie__Modigie__c();

            if (con.modigie__Modigie__r.size() > 0) {
              modiRec.Id = con.modigie__Modigie__r[0].Id;
            }

            modirec.modigie__Validation_Date_Get_LinkedIn__c = System.now();

            modiRec.modigie__Linkedin_Job_Id__c = jobid;
            modiRec.modigie__Contact__c = con.id;
            modiRec.modigie__Parent_Id__c = con.id;

            String status = responseMap.get('status').toString();
            status =
              status.substring(0, 1).toUpperCase() +
              status.substring(1, status.length());

            modiRec.modigie__Get_LinkedIn_Job_Status__c = status;
            modiRec.modigie__User_GetLinkedin__c = UserInfo.getUserId();
            modiRec.modigie__Linkedin_Status__c = 'In process';
            modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            modiList.add(modiRec);
          }

          if (modiList.size() > 0) {
            if (
              FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
              FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') &&
              FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Validation_Date_Get_LinkedIn__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Validation_Date_Get_LinkedIn__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Validation_Date_Get_LinkedIn__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Job_Id__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Job_Id__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Job_Id__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Contact__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Contact__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Contact__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Parent_Id__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Parent_Id__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Parent_Id__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Get_LinkedIn_Job_Status__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Get_LinkedIn_Job_Status__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Get_LinkedIn_Job_Status__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Status__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Status__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Status__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Validation_Key__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Validation_Key__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Validation_Key__c'
              )
            ) {
              upsert modiList;
            }
          }

          List<modigie__Process_Builder_Switch__c> lstPbs = [
            SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c
            FROM modigie__Process_Builder_Switch__c
            WITH SECURITY_ENFORCED
            LIMIT 1
          ];
          if (lstPbs.isEmpty()) {
            throw new ListViewGetLinkedInBatchClassException(
              'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
            );
          } else if (
            lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null
          ) {
            throw new ListViewGetLinkedInBatchClassException(
              'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
            );
          }

          if (lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c) {
            String userId = UserInfo.getUserId();
            List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieUsage = [
              SELECT
                modigie__User_Id__c,
                modigie__Number_of_modigie_callouts_in_a_day__c
              FROM modigie__Daily_usage_modigie_callouts_by_users__c
              WHERE modigie__User_Id__c = :userId
              WITH SECURITY_ENFORCED
              LIMIT 1
            ];

            if (modigieUsage.size() > 0) {
              modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c =
                modigieUsage[0]
                  .modigie__Number_of_modigie_callouts_in_a_day__c +
                lstCon.size();
            } else {
              modigieUsage.add(
                new modigie__Daily_usage_modigie_callouts_by_users__c(
                  Name = userId,
                  modigie__User_Id__c = userId,
                  modigie__Number_of_modigie_callouts_in_a_day__c = lstCon.size()
                )
              );
            }

            if (modigieUsage.size() > 0) {
              if (
                FieldLevelSecurityCheck.canReadObject(
                  'modigie__Daily_usage_modigie_callouts_by_users__c'
                ) &&
                FieldLevelSecurityCheck.canCreateObject(
                  'modigie__Daily_usage_modigie_callouts_by_users__c'
                ) &&
                FieldLevelSecurityCheck.canUpdateObject(
                  'modigie__Daily_usage_modigie_callouts_by_users__c'
                ) &&
                FieldLevelSecurityCheck.canReadField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__Number_of_modigie_callouts_in_a_day__c'
                ) &&
                FieldLevelSecurityCheck.canCreateField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__Number_of_modigie_callouts_in_a_day__c'
                ) &&
                FieldLevelSecurityCheck.canUpdateField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__Number_of_modigie_callouts_in_a_day__c'
                ) &&
                FieldLevelSecurityCheck.canReadField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__User_Id__c'
                ) &&
                FieldLevelSecurityCheck.canCreateField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__User_Id__c'
                ) &&
                FieldLevelSecurityCheck.canUpdateField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__User_Id__c'
                )
              ) {
                upsert modigieUsage;
              }
              //check limit here
            } else {
              throw new ListViewGetLinkedInBatchClassException(
                'User does not have permission to edit modigie record.'
              );
            }
          }
        } else {
          if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
            EmailServiceClass.sendResponseError('ListViewGetLinkedInBatchClass', response.getStatusCode(), response.getBody());
          }
          for (Contact con : conList) {
            modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
            String jsonResponse = response.getBody();
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
              jsonResponse
            );
            modigieErrorLog.modigie__Description__c = (String) responseMap.get(
              'message'
            );
            modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
            modigieErrorLog.modigie__Modigie_Service__c = 'Get LinkedIn';
            modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            modigieErrorLog.modigie__Contact__c = con.Id;
            emailMessages.add((String) responseMap.get('message'));
            lstErrorLog.add(modigieErrorLog);
          }
        }
      } catch (Exception e) {
        throw new ListViewGetLinkedInBatchClassException(e.getMessage());
      }
    } else {
      try {
        Map<String, Object> outerMap = new Map<String, Object>();

        List<Lead> leadList = new List<Lead>();

        for (sObject l : scope) {
          Lead c = (Lead) l;
          leadList.add(c);
        }
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
        outerMap.put('creditsId',creditAccountId);
        String currentPackageVersion = String.valueOf(System.requestVersion());
        if(System.requestVersion().patch() != null){
            currentPackageVersion += '.' + System.requestVersion().patch();
        }
        List<Map<String, Object>> lstJobLevelCustomParameters = new List<Map<String, Object>>{
          new Map<String, Object>{
            'name' => 'modigie-client-name',
            'value' => 'sfdc'
          },
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-version',
            'value' => currentPackageVersion
          },
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-org',
            'value' => UserInfo.getOrganizationId()
          },
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-adhoq',
            'value' => 'list-view'
          }
        };
        outerMap.put('customParameters', lstJobLevelCustomParameters);

        List<Map<String, Object>> lstCon = new List<Map<String, Object>>();

        for (Lead leadrec : leadList) {
          //leadMap.put(leadrec.id, leadrec);

          Map<String, Object> sinCon = new Map<String, Object>();

          if (leadrec.FirstName != null) {
            sinCon.put('firstName', leadrec.FirstName);
          }

          if (leadrec.LastName != null) {
            sinCon.put('lastName', leadrec.LastName);
          }

          if (leadrec.Company != null) {
            sinCon.put('company', leadrec.Company);
          }

          if (leadrec.MobilePhone != null) {
            sinCon.put('mobilePhone', leadrec.MobilePhone);
          }

          Map<String, String> customParaMap = new Map<String, String>();

          customParaMap.put('name', 'recordIdAndOrgId');
          customParaMap.put('value', leadrec.Id + UserInfo.getOrganizationId());

          List<Map<String, String>> lstMap = new List<Map<String, String>>();

          lstMap.add(customParaMap);
          sinCon.put('customParameters', lstMap);

          sinCon.put('companyEmail', leadrec.Email);

          lstCon.add(sinCon);
        }

        outerMap.put('contacts', lstCon);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        // request.setHeader('Content-Length', '4096');
        //request.setHeader('accept', 'application/json');
        request.setHeader('Content-Type', contentType);
        request.setHeader('Authorization', accessToken);

        request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);
        request.setEndpoint(
          endpoint
        ); //Production Environment Endpoints
        //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/linkedInUrlJobs?key=' + modigieCredential.modigie__API_Key__c); //Staging Environment Endpoints

        request.setBody(JSON.serialize(outerMap));
        request.setTimeout(120000);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 202) {
          String jsonResponse = response.getBody();
          Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
            jsonResponse
          );

          String jobid = responseMap.get('id').toString();

          for (Lead ld : leadList) {
            modigie__Modigie__c modiRec = new modigie__Modigie__c();
            if (ld.modigie__Modigie__r.size() > 0) {
              modiRec.Id = ld.modigie__Modigie__r[0].Id;
            }

            modirec.modigie__Validation_Date_Get_LinkedIn__c = System.now();

            modiRec.modigie__Linkedin_Job_Id__c = jobid;
            modiRec.modigie__Lead__c = ld.id;
            modiRec.modigie__Parent_Id__c = ld.id;

            String statusGetModigie = responseMap.get('status').toString();
            statusGetModigie =
              statusGetModigie.substring(0, 1).toUpperCase() +
              statusGetModigie.substring(1, statusGetModigie.length());
            modiRec.modigie__User_GetLinkedin__c = UserInfo.getUserId();
            modiRec.modigie__Get_LinkedIn_Job_Status__c = statusGetModigie;
            modiRec.modigie__Linkedin_Status__c = 'In process';
            modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            modiList.add(modiRec);
          }

          if (modiList.size() > 0) {
            if (
              FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
              FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') &&
              FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Validation_Date_Get_LinkedIn__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Validation_Date_Get_LinkedIn__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Validation_Date_Get_LinkedIn__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Job_Id__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Job_Id__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Job_Id__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Lead__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Lead__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Lead__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Parent_Id__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Parent_Id__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Parent_Id__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Get_LinkedIn_Job_Status__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Get_LinkedIn_Job_Status__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Get_LinkedIn_Job_Status__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Status__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Status__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Linkedin_Status__c'
              ) &&
              FieldLevelSecurityCheck.canReadField(
                'modigie__Modigie__c',
                'modigie__Validation_Key__c'
              ) &&
              FieldLevelSecurityCheck.canCreateField(
                'modigie__Modigie__c',
                'modigie__Validation_Key__c'
              ) &&
              FieldLevelSecurityCheck.canUpdateField(
                'modigie__Modigie__c',
                'modigie__Validation_Key__c'
              )
            ) {
              upsert modiList;
            } else {
              throw new ListViewGetLinkedInBatchClassException(
                'User does not have permission to edit modigie object.'
              );
            }
          }

          List<modigie__Process_Builder_Switch__c> lstPbs = [
            SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c
            FROM modigie__Process_Builder_Switch__c
            WITH SECURITY_ENFORCED
            LIMIT 1
          ];
          if (lstPbs.isEmpty()) {
            throw new ListViewGetLinkedInBatchClassException(
              'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
            );
          } else if (
            lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null
          ) {
            throw new ListViewGetLinkedInBatchClassException(
              'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
            );
          }

          if (lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c) {
            String userId = UserInfo.getUserId();
            List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieUsage = [
              SELECT
                modigie__User_Id__c,
                modigie__Number_of_modigie_callouts_in_a_day__c
              FROM modigie__Daily_usage_modigie_callouts_by_users__c
              WHERE modigie__User_Id__c = :userId
              WITH SECURITY_ENFORCED
              LIMIT 1
            ];

            if (modigieUsage.size() > 0) {
              modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c =
                modigieUsage[0]
                  .modigie__Number_of_modigie_callouts_in_a_day__c +
                lstCon.size();
            } else {
              modigieUsage.add(
                new modigie__Daily_usage_modigie_callouts_by_users__c(
                  Name = userId,
                  modigie__User_Id__c = userId,
                  modigie__Number_of_modigie_callouts_in_a_day__c = lstCon.size()
                )
              );
            }

            if (modigieUsage.size() > 0) {
              if (
                FieldLevelSecurityCheck.canReadObject(
                  'modigie__Daily_usage_modigie_callouts_by_users__c'
                ) &&
                FieldLevelSecurityCheck.canCreateObject(
                  'modigie__Daily_usage_modigie_callouts_by_users__c'
                ) &&
                FieldLevelSecurityCheck.canUpdateObject(
                  'modigie__Daily_usage_modigie_callouts_by_users__c'
                ) &&
                FieldLevelSecurityCheck.canReadField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__Number_of_modigie_callouts_in_a_day__c'
                ) &&
                FieldLevelSecurityCheck.canCreateField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__Number_of_modigie_callouts_in_a_day__c'
                ) &&
                FieldLevelSecurityCheck.canUpdateField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__Number_of_modigie_callouts_in_a_day__c'
                ) &&
                FieldLevelSecurityCheck.canReadField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__User_Id__c'
                ) &&
                FieldLevelSecurityCheck.canCreateField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__User_Id__c'
                ) &&
                FieldLevelSecurityCheck.canUpdateField(
                  'modigie__Daily_usage_modigie_callouts_by_users__c',
                  'modigie__User_Id__c'
                )
              ) {
                upsert modigieUsage;
              }
            } else {
              throw new ListViewGetLinkedInBatchClassException(
                'User does not have permission to query modigie object.'
              );
            }
          }
        } else {
          if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
            EmailServiceClass.sendResponseError('ListViewGetLinkedInBatchClass...', response.getStatusCode(), response.getBody());
          }
          if (
            FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c') &&
            FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Error_Log__c',
              'modigie__Lead__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Error_Log__c',
              'modigie__Lead__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Error_Log__c',
              'modigie__Contact__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Error_Log__c',
              'modigie__Contact__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Error_Log__c',
              'modigie__Description__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Error_Log__c',
              'modigie__Description__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Error_Log__c',
              'modigie__Error_Code__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Error_Log__c',
              'modigie__Error_Code__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Error_Log__c',
              'modigie__Modigie_Service__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Error_Log__c',
              'modigie__Modigie_Service__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Error_Log__c',
              'modigie__Validation_Key__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Error_Log__c',
              'modigie__Validation_Key__c'
            )
          ) {
            for (Lead l : leadList) {
              modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
              String jsonResponse = response.getBody();
              Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
                jsonResponse
              );
              modigieErrorLog.modigie__Description__c = (String) responseMap.get(
                'message'
              );
              modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
              modigieErrorLog.modigie__Modigie_Service__c = 'Get LinkedIn';
              modigieErrorLog.modigie__Lead__c = l.Id;
              modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
              emailMessages.add((String) responseMap.get('message'));

              lstErrorLog.add(modigieErrorLog);
            }
          }
        }
      } catch (Exception e) {
      }
    }
  }

  public void finish(Database.BatchableContext bc) {
    
    //sending email of limit reached
    //check here if User Usage and Limit Difference is 0 (or lesss, ehy not) and if it is send email
    NotificationServiceClass.adhoqLimitCheck();
    
    if (!lstErrorLog.isEmpty()) {
      if (
        FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c') &&
        FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') &&
        FieldLevelSecurityCheck.canCreateField(
          'modigie__Error_Log__c',
          'modigie__Lead__c'
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'modigie__Error_Log__c',
          'modigie__Lead__c'
        ) &&
        FieldLevelSecurityCheck.canCreateField(
          'modigie__Error_Log__c',
          'modigie__Contact__c'
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'modigie__Error_Log__c',
          'modigie__Contact__c'
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'modigie__Error_Log__c',
          'modigie__Description__c'
        ) &&
        FieldLevelSecurityCheck.canCreateField(
          'modigie__Error_Log__c',
          'modigie__Description__c'
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'modigie__Error_Log__c',
          'modigie__Error_Code__c'
        ) &&
        FieldLevelSecurityCheck.canCreateField(
          'modigie__Error_Log__c',
          'modigie__Error_Code__c'
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'modigie__Error_Log__c',
          'modigie__Modigie_Service__c'
        ) &&
        FieldLevelSecurityCheck.canCreateField(
          'modigie__Error_Log__c',
          'modigie__Modigie_Service__c'
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'modigie__Error_Log__c',
          'modigie__Validation_Key__c'
        ) &&
        FieldLevelSecurityCheck.canCreateField(
          'modigie__Error_Log__c',
          'modigie__Validation_Key__c'
        )
      ) {
        insert lstErrorLog;
      }
    }
    System.Queueable job = new CreditInfoQueableClass();
    System.enqueueJob(job);

    BatchJobsScheluderClass.scheduleForOneMinute();

    if (!emailMessages.isEmpty()) {
      EmailServiceClass.sendEmailForCampaign(emailMessages);
    }
  }
  private class ListViewGetLinkedInBatchClassException extends Exception {
  }
}