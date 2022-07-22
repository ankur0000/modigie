/**************************************************************************
 * @Author - Rikky Malviya 
 * @Date - 20 Jan 2022
 * @Name - TiggerOnModigieService
 * @Description - Trigger for Modigie Service Object
 *************************************************************************/
trigger TriggerOnModigieService on modigie__Modigie_Service__c (before insert, before update) {

    if(Trigger.isBefore){

        if((Trigger.isInsert || Trigger.isUpdate) && TriggerOnModigieServiceHelper.preventRecursion){

            TriggerOnModigieServiceHelper.preventRecursion = false;
            for(modigie__Modigie_Service__c ms : Trigger.new)
            {
                if(ms.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey'){
                    ms.modigie__Validation_Key__c = '';
                }else{
                    ms.addError('You can not insert/update the record');
                }
            }

        }
        
    }

}