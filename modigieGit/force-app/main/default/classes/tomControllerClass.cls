public class tomControllerClass {
    @AuraEnabled
    public static List<Map<String,String>> getPhoneFields(){
        try{
            String type='Lead';
            
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            
            Schema.SObjectType sObjectSchema = schemaMap.get('Lead');
            
            Map<String, Schema.SObjectField> fieldMap = sObjectSchema.getDescribe().fields.getMap();
            
            Map<String,String> fieldApiNametoLabelMap = new Map<String,String>();
            Map<String,String> fieldApiNametoTypeMap = new Map<String,String>();
            
            
            
            for (String fieldName: fieldMap.keySet()) {
                //It provides to get the object fields label.
                //String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                
                String fieldType = String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
                System.debug('fieldName --> ' + fieldName + '  ---> ' + fieldType);
                if(fieldType == 'PHONE'){
                    System.debug('If fieldName --> ' + fieldName + '  ---> ' + fieldType);
                    fieldApiNametoLabelMap.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());
                    fieldApiNametoTypeMap.put(fieldName,fieldType);
                }
                //It provides to get the object fields data type.
                //Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                
                
            }
            
            
            sObjectSchema = schemaMap.get('Contact');
            
            fieldMap = sObjectSchema.getDescribe().fields.getMap();
            
            Map<String,String> contactFieldApiNametoLabelMap = new Map<String,String>();
            Map<String,String> contactFieldApiNametoTypeMap = new Map<String,String>();
            
            for (String fieldName: fieldMap.keySet()) {
                //It provides to get the object fields label.
                //String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                String fieldType = String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
                
                if(fieldType == 'PHONE'){
                    contactFieldApiNametoLabelMap.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());
                    contactFieldApiNametoTypeMap.put(fieldName,fieldType);
                }
                //It provides to get the object fields data type.
                //Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                
                
            }
            
            List<Map<String,String>> result = new List<Map<String,String>>{fieldApiNametoLabelMap,fieldApiNametoTypeMap,contactFieldApiNametoLabelMap,contactFieldApiNametoTypeMap};       
                
                return result;        
            //return JSON.serialize(fieldApiNametoLabelMap);  
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }      
    }
    
    @AuraEnabled
    public static string savePrioritiesForLead(List<String> leadPriorities){
        try {
            modigie__TOM__c tomDetails = [SELECT Name, modigie__Lead_Priority_1__c, modigie__Lead_Priority_2__c, modigie__Lead_Priority_3__c, modigie__Lead_Priority_4__c, modigie__Lead_Priority_5__c, modigie__Lead_Priority_6__c, modigie__Lead_Reset_Priority_1__c, modigie__Lead_Reset_Priority_2__c, modigie__Lead_Reset_Priority_3__c FROM modigie__TOM__c LIMIT 1];
            tomDetails.modigie__Lead_Priority_4__c = leadPriorities[0];
            tomDetails.modigie__Lead_Priority_5__c = leadPriorities[1];
            tomDetails.modigie__Lead_Priority_6__c = leadPriorities[2];

            tomDetails.modigie__Lead_Reset_Priority_1__c = leadPriorities[3];
            tomDetails.modigie__Lead_Priority_2__c = leadPriorities[4];
            tomDetails.modigie__Lead_Reset_Priority_2__c = leadPriorities[5];
            tomDetails.modigie__Lead_Priority_3__c = leadPriorities[6];
            update tomDetails;
            return 'hii';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string savePrioritiesForContact(List<String> contactPriorities){
        try {
            modigie__TOM__c tomDetails = [SELECT Name, modigie__Contact_Priority_1__c, modigie__Contact_Priority_2__c, modigie__Contact_Priority_3__c, modigie__Contact_Priority_4__c, modigie__Contact_Priority_5__c, modigie__Contact_Priority_6__c, modigie__Contact_Reset_Priority_1__c, modigie__Contact_Reset_Priority_2__c, modigie__Contact_Reset_Priority_3__c FROM modigie__TOM__c LIMIT 1];
            tomDetails.modigie__Contact_Priority_4__c = contactPriorities[0];
            tomDetails.modigie__Contact_Priority_5__c = contactPriorities[1];
            tomDetails.modigie__Contact_Priority_6__c = contactPriorities[2];

            tomDetails.modigie__Contact_Reset_Priority_1__c = contactPriorities[3];
            tomDetails.modigie__Contact_Priority_2__c = contactPriorities[4];
            tomDetails.modigie__Contact_Reset_Priority_2__c = contactPriorities[5];
            tomDetails.modigie__Contact_Priority_3__c = contactPriorities[6];
            update tomDetails;
            return 'hii';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<List<String>> getPriorities(){
        try {
            List<modigie__TOM__c> tomDetails = [SELECT Id, IsDeleted, Name, SetupOwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, modigie__isActive__c, modigie__startDate__c, modigie__endDate__c, modigie__Org_Expiration_Date__c, modigie__Lead_Priority_1__c, modigie__Lead_Priority_2__c, modigie__Lead_Priority_3__c, modigie__Lead_Priority_4__c, modigie__Lead_Priority_5__c, modigie__Lead_Priority_6__c, modigie__Contact_Priority_1__c, modigie__Contact_Priority_2__c, modigie__Contact_Priority_3__c, modigie__Contact_Priority_4__c, modigie__Contact_Priority_5__c, modigie__Contact_Priority_6__c, modigie__Lead_Reset_Priority_1__c, modigie__Lead_Reset_Priority_2__c, modigie__Lead_Reset_Priority_3__c, modigie__Contact_Reset_Priority_1__c, modigie__Contact_Reset_Priority_2__c, modigie__Contact_Reset_Priority_3__c FROM modigie__TOM__c LIMIT 1];
            System.debug('tomDetails------------>'+tomDetails);
            if(tomDetails.size() > 0){
                String valid = 'false';
                if(Date.Today() >= tomDetails[0].modigie__startDate__c && Date.Today() <= tomDetails[0].modigie__endDate__c){
                    valid = 'true';
                }
                List<String> isValid = new List<String>();
                isValid.add(valid);

                String active = 'false';
                if(tomDetails[0].modigie__isActive__c){
                    active = 'true';
                }
                List<String> isActive = new List<String>();
                isActive.add(active);

                List<String> leadPriorities = new List<String>();
                leadPriorities.add(tomDetails[0].modigie__Lead_Priority_1__c);
                leadPriorities.add(tomDetails[0].modigie__Lead_Priority_2__c);
                leadPriorities.add(tomDetails[0].modigie__Lead_Priority_3__c);
                leadPriorities.add(tomDetails[0].modigie__Lead_Priority_4__c);
                leadPriorities.add(tomDetails[0].modigie__Lead_Priority_5__c);
                leadPriorities.add(tomDetails[0].modigie__Lead_Priority_6__c);
                List<String> contactPriorities = new List<String>();
                contactPriorities.add(tomDetails[0].modigie__Contact_Priority_1__c);
                contactPriorities.add(tomDetails[0].modigie__Contact_Priority_2__c);
                contactPriorities.add(tomDetails[0].modigie__Contact_Priority_3__c);
                contactPriorities.add(tomDetails[0].modigie__Contact_Priority_4__c);
                contactPriorities.add(tomDetails[0].modigie__Contact_Priority_5__c);
                contactPriorities.add(tomDetails[0].modigie__Contact_Priority_6__c);
                List<List<String>> priorities = new List<List<String>>();
                priorities.add(leadPriorities);
                priorities.add(contactPriorities);
                priorities.add(isActive);
                priorities.add(isValid);
                List<String> leadResetPriorities = new List<String>();
                leadResetPriorities.add(tomDetails[0].modigie__Lead_Reset_Priority_1__c);
                leadResetPriorities.add(tomDetails[0].modigie__Lead_Reset_Priority_2__c);
                leadResetPriorities.add(tomDetails[0].modigie__Lead_Reset_Priority_3__c);
                List<String> contactResetPriorities = new List<String>();
                contactResetPriorities.add(tomDetails[0].modigie__Contact_Reset_Priority_1__c);
                contactResetPriorities.add(tomDetails[0].modigie__Contact_Reset_Priority_2__c);
                contactResetPriorities.add(tomDetails[0].modigie__Contact_Reset_Priority_3__c);
                priorities.add(leadResetPriorities);
                priorities.add(contactResetPriorities);
                return priorities;
            }
            else{
                List<String> isValid = new List<String>();
                isValid.add('false');
                List<String> isActive = new List<String>();
                isActive.add('false');
                List<String> leadPriorities = new List<String>();
                List<String> contactPriorities = new List<String>();
                List<List<String>> priorities = new List<List<String>>();
                priorities.add(leadPriorities);
                priorities.add(contactPriorities);
                priorities.add(isActive);
                priorities.add(isValid);
                List<String> leadResetPriorities = new List<String>();
                List<String> contactResetPriorities = new List<String>();
                priorities.add(leadResetPriorities);
                priorities.add(contactResetPriorities);
                //SFD-65
                priorities.add(new List<String>());
                System.debug(priorities);
                return priorities;
            }
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string saveToggleForTom(Boolean toggleValue){
        try {
            List<modigie__TOM__c> tomDetails = [SELECT Id, IsDeleted, Name, SetupOwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, modigie__isActive__c, modigie__startDate__c, modigie__endDate__c, modigie__Org_Expiration_Date__c, modigie__Lead_Priority_1__c, modigie__Lead_Priority_2__c, modigie__Lead_Priority_3__c, modigie__Lead_Priority_4__c, modigie__Lead_Priority_5__c, modigie__Lead_Priority_6__c, modigie__Contact_Priority_1__c, modigie__Contact_Priority_2__c, modigie__Contact_Priority_3__c, modigie__Contact_Priority_4__c, modigie__Contact_Priority_5__c, modigie__Contact_Priority_6__c FROM modigie__TOM__c LIMIT 1];
            if(tomDetails.isEmpty()){
                tomDetails.add(new modigie__TOM__c(SetupOwnerId = UserInfo.getOrganizationId(), modigie__startDate__c = Date.Today(), modigie__endDate__c = Date.Today().addDays(30), modigie__isActive__c = true));
                insert tomDetails;
                return 'hii';
            }
            tomDetails[0].modigie__isActive__c = toggleValue;
            update tomDetails;
            return 'hii';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}