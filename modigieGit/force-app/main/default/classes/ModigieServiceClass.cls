/************************************************************************ 
@Authors Rikky Malviya
@Date    19 jan 2022
@Name    ModigieServiceClass
@Description Everything Related to new object Modigie Service handled here
***********************************************************************/
public class ModigieServiceClass {
    public ModigieServiceClass() {
        //no use
    }

    public static void createModigieServiceRecord(List<modigie__Modigie__c> modiList, String objType, String jobSource, String jobType){
        try{
            //Boolean flsCheck = check();
            if( FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Service__c') 
            && FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Service__c') 
            && FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Service__c') 
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Contact__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Contact__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Contact__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Lead__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Lead__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Lead__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Modigie__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Modigie__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Modigie__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Id__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Id__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Id__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Name__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Name__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Name__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Logic__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Logic__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Logic__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Job_Source__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Job_Source__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Job_Source__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Job_Type__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Job_Type__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Job_Type__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Validation_Key__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Validation_Key__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Validation_Key__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Parent_Id__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Parent_Id__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Parent_Id__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Api_Call__c' ) 
            && FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Api_Call__c' ) 
            && FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Api_Call__c' ) 
            && FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') 
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Lead__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Contact__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Parent_Id__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Rule_Set_Id__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Rule_Set_Name__c' )
            && FieldLevelSecurityCheck.canReadField( 'modigie__Modigie__c', 'modigie__Rule_Set_Logic__c' ) ) 
            {
                List<modigie__Modigie_Service__c> modiServiceList = new List<modigie__Modigie_Service__c>();

                for(modigie__Modigie__c modiRec: modiList){
                    modigie__Modigie_Service__c tempMS = new modigie__Modigie_Service__c();
                    if(modiRec.modigie__Lead__c != Null){
                        tempMS.modigie__Lead__c = modiRec.modigie__Lead__c;
                    }else if(modiRec.modigie__Contact__c != Null){
                        tempMS.modigie__Contact__c = modiRec.modigie__Contact__c;
                    }
                    tempMS.modigie__Parent_Id__c = modiRec.modigie__Parent_Id__c;
                    if(modiRec.modigie__Status__c == 'In process'){
                        tempMS.modigie__Api_Call__c = true;
                    }
                    tempMs.modigie__Modigie__c = modiRec.Id;
                    tempMS.modigie__Rule_Set_Id__c = modiRec.modigie__Rule_Set_Id__c;
                    tempMS.modigie__Rule_Set_Name__c = modiRec.modigie__Rule_Set_Name__c;
                    tempMS.modigie__Rule_Set_Logic__c = modiRec.modigie__Rule_Set_Logic__c;
                    tempMS.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    tempMS.modigie__Job_Source__c = jobSource;
                    tempMS.modigie__Job_Type__c = jobType;
                    modiServiceList.add(tempMS);
                }
                
                //change insertion method to also create log on failure
                Database.SaveResult[] saveResults = database.insert(modiServiceList, false);
                ErrorLogClass.createErrorLog(modiServiceList, 'modigie__Parent_Id__c', saveResults, jobType, jobSource);
            }
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('ModigieServiceClass Error', e);
        }
    }

    public static Boolean check(){
        return true;
        //if( FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Service__c') 
        //&& FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Service__c') 
        //&& FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Service__c') 
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Contact__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Contact__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Contact__c' )
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Lead__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Lead__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Lead__c' )
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Modigie__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Modigie__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Modigie__c' )
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Id__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Id__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Id__c' )
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Name__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Name__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Name__c' )
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Logic__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Logic__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Rule_Set_Logic__c' )
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Job_Source__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Job_Source__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Job_Source__c' )
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Job_Type__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Job_Type__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Job_Type__c' )
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Validation_Key__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Validation_Key__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Validation_Key__c' )
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Parent_Id__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Parent_Id__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Parent_Id__c' )
        //&& FieldLevelSecurityCheck.canReadField( 'modigie__Modigie_Service__c', 'modigie__Api_Call__c' ) 
        //&& FieldLevelSecurityCheck.canCreateField( 'modigie__Modigie_Service__c', 'modigie__Api_Call__c' ) 
        //&& FieldLevelSecurityCheck.canUpdateField( 'modigie__Modigie_Service__c', 'modigie__Api_Call__c' ) ) {
        //    return true;
        //}
        //return false;
    }

}