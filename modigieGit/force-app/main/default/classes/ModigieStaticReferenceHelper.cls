global without sharing class ModigieStaticReferenceHelper {
    public ModigieStaticReferenceHelper(){
        //do nothing for now
    }
    //Job Automation
    global static List<Id> initialFiltering = new List<Id>();
    global static Boolean calledOnInitialFilter = false;
    global static List<Id> initialFilteringContact = new List<Id>();
    global static Boolean calledOnInitialFilterContact = false;
    //TOM - UnTOM
    global static Boolean calledOnInitialFilterTom = false;
    global static List<Id> initialFilteringTom = new List<Id>();
    global static Boolean calledOnInitialFilterContactTom = false;
    global static Boolean calledOnTomOverride = false;
    global static Boolean calledOnTomContactOverride = false;
    global static List<Id> initialFilteringContactTom = new List<Id>();
    //Stop Recursion for both Job Automation and TOM
    global static Boolean isSalesEngagementBatchRunning = false;
    global static Boolean isGetModigieBatchRunning = false;
    global static Boolean isUpdateFromModigie = false;
    global static Boolean isTOMunTOMBatchClassRunning = false;
    //Contact Make Inactive if from Lead Conversion.
    global static Boolean makeIsActiveFalse = false;
}