/************************************************************************ 
@Authors - Rikky Malviya
@Date - 27 Feb 2022
@Name - InvocableTomAutomationCall
@Description - Takes list of id of records from trigger and run a batch class for tom/untom
@Accessibility All Modigie Permission Set
***********************************************************************/
global with sharing class InvocableTomAutomationCall {
    @InvocableMethod
    global static void getRecordId(List<Id> listIds){
        try{
            String objType = listIds[0].getSObjectType().getDescribe().getName();
            Integer b_size;
            try{
                b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                if(b_size > 100 || b_size < 1){
                    b_size = 100;
                }
            }catch(Exception e){
                b_size = 100;
            }
            if(System.isFuture() || System.isBatch()){

                //SOrt Lead Ids(Ascending)) -> json serialize -> //append yyyy-MM-dd\'T\'HH:mm:ss'
                listIds.sort();
                String serializeListIds = Json.serialize(listIds);
                Datetime timeToSchedule = System.now().addMinutes(2);
                Datetime forUns;
                Integer minuteInTens = ((timeToSchedule.minute()/10) * 10);
                Integer minuteBy10Rem = timeToSchedule.minute() - minuteInTens;
                if(minuteBy10Rem >= 8){
                    forUns = Datetime.newInstance(timeToSchedule.year(), timeToSchedule.month(), timeToSchedule.day(), timeToSchedule.hour(), minuteInTens + 8, 0);
                }else if(minuteBy10Rem >= 6){
                    forUns = Datetime.newInstance(timeToSchedule.year(), timeToSchedule.month(), timeToSchedule.day(), timeToSchedule.hour(), minuteInTens + 6, 0);
                }else if(minuteBy10Rem >= 4){
                    forUns = Datetime.newInstance(timeToSchedule.year(), timeToSchedule.month(), timeToSchedule.day(), timeToSchedule.hour(), minuteInTens + 4, 0);
                }else if(minuteBy10Rem >= 2){
                    forUns = Datetime.newInstance(timeToSchedule.year(), timeToSchedule.month(), timeToSchedule.day(), timeToSchedule.hour(), minuteInTens + 2, 0);
                }else if(minuteBy10Rem >= 0){
                    forUns = Datetime.newInstance(timeToSchedule.year(), timeToSchedule.month(), timeToSchedule.day(), timeToSchedule.hour(), minuteInTens + 0, 0);
                }
                
                String stringLiteral = serializeListIds + forUns.formatGMT('yyyy-MM-dd\'T\'HH:mmZ');
                String uniqueString = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(stringLiteral)));
                System.debug(forUns.formatGMT('yyyy-MM-dd\'T\'HH:mmZ') + ' -> ' + uniqueString);

                String tempCronExpresstion = timeToSchedule.second() + ' ' + timeToSchedule.minute() + ' ' + timeToSchedule.hour() + ' ' + timeToSchedule.day() + ' ' + timeToSchedule.month() + ' ? ' + timeToSchedule.year();
                ModigieServicesAsychronousSchedulable schedulable = new ModigieServicesAsychronousSchedulable(listIds, 'Tom unTOM Batch Class');
                try{
                    System.schedule('modigie_TOM__' + uniqueString, tempCronExpresstion, schedulable);
                    System.debug('A-Sync -> ModigieServicesAsychronousSchedulable -> TOMunTOMBatchClass Called');
                }catch(Exception e){/*ignore*/}
            }else{
                System.debug('Sync -> TOMunTOMBatchClass Called');
                TOMunTOMBatchClass modiAsync = new TOMunTOMBatchClass(listIds, objType);
                Database.executeBatch(modiAsync, b_size);
            }
        }catch(Exception ex){
            EmailServiceClass.sendErrorEmail('InvocableTomAutomationCall Error', ex);
        }
    }
}