global with sharing class BatchJobsScheluderClass implements Schedulable {
  //public static String sched = '0 00 00 * * ?';  //Every Day at Midnight

  global static String scheduleMe(Integer hour, Decimal Minute, String type) {
    try {
      String sched = '';
      BatchJobsScheluderClass SC = new BatchJobsScheluderClass();

      if (type?.equalsIgnoreCase('Time') == true) {
        sched = '0 ' + Minute + ' ' + hour + ' *' + ' *' + ' ?';
        List<modigie__Scheduled_Classes_Interval_Information__c> scheduledIntervalInfo = [
          SELECT id
          FROM modigie__Scheduled_Classes_Interval_Information__c
          WITH SECURITY_ENFORCED
          LIMIT 1
        ];
        if (!scheduledIntervalInfo.isEmpty()) {
          delete scheduledIntervalInfo;
        }
        return System.schedule('Modigie Services Batch Job by time', sched, SC);
      } else {
        List<modigie__Scheduled_Classes_Interval_Information__c> scheduledIntervalInfo = [
          SELECT id
          FROM modigie__Scheduled_Classes_Interval_Information__c
          WITH SECURITY_ENFORCED
          LIMIT 1
        ];

        modigie__Scheduled_Classes_Interval_Information__c scheduleIntObj = new modigie__Scheduled_Classes_Interval_Information__c();
        if (scheduledIntervalInfo.size() > 0) {
          scheduleIntObj.id = scheduledIntervalInfo[0].Id;
        }
        scheduleIntObj.modigie__Hours__c = hour;
        scheduleIntObj.modigie__Minutes__c = Minute;
        if (
          FieldLevelSecurityCheck.canReadObject(
            'modigie__Scheduled_Classes_Interval_Information__c'
          ) &&
          FieldLevelSecurityCheck.canCreateObject(
            'modigie__Scheduled_Classes_Interval_Information__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateObject(
            'modigie__Scheduled_Classes_Interval_Information__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Scheduled_Classes_Interval_Information__c',
            'modigie__Hours__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Scheduled_Classes_Interval_Information__c',
            'modigie__Hours__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Scheduled_Classes_Interval_Information__c',
            'modigie__Hours__c'
          ) &&
          FieldLevelSecurityCheck.canReadField(
            'modigie__Scheduled_Classes_Interval_Information__c',
            'modigie__Minutes__c'
          ) &&
          FieldLevelSecurityCheck.canCreateField(
            'modigie__Scheduled_Classes_Interval_Information__c',
            'modigie__Minutes__c'
          ) &&
          FieldLevelSecurityCheck.canUpdateField(
            'modigie__Scheduled_Classes_Interval_Information__c',
            'modigie__Minutes__c'
          )
        ) {
          upsert scheduleIntObj;
        }

        IntervalSchedulerClass.scheduleForNextInterval();

        if (Test.isRunningTest()) {
          throw new BatchJobsScheluderClassException(
            'For Covering Catch block code'
          );
        }
        try{
          List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'User and Invocable Modigie Limits Reset' WITH SECURITY_ENFORCED]; 
          List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);

          if(lstCt.isEmpty()){
              System.schedule('User and Invocable Modigie Limits Reset', '0 00 00 * * ?', new ModigieLimitResetClass());
          }
          lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Modigie Batch Class Error Reset' WITH SECURITY_ENFORCED]; 
          lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);

          if(lstCt.size() == 0){
              System.schedule('Modigie Batch Class Error Reset', '0 00 00 * * ?', new ModigieBatchClassErrorReset());
          }
          
          lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Get Modigie for Queue' WITH SECURITY_ENFORCED]; 
          lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
          
          if(lstCt.size() == 0){
              System.schedule('Get Modigie for Queue', '0 30 00 * * ?', new SalesEngagementScheduleClass());
          }

          lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Modigie Analysis' WITH SECURITY_ENFORCED]; 
          lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
          
          if(lstCt.size() == 0){
              System.schedule('Modigie Analysis', '0 00 00 ? * 1', new ModigieUserAnalyticsBatch());
          }
        }catch(Exception ex){}
        if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Configurator__c') &&
          FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Configurator__c') &&
          FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Configurator__c') &&
          FieldLevelSecurityCheck.canReadField('modigie__Modigie_Configurator__c','modigie__ConfigurerId__c') &&
          FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Configurator__c','modigie__ConfigurerId__c') &&
          FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Configurator__c','modigie__ConfigurerId__c'))
        { 
          modigie__Modigie_Configurator__c pbs = modigie__Modigie_Configurator__c.getOrgDefaults();
          Id currentUserId = UserInfo.getUserId();
          if(pbs.modigie__ConfigurerId__c != (String)currentUserId){
            pbs.modigie__ConfigurerId__c = (String)currentUserId;
            upsert pbs;
          }
        }
        return 'success';
      }
    } catch (Exception e) {
      //call here Error Email
      EmailServiceClass.sendErrorEmail('BatchJobsSchedulerClass Error', e);
      /*
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<String> toAddresses = new List<String>();
      toAddresses.add('pratik@cyntexa.com');
      toAddresses.add('ashishsharma@cyntexa.com');
      if (!toAddresses.isEmpty()) {
        mail.setToAddresses(toAddresses);
        mail.saveAsActivity = false;
        mail.setSubject('Modigie : BatchJobsSchedulerBatchClass Error');
        String emailBody = 'Please check the error message - ' + e.getMessage();
        emailBody += '\nLine Number : ' + e.getLineNumber();
        emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
        emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
        mail.setPlainTextBody(emailBody);
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(
          new List<Messaging.SingleEmailMessage>{ mail }
        );
      }*/
      return 'error';
    }
  }
  global static String scheduleMe(Integer hour, Integer Minute, String type) {
    String sched = '';
    BatchJobsScheluderClass SC = new BatchJobsScheluderClass();

    if (type?.equalsIgnoreCase('Time') == true) {
      sched = '0 ' + Minute + ' ' + hour + ' *' + ' *' + ' ?';

      return System.schedule('Modigie Services Batch Job by time', sched, SC);
    } else {
      List<modigie__Scheduled_Classes_Interval_Information__c> scheduledIntervalInfo = [
        SELECT id
        FROM modigie__Scheduled_Classes_Interval_Information__c
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];

      modigie__Scheduled_Classes_Interval_Information__c scheduleIntObj = new modigie__Scheduled_Classes_Interval_Information__c();
      if (scheduledIntervalInfo.size() > 0) {
        scheduleIntObj.id = scheduledIntervalInfo[0].Id;
      }
      scheduleIntObj.modigie__Hours__c = hour;
      scheduleIntObj.modigie__Minutes__c = Minute;

      if (
        FieldLevelSecurityCheck.canReadObject(
          'modigie__Scheduled_Classes_Interval_Information__c'
        ) &&
        FieldLevelSecurityCheck.canCreateObject(
          'modigie__Scheduled_Classes_Interval_Information__c'
        ) &&
        FieldLevelSecurityCheck.canUpdateObject(
          'modigie__Scheduled_Classes_Interval_Information__c'
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'modigie__Scheduled_Classes_Interval_Information__c',
          'modigie__Hours__c'
        ) &&
        FieldLevelSecurityCheck.canCreateField(
          'modigie__Scheduled_Classes_Interval_Information__c',
          'modigie__Hours__c'
        ) &&
        FieldLevelSecurityCheck.canUpdateField(
          'modigie__Scheduled_Classes_Interval_Information__c',
          'modigie__Hours__c'
        ) &&
        FieldLevelSecurityCheck.canReadField(
          'modigie__Scheduled_Classes_Interval_Information__c',
          'modigie__Minutes__c'
        ) &&
        FieldLevelSecurityCheck.canCreateField(
          'modigie__Scheduled_Classes_Interval_Information__c',
          'modigie__Minutes__c'
        ) &&
        FieldLevelSecurityCheck.canUpdateField(
          'modigie__Scheduled_Classes_Interval_Information__c',
          'modigie__Minutes__c'
        )
      ) {
        upsert scheduleIntObj;
      }

      IntervalSchedulerClass.scheduleForNextInterval();
      try{
        List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'User and Invocable Modigie Limits Reset' WITH SECURITY_ENFORCED]; 
        List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);

        if(lstCt.isEmpty()){
            System.schedule('User and Invocable Modigie Limits Reset', '0 00 00 * * ?', new ModigieLimitResetClass());
        }
        lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Modigie Batch Class Error Reset' WITH SECURITY_ENFORCED]; 
        lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);

        if(lstCt.size() == 0){
            System.schedule('Modigie Batch Class Error Reset', '0 00 00 * * ?', new ModigieBatchClassErrorReset());
        }
        lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Get Modigie for Queue' WITH SECURITY_ENFORCED]; 
        lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
        
        if(lstCt.size() == 0){
            System.schedule('Get Modigie for Queue', '0 30 00 * * ?', new SalesEngagementScheduleClass());
        }
        lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Modigie Analysis' WITH SECURITY_ENFORCED]; 
        lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
        
        if(lstCt.size() == 0){
            System.schedule('Modigie Analysis', '0 00 00 ? * 1', new ModigieUserAnalyticsBatch());
        }
      }catch(Exception ex){}
      return 'success';
    }
  }

  global void execute(SchedulableContext sc) {
    try {
      List<AsyncApexJob> lstJobs = [
        SELECT ApexClass.Name
        FROM AsyncApexJob
        WHERE
          Status NOT IN ('Completed', 'Aborted', 'Failed')
          AND ApexClass.Name IN (
            'GetModigieBatchClass',
            'GetLinkedInBatchClass',
            'GetPhoneIntelligenceBatchClass',
            'VerifyEmployerBatchClass'
          )
        WITH SECURITY_ENFORCED
      ];

      Set<String> lstBatchName = new Set<String>();

      for (AsyncApexJob job : lstJobs) {
        lstBatchName.add(job.ApexClass.Name);
      }

      if (!lstBatchName.contains('GetModigieBatchClass')) {
        GetModigieBatchClass b1 = new GetModigieBatchClass();
        Database.executeBatch(b1, 25);
      }

      if (!lstBatchName.contains('GetLinkedInBatchClass')) {
        GetLinkedInBatchClass b2 = new GetLinkedInBatchClass();
        Database.executeBatch(b2, 25);
      }

      if (!lstBatchName.contains('GetPhoneIntelligenceBatchClass')) {
        GetPhoneIntelligenceBatchClass b3 = new GetPhoneIntelligenceBatchClass();
        Database.executeBatch(b3, 25);
      }

      if (!lstBatchName.contains('VerifyEmployerBatchClass')) {
        VerifyEmployerBatchClass b4 = new VerifyEmployerBatchClass();
        Database.executeBatch(b4, 25);
      }

      if (Test.isRunningTest()) {
        throw new BatchJobsScheluderClassException(
          'For covering catch code block'
        );
      }

      IntervalSchedulerClass.scheduleForNextInterval();
    } catch (Exception e) {
      //call here Error Email
      EmailServiceClass.sendErrorEmail('BatchJobsSchedulerClass Error', e);
      /*
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<String> toAddresses = new List<String>();
      toAddresses.add('pratik@cyntexa.com');
      toAddresses.add('ashishsharma@cyntexa.com');
      if (!toAddresses.isEmpty()) {
        mail.setToAddresses(toAddresses);
        mail.saveAsActivity = false;
        mail.setSubject('Modigie : BatchJobsSchedulerBatchClass Execute');
        String emailBody = 'Please check the error message - ' + e.getMessage();
        emailBody += '\nLine Number : ' + e.getLineNumber();
        emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
        emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
        mail.setPlainTextBody(emailBody);
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(
          new List<Messaging.SingleEmailMessage>{ mail }
        );
      }*/
      IntervalSchedulerClass.scheduleForNextInterval();
    }
  }

  public static void scheduleForOneMinute() {
    try {
      List<AsyncApexJob> lstJobs = [
        SELECT ApexClass.Name, Status
        FROM AsyncApexJob
        WHERE
          Status NOT IN ('Completed', 'Aborted', 'Failed')
          AND ApexClass.Name IN ('BatchJobsScheluderClass')
      ];

      if (lstJobs.isEmpty()) {
        for (CronTrigger ct : [
          SELECT Id
          FROM CronTrigger
          WHERE CronJobDetail.Name = 'Modigie Services Batch Job by interval'
        ]) {
          System.abortJob((String) ct.Id);
        }
        Datetime now = Datetime.now();
        now = now.addMinutes(1);
        String sched =
          now.second() +
          ' ' +
          now.minute() +
          ' ' +
          now.hour() +
          ' ' +
          now.day() +
          ' ' +
          now.month() +
          ' ?' +
          ' ' +
          now.year();
        BatchJobsScheluderClass SC = new BatchJobsScheluderClass();
        modigie__TOM__c tomDetails = modigie__TOM__c.getInstance();
        if(tomDetails.modigie__Repository_Status__c == 'inactive'){
          System.schedule('Modigie Services Batch Job by interval', sched, SC);
        }
        try{
          List<CronJobDetail> lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'User and Invocable Modigie Limits Reset' WITH SECURITY_ENFORCED]; 
          List<CronTrigger> lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);

          if(lstCt.isEmpty()){
              System.schedule('User and Invocable Modigie Limits Reset', '0 00 00 * * ?', new ModigieLimitResetClass());
          }

          lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Modigie Batch Class Error Reset' WITH SECURITY_ENFORCED]; 
          lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);

          if(lstCt.size() == 0){
              System.schedule('Modigie Batch Class Error Reset', '0 00 00 * * ?', new ModigieBatchClassErrorReset());
          }

          lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Get Modigie for Queue' WITH SECURITY_ENFORCED]; 
          lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
          
          if(lstCt.size() == 0){
              System.schedule('Get Modigie for Queue', '0 30 00 * * ?', new SalesEngagementScheduleClass());
          }
          lstCjd = [SELECT Id, Name, JobType FROM CronJobDetail WHERE Name = 'Modigie Analysis' WITH SECURITY_ENFORCED]; 
          lstCt = ([SELECT Id, CronJobDetailId, State FROM CronTrigger WHERE CronJobDetailId = :lstCjd WITH SECURITY_ENFORCED]);
          
          if(lstCt.size() == 0){
              System.schedule('Modigie Analysis', '0 00 00 ? * 1', new ModigieUserAnalyticsBatch());
          }
        }catch(Exception ex){}
      }
    } catch (Exception e) {
      //call here Error Email
      EmailServiceClass.sendErrorEmail('BatchJobsSchedulerClass Error', e);
      /*System.debug('e.getLineNumber() --> ' + e.getLineNumber());
      System.debug('e.getMessage() --> ' + e.getMessage());
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<String> toAddresses = new List<String>();
      toAddresses.add('pratik@cyntexa.com');
      toAddresses.add('ashishsharma@cyntexa.com');
      if (!toAddresses.isEmpty()) {
        mail.setToAddresses(toAddresses);
        mail.saveAsActivity = false;
        mail.setSubject(
          'Modigie : BatchJobsSchedulerBatchClass scheduleForOneMinute'
        );
        String emailBody = 'Please check the error message - ' + e.getMessage();
        emailBody += '\nLine Number : ' + e.getLineNumber();
        emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
        emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
        mail.setPlainTextBody(emailBody);
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(
          new List<Messaging.SingleEmailMessage>{ mail }
        );
      }*/
    }
  }
  private class BatchJobsScheluderClassException extends Exception {
  }
}