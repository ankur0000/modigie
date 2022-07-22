/*  List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
if(!lstPbs.isEmpty() && lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c != null){
if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c){
Integer dailyCallout = 0;
String userId = UserInfo.getUserId();
List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieUsage = [SELECT modigie__User_Id__c, modigie__Number_of_modigie_callouts_in_a_day__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WHERE modigie__User_Id__c = :userId WITH SECURITY_ENFORCED LIMIT 1];
if(modigieUsage.size() > 0){
dailyCallout = (Integer)modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c;
}

Map<Id,Integer> userToLimitsMap = LimitsMapClass.getProfileUserLimitsData();

if(userToLimitsMap.containsKey(userId)){
if(userToLimitsMap.get(userId) < dailyCallout + 1){
throw new GetModigieButtonException('You have exceded your daily limit to call modigie services.');
}
}
else{
throw new GetModigieButtonException('You are not assigned limits for modigie services, please contact your system administrator.');
}
}
}
else{
throw new GetModigieButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
}*/

/************************************************************************
 *  @authors Tarun Gyanchandani
 *  @date    10 August 2020
 *  @name    GetModigieButton
 *  @description This class is used by "GetModigieButtonComponent" to make callouts when user press Get Modigie Button.
 ***********************************************************************/
public with sharing class GetModigieButton {
  /************************************************************************
   *  @authors Tarun Gyanchandani
   *  @date    10 August 2020
   *  @name   makeGetCallout (Action Method)
   *  @description This method checks the id from parameter and set the parameter in endpoint for callout.
   *  @Parameters Lead/Contact Id
   *  @return returns a Continuation object.
   ***********************************************************************/

  @AuraEnabled(continuation=true)
  public static Object makeGetCallout(ID recid) {
    try {
      // List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
      List<modigie__Modigie_Service_Account__mdt> tokenList = ModigieApiUtils.getServiceAccountDetails();
      // tokenList = [
      //   SELECT
      //     Name,
      //     modigie__Credits_Account_Id__c,
      //     modigie__API_Key__c,
      //     modigie__Service_Account_Credentials__c,
      //     modigie__Private_Key__c
      //   FROM modigie__Modigie_Credentials__c
      //   WITH SECURITY_ENFORCED
      //   LIMIT 1
      // ];

      if (tokenList.isEmpty()) {
        throw new GetModigieButtonException('You are not authorized user.');
      }

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

      String creditsId = creditAccountId;
      System.debug('line 79'+creditsId);

      String sobjectType = recid.getSObjectType().getDescribe().getName();

      String query = 'SELECT Id,FirstName,LastName,MobilePhone,Email,modigie__linkedin_url__c,';

      Continuation con = new Continuation(120);

      if (sobjectType?.equalsIgnoreCase('Contact') == true) {
        query += 'AccountId FROM Contact';
      } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
        query += 'Company FROM Lead';
      }

      query += ' WHERE Id = :recid WITH SECURITY_ENFORCED LIMIT 1';

      List<SObject> lstSobj = Database.query(query);
      System.debug('line 96'+lstSobj);
      if (lstSobj.size() > 0) {
        con.continuationMethod = 'modigieCallback';
        con.state = recid;

        List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Mobile Phone Job Create' LIMIT 1];
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
        request.setHeader('x-api-key', tokenList[0].modigie__API_Key__c);
        request.setHeader('Content-Type', contentType);
        request.setHeader('Authorization', accessToken);
        request.setHeader('X-MODIGIE-SFDC-REQUEST-ID', String.valueOf(Math.round((Math.random() * (9000) + 1000))));
        request.setEndpoint(
          endpoint
        ); // Production Environment Endpoints

        Map<String, Object> outerMap = new Map<String, Object>();

        // Integer requestId = Math.round((Math.random() * (9000) + 1000));
        // outerMap.put('id', requestId);

        outerMap.put('creditsId', creditsId);
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
        //Map<String,Object> jobLevelCustomParameters = new Map<String,Object> {'modigie-client-name' => 'sfdc', 'modigie-client-sfdc-version' : System.};

        Map<String, Object> sinCon = new Map<String, Object>();

        if (lstSobj[0].get('FirstName') != null) {
          sinCon.put('firstName', lstSobj[0].get('FirstName'));
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
          sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputEmail');
          sinCon.put('companyEmail', lstSobj[0].get('Email'));
          if (
            lstSobj[0].get('modigie__linkedin_url__c') != null &&
            !String.valueOf(lstSobj[0].get('modigie__linkedin_url__c'))
              .containsIgnoreCase('\\sales\\')
          ) {
            sinCon.put(
              'linkedInUrl',
              lstSobj[0].get('modigie__linkedin_url__c')
            );
          }
        } else {
          sinCon.put('jobSubType', 'CreateMobilePhoneJobContactInputLinkedIn');
          if (lstSobj[0].get('modigie__linkedin_url__c') != null) {
            sinCon.put(
              'linkedInUrl',
              lstSobj[0].get('modigie__linkedin_url__c')
            );
          }
        }

        if (lstSobj[0].get('MobilePhone') != null) {
          String mobileNumber = (String) lstSobj[0].get('MobilePhone');

          if (!mobileNumber.startsWith('+')) {
            if (mobileNumber.startsWith('1')) {
              mobileNumber = '+' + mobileNumber;
            } else {
              mobileNumber = '+1' + mobileNumber;
            }
          }
          sinCon.put('mobilePhone', mobileNumber);
        }

        /*   if(lstSobj[0].get('modigie__linkedin_url__c') != null){
                    sinCon.put('linkedInUrl',lstSobj[0].get('modigie__linkedin_url__c'));
                }*/

        Map<String, String> customParaMap = new Map<String, String>();

        customParaMap.put('name', 'recordIdAndOrgId');
        customParaMap.put(
          'value',
          lstSobj[0].Id + UserInfo.getOrganizationId()
        );

        List<Map<String, String>> lstMap = new List<Map<String, String>>();

        lstMap.add(customParaMap);
        //  lstMap.add(new Map<String,String>{'name' => 'SessionId', 'value' => UserInfo.getSessionId()});
        sinCon.put('customParameters', lstMap);
        outerMap.put('contacts', new List<Map<String, Object>>{ sinCon });
        System.debug('line 237'+outerMap);
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
      errorMap.put('ModigieService', 'Get Modigie');
      errorMap.put('SObjectId', recid);
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (Exception e) {
      /*  catch(System.QueryException e){
           System.debug('e.getMessage-->' + e.getMessage());
            Map <String,Object> errorMap = new Map<String,Object>();
            errorMap.put('DisplayMessage','You do not have permission to query lead, contact or modigie fields.');
            throw new GetModigieButtonException(JSON.serialize(errorMap));
        }*/
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put('DisplayMessage', e.getMessage());
      throw new GetModigieButtonException(JSON.serialize(errorMap));
    }
  }

  @AuraEnabled
  public static String modigieCallback(List<String> labels, Object state) {
    try {
      HttpResponse response = Continuation.getResponse(labels[0]);

      String result = response.getBody();
      System.debug(result);

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
        errorMap.put('ModigieService', 'Get Modigie');
        errorMap.put('SObjectId', state);

        throw new ServerErrorException(JSON.serialize(errorMap));
      }
    } catch (ServerErrorException e) {
      throw new ServerErrorException(e.getMessage());
    } catch (Exception e) {
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put('DisplayMessage', e.getMessage());
      throw new GetModigieButtonException(JSON.serialize(errorMap));
    }
  }

  /************************************************************************
   *  @authors Tarun Gyanchandani
   *  @date    10 August 2020
   *  @name   dataToModigie
   *  @description  This method is used to Update data to Modigie Object after callout.
   *  @Parameters Response, Contact/Lead Id
   *  @return Returns status comes in response.
   ***********************************************************************/
  @AuraEnabled
  public static String dataToModigie(String resMap, Id recids) {
    try {
      Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
        resMap
      );

      if (responseMap.containsKey('id')) {
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
          throw new GetModigieButtonException(
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

          if (!modigieUsage.isEmpty()) {
            modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c =
              modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c +
              1;
          } else {
            modigieUsage.add(
              new modigie__Daily_usage_modigie_callouts_by_users__c(
                Name = userId,
                modigie__User_Id__c = userId,
                modigie__Number_of_modigie_callouts_in_a_day__c = 1
              )
            );
          }

          if (!modigieUsage.isEmpty()) {
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
              //sending email of limit reached
              //check here if User Usage and Limit Difference is 0 (or lesss, ehy not) and if it is send email
              NotificationServiceClass.adhoqLimitCheck();
            }
          }
        }

        String jobid;

        String modiRecId;

        List<modigie__Modigie__c> listToUpsert = new List<modigie__Modigie__c>();

        Map<String, Object> jobData = (Map<String, Object>) responseMap.get(
          'job'
        );
        jobid = responseMap.get('id').toString();

        Map<String, String> securityMap = new Map<String, String>();
        securityMap.put('modigie__Jobid__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Status__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Job_start__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Job_end__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Mobile__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
        securityMap.put(
          'modigie__Validation_Date_Get_Mobile_Number__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Modigie_Job_Status__c',
          'modigie__Modigie__c'
        );

        Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);

        String sobjectType = recids.getSObjectType().getDescribe().getName();
        //if(sobjectType == 'Contact'){

        List<modigie__Modigie__c> mrec = [
          SELECT
            Name,
            modigie__Job_start__c,
            modigie__Job_end__c,
            modigie__Jobid__c,
            modigie__Mobile__c,
            modigie__Status__c,
            modigie__Contact__c,
            modigie__Lead__c,
            modigie__Validation_Date_Get_Mobile_Number__c,
            modigie__Validation_Key__c,
            modigie__Parent_Id__c,
            modigie__Get_Modigie_Job_Status__c
          FROM modigie__Modigie__c
          WHERE modigie__Parent_Id__c = :recids
          WITH SECURITY_ENFORCED
          LIMIT 1
        ];

        if (mrec.size() == 1) {
          mrec[0].modigie__Jobid__c = jobid;
          mrec[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';

          String statusGetModigie = responseMap.get('status').toString();
          statusGetModigie =
            statusGetModigie.substring(0, 1).toUpperCase() +
            statusGetModigie.substring(1, statusGetModigie.length());
          mrec[0].modigie__Get_Modigie_Job_Status__c = statusGetModigie;
          mrec[0].modigie__Status__c = 'In process';
          mrec[0].modigie__Validation_Date_Get_Mobile_Number__c = System.now();
          mrec[0].modigie__Parent_Id__c = recids;
          mrec[0].modigie__User_GetModigieMobile__c = UserInfo.getUserId();
          mrec[0].modigie__Mobile__c = null;
          mrec[0].modigie__Accuracy_Match_Modigie_Validated_Number__c = null;
          mrec[0].modigie__Line_Activity_Modigie_Validated_Number__c = null;
          mrec[0].modigie__Best_Time_to_Call_Validated_Number__c = null;
          mrec[0].modigie__Day_of_Week_Detail_Modigie_Val_Number__c = null;
          mrec[0].modigie__Phone_Type_Modigie_Validated_Number__c = null;
          mrec[0].modigie__Phone_Type_Alternate_Number1__c = null;
          mrec[0].modigie__Phone_Type_Alternate_Number2__c = null;
          mrec[0].modigie__LinkedIn_Url_Get_Mobile_Number__c = null;
          mrec[0].modigie__Current_Title_Get_Modigie__c = null;
          mrec[0].modigie__Current_Employer_Get_Modigie__c = null;
          mrec[0].modigie__Current_Country_Get_Modigie__c = null;
          mrec[0].modigie__Company_Name_Matches_Records_Get_Modigie__c = null;
          mrec[0].modigie__Mobile_2__c = null;
          mrec[0].modigie__Mobile_3__c = null;
          mrec[0].modigie__Accuracy_Match_Alternate_Number1__c = null;
          mrec[0].modigie__Accuracy_Match_Alternate_Number2__c = null;
          mrec[0].modigie__Line_Activity_Alternate1__c = null;
          mrec[0].modigie__Line_Activity_Alternate2__c = null;
          mrec[0].modigie__Day_of_Week_Detail_Alternate_Number1__c = null;
          mrec[0].modigie__Day_of_Week_Detail_Alternate_Number2__c = null;
          mrec[0].modigie__Best_Time_to_Call_Alternate_Number1__c = null;
          mrec[0].modigie__Best_Time_to_Call_Alternate_Number2__c = null;
          mrec[0].modigie__Get_Modigie_Job_Source__c = 'Ad Hoc';
          mrec[0].modigie__Validate_Employer_Status__c = null;
          mrec[0].modigie__Employment_Ends_Get_Modigie__c=null;
          // update mrec[0];
          listToUpsert.add(mrec[0]);
          modiRecId = mrec[0].Id;
        } else if (mrec.size() == 0) {
          modigie__Modigie__c modirec = new modigie__Modigie__c();

          modirec.modigie__Jobid__c = jobid;
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

          modirec.modigie__Get_Modigie_Job_Status__c = statusGetModigie;
          modirec.modigie__Status__c = 'In process';
          modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
          modirec.modigie__Parent_Id__c = recids;
          modirec.modigie__User_GetModigieMobile__c = UserInfo.getUserId();
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
          modirec.modigie__Get_Modigie_Job_Source__c = 'Ad Hoc';

          listToUpsert.add(modirec);
          modiRecId = modirec.Id;
        }

        if (check) {
          upsert listToUpsert;
          System.Queueable job = new CreditInfoQueableClass();
          System.enqueueJob(job);

          BatchJobsScheluderClass.scheduleForOneMinute();
          return listToUpsert[0].Id;
        } else {
          throw new GetModigieButtonException(
            'User does not have permission to query modigie object.'
          );
        }
      }
    } catch (Exception e) {
      throw new GetModigieButtonException(e.getMessage());
    }
    return null;
  }

  /***********************************************************************
   *  @authors Tarun Gyanchandani
   *  @date    10 August 2020
   *  @name   checkValidateRecord
   *  @description This method Verifies the status of Record to validated
   *  @Parameters Modigie Id
   *  @return Returns Validation statement for modigie record.
   ***********************************************************************/
  @AuraEnabled
  public static string checkValidateRecord(ID recid) {
    try {
      System.debug('In check Validate Record');
      List<modigie__Modigie_Service_Account__mdt> lstCredentials = ModigieApiUtils.getServiceAccountDetails();
      // List<modigie__Modigie_Credentials__c> lstCredentials = [
      //   SELECT id
      //   FROM modigie__Modigie_Credentials__c
      //   WITH SECURITY_ENFORCED
      //   LIMIT 1
      // ];
      if (!lstCredentials.isEmpty()) {
        String result;
        List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
        String sobjectType = recid.getSObjectType().getDescribe().getName();
        modiList = [
          SELECT Name, modigie__Parent_Id__c, modigie__Status__c
          FROM modigie__Modigie__c
          WHERE modigie__Parent_Id__c = :recid
          WITH SECURITY_ENFORCED
          LIMIT 1
        ];

        if (!modiList.isEmpty()) {
          // if(modiList[0].modigie__Status__c?.equalsIgnoreCase('Validated') == true || modiList[0].modigie__Status__c?.equalsIgnoreCase('Not Available') == true){
          //     result = 'Modigie used';

          // }

          if (
            modiList[0].modigie__Status__c?.equalsIgnoreCase('In process') ==
            true
          ) {
            result = 'Job is already in process.';
          } else {
            result = 'Available';
          }
        } else if (modiList.isEmpty()) {
          result = 'Available';
        }

        if (result?.equalsIgnoreCase('Available') == true) {
          if (sobjectType?.equalsIgnoreCase('Contact') == true) {
            System.debug('Inside If');
            String query = 'SELECT FirstName,LastName,Email,Account.Name, modigie__LinkedIn_Url__c';

            List<modigie__Process_Builder_Switch__c> altLinkedInSetting = getAltLinkedInSetting(
              'Contact'
            );

            Contact con = new Contact();
            if (
              altLinkedInSetting != null &&
              !altLinkedInSetting.isEmpty() &&
              altLinkedInSetting[0]
                .modigie__Is_Active_Contact_Alt_LinkedIn_Url__c != null &&
              altLinkedInSetting[0]
                .modigie__Is_Active_Contact_Alt_LinkedIn_Url__c &&
              altLinkedInSetting[0]
                .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c != null
            ) {
              query +=
                ', ' +
                altLinkedInSetting[0]
                  .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c +
                ' FROM Contact WHERE Id = :recId WITH SECURITY_ENFORCED';
              con = Database.query(query);
              if (
                con != null &&
                con.get(
                  altLinkedInSetting[0]
                    .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
                ) != null &&
                checkValidLinkedInUrl(
                  (String) con.get(
                    altLinkedInSetting[0]
                      .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
                  )
                ) &&
                con.get(
                  altLinkedInSetting[0]
                    .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
                ) != con.modigie__LinkedIn_Url__c &&
                !String.valueOf(
                    con.get(
                      altLinkedInSetting[0]
                        .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
                    )
                  )
                  .containsIgnoreCase('/sales/')
              ) {
                con.modigie__LinkedIn_Url__c = String.valueOf(
                  con.get(
                    altLinkedInSetting[0]
                      .modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
                  )
                );
                update con;
              }
            } else {
              query += ' FROM Contact WHERE id = :recId WITH SECURITY_ENFORCED';
              con = Database.query(query);
            }

            //Contact con = [SELECT FirstName,LastName,Email,Account.Name FROM Contact WHERE id = :recId WITH SECURITY_ENFORCED];

            System.debug('527 -->> ' + con.Account.Name);
            if (
              (con.FirstName == null ||
              con.FirstName == '') ||
              (con.LastName == null ||
              con.LastName == '') ||
              (con.Account.Name == null ||
              con.Account.Name == '') ||
              ((con.Email == null || con.Email == '') &&
              (con.modigie__LinkedIn_Url__c == null ||
              con.modigie__LinkedIn_Url__c == '' ||
              con.modigie__LinkedIn_Url__c.containsIgnoreCase('/sales/')))
            ) {
              result = 'This request requires First Name, Last Name, Account and Email (or LinkedIn).  Please update your information and re-submit the request.';
            }
          } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
            String query = 'SELECT FirstName,LastName,Company,Email, modigie__LinkedIn_Url__c';
            List<modigie__Process_Builder_Switch__c> altLinkedInSetting = getAltLinkedInSetting(
              'Lead'
            );

            Lead ld = new Lead();

            if (
              altLinkedInSetting != null &&
              !altLinkedInSetting.isEmpty() &&
              altLinkedInSetting[0]
                .modigie__Is_Active_Lead_Alt_LinkedIn_Url__c != null &&
              altLinkedInSetting[0]
                .modigie__Is_Active_Lead_Alt_LinkedIn_Url__c &&
              altLinkedInSetting[0]
                .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c != null
            ) {
              query +=
                ', ' +
                altLinkedInSetting[0]
                  .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c +
                ' FROM Lead WHERE Id = :recId WITH SECURITY_ENFORCED';
              ld = Database.query(query);

              if (
                ld != null &&
                ld.get(
                  altLinkedInSetting[0]
                    .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
                ) != null &&
                checkValidLinkedInUrl(
                  (String) ld.get(
                    altLinkedInSetting[0]
                      .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
                  )
                ) &&
                ld.get(
                  altLinkedInSetting[0]
                    .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
                ) != ld.modigie__LinkedIn_Url__c &&
                !String.valueOf(
                    ld.get(
                      altLinkedInSetting[0]
                        .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
                    )
                  )
                  .containsIgnoreCase('/sales/')
              ) {
                ld.modigie__LinkedIn_Url__c = String.valueOf(
                  ld.get(
                    altLinkedInSetting[0]
                      .modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
                  )
                );
                update ld;
              }
            } else {
              query += ' FROM Lead WHERE id = :recId WITH SECURITY_ENFORCED';
              ld = Database.query(query);
            }

            if (
              (ld.FirstName == null ||
              ld.FirstName == '') ||
              (ld.LastName == null ||
              ld.LastName == '') ||
              (ld.Company == null ||
              ld.Company == '') ||
              ((ld.Email == null || ld.Email == '') &&
              (ld.modigie__LinkedIn_Url__c == null ||
              ld.modigie__LinkedIn_Url__c == '' ||
              ld.modigie__LinkedIn_Url__c.containsIgnoreCase('/sales/')))
            ) {
              result = 'This request requires First Name, Last Name, Company and Email (or LinkedIn).  Please update your information and re-submit the request.';
            }
          }
        }
        return result;
      } else {
        throw new GetModigieButtonException('You are not an authorized user.');
      }
    } catch (Exception e) {
      /*catch(System.QueryException e){
            System.debug('Excetion and line number --> ' + e.getMessage() + ' ' + e.getLineNumber());
            throw new GetModigieButtonException('You do not have permission to query lead, contact or modigie fields.');
        }*/
      throw new GetModigieButtonException(
        e.getMessage() +
        'Line number -->> ' +
        e.getLineNumber() +
        ' ' +
        e.getCause() +
        ' ' +
        e.getStackTraceString()
      );
    }
  }

  public static List<modigie__Process_Builder_Switch__c> getAltLinkedInSetting(
    String sObjectName
  ) {
    return Database.query(
      'SELECT ' +
      ((sObjectName == 'Contact')
        ? 'modigie__Contact_Alt_LinkedIn_Url_Field_Name__c, modigie__Is_Active_Contact_Alt_LinkedIn_Url__c '
        : 'modigie__Lead_Alt_LinkedIn_Url_Field_Name__c, modigie__Is_Active_Lead_Alt_LinkedIn_Url__c') +
      ' FROM modigie__Process_Builder_Switch__c LIMIT 1'
    );
  }
  public static Boolean checkValidLinkedInUrl(String linkedInUrl) {
    Pattern staPattern = Pattern.compile(
      '(?i)^(\\/\\/|http:\\/\\/|https:\\/\\/)?(www\\.)?linkedin\\.com\\/in\\/+([\\w\\-]{3,100})+\\/?$'
    );
    Matcher matcherSta = staPattern.matcher(linkedInUrl);
    return matcherSta.find();
  }
  private class GetModigieButtonException extends Exception {
  }
}