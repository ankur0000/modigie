/************************************************************************ 
@Authors Rikky Malviya
@Date    13 jan 2022
@Name    RuleSetClass
@Description Everything Related to RuleSet handled here
***********************************************************************/
public with sharing class RuleSetClass {
    public RuleSetClass() {
        //no use
    }






    //Raising an issue,remember it






    /** UseCase - Decide which records are to be fired, also map records to their respective ruleset */
    public static Map<Id,List<Id>> RecordsToFire(List<Id> objIdList, String creditId, Boolean isPerformance){
        Map<Id,List<Id>> ruleSetIdObjList = new Map<Id,List<Id>>();
        try {
            // Making a copy to manipulate. So, Ids don't come in Multiple Ruleset
            Set<Id> setTempIds = new Set<Id>(objIdList);
            String objType = objIdList[0].getSObjectType().getDescribe().getName();

            Map<String, String> fieldApiNametoTypeMap = getfieldApiNametoTypeMap(objType);

            List<modigie__Modigie_Rule_Sets__c> mrsList = [SELECT Id, modigie__Rule_Set_Name__c, modigie__Email_Limit_Sent__c, modigie__Limit__c, modigie__Usage__c, modigie__isLimit__c, modigie__Maintain_Queue__c, modigie__isPerformance__c FROM modigie__Modigie_Rule_Sets__c WHERE modigie__isActive__c = true AND modigie__isPerformance__c =: isPerformance];
            for(modigie__Modigie_Rule_Sets__c mrs: mrsList){
                //Check? Limit, Usage, isLimit, isMaintainQueue
                if(mrs.modigie__Usage__c == Null){
                    mrs.modigie__Usage__c = 0;
                }
                if((mrs.modigie__isLimit__c && ((mrs.modigie__Limit__c - mrs.modigie__Usage__c) > 0)) || !mrs.modigie__isLimit__c || mrs.modigie__Maintain_Queue__c){
                    Set<Id> tempIds = MapRecordToRuleSet(mrs.Id, setTempIds, objType);
                    ruleSetIdObjList.put(mrs.Id, (new List<Id>(tempIds)));
                    //Removed by issue: Prioritize for queue if next one can fire it
                    //setTempIds.removeAll(tempIds);
                }
            }
            return RuleSetIdObjList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return ruleSetIdObjList;
        }
    }

    //public static List<Map<Id, List<Id>>> transitRuleSetRecords()

    public static Map<String, String> getfieldApiNametoTypeMap(String objType){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType sObjectSchema = schemaMap.get(objType);
            Map<String, Schema.SObjectField> fieldMap = sObjectSchema.getDescribe().fields.getMap();
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
            return fieldApiNameToTypeMap;
    }

    public static Set<Id> MapRecordToRuleSet(Id ruleSetId, Set<Id> objIdList, String objType){
        Set<id> resultIds = new Set<Id>();
        String onlyCreate = '';
        try {
            modigie__Modigie_Rule_Sets__c mRS = [SELECT modigie__OnlyOnCreate__c FROM modigie__Modigie_Rule_Sets__c WHERE Id = :ruleSetId];
            if(mRS.modigie__OnlyOnCreate__c){
                onlyCreate = 'modigie__Modigie_Is_New__c = true AND ';
            }
            System.debug('is Only on Create -> ' + onlyCreate);
            String qry = 'SELECT Id FROM '+objType+'  WHERE ' + onlyCreate + 'Id In :objIdList AND Id NOT IN (SELECT modigie__'+objType+'__c FROM modigie__c WHERE modigie__Status__c = \'In process\' OR modigie__Status__c = \'Validated\' OR modigie__Status__c = \'Not Available\')';
            qry += GetRuleSetSubQuery(ruleSetId, objType);
            System.debug('To Run Query-> '+qry+' objIdList : '+objIdList);
            List<SObject> resultList = Database.query(qry);
            
            For(SObject s: resultList){
                resultIds.add(s.Id);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        System.debug('RuleId-> Records : '+resultIds);
        return resultIds;
    }

    //retType value Lead, Contact, else - both
    public static string GetRuleSetQueryLogic(String ruleSetId, String objType){
        String leadQuery = 'Lead : ' + GetRuleSetSubQuery(ruleSetId, 'Lead');
        if(objType == 'Lead'){
            return leadQuery;
        }
        String contactQuery = 'Contact: ' + GetRuleSetSubQuery(ruleSetId, 'Contact');
        If(objType == 'Contact'){
            return contactQuery;
        }
        String allQuery = leadQuery+'\n'+contactQuery;
        return allQuery;
    }

    public static string GetRuleSetName(String ruleSetId){
        String ruleSetName = [SELECT modigie__Rule_Set_Name__c FROM modigie__Modigie_Rule_Sets__c WHERE Id = :ruleSetId LIMIT 1].modigie__Rule_Set_Name__c;
        return ruleSetName;
    }

    public static string GetRuleSetSubQuery(String parentId, String objType){
        try {
            Boolean isTom = false;
            Map<String, String> fieldApiNametoTypeMap = getfieldApiNametoTypeMap(objType);
            String query = '';
            if(objType == 'Contact'){
                
                List<modigie__Modigie_Automation_Criteria_Contact__c> lstContactCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__TOM_Id__c FROM modigie__Modigie_Automation_Criteria_Contact__c WHERE (modigie__Rule_Set_Id__c =:parentId OR modigie__TOM_Id__c =:parentId) ORDER BY modigie__Field_Order__c];
                
                if(!lstContactCriteria.isEmpty()){
                    if(lstContactCriteria[0].modigie__TOM_Id__c != Null){
                        isTom = true;
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
                            List<String> stringOperators = new List<String>{'ct', 'nct', 'sw', 'nsw', 'ew', 'new'};
                            if(stringOperators.contains(conCriteria.modigie__Operator__c) && conCriteria.modigie__Operator__c.startsWith('n')){
                                singleQuery += ' (NOT ';
                            }
                            String fieldType = fieldApiNametoTypeMap.get(
                                conCriteria.modigie__Field_Api_Name__c
                            );
                            if(fieldType == 'DATETIME' && (conCriteria.modigie__Operator__c == 'equals' || conCriteria.modigie__Operator__c == 'notEquals')){
                                singleQuery += ' (';
                            }
                            singleQuery += conCriteria.modigie__Field_Api_Name__c;
                            if (conCriteria.modigie__Operator__c == 'null') {
                                if (conCriteria.modigie__Field_Value__c == 'true') {
                                singleQuery += ' = null';
                                } else {
                                singleQuery += ' != null';
                                }
                            }else if (conCriteria.modigie__Operator__c == 'gte') {
                                if (
                                fieldType == 'DATE' ||
                                fieldType == 'INTEGER' ||
                                fieldType == 'DOUBLE'
                                ) {
                                singleQuery += ' >= ' + conCriteria.modigie__Field_Value__c;
                                } else if (fieldType == 'DATETIME') {
                                singleQuery +=
                                    ' >= ' +
                                    conCriteria.modigie__Field_Value__c +
                                    'T00:00:00Z';
                                }
                            } else if (conCriteria.modigie__Operator__c == 'lte') {
                                if (
                                fieldType == 'DATE' ||
                                fieldType == 'INTEGER' ||
                                fieldType == 'DOUBLE'
                                ) {
                                singleQuery += ' <= ' + conCriteria.modigie__Field_Value__c;
                                } else if (fieldType == 'DATETIME') {
                                singleQuery +=
                                    ' <= ' +
                                    conCriteria.modigie__Field_Value__c +
                                    'T23:59:59Z';
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
                                    } else if(fieldType == 'DATETIME'){
                                        //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                        String d = conCriteria.modigie__Field_Value__c;//.split('-');
                                        //lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                        singleQuery += ' >= ' + d + 'T00:00:00Z AND ' + conCriteria.modigie__Field_Api_Name__c + ' <= ' + d +'T23:59:59Z )';//+ lstDateTime[lstDateTime.size()-1];//:lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                        //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                    } else if(fieldType == 'DATE'){
                                        //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                        String d = conCriteria.modigie__Field_Value__c;
                                        //lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                        singleQuery += ' = ' + d;//':lstDateTime[' +  (lstDateTime.size()-1) + ']';   
                                    } else {
                                        // singleQuery += ' = \'' + conCriteria.modigie__Field_Value__c + '\'';
                                        String criteriaValue = conCriteria.modigie__Field_Value__c;
                                        /*if(criteriaValue.contains('\\')){
                                            criteriaValue = criteriaValue.replace('\\', '\\\\');
                                        }
                                        if(criteriaValue.contains('\'')){
                                            criteriaValue = criteriaValue.replace('\'', '\\\'');
                                        }*/
                                        List<String> lstCriteriaValue = criteriaValue.split(';;');
                                        singleQuery += ' IN (';

                                        for (String criteriaValueNode : lstCriteriaValue) {
                                        singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                                        }

                                        singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                                        singleQuery += ')';
                                    }
                                } else {
                                    //List<String> stringOperators = new List<String>{'ct', 'nct', 'sw', 'nsw', 'ew', 'new'};
                                    if(stringOperators.contains(conCriteria.modigie__Operator__c)){
                                        singleQuery += ' LIKE ';
                                        String criteriaValue = conCriteria.modigie__Field_Value__c;
                                        /*if(criteriaValue.contains('\\')){
                                            criteriaValue = criteriaValue.replace('\\', '\\\\');
                                        }
                                        if(criteriaValue.contains('\'')){
                                            criteriaValue = criteriaValue.replace('\'', '\\\'');
                                        }*/
                                        if(criteriaValue.contains('%')){
                                            criteriaValue = criteriaValue.replace('%', '\\%');
                                        }
                                        if(criteriaValue.contains('_')){
                                            criteriaValue = criteriaValue.replace('_', '\\_');
                                        }
                                        if(conCriteria.modigie__Operator__c.contains('ct')){
                                            singleQuery += '\'%'+criteriaValue+'%\'';
                                        }else if(conCriteria.modigie__Operator__c.contains('ew')){
                                            singleQuery += '\'%'+criteriaValue+'\'';
                                        }else if(conCriteria.modigie__Operator__c.contains('sw')){
                                            singleQuery += '\''+criteriaValue+'%\'';
                                        }

                                        if(conCriteria.modigie__Operator__c.startsWith('n')){
                                            singleQuery += ')';
                                        }

                                    }else{
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
                                        } else if(fieldType == 'DATETIME'){
                                            //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                            String d = conCriteria.modigie__Field_Value__c;//.split('-');
                                            //lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                            singleQuery += ' <= ' + d + 'T00:00:00Z OR ' + conCriteria.modigie__Field_Api_Name__c + ' >= ' + d +'T23:59:59Z )';//+ lstDateTime[lstDateTime.size()-1];//:lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                            //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                        } else if(fieldType == 'DATE'){
                                            //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                            String d = conCriteria.modigie__Field_Value__c;
                                            //lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                            singleQuery += ' != ' + d;//':lstDateTime[' +  (lstDateTime.size()-1) + ']';   
                                        } else {
                                            String criteriaValue = conCriteria.modigie__Field_Value__c;
                                            /*if(criteriaValue.contains('\\')){
                                                criteriaValue = criteriaValue.replace('\\', '\\\\');
                                            }
                                            if(criteriaValue.contains('\'')){
                                                criteriaValue = criteriaValue.replace('\'', '\\\'');
                                            }*/
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
                        }else{
                            throw new RuleSetClassException('FieldApiName is not present!');
                        }
                        System.debug(String.valueOf(index)+' --> '+ singleQuery);
                        mapCriteriaQuery.put(index, singleQuery);
                        index++;
                    }
                    
                    //logicType can be of 1->'AND' 2->'OR' & 3->'CUSTOM'
                    sObject customLogic;
                    if(isTom){
                        customLogic = [SELECT modigie__Contact_Logic_Type__c, modigie__Contact_Custom_Logic__c FROM modigie__TOM_Criteria__c WHERE Id = :parentId LIMIT 1];
                    }else{
                        customLogic = [SELECT modigie__Contact_Logic_Type__c, modigie__Contact_Custom_Logic__c FROM modigie__Modigie_Rule_Sets__c WHERE Id = :parentId LIMIT 1];
                    }

                    String subQuery = '';
                    String logicType;
                    List<String> pToken = new List<String>();
                    pToken.add('(');
                    pToken.add(')');
                    pToken.add('AND');
                    pToken.add('OR');
                    
                    //Fetch Logic Type
                    try{
                        Integer expression = Integer.valueOf(customLogic.get('modigie__Contact_Logic_Type__c'));
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
                        String tempQuery = '(' + customLogic.get('modigie__Contact_Custom_Logic__c') + ')';
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
                        }catch(Exception e){
                            subQuery = ' AND Id = Null';
                        }
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
                }else{
                    System.debug('Criteria Empty');
                    query = ' AND (Id = Null)';
                }
            }else if(objType == 'Lead'){
                
                List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__TOM_Id__c FROM modigie__Modigie_Automation_Criteria_Lead__c WHERE (modigie__Rule_Set_Id__c = :parentId OR modigie__TOM_Id__c = :parentId) ORDER BY modigie__Field_Order__c];

                if(!lstLeadCriteria.isEmpty()){
                    if(lstLeadCriteria[0].modigie__TOM_Id__c != Null){
                        isTom = true;
                    }
                    List<DateTime> lstDateTime = new List<DateTime>();
                    List<Date> lstDate = new List<Date>();

                    if (
                        fieldApiNametoTypeMap.containsKey (
                        lstLeadCriteria[0].modigie__Field_Api_Name__c
                        )
                    ) {
                        query += ' AND (';
                    }
                    Map<Integer, String> mapCriteriaQuery = new Map<Integer, String>();
                    Integer index = 1;
                    for (
                        modigie__Modigie_Automation_Criteria_Lead__c ldCriteria : lstLeadCriteria
                    ) {
                        System.debug('33 --->> ' + ldCriteria);
                        String singleQuery = '';
                        if (
                        fieldApiNametoTypeMap.containsKey(
                            ldCriteria.modigie__Field_Api_Name__c
                        )
                        ) {
                            List<String> stringOperators = new List<String>{'ct', 'nct', 'sw', 'nsw', 'ew', 'new'};
                            if(stringOperators.contains(ldCriteria.modigie__Operator__c) && ldCriteria.modigie__Operator__c.startsWith('n')){
                                singleQuery += ' (NOT ';
                            }
                            String fieldType = fieldApiNametoTypeMap.get(
                                ldCriteria.modigie__Field_Api_Name__c
                            );
                            if(fieldType == 'DATETIME' && (ldCriteria.modigie__Operator__c == 'equals' || ldCriteria.modigie__Operator__c == 'notEquals')){
                                singleQuery += ' (';
                            }
                            singleQuery += ldCriteria.modigie__Field_Api_Name__c;
                            if (ldCriteria.modigie__Operator__c == 'null') {
                                if (ldCriteria.modigie__Field_Value__c == 'true') {
                                singleQuery += ' = null';
                                } else {
                                singleQuery += ' != null';
                                }
                            }else if (ldCriteria.modigie__Operator__c == 'gte') {
                                if (
                                fieldType == 'DATE' ||
                                fieldType == 'INTEGER' ||
                                fieldType == 'DOUBLE'
                                ) {
                                singleQuery += ' >= ' + ldCriteria.modigie__Field_Value__c;
                                } else if (fieldType == 'DATETIME') {
                                singleQuery +=
                                    ' >= ' +
                                    ldCriteria.modigie__Field_Value__c +
                                    'T00:00:00Z';
                                }
                            } else if (ldCriteria.modigie__Operator__c == 'lte') {
                                if (
                                fieldType == 'DATE' ||
                                fieldType == 'INTEGER' ||
                                fieldType == 'DOUBLE'
                                ) {
                                singleQuery += ' <= ' + ldCriteria.modigie__Field_Value__c;
                                } else if (fieldType == 'DATETIME') {
                                singleQuery +=
                                    ' <= ' +
                                    ldCriteria.modigie__Field_Value__c +
                                    'T23:59:59Z';
                                }
                            } else if (ldCriteria.modigie__Operator__c == 'gt') {
                                if (
                                fieldType == 'DATE' ||
                                fieldType == 'INTEGER' ||
                                fieldType == 'DOUBLE'
                                ) {
                                singleQuery += ' > ' + ldCriteria.modigie__Field_Value__c;
                                } else if (fieldType == 'DATETIME') {
                                singleQuery +=
                                    ' > ' +
                                    ldCriteria.modigie__Field_Value__c +
                                    'T00:00:00Z';
                                }
                            } else if (ldCriteria.modigie__Operator__c == 'lt') {
                                if (
                                fieldType == 'DATE' ||
                                fieldType == 'INTEGER' ||
                                fieldType == 'DOUBLE'
                                ) {
                                singleQuery += ' < ' + ldCriteria.modigie__Field_Value__c;
                                } else if (fieldType == 'DATETIME') {
                                singleQuery +=
                                    ' < ' +
                                    ldCriteria.modigie__Field_Value__c +
                                    'T00:00:00Z';
                                }
                            } else {
                                if (ldCriteria.modigie__Operator__c == 'equals') {
                                    if (fieldType == 'PICKLIST') {
                                        String criteriaValue = ldCriteria.modigie__Field_Value__c;
                                        List<String> lstCriteriaValue = criteriaValue.split(',');
                                        singleQuery += ' IN (';

                                        for (String criteriaValueNode : lstCriteriaValue) {
                                        singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                                        }

                                        singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                                        singleQuery += ')';
                                    } else if (fieldType == 'BOOLEAN') {
                                        if (ldCriteria.modigie__Field_Value__c == 'true') {
                                        singleQuery += ' = true';
                                        } else {
                                        singleQuery += ' = false';
                                        }
                                    } else if (fieldType == 'DOUBLE' || fieldType == 'INTEGER') {
                                        singleQuery += ' = ' + ldCriteria.modigie__Field_Value__c;
                                    } else if(fieldType == 'DATETIME'){
                                        //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                        String d = ldCriteria.modigie__Field_Value__c;//.split('-');
                                        //lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                        singleQuery += ' >= ' + d + 'T00:00:00Z AND ' + ldCriteria.modigie__Field_Api_Name__c + ' <= ' + d +'T23:59:59Z )';//+ lstDateTime[lstDateTime.size()-1];//:lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                        //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                    } else if(fieldType == 'DATE'){
                                        //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                        String d = ldCriteria.modigie__Field_Value__c;
                                        //lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                        singleQuery += ' = ' + d;//':lstDateTime[' +  (lstDateTime.size()-1) + ']';   
                                    } else {
                                        /* else if(fieldType == 'DOUBLE' || fieldType == 'INTEGER'){
                                                            singleQuery += ' = ' + ldCriteria.modigie__Field_Value__c;
                                                        }
                                                        else if(fieldType == 'DATETIME'){
                                                            List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                                            
                                                            lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                                            singleQuery += ' = :lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                                            //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                                        }
                                                        else if(fieldType == 'DATE'){
                                                            List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                                            lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                                            singleQuery += ' = :lstDateTime[' +  (lstDateTime.size()-1) + ']';   
                                                        }*/
                                        String criteriaValue = ldCriteria.modigie__Field_Value__c;
                                        List<String> lstCriteriaValue = criteriaValue.split(';;');
                                        singleQuery += ' IN (';

                                        for (String criteriaValueNode : lstCriteriaValue) {
                                        singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                                        }

                                        singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                                        singleQuery += ')';

                                        // singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                    }
                                } else {
                                    if(stringOperators.contains(ldCriteria.modigie__Operator__c)){
                                        singleQuery += ' LIKE ';
        
                                        String criteriaValue = ldCriteria.modigie__Field_Value__c;
                                        /*if(criteriaValue.contains('\\')){
                                            criteriaValue = criteriaValue.replace('\\', '\\\\');
                                        }
                                        if(criteriaValue.contains('\'')){
                                            criteriaValue = criteriaValue.replace('\'', '\\\'');
                                        }*/
                                        if(criteriaValue.contains('%')){
                                            criteriaValue = criteriaValue.replace('%', '\\%');
                                        }
                                        if(criteriaValue.contains('_')){
                                            criteriaValue = criteriaValue.replace('_', '\\_');
                                        }
                                        if(ldCriteria.modigie__Operator__c.contains('ct')){
                                            singleQuery += '\'%'+criteriaValue+'%\'';
                                        }else if(ldCriteria.modigie__Operator__c.contains('ew')){
                                            singleQuery += '\'%'+criteriaValue+'\'';
                                        }else if(ldCriteria.modigie__Operator__c.contains('sw')){
                                            singleQuery += '\''+criteriaValue+'%\'';
                                        }
        
                                        if(ldCriteria.modigie__Operator__c.startsWith('n')){
                                        singleQuery += ')';
                                        }
        
                                    }else {
                                    if (fieldType == 'PICKLIST') {
                                        String criteriaValue = ldCriteria.modigie__Field_Value__c;
                                        List<String> lstCriteriaValue = criteriaValue.split(',');
                                        singleQuery += ' NOT IN (';

                                        for (String criteriaValueNode : lstCriteriaValue) {
                                        singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                                        }

                                        singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                                        singleQuery += ')';
                                    } else if (fieldType == 'BOOLEAN') {
                                        if (ldCriteria.modigie__Field_Value__c == 'true') {
                                        singleQuery += ' != true';
                                        } else {
                                        singleQuery += ' != false';
                                        }
                                    } else if (fieldType == 'DOUBLE' || fieldType == 'INTEGER') {
                                        singleQuery += ' != ' + ldCriteria.modigie__Field_Value__c;
                                    } else if(fieldType == 'DATETIME'){
                                        //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                        String d = ldCriteria.modigie__Field_Value__c;//.split('-');
                                        //lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                        singleQuery += ' <= ' + d + 'T00:00:00Z OR ' + ldCriteria.modigie__Field_Api_Name__c + ' >= ' + d +'T23:59:59Z )';//+ lstDateTime[lstDateTime.size()-1];//:lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                        //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                    } else if(fieldType == 'DATE'){
                                        //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                        String d = ldCriteria.modigie__Field_Value__c;
                                        //lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                        singleQuery += ' != ' + d;//':lstDateTime[' +  (lstDateTime.size()-1) + ']';   
                                    } else {
                                        /*  else if(fieldType == 'DATETIME'){
                                                            List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                                            
                                                            lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                                            singleQuery += ' != :lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                                            //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                                        }
                                                        else if(fieldType == 'DATE'){
                                                            List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                                            lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                                            singleQuery += ' != :lstDateTime[' +  (lstDateTime.size()-1) + ']';   
                                                        }*/
                                        String criteriaValue = ldCriteria.modigie__Field_Value__c;
                                        List<String> lstCriteriaValue = criteriaValue.split(';;');
                                        singleQuery += ' NOT IN (';

                                        for (String criteriaValueNode : lstCriteriaValue) {
                                        singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                                        }

                                        singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                                        singleQuery += ')';
                                        //singleQuery += ' != \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                    }
                                }
                                }
                            }
                        }else{
                            throw new RuleSetClassException('FieldApiName is not present!');
                        }
                        System.debug(String.valueOf(index)+' --> '+ singleQuery);
                        mapCriteriaQuery.put(index, singleQuery);
                        index++;
                    }

                    //logicType can be of 1->'AND' 2->'OR' & 3->'CUSTOM'
                    sObject customLogic;
                    if(isTom){
                        customLogic = [SELECT modigie__Lead_Logic_Type__c, modigie__Lead_Custom_Logic__c FROM modigie__TOM_Criteria__c WHERE Id = :parentId LIMIT 1];
                    }else{
                        customLogic = [SELECT modigie__Lead_Logic_Type__c, modigie__Lead_Custom_Logic__c FROM modigie__Modigie_Rule_Sets__c WHERE Id = :parentId LIMIT 1];
                    }
                    
                    //logicType can be of 1->'AND' 2->'OR' & 3->'CUSTOM'
                    String subQuery = '';
                    String logicType;
                    List<String> pToken = new List<String>();
                    pToken.add('(');
                    pToken.add(')');
                    pToken.add('AND');
                    pToken.add('OR');
                    
                    //Fetch Logic Type
                    try{
                        Integer expression = Integer.valueOf(customLogic.get('modigie__Lead_Logic_Type__c'));
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
                        String tempQuery = '(' + customLogic.get('modigie__Lead_Custom_Logic__c') + ')';
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
                        lstLeadCriteria[0].modigie__Field_Api_Name__c
                        )
                    ) {
                        query += subQuery+')';
                    }
                }else{
                    System.debug('Criteria Empty');
                    query = ' AND (Id = Null)';
                }
            }else{
                //throw error
                throw new RuleSetClassException('objType can be only Lead/Contact!');
            }
            System.debug('Query-->'+query);
            return query;
        } catch (Exception e) {
            EmailServiceClass.sendErrorEmail('RuleSetClass Error', e);
            return ' AND (Id = Null)';
        }
    }
    
    public static string GetRuleSetSubQueryNoId(List<modigie__Modigie_Automation_Criteria_Contact__c> lstContactCriteria, List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria, modigie__Modigie_Rule_Sets__c customLogic, String objType){
        try {
            Map<String, String> fieldApiNametoTypeMap = getfieldApiNametoTypeMap(objType);
            System.debug('fieldApiNameToTypeName -> ' + fieldApiNametoTypeMap);
            String query = '';
            if(objType == 'Contact'){
                
                //List<modigie__Modigie_Automation_Criteria_Contact__c> lstContactCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Contact__c WHERE modigie__Rule_Set_Id__c =:ruleSetId ORDER BY modigie__Field_Order__c];

                if(!lstContactCriteria.isEmpty()){
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
                        System.debug('Api Name -> ' + conCriteria.modigie__Field_Api_Name__c + ' Is Present -> ' + fieldApiNametoTypeMap.containsKey(conCriteria.modigie__Field_Api_Name__c));
                    
                        String singleQuery = '';
                        if (
                        fieldApiNametoTypeMap.containsKey(
                            conCriteria.modigie__Field_Api_Name__c
                        )
                        ) {
                        List<String> stringOperators = new List<String>{'ct', 'nct', 'sw', 'nsw', 'ew', 'new'};
                        if(stringOperators.contains(conCriteria.modigie__Operator__c) && conCriteria.modigie__Operator__c.startsWith('n')){
                            singleQuery += ' (NOT ';
                        }
                        String fieldType = fieldApiNametoTypeMap.get(
                            conCriteria.modigie__Field_Api_Name__c
                        );
                        
                        if(fieldType == 'DATETIME' && (conCriteria.modigie__Operator__c == 'equals' || conCriteria.modigie__Operator__c == 'notEquals')){
                            singleQuery += ' (';
                        }
                        singleQuery += conCriteria.modigie__Field_Api_Name__c;
                        if (conCriteria.modigie__Operator__c == 'null') {
                            if (conCriteria.modigie__Field_Value__c == 'true') {
                            singleQuery += ' = null';
                            } else {
                            singleQuery += ' != null';
                            }
                        }else if (conCriteria.modigie__Operator__c == 'gte') {
                            if (
                            fieldType == 'DATE' ||
                            fieldType == 'INTEGER' ||
                            fieldType == 'DOUBLE'
                            ) {
                            singleQuery += ' >= ' + conCriteria.modigie__Field_Value__c;
                            } else if (fieldType == 'DATETIME') {
                                singleQuery +=
                                    ' >= ' +
                                    conCriteria.modigie__Field_Value__c +
                                    'T00:00:00Z';
                            }
                        } else if (conCriteria.modigie__Operator__c == 'lte') {
                            if (
                            fieldType == 'DATE' ||
                            fieldType == 'INTEGER' ||
                            fieldType == 'DOUBLE'
                            ) {
                            singleQuery += ' <= ' + conCriteria.modigie__Field_Value__c;
                            } else if (fieldType == 'DATETIME') {
                            singleQuery +=
                                ' <= ' +
                                conCriteria.modigie__Field_Value__c +
                                'T23:59:59Z';
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
                                } else if(fieldType == 'DATETIME'){
                                    //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                    String d = conCriteria.modigie__Field_Value__c;//.split('-');
                                    //lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                    singleQuery += ' >= ' + d + 'T00:00:00Z AND ' + conCriteria.modigie__Field_Api_Name__c + ' <= ' + d +'T23:59:59Z )';//+ lstDateTime[lstDateTime.size()-1];//:lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                    //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                } else if(fieldType == 'DATE'){
                                    //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                    String d = conCriteria.modigie__Field_Value__c;
                                    //lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                    singleQuery += ' = ' + d;//':lstDateTime[' +  (lstDateTime.size()-1) + ']';   
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
                                //List<String> stringOperators = new List<String>{'ct', 'nct', 'sw', 'nsw', 'ew', 'new'};
                                if(stringOperators.contains(conCriteria.modigie__Operator__c)){
                                    singleQuery += ' LIKE ';

                                    String criteriaValue = conCriteria.modigie__Field_Value__c;
                                    /*if(criteriaValue.contains('\\')){
                                        criteriaValue = criteriaValue.replace('\\', '\\\\');
                                    }
                                    if(criteriaValue.contains('\'')){
                                        criteriaValue = criteriaValue.replace('\'', '\\\'');
                                    }*/
                                    if(criteriaValue.contains('%')){
                                        criteriaValue = criteriaValue.replace('%', '\\%');
                                    }
                                    if(criteriaValue.contains('_')){
                                        criteriaValue = criteriaValue.replace('_', '\\_');
                                    }
                                    if(conCriteria.modigie__Operator__c.contains('ct')){
                                        singleQuery += '\'%'+criteriaValue+'%\'';
                                    }else if(conCriteria.modigie__Operator__c.contains('ew')){
                                        singleQuery += '\'%'+criteriaValue+'\'';
                                    }else if(conCriteria.modigie__Operator__c.contains('sw')){
                                        singleQuery += '\''+criteriaValue+'%\'';
                                    }

                                    if(conCriteria.modigie__Operator__c.startsWith('n')){
                                    singleQuery += ')';
                                    }

                                }else{
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
                                        singleQuery += ' = ' + conCriteria.modigie__Field_Value__c;
                                    } else if(fieldType == 'DATETIME'){
                                        //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                        String d = conCriteria.modigie__Field_Value__c;//.split('-');
                                        //lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                        singleQuery += ' <= ' + d + 'T00:00:00Z OR ' + conCriteria.modigie__Field_Api_Name__c + ' >= ' + d +'T23:59:59Z )';//+ lstDateTime[lstDateTime.size()-1];//:lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                        //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                    } else if(fieldType == 'DATE'){
                                        //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                        String d = conCriteria.modigie__Field_Value__c;
                                        //lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                        singleQuery += ' != ' + d;//':lstDateTime[' +  (lstDateTime.size()-1) + ']';   
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
                        }else{
                            throw new RuleSetClassException('FieldApiName is not present!');
                        }
                        System.debug(String.valueOf(index)+' --> '+ singleQuery);
                        mapCriteriaQuery.put(index, singleQuery);
                        index++;
                    }
                    
                    //logicType can be of 1->'AND' 2->'OR' & 3->'CUSTOM'
                    //modigie__Modigie_Rule_Sets__c customLogic = [SELECT modigie__Contact_Logic_Type__c, modigie__Contact_Custom_Logic__c FROM modigie__Modigie_Rule_Sets__c WHERE Id = :ruleSetId LIMIT 1];
                    String subQuery = '';
                    String logicType;
                    List<String> pToken = new List<String>();
                    pToken.add('(');
                    pToken.add(')');
                    pToken.add('AND');
                    pToken.add('OR');
                    
                    //Fetch Logic Type
                    try{
                        Integer expression = Integer.valueOf(customLogic.modigie__Contact_Logic_Type__c);
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
                        String tempQuery = '(' + customLogic.modigie__Contact_Custom_Logic__c + ')';
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
                        }catch(Exception e){
                            subQuery = ' AND Id = Null';
                        }
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
                }else{
                    System.debug('Criteria Empty');
                    query = ' AND (Id = Null)';
                }
            }else if(objType == 'Lead'){
                
                //List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Lead__c WHERE modigie__Rule_Set_Id__c = :ruleSetId ORDER BY modigie__Field_Order__c];

                if(!lstLeadCriteria.isEmpty()){
                    List<DateTime> lstDateTime = new List<DateTime>();
                    List<Date> lstDate = new List<Date>();

                    if (
                        fieldApiNametoTypeMap.containsKey (
                        lstLeadCriteria[0].modigie__Field_Api_Name__c
                        )
                    ) {
                        query += ' AND (';
                    }
                    Map<Integer, String> mapCriteriaQuery = new Map<Integer, String>();
                    Integer index = 1;
                    for (
                        modigie__Modigie_Automation_Criteria_Lead__c ldCriteria : lstLeadCriteria
                    ) {
                        System.debug('33 --->> ' + ldCriteria);
                        String singleQuery = '';
                        if (
                        fieldApiNametoTypeMap.containsKey(
                            ldCriteria.modigie__Field_Api_Name__c
                        )
                        ) {
                            List<String> stringOperators = new List<String>{'ct', 'nct', 'sw', 'nsw', 'ew', 'new'};
                            if(stringOperators.contains(ldCriteria.modigie__Operator__c) && ldCriteria.modigie__Operator__c.startsWith('n')){
                                singleQuery += ' (NOT ';
                            }
                        String fieldType = fieldApiNametoTypeMap.get(
                            ldCriteria.modigie__Field_Api_Name__c
                        );
                        if(fieldType == 'DATETIME' && (ldCriteria.modigie__Operator__c == 'equals' || ldCriteria.modigie__Operator__c == 'notEquals')){
                            singleQuery += ' (';
                        }
                        singleQuery += ldCriteria.modigie__Field_Api_Name__c;
                        System.debug('Field Type -> '+ fieldType);
                        if (ldCriteria.modigie__Operator__c == 'null') {
                            if (ldCriteria.modigie__Field_Value__c == 'true') {
                            singleQuery += ' = null';
                            } else {
                            singleQuery += ' != null';
                            }
                        } else if (ldCriteria.modigie__Operator__c == 'gte') {
                            if (
                            fieldType == 'DATE' ||
                            fieldType == 'INTEGER' ||
                            fieldType == 'DOUBLE'
                            ) {
                            singleQuery += ' >= ' + ldCriteria.modigie__Field_Value__c;
                            } else if (fieldType == 'DATETIME') {
                            singleQuery +=
                                ' >= ' +
                                ldCriteria.modigie__Field_Value__c +
                                'T00:00:00Z';
                            }
                        } else if (ldCriteria.modigie__Operator__c == 'lte') {
                            if (
                            fieldType == 'DATE' ||
                            fieldType == 'INTEGER' ||
                            fieldType == 'DOUBLE'
                            ) {
                            singleQuery += ' <= ' + ldCriteria.modigie__Field_Value__c;
                            } else if (fieldType == 'DATETIME') {
                            singleQuery +=
                                ' <= ' +
                                ldCriteria.modigie__Field_Value__c +
                                'T23:59:59Z';
                            }
                        } else if (ldCriteria.modigie__Operator__c == 'gt') {
                            if (
                            fieldType == 'DATE' ||
                            fieldType == 'INTEGER' ||
                            fieldType == 'DOUBLE'
                            ) {
                            singleQuery += ' > ' + ldCriteria.modigie__Field_Value__c;
                            } else if (fieldType == 'DATETIME') {
                            singleQuery +=
                                ' > ' +
                                ldCriteria.modigie__Field_Value__c +
                                'T00:00:00Z';
                            }
                        } else if (ldCriteria.modigie__Operator__c == 'lt') {
                            if (
                            fieldType == 'DATE' ||
                            fieldType == 'INTEGER' ||
                            fieldType == 'DOUBLE'
                            ) {
                            singleQuery += ' < ' + ldCriteria.modigie__Field_Value__c;
                            } else if (fieldType == 'DATETIME') {
                            singleQuery +=
                                ' < ' +
                                ldCriteria.modigie__Field_Value__c +
                                'T00:00:00Z';
                            }
                        } else {
                            if (ldCriteria.modigie__Operator__c == 'equals') {
                                if (fieldType == 'PICKLIST') {
                                    String criteriaValue = ldCriteria.modigie__Field_Value__c;
                                    List<String> lstCriteriaValue = criteriaValue.split(',');
                                    singleQuery += ' IN (';

                                    for (String criteriaValueNode : lstCriteriaValue) {
                                    singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                                    }

                                    singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                                    singleQuery += ')';
                                } else if (fieldType == 'BOOLEAN') {
                                    if (ldCriteria.modigie__Field_Value__c == 'true') {
                                    singleQuery += ' = true';
                                    } else {
                                    singleQuery += ' = false';
                                    }
                                } else if(fieldType == 'DOUBLE' || fieldType == 'INTEGER'){
                                    singleQuery += ' = ' + ldCriteria.modigie__Field_Value__c;
                                } else if(fieldType == 'DATETIME'){
                                    //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                    String d = ldCriteria.modigie__Field_Value__c;//.split('-');
                                    //lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                    singleQuery += ' >= ' + d + 'T00:00:00Z AND ' + ldCriteria.modigie__Field_Api_Name__c + ' <= ' + d +'T23:59:59Z )';//+ lstDateTime[lstDateTime.size()-1];//:lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                    //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                } else if(fieldType == 'DATE'){
                                    //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                    String d = ldCriteria.modigie__Field_Value__c;
                                    //lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                    singleQuery += ' = ' + d;//':lstDateTime[' +  (lstDateTime.size()-1) + ']';   
                                } else {
                                    /* else if(fieldType == 'DOUBLE' || fieldType == 'INTEGER'){
                                                        singleQuery += ' = ' + ldCriteria.modigie__Field_Value__c;
                                                    }
                                                    else if(fieldType == 'DATETIME'){
                                                        List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                                        
                                                        lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                                        singleQuery += ' = :lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                                        //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                                    }
                                                    else if(fieldType == 'DATE'){
                                                        List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                                        lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                                        singleQuery += ' = :lstDateTime[' +  (lstDateTime.size()-1) + ']';   
                                                    }*/
                                    String criteriaValue = ldCriteria.modigie__Field_Value__c;
                                    List<String> lstCriteriaValue = criteriaValue.split(';;');
                                    singleQuery += ' IN (';

                                    for (String criteriaValueNode : lstCriteriaValue) {
                                    singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                                    }

                                    singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                                    singleQuery += ')';

                                    // singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                }
                            } else {
                                if(stringOperators.contains(ldCriteria.modigie__Operator__c)){
                                    singleQuery += ' LIKE ';
    
                                    String criteriaValue = ldCriteria.modigie__Field_Value__c;
                                    /*if(criteriaValue.contains('\\')){
                                        criteriaValue = criteriaValue.replace('\\', '\\\\');
                                    }
                                    if(criteriaValue.contains('\'')){
                                        criteriaValue = criteriaValue.replace('\'', '\\\'');
                                    }*/
                                    if(criteriaValue.contains('%')){
                                        criteriaValue = criteriaValue.replace('%', '\\%');
                                    }
                                    if(criteriaValue.contains('_')){
                                        criteriaValue = criteriaValue.replace('_', '\\_');
                                    }
                                    if(ldCriteria.modigie__Operator__c.contains('ct')){
                                        singleQuery += '\'%'+criteriaValue+'%\'';
                                    }else if(ldCriteria.modigie__Operator__c.contains('ew')){
                                        singleQuery += '\'%'+criteriaValue+'\'';
                                    }else if(ldCriteria.modigie__Operator__c.contains('sw')){
                                        singleQuery += '\''+criteriaValue+'%\'';
                                    }
    
                                    if(ldCriteria.modigie__Operator__c.startsWith('n')){
                                    singleQuery += ')';
                                    }
    
                                }else {
                                    if (fieldType == 'PICKLIST') {
                                        String criteriaValue = ldCriteria.modigie__Field_Value__c;
                                        List<String> lstCriteriaValue = criteriaValue.split(',');
                                        singleQuery += ' NOT IN (';

                                        for (String criteriaValueNode : lstCriteriaValue) {
                                        singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                                        }

                                        singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                                        singleQuery += ')';
                                    } else if (fieldType == 'BOOLEAN') {
                                        if (ldCriteria.modigie__Field_Value__c == 'true') {
                                        singleQuery += ' != true';
                                        } else {
                                        singleQuery += ' != false';
                                        }
                                    } else if (fieldType == 'DOUBLE' || fieldType == 'INTEGER') {
                                        singleQuery += ' != ' + ldCriteria.modigie__Field_Value__c;
                                    } else if(fieldType == 'DATETIME'){
                                        //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                        String d = ldCriteria.modigie__Field_Value__c;//.split('-');
                                        //lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                        singleQuery += ' <= ' + d + 'T00:00:00Z OR ' + ldCriteria.modigie__Field_Api_Name__c + ' >= ' + d +'T23:59:59Z )';//+ lstDateTime[lstDateTime.size()-1];//:lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                        //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                    } else if(fieldType == 'DATE'){
                                        //List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                        String d = ldCriteria.modigie__Field_Value__c;
                                        //lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                        singleQuery += ' != ' + d;//':lstDateTime[' +  (lstDateTime.size()-1) + ']';   
                                    } else {
                                        /*  else if(fieldType == 'DATETIME'){
                                                            List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                                            
                                                            lstDateTime.add(DateTime.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                                            singleQuery += ' != :lstDateTime[' +  (lstDateTime.size()-1) + ']';
                                                            //singleQuery += ' = \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                                        }
                                                        else if(fieldType == 'DATE'){
                                                            List<String> lstString = ldCriteria.modigie__Field_Value__c.split('-');
                                                            lstDateTime.add(Date.newInstance(Integer.valueOf(lstString[0]),Integer.valueOf(lstString[1]) , Integer.valueOf(lstString[2])));
                                                            singleQuery += ' != :lstDateTime[' +  (lstDateTime.size()-1) + ']';   
                                                        }*/
                                        String criteriaValue = ldCriteria.modigie__Field_Value__c;
                                        List<String> lstCriteriaValue = criteriaValue.split(';;');
                                        singleQuery += ' NOT IN (';

                                        for (String criteriaValueNode : lstCriteriaValue) {
                                        singleQuery += '\'' + criteriaValueNode.trim() + '\',';
                                        }

                                        singleQuery = singleQuery.substring(0, singleQuery.length() - 1);

                                        singleQuery += ')';
                                        //singleQuery += ' != \'' + ldCriteria.modigie__Field_Value__c + '\'';
                                    }
                                }
                            }
                        }
                    }else{
                        throw new RuleSetClassException('FieldApiName is not present!');
                    }
                        System.debug(String.valueOf(index)+' --> '+ singleQuery);
                        mapCriteriaQuery.put(index, singleQuery);
                        index++;
                    }
                    
                    //logicType can be of 1->'AND' 2->'OR' & 3->'CUSTOM'
                    //modigie__Modigie_Rule_Sets__c customLogic = [SELECT modigie__Lead_Logic_Type__c, modigie__Lead_Custom_Logic__c FROM modigie__Modigie_Rule_Sets__c WHERE Id = :ruleSetId LIMIT 1];
                    String subQuery = '';
                    String logicType;
                    List<String> pToken = new List<String>();
                    pToken.add('(');
                    pToken.add(')');
                    pToken.add('AND');
                    pToken.add('OR');
                    
                    //Fetch Logic Type
                    try{
                        Integer expression = Integer.valueOf(customLogic.modigie__Lead_Logic_Type__c);
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
                        String tempQuery = '(' + customLogic.modigie__Lead_Custom_Logic__c + ')';
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
                        lstLeadCriteria[0].modigie__Field_Api_Name__c
                        )
                    ) {
                        query += subQuery+')';
                    }
                }else{
                    System.debug('Criteria Empty');
                    query = ' AND (Id = Null)';
                }
            }else{
                //throw error
                throw new RuleSetClassException('objType can be only Lead/Contact!');
            }
            System.debug('Query-->'+query);
            return query;
        } catch (Exception e) {
            EmailServiceClass.sendErrorEmail('RuleSetClass Error', e);
            return ' AND (Id = Null)';
        }
    }

    /**
     * sEPERATOR
     */

    @AuraEnabled
    public static Integer getCurrentQueue(String ruleSetId){
        Integer currentQueue = 0;
        try {
            String countQuery = 'SELECT Count(Id) total FROM modigie__Modigie__c WHERE modigie__Rule_Set_Id__c = :ruleSetId AND modigie__Status__c = \'In queue\'';
            AggregateResult aRCount = database.query(countQuery);
            currentQueue = (Integer)aRCount.get('total');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return currentQueue;
    }

    @AuraEnabled
    public static Map<String, Object> getAnalysis(String ruleSetId){
        Map<String, Object> resultMap = new Map<String, Object>();
        try {
            /**
             * If RuleSetId is blank, call a default ruleset create method
             */
            /**
            * List of Object
            map lead, #; contact, #
            map lead, records userId, Name, #; contact, records userId, Name, # //All User
            map lead, records userId, Name, #; userId, Name, # //Only Automation User
            OR
            map lead, records userId, Name, #, isAutomation; map lead, userId, Name, #, isAutomation
            */
            List<modigie__Modigie_Rule_Sets__c> mrs = [SELECT modigie__OnlyOnCreate__c FROM modigie__Modigie_Rule_Sets__c WHERE Id = :ruleSetId];
            if(mrs.isEmpty()){
                //throw error
                return resultMap;
            }

            String modigieAU = [SELECT Id FROM PermissionSet WHERE NameSpacePrefix = 'modigie' AND Label = 'Modigie Automation User' LIMIT 1].Id;
            List<PermissionSetAssignment> psaList = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :modigieAU];
            List<String> userList = new List<String>();
            for(PermissionSetAssignment psa : psaList){
                userList.add((String) psa.AssigneeId);
            }
            System.debug(userList);

            Integer anticipatedCall = 0;
            List<String> objList = new List<String> {'Lead', 'Contact'};
            for(String objType: objList){
                String dateField = 'LastModified';
                if(mrs[0].modigie__OnlyOnCreate__c == true){
                    dateField = 'Created';
                }
                String subQuery = 'Count(Id) total FROM ' + objType + ' WHERE (' + dateField + 'Date = LAST_N_DAYS:30)' + GetRuleSetSubQuery(ruleSetId, objType);
                String countQuery = 'SELECT ' + subQuery;

                AggregateResult aRCount = database.query(countQuery);

                //1st and 3rd Item
                resultMap.put(objType+'-Count', aRCount.get('total'));

                String allUserQuery = 'SELECT '+ dateField + 'ById userId, ' + dateField + 'By.Name userName, '+subQuery+' GROUP BY ' + dateField + 'ById, ' + dateField + 'By.Name ORDER BY Count(Id) DESC LIMIT 25';
                System.debug('all-->'+allUserQuery);
                List<AggregateResult> aRs = database.query(allUserQuery);
                List<queryRecord> sObjUserList = new List<queryRecord>();
                System.debug('aRs-->'+aRs);
                for(AggregateResult aR : aRs){
                    Boolean isModigieAU = false;
                    if(userList.contains((String)aR.get('userId'))){
                        isModigieAU = true;
                        anticipatedCall += (Integer)aR.get('total');
                    }
                    sObjUserList.add(new queryRecord((String)aR.get('userId'), (String)aR.get('userName'), (Integer)aR.get('total'), isModigieAU));
                    System.debug('aR-->'+aR);   
                }
                //2nd and 4th Item
                resultMap.put(objType+'-User', sObjUserList);
            }
            resultMap.put('Acticipated-Call', Math.ceil(((Decimal)anticipatedCall)/30));
        } catch (Exception e) {
            System.debug(e.getMessage() + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        return resultMap;
    }

    @AuraEnabled
    public static Map<String, Object> getAnalysisPreSave(List<List<Map<String,String>>> criteriaData, List<String> logicCriteria, Boolean onlyCreate){
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            List<modigie__Modigie_Automation_Criteria_Lead__c> analysisCriteriaLead = new List<modigie__Modigie_Automation_Criteria_Lead__c>();
            
            if(!criteriaData[0].isEmpty()){
                Integer i = 0;
                for(Map<String,String> leadCriteria : criteriaData[0]){
                    analysisCriteriaLead.add(new modigie__Modigie_Automation_Criteria_Lead__c(modigie__Field_Order__c = i, modigie__Field_Value__c = leadCriteria.get('CriteriaValue'), modigie__Operator__c = leadCriteria.get('SelectedOperator'),modigie__Field_Api_Name__c = leadCriteria.get('SelectedField')));
                    i++;
                }
            }
            
            List<modigie__Modigie_Automation_Criteria_Contact__c> analysisCriteriaCon = new List<modigie__Modigie_Automation_Criteria_Contact__c>();
            
            if(!criteriaData[1].isEmpty()){
                Integer i = 0;
                for(Map<String,String> conCriteria : criteriaData[1]){
                    analysisCriteriaCon.add(new modigie__Modigie_Automation_Criteria_Contact__c(modigie__Field_Order__c = i, modigie__Field_Value__c = conCriteria.get('CriteriaValue'), modigie__Operator__c = conCriteria.get('SelectedOperator'),modigie__Field_Api_Name__c = conCriteria.get('SelectedField')));
                    i++;
                }
            }

            modigie__Modigie_Rule_Sets__c mRS = new modigie__Modigie_Rule_Sets__c();
            
            mRS.modigie__Lead_Logic_Type__c = Integer.valueOf(logicCriteria[0]);
            mRS.modigie__Lead_Custom_Logic__c = logicCriteria[1];
            mRS.modigie__Contact_Logic_Type__c = Integer.valueOf(logicCriteria[2]);
            mRS.modigie__Contact_Custom_Logic__c = logicCriteria[3];

            String modigieAU = [SELECT Id FROM PermissionSet WHERE NameSpacePrefix = 'modigie' AND Label = 'Modigie Automation User' LIMIT 1].Id;
            List<PermissionSetAssignment> psaList = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :modigieAU];
            List<String> userList = new List<String>();
            for(PermissionSetAssignment psa : psaList){
                userList.add((String) psa.AssigneeId);
            }
            System.debug(userList);

            Integer anticipatedCall = 0;
            List<String> objList = new List<String> {'Lead', 'Contact'};
            for(String objType: objList){
                String dateField = 'LastModified';
                if(onlyCreate){
                    dateField = 'Created';
                }

                String ruleSetSubQuery = ' AND Id = NULL';
                if(objType == 'Lead'){
                    ruleSetSubQuery = GetRuleSetSubQueryNoId(analysisCriteriaCon, analysisCriteriaLead, mRS, objType);
                }else{
                    ruleSetSubQuery = GetRuleSetSubQueryNoId(analysisCriteriaCon, analysisCriteriaLead, mRS, objType);
                }
                String subQuery = 'Count(Id) total FROM ' + objType + ' WHERE (' + dateField + 'Date = LAST_N_DAYS:30)' + ruleSetSubQuery;
                String countQuery = 'SELECT ' + subQuery;
                System.debug('Analysis Query->'+countQuery);

                AggregateResult aRCount = database.query(countQuery);

                //1st and 3rd Item
                resultMap.put(objType+'-Count', aRCount.get('total'));

                String allUserQuery = 'SELECT ' + dateField + 'ById userId, ' + dateField + 'By.Name userName, ' + subQuery + ' GROUP BY ' + dateField + 'ById, ' + dateField + 'By.Name ORDER BY Count(Id) DESC LIMIT 25';
                System.debug('all-->'+allUserQuery);
                List<AggregateResult> aRs = database.query(allUserQuery);
                List<queryRecord> sObjUserList = new List<queryRecord>();
                System.debug('aRs-->'+aRs);
                for(AggregateResult aR : aRs){
                    Boolean isModigieAU = false;
                    if(userList.contains((String)aR.get('userId'))){
                        isModigieAU = true;
                        anticipatedCall += (Integer)aR.get('total');
                    }
                    sObjUserList.add(new queryRecord((String)aR.get('userId'), (String)aR.get('userName'), (Integer)aR.get('total'), isModigieAU));
                    System.debug('aR-->'+aR);   
                }
                //2nd and 4th Item
                resultMap.put(objType+'-User', sObjUserList);
            }
            resultMap.put('Acticipated-Call', Math.ceil(((Decimal)anticipatedCall)/30));
        } catch (Exception e) {
            System.debug(e.getMessage() + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        return resultMap;
    }

    public class QueryRecord{
        /**
         * Used as custom Object for pre-Analysis of Rule Set
         */
        @AuraEnabled
        public String userId;
        @AuraEnabled
        public String userName;
        @AuraEnabled
        public Integer total;
        @AuraEnabled
        public Boolean isAutomation;
        
        public QueryRecord(String uId, String uN, Integer ttl, Boolean mAU){
            userId = uId;
            userName = uN;
            total = ttl;
            isAutomation = mAU;
        }
    }

    private class RuleSetClassException extends Exception{}
}