global with sharing class InvocableDynamiCritriaGetModigieContact {
  @InvocableMethod
  global static void getRecordId(List<String> lstIds) {
    try {
      System.debug('lstIds :: ' + lstIds);
      if (
        FieldLevelSecurityCheck.canReadObject('Contact') &&
        FieldLevelSecurityCheck.canReadField(
          'Contact',
          'modigie__Modigie_Verified_Number__c'
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'Contact',
          'modigie__Alternate_Mobile_Phone_Available__c'
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'Contact',
          'modigie__Validation_Key__c'
        ) &&
        FieldLevelSecurityCheck.canUpdateField(
          'Contact',
          'modigie__Validation_Key__c'
        )
      ) {
        String orderBy = 'Name';
        List<modigie__Modigie_Automation_Criteria_Contact__c> macc = [SELECT modigie__Field_Order__c FROM modigie__Modigie_Automation_Criteria_Contact__c];

        if(macc.size() > 0 && [SELECT modigie__Field_Order__c FROM modigie__Modigie_Automation_Criteria_Contact__c LIMIT 1].modigie__Field_Order__c != null){
          orderBy = 'modigie__Field_Order__c';
        }
        System.debug('Contact orderBy-->'+ orderBy);
        String qry = 'SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Contact__c ORDER BY '+orderBy;
        List<modigie__Modigie_Automation_Criteria_Contact__c> lstContactCriteria = Database.query(qry);
        /*
        List<modigie__Modigie_Automation_Criteria_Contact__c> lstContactCriteria = [
          SELECT
            Id,
            Name,
            modigie__Field_Data_Type__c,
            modigie__Field_Value__c,
            modigie__Operator__c,
            modigie__Field_Api_Name__c
          FROM modigie__Modigie_Automation_Criteria_Contact__c
          ORDER BY Name
        ];
        */
        if (!lstContactCriteria.isEmpty()) {
          //25 Sep 2021 ( line 36 - 40 )
          List<PermissionSetAssignment> modigieAutomationUser = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Modigie_Automation_User'];
          List<Id> modigieAutomationUserIds = new List<Id>();
          for(PermissionSetAssignment loop_u: modigieAutomationUser){
            modigieAutomationUserIds.add(loop_u.AssigneeId);
          }
          String query = 'SELECT Id, FirstName, LastName, Email, Account.Name, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Contact WHERE Id In :lstIds AND Id NOT IN (SELECT modigie__Contact__c FROM modigie__c WHERE modigie__Status__c = \'In process\' OR modigie__Status__c = \'Validated\' OR modigie__Status__c = \'Not Available\')';
          
          //25 Sep 2021 ( line 44 )
          query += ' AND CreatedById in :modigieAutomationUserIds';

          Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

          Schema.SObjectType sObjectSchema = schemaMap.get('Contact');

          Map<String, Schema.SObjectField> fieldMap = sObjectSchema.getDescribe()
            .fields.getMap();

          Map<String, String> fieldApiNametoTypeMap = new Map<String, String>();
          for (String fieldName : fieldMap.keySet()) {
            String fieldType = String.valueOf(
              fieldMap.get(fieldName).getDescribe().getType()
            );
            if (
              fieldType == 'PICKLIST' ||
              fieldType == 'STRING' ||
              fieldType == 'URL' ||
              fieldType == 'PHONE' ||
              fieldType == 'DATETIME' ||
              fieldType == 'DATE' ||
              fieldType == 'DOUBLE' ||
              fieldType == 'INTEGER' ||
              fieldType == 'BOOLEAN'
            ) {
              fieldApiNametoTypeMap.put(fieldName, fieldType);
            }
          }

          List<DateTime> lstDateTime = new List<DateTime>();
          List<Date> lstDate = new List<Date>();

          if (
            fieldApiNametoTypeMap.containsKey (
              lstContactCriteria[0].modigie__Field_Api_Name__c
            )
          ) {
            query += ' AND (';
          }
          Map<Integer, String> mapCriteriaQuery = new Map<Integer, String>();
          Integer index = 1;
          for (
            modigie__Modigie_Automation_Criteria_Contact__c conCriteria : lstContactCriteria
          ) {
            System.debug('33 --->> ' + conCriteria);
            String singleQuery = '';
            if (
              fieldApiNametoTypeMap.containsKey(
                conCriteria.modigie__Field_Api_Name__c
              )
            ) {
              singleQuery += conCriteria.modigie__Field_Api_Name__c;
              String fieldType = fieldApiNametoTypeMap.get(
                conCriteria.modigie__Field_Api_Name__c
              );
              if (conCriteria.modigie__Operator__c == 'null') {
                if (conCriteria.modigie__Field_Value__c == 'true') {
                  singleQuery += ' = null';
                } else {
                  singleQuery += ' != null';
                }
              } else if (conCriteria.modigie__Operator__c == 'gt') {
                if (
                  fieldType == 'DATE' ||
                  fieldType == 'INTEGER' ||
                  fieldType == 'DOUBLE'
                ) {
                  singleQuery += ' > ' + conCriteria.modigie__Field_Value__c;
                } else if (fieldType == 'DATETIME') {
                  singleQuery +=
                    ' > ' +
                    conCriteria.modigie__Field_Value__c +
                    'T00:00:00Z';
                }
              } else if (conCriteria.modigie__Operator__c == 'lt') {
                if (
                  fieldType == 'DATE' ||
                  fieldType == 'INTEGER' ||
                  fieldType == 'DOUBLE'
                ) {
                  singleQuery += ' < ' + conCriteria.modigie__Field_Value__c;
                } else if (fieldType == 'DATETIME') {
                  singleQuery +=
                    ' < ' +
                    conCriteria.modigie__Field_Value__c +
                    'T00:00:00Z';
                }
              } else {
                if (conCriteria.modigie__Operator__c == 'equals') {
                  if (fieldType == 'PICKLIST') {
                    String criteriaValue = conCriteria.modigie__Field_Value__c;
                    List<String> lstCriteriaValue = criteriaValue.split(',');
                    singleQuery += ' IN (';

                    for (String criteriaValueNode : lstCriteriaValue) {
                      singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                    }

                    singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                    singleQuery += ')';
                  } else if (fieldType == 'BOOLEAN') {
                    if (conCriteria.modigie__Field_Value__c == 'true') {
                      singleQuery += ' = true';
                    } else {
                      singleQuery += ' = false';
                    }
                  } else if (fieldType == 'DOUBLE' || fieldType == 'INTEGER') {
                    singleQuery += ' = ' + conCriteria.modigie__Field_Value__c;
                  } else if (fieldType == 'DATETIME') {
                    List<String> lstString = conCriteria.modigie__Field_Value__c.split(
                      '-'
                    );

                    lstDateTime.add(
                      DateTime.newInstance(
                        Integer.valueOf(lstString[0]),
                        Integer.valueOf(lstString[1]),
                        Integer.valueOf(lstString[2])
                      )
                    );
                    singleQuery +=
                      ' = :lstDateTime[' +
                      (lstDateTime.size() - 1) +
                      ']';
                    //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                  } else if (fieldType == 'DATE') {
                    List<String> lstString = conCriteria.modigie__Field_Value__c.split(
                      '-'
                    );
                    lstDateTime.add(
                      Date.newInstance(
                        Integer.valueOf(lstString[0]),
                        Integer.valueOf(lstString[1]),
                        Integer.valueOf(lstString[2])
                      )
                    );
                    singleQuery +=
                      ' = :lstDateTime[' +
                      (lstDateTime.size() - 1) +
                      ']';
                  } else {
                    // singleQuery += ' = \'' + conCriteria.modigie__Field_Value__c + '\'';
                    String criteriaValue = conCriteria.modigie__Field_Value__c;
                    List<String> lstCriteriaValue = criteriaValue.split(';;');
                    singleQuery += ' IN (';

                    for (String criteriaValueNode : lstCriteriaValue) {
                      singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                    }

                    singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                    singleQuery += ')';
                  }
                } else {
                  if (fieldType == 'PICKLIST') {
                    String criteriaValue = conCriteria.modigie__Field_Value__c;
                    List<String> lstCriteriaValue = criteriaValue.split(',');
                    singleQuery += ' NOT IN (';

                    for (String criteriaValueNode : lstCriteriaValue) {
                      singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                    }

                    singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                    singleQuery += ')';
                  } else if (fieldType == 'BOOLEAN') {
                    if (conCriteria.modigie__Field_Value__c == 'true') {
                      singleQuery += ' != true';
                    } else {
                      singleQuery += ' != false';
                    }
                  } else if (fieldType == 'DOUBLE' || fieldType == 'INTEGER') {
                    singleQuery += ' != ' + conCriteria.modigie__Field_Value__c;
                  } else if (fieldType == 'DATETIME') {
                    List<String> lstString = conCriteria.modigie__Field_Value__c.split(
                      '-'
                    );

                    lstDateTime.add(
                      DateTime.newInstance(
                        Integer.valueOf(lstString[0]),
                        Integer.valueOf(lstString[1]),
                        Integer.valueOf(lstString[2])
                      )
                    );
                    singleQuery +=
                      ' != :lstDateTime[' +
                      (lstDateTime.size() - 1) +
                      ']';
                    //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                  } else if (fieldType == 'DATE') {
                    List<String> lstString = conCriteria.modigie__Field_Value__c.split(
                      '-'
                    );
                    lstDateTime.add(
                      Date.newInstance(
                        Integer.valueOf(lstString[0]),
                        Integer.valueOf(lstString[1]),
                        Integer.valueOf(lstString[2])
                      )
                    );
                    singleQuery +=
                      ' != :lstDateTime[' +
                      (lstDateTime.size() - 1) +
                      ']';
                  } else {
                    String criteriaValue = conCriteria.modigie__Field_Value__c;
                    List<String> lstCriteriaValue = criteriaValue.split(';;');
                    singleQuery += ' NOT IN (';

                    for (String criteriaValueNode : lstCriteriaValue) {
                      singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                    }

                    singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                    singleQuery += ')';
                    //singleQuery += ' != \'' + conCriteria.modigie__Field_Value__c + '\'';
                  }
                }
              }
            }
            System.debug(String.valueOf(index)+' --> '+ singleQuery);
            mapCriteriaQuery.put(index, singleQuery);
            index++;
          }
          
          //logicType can be of 1->'AND' 2->'OR' & 3->'CUSTOM'
          modigie__Process_Builder_Switch__c CustomLogic = [SELECT modigie__Dynamic_Contact_Logic_Type__c, modigie__Dynamic_Contact_Custom_Logic__c FROM modigie__Process_Builder_Switch__c LIMIT 1];
          String subQuery = '';
          String logicType;
          List<String> pToken = new List<String>();
          pToken.add('(');
          pToken.add(')');
          pToken.add('AND');
          pToken.add('OR');
          
          //Fetch Logic Type
          try{
            Integer expression = Integer.valueOf(CustomLogic.modigie__Dynamic_Contact_Logic_Type__c);
            switch on expression {
              when 1 {
                logicType = 'AND';
              }
              when 2 {
                logicType = 'OR';
              }
              when 3 {
                logicType = 'CUSTOM';
              }
              when else {
                logicType = 'AND';
              }
            }
          }catch(Exception e){
            logicType = 'AND';
          }

          //Create SubQuery in respose to correct Logic Type
          if(logicType == 'CUSTOM'){
            //If Custom get Custom Logic String, it is going to be parsed.
            Integer mapCriteriaQueryLength = mapCriteriaQuery.size();
            try{
              String tempQuery = '(' + CustomLogic.modigie__Dynamic_Contact_Custom_Logic__c + ')';
              tempQuery = tempQuery.replace('(', ' ( ');
              tempQuery = tempQuery.replace(')', ' ) ');
              tempQuery = tempQuery.normalizeSpace();

              List<String> tokens = tempQuery.split(' ');
              for(String token: tokens){
                if(pToken.contains(token)){
                  subQuery += token;
                }else{
                  subQuery += mapCriteriaQuery.get(Integer.valueOf(token));
                }
                subQuery += ' ';
              }
              subQuery = subQuery.normalizeSpace();
              /*
              for(Integer orderNum: mapCriteriaQuery.keySet()){
                subQuery = subQuery.replaceAll(String.valueOf(mapCriteriaQueryLength),'{!key'+String.valueOf(mapCriteriaQueryLength)+'key!}');
                mapCriteriaQueryLength--;
              }
              */
            }catch(Exception e){
              subQuery = '';
            }
            /*
            if(subQuery != null || subQuery != '' || subQuery != '()'){
              mapCriteriaQueryLength = mapCriteriaQuery.size();
              for(Integer orderNum: mapCriteriaQuery.keySet()){
                String toReplaceStr = '\\{\\!key'+String.valueOf(mapCriteriaQueryLength)+'key\\!\\}';
                subQuery = subQuery.replaceAll(toReplaceStr, mapCriteriaQuery.get(mapCriteriaQueryLength));
                System.debug(String.valueOf(mapCriteriaQueryLength)+' --> '+ mapCriteriaQuery.get(mapCriteriaQueryLength));
                mapCriteriaQueryLength--;
              }
            }
            */
          }else{
            for(Integer orderNum: mapCriteriaQuery.keySet()){
              subQuery += mapCriteriaQuery.get(orderNum);
              if(mapCriteriaQuery.get(orderNum +1) != null){
                subQuery += ' ' + logicType + ' ';
              }
              System.debug(String.valueOf(orderNum)+' --> '+ mapCriteriaQuery.get(orderNum));
            }
          }

          System.debug('SubQuery --> '+ SubQuery);
          if (
            fieldApiNametoTypeMap.containsKey (
              lstContactCriteria[0].modigie__Field_Api_Name__c
            )
          ) {
            query += subQuery+')';
          }
          query += ' WITH SECURITY_ENFORCED';

          System.debug('Query -->> ' + query);

          List<Contact> lstCon = Database.query(query);

          System.debug('lstCon ---> ' + lstCon);

          if (!lstCon.isEmpty()) {
            if (System.isBatch() || System.isFuture()) {
              List<String> lstIdsCon = new List<String>();

              for (Contact con : lstCon) {
                lstIdsCon.add(con.Id);
              }

              Datetime timeToSchedule = System.now().addMinutes(2);
              ModigieServicesAsychronousSchedulable schedulable = new ModigieServicesAsychronousSchedulable(
                lstIdsCon,
                'Dynamic Criteria Get Modigie Contact'
              );
              System.schedule(
                'Get Modigie Sales Engagement Tool Module Con' +
                System.now().addMinutes(2) +
                Math.round((Math.random() * (9000) + 1000)),
                timeToSchedule.second() +
                ' ' +
                timeToSchedule.minute() +
                ' ' +
                timeToSchedule.hour() +
                ' ' +
                timeToSchedule.day() +
                ' ' +
                timeToSchedule.month() +
                ' ? ' +
                timeToSchedule.year(),
                schedulable
              );
            } else {
              List<modigie__Process_Builder_Switch__c> pbs = [
                SELECT
                  modigie__Dynamic_Criteria_Automation_Limit__c,
                  modigie__Dynamic_Criteria_Automation_Usage__c,
                  modigie__Limits_No_Limits_Selection__c,
                  modigie__Dynamic_Criteria_Automation_A__c
                FROM modigie__Process_Builder_Switch__c
                WITH SECURITY_ENFORCED
                LIMIT 1
              ];
              if (!pbs.isEmpty()) {
                if (
                  pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c == null
                ) {
                  pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c = 0;
                  update pbs;
                }
                if (
                  pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c == null
                ) {
                  pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c = 0;
                  update pbs;
                }
                if (
                  pbs[0]
                    .modigie__Limits_No_Limits_Selection__c
                    ?.equalsIgnoreCase('No Limits') == true ||
                  (pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c >=
                  pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c +
                  lstCon.size())
                ) {
                  List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
                  tokenList = [
                    SELECT
                      Name,
                      modigie__Credits_Account_Id__c,
                      modigie__API_Key__c,
                      modigie__Service_Account_Credentials__c,
                      modigie__Private_Key__c
                    FROM modigie__Modigie_Credentials__c
                    WITH SECURITY_ENFORCED
                    LIMIT 1
                  ];
                  if (!tokenList.isEmpty()) {
                    //  List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds WITH SECURITY_ENFORCED];
                    if (!lstCon.isEmpty()) {
                      ContactBatchForGetModigieButton batchable = new ContactBatchForGetModigieButton(
                        lstCon,
                        4
                      );
                      Integer b_size = 100;
                      try{
                          b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                          if(b_size > 100 || b_size < 1){
                            b_size = 100;
                        }
                      }catch(Exception e){}
                      Database.executeBatch(batchable, b_size);
                    }
                  }
                } else {
                  // NotificationServiceClass.sendNotification(
                  //   'Get Modigie Sales Engagement Automation Module',
                  //   pbs[0].modigie__Dynamic_Criteria_Automation_A__c
                  // );
                  NotificationServiceClass.sendEmailLimitReached('Get Modigie Sales Engagement Automation Module', 'modigie__Dynamic_Criteria_Automation_Limit__c', pbs[0].modigie__Dynamic_Criteria_Automation_Limit__c, pbs[0].modigie__Dynamic_Criteria_Automation_Usage__c, lstIds.size(), pbs[0].modigie__Dynamic_Criteria_Automation_A__c);
                }
              }
            }
          }
        }
      }
    } catch (Exception e) {
      //call here Error Email
      EmailServiceClass.sendErrorEmail('InvocableDynamiCritriaGetModigieContact Error', e);
/*        /*try {
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
          List<String> toAddresses = new List<String>();
          toAddresses.add('pratik@cyntexa.com');
          toAddresses.add('ashishsharma@cyntexa.com');
          if (!toAddresses.isEmpty()) {
            mail.setToAddresses(toAddresses);
            mail.saveAsActivity = false;
            mail.setSubject(
              'Modigie : InvocableDynamiCritriaGetModigieContact Error'
            );
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
        System.debug('e.getLineNumber() --> ' + e.getLineNumber());
        System.debug('error --> ' + e.getMessage());
      } catch (Exception exx) {
      }*/
    }
  }
}