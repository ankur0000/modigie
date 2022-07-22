public with sharing class LeadBatchForModigieLinkedInMapping implements Database.Batchable<sObject>{
    String altLinkedInApiName;
    List<Lead> ldLst = new List<Lead>();
    String campaignId;
    String accessToken;

    public LeadBatchForModigieLinkedInMapping(List<Lead> ldLst,String recId, String accessToken, String altLinkedInApiName) {
        this.ldLst = ldLst;
        campaignId = recId;
        this.accessToken = accessToken;
        this.altLinkedInApiName = altLinkedInApiName;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, modigie__linkedin_url__c , ' + altLinkedInApiName + ' FROM Lead WHERE Id IN :ldLst AND ' + altLinkedInApiName + ' != null WITH SECURITY_ENFORCED');
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope){
        for(Lead ld : scope){
            ld.modigie__linkedin_url__c = String.valueOf(ld.get(altLinkedInApiName));
        }
        update scope;
    }
    public void finish(Database.BatchableContext bc){
        Integer b_size = 100;
        try{
            b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
            if(b_size > 100 || b_size < 1){
                b_size = 100;
            }
        }catch(Exception e){}
        LeadBatchForGetModigieButton batchable = new LeadBatchForGetModigieButton(ldLst,campaignId,accessToken);
        Database.executeBatch(batchable,b_size);
    }
}