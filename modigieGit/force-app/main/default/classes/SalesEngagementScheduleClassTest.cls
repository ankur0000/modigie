@isTest
public class SalesEngagementScheduleClassTest {
    @isTest
    public static void callingTestBothType() {
        RuleSetFactoryTest.insertUseCase('Use Case 1');
		RuleSetFactoryTest.createQueue('Use Case 1', 'both');
        Datetime timeToSchedule = System.now().addMinutes(2);
        String tempCronExpresstion = timeToSchedule.second() + ' ' + timeToSchedule.minute() + ' ' + timeToSchedule.hour() + ' ' + timeToSchedule.day() + ' ' + timeToSchedule.month() + ' ? ' + timeToSchedule.year();
        Id jobId = System.schedule('Get Modigie for Queue Test', tempCronExpresstion, new SalesEngagementScheduleClass());
        System.assert(jobId != null);
    }
    @isTest
    public static void callingTestLeadType() {
        RuleSetFactoryTest.insertUseCase('Use Case 1');
		RuleSetFactoryTest.createQueue('Use Case 1', 'Lead');
        Datetime timeToSchedule = System.now().addMinutes(2);
        String tempCronExpresstion = timeToSchedule.second() + ' ' + timeToSchedule.minute() + ' ' + timeToSchedule.hour() + ' ' + timeToSchedule.day() + ' ' + timeToSchedule.month() + ' ? ' + timeToSchedule.year();
        Id jobId = System.schedule('Get Modigie for Queue Test Lead', tempCronExpresstion, new SalesEngagementScheduleClass());
        System.assert(jobId != null);
    }
    @isTest
    public static void callingTestContactType() {
        RuleSetFactoryTest.insertUseCase('Use Case 1');
		RuleSetFactoryTest.createQueue('Use Case 1', 'Contact');
        Datetime timeToSchedule = System.now().addMinutes(2);
        String tempCronExpresstion = timeToSchedule.second() + ' ' + timeToSchedule.minute() + ' ' + timeToSchedule.hour() + ' ' + timeToSchedule.day() + ' ' + timeToSchedule.month() + ' ? ' + timeToSchedule.year();
        Id jobId = System.schedule('Get Modigie for Queue Test Contact', tempCronExpresstion, new SalesEngagementScheduleClass());
        System.assert(jobId != null);
    }
}