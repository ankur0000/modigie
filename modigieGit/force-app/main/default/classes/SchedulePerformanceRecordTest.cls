@isTest
public class SchedulePerformanceRecordTest 
{
    @isTest
    public static void test()
    {
        Time timeChange = Time.newInstance(11,12,12,0); 
        Time timeChange1 = Time.newInstance(11,13,12,0); 
        modigie__Modigie__c mm = new modigie__Modigie__c();
        mm.modigie__Status__c = 'Validated';
        mm.modigie__Job_start__c = timeChange;   
        mm.modigie__Job_end__c = timeChange1;
        mm.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        insert mm;
        System.assert(mm.Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
       
        String CRON_EXP = '0 0 0 3 9 ? 2022';
       // Schedule the test job
        Test.setCreatedDate(mm.Id,date.today());
        test.startTest();
        String jobId = System.schedule('BorrarAseguradosTest', CRON_EXP, new SchedulePerformanceRecord());
        test.stopTest();
    }

}