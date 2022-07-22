/************************************************************************
 *  @authors Pragati Goyal
 *  @date    6 Feb 2020
 *  @name    GetModigieCampaignButton
 *  @description This class is used by "GetModigieCampaignButtonComponent" to make callout when user press Get Modigie Button.
 ***********************************************************************/
public with sharing class GetModigieCampaignButton {
  /************************************************************************
   *  @authors Pragati Goyal
   *  @date    6 Feb 2020
   *  @name   CampaignCallout
   *  @description This method fetch Campaign members and credit limit from Modigie Credit to display counts of Leads & Contacts.
   *  @Parameters Campaign Id
   *  @return Returns remaining Credit Limit & count of Campaign members.
   ***********************************************************************/

  @AuraEnabled
  public static String CampaignCallout(Id recid) {
    Map<String, Integer> camMem = new Map<String, Integer>();
    try {
      Map<String, String> securityForReadMap = new Map<String, String>();
      securityForReadMap.put('CampaignId', 'CampaignMember');
      securityForReadMap.put('ContactId', 'CampaignMember');
      securityForReadMap.put('LeadId', 'CampaignMember');
      securityForReadMap.put('modigie__Contact__c', 'modigie__Modigie__c');
      securityForReadMap.put('modigie__Lead__c', 'modigie__Modigie__c');
      securityForReadMap.put('modigie__Status__c', 'modigie__Modigie__c');
      securityForReadMap.put('FirstName', 'Contact');
      securityForReadMap.put('Email', 'Contact');
      securityForReadMap.put('FirstName', 'Lead');
      securityForReadMap.put('Company', 'Lead');
      securityForReadMap.put('Email', 'Lead');
      securityForReadMap.put('Name', 'Account');

      Boolean checkForRead = FieldLevelSecurityCheck.checkSecurityForRead(
        securityForReadMap
      );

      if (!checkForRead) {
        throw new GetModigieCampaignButtonException(
          'User does not have the required object read permissions.'
        );
      }
      List<modigie__Modigie_Service_Account__mdt> lstCredentials = ModigieApiUtils.getServiceAccountDetails();
      // List<modigie__Modigie_Credentials__c> lstCredentials = [
      //   SELECT id
      //   FROM modigie__Modigie_Credentials__c
      //   WITH SECURITY_ENFORCED
      //   LIMIT 1
      // ];
      if (lstCredentials.size() > 0) {
        Integer recordsToProcess;
        Integer validatedRecords;
        Integer recordsRunning;
        Integer newRecordsToProcess;
        Integer invalidatedRecords;
        Integer notFulfill;
        Integer userFilled;
        Integer totalRecordsWithRequiredFiels;

        List<CampaignMember> totalMembersList = new List<CampaignMember>();
        List<CampaignMember> contactList = new List<CampaignMember>();
        List<CampaignMember> leadList = new List<CampaignMember>();

        totalMembersList = [
          SELECT ContactId, LeadId
          FROM CampaignMember
          WHERE CampaignId = :recid AND (ContactId != NULL OR LeadId != NULL)
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        validatedRecords = [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recid
            AND ContactId != NULL
            AND ContactId IN (
              SELECT modigie__Contact__c
              FROM modigie__Modigie__c
              WHERE modigie__Status__c = 'Validated'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        invalidatedRecords = [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recId
            AND ContactId != NULL
            AND ContactId IN (
              SELECT modigie__Contact__c
              FROM modigie__Modigie__c
              WHERE modigie__Status__c = 'Not Available'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        recordsRunning = [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recId
            AND ContactId != NULL
            AND ContactId IN (
              SELECT modigie__Contact__c
              FROM modigie__Modigie__c
              WHERE modigie__Status__c = 'In process'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        // String dynamicQuery = 'SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE FirstName = null OR Account.Name = null OR Email = null) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c = 'In process' OR modigie__Status__c = 'Validated' OR modigie__Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000'

        // 'SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE FirstName = null OR Account.Name = null OR (Email = null AND modigie__LinkedIn_Url__c = null AND Test_LinkedIn_Field__c)) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c = \'In process\' OR modigie__Status__c = \'Validated\' OR modigie__Status__c = \'Not Available\') WITH SECURITY_ENFORCED LIMIT 50000'

        String query = 'SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE FirstName = null OR Account.Name = null OR (Email = null AND (modigie__LinkedIn_Url__c = null OR modigie__LinkedIn_Url__c LIKE \'%/sales/\' )';
        query += ' AND (modigie__Test_Alt_LinkedIn_Url_FIeld__c = null OR modigie__Test_Alt_LinkedIn_Url_FIeld__c LIKE \'/sales/\')';
        query += ')) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c = \'In process\' OR modigie__Status__c = \'Validated\' OR modigie__Status__c = \'Not Available\') WITH SECURITY_ENFORCED LIMIT 50000';

        notFulfill = [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recId
            AND ContactId != NULL
            AND ContactId IN (
              SELECT Id
              FROM Contact
              WHERE
                FirstName = NULL
                OR Account.Name = NULL
                OR (Email = NULL
                AND modigie__linkedin_url__c = NULL)
            )
            AND ContactId NOT IN (
              SELECT modigie__Contact__c
              FROM modigie__Modigie__c
              WHERE
                modigie__Status__c = 'In process'
                OR modigie__Status__c = 'Validated'
                OR modigie__Status__c = 'Not Available'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        recordsToProcess = [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recId
            AND ContactId != NULL
            AND ContactId IN (
              SELECT Id
              FROM Contact
              WHERE
                FirstName != NULL
                AND Account.Name != NULL
                AND (Email != NULL
                OR modigie__linkedin_url__c != NULL)
            )
            AND ContactId NOT IN (
              SELECT modigie__Contact__c
              FROM modigie__Modigie__c
              WHERE modigie__Status__c = 'In process'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        newRecordsToProcess = [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recId
            AND ContactId != NULL
            AND ContactId IN (
              SELECT Id
              FROM Contact
              WHERE
                FirstName != NULL
                AND Account.Name != NULL
                AND (Email != NULL
                OR modigie__linkedin_url__c != NULL)
            )
            AND ContactId NOT IN (
              SELECT modigie__Contact__c
              FROM modigie__Modigie__c
              WHERE
                modigie__Status__c = 'In process'
                OR modigie__Status__c = 'Validated'
                OR modigie__Status__c = 'Not Available'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        validatedRecords += [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recid
            AND LeadId != NULL
            AND LeadId IN (
              SELECT modigie__Lead__c
              FROM modigie__Modigie__c
              WHERE modigie__Status__c = 'Validated'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        invalidatedRecords += [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recId
            AND LeadId != NULL
            AND LeadId IN (
              SELECT modigie__Lead__c
              FROM modigie__Modigie__c
              WHERE modigie__Status__c = 'Not Available'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        recordsRunning += [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recId
            AND LeadId != NULL
            AND LeadId IN (
              SELECT modigie__Lead__c
              FROM modigie__Modigie__c
              WHERE modigie__Status__c = 'In process'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        notFulfill += [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recId
            AND LeadId != NULL
            AND LeadId IN (
              SELECT Id
              FROM Lead
              WHERE
                FirstName = NULL
                OR Company = NULL
                OR (Email = NULL
                AND modigie__linkedin_url__c = NULL)
            )
            AND LeadId NOT IN (
              SELECT modigie__Lead__c
              FROM modigie__Modigie__c
              WHERE
                modigie__Status__c = 'In process'
                OR modigie__Status__c = 'Validated'
                OR modigie__Status__c = 'Not Available'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        recordsToProcess += [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recId
            AND LeadId != NULL
            AND LeadId IN (
              SELECT Id
              FROM Lead
              WHERE
                FirstName != NULL
                AND Company != NULL
                AND (Email != NULL
                OR modigie__linkedin_url__c != NULL)
            )
            AND LeadId NOT IN (
              SELECT modigie__Lead__c
              FROM modigie__Modigie__c
              WHERE modigie__Status__c = 'In process'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        newRecordsToProcess += [
          SELECT COUNT()
          FROM CampaignMember
          WHERE
            CampaignId = :recId
            AND LeadId != NULL
            AND LeadId IN (
              SELECT Id
              FROM Lead
              WHERE
                FirstName != NULL
                AND Company != NULL
                AND (Email != NULL
                OR modigie__linkedin_url__c != NULL)
            )
            AND LeadId NOT IN (
              SELECT modigie__Lead__c
              FROM modigie__Modigie__c
              WHERE
                modigie__Status__c = 'In process'
                OR modigie__Status__c = 'Validated'
                OR modigie__Status__c = 'Not Available'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        //totalRecordsWithRequiredFiels = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE  FirstName != null AND Account.Name != null AND Email != null) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c = 'In process') WITH SECURITY_ENFORCED LIMIT 50000];

        // totalRecordsWithRequiredFiels += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE FirstName != null AND Company != null AND Email != null) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Status__c = 'In process') WITH SECURITY_ENFORCED LIMIT 50000];

        if (recordsToProcess > 0) {
          camMem.put('TokenExist', 1);
        } else {
          camMem.put('TokenExist', -3);
        }
        camMem.put('totalSize', totalMembersList.size());
        camMem.put('alreadyValidated', validatedRecords);
        camMem.put('recordsRunning', recordsRunning);
        camMem.put('recordsToProcess', recordsToProcess);
        camMem.put('invalidatedRecords', invalidatedRecords);
        camMem.put('newRecordsToProcess', newRecordsToProcess);
        camMem.put('notFulfill', notFulfill);

        return JSON.serialize(camMem);
      } else {
        camMem.put('TokenExist', 0);
        throw new GetModigieCampaignButtonException(
          'You are not an authorized user.'
        );
      }
    } catch (LimitException e) {
      throw new GetModigieCampaignButtonException(
        'You cannot process more than 50,000 records.'
      );
    } catch (System.QueryException e) {
      throw new GetModigieCampaignButtonException(
        'You do not have permission to query lead, contact or modigie fields.'
      );
    } catch (Exception e) {
      throw new GetModigieCampaignButtonException(e.getMessage());
    }
  }

  /************************************************************************
   *  @authors Tarun Gyanchandani
   *  @date
   *  @name   campaignCalloutForNewMembers
   *  @description Method to Syncronization of new Campaign records.
   *  @Parameters Campaign Id
   ***********************************************************************/
  @AuraEnabled
  public static List<Id> campaignCalloutForNewMembers(Id recid) {
    try {
      Map<String, String> securityMap = new Map<String, String>();
      Map<String, String> securityForRead = new Map<String, String>();
      List<CampaignMember> contactList = new List<CampaignMember>();
      List<CampaignMember> leadList = new List<CampaignMember>();

      securityForRead.put('CampaignId', 'CampaignMember');
      securityForRead.put('ContactId', 'CampaignMember');
      securityForRead.put('LeadId', 'CampaignMember');

      securityForRead.put('AccountId', 'Contact');
      securityForRead.put('FirstName', 'Contact');
      securityForRead.put('LastName', 'Contact');
      securityForRead.put('Email', 'Contact');
      securityForRead.put('MobilePhone', 'Contact');
      securityForRead.put('modigie__linkedin_url__c', 'Contact');
      securityForRead.put('modigie__Modigie_Verified_Number__c', 'Contact');
      securityForRead.put('Name', 'Account');
      securityForRead.put('FirstName', 'Lead');
      securityForRead.put('LastName', 'Lead');
      securityForRead.put('Email', 'Lead');
      securityForRead.put('Company', 'Lead');
      securityForRead.put('MobilePhone', 'Lead');
      securityForRead.put('modigie__Modigie_Verified_Number__c', 'Lead');
      securityForRead.put('modigie__linkedin_url__c', 'Lead');
      securityForRead.put('modigie__Contact__c', 'modigie__Modigie__c');
      securityForRead.put('modigie__Lead__c', 'modigie__Modigie__c');
      securityForRead.put('modigie__Status__c', 'modigie__Modigie__c');

      Boolean checkForRead = FieldLevelSecurityCheck.checkSecurityForRead(
        securityForRead
      );
      Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);

      contactList = [
        SELECT ContactId
        FROM CampaignMember
        WHERE
          CampaignId = :recid
          AND ContactId != NULL
          AND ContactId IN (
            SELECT Id
            FROM Contact
            WHERE
              FirstName != NULL
              AND Account.Name != NULL
              AND (Email != NULL
              OR modigie__linkedin_url__c != NULL)
          )
          AND ContactId NOT IN (
            SELECT modigie__Contact__c
            FROM modigie__Modigie__c
            WHERE
              modigie__Status__c = 'In process'
              OR modigie__Status__c = 'Validated'
              OR modigie__Status__c = 'Not Available'
          )
        WITH SECURITY_ENFORCED
        LIMIT 50000
      ];

      leadList = [
        SELECT LeadId
        FROM CampaignMember
        WHERE
          CampaignId = :recid
          AND LeadId != NULL
          AND LeadId IN (
            SELECT Id
            FROM Lead
            WHERE
              FirstName != NULL
              AND Company != NULL
              AND (Email != NULL
              OR modigie__linkedin_url__c != NULL)
          )
          AND LeadId NOT IN (
            SELECT modigie__Lead__c
            FROM modigie__Modigie__c
            WHERE
              modigie__Status__c = 'In process'
              OR modigie__Status__c = 'Validated'
              OR modigie__Status__c = 'Not Available'
          )
        WITH SECURITY_ENFORCED
        LIMIT 50000
      ];

      Set<Id> setOfContactIds = new Set<Id>();

      for (CampaignMember cm : contactList) {
        setOfContactIds.add(cm.ContactId);
      }

      Set<ID> setOfLeadIds = new Set<ID>();

      for (CampaignMember cm : leadList) {
        setOfLeadIds.add(cm.LeadId);
      }

      List<Contact> conLst = [
        SELECT
          Id,
          Account.Name,
          Email,
          Account.BillingStreet,
          Account.BillingPostalCode,
          Account.BillingCity,
          Account.BillingState,
          Account.BillingCountry,
          modigie__linkedin_url__c,
          FirstName,
          LastName,
          modigie__Company_URL__c,
          MobilePhone,
          modigie__Modigie_Verified_Number__c,
          (SELECT id FROM modigie__Modigie__r)
        FROM Contact
        WHERE Id IN :setOfContactIds
        WITH SECURITY_ENFORCED
        LIMIT 50000
      ];
      List<Lead> ldLst = [
        SELECT
          Id,
          FirstName,
          LastName,
          Email,
          Company,
          modigie__Company_URL__c,
          modigie__linkedin_url__c,
          MobilePhone,
          modigie__Modigie_Verified_Number__c,
          (SELECT id FROM modigie__Modigie__r)
        FROM Lead
        WHERE Id IN :setOfLeadIds
        WITH SECURITY_ENFORCED
        LIMIT 50000
      ];

      List<Id> lstBatchJobsIds = new List<Id>();

      String userId = UserInfo.getUserId();

      List<modigie__Process_Builder_Switch__c> lstPbs = [
        SELECT
          Id,
          modigie__Limit_User_for_Modigie_Ad_hoc__c,
          modigie__Is_Active_Contact_Alt_LinkedIn_Url__c,
          modigie__Is_Active_Lead_Alt_LinkedIn_Url__c,
          modigie__Lead_Alt_LinkedIn_Url_Field_Name__c,
          modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
        FROM modigie__Process_Builder_Switch__c
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];
      if (lstPbs.isEmpty()) {
        throw new GetModigieCampaignButtonException(
          'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
        );
      } else if (lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null) {
        throw new GetModigieCampaignButtonException(
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

        Integer dailyCallout = 0;

        if (modigieUsage.size() > 0) {
          dailyCallout = (Integer) modigieUsage[0]
            .modigie__Number_of_modigie_callouts_in_a_day__c;
        }

        Map<Id, Integer> userToLimitsMap = LimitsMapClass.getProfileUserLimitsData();

        if (userToLimitsMap.containsKey(userId)) {
          if (
            userToLimitsMap.get(userId) <
            (dailyCallout +
            conLst.size() +
            ldLst.size())
          ) {
            throw new GetModigieCampaignButtonException(
              'You do not have enough daily limit to call modigie services.'
            );
          }
        } else {
          //throw new GetModigieCampaignButtonException('You are not assigned limits for modigie services, please contact your system administrator.');
        }
      }
      List<modigie__Modigie_Service_Account__mdt> modigieCredential = ModigieApiUtils.getServiceAccountDetails();
      List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Mobile Phone Job Read' LIMIT 1];
      String targetAudience, endpoint, contentType;
      if(!calloutInfo.isEmpty()){
        endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
        targetAudience = calloutInfo[0].modigie__targetAud__c;
        contentType = calloutInfo[0].modigie__Content_Type__c;
      }

      if (!modigieCredential.isEmpty()) {
        //String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',modigieCredential[0].modigie__Private_Key__c);
        String accessToken =
          'Bearer ' +
          jwtapex.get_access_token(
            modigieCredential[0].modigie__Email__c,
            targetAudience,
            modigieCredential[0].modigie__Private_Key__c
          );
        Integer b_size = 100;
        try{
            b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
            if(b_size > 100 || b_size < 1){
              b_size = 100;
            }
        }catch(Exception e){}
        if (!conLst.isEmpty()) {
          if (
            lstPbs[0].modigie__Is_Active_Contact_Alt_LinkedIn_Url__c &&
            lstPbs[0].modigie__Contact_Alt_LinkedIn_Url_Field_Name__c != null
          ) {
            ContactBatchForModigieLinkedInMapping batchable = new ContactBatchForModigieLinkedInMapping(
              conLst,
              recid,
              accessToken,
              lstPbs[0].modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
            );
            Database.executeBatch(batchable);
          } else {
            ContactBatchForGetModigieButton b1 = new ContactBatchForGetModigieButton(
              conLst,
              recid,
              accessToken
            );
            Id jobId = Database.executeBatch(b1, b_size);
            lstBatchJobsIds.add(jobId);
          }
        }

        if (!ldLst.isEmpty()) {
          if (
            lstPbs[0].modigie__Is_Active_Lead_Alt_LinkedIn_Url__c &&
            lstPbs[0].modigie__Lead_Alt_LinkedIn_Url_Field_Name__c != null
          ) {
            LeadBatchForModigieLinkedInMapping batchable = new LeadBatchForModigieLinkedInMapping(
              ldLst,
              recid,
              accessToken,
              lstPbs[0].modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
            );
            Database.executeBatch(batchable);
          } else {
            LeadBatchForGetModigieButton b2 = new LeadBatchForGetModigieButton(
              ldLst,
              recid,
              accessToken
            );
            Id jobId = Database.executeBatch(b2, b_size);
            lstBatchJobsIds.add(jobId);
          }
        }
      } else {
        throw new GetModigieCampaignButtonException(
          'You are not an authorized user.'
        );
      }

      return lstBatchJobsIds;
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get Modigie');
      errorMap.put('SObjectId', recid);
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put(
        'DisplayMessage',
        'You do not have permission to query lead, contact or modigie fields.'
      );
      throw new GetModigieCampaignButtonException(JSON.serialize(errorMap));
    } catch (Exception e) {
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put('DisplayMessage', e.getMessage());
      throw new GetModigieCampaignButtonException(JSON.serialize(errorMap));
    }
  }

  @AuraEnabled
  public static List<Id> campaignCalloutForAllMembers(Id recid) {
    try {
      Map<String, String> securityMap = new Map<String, String>();
      Map<String, String> securityCamapaignMemberMap = new Map<String, String>();
      List<CampaignMember> contactList = new List<CampaignMember>();
      List<CampaignMember> leadList = new List<CampaignMember>();

      securityCamapaignMemberMap.put('CampaignId', 'CampaignMember');
      securityCamapaignMemberMap.put('ContactId', 'CampaignMember');
      securityCamapaignMemberMap.put('LeadId', 'CampaignMember');

      securityMap.put('AccountId', 'Contact');
      securityMap.put('FirstName', 'Contact');
      securityMap.put('LastName', 'Contact');
      securityMap.put('Email', 'Contact');
      securityMap.put('MobilePhone', 'Contact');
      securityMap.put('modigie__linkedin_url__c', 'Contact');
      securityMap.put('modigie__Modigie_Verified_Number__c', 'Contact');
      securityMap.put('Name', 'Account');
      securityMap.put('FirstName', 'Lead');
      securityMap.put('LastName', 'Lead');
      securityMap.put('Email', 'Lead');
      securityMap.put('Company', 'Lead');
      securityMap.put('MobilePhone', 'Lead');
      securityMap.put('modigie__Modigie_Verified_Number__c', 'Lead');
      securityMap.put('modigie__linkedin_url__c', 'Lead');
      securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
      securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
      securityMap.put('modigie__Status__c', 'modigie__Modigie__c');

      Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
      Boolean checkMember = FieldLevelSecurityCheck.checkSecurityForRead(
        securityCamapaignMemberMap
      );

      if (check && checkMember) {
        contactList = [
          SELECT ContactId
          FROM CampaignMember
          WHERE
            CampaignId = :recid
            AND ContactId != NULL
            AND ContactId IN (
              SELECT Id
              FROM Contact
              WHERE
                FirstName != NULL
                AND Account.Name != NULL
                AND (Email != NULL
                OR modigie__linkedin_url__c != NULL)
            )
            AND ContactId NOT IN (
              SELECT modigie__Contact__c
              FROM modigie__Modigie__c
              WHERE modigie__Status__c = 'In process'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        leadList = [
          SELECT LeadId
          FROM CampaignMember
          WHERE
            CampaignId = :recid
            AND LeadId != NULL
            AND LeadId IN (
              SELECT Id
              FROM Lead
              WHERE
                FirstName != NULL
                AND Company != NULL
                AND (Email != NULL
                OR modigie__linkedin_url__c != NULL)
            )
            AND LeadId NOT IN (
              SELECT modigie__Lead__c
              FROM modigie__Modigie__c
              WHERE modigie__Status__c = 'In process'
            )
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        Set<Id> setOfContactIds = new Set<Id>();

        for (CampaignMember cm : contactList) {
          setOfContactIds.add(cm.ContactId);
        }

        Set<ID> setOfLeadIds = new Set<ID>();

        for (CampaignMember cm : leadList) {
          setOfLeadIds.add(cm.LeadId);
        }

        List<Contact> conLst = [
          SELECT
            Id,
            Account.Name,
            Email,
            Account.BillingStreet,
            Account.BillingPostalCode,
            Account.BillingCity,
            Account.BillingState,
            Account.BillingCountry,
            modigie__linkedin_url__c,
            FirstName,
            LastName,
            modigie__Company_URL__c,
            MobilePhone,
            modigie__Modigie_Verified_Number__c,
            (SELECT id FROM modigie__Modigie__r)
          FROM Contact
          WHERE Id IN :setOfContactIds
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];
        List<Lead> ldLst = [
          SELECT
            Id,
            FirstName,
            LastName,
            Email,
            Company,
            modigie__Company_URL__c,
            modigie__linkedin_url__c,
            MobilePhone,
            modigie__Modigie_Verified_Number__c,
            (SELECT id FROM modigie__Modigie__r)
          FROM Lead
          WHERE Id IN :setOfLeadIds
          WITH SECURITY_ENFORCED
          LIMIT 50000
        ];

        List<Id> lstBatchJobsIds = new List<Id>();
        List<modigie__Modigie_Service_Account__mdt> modigieCredential = ModigieApiUtils.getServiceAccountDetails();
        // List<modigie__Modigie_Credentials__c> modigieCredential = [
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

        String userId = UserInfo.getUserId();

        List<modigie__Process_Builder_Switch__c> lstPbs = [
          SELECT
            Id,
            modigie__Limit_User_for_Modigie_Ad_hoc__c,
            modigie__Is_Active_Contact_Alt_LinkedIn_Url__c,
            modigie__Is_Active_Lead_Alt_LinkedIn_Url__c,
            modigie__Lead_Alt_LinkedIn_Url_Field_Name__c,
            modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
          FROM modigie__Process_Builder_Switch__c
          WITH SECURITY_ENFORCED
          LIMIT 1
        ];
        if (lstPbs.isEmpty()) {
          throw new GetModigieCampaignButtonException(
            'No settings found ! Please ask Modigie Admin to configure the user limits settings.'
          );
        } else if (
          lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null
        ) {
          throw new GetModigieCampaignButtonException(
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

          Integer dailyCallout = 0;

          if (modigieUsage.size() > 0) {
            dailyCallout = (Integer) modigieUsage[0]
              .modigie__Number_of_modigie_callouts_in_a_day__c;
          }

          Map<Id, Integer> userToLimitsMap = LimitsMapClass.getProfileUserLimitsData();

          if (userToLimitsMap.containsKey(userId)) {
            if (
              userToLimitsMap.get(userId) <
              (dailyCallout +
              conLst.size() +
              ldLst.size())
            ) {
              throw new GetModigieCampaignButtonException(
                'You do not have enough daily limit to call modigie services.'
              );
            }
          } else {
            //throw new GetModigieCampaignButtonException('You are not assigned limits for modigie services, please contact your system administrator.');
          }
        }
        List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Mobile Phone Job Read' LIMIT 1];
        String targetAudience, endpoint, contentType;
        if(!calloutInfo.isEmpty()){
          endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
          targetAudience = calloutInfo[0].modigie__targetAud__c;
          contentType = calloutInfo[0].modigie__Content_Type__c;
        }

        //String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',modigieCredential[0].modigie__Private_Key__c);
        String accessToken =
          'Bearer ' +
          jwtapex.get_access_token(
            modigieCredential[0].modigie__Email__c,
            targetAudience,
            modigieCredential[0].modigie__Private_Key__c
          );

        // if(modigieCredential.size() > 0){
        //     if(conLst.size()>0)
        //     {
        //         ContactBatchForGetModigieButton b1 = new ContactBatchForGetModigieButton(conLst,recid,accessToken);
        //         Id jobId = Database.executeBatch(b1,100);
        //         lstBatchJobsIds.add(jobId);
        //     }

        //     if(ldLst.size()>0)
        //     {
        //         LeadBatchForGetModigieButton b2 = new LeadBatchForGetModigieButton(ldLst,recid,accessToken);
        //         Id jobId = Database.executeBatch(b2,100);
        //         lstBatchJobsIds.add(jobId);
        //     }
        // }

        if (!modigieCredential.isEmpty()) {
          Integer b_size = 100;
          try{
              b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
              if(b_size > 100 || b_size < 1){
                b_size = 100;
              }
          }catch(Exception e){}
          if (!conLst.isEmpty()) {
            if (
              lstPbs[0].modigie__Is_Active_Contact_Alt_LinkedIn_Url__c &&
              lstPbs[0].modigie__Contact_Alt_LinkedIn_Url_Field_Name__c != null
            ) {
              ContactBatchForModigieLinkedInMapping batchable = new ContactBatchForModigieLinkedInMapping(
                conLst,
                recid,
                accessToken,
                lstPbs[0].modigie__Contact_Alt_LinkedIn_Url_Field_Name__c
              );
              Database.executeBatch(batchable);
            } else {
              ContactBatchForGetModigieButton b1 = new ContactBatchForGetModigieButton(
                conLst,
                recid,
                accessToken
              );
              Id jobId = Database.executeBatch(b1, b_size);
              lstBatchJobsIds.add(jobId);
            }
          }

          if (!ldLst.isEmpty()) {
            if (
              lstPbs[0].modigie__Is_Active_Lead_Alt_LinkedIn_Url__c &&
              lstPbs[0].modigie__Lead_Alt_LinkedIn_Url_Field_Name__c != null
            ) {
              LeadBatchForModigieLinkedInMapping batchable = new LeadBatchForModigieLinkedInMapping(
                ldLst,
                recid,
                accessToken,
                lstPbs[0].modigie__Lead_Alt_LinkedIn_Url_Field_Name__c
              );
              Database.executeBatch(batchable);
            } else {
              LeadBatchForGetModigieButton b2 = new LeadBatchForGetModigieButton(
                ldLst,
                recid,
                accessToken
              );
              Id jobId = Database.executeBatch(b2, b_size);
              lstBatchJobsIds.add(jobId);
            }
          }
        } else {
          throw new GetModigieCampaignButtonException(
            'You are not an authorized user.'
          );
        }

        return lstBatchJobsIds;
      } else {
        throw new GetModigieCampaignButtonException(
          'User does not have the required object edit permissions.'
        );
      }
    } catch (ServerErrorException e) {
      Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(
        e.getMessage()
      );
      errorMap.put('ModigieService', 'Get Modigie');
      errorMap.put('SObjectId', recid);
      throw new ServerErrorException(JSON.serialize(errorMap));
    } catch (System.QueryException e) {
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put(
        'DisplayMessage',
        'You do not have permission to query lead, contact or modigie fields.'
      );
      throw new GetModigieCampaignButtonException(JSON.serialize(errorMap));
    } catch (Exception e) {
      Map<String, Object> errorMap = new Map<String, Object>();
      errorMap.put('DisplayMessage', e.getMessage());
      throw new GetModigieCampaignButtonException(JSON.serialize(errorMap));
    }
  }

  @AuraEnabled
  public static Integer checkBatchJobStatus(List<Id> lstIds) {
    List<AsyncApexJob> pendingBatchJobs = [
      SELECT Id
      FROM AsyncApexJob
      WHERE Id IN :lstIds AND Status NOT IN ('Completed', 'Aborted')
      WITH SECURITY_ENFORCED
    ];
    return pendingBatchJobs.size();
  }
  private class GetModigieCampaignButtonException extends Exception {
  }
}