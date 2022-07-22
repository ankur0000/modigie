global class ModigieBatchClassErrorReset implements Database.Batchable<sObject>, Schedulable{
	global Database.QueryLocator start(Database.BatchableContext bc) {
    	return Database.getQueryLocator('SELECT Id FROM modigie__Modigie_Batch_Class_Internal_Error_List__c WITH SECURITY_ENFORCED');
    }
    global void execute(Database.BatchableContext bc, List<modigie__Modigie_Batch_Class_Internal_Error_List__c> scope){
   		if(FieldLevelSecurityCheck.canDeleteObject('modigie__Modigie_Batch_Class_Internal_Error_List__c')){
            delete scope;
        }
    }
    global void finish(Database.BatchableContext bc){
        try{
            String message = 'EmailLog-%';
            List<modigie__Error_Log__c> modiErrorLogList = [SELECT Id FROM modigie__Error_Log__c WHERE modigie__Job_Id__c LIKE :message];
            if(FieldLevelSecurityCheck.canDeleteObject('modigie__Error_Log__c')){
                delete modiErrorLogList;
            }
        }catch(Exception exc){
            EmailServiceClass.sendErrorEmail('ModigieBatchClassErrorReset Error', exc);
        }
    }
    global void execute(SchedulableContext sc){
        Database.executeBatch(new ModigieBatchClassErrorReset());
    }
}