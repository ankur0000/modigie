public with sharing class myExtension {

    public String currentRecordId {get;set;}
    
    public myExtension(ApexPages.StandardController controller) {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
    }
}