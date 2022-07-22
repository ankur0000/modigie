@isTest
private class ModigieBatchClassErrorResetTest {
	 @testSetup 
    static void setup() {
    	List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = new List<modigie__Modigie_Batch_Class_Internal_Error_List__c>();
        for(Integer i = 1; i <= 10; i++){
            lstBatchClassError.add(new modigie__Modigie_Batch_Class_Internal_Error_List__c(name=String.valueOf(i), modigie__Error_Message__c = 'Sample Error Message' + i));
        }
        insert lstBatchClassError;
        
        System.assertEquals(10,lstBatchClassError.size());
    }
    @isTest
    static void unitTest1(){
       
               
        
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        ModigieBatchClassErrorReset SC = new ModigieBatchClassErrorReset(); 
        Id jobId = System.schedule('Modigie batch class errors reset', sched, SC);
        Test.stopTest();
        System.assert(jobId != null);
    }
}