/************************************************************************ 
@Authors Rikky Malviya
@Date    25 feb 2022
@Name    TOMunTOMBatchClass
@Description Batch Class to run Automation for TOM and unTOM
***********************************************************************/
public with sharing class TOMunTOMBatchClass implements Database.Batchable<sObject>, Database.Stateful {
    String objType;
    Integer revertDateInDays = null;
    
    List<String> to = new List<String>{'modigie__TOM_Priority_Mobile_1__c', 'modigie__TOM_Priority_Mobile_2__c', 'modigie__TOM_Priority_Mobile_3__c'};
    List<String> toE164 = new List<String>{'modigie__TOM_Priority_Map_To_Dialer_1__c', 'modigie__TOM_Priority_Map_To_Dialer_2__c', 'modigie__TOM_Priority_Map_To_Dialer_3__c'};

    List<Id> allListId = new List<Id>();

    List<String> tomFields = new List<String>();
    List<String> unTomFields = new List<String>();
    List<Id> forTOM = new List<Id>();
    //Map<Id, sObject> forUnTOM = new Map<Id, sObject>();

    public TOMunTOMBatchClass(List<Id> paramLstIds, String paramObjType) {
        objType = paramObjType;
        allListId = new List<Id>(paramLstIds);
    }

    public database.QueryLocator start(Database.BatchableContext bc) {
        Set<Id> setIds = new Set<Id>(allListId);

        //forTOM records and forUnTOM records fetch, 26-Feb, only fetch forTOM.
        String qry = 'SELECT Id FROM ' + objType;
        List<modigie__TOM_Criteria__c> tomCriteriaList = [SELECT Id, modigie__revertDateIn__c FROM modigie__TOM_Criteria__c WHERE modigie__isTom__c = true];
        if(!tomCriteriaList.isEmpty()){
            if(tomCriteriaList[0].modigie__revertDateIn__c != null){
                if(tomCriteriaList[0].modigie__revertDateIn__c > 0){
                    revertDateInDays = (Integer)tomCriteriaList[0].modigie__revertDateIn__c;
                }
            }
            qry += '  WHERE Id In :setIds';
            qry += RuleSetClass.GetRuleSetSubQuery(tomCriteriaList[0].Id, objType);
            //To prevent any unTOM from updating TOM records, when Criteria is empty or any fls error
            if(qry.contains('AND (Id = Null)')){
                qry = 'SELECT Id FROM Lead WHERE Id = Null';
                return database.getQueryLocator(qry);
            }
        }else{
            qry += ' WHERE Id = Null';
        }
        //If TOM is null due to error, don't run TOM
        System.debug('To TOM Query-> '+qry+'; allListId : '+setIds);
        Map<Id, sObject> resultMap = new Map<Id, sObject>(Database.query(qry));
        forTOM.addAll(resultMap.keySet());

        //fresh qry, scope
        qry = '';
        String TOMFieldName;
        String unTOMFieldName;
        try{
            qry += 'SELECT Id, ';
            if(objType == 'Lead'){
                TOMFieldName = 'modigie__Lead_Priority_';
                unTOMFieldName = 'modigie__Lead_Reset_Priority_';
            }else if(objType == 'Contact'){
                TOMFieldName = 'modigie__Contact_Priority_';
                unTOMFieldName = 'modigie__Contact_Reset_Priority_';
            }else{
                throw new TOMunTOMBatchClassException('objType can be only Lead/Contact!');
            }
            
            //fetch TOM.
            modigie__TOM__c tom = modigie__TOM__c.getInstance();

            //tomFields
            if((String)tom.get(TOMFieldName + '1__c') != null && (String)tom.get(TOMFieldName + '1__c') != ''){
                tomFields.add((String)tom.get(TOMFieldName + '1__c'));
            }
            if((String)tom.get(TOMFieldName + '2__c') != null && (String)tom.get(TOMFieldName + '2__c') != ''){
                tomFields.add((String)tom.get(TOMFieldName + '2__c'));
            }
            if((String)tom.get(TOMFieldName + '3__c') != null && (String)tom.get(TOMFieldName + '3__c') != ''){
                tomFields.add((String)tom.get(TOMFieldName + '3__c'));
            }
            if((String)tom.get(TOMFieldName + '4__c') != null && (String)tom.get(TOMFieldName + '4__c') != ''){
                tomFields.add((String)tom.get(TOMFieldName + '4__c'));
            }
            if((String)tom.get(TOMFieldName + '5__c') != null && (String)tom.get(TOMFieldName + '5__c') != ''){
                tomFields.add((String)tom.get(TOMFieldName + '5__c'));
            }
            if((String)tom.get(TOMFieldName + '6__c') != null && (String)tom.get(TOMFieldName + '6__c') != ''){
                tomFields.add((String)tom.get(TOMFieldName + '6__c'));
            }

            //unTomFields
            if((String)tom.get(unTOMFieldName + '1__c')!= null && (String)tom.get(unTOMFieldName + '1__c') != ''){
                unTomFields.add((String)tom.get(unTOMFieldName + '1__c'));
            }
            if((String)tom.get(unTOMFieldName + '2__c')!= null && (String)tom.get(unTOMFieldName + '2__c') != ''){
                unTomFields.add((String)tom.get(unTOMFieldName + '2__c'));
            }
            if((String)tom.get(unTOMFieldName + '3__c')!= null && (String)tom.get(unTOMFieldName + '3__c') != ''){
                unTomFields.add((String)tom.get(unTOMFieldName + '3__c'));
            }

            Set<String> allFieldsInBoth = new Set<String>(tomFields);
            allFieldsInBoth.addAll(unTomFields);
            Boolean checkDynamicFlsTom = false;
            for(String field: allFieldsInBoth){
                //System.debug(objType+field);
                qry+= field + ', ';
                if(FieldLevelSecurityCheck.canReadField(objType, field) && 
                    FieldLevelSecurityCheck.canUpdateField(objType, field))
                {
                    checkDynamicFlsTom = true;
                }else{
                    checkDynamicFlsTom = false;
                    break;
                }
            }
            if(!checkDynamicFlsTom  
                && FieldLevelSecurityCheck.canReadField(objType, 'modigie__Tom_Date__c') 
                && FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__Tom_Date__c') 
                && FieldLevelSecurityCheck.canReadField(objType, 'modigie__Is_Dynamic_Criteria_Field_Values_Changed__c'))
            {
                if(!Test.isRunningTest()){
                    throw new TOMunTOMBatchClassException('Warning! - User has missing Field Permission, there might be data discrepancy. User: ' + UserInfo.getUserId());
                }
            }

            qry += 'modigie__TOM_Priority_Mobile_1__c, modigie__TOM_Priority_Mobile_2__c, modigie__TOM_Priority_Mobile_3__c, modigie__TOM_Priority_Map_To_Dialer_1__c, modigie__TOM_Priority_Map_To_Dialer_2__c, modigie__TOM_Priority_Map_To_Dialer_3__c, modigie__Tom_Date__c, modigie__Is_Dynamic_Criteria_Field_Values_Changed__c FROM ' + objType + ' WHERE Id = :setIds';
        }catch(Exception e){
            qry = 'SELECT Id FROM Lead WHERE Id = Null';
            EmailServiceClass.sendErrorEmail('TOMunTOMBatchClass Error', e);
        }
        return database.getQueryLocator(qry);
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        try{
            List<sObject> toUpdateRecords = new List<sObject>();
            Boolean flsCheck = Check(objType);
            String actionType = 'TOM/UNTOM';
            
            if(flsCheck){
                for(sObject objRec: scope){
                    Boolean needToUpdate = false;
                    Id objRecId = (Id)objRec.get('Id');
                    List<String> fromList = new List<String>();
                    Integer iterateCount = 0;
                    Boolean doTom = true;
                    Boolean doUnTom = false;

                    if(forTOM.contains(objRecId)){
                        if(revertDateInDays != null){
                            if((Date)objRec.get('modigie__Tom_Date__c') != null){
                                Date objTomDate = (Date)objRec.get('modigie__Tom_Date__c');
                                objTomDate = objTomDate.addDays(revertDateInDays);
                                //Datetime objTomDateFormated = Datetime.newInstance(objTomDate.year(), objTomDate.month(), objTomDate.day());
                                Date sysToday = System.today();
                                //Datetime sysTodayFormated = Datetime.newInstance(sysToday.year(), sysToday.month(), sysToday.day());
                                if(sysToday > objTomDate){
                                    System.debug('sysToday > objTomDate ' + sysToday +' > '+ objTomDate + ' ' +(sysToday > objTomDate));
                                    if(!(Boolean)objRec.get('modigie__Is_Dynamic_Criteria_Field_Values_Changed__c')){
                                        //unTom
                                        System.debug('Do Untom Here!!!!');
                                        doTom = false;
                                        doUnTom = true;
                                    }//else{
                                        //tom
                                    //}
                                }//else{
                                    //tom
                                //}
                            }//else{
                                //tom
                            //}
                        }//else{
                            //tom
                        //}
                    }else{
                        doTom = false;
                        doUnTom = true;
                    }
                    if(doTom){
                        for(String field : tomFields){
                            String tempPhone = (String)objRec.get(field);
                            if(tempPhone != null && tempPhone != ''){
                                fromList.add(tempPhone);
                            }
                        }
    
                        System.debug('fromList -> '+ fromList);
                        
                        for(String tempPhone : fromList) {
                            String tempPhoneField = (String)objRec.get(to[iterateCount]);
                            if(tempPhone != tempPhoneField && !((tempPhone == null && tempPhoneField == '') || (tempPhone == '' && tempPhoneField == null))) {
                                needToUpdate = true;
                                objRec.put(to[iterateCount], tempPhone);
                                String tempPhoneE164 = returnE164Format(tempPhone);
                                objRec.put(toE164[iterateCount], tempPhoneE164);
                            }
                            if(iterateCount == 2) {
                                break;
                            }
                            iterateCount++;
                        }
                        Integer reduceCount = 2;
                        
                        while(reduceCount >= fromList.size()) {
                            String tomFieldValue = (String)objRec.get(to[reduceCount]);
                            if(tomFieldValue != null && tomFieldValue != ''){
                                needToUpdate = true;
                                objRec.put(to[reduceCount], '');
                                objRec.put(toE164[reduceCount], '');
                            }
                            reduceCount--;
                        }
                    }
                    if(doUnTom){
                        for(String field : unTomFields){
                            String tempPhone = (String)objRec.get(field);
                            if(tempPhone != null && tempPhone != ''){
                                fromList.add(tempPhone);
                            }
                        }
    
                        System.debug('fromList -> '+ fromList);
                        
                        for(String tempPhone : fromList) {
                            String tempPhoneField = (String)objRec.get(to[iterateCount]);
                            if(tempPhone != tempPhoneField && !((tempPhone == null && tempPhoneField == '') || (tempPhone == '' && tempPhoneField == null))) {
                                needToUpdate = true;
                                objRec.put(to[iterateCount], tempPhone); 
                                String tempPhoneE164 = returnE164Format(tempPhone);
                                objRec.put(toE164[iterateCount], tempPhoneE164);
                            }
                            iterateCount++;
                        }
                        Integer reduceCount = 2;
                        
                        while(reduceCount >= fromList.size()) {
                            String tomFieldValue = (String)objRec.get(to[reduceCount]);
                            if(tomFieldValue != null && tomFieldValue != ''){
                                needToUpdate = true;
                                objRec.put(to[reduceCount], '');
                                objRec.put(toE164[reduceCount], '');
                            }
                            reduceCount--;
                        }
                    }

                    if(needToUpdate){
                        if(objType == 'Lead'){
                            Lead tempS = new Lead(Id = objRecId);
                            tempS.modigie__TOM_Priority_Mobile_1__c = (String)objRec.get('modigie__TOM_Priority_Mobile_1__c');
                            tempS.modigie__TOM_Priority_Mobile_2__c = (String)objRec.get('modigie__TOM_Priority_Mobile_2__c');
                            tempS.modigie__TOM_Priority_Mobile_3__c = (String)objRec.get('modigie__TOM_Priority_Mobile_3__c');
                            tempS.modigie__TOM_Priority_Map_To_Dialer_1__c = (String)objRec.get('modigie__TOM_Priority_Map_To_Dialer_1__c');
                            tempS.modigie__TOM_Priority_Map_To_Dialer_2__c = (String)objRec.get('modigie__TOM_Priority_Map_To_Dialer_2__c');
                            tempS.modigie__TOM_Priority_Map_To_Dialer_3__c = (String)objRec.get('modigie__TOM_Priority_Map_To_Dialer_3__c');
                            if(doTom){
                                tempS.modigie__Tom_Date__c = System.today();
                            }
                            toUpdateRecords.add(tempS);
                        }else if(objType == 'Contact'){
                            Contact tempS = new Contact(Id = objRecId);
                            tempS.modigie__TOM_Priority_Mobile_1__c = (String)objRec.get('modigie__TOM_Priority_Mobile_1__c');
                            tempS.modigie__TOM_Priority_Mobile_2__c = (String)objRec.get('modigie__TOM_Priority_Mobile_2__c');
                            tempS.modigie__TOM_Priority_Mobile_3__c = (String)objRec.get('modigie__TOM_Priority_Mobile_3__c');
                            tempS.modigie__TOM_Priority_Map_To_Dialer_1__c = (String)objRec.get('modigie__TOM_Priority_Map_To_Dialer_1__c');
                            tempS.modigie__TOM_Priority_Map_To_Dialer_2__c = (String)objRec.get('modigie__TOM_Priority_Map_To_Dialer_2__c');
                            tempS.modigie__TOM_Priority_Map_To_Dialer_3__c = (String)objRec.get('modigie__TOM_Priority_Map_To_Dialer_3__c');
                            if(doTom){
                                tempS.modigie__Tom_Date__c = System.today();
                            }
                            toUpdateRecords.add(tempS);
                        }
                    }

                }

                if(!toUpdateRecords.isEmpty()){
                    System.debug('Updating records to reflect TOM.');
                    ModigieStaticReferenceHelper.isTOMunTOMBatchClassRunning = true;
                    Database.SaveResult[] saveResults = Database.update(toUpdateRecords);
                    ErrorLogClass.createErrorLog(toUpdateRecords, 'Id', saveResults, null, actionType);
                }

            }else{
                if(!Test.isRunningTest()){
                    throw new TOMunTOMBatchClassException('Warning! - User has missing Field Permission, there might be data discrepancy. User: ' + UserInfo.getUserId());
                }
            }
        }catch(Exception e){
           EmailServiceClass.sendErrorEmail('TOMunTOMBatchClass Error', e); 
        }
    }

    public void finish(Database.BatchableContext bc) {
        //
    }

    private class TOMunTOMBatchClassException extends Exception{}

    public static Boolean Check(String objType){
        if( FieldLevelSecurityCheck.canReadObject(objType) 
        && FieldLevelSecurityCheck.canCreateObject(objType) 
        && FieldLevelSecurityCheck.canUpdateObject(objType) 
        && FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Mobile_1__c') 
        && FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Mobile_1__c') 
        && FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Mobile_2__c') 
        && FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Mobile_2__c') 
        && FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Mobile_3__c') 
        && FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Mobile_3__c') 
        && FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Map_To_Dialer_1__c') 
        && FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Map_To_Dialer_1__c') 
        && FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Map_To_Dialer_2__c') 
        && FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Map_To_Dialer_2__c') 
        && FieldLevelSecurityCheck.canReadField(objType, 'modigie__TOM_Priority_Map_To_Dialer_3__c') 
        && FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__TOM_Priority_Map_To_Dialer_3__c') 
        && FieldLevelSecurityCheck.canReadField(objType, 'modigie__Tom_Date__c') 
        && FieldLevelSecurityCheck.canUpdateField(objType, 'modigie__Tom_Date__c') 
        && FieldLevelSecurityCheck.canReadField(objType, 'modigie__Is_Dynamic_Criteria_Field_Values_Changed__c') ) {
            return true;
        }
        return false;
    }

    public static String returnE164Format(String tempPhone){
        String pattern = '[^0-9]';
        //for extension copy and append later
        tempPhone = tempPhone.toLowerCase();
        Boolean containsPlus = tempPhone.startsWith('+') ? true : false;
        String patternExt = 'ext';
        String patternX = 'x';
        String newTempPhone = '';
        Integer patternIndex = -1;
        String extension; 
        String extNumber;
        if(tempPhone.contains(patternExt)){
            patternIndex = tempPhone.lastIndexOf(patternExt);
            if(patternIndex > 0){
                newTempPhone = tempPhone.subString(0, patternIndex);
                extension = tempPhone.subStringAfter(newTempPhone);
                extNumber = extension.replaceAll(pattern, '');
                newTempPhone = newTempPhone.replaceAll(pattern, '');
                if(extNumber != ''){
                    newTempPhone += ';ext=' + extNumber;
                }
            }
        }else if(tempPhone.contains(patternX)){
            patternIndex = tempPhone.lastIndexOf(patternX);
            if(patternIndex > 0){
                newTempPhone = tempPhone.subString(0, patternIndex);
                extension = tempPhone.subStringAfter(newTempPhone);
                extNumber = extension.replaceAll(pattern, '');
                newTempPhone = newTempPhone.replaceAll(pattern, '');
                if(extNumber != ''){
                    newTempPhone += ';ext=' + extNumber;
                }
            }
        }else{
            newTempPhone = tempPhone.replaceAll(pattern, '');
        }
        if(newTempPhone.startsWith('1') || containsPlus){
            newTempPhone = '+' + newTempPhone;
        }else{
            newTempPhone = '+1' + newTempPhone;
        }
        return newTempPhone;
    }

}