public with sharing class UnresponsiveLeadContactBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts {
  List<SObject> lstsObj = new List<SObject>();
  List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
  List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
  List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();
  Set<String> emailMessages = new Set<String>();
  String targetAudience, endpoint;
  List<modigie__Error_Log__c> lstErrorLog = new List<modigie__Error_Log__c>();
  String accessToken;

  public UnresponsiveLeadContactBatchClass(List<SObject> lstsObj) {
    try {
      modigieCredential = ModigieApiUtils.getServiceAccountDetails();
      List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Verify Employer Job Create' LIMIT 1];
      
      if(!calloutInfo.isEmpty()){
        endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
        targetAudience = calloutInfo[0].modigie__targetAud__c;
      }

      accessToken =
        'Bearer ' +
        jwtapex.get_access_token(
          modigieCredential[0].modigie__Email__c,
          targetAudience,
          modigieCredential[0].modigie__Private_Key__c
        );
      //accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-kyaxv4ttua-uc.a.run.app',modigieCredential.modigie__Private_Key__c);
      this.lstsObj = lstsObj;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Unresponsive Lead');
      // EmailServiceClass.sendEmail(JSON.serialize(errorMap));
      //throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new UnresponsiveLeadContactBatchClassException(
        'You are not an authorized user.'
      );
    } catch (Exception e) {
      throw new UnresponsiveLeadContactBatchClassException(e.getMessage());
    }
  }
  public List<SObject> start(Database.BatchableContext bc) {
    return lstsObj;
  }

  public void execute(Database.BatchableContext bc, List<SObject> scope) {
    try {
      List<User> userobj = new List<User>();

      modiCredit = [
        SELECT
          Name,
          modigie__Purchased__c,
          modigie__Remaining__c,
          modigie__Validation_Key__c,
          modigie__Used__c,
          modigie__Date_Last_Synced__c
        FROM modigie__Modigie_Credit__c
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];

      Set<Id> setOfKeysIds = new Set<Id>();
      for (SObject sco : scope) {
        setOfKeysIds.add((Id) sco.get('Id'));
      }

      Map<Id, Contact> conMap = new Map<Id, Contact>(
        [
          SELECT id, Account.Name
          FROM Contact
          WHERE Id IN :setOfKeysIds
          WITH SECURITY_ENFORCED
        ]
      );

      Map<ID, Lead> leadMap = new Map<ID, Lead>();

      Map<String, Object> outerMap = new Map<String, Object>();

      List<modigie__creditAccountUsers__c> cau = [SELECT Id, Name, modigie__Credit_Id__c FROM modigie__creditAccountUsers__c
                                                  WHERE modigie__User_Id__c =: Userinfo.getUserId() AND modigie__isPerformance__c = false LIMIT 1];
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

      outerMap.put(
        'creditsId',
        creditAccountId
      );
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
          'value' => 'detail-view'
        }
      };
      outerMap.put('customParameters', lstJobLevelCustomParameters);

      List<Map<String, Object>> lstCon = new List<Map<String, Object>>();
      for (SObject sObj : scope) {
        String sobjectType = sObj.getSObjectType().getDescribe().getName();

        Map<String, Object> sinCon = new Map<String, Object>();

        if (sObj.get('FirstName') != null) {
          sinCon.put('firstName', sObj.get('FirstName'));
        }

        if (sObj.get('LastName') != null) {
          sinCon.put('lastName', sObj.get('LastName'));
        }

        if (sobjectType?.equalsIgnoreCase('Contact') == true) {
          if (sObj.get('AccountId') != null) {
            Contact con = conMap.get((Id) sObj.get('Id'));

            sinCon.put('company', con.Account.Name);
          }
        } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
          if (sObj.get('Company') != null) {
            sinCon.put('company', sObj.get('Company'));
          }
        }

        if (sObj.get('modigie__linkedin_url__c') != null) {
          sinCon.put('linkedInUrl', sObj.get('modigie__linkedin_url__c'));
        }

        if (sObj.get('Email') != null) {
          sinCon.put('companyEmail', sObj.get('Email'));
          sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputEmail');
        }else if (sObj.get('modigie__linkedin_url__c') != null) {
          sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputLinkedIn');
        }

        Map<String, String> customParaMap = new Map<String, String>();

        customParaMap.put('name', 'recordIdAndOrgId');
        customParaMap.put(
          'value',
          sObj.get('Id') + UserInfo.getOrganizationId()
        );

        List<Map<String, String>> lstMap = new List<Map<String, String>>();

        lstMap.add(customParaMap);
        sinCon.put('customParameters', lstMap);

        lstCon.add(sinCon);
      }

      outerMap.put('contacts', lstCon);

      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setMethod('POST');

      request.setHeader('Content-Type', ' application/json');
      request.setHeader('Authorization', accessToken);
      request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);
      request.setEndpoint(
        endpoint
      ); //Production Environment Endpoints
      //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/mobilePhoneJobs?key=' + modigieCredential.modigie__API_Key__c); //Staging Environment Endpoints

      request.setTimeout(60000);

      request.setBody(JSON.serialize(outerMap));

      HttpResponse response = http.send(request);
      if (response.getStatusCode() == 202) {
        String jsonResponse = response.getBody();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
          jsonResponse
        );

        String jobid = responseMap.get('id').toString();

        List<modigie__Modigie__c> lstmodigie = [
          SELECT Id, modigie__Contact__c, modigie__Lead__c
          FROM modigie__Modigie__c
          WHERE
            modigie__Contact__c IN :setOfKeysIds
            OR modigie__Lead__c IN :setOfKeysIds
          WITH SECURITY_ENFORCED
        ];

        Map<Id, Id> modigieData = new Map<Id, Id>();

        for (modigie__Modigie__c modi : lstmodigie) {
          if (modi.modigie__Contact__c != null) {
            modigieData.put(modi.modigie__Contact__c, modi.Id);
          } else if (modi.modigie__Lead__c != null) {
            modigieData.put(modi.modigie__Lead__c, modi.Id);
          }
        }

        for (SObject sObj : scope) {
          String sobjectType = sObj.getSObjectType().getDescribe().getName();

          modigie__Modigie__c modiRec = new modigie__Modigie__c();
          if (modigieData.get((ID) sObj.get('Id')) != null) {
            modiRec.Id = modigieData.get((ID) sObj.get('Id'));
          }

          modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
          modiRec.modigie__Jobid__c = jobid;

          if (sobjectType?.equalsIgnoreCase('Contact') == true) {
            modiRec.modigie__Contact__c = (ID) sObj.get('Id');
          } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
            modiRec.modigie__Lead__c = (ID) sObj.get('Id');
          }

          modiRec.modigie__Parent_Id__c = (String) sObj.get('Id');

          String statusGetModigie = responseMap.get('status').toString();
          statusGetModigie =
            statusGetModigie.substring(0, 1).toUpperCase() +
            statusGetModigie.substring(1, statusGetModigie.length());

          modiRec.modigie__Get_Modigie_Job_Status__c = statusGetModigie;
          modiRec.modigie__Status__c = 'In process';
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
              'modigie__Validation_Date_Get_Mobile_Number__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Get_Mobile_Number__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Get_Mobile_Number__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Jobid__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Jobid__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Jobid__c'
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
              'modigie__Get_Modigie_Job_Status__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Get_Modigie_Job_Status__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Get_Modigie_Job_Status__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Status__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Status__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Status__c'
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
            throw new UnresponsiveLeadContactBatchClassException(
              'User does not have permission to query modigie object.'
            );
          }
        }

        List<modigie__Process_Builder_Switch__c> processSwitch = [
          SELECT
            modigie__Limits_No_Limits_Selection__c,
            modigie__Unresponsive_Lead_Invocable_Limits__c,
            modigie__Unresponsive_Lead_Invocable_Usage__c
          FROM modigie__Process_Builder_Switch__c
          WITH SECURITY_ENFORCED
          LIMIT 1
        ];

        if (
          processSwitch.size() > 0 &&
          processSwitch[0]
            .modigie__Limits_No_Limits_Selection__c
            ?.equalsIgnoreCase('Limits') == true
        ) {
          processSwitch[0]
            .modigie__Unresponsive_Lead_Invocable_Usage__c += lstCon.size();
          if (
            FieldLevelSecurityCheck.canReadObject(
              'modigie__Process_Builder_Switch__c'
            ) &&
            FieldLevelSecurityCheck.canCreateObject(
              'modigie__Process_Builder_Switch__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateObject(
              'modigie__Process_Builder_Switch__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Process_Builder_Switch__c',
              'modigie__Unresponsive_Lead_Invocable_Usage__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Process_Builder_Switch__c',
              'modigie__Unresponsive_Lead_Invocable_Usage__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Process_Builder_Switch__c',
              'modigie__Unresponsive_Lead_Invocable_Usage__c'
            )
          ) {
            update processSwitch;
          }
        }
      } else {
        if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
          EmailServiceClass.sendResponseError('UnresponsiveLeadContactBatchClass', response.getStatusCode(), response.getBody());
        }
        modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
        String jsonResponse = response.getBody();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
          jsonResponse
        );
        modigieErrorLog.modigie__Description__c = (String) responseMap.get(
          'message'
        );
        modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
        modigieErrorLog.modigie__Modigie_Service__c = 'Unresponsive Lead';
        modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';

        lstErrorLog.add(modigieErrorLog);
      }
    } catch (Exception e) {
      System.debug(e.getMessage() + e.getStackTraceString());
      throw new UnresponsiveLeadContactBatchClassException(e.getMessage());
    }
  }
  public void finish(Database.BatchableContext bc) {
    if (lstErrorLog.size() > 0) {
      if (
        FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c') &&
        FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') &&
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
    // ModigieCreditInfoClass.saveCreditInfoAfterCallout();
    System.Queueable job = new CreditInfoQueableClass();
    System.enqueueJob(job);

    if (emailMessages.size() > 0) {
      EmailServiceClass.sendEmailForCampaign(emailMessages);
    }
  }

  private class UnresponsiveLeadContactBatchClassException extends Exception {
  }
}