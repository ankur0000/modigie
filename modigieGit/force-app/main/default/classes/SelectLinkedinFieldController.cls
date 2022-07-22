public with sharing class SelectLinkedinFieldController {

   /* @AuraEnabled
    public static void saveField(String conField, String leadField){
        
        try{
            if(conField != '' || conField != null){
                Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Contact');
                Map<String, Schema.SObjectField> fieldMap = targetType.getDescribe().fields.getMap();
                for (Schema.SObjectField field : fieldMap.values()) {
                    if(field.getDescribe().getName() == conField)
                        System.debug(field.getDescribe().getName());
                }
            }
            
            if(leadField != '' || leadField != null){
                Schema.SObjectType targetType1 = Schema.getGlobalDescribe().get('Lead');
                Map<String, Schema.SObjectField> fieldMap1 = targetType1.getDescribe().fields.getMap();
                for (Schema.SObjectField field : fieldMap1.values()) {
                    if(field.getDescribe().getName() == leadField)
                        System.debug(field.getDescribe().getName());
                }
            }
        }
        catch(Exception e){
            throw new SelectLinkedinFieldControllerException(e.getMessage());
        }
    }*/
    
    @AuraEnabled
    public static String checkFieldExistence(){
        try{
           // String fieldValueString;
            List<modigie__Process_Builder_Switch__c> listOfFields = [SELECT modigie__Contact_Alt_LinkedIn_Url_Field_Name__c, modigie__Lead_Alt_LinkedIn_Url_Field_Name__c, modigie__Is_Active_Contact_Alt_LinkedIn_Url__c, modigie__Is_Active_Lead_Alt_LinkedIn_Url__c FROM modigie__Process_Builder_Switch__c];
            
            if(!listOfFields.isEmpty()){
            	Map<String, Object> resultMap = new Map<String,Object>();
            	resultMap.put('modigie__Contact_Alt_LinkedIn_Url_Field_Name__c', listOfFields[0].modigie__Contact_Alt_LinkedIn_Url_Field_Name__c);
                resultMap.put('modigie__Lead_Alt_LinkedIn_Url_Field_Name__c', listOfFields[0].modigie__Lead_Alt_LinkedIn_Url_Field_Name__c);
                resultMap.put('modigie__Is_Active_Contact_Alt_LinkedIn_Url__c', listOfFields[0].modigie__Is_Active_Contact_Alt_LinkedIn_Url__c);
                resultMap.put('modigie__Is_Active_Lead_Alt_LinkedIn_Url__c', listOfFields[0].modigie__Is_Active_Lead_Alt_LinkedIn_Url__c);
                resultMap.put('ContactFields',Schema.SObjectType.Contact.fields.getMap().keySet());
                resultMap.put('LeadFields',Schema.SObjectType.Lead.fields.getMap().keySet());
                
                
               // fieldValueString = '{"modigie__Contact_Alt_LinkedIn_Url_Field_Name__c":"'+listOfFields[0].modigie__Contact_Alt_LinkedIn_Url_Field_Name__c+'", "modigie__Lead_Alt_LinkedIn_Url_Field_Name__c":"'+listOfFields[0].modigie__Lead_Alt_LinkedIn_Url_Field_Name__c+'" , "modigie__Is_Active_Contact_Alt_LinkedIn_Url__c":"'+listOfFields[0].modigie__Is_Active_Contact_Alt_LinkedIn_Url__c+'", "modigie__Is_Active_Lead_Alt_LinkedIn_Url__c":"'+listOfFields[0].modigie__Is_Active_Lead_Alt_LinkedIn_Url__c+'"}';
                return JSON.serialize(resultMap);    
            }
		
            throw new SelectLinkedinFieldControllerException('No settings found, please contact your system administrator');
        }
        catch(Exception e){
            throw new SelectLinkedinFieldControllerException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void saveAltFieldSettings(String inputSetting){
    	Map<String, Object> inputMap = (Map<String, Object>)JSON.deserializeUntyped(inputSetting);
        
        List<modigie__Process_Builder_Switch__c> listOfFields = [SELECT modigie__Contact_Alt_LinkedIn_Url_Field_Name__c, modigie__Lead_Alt_LinkedIn_Url_Field_Name__c, modigie__Is_Active_Contact_Alt_LinkedIn_Url__c, modigie__Is_Active_Lead_Alt_LinkedIn_Url__c FROM modigie__Process_Builder_Switch__c];
            
        if(!listOfFields.isEmpty()){
            listOfFields[0].modigie__Contact_Alt_LinkedIn_Url_Field_Name__c = (String)inputMap.get('modigie__Contact_Alt_LinkedIn_Url_Field_Name__c');
            listOfFields[0].modigie__Lead_Alt_LinkedIn_Url_Field_Name__c = (String)inputMap.get('modigie__Lead_Alt_LinkedIn_Url_Field_Name__c');
            listOfFields[0].modigie__Is_Active_Contact_Alt_LinkedIn_Url__c = (Boolean)inputMap.get('modigie__Is_Active_Contact_Alt_LinkedIn_Url__c');
            listOfFields[0].modigie__Is_Active_Lead_Alt_LinkedIn_Url__c = (Boolean)inputMap.get('modigie__Is_Active_Lead_Alt_LinkedIn_Url__c');
        }
        
        update listOfFields;
    }

    private class SelectLinkedinFieldControllerException extends Exception{}
}