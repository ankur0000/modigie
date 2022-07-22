@isTest
public class tomControllerClassTest {
	@isTest
    public static void test1(){
        modigie__TOM__c tomDetails = new modigie__TOM__c();
        tomDetails.modigie__Lead_Priority_1__c = 'modigie__Modigie_Verified_Number__c';
        tomDetails.modigie__Lead_Priority_2__c = 'modigie__Alternate_Mobile_Number_1__c';
        tomDetails.modigie__Lead_Priority_3__c = 'modigie__Alternate_Mobile_Number_2__c';
        tomDetails.modigie__Lead_Priority_4__c = 'modigie__modigie_mobile_phone_number_salesloft__c';
        tomDetails.modigie__Lead_Priority_5__c = 'mobilephone';
        tomDetails.modigie__Lead_Priority_6__c = 'phone';
        tomDetails.modigie__Contact_Priority_1__c = 'modigie__Modigie_Verified_Number__c';
        tomDetails.modigie__Contact_Priority_2__c = 'modigie__Alternate_Mobile_Number1__c';
        tomDetails.modigie__Contact_Priority_3__c = 'modigie__Alternate_Mobile_Number2__c';
        tomDetails.modigie__Contact_Priority_4__c = 'homephone';
        tomDetails.modigie__Contact_Priority_5__c = 'otherphone';
        tomDetails.modigie__Contact_Priority_6__c = 'phone';
        tomDetails.modigie__endDate__c = Date.today();
        insert tomDetails;
        
        List<Map<String,String>> phoneFields = tomControllerClass.getPhoneFields();
        List<String> leadPriorities = new List<String>();
        leadPriorities.add('mobilephone');
        leadPriorities.add('modigie__modigie_mobile_phone_number_salesloft__c');
        leadPriorities.add('phone');
        leadPriorities.add('mobilephone');
        leadPriorities.add('modigie__modigie_mobile_phone_number_salesloft__c');
        leadPriorities.add('phone');
        leadPriorities.add('phone');
        tomControllerClass.savePrioritiesForLead(leadPriorities);
        List<String> contactPriorities = new List<String>();
        contactPriorities.add('mobilephone');
        contactPriorities.add('otherphone');
        contactPriorities.add('homephone');
        contactPriorities.add('mobilephone');
        contactPriorities.add('otherphone');
        contactPriorities.add('homephone');
        contactPriorities.add('homephone');
        tomControllerClass.savePrioritiesForContact(contactPriorities);
        tomControllerClass.getPriorities();
        Boolean toggleValue = true;
        tomControllerClass.saveToggleForTom(toggleValue);
        modigie__TOM__c tomCheck = [SELECT modigie__isActive__c FROM modigie__TOM__c WHERE Id = :tomDetails.Id];
        System.assert(tomCheck.modigie__isActive__c == toggleValue);
    }
    
    @isTest
    public static void test2(){
        tomControllerClass.getPriorities();
        Boolean toggleValue = true;
        tomControllerClass.saveToggleForTom(toggleValue);
        modigie__TOM__c tomCheck = [SELECT modigie__isActive__c FROM modigie__TOM__c LIMIT 1];
        System.assert(tomCheck.modigie__isActive__c == toggleValue);
    }
}