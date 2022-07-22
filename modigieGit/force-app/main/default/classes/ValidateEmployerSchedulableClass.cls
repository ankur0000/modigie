global with sharing class ValidateEmployerSchedulableClass implements Schedulable, Database.AllowsCallouts{ 
    global void execute(SchedulableContext sc){
        try{
            List<modigie__Process_Builder_Switch__c> processSwitch = [SELECT modigie__Validate_Employer_Data_Maintenance__c, modigie__Validate_Employer_Data_Maintenance_Lmt__c, modigie__Validate_Employer_Data_Maintenance_Usage__c, modigie__Limits_No_Limits_Selection__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
            
            if(processSwitch[0].modigie__Validate_Employer_Data_Maintenance__c){
                List<sObject> sobj1 = [SELECT FirstName,LastName,AccountId,modigie__Modigie_Verified_Number__c,MobilePhone,Email,modigie__linkedin_url__c FROM Contact WHERE (FirstName != null OR modigie__linkedin_url__c != null)  AND Account.Name != null AND Id IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'Not Available' OR modigie__Validate_Employer_Status__c = 'Validated') WITH SECURITY_ENFORCED];// AND modigie__Validate_Employer_Status__c != Network error, please try again
                List<sObject> sobj2 = [SELECT FirstName,LastName,Company,modigie__Modigie_Verified_Number__c,MobilePhone,Email,modigie__linkedin_url__c FROM Lead WHERE (FirstName != null OR modigie__linkedin_url__c != null) AND  Company != null AND Id IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'Validated' OR modigie__Validate_Employer_Status__c = 'Not Available') WITH SECURITY_ENFORCED];// AND modigie__Validate_Employer_Status__c != 'Network error, please try again
                
                List<sObject> lstSobj = new List<sObject>(); 
                lstSobj.addAll(sobj1);
                lstSobj.addAll(sobj2);
                
                if(!lstSobj.isEmpty()){
                    List<SObject> finalList = new List<SObject>();
                    
                    if(processSwitch[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('Limits') == true){
                        Integer availableLimit = (Integer)(processSwitch[0].modigie__Validate_Employer_Data_Maintenance_Lmt__c - processSwitch[0].modigie__Validate_Employer_Data_Maintenance_Usage__c);
                        if(availableLimit > 0){
                            if(availableLimit >= lstSobj.size()){
                                finalList = lstSobj;
                            }
                            else{
                                for(Integer i = 0; i < availableLimit; i++){
                                    finalList.add(lstSobj[i]);
                                }
                            }
                        }
                        else{
                            NotificationServiceClass.sendNotification('Verify Employer (Data Maintenance)',processSwitch[0].modigie__Validate_Employer_Data_Maintenance_Lmt_A__c);
                        }
                    }
                    else{
                        finalList = lstSobj;
                    }
                    
                    
                    if(finalList.size() > 0){
                        Integer b_size = 100;
                        try{
                            b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                            if(b_size > 100 || b_size < 1){
                                b_size = 100;
                            }
                        }catch(Exception e){}
                        VerifyEmployerDataMaintainenceClass b1 = new VerifyEmployerDataMaintainenceClass(finalList,3);
                        Database.executeBatch(b1,b_size);
                    }    
                }
                
                
            }
        }
        
        catch(System.QueryException e){
            throw new ValidateEmployerSchedulableClassException('You do not have permission to query lead, contact or modigie fields.');
        }
        catch(Exception e){
            //throw new ValidateEmployerSchedulableClassException(e.getMessage());
        }
    }
    private class ValidateEmployerSchedulableClassException extends Exception{}
}