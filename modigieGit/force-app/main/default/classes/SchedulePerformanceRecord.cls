public with sharing class SchedulePerformanceRecord implements Schedulable 
{
    public void execute(SchedulableContext sc)
    {
     /*   try
        {
            Integer numberOfRecords;
            Integer totalResponseTime = 0;
            Decimal averageResponseTime;
            
            List<modigie__Modigie__c> modigielist = new List<modigie__Modigie__c>();
            
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c') &&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','CreatedDate')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Response_time__c'))
            {
                modigielist = [SELECT CreatedDate, modigie__Status__c, modigie__Response_time__c FROM modigie__Modigie__c WHERE (CreatedDate =: Date.today() AND modigie__Response_time__c != NULL) WITH SECURITY_ENFORCED];
            }
            
            if(modigielist.size() > 0)
            {
                numberOfRecords = modigielist.size();
                for(Integer i=0;i<modigielist.size();i++)
                {
                    List<String> arr = modigielist[i].modigie__Response_time__c.split(' ');
                    Integer iii = Integer.valueOf(arr[0])/1000;
                    totalResponseTime = totalResponseTime + iii;
                }
                averageResponseTime = totalResponseTime/numberOfRecords;
                
                    performanceObj.modigie__Average_Response_Time__c = averageResponseTime;
                    performanceObj.modigie__Date__c = Date.today();
                    performanceObj.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    
                    insert performanceObj;
                }
            }
            
        }
        catch(Exception e)
        {
        }*/
        
    }
}