public with sharing class GetPhoneInsightsButton {
  @AuraEnabled
  public static String getMobileInformation(Id recid) {
    try {
      List<modigie__Modigie_Service_Account__mdt> lstCredentials = ModigieApiUtils.getServiceAccountDetails();
      // List<modigie__Modigie_Credentials__c> lstCredentials = [
      //   SELECT id
      //   FROM modigie__Modigie_Credentials__c
      //   WITH SECURITY_ENFORCED
      //   LIMIT 1
      // ];
      if (!lstCredentials.isEmpty()) {
        String sobjectType = recid.getSObjectType().getDescribe().getName();

        Map<String, Object> result = new Map<String, Object>{
          'isContact' => false,
          'Mobile' => true,
          'Phone' => true,
          'OtherPhone' => true,
          'ModigieValNumber' => true,
          'Alternate1' => true,
          'Alternate2' => true,
          'MobileNumber' => '',
          'PhoneNumber' => '',
          'OtherNumber' => '',
          'ModigieNumber' => '',
          'AlternateNumber1' => '',
          'AlternateNumber2' => ''
        };

        List<modigie__Modigie__c> lstModigie = [
          SELECT Id, modigie__Mobile_2__c, modigie__Mobile_3__c
          FROM modigie__Modigie__c
          WHERE modigie__Parent_Id__c = :recid
          WITH SECURITY_ENFORCED
        ];

        String query = 'SELECT Id,FirstName,MobilePhone,Phone,modigie__Modigie_Verified_Number__c';

        if (sobjectType?.equalsIgnoreCase('Contact') == true) {
          result.put('isContact', true);
          query += ', OtherPhone FROM Contact';
        } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
          query += ' FROM Lead';
        }

        query += ' WHERE Id = :recid WITH SECURITY_ENFORCED';

        SObject sObj = Database.query(query);

        /* if(sObj.get('FirstName') == null){
return 'This request requires First Name and Mobile Phones.  Please update your information and re-submit the request.';
}*/

        if (sObj.get('MobilePhone') != null) {
          result.put('Mobile', false);
          result.put(
            'MobileNumber',
            ' - ' + FormatPhone((String) sObj.get('MobilePhone'))
          );
        }

        if (sObj.get('Phone') != null) {
          result.put('Phone', false);
          result.put(
            'PhoneNumber',
            ' - ' + FormatPhone((String) sObj.get('Phone'))
          );
        }

        if (sobjectType?.equalsIgnoreCase('Contact') == true) {
          if (sObj.get('OtherPhone') != null) {
            result.put('OtherPhone', false);
            result.put(
              'OtherNumber',
              ' - ' + FormatPhone((String) sObj.get('OtherPhone'))
            );
          }
        }

        if (sObj.get('modigie__Modigie_Verified_Number__c') != null) {
          result.put('ModigieValNumber', false);
          result.put(
            'ModigieNumber',
            ' - ' + sObj.get('modigie__Modigie_Verified_Number__c')
          );
        }

        /*   if(lstModigie.size() > 0){
if(lstModigie[0].modigie__Mobile_2__c != null){
result.put('Alternate1', false);
result.put('AlternateNumber1', ' - ' + lstModigie[0].modigie__Mobile_2__c);
}
if(lstModigie[0].modigie__Mobile_3__c != null){
result.put('Alternate2', false);
result.put('AlternateNumber2', ' - ' + lstModigie[0].modigie__Mobile_3__c); 
}
}*/
        return JSON.serialize(result);
      } else {
        throw new GetPhoneInsightsButtonException(
          'You are not an authorized user.'
        );
      }
    } catch (System.QueryException e) {
      throw new GetPhoneInsightsButtonException(
        'You do not have permission to query lead, contact or modigie fields.'
      );
    } catch (Exception e) {
      throw new GetPhoneInsightsButtonException(e.getMessage());
    }
  }

  @AuraEnabled(continuation=true)
  public static Object makeGetCallout(ID recid, String inputNumbers) {
    try {
      List<String> lstInputNumbers = inputNumbers.split(',');
      List<modigie__Modigie_Service_Account__mdt> tokenList = ModigieApiUtils.getServiceAccountDetails();
      // List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
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

      List<modigie__Modigie__c> lstModigie = new List<modigie__Modigie__c>();

      lstModigie = [
        SELECT
          Id,
          modigie__Validation_Date_Alternate_Number2__c,
          modigie__Validation_Date_Alternate_Number1__c,
          modigie__Validation_Date_Modigie_Val_Phone_Number__c,
          modigie__Validation_Date_Other_Phone__c,
          modigie__Validation_Date_Phone__c,
          modigie__Validation_Date_Mobile__c,
          modigie__Verified_Phone_Get_Phone_Insights_OPhone__c,
          modigie__Verified_Phone_Get_Phone_Insights_Alt2__c,
          modigie__Verified_Phone_Get_Phone_Insights_Alt1__c,
          modigie__Verified_Phone_Get_Phone_Insights_ValNum__c,
          modigie__Verified_Phone_Get_Phone_Insights_Phone__c,
          modigie__Verified_Phone_Get_Phone_Insights__c,
          modigie__Phone_Intelligence_Status_Other_Phone__c,
          modigie__Phone_Intelligence_Status_Alt_Number2__c,
          modigie__Phone_Intelligence_Status_Alt_Number1__c,
          modigie__Phone_Intelligence_Status_Modigie_Number__c,
          modigie__Phone_Intelligence_Status_Phone__c,
          modigie__Get_Phone_Intelligence_Job_Status__c,
          modigie__Get_Phone_Intelligence_Job_Status_OPhone__c,
          modigie__Get_Phone_Intelligence_Job_Status_Alt2__c,
          modigie__Get_Phone_Intelligence_Job_Status_Alt1__c,
          modigie__Get_Phone_Intelligence_Job_Status_ValNum__c,
          modigie__Get_Phone_Intelligence_Job_Status_Phone__c,
          modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c,
          modigie__Get_Phone_Intelligence_Job_Id_Alternate2__c,
          modigie__Get_Phone_Intelligence_Job_Id_Alternate1__c,
          modigie__Get_Phone_Intelligence_Job_Id_Val_Number__c,
          modigie__Get_Phone_Intelligence_Job_Id_Phone__c,
          modigie__Get_Phone_Intelligence_Job_Id__c,
          modigie__Mobile_2__c,
          modigie__Mobile_3__c
        FROM modigie__Modigie__c
        WHERE modigie__Parent_Id__c = :recid
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];

      String sobjectType = recid.getSObjectType().getDescribe().getName();

      String query = 'SELECT Id,FirstName,LastName,MobilePhone,Phone,Email,modigie__Modigie_Verified_Number__c,';

      Continuation con = new Continuation(120);

      if (sobjectType?.equalsIgnoreCase('Contact') == true) {
        query += 'AccountId,OtherPhone FROM Contact';
      } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
        query += 'Company FROM Lead';
      }

      query += ' WHERE Id = :recid WITH SECURITY_ENFORCED LIMIT 1';

      List<SObject> lstSobj = Database.query(query);

      if (!lstSobj.isEmpty()) {
        con.continuationMethod = 'getPhoneIntelligenceCallback';
        con.state = recid;

        List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'PhoneIntelligence Job Create' LIMIT 1];
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
        ); // Production Environment Endpoints
        //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/phoneIntelJobs?key=' + tokenList[0].modigie__API_Key__c); //Staging Environment Endpoints
        request.setTimeout(120000);

        Map<String, Object> outerMap = new Map<String, Object>();

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
            'value' => 'detail-view'
          }
        };
        outerMap.put('customParameters', lstJobLevelCustomParameters);

        outerMap.put(
          'options',
          new Map<String, Object>{ 'usePremiumTier' => true }
        );

        Map<String, Object> sinCon = new Map<String, Object>();
        List<String> lstMobileNumber = new List<String>();

        if (lstSobj[0].get('FirstName') != null) {
          sinCon.put('firstName', lstSobj[0].get('FirstName'));
        }

        if (lstSobj[0].get('LastName') != null) {
          sinCon.put('lastName', lstSobj[0].get('LastName'));
        }

        if (
          sobjectType?.equalsIgnoreCase('Contact') == true &&
          lstSobj[0].get('AccountId') != null
        ) {
          String accId = lstSobj[0].get('AccountId').toString();

          List<Account> acc = [
            SELECT Name
            FROM Account
            WHERE Id = :accId
            WITH SECURITY_ENFORCED
            LIMIT 1
          ];
          if (acc[0].Name != null) {
            sinCon.put('company', acc[0].Name);
          }
        } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
          if (lstSobj[0].get('Company') != null) {
            sinCon.put('company', lstSobj[0].get('Company'));
          }
        }

        if (lstSobj[0].get('Email') != null) {
          sinCon.put('companyEmail', lstSobj[0].get('Email'));
        }

        if (lstInputNumbers.contains('Mobile')) {
          if (lstSobj[0].get('MobilePhone') != null) {
            String mobileNumber = (String) lstSobj[0].get('MobilePhone');

            if (!mobileNumber.startsWith('+')) {
              if (mobileNumber.startsWith('1')) {
                mobileNumber = '+' + mobileNumber;
              } else {
                mobileNumber = '+1' + mobileNumber;
              }
            }

            lstMobileNumber.add(mobileNumber);
          }
        }

        if (lstInputNumbers.contains('Phone')) {
          if (lstSobj[0].get('Phone') != null) {
            String mobileNumber = (String) lstSobj[0].get('Phone');

            if (!mobileNumber.startsWith('+')) {
              if (mobileNumber.startsWith('1')) {
                mobileNumber = '+' + mobileNumber;
              } else {
                mobileNumber = '+1' + mobileNumber;
              }
            }

            lstMobileNumber.add(mobileNumber);
          }
        }

        if (lstInputNumbers.contains('Other')) {
          if (sobjectType?.equalsIgnoreCase('Contact') == true) {
            if (lstSobj[0].get('OtherPhone') != null) {
              String mobileNumber = (String) lstSobj[0].get('OtherPhone');

              if (!mobileNumber.startsWith('+')) {
                if (mobileNumber.startsWith('1')) {
                  mobileNumber = '+' + mobileNumber;
                } else {
                  mobileNumber = '+1' + mobileNumber;
                }
              }

              lstMobileNumber.add(mobileNumber);
            }
          }
        }

        /*  if(lstInputNumbers.contains('modigie__Modigie_Verified_Number__c')){
if( lstSobj[0].get('modigie__Modigie_Verified_Number__c') != null){
String mobileNumber = (String)lstSobj[0].get('modigie__Modigie_Verified_Number__c');

if(!mobileNumber.startsWith('+')){
if(mobileNumber.startsWith('1'))
{
mobileNumber = '+' + mobileNumber;
}
else{
mobileNumber = '+1' + mobileNumber;
}

}

lstMobileNumber.add(mobileNumber); 

}
}

if(lstInputNumbers.contains('modigie__Verified_Alt1__c')){
if( lstModigie[0].get('modigie__Mobile_2__c') != null){
String mobileNumber = (String)lstModigie[0].get('modigie__Mobile_2__c');

if(!mobileNumber.startsWith('+')){
if(mobileNumber.startsWith('1'))
{
mobileNumber = '+' + mobileNumber;
}
else{
mobileNumber = '+1' + mobileNumber;
}

}

lstMobileNumber.add(mobileNumber); 

}
}

if(lstInputNumbers.contains('modigie__Verified_Alt2__c')){
if( lstModigie[0].get('modigie__Mobile_3__c') != null){
String mobileNumber = (String)lstModigie[0].get('modigie__Mobile_3__c');

if(!mobileNumber.startsWith('+')){
if(mobileNumber.startsWith('1'))
{
mobileNumber = '+' + mobileNumber;
}
else{
mobileNumber = '+1' + mobileNumber;
}

}

lstMobileNumber.add(mobileNumber); 

}
}*/
        sinCon.put('mobilePhones', lstMobileNumber);

        Map<String, String> customParaMap = new Map<String, String>();

        customParaMap.put('name', 'recordIdAndOrgId');
        customParaMap.put(
          'value',
          lstSobj[0].Id + UserInfo.getOrganizationId()
        );

        Map<String, String> customParaMap2 = new Map<String, String>();

        // Integer requestId = Math.round((Math.random() * (9000) + 1000));

        // customParaMap2.put('name', 'uniqueId');

        // customParaMap2.put('value', requestId+'');

        List<Map<String, String>> lstMap = new List<Map<String, String>>();

        lstMap.add(customParaMap);
        lstMap.add(customParaMap2);
        lstMap.add(
          new Map<String, String>{
            'name' => 'lstNumbers',
            'value' => inputNumbers
          }
        );
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
      errorMap.put('ModigieService', 'Get Phone Insights');
      errorMap.put('SObjectId', recid);
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put(
        'DisplayMessage',
        'You do not have permission to query lead, contact or modigie fields.'
      );
      throw new GetPhoneInsightsButtonException(JSON.serialize(errorMap));
    } catch (Exception e) {
      System.debug('Line Number -->> ' + e.getLineNumber());
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put('DisplayMessage', e.getMessage());
      throw new GetPhoneInsightsButtonException(JSON.serialize(errorMap));
    }
  }
  @AuraEnabled
  public static Object getPhoneIntelligenceCallback(
    List<String> labels,
    Object state
  ) {
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
        errorMap.put('ModigieService', 'Get Phone Insights');
        errorMap.put('SObjectId', state);

        throw new ServerErrorException(JSON.serialize(errorMap));
      }
    } catch (ServerErrorException e) {
      throw new ServerErrorException(e.getMessage());
    } catch (Exception e) {
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put('DisplayMessage', e.getMessage());
      System.debug(e.getStackTraceString()+'--->'+e.getLineNumber());
      throw new GetPhoneInsightsButtonException(JSON.serialize(errorMap));
    }
  }

  @AuraEnabled
  public static String dataToModigie(
    String resMap,
    Id recid,
    String inputNumbers
  ) {
    Map<String, String> returnDataMap = new Map<String, String>();

    try {
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
        throw new GetPhoneInsightsButtonException(
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
              'modigie__User_Id__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Daily_usage_modigie_callouts_by_users__c',
              'modigie__User_Id__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Daily_usage_modigie_callouts_by_users__c',
              'modigie__User_Id__c'
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
            )
          ) {
            upsert modigieUsage;
            //sending email of limit reached
            //check here if User Usage and Limit Difference is 0 (or lesss, ehy not) and if it is send email
            NotificationServiceClass.adhoqLimitCheck();
          }
        }
      }

      Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
        resMap
      );

      if (responseMap.containsKey('id')) {
        String sobjectType = recid.getSObjectType().getDescribe().getName();

        String query = 'SELECT Id,MobilePhone,Phone,modigie__Modigie_Verified_Number__c';

        if (sobjectType?.equalsIgnoreCase('Contact') == true) {
          query += ', OtherPhone FROM Contact';
        } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
          query += ' FROM Lead';
        }

        query += ' WHERE Id = :recid WITH SECURITY_ENFORCED';
        SObject sObj = Database.query(query);

        List<modigie__Modigie__c> lstModigie = new List<modigie__Modigie__c>();
        List<String> lstInputNumbers = inputNumbers.split(',');

        String jobid = responseMap.get('id').toString();

        Map<String, String> securityMap = new Map<String, String>();
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Id__c',
          'modigie__Modigie__c'
        );
        securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Status__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Phone_Intelligence_Status__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Validation_Date_Mobile__c',
          'modigie__Modigie__c'
        );
        securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Phone_Name_Match__c', 'modigie__Modigie__c');
        securityMap.put(
          'modigie__Day_of_Week_Detail__c',
          'modigie__Modigie__c'
        );
        securityMap.put('modigie__Line_Activity__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Phone_Type__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Best_Time_to_Call__c', 'modigie__Modigie__c');
        securityMap.put(
          'modigie__Verified_Phone_Get_Phone_Insights__c',
          'modigie__Modigie__c'
        );

        securityMap.put(
          'modigie__Accuracy_Match_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Day_of_Week_Detail_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Line_Activity_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put('modigie__Phone_Type_Phone__c', 'modigie__Modigie__c');
        securityMap.put(
          'modigie__Best_Time_to_Call_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Verified_Phone_Get_Phone_Insights_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Phone_Intelligence_Status_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Id_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Status_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Validation_Date_Phone__c',
          'modigie__Modigie__c'
        );

        securityMap.put(
          'modigie__Accuracy_Match_Other_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Day_of_Week_Detail_Other_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Line_Activity_Other_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Phone_Type_Other_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Best_Time_to_Call_Phone_Other_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Verified_Phone_Get_Phone_Insights_OPhone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Phone_Intelligence_Status_Other_Phone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Validation_Date_Other_Phone__c',
          'modigie__Modigie__c'
        );

        securityMap.put(
          'modigie__Accuracy_Match_Modigie_Validated_Number__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Day_of_Week_Detail_Modigie_Val_Number__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Line_Activity_Modigie_Validated_Number__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Phone_Type_Modigie_Validated_Number__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Best_Time_to_Call_Validated_Number__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Verified_Phone_Get_Phone_Insights_ValNum__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Phone_Intelligence_Status_Modigie_Number__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Id_Val_Number__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Status_ValNum__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Validation_Date_Modigie_Val_Phone_Number__c',
          'modigie__Modigie__c'
        );

        securityMap.put(
          'modigie__Accuracy_Match_Alternate_Number1__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Day_of_Week_Detail_Alternate_Number1__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Line_Activity_Alternate1__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Phone_Type_Alternate_Number1__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Best_Time_to_Call_Alternate_Number1__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Verified_Phone_Get_Phone_Insights_Alt1__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Phone_Intelligence_Status_Alt_Number1__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Id_Alternate1__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Status_Alt1__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Validation_Date_Alternate_Number1__c',
          'modigie__Modigie__c'
        );

        securityMap.put(
          'modigie__Accuracy_Match_Alternate_Number2__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Day_of_Week_Detail_Alternate_Number2__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Line_Activity_Alternate2__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Phone_Type_Alternate_Number2__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Best_Time_to_Call_Alternate_Number2__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Verified_Phone_Get_Phone_Insights_Alt2__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Phone_Intelligence_Status_Alt_Number2__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Id_Alternate2__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Get_Phone_Intelligence_Job_Status_Alt2__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Validation_Date_Alternate_Number2__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__User_PhoneInsights__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Formatted_Mobile_Number__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Formatted_Phone_Number__c',
          'modigie__Modigie__c'
        );
        securityMap.put(
          'modigie__Formatted_Other_Phone_Number__c',
          'modigie__Modigie__c'
        );

        Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);

        lstModigie = [
          SELECT
            Id,
            modigie__Accuracy_Match_Phone__c,
            modigie__Validation_Date_Alternate_Number2__c,
            modigie__Validation_Date_Alternate_Number1__c,
            modigie__Validation_Date_Modigie_Val_Phone_Number__c,
            modigie__Validation_Date_Other_Phone__c,
            modigie__Validation_Date_Phone__c,
            modigie__Validation_Date_Mobile__c,
            modigie__Verified_Phone_Get_Phone_Insights_OPhone__c,
            modigie__Verified_Phone_Get_Phone_Insights_Alt2__c,
            modigie__Verified_Phone_Get_Phone_Insights_Alt1__c,
            modigie__Verified_Phone_Get_Phone_Insights_ValNum__c,
            modigie__Verified_Phone_Get_Phone_Insights_Phone__c,
            modigie__Verified_Phone_Get_Phone_Insights__c,
            modigie__Phone_Intelligence_Status_Other_Phone__c,
            modigie__Phone_Intelligence_Status_Alt_Number2__c,
            modigie__Phone_Intelligence_Status_Alt_Number1__c,
            modigie__Phone_Intelligence_Status_Modigie_Number__c,
            modigie__Phone_Intelligence_Status_Phone__c,
            modigie__Get_Phone_Intelligence_Job_Status__c,
            modigie__Get_Phone_Intelligence_Job_Status_OPhone__c,
            modigie__Get_Phone_Intelligence_Job_Status_Alt2__c,
            modigie__Get_Phone_Intelligence_Job_Status_Alt1__c,
            modigie__Get_Phone_Intelligence_Job_Status_ValNum__c,
            modigie__Get_Phone_Intelligence_Job_Status_Phone__c,
            modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c,
            modigie__Get_Phone_Intelligence_Job_Id_Alternate2__c,
            modigie__Get_Phone_Intelligence_Job_Id_Alternate1__c,
            modigie__Get_Phone_Intelligence_Job_Id_Val_Number__c,
            modigie__Get_Phone_Intelligence_Job_Id_Phone__c,
            modigie__Get_Phone_Intelligence_Job_Id__c,
            modigie__Mobile_2__c,
            modigie__Mobile_3__c
          FROM modigie__Modigie__c
          WHERE modigie__Parent_Id__c = :recid
          WITH SECURITY_ENFORCED
          LIMIT 1
        ];

        modigie__Modigie__c modigieToUpsert = new modigie__Modigie__c();

        if (lstModigie.size() == 1) {
          modigieToUpsert.Id = lstModigie[0].Id;
        }

        modigieToUpsert.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modigieToUpsert.modigie__Parent_Id__c = recid;
        modigieToUpsert.modigie__User_PhoneInsights__c = UserInfo.getUserId();

        if (sobjectType?.equalsIgnoreCase('Contact') == true) {
          modigieToUpsert.modigie__Contact__c = recid;
        } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
          modigieToUpsert.modigie__Lead__c = recid;
        }

        String statusGetModigie = responseMap.get('status').toString();
        statusGetModigie =
          statusGetModigie.substring(0, 1).toUpperCase() +
          statusGetModigie.substring(1, statusGetModigie.length());

        if (lstInputNumbers.contains('Mobile')) {
          modigieToUpsert.modigie__Phone_Name_Match__c = null;
          modigieToUpsert.modigie__Day_of_Week_Detail__c = null;
          modigieToUpsert.modigie__Line_Activity__c = null;
          modigieToUpsert.modigie__Phone_Type__c = null;
          modigieToUpsert.modigie__Best_Time_to_Call__c = null;
          modigieToUpsert.modigie__Verified_Phone_Get_Phone_Insights__c = getInternationalNumber(
            (String) sObj.get('MobilePhone')
          );
          modigieToUpsert.modigie__Formatted_Mobile_Number__c = FormatPhone(
            (String) sObj.get('MobilePhone')
          );
          modigieToUpsert.modigie__Phone_Intelligence_Status__c = 'In process';
          modigieToUpsert.modigie__Get_Phone_Intelligence_Job_Id__c = jobid;
          modigieToUpsert.modigie__Get_Phone_Intelligence_Job_Status__c = statusGetModigie;
          modigieToUpsert.modigie__Validation_Date_Mobile__c = System.now();
        }

        if (lstInputNumbers.contains('Phone')) {
          modigieToUpsert.modigie__Accuracy_Match_Phone__c = null;
          modigieToUpsert.modigie__Day_of_Week_Detail_Phone__c = null;
          modigieToUpsert.modigie__Line_Activity_Phone__c = null;
          modigieToUpsert.modigie__Phone_Type_Phone__c = null;
          modigieToUpsert.modigie__Best_Time_to_Call_Phone__c = null;
          modigieToUpsert.modigie__Verified_Phone_Get_Phone_Insights_Phone__c = getInternationalNumber(
            (String) sObj.get('Phone')
          );
          modigieToUpsert.modigie__Formatted_Phone_Number__c = FormatPhone(
            (String) sObj.get('Phone')
          );
          modigieToUpsert.modigie__Phone_Intelligence_Status_Phone__c = 'In process';
          modigieToUpsert.modigie__Get_Phone_Intelligence_Job_Id_Phone__c = jobid;
          modigieToUpsert.modigie__Get_Phone_Intelligence_Job_Status_Phone__c = statusGetModigie;
          modigieToUpsert.modigie__Validation_Date_Phone__c = System.now();
        }
        if (lstInputNumbers.contains('Other')) {
          modigieToUpsert.modigie__Accuracy_Match_Other_Phone__c = null;
          modigieToUpsert.modigie__Day_of_Week_Detail_Other_Phone__c = null;
          modigieToUpsert.modigie__Line_Activity_Other_Phone__c = null;
          modigieToUpsert.modigie__Phone_Type_Other_Phone__c = null;
          modigieToUpsert.modigie__Best_Time_to_Call_Phone_Other_Phone__c = null;
          modigieToUpsert.modigie__Verified_Phone_Get_Phone_Insights_OPhone__c = getInternationalNumber(
            (String) sObj.get('OtherPhone')
          );
          modigieToUpsert.modigie__Formatted_Other_Phone_Number__c = FormatPhone(
            (String) sObj.get('OtherPhone')
          );
          modigieToUpsert.modigie__Phone_Intelligence_Status_Other_Phone__c = 'In process';
          modigieToUpsert.modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c = jobid;
          modigieToUpsert.modigie__Get_Phone_Intelligence_Job_Status_OPhone__c = statusGetModigie;
          modigieToUpsert.modigie__Validation_Date_Other_Phone__c = System.now();
        }

        if (check) {
          upsert modigieToUpsert;
          BatchJobsScheluderClass.scheduleForOneMinute();
          return modigieToUpsert.Id;
        }

        System.Queueable job = new CreditInfoQueableClass();
        System.enqueueJob(job);
      }
    } catch (Exception e) {
      throw new GetPhoneInsightsButtonException(e.getMessage());
    }
    return null;
  }
  private static String FormatPhone(String Phone) {
    string nondigits = '[^0-9]';
    string PhoneDigits;

    // remove all non numeric
    PhoneDigits = Phone;

    // 10 digit: reformat with dashes
    if (PhoneDigits.length() == 10)
      return '(' +
        PhoneDigits.substring(0, 3) +
        ') ' +
        PhoneDigits.substring(3, 6) +
        '-' +
        PhoneDigits.substring(6, 10);
    // 11 digit: if starts with 1, format as 10 digit
    if (PhoneDigits.length() == 11) {
      if (PhoneDigits.substring(0, 1)?.equalsIgnoreCase('1') == true) {
        return '(' +
          PhoneDigits.substring(1, 4) +
          ') ' +
          PhoneDigits.substring(4, 7) +
          '-' +
          PhoneDigits.substring(7, 11);
      }
    }

    // if it isn't a 10 or 11 digit number, return the original because
    // it may contain an extension or special information
    return (Phone);
  }

  private static String getInternationalNumber(String phoneNumber) {
    if (!phoneNumber.startsWith('+')) {
      if (phoneNumber.startsWith('1')) {
        phoneNumber = '+' + phoneNumber;
      } else {
        phoneNumber = '+1' + phoneNumber;
      }
    }

    phoneNumber =
      phoneNumber.substring(0, 2) +
      ' ' +
      phoneNumber.substring(2, phoneNumber.length());
    return phoneNumber;
  }
  private class GetPhoneInsightsButtonException extends Exception {
  }
}