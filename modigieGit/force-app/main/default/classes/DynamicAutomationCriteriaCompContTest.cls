@isTest
public class DynamicAutomationCriteriaCompContTest {
    @isTest
    public static void test1(){
        
        modigie__Modigie_Automation_Criteria_Lead__c newLeadCrit = new modigie__Modigie_Automation_Criteria_Lead__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        modigie__Modigie_Automation_Criteria_Contact__c newContCrit = new modigie__Modigie_Automation_Criteria_Contact__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        insert newLeadCrit;
        insert newContCrit;
        modigie__Process_Builder_Switch__c mPBS = new modigie__Process_Builder_Switch__c();
        insert mPBS;
        List<List<map<string,string>>> newLeadContact = new List<List<map<string,string>>>();
        List<map<string,string>> newlead = new List<map<string,string>>();
        List<map<string,string>> newContact = new List<map<string,string>>();
        newlead.add(new map<string,string>{'CriteriaValue'=>'newComp','SelectedField'=>'modigie__Company_URL__c','SelectedOperator'=>'equals'});
        newContact.add(new map<string,string>{'CriteriaValue'=>'newComp','SelectedField'=>'modigie__Company_URL__c','SelectedOperator'=>'equals'});
        newLeadContact.add(newlead);
        newLeadContact.add(newContact);
        
        List<String> logicCriteria = new List<String>();
        logicCriteria.add('2');
        logicCriteria.add('');
        logicCriteria.add('3');
        logicCriteria.add('1 OR 1');
        
        Test.startTest();
        
        DynamicAutomationCriteriaCompController.setAutomationCriteria(newLeadContact, logicCriteria);
        List<Map<String,String>> fieldInfo = DynamicAutomationCriteriaCompController.getObjectFieldInfo();
       	List<String> pickVal = DynamicAutomationCriteriaCompController.getPicklistvalues('Campaign','Type');
        List<String> someVal = DynamicAutomationCriteriaCompController.getLogicCriteria();
        List<List<Map<String,String>>> someOtherVal = DynamicAutomationCriteriaCompController.getAutomationCriteria();
        Test.stopTest();    
        System.assert(!someOtherVal.isEmpty());
    }
    @isTest
    public static void testForNewMethods(){
        modigie__Modigie_Automation_Criteria_Lead__c newLeadCrit = new modigie__Modigie_Automation_Criteria_Lead__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        modigie__Modigie_Automation_Criteria_Contact__c newContCrit = new modigie__Modigie_Automation_Criteria_Contact__c(Name = '1', modigie__Field_Value__c = 'newCompany1', modigie__Operator__c = 'equal',modigie__Field_Api_Name__c = 'modigie__Company_URL__c');
        insert newLeadCrit;
        insert newContCrit;
        modigie__Process_Builder_Switch__c mPBS = new modigie__Process_Builder_Switch__c();
        insert mPBS;
        List<List<map<string,string>>> newLeadContact = new List<List<map<string,string>>>();
        List<map<string,string>> leadCriteriaList = new List<map<string,string>>();
        List<map<string,string>> contactCriteriaList = new List<map<string,string>>();
        leadCriteriaList.add(new map<string,string>{'CriteriaValue'=>'newComp','SelectedField'=>'modigie__Company_URL__c','SelectedOperator'=>'equals'});
        contactCriteriaList.add(new map<string,string>{'CriteriaValue'=>'newComp','SelectedField'=>'modigie__Company_URL__c','SelectedOperator'=>'equals'});
        newLeadContact.add(leadCriteriaList);
        newLeadContact.add(contactCriteriaList);
        
        List<String> logicCriteria = new List<String>();
        logicCriteria.add('2');
        logicCriteria.add('');
        logicCriteria.add('3');
        logicCriteria.add('1 OR 1');
        
        modigie__Modigie_Rule_Sets__c ruleset = new modigie__Modigie_Rule_Sets__c();
        ruleset.Name = '2022-02-07T14:32:14.527+0000963';
        ruleset.modigie__Rule_Set_Name__c = 'ruleset1';
        insert ruleset;
        String automationTrigger = '1';
        String leadLogic = '';
        String contactLogic = '';
        String leadLogicType = '1';
        String contactLogicType = '1';
        
        DynamicAutomationCriteriaCompController.getRulesetDetails(ruleset.Id);
        DynamicAutomationCriteriaCompController.getCriteriaDetails(ruleset.Id);
        DynamicAutomationCriteriaCompController.getCurrentQueue(ruleset.Id);
        DynamicAutomationCriteriaCompController.getPreAnalysis(leadCriteriaList, contactCriteriaList, leadLogic, contactLogic, automationTrigger, leadLogicType, contactLogicType);
        System.assert(ruleset != null);
    }
    
