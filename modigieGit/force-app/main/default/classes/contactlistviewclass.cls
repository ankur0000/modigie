public with sharing class contactlistviewclass {
 public List<Contact> selLeadLst{get;set;}
    public String leadIds{get;set;}
    
    public contactlistviewclass(ApexPages.StandardSetController cntlr) {
        selLeadLst = cntlr.getSelected(); 
        leadIds = '';  
        for(Contact l : selLeadLst){
            leadIds += l.Id + ','; 
        }
        leadIds = leadIds.removeEnd(',');
    }
}