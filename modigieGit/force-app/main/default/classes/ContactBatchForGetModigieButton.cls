/*/************************************************************************
 *  @authors Pragati Goyal
 *  @date    6 Feb 2020
 *  @name    ContactBatchForGetModigieButton
 *  @description This class is used to make callout when user press Get Modigie Button on Campaign to syncronise Leads.
 ***********************************************************************/
public with sharing class ContactBatchForGetModigieButton implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  List<modigie__Error_Log__c> lstErrorLog = new List<modigie__Error_Log__c>();
  List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();
  String accessToken;
  String campaignId;
  List<Contact> contactList = new List<Contact>();
  Set<String> emailMessages = new Set<String>();
  Integer automationCode;

  public ContactBatchForGetModigieButton(
    List<Contact> conList,
    String recid,
    String accToken
  ) {
    try {
      modigieCredential = ModigieApiUtils.getServiceAccountDetails();
      accessToken = accToken;
      contactList = conList;
      campaignId = recid;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get Modigie');
      errorMap.put('SObjectId', recid);
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      System.debug('e.getLineNumber() --> ' + e.getLineNumber());
      System.debug('e.getMessage() --> ' + e.getMessage());

      //throw new ContactBatchForGetModigieButtonException('You do not have permission to query modigie credentials.');
    } catch (Exception e) {
      System.debug('e.getLineNumber() --> ' + e.getLineNumber());
      System.debug('e.getMessage() --> ' + e.getMessage());
      //throw new ContactBatchForGetModigieButtonException(e.getMessage() + 'Contact Batch');
    }
  }

  public ContactBatchForGetModigieButton(
    List<Contact> conList,
    integer automationCodes
  ) {
    try {
      this.automationCode = automationCodes;
      modigieCredential = ModigieApiUtils.getServiceAccountDetails();
      contactList = conList;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get Modigie Job Automation');
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new ContactBatchForGetModigieButtonException(
        'You do not have permission to query modigie credentials.'
      );
    } catch (Exception e) {
      throw new ContactBatchForGetModigieButtonException(
        e.getMessage() + 'LeadBatch'
      );
    }
  }

  public ContactBatchForGetModigieButton(List<Contact> conList) {
    try {
      modigieCredential = ModigieApiUtils.getServiceAccountDetails();
      //accessToken = accToken;
      contactList = conList;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get Modigie Job Automation');
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new ContactBatchForGetModigieButtonException(
        'You do not have permission to query modigie credentials.'
      );
    } catch (Exception e) {
      throw new ContactBatchForGetModigieButtonException(
        e.getMessage() + 'ContactBatch'
      );
    }
  }

  public List<Contact> start(Database.BatchableContext bc) {
    return contactList;
  }

  public void execute(Database.BatchableContext bc, List<Contact> scope) {
    try {
      List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Mobile Phone Job Create' LIMIT 1];
      String targetAudience, endpoint, contentType;
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
      //accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-kyaxv4ttua-uc.a.run.app',modigieCredential.modigie__Private_Key__c);

      List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
      Map<String, Object> outerMap = new Map<String, Object>();

      // Integer requestId = Math.round((Math.random() * (9000) + 1000));
      //outerMap.put('id', requestId);

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
      if (campaignId != null) {
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
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','New Contact Get Modigie');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        getModigieJobSource = 'New Contact Automation';
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetModigie-Automation-New-Contact'
          }
        );
      } else if (automationCode == 1) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','Modigie Custom Automation Get Modigie');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetModigie-Custom-Automation-Invocable'
          }
        );
      } else if (automationCode == 2) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','Opportunity Contact Enrichment Get Automation');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        getModigieJobSource = 'Opportunity Contact Enrichment Automation';
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetModigie-Automation-OpportunityContactEnrichment'
          }
        );
      } else if (automationCode == 3) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','Custom Opportunity Contact Enrichment Get Modigie Automation');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
        lstJobLevelCustomParameters.add(
          new Map<String, Object>{
            'name' => 'modigie-client-sfdc-automation',
            'value' => 'GetModigie-Custom-Automation-Invocable-OpportunityContactEnrichment'
          }
        );
      } else if (automationCode == 4) {
        // Map<String,String> jobCustomParameter = new Map<String,String>();
        // jobCustomParameter.put('name','Called from automation');
        // jobCustomParameter.put('value','Get Modigie Campaign Automation');
        // outerMap.put('customParameters', new List<Map<String,String>>{jobCustomParameter});
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

        List<String> lstMobileNumber = new List<String>();

        if (con.MobilePhone != null) {
          String mobileNumber = (String) con.MobilePhone;

          if (!mobileNumber.startsWith('+')) {
            if (mobileNumber.startsWith('1')) {
              mobileNumber = '+' + mobileNumber;
            } else {
              mobileNumber = '+1' + mobileNumber;
            }
          }

          lstMobileNumber.add(mobileNumber);
        }

        sinCon.put('mobilePhones', lstMobileNumber);

        if (con.email != null) {
          sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputEmail');
          sinCon.put('companyEmail', con.Email);
          if (
            con.modigie__linkedin_url__c != null &&
            !con.modigie__linkedin_url__c.containsIgnoreCase('\\sales\\')
          ) {
            sinCon.put('linkedInUrl', con.modigie__linkedin_url__c);
          }
        } else if (con.modigie__linkedin_url__c != null) {
          sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputLinkedIn');
          sinCon.put('linkedInUrl', con.modigie__linkedin_url__c);
        }

        Map<String, String> customParaMap = new Map<String, String>();

        customParaMap.put('name', 'recordIdAndOrgId');
        customParaMap.put('value', con.Id + UserInfo.getOrganizationId());

        List<Map<String, String>> lstMap = new List<Map<String, String>>();

        lstMap.add(customParaMap);
        sinCon.put('customParameters', lstMap);

        lstCon.add(sinCon);
      }

      outerMap.put('contacts', lstCon);

      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setMethod('POST');

      request.setHeader('Content-Type', contentType);
      request.setHeader('Authorization', accessToken);
      request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);
      request.setHeader('X-MODIGIE-SFDC-REQUEST-ID', String.valueOf(Math.round((Math.random() * (9000) + 1000))));
      
      request.setEndpoint(
        endpoint
      ); // Production Environment Endpoints
      //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/mobilePhoneJobs?key=' + modigieCredential.modigie__API_Key__c); //Staging Environment Endpoints
      request.setBody(JSON.serialize(outerMap));
      System.debug(
        'Contact batch for get modigie button -->> ' + JSON.serialize(outerMap)
      );

      request.setTimeout(120000);
      HttpResponse response = http.send(request);
      System.debug('response.getStatusCode() --> ' + response.getStatusCode());

      if (response.getStatusCode() == 202) {
        String jsonResponse = response.getBody();

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
          jsonResponse
        );

        String jobid = responseMap.get('id').toString();

        /*Map<String, String> securityMap = new Map<String, String>();
                securityMap.put('modigie__Jobid__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Status__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Validation_Date_Get_Mobile_Number__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Get_Modigie_Job_Status__c', 'modigie__Modigie__c');
                
                Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);*/

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
          for (Contact con : scope) {
            modigie__Modigie__c modiRec = new modigie__Modigie__c();

            if (con.modigie__Modigie__r.size() > 0) {
              modiRec.Id = con.modigie__Modigie__r[0].Id;
            }

            modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
            modiRec.modigie__Jobid__c = jobid;
            modiRec.modigie__Contact__c = con.id;
            modiRec.modigie__Parent_Id__c = con.id;

            String status = responseMap.get('status').toString();
            status =
              status.substring(0, 1).toUpperCase() +
              status.substring(1, status.length());

            modiRec.modigie__Status__c = 'In process';
            modiRec.modigie__Get_Modigie_Job_Status__c = status;
            modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            if (campaignId != null) {
              modiRec.modigie__Campaign_Id_GetMobileNumber__c = campaignId;
              modiRec.modigie__Get_Mobile_Campaign_User__c = UserInfo.getUserId();
            } else {
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
            upsert modiList;
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
            throw new ContactBatchForGetModigieButtonException(
              'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
            );
          } else if (
            lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null
          ) {
            throw new ContactBatchForGetModigieButtonException(
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
            }
          }
        } else if (automationCode == 0) {
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> pbs = [
            SELECT
              modigie__Get_Modigie_Invocable_Usage__c,
              modigie__Limits_No_Limits_Selection__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];

          if (!pbs.isEmpty()) {
            if (
              !pbs[0]
                .modigie__Limits_No_Limits_Selection__c.equalsIgnoreCase(
                  'No Limits'
                )
            ) {
              pbs[0].modigie__Get_Modigie_Invocable_Usage__c =
                pbs[0].modigie__Get_Modigie_Invocable_Usage__c + lstCon.size();
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
        } else if (automationCode == 2) {
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> pbs = [
            SELECT
              modigie__Opportunity_Contact_Get_Modigie_Usage__c,
              modigie__Limits_No_Limits_Selection__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];

          if (!pbs.isEmpty()) {
            if (
              !pbs[0]
                .modigie__Limits_No_Limits_Selection__c.equalsIgnoreCase(
                  'No Limits'
                )
            ) {
              pbs[0].modigie__Opportunity_Contact_Get_Modigie_Usage__c =
                pbs[0].modigie__Opportunity_Contact_Get_Modigie_Usage__c +
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
        } else if (automationCode == 5) {
          String userId = UserInfo.getUserId();
          List<modigie__Process_Builder_Switch__c> pbs = [
            SELECT
              modigie__Get_Modigie_Campaign_Invocable_Usage__c,
              modigie__Limits_No_Limits_Selection__c
            FROM modigie__Process_Builder_Switch__c SECURITY_ENFORCED
            LIMIT 1
          ];

          if (!pbs.isEmpty()) {
            if (
              pbs[0]
                .modigie__Limits_No_Limits_Selection__c.equalsIgnoreCase(
                  'Limits'
                ) == true
            ) {
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

          if (!pbs.isEmpty()) {
            if (
              pbs[0]
                .modigie__Limits_No_Limits_Selection__c.equalsIgnoreCase(
                  'Limits'
                ) == true
            ) {
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
                //we are updating Usage here, We can check if usage is in certain range to exceeding limit, we can send mail
              }
            }
          }
        }
        //maybe here
      } else {
        if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
          EmailServiceClass.sendResponseError('ContactBatchForGetModigieButton', response.getStatusCode(), response.getBody());
        }
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
            modigieErrorLog.modigie__Modigie_Service__c = 'Get Modigie';
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
                modigieErrorLog.modigie__Modigie_Service__c = 'Get Modigie Job Automation';
              } else if (automationCode == 1) {
                modigieErrorLog.modigie__Modigie_Service__c = 'Modigie Custom Automation Get Modigie';
              } else if (automationCode == 2) {
                modigieErrorLog.modigie__Modigie_Service__c = 'Opportunity Contact Enrichment Get Modigie Automation';
              } else if (automationCode == 3) {
                modigieErrorLog.modigie__Modigie_Service__c = 'Custom Opportunity Contact Enrichment Get Modigie Automation';
              } else if (automationCode == 4) {
                modigieErrorLog.modigie__Modigie_Service__c = 'Sales Engagement Tool Automation';
              }
              modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
              modigieErrorLog.modigie__Contact__c = sObj.Id;
              lstErrorLog.add(modigieErrorLog);
            }
          }

          /* modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
                    String jsonResponse = response.getBody();
                    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                    modigieErrorLog.modigie__Description__c = (String)responseMap.get('message');
                    modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
                    if(campaignId != null){
                        modigieErrorLog.modigie__Modigie_Service__c = 'Get Modigie';
                        modigieErrorLog.modigie__Campaign__c = campaignId;
                    }
                    else{
                        modigieErrorLog.modigie__Modigie_Service__c = 'Get Modigie Job Automation';
                    }
                    modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    emailMessages.add((String)responseMap.get('message'));
                    
                    lstErrorLog.add(modigieErrorLog);*/
        }
      }
    } catch (Exception e) {
      //call here Error Email
      EmailServiceClass.sendErrorEmail('ContactBatchForGetModigieButton Error', e);
      /*System.debug('ContactBatchForGetModigieButton --> ' + e.getLineNumber());
      System.debug('e.getMessage() ' + e.getMessage());
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<String> toAddresses = new List<String>();
      toAddresses.add('pratik@cyntexa.com');
      toAddresses.add('ashishsharma@cyntexa.com');
      if (!toAddresses.isEmpty()) {
        mail.setToAddresses(toAddresses);
        mail.saveAsActivity = false;
        mail.setSubject('Modigie : ContactBatchForGetModigieButton Error');
        String emailBody = 'Please check the error message - ' + e.getMessage();
        emailBody += '\nLine Number : ' + e.getLineNumber();
        emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
        emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
        mail.setPlainTextBody(emailBody);
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(
          new List<Messaging.SingleEmailMessage>{ mail }
        );
      }*/
      //throw new ContactBatchForGetModigieButtonException(e.getMessage());
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

    if (!emailMessages.isEmpty()) {
      EmailServiceClass.sendEmailForCampaign(emailMessages);
    }

    BatchJobsScheluderClass.scheduleForOneMinute();
  }
  private class ContactBatchForGetModigieButtonException extends Exception {
  }
}