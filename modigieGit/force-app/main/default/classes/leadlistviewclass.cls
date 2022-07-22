public with sharing class leadlistviewclass {
    public List<Lead> selLeadLst{get;set;}
    public String leadIds{get;set;}
    
    public leadlistviewclass(ApexPages.StandardSetController cntlr) {
        
        selLeadLst = cntlr.getSelected(); 
        leadIds = '';  
        for(Lead l : selLeadLst){
            leadIds += l.Id + ','; 
        }
        leadIds = leadIds.removeEnd(',');
    }
    
}