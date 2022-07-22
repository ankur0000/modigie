//Added v1.70 Current Use Case - Update Older Enriched Data to reflect Alternative Numbers, and Employment Data
global without sharing class ModigieMaintenanceBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful, Schedulable  {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, modigie__Validation_Key__c FROM modigie__Modigie__c WHERE ((modigie__Lead__c != null AND modigie__Lead__r.modigie__Alternate_Mobile_Number_1__c = Null AND modigie__Mobile_2__c != Null) OR (modigie__Contact__c != null AND modigie__Contact__r.modigie__Alternate_Mobile_Number1__c = Null AND modigie__Mobile_2__c != Null)) OR ((modigie__Lead__c != null AND modigie__Lead__r.modigie__Alternate_Mobile_Number_2__c = Null AND modigie__Mobile_3__c != Null) OR (modigie__Contact__c != null AND modigie__Contact__r.modigie__Alternate_Mobile_Number2__c = Null AND modigie__Mobile_3__c != Null)) OR ((modigie__Lead__c != null AND modigie__Lead__r.modigie__Modigie_Employment_Changed__c = false AND modigie__Company_Name_Matches_Public_Records__c = \'No\') OR (modigie__Contact__c != null AND modigie__Contact__r.modigie__Modigie_Employment_Changed__c = false AND modigie__Company_Name_Matches_Public_Records__c = \'No\'))';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<modigie__Modigie__c> scope){
        try{
            System.debug('scope size->'+scope.size());
            List<modigie__Modigie__c> toUpdateList = new List<modigie__Modigie__c>();
            for(modigie__Modigie__c objRec: scope){
                objRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                toUpdateList.add(objRec);
            }
            if(!toUpdateList.isEmpty()
            && FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c')
            && FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Key__c')){
                update toUpdateList;
            }
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('ModigieMaintenanceBatchClass Error', e);
        }
    }
    global void finish(Database.BatchableContext bc) {}
    global void execute(SchedulableContext SC) {
        database.executebatch(new ModigieMaintenanceBatchClass());
    }
    global static Integer returnToUpdateRecords(){
        AggregateResult a = [SELECT Count(Id) total FROM modigie__Modigie__c WHERE ((modigie__Lead__c != null AND modigie__Lead__r.modigie__Alternate_Mobile_Number_1__c = Null AND modigie__Mobile_2__c != Null) OR (modigie__Contact__c != null AND modigie__Contact__r.modigie__Alternate_Mobile_Number1__c = Null AND modigie__Mobile_2__c != Null))
            OR ((modigie__Lead__c != null AND modigie__Lead__r.modigie__Alternate_Mobile_Number_2__c = Null AND modigie__Mobile_3__c != Null) OR (modigie__Contact__c != null AND modigie__Contact__r.modigie__Alternate_Mobile_Number2__c = Null AND modigie__Mobile_3__c != Null)) 
            OR ((modigie__Lead__c != null AND modigie__Lead__r.modigie__Modigie_Employment_Changed__c = false AND modigie__Company_Name_Matches_Public_Records__c = 'No') OR (modigie__Contact__c != null AND modigie__Contact__r.modigie__Modigie_Employment_Changed__c = false AND modigie__Company_Name_Matches_Public_Records__c = 'No'))
        ];
        return (Integer)a.get('total');
    }
}