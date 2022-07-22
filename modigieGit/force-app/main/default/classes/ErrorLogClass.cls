public class ErrorLogClass {

    public ErrorLogClass() {
        //no use
    }
    
    public static void createErrorLog(List<sObject> listObject, String sObjectFieldId, List<Database.UpsertResult> saveResults, String jobType, String jobSource){
        try{
            Integer totalFailed = 0;
            Integer totalSize = saveResults.size();
            String recordErrors = '';
            Integer index = 0;
            for(Database.UpsertResult sR : saveResults){
                String singleRecordError = ' - ';
                if(!sR.isSuccess()) {
                    for(Database.Error er : sR.getErrors()) {
                        singleRecordError += er.getMessage()+', '; 
                    }
                    totalFailed += 1;
                    //sObject Field Id is for matching against failed record
                    Id matchingId = (Id)listObject[index].get(sObjectFieldId);
                    recordErrors +=  matchingId + singleRecordError + ' ; ';
                }
                index++;
            }
            if(FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') 
                && FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Description__c') 
                && FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Modigie_Service__c') 
                && FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Validation_Key__c') 
            ){
                modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
                String tempDescription = jobSource + ' : Record Failed ' + totalFailed + '/' + totalSize + ' = {' + recordErrors + '}';
                if(tempDescription != null){
                    Integer lastIndex = 32767;
                    if(tempDescription.length() < lastIndex){
                        lastIndex = tempDescription.length() - 1;
                    }
                    tempDescription = tempDescription.subString(4, lastIndex);
                }
                modigieErrorLog.modigie__Description__c = tempDescription;
                modigieErrorLog.modigie__Modigie_Service__c = jobType;
                modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                if(totalFailed > 0)
                    insert modigieErrorLog;
            }
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('ErrorLogClass Error', e);
        }
    }

    public static void createErrorLog(List<sObject> listObject, String sObjectFieldId, List<Database.SaveResult> saveResults, String jobType, String jobSource){
        try{
            Integer totalFailed = 0;
            Integer totalSize = saveResults.size();
            String recordErrors = '';
            Integer index = 0;
            for(Database.SaveResult sR : saveResults){
                String singleRecordError = ' - ';
                if(!sR.isSuccess()) {
                    for(Database.Error er : sR.getErrors()) {
                        singleRecordError += er.getMessage()+', '; 
                    }
                    totalFailed += 1;
                    //sObject Field Id is for matching against failed record
                    Id matchingId = (Id)listObject[index].get(sObjectFieldId);
                    recordErrors +=  matchingId + singleRecordError + ' ; ';
                }
                index++;
            }
            if(FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') 
                && FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Description__c') 
                && FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Modigie_Service__c') 
                && FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Validation_Key__c') 
            ){
                modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
                String tempDescription = jobSource + ' : Record Failed ' + totalFailed + '/' + totalSize + ' = {' + recordErrors + '}';
                if(tempDescription != null){
                    Integer lastIndex = 32767;
                    if(tempDescription.length() < lastIndex){
                        lastIndex = tempDescription.length() - 1;
                    }
                    tempDescription = tempDescription.subString(4, lastIndex);
                }
                modigieErrorLog.modigie__Description__c = tempDescription;
                modigieErrorLog.modigie__Modigie_Service__c = jobType;
                modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                if(totalFailed > 0)
                    insert modigieErrorLog;
            }
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('ErrorLogClass Error', e);
        }
    }

    public static void createErrorLog(List<sObject> listObject, String sObjectFieldId, List<Database.DeleteResult> delResults, String jobType, String jobSource){
        try{
            Integer totalFailed = 0;
            Integer totalSize = delResults.size();
            String recordErrors = '';
            Integer index = 0;
            for(Database.DeleteResult sR : delResults){
                String singleRecordError = ' - ';
                if(!sR.isSuccess()) {
                    for(Database.Error er : sR.getErrors()) {
                        singleRecordError += er.getMessage()+' from Affected Field ' + er.getFields() + ', '; 
                    }
                    totalFailed += 1;
                    //sObject Field Id is for matching against failed record
                    Id matchingId = (Id)listObject[index].get(sObjectFieldId);
                    recordErrors +=  matchingId + singleRecordError + ' ; ';
                }
                index++;
            }
            if(FieldLevelSecurityCheck.canCreateObject('modigie__Error_Log__c') 
                && FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Description__c') 
                && FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Modigie_Service__c') 
                && FieldLevelSecurityCheck.canCreateField('modigie__Error_Log__c', 'modigie__Validation_Key__c') 
            ){
                modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
                String tempDescription = jobSource + ' : Record Failed ' + totalFailed + '/' + totalSize + ' = {' + recordErrors + '}';
                if(tempDescription != null){
                    Integer lastIndex = 32767;
                    if(tempDescription.length() < lastIndex){
                        lastIndex = tempDescription.length() - 1;
                    }
                    tempDescription = tempDescription.subString(4, lastIndex);
                }
                modigieErrorLog.modigie__Description__c = tempDescription;
                modigieErrorLog.modigie__Modigie_Service__c = jobType;
                modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                if(totalFailed > 0)
                    insert modigieErrorLog;
            }
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('ErrorLogClass Error', e);
        }
    }
}