    @isTest
    public static void test3(){
        map<string,string> criteriaDetails = new map<string,string>{
            'leadSelectedLogic' => '1', 
            'contactSelectedLogic' => '2',
            'leadLogic' => '',
            'contactLogic' => '',
            'isActive' => 'true'
        };
        List<map<string,string>> leadCriteriaList = new List<map<string,string>>();
        List<map<string,string>> contactCriteriaList = new List<map<string,string>>();
        leadCriteriaList.add(new map<string,string>{'CriteriaValue'=>'newComp','SelectedField'=>'modigie__Company_URL__c','SelectedOperator'=>'equals'});
        contactCriteriaList.add(new map<string,string>{'CriteriaValue'=>'newComp','SelectedField'=>'modigie__Company_URL__c','SelectedOperator'=>'equals'});
        String tomOrUntom = 'TOM';
        DynamicAutomationCriteriaCompController.saveTomUntomCriteria(criteriaDetails, leadCriteriaList, contactCriteriaList, tomOrUntom);
        tomOrUntom = 'unTOM';
        DynamicAutomationCriteriaCompController.saveTomUntomCriteria(criteriaDetails, leadCriteriaList, contactCriteriaList, tomOrUntom);
        
        modigie__TOM_Criteria__c tomCriteriaDetails = new modigie__TOM_Criteria__c();
        tomCriteriaDetails.Name = 'TOM';
        tomCriteriaDetails.modigie__Contact_Custom_Logic__c = '';
        tomCriteriaDetails.modigie__Contact_Logic_Type__c = 2;
        tomCriteriaDetails.modigie__isTom__c = true;
        tomCriteriaDetails.modigie__Lead_Custom_Logic__c = '';
        tomCriteriaDetails.modigie__Lead_Logic_Type__c = 1;
        insert tomCriteriaDetails;
        DynamicAutomationCriteriaCompController.saveTomUntomCriteria(criteriaDetails, leadCriteriaList, contactCriteriaList, tomOrUntom);
        
        
        /*modigie__TOM_Criteria__c tomCriteriaDetail = new modigie__TOM_Criteria__c();
        tomCriteriaDetail.Name = 'UNTOM';
        tomCriteriaDetail.modigie__Contact_Custom_Logic__c = '';
        tomCriteriaDetail.modigie__Contact_Logic_Type__c = 2;
        tomCriteriaDetail.modigie__isTom__c = false;
        tomCriteriaDetail.modigie__Lead_Custom_Logic__c = '';
        tomCriteriaDetail.modigie__Lead_Logic_Type__c = 1;
        insert tomCriteriaDetail;
        DynamicAutomationCriteriaCompController.saveTomUntomCriteria(criteriaDetails, leadCriteriaList, contactCriteriaList, tomOrUntom);*/
        
        List<List<Map<String,String>>> criteria = DynamicAutomationCriteriaCompController.getTomUntomCriteria(tomOrUntom);
        
        DynamicAutomationCriteriaCompController.getTomDetails('TOM');
        DynamicAutomationCriteriaCompController.getTomDetails('unTOM');
        System.assert(!criteria.isEmpty());
    }
}