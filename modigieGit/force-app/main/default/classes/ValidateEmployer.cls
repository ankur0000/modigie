public with sharing class ValidateEmployer {
  @AuraEnabled
  public static string checkValidateRecord(ID recid) {
    try {
      // List<modigie__Modigie_Credentials__c> lstCredentials = [
      //   SELECT id
      //   FROM modigie__Modigie_Credentials__c
      //   WITH SECURITY_ENFORCED
      //   LIMIT 1
      // ];
      List<modigie__Modigie_Service_Account__mdt> lstCredentials = ModigieApiUtils.getServiceAccountDetails();
      if (lstCredentials.size() > 0) {
        String result;

        List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();

        String sobjectType = recid.getSObjectType().getDescribe().getName();

        modiList = [
          SELECT
            Name,
            modigie__Parent_Id__c,
            modigie__Validate_Employer_Status__c
          FROM modigie__Modigie__c
          WHERE modigie__Parent_Id__c = :recid
          WITH SECURITY_ENFORCED
          LIMIT 1
        ];

        if (modiList.size() == 1) {
          if (
            modiList[0]
              .modigie__Validate_Employer_Status__c
              ?.equalsIgnoreCase('Validated') == true
          ) {
            result = 'The record is already validated.';
            //result = 'Get Phone Intelligence has been used for this record.';
          } else if (
            modiList[0]
              .modigie__Validate_Employer_Status__c
              ?.equalsIgnoreCase('Not Available') == true
          ) {
            result = 'Verify Employer for this record is not available.';
          } else if (
            modiList[0]
              .modigie__Validate_Employer_Status__c
              ?.equalsIgnoreCase('In process') == true
          ) {
            result = 'Job is already in process.';
          } else {
            result = 'Available';
          }
        } else if (modiList.size() == 0) {
          result = 'Available';
        }

        if (result?.equalsIgnoreCase('Available') == true) {
          if (sobjectType?.equalsIgnoreCase('Contact') == true) {
            List<Contact> con = [
              SELECT
                FirstName,
                LastName,
                MobilePhone,
                Email,
                Account.Name,
                modigie__linkedin_url__c
              FROM Contact
              WHERE
                id = :recId
                AND Account.Name != NULL
                AND (FirstName != NULL
                OR modigie__linkedin_url__c != NULL)
              WITH SECURITY_ENFORCED
            ];
            if (con.size() == 0) {
              result = 'This request requires Company and LinkedIn/First Name. Please update your information and re-submit the request.';
            }
          } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
            List<Lead> ld = [
              SELECT
                FirstName,
                LastName,
                Company,
                Email,
                MobilePhone,
                modigie__linkedin_url__c
              FROM Lead
              WHERE
                id = :recId
                AND (FirstName != NULL
                OR modigie__linkedin_url__c != NULL)
              WITH SECURITY_ENFORCED
            ];

            if (ld.size() == 0) {
              result = 'This request requires Company and LinkedIn/First Name. Please update your information and re-submit the request.';
            }
          }
        }
        return result;
      } else {
        throw new VerifyEmployerException('You are not an authorized user.');
      }
    } catch (System.QueryException e) {
      throw new VerifyEmployerException(
        'You do not have permission to query lead, contact or modigie fields.'
      );
    } catch (Exception e) {
      throw new VerifyEmployerException(e.getMessage());
    }
  }

  @AuraEnabled(continuation=true cacheable=true)
  public static Object makeGetCallout(ID recid) {
    try {
      List<modigie__Modigie_Service_Account__mdt> tokenList = ModigieApiUtils.getServiceAccountDetails();
      
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
      String creditId = creditAccountId;

      List<modigie__Modigie__c> lstModigie = [
        SELECT
          id,
          modigie__Validate_Employer_Job_Id__c,
          modigie__Validate_Employer_Job_Status__c,
          modigie__Validate_Employer_Status__c,
          modigie__Parent_Id__c,
          modigie__Validation_Key__c
        FROM modigie__Modigie__c
        WHERE modigie__Parent_Id__c = :recid
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];

      String sobjectType = recid.getSObjectType().getDescribe().getName();

      String query = 'SELECT Id,FirstName,LastName,MobilePhone,Email,modigie__linkedin_url__c,modigie__Modigie_Verified_Number__c,';

      Continuation con = new Continuation(120);

      if (sobjectType?.equalsIgnoreCase('Contact') == true) {
        query += 'AccountId FROM Contact';
      } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
        query += 'Company FROM Lead';
      }

      query += ' WHERE Id = :recid WITH SECURITY_ENFORCED LIMIT 1';

      List<SObject> lstSobj = Database.query(query);

      if (lstSobj.size() > 0) {
        con.continuationMethod = 'verifyEmployerCallback';
        con.state = recid;

        List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Verify Employer Job Create' LIMIT 1];
        String targetAudience, endpoint, contentType;
        if(!calloutInfo.isEmpty()){
          endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
          targetAudience = calloutInfo[0].modigie__targetAud__c;
          contentType = calloutInfo[0].modigie__Content_Type__c;
        }

        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        String accessToken =
          'Bearer ' +
          jwtapex.get_access_token(
            tokenList[0].modigie__Email__c,
            targetAudience,
            tokenList[0].modigie__Private_Key__c
          );
        //String accessToken = 'Bearer ' + jwtapex.get_access_token(tokenList[0].modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-kyaxv4ttua-uc.a.run.app',tokenList[0].modigie__Private_Key__c);
        request.setHeader('Content-Type', contentType);
        request.setHeader('Authorization', accessToken);

        request.setHeader('x-api-key', tokenList[0].modigie__API_Key__c);
        request.setEndpoint(
          endpoint
        ); //Production Environment Endpoints
        //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/verifyEmployerJobs?key=' + tokenList[0].modigie__API_Key__c); //Staging Environment Endpoints

        request.setTimeout(120000);
        Map<String, Object> outerMap = new Map<String, Object>();
        String jobSubType = '';
        //Integer requestId = Math.round((Math.random() * (9000) + 1000));
        //outerMap.put('id', requestId);
        outerMap.put('creditsId', creditId);
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

        Map<String, Object> sinCon = new Map<String, Object>();

        if (lstSobj[0].get('FirstName') != null) {
          sinCon.put('firstName', lstSobj[0].get('FirstName'));
          jobSubType = 'CreateVerifyEmployerJobContactInputName';
        }

        if (lstSobj[0].get('LastName') != null) {
          sinCon.put('lastName', lstSobj[0].get('LastName'));
        }

        if (sobjectType?.equalsIgnoreCase('Contact') == true) {
          String accId = lstSobj[0].get('AccountId').toString();

          List<Account> acc = [
            SELECT Name
            FROM Account
            WHERE Id = :accId
            WITH SECURITY_ENFORCED
            LIMIT 1
          ];

          sinCon.put('company', acc[0].Name);
        } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
          sinCon.put('company', lstSobj[0].get('Company'));
        }

        if (lstSobj[0].get('Email') != null) {
          sinCon.put('companyEmail', lstSobj[0].get('Email'));
        }

        if (lstSobj[0].get('modigie__Modigie_Verified_Number__c') != null) {
          sinCon.put(
            'mobilePhone',
            lstSobj[0].get('modigie__Modigie_Verified_Number__c')
          );
        } else if (lstSobj[0].get('MobilePhone') != null) {
          sinCon.put('mobilePhone', lstSobj[0].get('MobilePhone'));
        }

        if (lstSobj[0].get('modigie__linkedin_url__c') != null) {
          sinCon.put('linkedInUrl', lstSobj[0].get('modigie__linkedin_url__c'));
          jobSubType = 'CreateVerifyEmployerJobContactInputUrl';
        }

        sinCon.put('jobSubType ', jobSubType);
        Map<String, String> customParaMap = new Map<String, String>();

        customParaMap.put('name', 'recordIdAndOrgId');
        customParaMap.put(
          'value',
          lstSobj[0].Id + UserInfo.getOrganizationId()
        );

        List<Map<String, String>> lstMap = new List<Map<String, String>>();

        lstMap.add(customParaMap);

        sinCon.put('customParameters', lstMap);

        outerMap.put('contacts', new List<Map<String, Object>>{ sinCon });

        request.setBody(JSON.serialize(outerMap));

        con.addHttpRequest(request);
      } else {
        con.addHttpRequest(null);
      }

      return con;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Verify Employer');
      errorMap.put('SObjectId', recid);
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put(
        'DisplayMessage',
        'You do not have permission to query lead, contact or modigie fields.'
      );
      throw new VerifyEmployerException(JSON.serialize(errorMap));
    } catch (Exception e) {
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put('DisplayMessage', e.getMessage());
      throw new VerifyEmployerException(JSON.serialize(errorMap));
    }
  }

  @AuraEnabled(cacheable=true)
  public static Object verifyEmployerCallback(
    List<String> labels,
    Object state
  ) {
    try {
      HttpResponse response = Continuation.getResponse(labels[0]);

      String result = response.getBody();

      if (response.getStatusCode() == 202) {
        return result;
      } else {
        Map<String, Object> mMap = (Map<String, Object>) JSON.deserializeUntyped(
          result
        );
        Map<String, Object> errorMap = new Map<String, Object>();
        String messageToDisplay = '';
        if (!mMap.containsKey('message')) {
          messageToDisplay = 'Internal Server Error';
          errorMap.put('ErrorMessage', messageToDisplay);
        } else if (
          response.getStatusCode() == 400 ||
          response.getStatusCode() == 404
        ) {
          messageToDisplay = 'There seems to be a problem with your Modigie system credentials. Please contact your Modigie Administrator for assistance.';
          errorMap.put('ErrorMessage', (String) mMap.get('message'));
        } else {
          messageToDisplay = (String) mMap.get('message');
          errorMap.put('ErrorMessage', messageToDisplay);
        }

        errorMap.put('DisplayMessage', messageToDisplay);
        errorMap.put('StatusCode', response.getStatusCode());
        errorMap.put('ModigieService', 'Verify Employer');
        errorMap.put('SObjectId', state);

        throw new ServerErrorException(JSON.serialize(errorMap));
      }
    } catch (ServerErrorException e) {
      throw new ServerErrorException(e.getMessage());
    } catch (Exception e) {
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put('DisplayMessage', e.getMessage());
      throw new VerifyEmployerException(JSON.serialize(errorMap));
    }
  }

  @AuraEnabled
  public static String dataToModigie(String resMap, Id recids) {
    String userId = UserInfo.getUserId();
    List<modigie__Process_Builder_Switch__c> lstPbs = [
      SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c
      FROM modigie__Process_Builder_Switch__c
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];

    if (
      lstPbs.isEmpty() ||
      lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null
    ) {
      throw new VerifyEmployerException(
        'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
      );
    }

    if (lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c) {
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
          modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c + 1;
      } else {
        modigieUsage.add(
          new modigie__Daily_usage_modigie_callouts_by_users__c(
            Name = userId,
            modigie__User_Id__c = userId,
            modigie__Number_of_modigie_callouts_in_a_day__c = 1
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
          //Limit Functionality
          //sending email of limit reached
          //check here if User Usage and Limit Difference is 0 (or lesss, ehy not) and if it is send email
          NotificationServiceClass.adhoqLimitCheck();
        }
      }
    }

    Map<String, String> returnDataMap = new Map<String, String>();

    try {
      String jobid;
      Object status;

      String modiRecId;

      List<modigie__Modigie__c> mrec = new List<modigie__Modigie__c>();

      Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
        resMap
      );

      jobid = responseMap.get('id').toString();

      String sobjectType = recids.getSObjectType().getDescribe().getName();

      Map<String, String> securityMap = new Map<String, String>();
      securityMap.put(
        'modigie__Validate_Employer_Job_Id__c',
        'modigie__Modigie__c'
      );
      securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
      securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
      securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
      securityMap.put(
        'modigie__Validate_Employer_Job_Status__c',
        'modigie__Modigie__c'
      );
      securityMap.put(
        'modigie__Validate_Employer_Status__c',
        'modigie__Modigie__c'
      );
      securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
      securityMap.put(
        'modigie__Validation_Date_Verify_Employer__c',
        'modigie__Modigie__c'
      );
      securityMap.put('modigie__User_VerifyEmployer__c', 'modigie__Modigie__c');

      Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);

      mrec = [
        SELECT
          Name,
          modigie__Validate_Employer_Job_Id__c,
          modigie__Validate_Employer_Job_Status__c,
          modigie__Validate_Employer_Status__c,
          modigie__Validation_Date_Verify_Employer__c,
          modigie__Validation_Key__c,
          modigie__Parent_Id__c
        FROM modigie__Modigie__c
        WHERE modigie__Parent_Id__c = :recids
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];

      if (mrec.size() == 1) {
        mrec[0].modigie__Validate_Employer_Job_Id__c = jobid;
        mrec[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';

        String statusGetModigie = responseMap.get('status').toString();
        statusGetModigie =
          statusGetModigie.substring(0, 1).toUpperCase() +
          statusGetModigie.substring(1, statusGetModigie.length());
        mrec[0].modigie__Validate_Employer_Job_Status__c = statusGetModigie;
        mrec[0].modigie__Validate_Employer_Status__c = 'In process';
        mrec[0].modigie__Validation_Date_Verify_Employer__c = System.now();
        mrec[0].modigie__User_VerifyEmployer__c = UserInfo.getUserId();
      } else if (mrec.size() == 0) {
        modigie__Modigie__c modirec = new modigie__Modigie__c();

        modirec.modigie__Validate_Employer_Job_Id__c = jobid;
        modirec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        if (sobjectType?.equalsIgnoreCase('Contact') == true) {
          modirec.modigie__Contact__c = recids;
        } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
          modirec.modigie__Lead__c = recids;
        }
        String statusGetModigie = responseMap.get('status').toString();
        statusGetModigie =
          statusGetModigie.substring(0, 1).toUpperCase() +
          statusGetModigie.substring(1, statusGetModigie.length());
        modirec.modigie__Validate_Employer_Job_Status__c = statusGetModigie;
        modirec.modigie__Validate_Employer_Status__c = 'In process';
        modirec.modigie__Parent_Id__c = recids;
        modirec.modigie__Validation_Date_Verify_Employer__c = System.now();
        modirec.modigie__User_VerifyEmployer__c = UserInfo.getUserId();

        mrec.add(modirec);
      }

      if (check) {
        if (mrec.size() > 0)
          upsert mrec;

        System.Queueable job = new CreditInfoQueableClass();
        System.enqueueJob(job);

        BatchJobsScheluderClass.scheduleForOneMinute();

        returnDataMap.put('Status', String.valueOf(status));
        returnDataMap.put('modiRecId', modiRecId);

        return mrec[0].Id;
      } else {
        throw new VerifyEmployerException(
          'User does not have permission to query modigie object.'
        );
      }
    } catch (Exception e) {
      throw new VerifyEmployerException(e.getMessage());
    }
  }
  private class VerifyEmployerException extends Exception {
  }
}