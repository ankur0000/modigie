trigger TriggerOnOpportunityContactRole on OpportunityContactRole (before insert)
{
    
    
    /*Set <Id> oppIds = new Set<Id>();
    Set <Id> conIds = new Set<Id>();
    
    
    for (OpportunityContactRole a : trigger.new) 
    {
        oppIds.add(a.OpportunityId);
        conIds.add(a.ContactId);
    }
    
    Map<ID, Opportunity> oppMap = new Map<ID, Opportunity>([SELECT Id,modigie__Contact_Id__c FROM Opportunity WHERE Id IN :oppIds]);
    Map<ID, Contact> conMap = new Map<ID, Contact>([SELECT Id,MobilePhone FROM Contact WHERE Id IN :conIds]);
    
    List <Opportunity> oppLst = new List<Opportunity>();
    
    
    
    
    for (OpportunityContactRole a : trigger.new)
    {
        Opportunity opp = oppMap.get(a.OpportunityId);
        
        opp.modigie__Contact_Id__c = a.ContactId;
        opp.modigie__Contact_Mobile_Number__c = conMap.get(a.ContactId).MobilePhone;
        oppLst.add(opp);
    }
    
    update oppLst;*/
    
}