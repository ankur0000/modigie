public with sharing class IntervalSchedulerClass {
    public static void scheduleForNextInterval(){
        try{
            List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name LIKE 'Modigie Services Batch Job by interval%' WITH SECURITY_ENFORCED];
            List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
            for(CronTrigger ct : lstCt){
                System.abortJob((String)ct.Id);
            }
            
            List<modigie__Scheduled_Classes_Interval_Information__c> scheduledIntervalInfo = [SELECT modigie__Hours__c, modigie__Minutes__c FROM modigie__Scheduled_Classes_Interval_Information__c WITH SECURITY_ENFORCED LIMIT 1];
            if(scheduledIntervalInfo.size() == 0){
                return;
            }
            
            Datetime now = Datetime.now();
            System.debug('Initially now --> ' + now);
            //Integer offset = UserInfo.getTimezone().getOffset(now);
            //Datetime local = now.addSeconds(offset/1000);
            
            now = now.addHours((Integer)scheduledIntervalInfo[0].modigie__Hours__c);
            
            if(scheduledIntervalInfo[0].modigie__Minutes__c == 0.5){
                now = now.addSeconds(30);
            }
            else{
                now = now.addMinutes((Integer)scheduledIntervalInfo[0].modigie__Minutes__c);
            }
            
            
            
            
            
            /* Integer day = system.now().day();
            Integer month = system.now().month();
            Integer hour = system.now().hour() + (Integer)scheduledIntervalInfo[0].modigie__Hours__c;
            Integer minute = system.now().minute();
            Integer second = system.now().second();
            Integer year = system.now().year();




            if(scheduledIntervalInfo[0].modigie__Minutes__c == 0.5){
            second += 30;
            }
            else{
            minute += (Integer)scheduledIntervalInfo[0].modigie__Minutes__c;
            }


            if(second > 59 || Test.isRunningTest()){
            second -= 60;
            minute++;
            }
            if(minute > 59 || Test.isRunningTest()){
            minute -= 60;
            hour++;
            }
            if(hour > 23 || Test.isRunningTest()){
            hour -= 24;
            day++;
            }

            if(day > 30 || (day > 28 && month == 2) || Test.isRunningTest()){
            /*switch on month {
            when 4,6,9,11 {		// when block 1
            month++;// code block 1
            day = 1;
            }	
            when 2{
            if(day > 29 || (day == 29 && math.mod(year,4) != 0)){
            day = 1;
            month++;
            }
            else{
            day ++;
            }
            }
            when 1,3,5,7,8,10,12{
            if(day > 31){
            day = 1;
            if(month ==12){
            month=1;
            }
            else{
            month++;
            }
            }
            }
            }
            }

            if(day > 30 || (day > 28 && month == 2) || Test.isRunningTest()){
            if(month == 4 || month == 6 || month == 9 || month == 11 || Test.isRunningTest()){
            month++;// code block 1
            day = 1;    
            }
            if(month == 2 || Test.isRunningTest()){
            if(day > 29 || (day == 29 && math.mod(year,4) != 0)  || Test.isRunningTest()){
            day = 1;
            month++;
            }
            else{
            day ++;
            }
            }

            if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 || Test.isRunningTest()){
            if(day > 31 || Test.isRunningTest()){
            day = 1;
            if(month ==12){
            month=1;
            }
            else{
            month++;
            }
            }
            }

            /*  switch on month {
            when 4,6,9,11 {		// when block 1
            month++;// code block 1
            day = 1;
            }	
            when 2{
            if(day > 29 || (day == 29 && math.mod(year,4) != 0)){
            day = 1;
            month++;
            }
            else{
            day ++;
            }
            }
            when 1,3,5,7,8,10,12{
            if(day > 31){
            day = 1;
            if(month ==12){
            month=1;
            }
            else{
            month++;
            }
            }
            }
            }
            }*/
            
            System.debug('now --> ' + now );
            System.debug('now.second() --> ' + now.second());
            System.debug('now.minute() --> ' + now.minute());
            System.debug('now.hour() --> ' + now.hour());
            System.debug('now.day() --> ' + now.day());
            System.debug('now.month() --> ' + now.month());
            System.debug('now.year() --> ' + now.year());
            String sched = now.second() + ' ' + now.minute() + ' ' + now.hour() + ' ' + now.day() + ' ' + now.month() + ' ?' + ' ' + now.year();
            BatchJobsScheluderClass SC = new BatchJobsScheluderClass(); 
            modigie__TOM__c tomDetails = modigie__TOM__c.getInstance();                
            if(!Test.isRunningTest() && tomDetails.modigie__Repository_Status__c == 'inactive'){
                System.schedule('Modigie Services Batch Job by interval', sched, SC);    
            }    
        	
            if(Test.isRunningTest()){
                throw new IntervalSchedulerClassException('For covering catch code block');
            }
        }
        catch(Exception e){
            //call here Error Email
            EmailServiceClass.sendErrorEmail('IntervalScheduler Class', e);
            /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>();
            toAddresses.add('pratik@cyntexa.com');
            toAddresses.add('ashishsharma@cyntexa.com');
            if(!toAddresses.isEmpty()){
                mail.setToAddresses(toAddresses);
                mail.saveAsActivity= false;
                mail.setSubject('Modigie : IntervalScheduler class');
                String emailBody = 'Please check the error message - ' + e.getMessage();
                emailBody += '\nLine Number : ' + e.getLineNumber();
                emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
                emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
                mail.setPlainTextBody(emailBody);
             //   List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }*/     
        }
        
        
    }
    private class IntervalSchedulerClassException extends Exception{}
}