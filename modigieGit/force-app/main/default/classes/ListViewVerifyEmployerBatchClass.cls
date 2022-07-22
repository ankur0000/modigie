public with sharing class ListViewVerifyEmployerBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  List<SObject> lstsObj = new List<SObject>();
  List<modigie__Error_Log__c> lstErrorLog = new List<modigie__Error_Log__c>();
  List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
  List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
  List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();
  String targetAudience, endpoint, contentType;
  String accessToken;
  Set<String> emailMessages = new Set<String>();

  public ListViewVerifyEmployerBatchClass(List<SObject> lstsObj) {
    try {
      modigieCredential = ModigieApiUtils.getServiceAccountDetails();
      List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Verify Employer Job Create' LIMIT 1];
      if(!calloutInfo.isEmpty()){
        endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
        targetAudience = calloutInfo[0].modigie__targetAud__c;
        contentType = calloutInfo[0].modigie__Content_Type__c;
      }

      accessToken =
        'Bearer ' +
        jwtapex.get_access_token(
          modigieCredential[0].modigie__Email__c,
          targetAudience,
          modigieCredential[0].modigie__Private_Key__c
        );
      this.lstsObj = lstsObj;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Verify Employer');
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new ListViewVerifyEmployerBatchClassException(
        'You are not an authorized user.'
      );
    } catch (Exception e) {
      throw new ListViewVerifyEmployerBatchClassException(e.getMessage());
    }
  }

  public List<SObject> start(Database.BatchableContext bc) {
    return lstsObj;
  }
  public void execute(Database.BatchableContext bc, List<SObject> scope) {
    try {
      Boolean containsContact = false;

      Set<Id> setOfKeysIds = new Set<Id>();
      for (SObject sco : scope) {
        setOfKeysIds.add((Id) sco.get('Id'));
        Id recId = (Id) sco.get('Id');
        String sobjectType = recId.getSObjectType().getDescribe().getName();
        if (sobjectType?.equalsIgnoreCase('Contact') == true) {
          containsContact = true;
        }
      }
      Map<Id, Contact> conMap = new Map<Id, Contact>();
      if (containsContact) {
        conMap = new Map<Id, Contact>(
          [
            SELECT id, Account.Name
            FROM Contact
            WHERE Id IN :scope
            WITH SECURITY_ENFORCED
          ]
        );
      }

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
          'value' => 'list-view'
        }
      };
      outerMap.put('customParameters', lstJobLevelCustomParameters);

      List<Map<String, Object>> lstCon = new List<Map<String, Object>>();
      for (SObject sObj : scope) {
        String sobjectType = sObj.getSObjectType().getDescribe().getName();

        String jobSubType = '';

        Map<String, Object> sinCon = new Map<String, Object>();

        if (sObj.get('FirstName') != null) {
          sinCon.put('firstName', sObj.get('FirstName'));
          jobSubType = 'CreateVerifyEmployerJobContactInputName';
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
          jobSubType = 'CreateVerifyEmployerJobContactInputUrl';
        }

        sinCon.put('jobSubType ', jobSubType);

        List<String> lstMobileNumber = new List<String>();

        if (sobj.get('modigie__Modigie_Verified_Number__c') != null) {
          String mobileNumber = (String) sObj.get(
            'modigie__Modigie_Verified_Number__c'
          );

          if (!mobileNumber.startsWith('+')) {
            if (mobileNumber.startsWith('1')) {
              mobileNumber = '+' + mobileNumber;
            } else {
              mobileNumber = '+1' + mobileNumber;
            }
          }

          lstMobileNumber.add(mobileNumber);
        }

        if (sObj.get('MobilePhone') != null) {
          String mobileNumber = (String) sObj.get('MobilePhone');

          if (!mobileNumber.startsWith('+')) {
            if (mobileNumber.startsWith('1')) {
              mobileNumber = '+' + mobileNumber;
            } else {
              mobileNumber = '+1' + mobileNumber;
            }
          }

          lstMobileNumber.add(mobileNumber);
        }

        if (lstMobileNumber.size() > 0) {
          sinCon.put('mobilePhones', lstMobileNumber);
        }

        if (sObj.get('Email') != null) {
          sinCon.put('companyEmail', sObj.get('Email'));
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
      request.setTimeout(60000);
      request.setMethod('POST');

      request.setHeader('Content-Type', contentType);
      request.setHeader('Authorization', accessToken);
      request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);
      request.setEndpoint(
        endpoint
      ); //Production Environment Endpoints
      //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/verifyEmployerJobs?key=' + modigieCredential.modigie__API_Key__c); //Staging Environment Endpoints

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

        if (
          FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
          FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') &&
          FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Verify_Employer__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Verify_Employer__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Verify_Employer__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Validate_Employer_Job_Id__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Validate_Employer_Job_Id__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Validate_Employer_Job_Id__c'
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
            'modigie__Validate_Employer_Job_Status__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Validate_Employer_Job_Status__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Validate_Employer_Job_Status__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Validate_Employer_Status__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Validate_Employer_Status__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Validate_Employer_Status__c'
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
          for (SObject sObj : scope) {
            String sobjectType = sObj.getSObjectType().getDescribe().getName();

            modigie__Modigie__c modiRec = new modigie__Modigie__c();

            if (modigieData.get((ID) sObj.get('Id')) != null) {
              modiRec.Id = modigieData.get((ID) sObj.get('Id'));
            }

            modirec.modigie__Validation_Date_Verify_Employer__c = System.now();
            modiRec.modigie__Validate_Employer_Job_Id__c = jobid;

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

            modiRec.modigie__Validate_Employer_Job_Status__c = statusGetModigie;
            modiRec.modigie__Validate_Employer_Status__c = 'In process';
            modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            //modiRec.modigie__Verify_Employer_Campaign_User__c = UserInfo.getUserId();
            //modiRec.modigie__Campaign_Id_VerifyEmployer__c = campaignId;
            modiRec.modigie__User_VerifyEmployer__c = UserInfo.getUserId();
            modiList.add(modiRec);
          }

          if (
            FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
            FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') &&
            FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Verify_Employer__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Verify_Employer__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Verify_Employer__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Validate_Employer_Job_Id__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Validate_Employer_Job_Id__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Validate_Employer_Job_Id__c'
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
              'modigie__Validate_Employer_Job_Status__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Validate_Employer_Job_Status__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Validate_Employer_Job_Status__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Validate_Employer_Status__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Validate_Employer_Status__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Validate_Employer_Status__c'
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
            if (modiList.size() > 0) {
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
            throw new ListViewVerifyEmployerBatchClassException(
              'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
            );
          } else if (
            lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null
          ) {
            throw new ListViewVerifyEmployerBatchClassException(
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
            }
          }
        }
      } else {
        if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
          EmailServiceClass.sendResponseError('ListViewVerifyEmployerBatchClass', response.getStatusCode(), response.getBody());
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
          for (SObject sObj : scope) {
            String sobjectType = sObj.getSObjectType().getDescribe().getName();

            modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
            String jsonResponse = response.getBody();
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
              jsonResponse
            );
            modigieErrorLog.modigie__Description__c = (String) responseMap.get(
              'message'
            );
            modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();

            if (sobjectType?.equalsIgnoreCase('Contact') == true) {
              modigieErrorLog.modigie__Contact__c = (ID) sObj.get('Id');
            } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
              modigieErrorLog.modigie__Lead__c = (ID) sObj.get('Id');
            }

            modigieErrorLog.modigie__Modigie_Service__c = 'Verify Employer';

            modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';

            emailMessages.add((String) responseMap.get('message'));
            lstErrorLog.add(modigieErrorLog);
          }
        }
      }
    } catch (Exception e) {
      throw new ListViewVerifyEmployerBatchClassException(e.getMessage());
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
    // ModigieCreditInfoClass.saveCreditInfoAfterCallout();
    System.Queueable job = new CreditInfoQueableClass();
    System.enqueueJob(job);

    BatchJobsScheluderClass.scheduleForOneMinute();

    if (!emailMessages.isEmpty()) {
      EmailServiceClass.sendEmailForCampaign(emailMessages);
    }
  }
  private class ListViewVerifyEmployerBatchClassException extends Exception {
  }
}