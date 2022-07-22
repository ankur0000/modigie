/************************************************************************
 *  @authors Tarun Gyanchandani
 *  @date    22 May 2020
 *  @name    LeadBatchForGetModigieButton
 *  @description This class is used to make callout when user press Get LinkedIn Button on Campaign to syncronise Leads.
 ***********************************************************************/
public with sharing class LeadBatchForGetLinkedInButton implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
  List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
  List<modigie__Error_Log__c> lstErrorLog = new List<modigie__Error_Log__c>();
  List<modigie__Modigie_Service_Account__mdt> modigieCredential = ModigieApiUtils.getServiceAccountDetails();
  // modigie__Modigie_Credentials__c modigieCredential = new modigie__Modigie_Credentials__c();
  String accessToken;
  String campaignId;
  List<Lead> leadList = new List<Lead>();
  Set<String> emailMessages = new Set<String>();
  Integer automationCode;

  public LeadBatchForGetLinkedInButton(List<Lead> lList, Id recid) {
    try {
      // modigieCredential = [
      //   SELECT
      //     Id,
      //     modigie__Api_key__c,
      //     modigie__Credits_Account_Id__c,
      //     modigie__Private_key__c,
      //     modigie__Service_Account_Credentials__c
      //   FROM modigie__Modigie_Credentials__c
      //   WITH SECURITY_ENFORCED
      //   LIMIT 1
      // ];
      // accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',modigieCredential.modigie__Private_Key__c);
      // accessToken = accToken;
      leadList = lList;
      campaignId = recid;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get LinkedIn');
      errorMap.put('SObjectId', recid);
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new LeadBatchForGetLinkedinButtonException(
        'You are not an authrized user.'
      );
    } catch (Exception e) {
      throw new LeadBatchForGetLinkedinButtonException(e.getMessage());
    }
  }
  public LeadBatchForGetLinkedInButton(
    List<Lead> lList,
    Integer automationCode
  ) {
    try {
      // modigieCredential = [
      //   SELECT
      //     Id,
      //     modigie__Api_key__c,
      //     modigie__Credits_Account_Id__c,
      //     modigie__Private_key__c,
      //     modigie__Service_Account_Credentials__c
      //   FROM modigie__Modigie_Credentials__c
      //   WITH SECURITY_ENFORCED
      //   LIMIT 1
      // ];
      leadList = lList;
      this.automationCode = automationCode;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get LinkedIn Job Automation');
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new LeadBatchForGetLinkedinButtonException(
        'You are not an authrized user.'
      );
    } catch (Exception e) {
      throw new LeadBatchForGetLinkedinButtonException(e.getMessage());
    }
  }
  public List<Lead> start(Database.BatchableContext bc) {
    return leadList;
  }

  public void execute(Database.BatchableContext bc, List<Lead> scope) {
    try {
      List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'LinkedIn Job Create' LIMIT 1];
      String targetAudience, endpoint;
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
        }
      };

      if (campaignId != null) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','CampaignId');
        // jobCustomParameter.put('value',campaignId);
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-campaign',
            'value' => campaignId
          }
        );
      } else if (automationCode == 0) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','New Lead creation get linkedin');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetLinkedIn-Automation-New-Lead'
          }
        );
      } else if (automationCode == 1) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','Modigie Custom Automation Get LinkedIn');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetLinkedIn-Custom-Automation-Invocable'
          }
        );
      } else if (automationCode == 2) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','Get LinkedIn Camapaign Automation');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetLinkedIn-Automation-New-CampaignMember'
          }
        );
      }

      outerMap.put('customParameters', lstJobLevelCustomParameters);

      List<Map<String, Object>> lstCon = new List<Map<String, Object>>();

      for (Lead leadrec : scope) {
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
      request.setHeader('Content-Type', ' application/json');
      request.setHeader('Authorization', accessToken);

      request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);
      request.setEndpoint(
        endpoint
      ); //Production Environment Endpoints
      //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/linkedInUrlJobs?key=' + modigieCredential.modigie__API_Key__c); //Staging Environment Endpoints

      request.setBody(JSON.serialize(outerMap));

      request.setTimeout(120000);
      if (
        FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c') &&
        FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') &&
        FieldLevelSecurityCheck.canUpdateObject('modigie__Error_Log__c') &&
        FieldLevelSecurityCheck.canReadField(
          'modigie__Error_Log__c',
          'modigie__Description__c'
        ) &&
        FieldLevelSecurityCheck.canCreateField(
          'modigie__Error_Log__c',
          'modigie__Description__c'
        ) &&
        FieldLevelSecurityCheck.canUpdateField(
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
        FieldLevelSecurityCheck.canUpdateField(
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
        FieldLevelSecurityCheck.canUpdateField(
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
        ) &&
        FieldLevelSecurityCheck.canUpdateField(
          'modigie__Error_Log__c',
          'modigie__Validation_Key__c'
        )
      ) {
        Map<String, String> securityMap1 = new Map<String, String>();
        securityMap1.put('modigie__Description__c', 'modigie__Error_Log__c');
        securityMap1.put('modigie__Error_Code__c', 'modigie__Error_Log__c');
        securityMap1.put(
          'modigie__Modigie_Service__c',
          'modigie__Error_Log__c'
        );
        securityMap1.put('modigie__Validation_Key__c', 'modigie__Error_Log__c');

        Boolean check1 = FieldLevelSecurityCheck.checkSecurity(securityMap1);

        modigie__Error_Log__c modigieErrorLog1 = new modigie__Error_Log__c();

        Map<String, String> securityMap2 = new Map<String, String>();
        securityMap2.put('modigie__Description__c', 'modigie__Error_Log__c');
        securityMap2.put('modigie__Error_Code__c', 'modigie__Error_Log__c');
        securityMap2.put(
          'modigie__Modigie_Service__c',
          'modigie__Error_Log__c'
        );
        securityMap2.put('modigie__Validation_Key__c', 'modigie__Error_Log__c');

        Boolean check2 = FieldLevelSecurityCheck.checkSecurity(securityMap1);

        modigie__Error_Log__c modigieErrorLog2 = new modigie__Error_Log__c();
      }
      HttpResponse response = http.send(request);
      if (response.getStatusCode() == 202) {
        String jsonResponse = response.getBody();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
          jsonResponse
        );

        String jobid = responseMap.get('id').toString();

        Map<String, String> securityMap = new Map<String, String>();
        securityMap.put(
          'modigie__Validation_Date_Get_LinkedIn__c',
          'modigie__Modigie__c'
        );
        securityMap.put('modigie__Linkedin_Job_Id__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
        securityMap.put(
          'modigie__Get_LinkedIn_Job_Status__c',
          'modigie__Modigie__c'
        );
        securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');

        Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);

        for (Lead ld : scope) {
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

          modiRec.modigie__Get_LinkedIn_Job_Status__c = statusGetModigie;
          modiRec.modigie__Linkedin_Status__c = 'In process';
          modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
          if (campaignId != null) {
            modiRec.modigie__Get_Linkedin_Campaign_User__c = UserInfo.getUserId();
            modiRec.modigie__Campaign_Id_GetLinkedin__c = campaignId;
          } else {
            modiRec.modigie__User_GetLinkedin__c = UserInfo.getUserId();
          }
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
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Get_Linkedin_Campaign_User__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Get_Linkedin_Campaign_User__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Get_Linkedin_Campaign_User__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Campaign_Id_GetLinkedin__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Campaign_Id_GetLinkedin__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Campaign_Id_GetLinkedin__c'
            )
          ) {
            upsert modiList;
          } else {
            throw new LeadBatchForGetLinkedinButtonException(
              'User does not have permission to edit modigie object.'
            );
          }
        }
        if (campaignId != null) {
          List<modigie__Process_Builder_Switch__c> lstPbs = [
            SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c
            FROM modigie__Process_Builder_Switch__c
            WITH SECURITY_ENFORCED
            LIMIT 1
          ];
          if (lstPbs.isEmpty()) {
            throw new LeadBatchForGetLinkedinButtonException(
              'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
            );
          } else if (
            lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null
          ) {
            throw new LeadBatchForGetLinkedinButtonException(
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
            }
          }
        } else if (automationCode == 0) {
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> pbs = [
            SELECT
              modigie__LinkedIn_Url_Invocable_Usage__c,
              modigie__Limits_No_Limits_Selection__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];

          if (pbs.size() > 0) {
            if (
              pbs[0]
                .modigie__Limits_No_Limits_Selection__c
                ?.equalsIgnoreCase('Limits') == true
            ) {
              pbs[0].modigie__LinkedIn_Url_Invocable_Usage__c =
                pbs[0].modigie__LinkedIn_Url_Invocable_Usage__c + lstCon.size();
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
                upsert pbs;
              }
            }
          }
        } else if (automationCode == 2) {
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> pbs = [
            SELECT
              modigie__LinkedIn_Url_Campaign_Usage__c,
              modigie__Limits_No_Limits_Selection__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];

          if (pbs.size() > 0) {
            if (
              pbs[0]
                .modigie__Limits_No_Limits_Selection__c
                ?.equalsIgnoreCase('Limits') == true
            ) {
              pbs[0].modigie__LinkedIn_Url_Campaign_Usage__c =
                pbs[0].modigie__LinkedIn_Url_Campaign_Usage__c + lstCon.size();
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
                upsert pbs;
              }
              //check here, there are multiple
            }
          }
        }
      } else {
          if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
            EmailServiceClass.sendResponseError('LeadBatchForGetLinkedInButton', response.getStatusCode(), response.getBody());
          }
        Map<String, String> securityMap = new Map<String, String>();
        securityMap.put('modigie__Description__c', 'modigie__Error_Log__c');
        securityMap.put('modigie__Error_Code__c', 'modigie__Error_Log__c');
        securityMap.put('modigie__Modigie_Service__c', 'modigie__Error_Log__c');
        securityMap.put('modigie__Validation_Key__c', 'modigie__Error_Log__c');

        Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
        if (
          FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c') &&
          FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') &&
          FieldLevelSecurityCheck.canUpdateObject('modigie__Error_Log__c') &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Error_Log__c',
            'modigie__Description__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Error_Log__c',
            'modigie__Description__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
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
          FieldLevelSecurityCheck.canUpdateField(
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
          FieldLevelSecurityCheck.canUpdateField(
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
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Error_Log__c',
            'modigie__Validation_Key__c'
          )
        ) {
          if (campaignId != null) {
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
            modigieErrorLog.modigie__Campaign__c = campaignId;
            if (check)
              lstErrorLog.add(modigieErrorLog);
          } else {
            for (Lead sObj : scope) {
              modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
              String jsonResponse = response.getBody();
              Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
                jsonResponse
              );
              modigieErrorLog.modigie__Description__c = (String) responseMap.get(
                'message'
              );
              modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
              if (automationCode == 0) {
                modigieErrorLog.modigie__Modigie_Service__c = 'Get LinkedIn Modigie Automation';
              } else if (automationCode == 1) {
                modigieErrorLog.modigie__Modigie_Service__c = 'Modigie Custom Automation Get LinkedIn';
              }
              modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';

              Id recId = sObj.Id;
              String sobjectType = recId.getSObjectType()
                .getDescribe()
                .getName();

              if (sobjectType.equalsIgnoreCase('Contact')) {
                modigieErrorLog.modigie__Contact__c = recId;
              } else if (sobjectType.equalsIgnoreCase('Lead')) {
                modigieErrorLog.modigie__Lead__c = recId;
              }
              if (check)
                lstErrorLog.add(modigieErrorLog);
            }
          }
        }
      }
    } catch (Exception e) {
      //   throw new LeadBatchForGetLinkedinButtonException(e.getMessage());
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
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'modigie__Error_Log__c',
          'modigie__Campaign__c'
        ) &&
        FieldLevelSecurityCheck.canCreateField(
          'modigie__Error_Log__c',
          'modigie__Campaign__c'
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
  private class LeadBatchForGetLinkedinButtonException extends Exception {
  }
}