/************************************************************************
 *  @authors Tarun Gyanchandani
 *  @date    30 June 2020
 *  @name    ContactBatchForGetLinkedInButton
 *  @description This class is used to make callout when user press Get Linkedin Button on Campaign.
 ***********************************************************************/
public with sharing class ContactBatchForGetLinkedinButton implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
  List<modigie__Error_Log__c> lstErrorLog = new List<modigie__Error_Log__c>();
  List<modigie__Modigie_Service_Account__mdt> modigieCredential = ModigieApiUtils.getServiceAccountDetails();
  String accessToken;
  String campaignId;
  List<Contact> contactList = new List<Contact>();
  Set<String> emailMessages = new Set<String>();
  Integer automationCode;

  public ContactBatchForGetLinkedinButton(List<Contact> conList, Id recid) {
    try {

      contactList = conList;
      campaignId = recid;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get LinkedIn');
      errorMap.put('SObjectId', recid);
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new ContactBatchForGetLinkedinButtonException(
        'You do not have permission to query Modigie Credentials.'
      );
    } catch (Exception e) {
      throw new ContactBatchForGetLinkedinButtonException(e.getMessage());
    }
  }
  public ContactBatchForGetLinkedinButton(
    List<Contact> conList,
    Integer automationCode
  ) {
    try {
      contactList = conList;
      this.automationCode = automationCode;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get Modigie Job Automation');
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new ContactBatchForGetLinkedinButtonException(
        'You do not have permission to query Modigie Credentials.'
      );
    } catch (Exception e) {
      throw new ContactBatchForGetLinkedinButtonException(
        e.getMessage() + 'ContactBatch'
      );
    }
  }
  public List<Contact> start(Database.BatchableContext bc) {
    return contactList;
  }

  public void execute(Database.BatchableContext bc, List<Contact> scope) {
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
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-campaign',
            'value' => campaignId
          }
        );
        //outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
      } else if (automationCode == 0) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','New Lead creation get modigie');

        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetLinkedIn-Automation-New-Contact'
          }
        );

        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
      } else if (automationCode == 1) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','Modigie Custom Automation Get LinkedIn');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});

        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetLinkedIn-Custom-Invocable-Automation'
          }
        );
      } else if (automationCode == 2) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','Get LinkedIn Campaign Automation');
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

      //for(Contact con : [SELECT Id, Account.Name, FirstName, LastName, Email, modigie__linkedin_url__c, modigie__Company_URL__c FROM Contact WHERE Id In :setOfContactIds])
      for (Contact con : scope) {
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
      request.setHeader('Content-Type', ' application/json');
      request.setHeader('Authorization', accessToken);
      request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);

      request.setEndpoint(
        endpoint
      ); // Production Environment Endpoints
      //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/linkedInUrlJobs?key=' + modigieCredential.modigie__API_Key__c); // Staging Environment Endpoints
      request.setBody(JSON.serialize(outerMap));

      request.setTimeout(120000);

      HttpResponse response = http.send(request);
      if (response.getStatusCode() == 202) {
        String jsonResponse = response.getBody();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
          jsonResponse
        );

        String jobid = responseMap.get('id').toString();

        /*Map<String, String> securityMap = new Map<String, String>();
                securityMap.put('modigie__Validation_Date_Get_LinkedIn__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Linkedin_Job_Id__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Get_LinkedIn_Job_Status__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
                
                Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);*/

        for (Contact con : scope) {
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

          modiRec.modigie__Linkedin_Status__c = 'In process';
          modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
          if (campaignId != null) {
            modiRec.modigie__Campaign_Id_GetLinkedin__c = campaignId;
            modiRec.modigie__Get_Linkedin_Campaign_User__c = UserInfo.getUserId();
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
              'modigie__Campaign_Id_GetLinkedin__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Campaign_Id_GetLinkedin__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Campaign_Id_GetLinkedin__c'
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
            )
          ) {
            upsert modiList;
          } else {
            throw new ContactBatchForGetLinkedinButtonException(
              'You do not have permission to query modigie fields.'
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
            throw new ContactBatchForGetLinkedinButtonException(
              'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
            );
          } else if (
            lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null
          ) {
            throw new ContactBatchForGetLinkedinButtonException(
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
                (FieldLevelSecurityCheck.canReadObject(
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
                )) || true
              ) {
                upsert modigieUsage;
              }
            } else {
              throw new ContactBatchForGetLinkedinButtonException(
                'User does not have permission to edit modigie daily usage.'
              );
            }
          }
        } else if (automationCode == 0) {
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> modigieUsage = [
            SELECT modigie__LinkedIn_Url_Invocable_Usage__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];

          if (modigieUsage.size() > 0) {
            modigieUsage[0].modigie__LinkedIn_Url_Invocable_Usage__c =
              modigieUsage[0].modigie__LinkedIn_Url_Invocable_Usage__c +
              lstCon.size();
            if (
              (FieldLevelSecurityCheck.canReadObject(
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
              )) || true
            ) {
              upsert modigieUsage;
            }
          }
        } else if (automationCode == 2) {
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> modigieUsage = [
            SELECT
              modigie__LinkedIn_Url_Campaign_Usage__c,
              modigie__Limits_No_Limits_Selection__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];

          if (modigieUsage.size() > 0) {
            if (
              modigieUsage[0]
                .modigie__Limits_No_Limits_Selection__c
                ?.equalsIgnoreCase('Limits') == true
            ) {
              modigieUsage[0].modigie__LinkedIn_Url_Campaign_Usage__c =
                modigieUsage[0].modigie__LinkedIn_Url_Campaign_Usage__c +
                lstCon.size();
              if (
                (FieldLevelSecurityCheck.canReadObject(
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
                )) || true
              ) {
                upsert modigieUsage;
              }
            }
          }
        }
      } else {
        Map<String, String> securityMap = new Map<String, String>();
        securityMap.put('modigie__Description__c', 'modigie__Error_Log__c');
        securityMap.put('modigie__Error_Code__c', 'modigie__Error_Log__c');
        securityMap.put('modigie__Modigie_Service__c', 'modigie__Error_Log__c');
        securityMap.put('modigie__Validation_Key__c', 'modigie__Error_Log__c');

        Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);

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
          lstErrorLog.add(modigieErrorLog);
        } else {
          for (Contact sObj : scope) {
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
            } else if (automationCode == 2) {
              modigieErrorLog.modigie__Modigie_Service__c = 'Get LinkedIn Campaign Automation';
            }
            modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';

            Id recId = sObj.Id;
            String sobjectType = recId.getSObjectType().getDescribe().getName();

            if (sobjectType.equalsIgnoreCase('Contact')) {
              modigieErrorLog.modigie__Contact__c = recId;
            } else if (sobjectType.equalsIgnoreCase('Lead')) {
              modigieErrorLog.modigie__Lead__c = recId;
            }
            lstErrorLog.add(modigieErrorLog);
          }
        }
      }
    } catch (Exception e) {
      throw new ContactBatchForGetLinkedinButtonException(e.getMessage());
    }
  }

  public void finish(Database.BatchableContext bc) {
    
    //sending email of limit reached
    //check here if User Usage and Limit Difference is 0 (or lesss, ehy not) and if it is send email
    NotificationServiceClass.adhoqLimitCheck();
    //if adhoq paste here
    Map<String, String> securityMap = new Map<String, String>();
    securityMap.put('modigie__Description__c', 'modigie__Error_Log__c');
    securityMap.put('modigie__Error_Code__c', 'modigie__Error_Log__c');
    securityMap.put('modigie__Modigie_Service__c', 'modigie__Error_Log__c');
    securityMap.put('modigie__Validation_Key__c', 'modigie__Error_Log__c');
    securityMap.put('modigie__Campaign__c', 'modigie__Error_Log__c');

    Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
    if (check) {
      if (!lstErrorLog.isEmpty()) {
        insert lstErrorLog;
      }
    }
    // ModigieCreditInfoClass.saveCreditInfoAfterCallout();
    System.Queueable job = new CreditInfoQueableClass();
    System.enqueueJob(job);

    if (!emailMessages.isEmpty()) {
      EmailServiceClass.sendEmailForCampaign(emailMessages);
    }

    BatchJobsScheluderClass.scheduleForOneMinute();
  }
  private class ContactBatchForGetLinkedinButtonException extends Exception {
  }
}