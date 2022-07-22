@isTest
public class RuleSetFactoryTest {
    public static void insertAnalysisUseCase(String ruleName) {
        Datetime currentTime = System.now();
        String uniqueString = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(currentTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'))));
        modigie__Modigie_Rule_Sets__c mrs = new modigie__Modigie_Rule_Sets__c(Name = uniqueString, modigie__Rule_Set_Name__c = ruleName, modigie__isActive__c = true, modigie__isLimit__c = true, modigie__Limit__c = 5, modigie__Maintain_Queue__c = true, modigie__Lead_Logic_Type__c = 3, modigie__Contact_Logic_Type__c = 3, modigie__Lead_Custom_Logic__c = '1 AND 2 AND (3 OR 4 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11) AND 5 AND 12 AND 13 AND 14 AND 15 AND 16 AND 17', modigie__Contact_Custom_Logic__c = '1 AND 2 AND (3 OR 4 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11) AND 5 AND 12 AND 13 AND 14 AND 15 AND 16 AND 17');
        insert mrs;
        List<modigie__Modigie_Automation_Criteria_Contact__c> lmacc= new List<modigie__Modigie_Automation_Criteria_Contact__c>();
        List<modigie__Modigie_Automation_Criteria_Lead__c> lmacl= new List<modigie__Modigie_Automation_Criteria_Lead__c>();
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'1', modigie__Field_Value__c = 'Test', modigie__Operator__c = 'nct',modigie__Field_Api_Name__c = 'title'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'2', modigie__Field_Value__c = 'Test;;Non;;Enrich;;Abacas', modigie__Operator__c = 'equals',modigie__Field_Api_Name__c = 'firstname'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'3', modigie__Field_Value__c = '1999-07-12', modigie__Operator__c = 'gte',modigie__Field_Api_Name__c = 'birthdate'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'4', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'equals',modigie__Field_Api_Name__c = 'createddate'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'5', modigie__Field_Value__c = 'True', modigie__Operator__c = 'null',modigie__Field_Api_Name__c = 'donotcall'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'6', modigie__Field_Value__c = 'Test;;Non;;Enrich;;Abacas', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'firstname'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'7', modigie__Field_Value__c = 'www', modigie__Operator__c = 'sw',modigie__Field_Api_Name__c = 'lastname'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'8', modigie__Field_Value__c = '69426938', modigie__Operator__c = 'equals',modigie__Field_Api_Name__c = 'mobilephone'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'9', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'lastmodifieddate'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'10', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'lt',modigie__Field_Api_Name__c = 'lastmodifieddate'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'11', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'lte',modigie__Field_Api_Name__c = 'lastmodifieddate'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'12', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'gt',modigie__Field_Api_Name__c = 'lastmodifieddate'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'13', modigie__Field_Value__c = 'A,B,C,D', modigie__Operator__c = 'equals',modigie__Field_Api_Name__c = 'cleanstatus'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'14', modigie__Field_Value__c = 'E,F,G,H', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'cleanstatus'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'15', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'gte',modigie__Field_Api_Name__c = 'lastmodifieddate'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'16', modigie__Field_Value__c = 'True', modigie__Operator__c = 'equals',modigie__Field_Api_Name__c = 'donotcall'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'17', modigie__Field_Value__c = 'False', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'donotcall'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'1', modigie__Field_Value__c = 'Test', modigie__Operator__c = 'nct',modigie__Field_Api_Name__c = 'title'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'2', modigie__Field_Value__c = 'Test;;Non;;Enrich;;Abaca', modigie__Operator__c = 'equals',modigie__Field_Api_Name__c = 'firstname'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'3', modigie__Field_Value__c = '22498439', modigie__Operator__c = 'gte',modigie__Field_Api_Name__c = 'numberofemployees'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'4', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'equals',modigie__Field_Api_Name__c = 'createddate'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'5', modigie__Field_Value__c = 'True', modigie__Operator__c = 'null',modigie__Field_Api_Name__c = 'donotcall'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'6', modigie__Field_Value__c = 'Test;;Non;;Enrich;;Abacas', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'firstname'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'7', modigie__Field_Value__c = 'www', modigie__Operator__c = 'sw',modigie__Field_Api_Name__c = 'lastname'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'8', modigie__Field_Value__c = '69426938', modigie__Operator__c = 'equals',modigie__Field_Api_Name__c = 'mobilephone'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'9', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'lastmodifieddate'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'10', modigie__Field_Value__c = 'A,B,C,D', modigie__Operator__c = 'equals',modigie__Field_Api_Name__c = 'status'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'11', modigie__Field_Value__c = 'E,F,G,H', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'status'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'12', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'lt',modigie__Field_Api_Name__c = 'lastmodifieddate'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'13', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'lte',modigie__Field_Api_Name__c = 'lastmodifieddate'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'14', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'gt',modigie__Field_Api_Name__c = 'lastmodifieddate'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'15', modigie__Field_Value__c = '2022-04-04', modigie__Operator__c = 'gte',modigie__Field_Api_Name__c = 'lastmodifieddate'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'16', modigie__Field_Value__c = 'True', modigie__Operator__c = 'equals',modigie__Field_Api_Name__c = 'donotcall'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'17', modigie__Field_Value__c = 'False', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'donotcall'));
        insert lmacc;
        insert lmacl;
    }
    public static void insertUseCase(String ruleName) {
        Datetime currentTime = System.now();
        String uniqueString = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(currentTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'))));
        modigie__Modigie_Rule_Sets__c mrs = new modigie__Modigie_Rule_Sets__c(Name = uniqueString, modigie__Rule_Set_Name__c = ruleName, modigie__isActive__c = true, modigie__isLimit__c = true, modigie__Limit__c = 5, modigie__Maintain_Queue__c = true, modigie__Lead_Logic_Type__c = 1, modigie__Contact_Logic_Type__c = 2);
        insert mrs;
        List<modigie__Modigie_Automation_Criteria_Contact__c> lmacc= new List<modigie__Modigie_Automation_Criteria_Contact__c>();
        List<modigie__Modigie_Automation_Criteria_Lead__c> lmacl= new List<modigie__Modigie_Automation_Criteria_Lead__c>();
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'1',  modigie__Field_Value__c = '2022-12-12', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'createddate'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'2',  modigie__Field_Value__c = 'Test', modigie__Operator__c = 'ct',modigie__Field_Api_Name__c = 'firstname'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'1',  modigie__Field_Value__c = '2022-12-12', modigie__Operator__c = 'lte',modigie__Field_Api_Name__c = 'createddate'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Rule_Set_Id__c = mrs.Id, Name = uniqueString+'2',  modigie__Field_Value__c = 'True', modigie__Operator__c = 'null',modigie__Field_Api_Name__c = 'mobilephone'));
        insert lmacc;
        insert lmacl;
    }

    public static void insertTomCriteria() {
        Datetime currentTime = System.now();
        String uniqueString = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(currentTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'))));
        modigie__TOM_Criteria__c tom = new modigie__TOM_Criteria__c(Name = uniqueString, modigie__isTom__c = true, modigie__Lead_Logic_Type__c = 2, modigie__Contact_Logic_Type__c = 2);
        insert tom;
        List<modigie__Modigie_Automation_Criteria_Contact__c> lmacc= new List<modigie__Modigie_Automation_Criteria_Contact__c>();
        List<modigie__Modigie_Automation_Criteria_Lead__c> lmacl= new List<modigie__Modigie_Automation_Criteria_Lead__c>();
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__TOM_Id__c = tom.Id, Name = uniqueString+'1',  modigie__Field_Value__c = 'Test', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'lastname'));
        lmacc.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__TOM_Id__c = tom.Id, Name = uniqueString+'2',  modigie__Field_Value__c = 'Test', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'firstname'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__TOM_Id__c = tom.Id, Name = uniqueString+'1',  modigie__Field_Value__c = 'Test', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'lastname'));
        lmacl.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__TOM_Id__c = tom.Id, Name = uniqueString+'2',  modigie__Field_Value__c = 'True', modigie__Operator__c = 'notEquals',modigie__Field_Api_Name__c = 'firstname'));
        insert lmacc;
        insert lmacl;
    }

    public static void createObjectRecords(Integer howMany, String singleObj){
        if(howMany > 1 || howMany != null){
            List<Lead> lstlead = new List<Lead>();
            List<Contact> lstcon = new List<Contact>();
            Account acc = new Account(Name = 'Test');
            insert acc;
            for(Integer i = 0; i< howMany; i++){
                if(singleObj == 'Lead'){
                    lstlead.add(new Lead(FirstName = 'Test', LastName = 'Test'+i, Company = 'Test', Email = 'test@test.com'));
                }else if(singleObj == 'Contact'){
                    lstcon.add(new Contact(FirstName = 'Test', LastName = 'Test'+i, AccountId = acc.Id, Email = 'test@test.com'));
                }else{
                    lstlead.add(new Lead(FirstName = 'Test', LastName = 'Test'+i, Company = 'Test', Email = 'test@test.com'));
                    lstcon.add(new Contact(FirstName = 'Test', LastName = 'Test'+i, AccountId = acc.Id, Email = 'test@test.com'));
                }
            }
            if(!lstcon.isEmpty()){
                insert lstcon;
            }
            if(!lstlead.isEmpty()){
                insert lstlead;
            }
        }
    }

    public static void createQueue(String ruleName, String singleObj){
        createObjectRecords(1, singleObj);
        List<Lead> lstlead= [SELECT Id FROM Lead LIMIT 1];
        List<Contact> lstcon= [SELECT Id FROM Contact LIMIT 1];
        modigie__Modigie_Rule_Sets__c mrs = [SELECT Id FROM modigie__Modigie_Rule_Sets__c WHERE modigie__Rule_Set_Name__c = :ruleName LIMIT 1];
        List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
        if(!lstlead.isEmpty()){
            modiList.add(new modigie__Modigie__c(modigie__Rule_Set_Id__c = mrs.Id, modigie__Status__c = 'In queue', modigie__Lead__c = lstlead[0].Id, modigie__Parent_Id__c = lstlead[0].Id, modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
            modiList.add(new modigie__Modigie__c(modigie__Rule_Set_Id__c = mrs.Id, modigie__Status__c = 'In queue', modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
            modiList.add(new modigie__Modigie__c(modigie__Status__c = 'In queue', modigie__Lead__c = lstlead[0].Id, modigie__Parent_Id__c = lstlead[0].Id, modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
        }
        if(!lstcon.isEmpty()){
            modiList.add(new modigie__Modigie__c(modigie__Rule_Set_Id__c = mrs.Id, modigie__Status__c = 'In queue', modigie__Contact__c = lstcon[0].Id, modigie__Parent_Id__c = lstcon[0].Id, modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
            modiList.add(new modigie__Modigie__c(modigie__Rule_Set_Id__c = mrs.Id, modigie__Status__c = 'In queue', modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
            modiList.add(new modigie__Modigie__c(modigie__Status__c = 'In queue', modigie__Contact__c = lstcon[0].Id, modigie__Parent_Id__c = lstcon[0].Id, modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
        }
        modiList.add(new modigie__Modigie__c(modigie__Status__c = 'In queue', modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
        if(!modiList.isEmpty()){
            insert modiList;
        }
    }

    public static List<modigie__Modigie__c> createCalled(String ruleName, String singleObj){
        createObjectRecords(1, singleObj);
        List<Lead> lstlead= [SELECT Id FROM Lead LIMIT 1];
        List<Contact> lstcon= [SELECT Id FROM Contact LIMIT 1];
        modigie__Modigie_Rule_Sets__c mrs = [SELECT Id, modigie__Rule_Set_Name__c FROM modigie__Modigie_Rule_Sets__c WHERE modigie__Rule_Set_Name__c = :ruleName LIMIT 1];
        List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
        String logicStringLead = RuleSetClass.GetRuleSetName(mrs.Id);
        String logicStringContact = RuleSetClass.GetRuleSetName(mrs.Id);
        if(!lstlead.isEmpty()){
            modiList.add(new modigie__Modigie__c(modigie__Rule_Set_Id__c = mrs.Id, modigie__Rule_Set_Name__c = mrs.modigie__Rule_Set_Name__c, modigie__Rule_Set_Logic__c = logicStringLead, modigie__Status__c = 'In process', modigie__Lead__c = lstlead[0].Id, modigie__Parent_Id__c = lstlead[0].Id, modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
            modiList.add(new modigie__Modigie__c(modigie__Rule_Set_Id__c = mrs.Id, modigie__Rule_Set_Name__c = mrs.modigie__Rule_Set_Name__c, modigie__Rule_Set_Logic__c = logicStringLead, modigie__Status__c = 'In queue', modigie__Lead__c = lstlead[0].Id, modigie__Parent_Id__c = lstlead[0].Id, modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
        }
        if(!lstcon.isEmpty()){
            modiList.add(new modigie__Modigie__c(modigie__Rule_Set_Id__c = mrs.Id, modigie__Rule_Set_Name__c = mrs.modigie__Rule_Set_Name__c, modigie__Rule_Set_Logic__c = logicStringContact, modigie__Status__c = 'In process', modigie__Contact__c = lstcon[0].Id, modigie__Parent_Id__c = lstcon[0].Id, modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
            modiList.add(new modigie__Modigie__c(modigie__Rule_Set_Id__c = mrs.Id, modigie__Rule_Set_Name__c = mrs.modigie__Rule_Set_Name__c, modigie__Rule_Set_Logic__c = logicStringContact, modigie__Status__c = 'In queue', modigie__Contact__c = lstcon[0].Id, modigie__Parent_Id__c = lstcon[0].Id, modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey'));
        }
        if(!modiList.isEmpty()){
            insert modiList;
        }
        return modiList;
    }

    public static void createToken() {
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
    }
}