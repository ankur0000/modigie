public class DynamicAutomationCriteriaCompController {
    @AuraEnabled
    public static List<Map<String,String>> getObjectFieldInfo(){
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
                if(fieldType == 'PICKLIST' || fieldType == 'STRING' || fieldType == 'URL' ||  fieldType == 'PHONE' || fieldType=='BOOLEAN' || fieldType=='DATETIME' || fieldType=='DOUBLE' || fieldType == 'INTEGER' || fieldType == 'DATE'){
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
                
                if(fieldType == 'PICKLIST' || fieldType == 'STRING' || fieldType == 'URL' || fieldType == 'PHONE' || fieldType=='BOOLEAN' || fieldType=='DATETIME' ||  fieldType=='DOUBLE' || fieldType == 'INTEGER' || fieldType == 'DATE'){
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
    public static List<String> getPicklistvalues(String objectName, String field_apiname){
        try{
            List<String> optionlist = new List<String>();       
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap();        
            List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();       
            for (Schema.PicklistEntry pv : picklistValues) {
                optionlist.add(pv.getValue());
            }
            return optionlist;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void setAutomationCriteria(List<List<Map<String,String>>> criteriaData, List<String> logicCriteria){
        try{
            System.debug('critriaData --> ' + criteriaData);
            
            List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT Id, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Lead__c];
            
            if(!lstLeadCriteria.isEmpty()){
                delete lstLeadCriteria;
            }
            
            List<modigie__Modigie_Automation_Criteria_Lead__c> insertCriteriaLead = new List<modigie__Modigie_Automation_Criteria_Lead__c>();
            
            if(!criteriaData[0].isEmpty()){
                Integer i = 0;
                for(Map<String,String> leadCriteria : criteriaData[0]){
                    insertCriteriaLead.add(new modigie__Modigie_Automation_Criteria_Lead__c(Name = String.valueOf(i),modigie__Field_Order__c = i, modigie__Field_Value__c = leadCriteria.get('CriteriaValue'), modigie__Operator__c = leadCriteria.get('SelectedOperator'),modigie__Field_Api_Name__c = leadCriteria.get('SelectedField')));
                    i++;
                }
                
                insert insertCriteriaLead;
            }
            
            List<modigie__Modigie_Automation_Criteria_Contact__c> lstConCriteria = [SELECT Id, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Contact__c];
            
            if(!lstConCriteria.isEmpty()){
                delete lstConCriteria;
            }
            
            
            List<modigie__Modigie_Automation_Criteria_Contact__c> insertCriteriaCon = new List<modigie__Modigie_Automation_Criteria_Contact__c>();
            
            if(!criteriaData[1].isEmpty()){
                Integer i = 0;
                for(Map<String,String> conCriteria : criteriaData[1]){
                    insertCriteriaCon.add(new modigie__Modigie_Automation_Criteria_Contact__c(Name = String.valueOf(i),modigie__Field_Order__c = i, modigie__Field_Value__c = conCriteria.get('CriteriaValue'), modigie__Operator__c = conCriteria.get('SelectedOperator'),modigie__Field_Api_Name__c = conCriteria.get('SelectedField')));
                    i++;
                }
                
                insert insertCriteriaCon;
            }
            
            modigie__Process_Builder_Switch__c mPbs = [SELECT Id FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
            mPbs.modigie__Dynamic_Lead_Logic_Type__c = Integer.valueOf(logicCriteria[0]);
            mPbs.modigie__Dynamic_Lead_Custom_Logic__c = logicCriteria[1];
            mPbs.modigie__Dynamic_Contact_Logic_Type__c = Integer.valueOf(logicCriteria[2]);
            mPbs.modigie__Dynamic_Contact_Custom_Logic__c = logicCriteria[3];
            update mPbs;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<List<Map<String,String>>> getAutomationCriteria(){
        try{
            String orderBy = 'Name';
            List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = new List<modigie__Modigie_Automation_Criteria_Lead__c>();
            try{
                if([SELECT modigie__Field_Order__c FROM modigie__Modigie_Automation_Criteria_Lead__c LIMIT 1].modigie__Field_Order__c != null){
                    orderBy = 'modigie__Field_Order__c';
                }
            }catch(Exception e){}
            
            if(orderBy == 'modigie__Field_Order__c'){
                lstLeadCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Lead__c ORDER BY modigie__Field_Order__c];
            }else{
                lstLeadCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Lead__c ORDER BY Name];
            }
            System.debug('Lead orderBy-->'+ orderBy);
            //String qry = 'SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Lead__c ORDER BY '+orderBy;
            //List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = new List<modigie__Modigie_Automation_Criteria_Lead__c>();
            //if(orderBy == ){
                
            //}else{

            //}
            
            /*
            try{
                lstLeadCriteria = Database.query(qry);
            }catch(System.QueryException e){}
            */
            //System.debug(lstLeadCriteria);
            //List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT Id, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Lead__c ORDER BY Name];
            //orderBy = 'Name';
            List<modigie__Modigie_Automation_Criteria_Contact__c> lstContactCriteria = new List<modigie__Modigie_Automation_Criteria_Contact__c>();
            try{
                if([SELECT modigie__Field_Order__c FROM modigie__Modigie_Automation_Criteria_Contact__c LIMIT 1].modigie__Field_Order__c != null){
                    orderBy = 'modigie__Field_Order__c';
                }
            }catch(Exception e){}
            
            if(orderBy == 'modigie__Field_Order__c'){
                lstContactCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Contact__c ORDER BY modigie__Field_Order__c];
            }else{
                lstContactCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Contact__c ORDER BY Name];
            }
            System.debug('Contact orderBy-->'+ orderBy);
            //qry = 'SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Contact__c ORDER BY '+orderBy;
            //new List<modigie__Modigie_Automation_Criteria_Contact__c>();
            /*
            try{
                lstContactCriteria = Database.query(qry);
            }catch(System.QueryException e){}
            */
            
            //System.debug(lstContactCriteria);
            //List<modigie__Modigie_Automation_Criteria_Contact__c> lstContactCriteria = [SELECT Id, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c FROM modigie__Modigie_Automation_Criteria_Contact__c ORDER BY Name];
            
            List<Map<String,String>> lstLdCrteria = new List<Map<String,String>>();
            
            for(modigie__Modigie_Automation_Criteria_Lead__c criteriaLd : lstLeadCriteria){
                lstLdCrteria.add(new Map<String,String>{'SelectedField' => criteriaLd.modigie__Field_Api_Name__c,'SelectedOperator' => criteriaLd.modigie__Operator__c, 'CriteriaValue' => criteriaLd.modigie__Field_Value__c});
            }
            
            List<Map<String,String>> lstConCrteria = new List<Map<String,String>>();
            
            for(modigie__Modigie_Automation_Criteria_Contact__c criteriaCon : lstContactCriteria){
                lstConCrteria.add(new Map<String,String>{'SelectedField' => criteriaCon.modigie__Field_Api_Name__c,'SelectedOperator' => criteriaCon.modigie__Operator__c, 'CriteriaValue' => criteriaCon.modigie__Field_Value__c});
            }
            
            List<List<Map<String,String>>> result = new List<List<Map<String,String>>>{lstLdCrteria, lstConCrteria};
                
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> getLogicCriteria(){
        try {
            modigie__Process_Builder_Switch__c mPbs = [SELECT modigie__Dynamic_Contact_Custom_Logic__c, modigie__Dynamic_Contact_Logic_Type__c, modigie__Dynamic_Lead_Custom_Logic__c, modigie__Dynamic_Lead_Logic_Type__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
            List<String> logicCriteria = new List<String>();
            if(mPbs.modigie__Dynamic_Lead_Logic_Type__c == Null || String.valueOf(mPbs.modigie__Dynamic_Lead_Logic_Type__c) == ''){
                logicCriteria.add('1');
            }else{
                logicCriteria.add(String.valueOf(mPbs.modigie__Dynamic_Lead_Logic_Type__c));
            }

            if(mPbs.modigie__Dynamic_Lead_Custom_Logic__c == Null){
                logicCriteria.add('');
            }else{
                logicCriteria.add(mPbs.modigie__Dynamic_Lead_Custom_Logic__c);
            }
            
            if(mPbs.modigie__Dynamic_Contact_Logic_Type__c == Null || String.valueOf(mPbs.modigie__Dynamic_Contact_Logic_Type__c) == ''){
                logicCriteria.add('1');
            }else{
                logicCriteria.add(String.valueOf(mPbs.modigie__Dynamic_Contact_Logic_Type__c));
            }

            if(mPbs.modigie__Dynamic_Contact_Custom_Logic__c == Null){
                logicCriteria.add('');
            }else{
                logicCriteria.add(mPbs.modigie__Dynamic_Contact_Custom_Logic__c);
            }

            return logicCriteria;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    // // ----------------   create new ruleset fumctions ----------------
    
    // @AuraEnabled
    // public static string saveRulesetDetails(){
    //     try {
    //         // System.debug(ruleset);
    //         return 'hii';
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }

    @AuraEnabled
    public static modigie__Modigie_Rule_Sets__c getRulesetDetails(String rulesetId){
        try {
            modigie__Modigie_Rule_Sets__c rulesetDetails = [SELECT Id, Name, modigie__Rule_Set_Name__c, modigie__Rule_Set_Description__c, modigie__isActive__c, modigie__Contact_Custom_Logic__c, modigie__Contact_Logic_Type__c, modigie__isLimit__c, modigie__Lead_Custom_Logic__c, modigie__Lead_Logic_Type__c, modigie__Limit__c, modigie__Maintain_Queue__c, modigie__OnlyOnCreate__c, modigie__Credit_Record_Id__c FROM modigie__Modigie_Rule_Sets__c WHERE Id =: rulesetId LIMIT 1];
            return rulesetDetails;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<List<Map<String,String>>> getCriteriaDetails(String rulesetId){
        try {
            // rulesetId = rulesetId.subString(0,15);
            List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__Rule_Set_Id__c FROM modigie__Modigie_Automation_Criteria_Lead__c WHERE modigie__Rule_Set_Id__c =: rulesetId ORDER BY modigie__Field_Order__c];

            List<Map<String,String>> lstLdCriteria = new List<Map<String,String>>();
            
            for(modigie__Modigie_Automation_Criteria_Lead__c criteriaLd : lstLeadCriteria){
                lstLdCriteria.add(new Map<String,String>{'SelectedField' => criteriaLd.modigie__Field_Api_Name__c,'SelectedOperator' => criteriaLd.modigie__Operator__c, 'CriteriaValue' => criteriaLd.modigie__Field_Value__c});
            }

            List<modigie__Modigie_Automation_Criteria_Contact__c> lstContactCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__Rule_Set_Id__c FROM modigie__Modigie_Automation_Criteria_Contact__c WHERE modigie__Rule_Set_Id__c =: rulesetId ORDER BY modigie__Field_Order__c];

            List<Map<String,String>> lstConCriteria = new List<Map<String,String>>();
            
            for(modigie__Modigie_Automation_Criteria_Contact__c criteriaCon : lstContactCriteria){
                lstConCriteria.add(new Map<String,String>{'SelectedField' => criteriaCon.modigie__Field_Api_Name__c,'SelectedOperator' => criteriaCon.modigie__Operator__c, 'CriteriaValue' => criteriaCon.modigie__Field_Value__c});
            }
            
            List<List<Map<String,String>>> result = new List<List<Map<String,String>>>{lstLdCriteria, lstConCriteria};
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Integer getCurrentQueue(String rulesetId){
        try {
            Integer currentQueue = RuleSetClass.getCurrentQueue(rulesetId);
            return currentQueue;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Object> getPreAnalysis(List<Map<String, String>> leadCriteriaList, List<Map<String, String>> contactCriteriaList, String leadLogic, String contactLogic, String automationTrigger, String leadLogicType, String contactLogicType){
        try {
            List<List<Map<String,String>>> criteriaData = new List<List<Map<String,String>>>();
            // criteriaData.add()
            criteriaData.add(leadCriteriaList);
            criteriaData.add(contactCriteriaList);
            System.debug('criteriaData==========>'+criteriaData);

            List<String> logicCriteria = new List<String>();
            logicCriteria.add(leadLogicType);
            logicCriteria.add(leadLogic);
            logicCriteria.add(contactLogicType);
            logicCriteria.add(contactLogic);
            System.debug('logicCriteria==========>'+logicCriteria);
            System.debug('automationTrigger==========>'+automationTrigger);
            Boolean onlyCreate;
            if(automationTrigger == '1'){
                onlyCreate = true;
            }
            else{
                onlyCreate = false;
            }
            System.debug('onlyCreate==========>'+onlyCreate);
            Map<String, Object> result = RuleSetClass.getAnalysisPreSave(criteriaData, logicCriteria, onlyCreate);
            System.debug('result==========>'+result);
            return result;
        } catch (Exception e) {
            System.debug(e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String saveTomUntomCriteria(Map<String,String> criteriaDetails, List<Map<String,String>> leadCriteriaList, List<Map<String,String>> contactCriteriaList, String tomOrUntom){
        try {
            System.debug('Criteira Detaiols ->>>>>>>>>>>>>>>>>>>>>>>'+criteriaDetails);
            Integer leadSelectedLogic = 0, contactSelectedLogic = 0, revertDateIn = 0;
            if(criteriaDetails.get('leadSelectedLogic') != null){
                leadSelectedLogic = Integer.valueOf(criteriaDetails.get('leadSelectedLogic'));
            }

            if(criteriaDetails.get('contactSelectedLogic') != null){
                contactSelectedLogic = Integer.valueOf(criteriaDetails.get('contactSelectedLogic'));
            }
            System.debug('revertIn==========>'+ criteriaDetails.get('revertDateIn'));
            if(criteriaDetails.get('revertDateIn') != null && criteriaDetails.get('revertDateIn') != ''){
                revertDateIn = Integer.valueOf(criteriaDetails.get('revertDateIn'));
            }
            if(criteriaDetails.get('revertDateIn') == ''){
                revertDateIn = null;
            }
            Id tomId;
            if(tomOrUntom == 'TOM'){ 
                
                List<modigie__TOM_Criteria__c> tomCriteriaDetails = [SELECT Id, Name, modigie__revertDateIn__c, modigie__Contact_Custom_Logic__c, modigie__Contact_Logic_Type__c, modigie__isTom__c, modigie__Lead_Custom_Logic__c, modigie__Lead_Logic_Type__c	 FROM modigie__TOM_Criteria__c WHERE modigie__isTom__c = true];
                if(tomCriteriaDetails.isEmpty()){
                        modigie__TOM_Criteria__c criteriaToInsert = new modigie__TOM_Criteria__c(
                            Name = 'TOM',
                            modigie__Contact_Custom_Logic__c = criteriaDetails.get('contactLogic'),
                            modigie__Contact_Logic_Type__c = contactSelectedLogic,
                            modigie__isTom__c = true,
                            modigie__Lead_Custom_Logic__c = criteriaDetails.get('leadLogic'),
                            modigie__Lead_Logic_Type__c = leadSelectedLogic,
                            modigie__revertDateIn__c = revertDateIn
                        );
                        try {
                            Database.SaveResult sr = Database.insert(criteriaToInsert);
                            if (sr.isSuccess()) {
                                // Operation was successful, so get the ID of the record that was processed
                                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                                tomId = sr.getId();
                            }
                            else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Account fields that affected this error: ' + err.getFields());
                                }
                            }
                        } catch (Exception e) {
                            System.debug('error-----------'+e.getStackTraceString());
                            throw new AuraHandledException(e.getMessage());
                        }
                        
                }
                else{
                    tomCriteriaDetails[0].modigie__Contact_Custom_Logic__c = criteriaDetails.get('contactLogic');
                    tomCriteriaDetails[0].modigie__Contact_Logic_Type__c = contactSelectedLogic;
                    tomCriteriaDetails[0].modigie__isTom__c = true;
                    tomCriteriaDetails[0].modigie__Lead_Custom_Logic__c = criteriaDetails.get('leadLogic');
                    tomCriteriaDetails[0].modigie__Lead_Logic_Type__c = leadSelectedLogic;
                    tomCriteriaDetails[0].modigie__revertDateIn__c = revertDateIn;
                    update tomCriteriaDetails;
                    tomId = tomCriteriaDetails[0].Id;
                }

                
            }
            else{
            List<modigie__TOM_Criteria__c> tomCriteriaDetails = [SELECT Id, Name, modigie__Contact_Custom_Logic__c, modigie__Contact_Logic_Type__c, modigie__isTom__c, modigie__Lead_Custom_Logic__c, modigie__Lead_Logic_Type__c	 FROM modigie__TOM_Criteria__c WHERE modigie__isTom__c = false];
                if(tomCriteriaDetails.isEmpty()){
                    
                        modigie__TOM_Criteria__c criteriaToInsert = new modigie__TOM_Criteria__c();
                        criteriaToInsert.Name = 'UNTOM';
                        criteriaToInsert.modigie__Contact_Custom_Logic__c = criteriaDetails.get('contactLogic');
                        criteriaToInsert.modigie__Contact_Logic_Type__c = contactSelectedLogic;
                        criteriaToInsert.modigie__isTom__c = false;
                        criteriaToInsert.modigie__Lead_Custom_Logic__c = criteriaDetails.get('leadLogic');
                        criteriaToInsert.modigie__Lead_Logic_Type__c = leadSelectedLogic;
                        criteriaToInsert.modigie__revertDateIn__c = revertDateIn;

                        Database.SaveResult sr = Database.insert(criteriaToInsert);
                            if (sr.isSuccess()) {
                                // Operation was successful, so get the ID of the record that was processed
                                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                                tomId = sr.getId();
                            }
                            else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Account fields that affected this error: ' + err.getFields());
                                }
                            }
                }
                else{
                    tomCriteriaDetails[0].modigie__Contact_Custom_Logic__c = criteriaDetails.get('contactLogic');
                    tomCriteriaDetails[0].modigie__Contact_Logic_Type__c = contactSelectedLogic;
                    tomCriteriaDetails[0].modigie__isTom__c = false;
                    tomCriteriaDetails[0].modigie__Lead_Custom_Logic__c = criteriaDetails.get('leadLogic');
                    tomCriteriaDetails[0].modigie__Lead_Logic_Type__c = leadSelectedLogic;
                    tomCriteriaDetails[0].modigie__revertDateIn__c = revertDateIn;
                    update tomCriteriaDetails;
                    tomId = tomCriteriaDetails[0].Id;
                }
            }   

            List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT Id, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__TOM_Id__c FROM modigie__Modigie_Automation_Criteria_Lead__c WHERE modigie__TOM_Id__c =: tomId];
                
                if(!lstLeadCriteria.isEmpty()){
                    delete lstLeadCriteria;
                }
                
                List<modigie__Modigie_Automation_Criteria_Lead__c> insertCriteriaLead = new List<modigie__Modigie_Automation_Criteria_Lead__c>();
                
                if(!leadCriteriaList.isEmpty()){
                    // System.debug(leadCriteriaList+tomId);
                    Integer i = 0;
                    for(Map<String,String> leadCriteria : leadCriteriaList){
                        String uniqueStringForLead = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
                        insertCriteriaLead.add(new modigie__Modigie_Automation_Criteria_Lead__c(Name = uniqueStringForLead, modigie__Field_Order__c = i, modigie__Field_Value__c = leadCriteria.get('CriteriaValue'), modigie__Operator__c = leadCriteria.get('SelectedOperator'), modigie__Field_Api_Name__c = leadCriteria.get('SelectedField'), modigie__TOM_Id__c = tomId));
                        i++;
                    }
                    
                    insert insertCriteriaLead;
                }

                List<modigie__Modigie_Automation_Criteria_Contact__c> lstConCriteria = [SELECT Id, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__TOM_Id__c FROM modigie__Modigie_Automation_Criteria_Contact__c WHERE modigie__TOM_Id__c =: tomId];
                
                if(!lstConCriteria.isEmpty()){
                    delete lstConCriteria;
                }
                
                
                List<modigie__Modigie_Automation_Criteria_Contact__c> insertCriteriaCon = new List<modigie__Modigie_Automation_Criteria_Contact__c>();
                
                if(!contactCriteriaList.isEmpty()){
                    Integer i = 0;
                    for(Map<String,String> conCriteria : contactCriteriaList){
                        String uniqueStringForContact = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') +((Integer)(Math.random()*1000));
                        insertCriteriaCon.add(new modigie__Modigie_Automation_Criteria_Contact__c(Name = uniqueStringForContact, modigie__Field_Order__c = i, modigie__Field_Value__c = conCriteria.get('CriteriaValue'), modigie__Operator__c = conCriteria.get('SelectedOperator'), modigie__Field_Api_Name__c = conCriteria.get('SelectedField'), modigie__TOM_Id__c = tomId));
                        i++;
                    }
                    
                    insert insertCriteriaCon;
                }
                
                // if(!lstLeadCriteria.isEmpty()){
                //     delete lstLeadCriteria;
                // }
            return 'criteriaDetails';
        } catch (Exception e) {
            System.debug('error-----------'+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<List<Map<String,String>>> getTomUntomCriteria(String tomOrUntom){
        try {
            System.debug('----------------->'+tomOrUntom);
            Boolean isTom;
            if(tomOrUntom == 'TOM'){
                isTom = true;
            }
            else{
                isTom = false;
            }
            List<modigie__TOM_Criteria__c> tomCriteriaDetails = [SELECT Id FROM modigie__TOM_Criteria__c WHERE modigie__isTom__c =: isTom];
            String tomId = String.valueOf(tomCriteriaDetails[0].Id);

            List<modigie__Modigie_Automation_Criteria_Lead__c> lstLeadCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__TOM_Id__c FROM modigie__Modigie_Automation_Criteria_Lead__c WHERE modigie__TOM_Id__c =:tomId ORDER BY modigie__Field_Order__c];

            System.debug(lstLeadCriteria);
            List<Map<String,String>> lstLdCriteria = new List<Map<String,String>>();
            
            for(modigie__Modigie_Automation_Criteria_Lead__c criteriaLd : lstLeadCriteria){
                lstLdCriteria.add(new Map<String,String>{'SelectedField' => criteriaLd.modigie__Field_Api_Name__c,'SelectedOperator' => criteriaLd.modigie__Operator__c, 'CriteriaValue' => criteriaLd.modigie__Field_Value__c});
            }

            List<modigie__Modigie_Automation_Criteria_Contact__c> lstContactCriteria = [SELECT Id, Name, modigie__Field_Order__c, modigie__Field_Data_Type__c, modigie__Field_Value__c, modigie__Operator__c, modigie__Field_Api_Name__c, modigie__TOM_Id__c FROM modigie__Modigie_Automation_Criteria_Contact__c WHERE modigie__TOM_Id__c =: tomId ORDER BY modigie__Field_Order__c];

            List<Map<String,String>> lstConCriteria = new List<Map<String,String>>();
            
            for(modigie__Modigie_Automation_Criteria_Contact__c criteriaCon : lstContactCriteria){
                lstConCriteria.add(new Map<String,String>{'SelectedField' => criteriaCon.modigie__Field_Api_Name__c,'SelectedOperator' => criteriaCon.modigie__Operator__c, 'CriteriaValue' => criteriaCon.modigie__Field_Value__c});
            }
            
            List<List<Map<String,String>>> result = new List<List<Map<String,String>>>{lstLdCriteria, lstConCriteria};
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static modigie__TOM_Criteria__c getTomDetails(String tomOrUntom){
        try {
            Boolean isTom;
            if(tomOrUntom == 'TOM'){
                isTom = true;
            }
            else{
                isTom = false;
            }
            modigie__TOM_Criteria__c tomCriteriaDetails = [SELECT Id, Name, modigie__revertDateIn__c, modigie__Contact_Custom_Logic__c, modigie__Contact_Logic_Type__c, modigie__isTom__c, modigie__Lead_Custom_Logic__c, modigie__Lead_Logic_Type__c FROM modigie__TOM_Criteria__c WHERE modigie__isTom__c =: isTom LIMIT 1];
            // String tomId = String.valueOf(tomCriteriaDetails[0].Id);

            // modigie__TOM_Criteria__c rulesetDetails = [SELECT Id, Name, modigie__Contact_Custom_Logic__c, modigie__Contact_Logic_Type__c, modigie__isTom__c, modigie__Lead_Custom_Logic__c, modigie__Lead_Logic_Type__c FROM modigie__isTom__c =: isTom LIMIT 1];
            return tomCriteriaDetails;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static list<modigie__creditAccountDetails__c	> getCreditId(){
        try {
            list<modigie__creditAccountDetails__c> gci = [SELECT modigie__Credit_Id__c , modigie__Title__c, modigie__isPerformance__c, modigie__Default__c FROM modigie__creditAccountDetails__c];
            system.debug('user Details..... '+ gci);
            return gci; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }   

}