/************************************************************************
 *  @authors Tarun Gyanchandani
 *  @date    6 Feb 2020
 *  @name    LeadBatchForGetModigieButton
 *  @description This class is used to make callout when user press Get Modigie Button on Campaign to syncronise Leads.
 ***********************************************************************/
public with sharing class LeadBatchForGetModigieButton implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
  List<modigie__Error_Log__c> lstErrorLog = new List<modigie__Error_Log__c>();
  List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();
  String accessToken;
  String campaignId;
  List<Lead> leadList = new List<Lead>();
  Set<String> emailMessages = new Set<String>();
  String errorLogService = '';
  integer automationCode;
  public LeadBatchForGetModigieButton(
    List<Lead> lList,
    String recid,
    String accToken
  ) {
    try {
      modigieCredential = ModigieApiUtils.getServiceAccountDetails();
      accessToken = accToken;
      leadList = lList;
      campaignId = recid;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get Modigie');
      errorMap.put('SObjectId', recid);
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new LeadBatchForGetModigieButtonException(
        'You are not an authorized user.'
      );
    } catch (Exception e) {
      throw new LeadBatchForGetModigieButtonException(
        e.getMessage() + 'LeadBatch'
      );
    }
  }
  public LeadBatchForGetModigieButton(
    List<Lead> lList,
    integer automationCodes
  ) {
    try {
      this.automationCode = automationCodes;
      modigieCredential = ModigieApiUtils.getServiceAccountDetails();
      leadList = lList;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get Modigie Job Automation');
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new LeadBatchForGetModigieButtonException(
        'You are not an authorized user.'
      );
    } catch (Exception e) {
      throw new LeadBatchForGetModigieButtonException(
        e.getMessage() + 'LeadBatch'
      );
    }
  }
  public List<Lead> start(Database.BatchableContext bc) {
    return leadList;
  }

  public void execute(Database.BatchableContext bc, List<Lead> scope) {
    try {
      List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Mobile Phone Job Create' LIMIT 1];
      String targetAudience, endpoint, contentType;
      if(!calloutInfo.isEmpty()){
        endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
        targetAudience = calloutInfo[0].modigie__targetAud__c;
        contentType = calloutInfo[0].modigie__Content_Type__c;
      }

      if (campaignId == null) {
        accessToken =
          'Bearer ' +
          jwtapex.get_access_token(
            modigieCredential[0].modigie__Email__c,
            targetAudience,
            modigieCredential[0].modigie__Private_Key__c
          );
      }

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

      String getModigieJobSource = '';
      system.debug('step 1');
      if (campaignId != null) {
        // system.debug('step 2');
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','CampaignId');
        // jobCustomParameter.put('value',campaignId);
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        getModigieJobSource = 'Campaign';
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-campaign',
            'value' => campaignId
          }
        );
      } else if (automationCode == 0) {
        // system.debug('step 3');
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','New Lead creation get modigie');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        getModigieJobSource = 'New Lead Automation';
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetModigie-Automation-New-Lead'
          }
        );
      } else if (automationCode == 1) {
        // system.debug('step 4');
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','Unresponsive Lead creation get modigie');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        getModigieJobSource = 'Unresponsive Lead Automation';
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetModigie-Automation-Unresponsive-Lead'
          }
        );
      } else if (automationCode == 2) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','modigie-client-sfdc-automation');
        // jobCustomParameter.put('value','Modigie Custom Automation Get Modigie');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetModigie-Custom-Automation-Invocable'
          }
        );
      } else if (automationCode == 3) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','modigie-client-sfdc-automation');
        // jobCustomParameter.put('value','Get Modigie Lead Campaign');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        getModigieJobSource = 'New Campaign Member Automation';
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetModigie-Automation-New-CampaignMember'
          }
        );
      } else if (automationCode == 4) {
        getModigieJobSource = 'Sales Engagement Tool Automation';
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetModigie-Automation-SalesEngagement'
          }
        );
      }

      outerMap.put('customParameters', lstJobLevelCustomParameters);

      List<Map<String, Object>> lstCon = new List<Map<String, Object>>();

      for (Lead leadrec : scope) {
        system.debug('step 5');
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

        List<String> lstMobileNumber = new List<String>();

        if (leadrec.MobilePhone != null) {
          String mobileNumber = (String) leadrec.MobilePhone;

          if (!mobileNumber.startsWith('+')) {
            if (mobileNumber.startsWith('1')) {
              mobileNumber = '+' + mobileNumber;
            } else {
              mobileNumber = '+1' + mobileNumber;
            }
          }

          lstMobileNumber.add(mobileNumber);
        }

        if (!lstMobileNumber.isEmpty()) {
          sinCon.put('mobilePhones', lstMobileNumber);
        }

        Map<String, String> customParaMap = new Map<String, String>();

        customParaMap.put('name', 'recordIdAndOrgId');
        customParaMap.put('value', leadrec.Id + UserInfo.getOrganizationId());

        List<Map<String, String>> lstMap = new List<Map<String, String>>();

        lstMap.add(customParaMap);
        sinCon.put('customParameters', lstMap);

        if (leadrec.Email != null) {
          sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputEmail');
          sinCon.put('companyEmail', leadrec.Email);
          if (
            leadrec.modigie__linkedin_url__c != null &&
            GetModigieButton.checkValidLinkedInUrl(
              leadrec.modigie__linkedin_url__c
            )
          ) {
            sinCon.put('linkedInUrl', leadrec.modigie__linkedin_url__c);
          }
        } else if (
          leadrec.modigie__linkedin_url__c != null &&
          GetModigieButton.checkValidLinkedInUrl(
            leadrec.modigie__linkedin_url__c
          )
        ) {
          sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputLinkedIn');
          sinCon.put('linkedInUrl', leadrec.modigie__linkedin_url__c);
        } else {
          continue;
        }
        lstCon.add(sinCon);
      }

      outerMap.put('contacts', lstCon);
      system.debug('step 6');
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setMethod('POST');
      request.setHeader('Content-Type', contentType);
      request.setHeader('Authorization', accessToken);
      request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);
      request.setEndpoint(
        endpoint
      ); //Production Environment Endpoints
      //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/mobilePhoneJobs?key=' + modigieCredential.modigie__API_Key__c); //Staging Environment Endpoints

      request.setBody(JSON.serialize(outerMap));

      System.debug(
        ' 218 Leadbtachforgetmodigiebutton request body -->>' +
        JSON.serialize(outerMap)
      );

      request.setTimeout(120000);
      HttpResponse response = http.send(request);
      if (response.getStatusCode() == 202) {
        system.debug('step 7');

        String jsonResponse = response.getBody();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
          jsonResponse
        );

        String jobid = responseMap.get('id').toString();

        if (
          FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
          FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') &&
          FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
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
            'modigie__Get_Mobile_Campaign_User__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Get_Mobile_Campaign_User__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Get_Mobile_Campaign_User__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Campaign_Id_GetMobileNumber__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Campaign_Id_GetMobileNumber__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Campaign_Id_GetMobileNumber__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Mobile__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Mobile__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Mobile__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Modigie_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Modigie_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Modigie_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Modigie_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Modigie_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Modigie_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Modigie_Val_Number__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Modigie_Val_Number__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Modigie_Val_Number__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Modigie_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Modigie_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Modigie_Validated_Number__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__LinkedIn_Url_Get_Mobile_Number__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__LinkedIn_Url_Get_Mobile_Number__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__LinkedIn_Url_Get_Mobile_Number__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Current_Title_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Current_Title_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Current_Title_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Current_Employer_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Current_Employer_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Current_Employer_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Current_Country_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Current_Country_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Current_Country_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Company_Name_Matches_Records_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Company_Name_Matches_Records_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Company_Name_Matches_Records_Get_Modigie__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Mobile_2__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Mobile_2__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Mobile_2__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Mobile_3__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Mobile_3__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Mobile_3__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Alternate1__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Alternate1__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Alternate1__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Alternate2__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Alternate2__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Alternate2__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Alternate_Number1__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Alternate_Number2__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Alternate_Number2__c'
          )
        ) {
          system.debug('step 8');
          for (Lead ld : scope) {
            modigie__Modigie__c modiRec = new modigie__Modigie__c();
            if (ld.modigie__Modigie__r.size() > 0) {
              modiRec.Id = ld.modigie__Modigie__r[0].Id;
            }

            modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
            modiRec.modigie__Jobid__c = jobid;
            modiRec.modigie__Lead__c = ld.id;
            modiRec.modigie__Parent_Id__c = ld.id;

            String statusGetModigie = responseMap.get('status').toString();
            statusGetModigie =
              statusGetModigie.substring(0, 1).toUpperCase() +
              statusGetModigie.substring(1, statusGetModigie.length());

            modiRec.modigie__Get_Modigie_Job_Status__c = statusGetModigie;
            modiRec.modigie__Status__c = 'In process';
            modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            if (campaignId != null) {
              system.debug('step 9');
              modiRec.modigie__Campaign_Id_GetMobileNumber__c = campaignId;
              modiRec.modigie__Get_Mobile_Campaign_User__c = UserInfo.getUserId();
            } else {
              system.debug('step 10');
              modiRec.modigie__User_GetModigieMobile__c = UserInfo.getUserId();
            }

            modirec.modigie__Mobile__c = null;
            modirec.modigie__Accuracy_Match_Modigie_Validated_Number__c = null;
            modirec.modigie__Line_Activity_Modigie_Validated_Number__c = null;
            modirec.modigie__Best_Time_to_Call_Validated_Number__c = null;
            modirec.modigie__Day_of_Week_Detail_Modigie_Val_Number__c = null;
            modirec.modigie__Phone_Type_Modigie_Validated_Number__c = null;
            modirec.modigie__Phone_Type_Alternate_Number1__c = null;
            modirec.modigie__Phone_Type_Alternate_Number2__c = null;
            modirec.modigie__LinkedIn_Url_Get_Mobile_Number__c = null;
            modirec.modigie__Current_Title_Get_Modigie__c = null;
            modirec.modigie__Current_Employer_Get_Modigie__c = null;
            modirec.modigie__Current_Country_Get_Modigie__c = null;
            modirec.modigie__Company_Name_Matches_Records_Get_Modigie__c = null;
            modirec.modigie__Mobile_2__c = null;
            modirec.modigie__Mobile_3__c = null;
            modirec.modigie__Accuracy_Match_Alternate_Number1__c = null;
            modirec.modigie__Accuracy_Match_Alternate_Number2__c = null;
            modirec.modigie__Line_Activity_Alternate1__c = null;
            modirec.modigie__Line_Activity_Alternate2__c = null;
            modirec.modigie__Day_of_Week_Detail_Alternate_Number1__c = null;
            modirec.modigie__Day_of_Week_Detail_Alternate_Number2__c = null;
            modirec.modigie__Best_Time_to_Call_Alternate_Number1__c = null;
            modirec.modigie__Best_Time_to_Call_Alternate_Number2__c = null;
            modiRec.modigie__Get_Modigie_Job_Source__c = getModigieJobSource;

            modiList.add(modiRec);
          }

          if (!modiList.isEmpty())
            upsert modiList;
        }
        if (campaignId != null) {
          system.debug('step 11');
          List<modigie__Process_Builder_Switch__c> lstPbs = [
            SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c
            FROM modigie__Process_Builder_Switch__c
            WITH SECURITY_ENFORCED
            LIMIT 1
          ];
          if (lstPbs.isEmpty()) {
            throw new LeadBatchForGetModigieButtonException(
              'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
            );
          } else if (
            lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null
          ) {
            throw new LeadBatchForGetModigieButtonException(
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
                ) || true
              ) {
                upsert modigieUsage;
              }
            }
          }
        } else if (automationCode == 0) {
          system.debug('step 12');
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> modigieUsage = [
            SELECT modigie__Get_Modigie_Invocable_Usage__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];

          if (modigieUsage.size() > 0) {
            modigieUsage[0].modigie__Get_Modigie_Invocable_Usage__c =
              modigieUsage[0].modigie__Get_Modigie_Invocable_Usage__c +
              lstCon.size();
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
          }
        } else if (automationCode == 1) {
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> pbs = [
            SELECT
              modigie__Unresponsive_Lead_Get_Modigie_Usage__c,
              modigie__Limits_No_Limits_Selection__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];
          system.debug('step 14');
          if (pbs.size() > 0) {
            if (
              pbs[0]
                .modigie__Limits_No_Limits_Selection__c
                ?.equalsIgnoreCase('Limits') == true
            ) {
              system.debug('if condition');
              pbs[0].modigie__Unresponsive_Lead_Get_Modigie_Usage__c =
                pbs[0].modigie__Unresponsive_Lead_Get_Modigie_Usage__c +
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
                upsert pbs;
              }
            }
          }
        } else if (automationCode == 3) {
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> pbs = [
            SELECT
              modigie__Get_Modigie_Campaign_Invocable_Usage__c,
              modigie__Limits_No_Limits_Selection__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];
          system.debug('step 14');
          if (pbs.size() > 0) {
            if (
              pbs[0]
                .modigie__Limits_No_Limits_Selection__c
                ?.equalsIgnoreCase('Limits') == true
            ) {
              system.debug('if condition');
              pbs[0].modigie__Get_Modigie_Campaign_Invocable_Usage__c =
                pbs[0].modigie__Get_Modigie_Campaign_Invocable_Usage__c +
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
                upsert pbs;
              }
            }
          }
        } else if (automationCode == 4) {
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> pbs = [
            SELECT
              modigie__Dynamic_Criteria_Automation_Usage__c,
              modigie__Limits_No_Limits_Selection__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];
          system.debug('step 14');
          if (!pbs.isEmpty()) {
            if (
              pbs[0]
                .modigie__Limits_No_Limits_Selection__c
                ?.equalsIgnoreCase('Limits') == true
            ) {
              system.debug('if condition');
              pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c =
                pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c +
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
                upsert pbs;
                //check limit here, maybe multiple
              }
            }
          }
        }
        //maybe here
      } else if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
          EmailServiceClass.sendResponseError('LeadBatchForGetModigieButton', response.getStatusCode(), response.getBody());
        }

        /*    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();




List<String> toAddresses = new List<String>{'khoppe@modigie.com'};



//List<String> ccAddresses = new List<String>{'support@modigie.com'};

if(!toAddresses.isEmpty()){
mail.setToAddresses(toAddresses);
mail.saveAsActivity= false;
mail.setSubject('Modigie : LeadBatchForGetModigieButton Error');
String emailBody = 'Please check the error response code - ' + response.getStatusCode();
if(responseMap.get('message') != null){
emailBody += 'Message : ' + responseMap.get('message');
}

//emailBody += '\nLine Number : ' + e.getLineNumber();
emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
mail.setPlainTextBody(emailBody);
List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

}*/
        //1.67.1 - Commented and replaced by above EmailServiceClass.sendResponseError()
        /*
        
        String jsonResponse = response.getBody();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
          jsonResponse
        );

        if (responseMap.get('message') != null) {
          List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [
            SELECT Id, modigie__Error_Message__c
            FROM modigie__Modigie_Batch_Class_Internal_Error_List__c
          ];
          List<String> lstStrErr = new List<String>();
          for (
            modigie__Modigie_Batch_Class_Internal_Error_List__c batchClassError : lstBatchClassError
          ) {
            lstStrErr.add(batchClassError.modigie__Error_Message__c);
          }

          if (!lstStrErr.contains(String.valueOf(responseMap.get('message')))) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            List<String> toAddresses = new List<String>();
            toAddresses.add('support@modigie.com');
            toAddresses.add('support-salesforce@modigie.com');
            if (!toAddresses.isEmpty()) {
              mail.setToAddresses(toAddresses);
              mail.saveAsActivity = false;
              mail.setSubject('Modigie : LeadBatchForGetModigieButton Error');
              String emailBody =
                'Please check the error message - ' +
                responseMap.get('message');

              emailBody +=
                '\nOrganization Name : ' + UserInfo.getOrganizationName();
              emailBody +=
                '\nOrganization Id : ' + UserInfo.getOrganizationId();
              mail.setPlainTextBody(emailBody);
              List<Messaging.SendEmailResult> results = Messaging.sendEmail(
                new List<Messaging.SingleEmailMessage>{ mail }
              );
              insert new modigie__Modigie_Batch_Class_Internal_Error_List__c(
                Name = String.valueOf(lstBatchClassError.size() + 1),
                modigie__Error_Message__c = String.valueOf(
                  responseMap.get('message')
                )
              );
            }
          }
        }*/

        /*

if(FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c')&&
FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c')&&
FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Description__c')&&
FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Description__c')&&
FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Error_Code__c')&&
FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Error_Code__c')&&
FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Modigie_Service__c')&&
FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Modigie_Service__c')&&
FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Validation_Key__c')&&
FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Validation_Key__c')&&
FieldLevelSecurityCheck.canReadField('modigie__Error_Log__c','modigie__Campaign__c')&&
FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c','modigie__Campaign__c'))
{

if(campaignId != null){
modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
String jsonResponse = response.getBody();
Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
modigieErrorLog.modigie__Description__c = (String)responseMap.get('message');
modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
modigieErrorLog.modigie__Modigie_Service__c = 'Get Modigie';
modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
modigieErrorLog.modigie__Campaign__c = campaignId;

lstErrorLog.add(modigieErrorLog);
}
else{
for(Lead sObj : scope){
modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
String jsonResponse = response.getBody();
Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
modigieErrorLog.modigie__Description__c = (String)responseMap.get('message');
modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
if(automationCode == 0){
modigieErrorLog.modigie__Modigie_Service__c = 'Get Modigie Job Automation';
}
else if(automationCode == 1){
modigieErrorLog.modigie__Modigie_Service__c = 'Unresponsive Lead Get Modigie';
}
else  if(automationCode == 2){
modigieErrorLog.modigie__Modigie_Service__c = 'Modigie Custom Automation Get Modigie';
}
else if(automationCode == 3){
modigieErrorLog.modigie__Modigie_Service__c = 'Get Modigie Lead Campaign Automation';
}
modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';

Id recId = sObj.Id;
String sobjectType = recId.getSObjectType().getDescribe().getName();

if(sobjectType.equalsIgnoreCase('Contact')){
modigieErrorLog.modigie__Contact__c = recId;
}
else if(sobjectType.equalsIgnoreCase('Lead')){
modigieErrorLog.modigie__Lead__c = recId;
}
lstErrorLog.add(modigieErrorLog);
} 
}



}*/
      //}

      // throw new LeadBatchForGetModigieButtonException('For testing and debugging');
    } catch (Exception e) {
      //call here Error Email
      EmailServiceClass.sendErrorEmail('LeadBatchForGetModigieButton Error', e);
      /*try {
        System.debug('LeadBatchForGetModigieButton -->' + e.getLineNumber());
        List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [
          SELECT Id, modigie__Error_Message__c
          FROM modigie__Modigie_Batch_Class_Internal_Error_List__c
        ];
        List<String> lstStrErr = new List<String>();
        for (
          modigie__Modigie_Batch_Class_Internal_Error_List__c batchClassError : lstBatchClassError
        ) {
          lstStrErr.add(batchClassError.modigie__Error_Message__c);
        }

        if (!lstStrErr.contains(e.getMessage())) {
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

          List<String> toAddresses = new List<String>{ 'pratik@cyntexa.com','ashishsharma@cyntexa.com' };
          if (!toAddresses.isEmpty()) {
            mail.setToAddresses(toAddresses);
            mail.saveAsActivity = false;
            mail.setSubject('Modigie : LeadBatchForGetModigieButton Error');
            String emailBody =
              'Please check the error message - ' + e.getMessage();
            emailBody += '\nLine Number : ' + e.getLineNumber();
            emailBody +=
              '\nOrganization Name : ' + UserInfo.getOrganizationName();
            emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
            mail.setPlainTextBody(emailBody);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(
              new List<Messaging.SingleEmailMessage>{ mail }
            );
            insert new modigie__Modigie_Batch_Class_Internal_Error_List__c(
              Name = String.valueOf(lstBatchClassError.size() + 1),
              modigie__Error_Message__c = e.getMessage()
            );
          }
        }
      } catch (Exception exx) {
      }*/
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
    System.Queueable job = new CreditInfoQueableClass();
    System.enqueueJob(job);

    BatchJobsScheluderClass.scheduleForOneMinute();

    if (!emailMessages.isEmpty()) {
      EmailServiceClass.sendEmailForCampaign(emailMessages);
    }
  }
  private class LeadBatchForGetModigieButtonException extends Exception {
  }
}