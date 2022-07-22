global with sharing class SalesEngagementScheduleClass implements Schedulable {
    Integer b_size;
    global SalesEngagementScheduleClass() {
        try{
            b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
            if(b_size > 100 || b_size < 1){
                b_size = 100;
            }
        }catch(Exception e){
            b_size = 100;
        }
    }

    global void execute(SchedulableContext sc){
        try{
            List<modigie__Modigie_Rule_Sets__c> ruleSetList = [SELECT Id, modigie__Rule_Set_Name__c, modigie__Email_Limit_Sent__c, modigie__Limit__c, modigie__Usage__c, modigie__isLimit__c, modigie__Maintain_Queue__c, modigie__isActive__c FROM modigie__Modigie_Rule_Sets__c];
            
            if(!ruleSetList.isEmpty()){
                Map<Id, sObject> mapRuleSets = new Map<Id, sObject>(ruleSetList);
                Set<Id> ruleSetKeys = mapRuleSets.keySet();

                //Give admin option to set this for organization wide default
                //Use case which object to consume limit first
                String firstChoiceOpted = 'Contact';
                String secondChoiceOpted = 'Lead';
                //fetch firstChoiceOpted from somewhere
                try{
                    firstChoiceOpted = System.Label.modigie.Queue_First_Priority;
                    if(firstChoiceOpted == 'Lead' || firstChoiceOpted == 'Leads'){
                        firstChoiceOpted = 'Lead';
                        secondChoiceOpted = 'Contact';
                    }else if(firstChoiceOpted == 'Contact' || firstChoiceOpted == 'Contacts'){
                        //do nothing
                    }else{
                        System.debug('Modigie Warning --> Custom Label Value for Queue First Priority can only be Lead/Contact');
                    }
                }catch(Exception e){
                    System.debug('Modigie Warning --> Custom Label Value for Queue First Priority can only be Lead/Contact');
                }
                
                Map<Id, List<Id>> firstChoice = new Map<Id, List<Id>>();
                Map<Id, List<Id>> secondChoice = new Map<Id, List<Id>>();
                List<modigie__Modigie__c> modiList = Database.query('SELECT modigie__Lead__c, modigie__Contact__c, modigie__Rule_Set_Id__c, modigie__Parent_Id__c FROM modigie__Modigie__c WHERE (modigie__Lead__c != Null OR modigie__Contact__c != Null) AND modigie__Status__c = \'In queue\'');// AND modigie__Rule_Set_Id__c = :ruleSetKeys');
                List<modigie__Modigie__c> toDeleteModiList = new List<modigie__Modigie__c>();

                String firstChoiceField = 'modigie__'+firstChoiceOpted+'__c';
                String secondChoiceField = 'modigie__'+secondChoiceOpted+'__c';
                for(modigie__Modigie__c modiRec : modiList){
                    if(modiRec.modigie__Parent_Id__c != Null && modiRec.modigie__Parent_Id__c != ''){
                        if(mapRuleSets.get(modiRec.modigie__Rule_Set_Id__c) != Null){
                            sObject tempMapRuleSet = mapRuleSets.get(modiRec.modigie__Rule_Set_Id__c);
                            if((Boolean)tempMapRuleSet.get('modigie__isActive__c')){
                                Id tempValue = (Id)modiRec.get(firstChoiceField);
                                if(tempValue != Null){
                                    firstChoice.put(tempValue, new List<Id>{modiRec.modigie__Rule_Set_Id__c});
                                }else{
                                    tempValue = (Id)modiRec.get(secondChoiceField);
                                    secondChoice.put(tempValue, new List<Id>{modiRec.modigie__Rule_Set_Id__c});
                                }
                            }else{
                                //delete queue of inactive rule set
                                toDeleteModiList.add(modiRec);
                            }                            
                        }else{
                            //delete queue of deleted rule set
                            toDeleteModiList.add(modiRec);
                        }
                    }else{
                        //delete queue of deleted parent record
                        toDeleteModiList.add(modiRec);
                    }
                }
                if(!toDeleteModiList.isEmpty() && FieldLevelSecurityCheck.canDeleteObject('modigie__Modigie__c')){
                    Database.DeleteResult[] delResults = Database.delete(toDeleteModiList, false);
                    ErrorLogClass.createErrorLog(toDeleteModiList, 'Id', delResults, 'Cleaning Queue', 'Sales Engagement Tool Automation');
                }

                Boolean noGo = true;
                if(!firstChoice.isEmpty() && !secondChoice.isEmpty()){
                    SalesEngagementBatchClass modiAsync = new SalesEngagementBatchClass(firstChoice, secondChoice, mapRuleSets, firstChoiceOpted);
                    Database.executeBatch(modiAsync, b_size);
                    noGo = false;
                }else{
                    if(!firstChoice.isEmpty()){
                        SalesEngagementBatchClass modiAsync = new SalesEngagementBatchClass(firstChoice, mapRuleSets, firstChoiceOpted);
                        Database.executeBatch(modiAsync, b_size);
                        noGo = false;
                    }else if(!secondChoice.isEmpty()){
                        SalesEngagementBatchClass modiAsync = new SalesEngagementBatchClass(secondChoice, mapRuleSets, secondChoiceOpted);
                        Database.executeBatch(modiAsync, b_size);
                        noGo = false;
                    }
                }
                if(noGo){
                    System.debug('No queues to run Modigie on.');
                }
            }
        }catch(Exception ex){
            EmailServiceClass.sendErrorEmail('SalesEngagementScheduleClass Error', ex);
        }
    }
    
    private class SalesEngagementScheduleClassException extends Exception{}

}