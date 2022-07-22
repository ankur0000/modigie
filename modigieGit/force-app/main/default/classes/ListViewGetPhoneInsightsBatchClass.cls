public with sharing class ListViewGetPhoneInsightsBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  List<SObject> lstsObj = new List<SObject>();
  List<modigie__Error_Log__c> lstErrorLog = new List<modigie__Error_Log__c>();
  // modigie__Modigie_Credentials__c modigieCredential = new modigie__Modigie_Credentials__c();
  List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();
  String targetAudience, endpoint, contentType;
  String accessToken;
  Set<String> emailMessages = new Set<String>();

  Map<String, Object> mapInputNumbers = new Map<String, Object>();

  public ListViewGetPhoneInsightsBatchClass(
    List<SObject> lstsObj,
    String inputNumbers
  ) {
    try {
      modigieCredential = ModigieApiUtils.getServiceAccountDetails();

      List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'PhoneIntelligence Job Create' LIMIT 1];
      
      if(!calloutInfo.isEmpty()){
        endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
        targetAudience = calloutInfo[0].modigie__targetAud__c;
        contentType = calloutInfo[0].modigie__Content_Type__c;
      }

      // modigieCredential = [ SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1];
      accessToken = 'Bearer ' + jwtapex.get_access_token(
          modigieCredential[0].modigie__Email__c,
          targetAudience,
          modigieCredential[0].modigie__Private_Key__c
        );
      //accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-kyaxv4ttua-uc.a.run.app',modigieCredential.modigie__Private_Key__c);
      this.lstsObj = lstsObj;
      mapInputNumbers = (Map<String, Object>) JSON.deserializeUntyped(
        inputNumbers
      );
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Phone Insights');
      //    EmailServiceClass.sendEmail(JSON.serialize(errorMap));
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      throw new ListViewGetPhoneInsightsBatchClassException(
        'You are not an authorized user.'
      );
    } catch (Exception e) {
      throw new ListViewGetPhoneInsightsBatchClassException(e.getMessage());
    }
  }

  public List<SObject> start(Database.BatchableContext bc) {
    return lstsObj;
  }
  public void execute(Database.BatchableContext bc, List<SObject> scope) {
    try {
      List<User> userobj = new List<User>();

      List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();

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

      //List<modigie__Modigie__c> lstModigie = [SELECT id,modigie__Parent_Id__c,modigie__Contact__c,modigie__Lead__c,modigie__Mobile_2__c,modigie__Mobile_3__c FROM modigie__Modigie__c WHERE modigie__Lead__c IN :setOfKeysIds OR modigie__Contact__c IN :setOfKeysIds];
      List<modigie__Modigie__c> lstModigie = [
        SELECT
          Id,
          modigie__User_PhoneInsights__c,
          modigie__Verified_Phone_Get_Phone_Insights__c,
          modigie__Contact__c,
          modigie__Lead__c,
          modigie__Validation_Key__c,
          modigie__Parent_Id__c,
          modigie__Get_Phone_Intelligence_Job_Id__c,
          modigie__Get_Phone_Intelligence_Job_Status__c,
          modigie__Phone_Intelligence_Status__c,
          modigie__Mobile_2__c,
          modigie__Mobile_3__c,
          modigie__Get_Phone_Intelligence_Job_Id_Phone__c,
          modigie__Get_Phone_Intelligence_Job_Id_Val_Number__c,
          modigie__Get_Phone_Intelligence_Job_Id_Alternate1__c,
          modigie__Get_Phone_Intelligence_Job_Id_Alternate2__c,
          modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c,
          modigie__Get_Phone_Intelligence_Job_Status_Phone__c,
          modigie__Get_Phone_Intelligence_Job_Status_ValNum__c,
          modigie__Get_Phone_Intelligence_Job_Status_Alt1__c,
          modigie__Get_Phone_Intelligence_Job_Status_Alt2__c,
          modigie__Get_Phone_Intelligence_Job_Status_OPhone__c,
          modigie__Phone_Intelligence_Status_Phone__c,
          modigie__Phone_Intelligence_Status_Modigie_Number__c,
          modigie__Phone_Intelligence_Status_Alt_Number1__c,
          modigie__Phone_Intelligence_Status_Alt_Number2__c,
          modigie__Phone_Intelligence_Status_Other_Phone__c,
          modigie__Verified_Phone_Get_Phone_Insights_Phone__c,
          modigie__Verified_Phone_Get_Phone_Insights_ValNum__c,
          modigie__Verified_Phone_Get_Phone_Insights_Alt1__c,
          modigie__Verified_Phone_Get_Phone_Insights_Alt2__c,
          modigie__Verified_Phone_Get_Phone_Insights_OPhone__c,
          modigie__Validation_Date_Mobile__c,
          modigie__Validation_Date_Phone__c,
          modigie__Validation_Date_Other_Phone__c,
          modigie__Validation_Date_Modigie_Val_Phone_Number__c,
          modigie__Validation_Date_Alternate_Number1__c,
          modigie__Validation_Date_Alternate_Number2__c,
          modigie__Best_Time_to_Call_Phone_Other_Phone__c,
          modigie__Best_Time_to_Call_Alternate_Number2__c,
          modigie__Best_Time_to_Call_Alternate_Number1__c,
          modigie__Best_Time_to_Call_Validated_Number__c,
          modigie__Best_Time_to_Call_Phone__c,
          modigie__Phone_Type_Other_Phone__c,
          modigie__Phone_Type_Alternate_Number2__c,
          modigie__Phone_Type_Alternate_Number1__c,
          modigie__Phone_Type_Modigie_Validated_Number__c,
          modigie__Phone_Type_Phone__c,
          modigie__Line_Activity_Other_Phone__c,
          modigie__Line_Activity_Alternate2__c,
          modigie__Line_Activity_Alternate1__c,
          modigie__Line_Activity_Modigie_Validated_Number__c,
          modigie__Line_Activity_Phone__c,
          modigie__Day_of_Week_Detail_Other_Phone__c,
          modigie__Day_of_Week_Detail_Alternate_Number2__c,
          modigie__Day_of_Week_Detail_Alternate_Number1__c,
          modigie__Day_of_Week_Detail_Modigie_Val_Number__c,
          modigie__Day_of_Week_Detail_Phone__c,
          modigie__Accuracy_Match_Other_Phone__c,
          modigie__Accuracy_Match_Alternate_Number2__c,
          modigie__Accuracy_Match_Alternate_Number1__c,
          modigie__Accuracy_Match_Modigie_Validated_Number__c,
          modigie__Accuracy_Match_Phone__c,
          modigie__Best_Time_to_Call__c,
          modigie__Day_of_Week_Detail__c,
          modigie__Phone_Type__c,
          modigie__Line_Activity__c,
          modigie__Phone_Name_Match__c
        FROM modigie__Modigie__c
        WHERE
          modigie__Lead__c IN :setOfKeysIds
          OR modigie__Contact__c IN :setOfKeysIds
        WITH SECURITY_ENFORCED
      ];

      Map<String, modigie__Modigie__c> mapModigie = new Map<String, modigie__Modigie__c>();

      for (modigie__Modigie__c modigie : lstModigie) {
        if (modigie.modigie__Contact__c != null) {
          mapModigie.put(modigie.modigie__Contact__c, modigie);
        } else if (modigie.modigie__Lead__c != null) {
          mapModigie.put(modigie.modigie__Lead__c, modigie);
        }
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
      for (SObject sObj : scope) {
        String sobjectType = sObj.getSObjectType().getDescribe().getName();
        //leadMap.put(leadrec.id, leadrec);
        String finalInputNumbers = '';
        String numberTypeSended = '';

        modigie__Modigie__c modigieRecToUpsert = mapModigie.get(
          (String) sObj.get('Id')
        );

        if (modigieRecToUpsert == null) {
          modigieRecToUpsert = new modigie__Modigie__c();
          modigieRecToUpsert.modigie__Parent_Id__c = (String) sObj.get('Id');
        }

        if (sobjectType?.equalsIgnoreCase('Contact') == true) {
          finalInputNumbers = mapInputNumbers.get('selectedFieldsContact')
            .toString();
          modigieRecToUpsert.modigie__Contact__c = (String) sObj.get('Id');
        } else if (sobjectType?.equalsIgnoreCase('Lead') == true) {
          finalInputNumbers = mapInputNumbers.get('selectedFieldsLead')
            .toString();
          modigieRecToUpsert.modigie__Lead__c = (String) sObj.get('Id');
        }

        Map<String, Object> sinCon = new Map<String, Object>();
        Boolean haveAtleastOnePhone = false;
        if (sObj.get('FirstName') != null) {
          sinCon.put('firstName', sObj.get('FirstName'));
        }

        if (sObj.get('LastName') != null) {
          sinCon.put('lastName', sObj.get('LastName'));
        }

        if (sobjectType?.equalsIgnoreCase('Contact') == true) {
          if (sObj.get('AccountId') != null) {
            Contact con = conMap.get((Id) sObj.get('Id'));
            //String accId = sObj.get('AccountId').toString();
            //List<Account> acc = [SELECT Name FROM Account WHERE Id = :accId WITH SECURITY_ENFORCED LIMIT 1];
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

        List<String> lstMobileNumber = new List<String>();

        if (finalInputNumbers.containsIgnoreCase('Mobile,')) {
          if (sObj.get('MobilePhone') != null) {
            String mobileNumber = (String) sObj.get('MobilePhone');

            if (!mobileNumber.startsWith('+')) {
              if (mobileNumber.startsWith('1')) {
                mobileNumber = '+' + mobileNumber;
              } else {
                mobileNumber = '+1' + mobileNumber;
              }
            }

            modigieRecToUpsert.modigie__Verified_Phone_Get_Phone_Insights__c = mobileNumber;
            modigieRecToUpsert.modigie__Formatted_Mobile_Number__c = FormatPhone(
              (String) sObj.get('MobilePhone')
            );
            modigieRecToUpsert.modigie__Phone_Intelligence_Status__c = 'Batch Process';
            haveAtleastOnePhone = true;
            lstMobileNumber.add(mobileNumber);
            numberTypeSended += 'Mobile,';

            //sinCon.put('mobilePhone',lstSobj[0].get('MobilePhone'));
          }
        }

        if (finalInputNumbers.containsIgnoreCase('Phone,')) {
          if (sObj.get('Phone') != null) {
            String mobileNumber = (String) sObj.get('Phone');

            if (!mobileNumber.startsWith('+')) {
              if (mobileNumber.startsWith('1')) {
                mobileNumber = '+' + mobileNumber;
              } else {
                mobileNumber = '+1' + mobileNumber;
              }
            }

            modigieRecToUpsert.modigie__Verified_Phone_Get_Phone_Insights_Phone__c = mobileNumber;
            modigieRecToUpsert.modigie__Formatted_Phone_Number__c = FormatPhone(
              (String) sObj.get('Phone')
            );

            modigieRecToUpsert.modigie__Phone_Intelligence_Status_Phone__c = 'Batch Process';
            lstMobileNumber.add(mobileNumber);
            //sinCon.put('mobilePhone',lstSobj[0].get('MobilePhone'));
            haveAtleastOnePhone = true;
            numberTypeSended += 'Phone,';
          }
        }

        if (finalInputNumbers.containsIgnoreCase('Other,')) {
          if (sObj.get('OtherPhone') != null) {
            String mobileNumber = (String) sObj.get('OtherPhone');

            if (!mobileNumber.startsWith('+')) {
              if (mobileNumber.startsWith('1')) {
                mobileNumber = '+' + mobileNumber;
              } else {
                mobileNumber = '+1' + mobileNumber;
              }
            }

            modigieRecToUpsert.modigie__Verified_Phone_Get_Phone_Insights_OPhone__c = mobileNumber;

            modigieRecToUpsert.modigie__Formatted_Other_Phone_Number__c = FormatPhone(
              (String) sObj.get('OtherPhone')
            );

            modigieRecToUpsert.modigie__Phone_Intelligence_Status_Other_Phone__c = 'Batch Process';

            lstMobileNumber.add(mobileNumber);
            //sinCon.put('mobilePhone',lstSobj[0].get('MobilePhone'));
            haveAtleastOnePhone = true;
            numberTypeSended += 'Other,';
          }
        }

        /*if(finalInputNumbers.containsIgnoreCase('Modigie_Verified_Number,')){
                        if(sObj.get('modigie__Modigie_Verified_Number__c') != null){
                   
                            String mobileNumber = (String)sObj.get('modigie__Modigie_Verified_Number__c');
            
                            if(!mobileNumber.startsWith('+')){
                                if(mobileNumber.startsWith('1'))
                                {
                                    mobileNumber = '+' + mobileNumber;
                                }
                                else{
                                    mobileNumber = '+1' + mobileNumber;
                                }
        
                            }
                           
                            modigieRecToUpsert.modigie__Verified_Phone_Get_Phone_Insights_ValNum__c = mobileNumber;

                            modigieRecToUpsert.modigie__Phone_Intelligence_Status_Modigie_Number__c = 'Batch Process';

                            lstMobileNumber.add(mobileNumber);
                            //sinCon.put('mobilePhone',lstSobj[0].get('MobilePhone')); 
                            haveAtleastOnePhone=true;
                            
                        }
                    }


                    if(finalInputNumbers.containsIgnoreCase('modigie__Verified_Alt1__c,')){
                        modigie__Modigie__c modigie = mapModigie.get((String)sObj.get('Id'));
                        if(modigie != null){
                            if(modigie.modigie__Mobile_2__c != null){
                                String mobileNumber = modigie.modigie__Mobile_2__c;
            
                                if(!mobileNumber.startsWith('+')){
                                    if(mobileNumber.startsWith('1'))
                                    {
                                        mobileNumber = '+' + mobileNumber;
                                    }
                                    else{
                                        mobileNumber = '+1' + mobileNumber;
                                    }
            
                                }
                            modigieRecToUpsert.modigie__Verified_Phone_Get_Phone_Insights_Alt1__c = mobileNumber;
                                
                                modigieRecToUpsert.modigie__Phone_Intelligence_Status_Alt_Number1__c = 'Batch Process';

                                lstMobileNumber.add(mobileNumber);    
                                haveAtleastOnePhone=true;
                                
                            }
                        }
                    }
                     
                    
                    if(finalInputNumbers.containsIgnoreCase('modigie__Verified_Alt2__c,')){ 
                        modigie__Modigie__c modigie = mapModigie.get((String)sObj.get('Id'));
                        if(modigie != null){
                            if(modigie.modigie__Mobile_3__c != null){
                                String mobileNumber = modigie.modigie__Mobile_3__c;
            
                                if(!mobileNumber.startsWith('+')){
                                    if(mobileNumber.startsWith('1'))
                                    {
                                        mobileNumber = '+' + mobileNumber;
                                    }
                                    else{
                                        mobileNumber = '+1' + mobileNumber;
                                    }
            
                                }
                            
                                modigieRecToUpsert.modigie__Verified_Phone_Get_Phone_Insights_Alt2__c = mobileNumber;
                                modigieRecToUpsert.modigie__Phone_Intelligence_Status_Alt_Number2__c = 'Batch Process';
                                lstMobileNumber.add(mobileNumber);    
                            haveAtleastOnePhone=true;
                                
                            }
                        }
                    }*/

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
            'value' => numberTypeSended
          }
        );
        sinCon.put('customParameters', lstMap);
        if (haveAtleastOnePhone) {
          lstCon.add(sinCon);
          if (modigieRecToUpsert.get('Id') == null) {
            lstModigie.add(modigieRecToUpsert);
          }
        }
      }

      outerMap.put('contacts', lstCon);

      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setMethod('POST');
      // request.setHeader('Content-Length', '4096');
      // request.setHeader('accept', 'application/json');
      request.setHeader('Content-Type', contentType);
      request.setHeader('Authorization', accessToken);
      request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);
      request.setEndpoint(
        endpoint
      ); //Production Environment Endpoints
      //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/phoneIntelJobs?key=' + modigieCredential.modigie__API_Key__c); //Staging Environment Endpoints

      request.setBody(JSON.serialize(outerMap));

      request.setTimeout(120000);
      HttpResponse response = http.send(request);

      if (response.getStatusCode() == 202) {
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
            'modigie__Phone_Name_Match__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Phone_Name_Match__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Phone_Name_Match__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Line_Activity__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Phone_Type__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Mobile__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Mobile__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Mobile__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Id__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Id__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Id__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Status__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Status__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Status__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Phone_Intelligence_Status__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Phone_Intelligence_Status__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Phone_Intelligence_Status__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Id_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Id_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Id_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Status_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Status_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Status_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Phone_Intelligence_Status_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Phone_Intelligence_Status_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Phone_Intelligence_Status_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Accuracy_Match_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Line_Activity_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Phone_Type_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Phone_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Phone_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Best_Time_to_Call_Phone_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Day_of_Week_Detail_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Validation_Date_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Modigie__c',
            'modigie__Phone_Intelligence_Status_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Modigie__c',
            'modigie__Phone_Intelligence_Status_Other_Phone__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Modigie__c',
            'modigie__Phone_Intelligence_Status_Other_Phone__c'
          )
        ) {
          for (modigie__Modigie__c modigie : lstModigie) {
            String statusGetModigie = responseMap.get('status').toString();
            statusGetModigie =
              statusGetModigie.substring(0, 1).toUpperCase() +
              statusGetModigie.substring(1, statusGetModigie.length());

            if (
              modigie.modigie__Phone_Intelligence_Status__c
                ?.equalsIgnoreCase('Batch Process') == true
            ) {
              modigie.modigie__Phone_Name_Match__c = '';
              modigie.modigie__Line_Activity__c = '';
              modigie.modigie__Phone_Type__c = '';
              modigie.modigie__Best_Time_to_Call__c = '';
              modigie.modigie__Day_of_Week_Detail__c = '';
              modigie.modigie__Validation_Date_Mobile__c = System.now();
              modigie.modigie__Get_Phone_Intelligence_Job_Id__c = jobid;
              modigie.modigie__Get_Phone_Intelligence_Job_Status__c = statusGetModigie;
              modigie.modigie__Phone_Intelligence_Status__c = 'In process';
            }

            if (
              modigie.modigie__Phone_Intelligence_Status_Phone__c
                ?.equalsIgnoreCase('Batch Process') == true
            ) {
              modigie.modigie__Accuracy_Match_Phone__c = '';
              modigie.modigie__Line_Activity_Phone__c = '';
              modigie.modigie__Phone_Type_Phone__c = '';
              modigie.modigie__Best_Time_to_Call_Phone__c = '';
              modigie.modigie__Day_of_Week_Detail_Phone__c = '';
              modigie.modigie__Validation_Date_Phone__c = System.now();
              modigie.modigie__Get_Phone_Intelligence_Job_Id_Phone__c = jobid;
              modigie.modigie__Get_Phone_Intelligence_Job_Status_Phone__c = statusGetModigie;
              modigie.modigie__Phone_Intelligence_Status_Phone__c = 'In process';
            }

            if (
              modigie.modigie__Phone_Intelligence_Status_Other_Phone__c
                ?.equalsIgnoreCase('Batch Process') == true
            ) {
              modigie.modigie__Line_Activity_Other_Phone__c = '';
              modigie.modigie__Accuracy_Match_Other_Phone__c = '';
              modigie.modigie__Phone_Type_Other_Phone__c = '';
              modigie.modigie__Best_Time_to_Call_Phone_Other_Phone__c = '';
              modigie.modigie__Day_of_Week_Detail_Other_Phone__c = '';
              modigie.modigie__Validation_Date_Other_Phone__c = System.now();
              modigie.modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c = jobid;
              modigie.modigie__Get_Phone_Intelligence_Job_Status_OPhone__c = statusGetModigie;
              modigie.modigie__Phone_Intelligence_Status_Other_Phone__c = 'In process';
            }

            /*if(modigie.modigie__Phone_Intelligence_Status_Modigie_Number__c == 'Batch Process'){
modigie.modigie__Line_Activity_Modigie_Validated_Number__c='';
modigie.modigie__Accuracy_Match_Modigie_Validated_Number__c='';
modigie.modigie__Phone_Type_Modigie_Validated_Number__c='';
modigie.modigie__Best_Time_to_Call_Validated_Number__c='';
modigie.modigie__Day_of_Week_Detail_Modigie_Val_Number__c='';
modigie.modigie__Validation_Date_Modigie_Val_Phone_Number__c = System.now();
modigie.modigie__Get_Phone_Intelligence_Job_Id_Val_Number__c	 = jobid;    
modigie.modigie__Get_Phone_Intelligence_Job_Status_ValNum__c = statusGetModigie;
modigie.modigie__Phone_Intelligence_Status_Modigie_Number__c = 'In process';

}

if(modigie.modigie__Phone_Intelligence_Status_Alt_Number1__c == 'Batch Process'){
modigie.modigie__Line_Activity_Alternate1__c='';
modigie.modigie__Accuracy_Match_Alternate_Number1__c='';
modigie.modigie__Best_Time_to_Call_Alternate_Number1__c='';
modigie.modigie__Day_of_Week_Detail_Alternate_Number1__c='';
modigie.modigie__Validation_Date_Alternate_Number1__c = System.now(); 
modigie.modigie__Phone_Type_Alternate_Number1__c='';
modigie.modigie__Get_Phone_Intelligence_Job_Id_Alternate1__c = jobid;    
modigie.modigie__Get_Phone_Intelligence_Job_Status_Alt1__c = statusGetModigie;
modigie.modigie__Phone_Intelligence_Status_Alt_Number1__c = 'In process';

}

if(modigie.modigie__Phone_Intelligence_Status_Alt_Number2__c == 'Batch Process'){
modigie.modigie__Accuracy_Match_Alternate_Number2__c='';
modigie.modigie__Line_Activity_Alternate2__c='';
modigie.modigie__Phone_Type_Alternate_Number2__c='';
modigie.modigie__Best_Time_to_Call_Alternate_Number2__c='';
modigie.modigie__Day_of_Week_Detail_Alternate_Number2__c='';
modigie.modigie__Validation_Date_Alternate_Number2__c = System.now();
modigie.modigie__Get_Phone_Intelligence_Job_Id_Alternate2__c	 = jobid;    
modigie.modigie__Get_Phone_Intelligence_Job_Status_Alt2__c = statusGetModigie;
modigie.modigie__Phone_Intelligence_Status_Alt_Number2__c = 'In process';

}*/

            //  modigie.modigie__Get_Phone_Insight_Campaign_User__c = UserInfo.getUserId();
            modigie.modigie__User_PhoneInsights__c = UserInfo.getUserId();

            //modigie.modigie__Campaign_Id_GetPhoneInsight__c = campaignId;
            modigie.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
          }
          if (
            FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
            FieldLevelSecurityCheck.canCreateObject('modigie__Modigie__c') &&
            FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie__c') &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Phone_Name_Match__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Phone_Name_Match__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Phone_Name_Match__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Line_Activity__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Line_Activity__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Line_Activity__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Phone_Type__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Phone_Type__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Phone_Type__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Best_Time_to_Call__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Best_Time_to_Call__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Best_Time_to_Call__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Day_of_Week_Detail__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Day_of_Week_Detail__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Day_of_Week_Detail__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Mobile__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Mobile__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Mobile__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Id__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Id__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Id__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Status__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Status__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Status__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Phone_Intelligence_Status__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Phone_Intelligence_Status__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Phone_Intelligence_Status__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Accuracy_Match_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Accuracy_Match_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Accuracy_Match_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Line_Activity_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Line_Activity_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Line_Activity_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Phone_Type_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Phone_Type_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Phone_Type_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Best_Time_to_Call_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Best_Time_to_Call_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Best_Time_to_Call_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Day_of_Week_Detail_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Day_of_Week_Detail_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Day_of_Week_Detail_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Id_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Id_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Id_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Status_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Status_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Status_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Phone_Intelligence_Status_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Phone_Intelligence_Status_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Phone_Intelligence_Status_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Accuracy_Match_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Accuracy_Match_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Accuracy_Match_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Line_Activity_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Line_Activity_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Line_Activity_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Phone_Type_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Phone_Type_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Phone_Type_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Best_Time_to_Call_Phone_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Best_Time_to_Call_Phone_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Best_Time_to_Call_Phone_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Day_of_Week_Detail_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Day_of_Week_Detail_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Day_of_Week_Detail_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Validation_Date_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Get_Phone_Intelligence_Job_Status_OPhone__c'
            ) &&
            FieldLevelSecurityCheck.canReadField(
              'modigie__Modigie__c',
              'modigie__Phone_Intelligence_Status_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canCreateField(
              'modigie__Modigie__c',
              'modigie__Phone_Intelligence_Status_Other_Phone__c'
            ) &&
            FieldLevelSecurityCheck.canUpdateField(
              'modigie__Modigie__c',
              'modigie__Phone_Intelligence_Status_Other_Phone__c'
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
          )
            upsert lstModigie;

          List<modigie__Process_Builder_Switch__c> lstPbs = [
            SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c
            FROM modigie__Process_Builder_Switch__c
            WITH SECURITY_ENFORCED
            LIMIT 1
          ];
          if (lstPbs.isEmpty()) {
            throw new ListViewGetPhoneInsightsBatchClassException(
              'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
            );
          } else if (
            lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null
          ) {
            throw new ListViewGetPhoneInsightsBatchClassException(
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
              //check here
            }
          }
        }
      } else {
        if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
          EmailServiceClass.sendResponseError('ListViewGetPhoneInsightsBatchClass', response.getStatusCode(), response.getBody());
        }
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
          modigieErrorLog.modigie__Modigie_Service__c = 'Get Phone Insights';

          modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';

          emailMessages.add((String) responseMap.get('message'));

          lstErrorLog.add(modigieErrorLog);
        }
      }
    } catch (Exception e) {
      throw new ListViewGetPhoneInsightsBatchClassException(e.getMessage());
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
  private static String FormatPhone(String Phone) {
    String nondigits = '[^0-9]';
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

  private class ListViewGetPhoneInsightsBatchClassException extends Exception {
  }
}