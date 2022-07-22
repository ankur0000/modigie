/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    6 Feb 2020
*  @name    ScheduledContactBatch
*  @description This class runs in every 24 hours to check status of Contact related modigie records which are in escalation.
***********************************************************************/
global with sharing class ScheduledContactBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful 
{
    // List<Contact> contactList = new List<Contact>();
    // List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
    // Map<String, modigie__Modigie__c> modiMap = new Map<String, modigie__Modigie__c>();
    
    // public ScheduledContactBatch(List<Contact> schConList)
    // {
    //     contactList = schConList;
    // }


    global List<Contact> start(Database.BatchableContext bc) 
    {
        return null;
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> scope)
    {
    }  
    
    global void finish(Database.BatchableContext bc)
    {
    }    
}