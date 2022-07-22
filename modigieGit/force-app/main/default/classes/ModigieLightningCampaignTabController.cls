public with sharing class ModigieLightningCampaignTabController {
    @AuraEnabled
    public static String getCampaignMemberInformation(Id recid){
        try{
            Map<String,Object> mMap = new Map<String,Object>();
            List<Map<String,Object>> lstMap = new List<Map<String,Object>>(); 
            List<CampaignMember> cmLst = new List<CampaignMember>();
            Set <Id> lstIds = new Set<Id>();

            Integer totalMembers = 0;
            
                totalMembers = [SELECT count() FROM CampaignMember WHERE CampaignId = :recid AND (ContactId !=null OR LeadId != null) WITH SECURITY_ENFORCED];
                mMap.put('TotalMembers',totalMembers);
                
                cmLst = [SELECT ContactId,LeadId FROM CampaignMember WHERE CampaignId = :recid AND (ContactId != NULL OR LeadId != NULL) WITH SECURITY_ENFORCED];
                
                for(CampaignMember cmObject : cmLst){
                    if(cmObject.ContactId != null){
                        lstIds.add(cmObject.ContactId);         		
                    }
                    
                    else if(cmObject.LeadId != null){
                        lstIds.add(cmObject.LeadId);
                    }
                }
           
                   Map<String,Object> serviceCountMap = new Map<String,Object>();
            
            	   Map<String, String> securityMap = new Map<String, String>();
                   securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
                   securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
                   securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
                   securityMap.put('modigie__Validate_Employer_Status__c', 'modigie__Modigie__c');
                   securityMap.put('modigie__Phone_Intelligence_Status__c', 'modigie__Modigie__c');
                   securityMap.put('modigie__Phone_Intelligence_Status_Phone__c', 'modigie__Modigie__c');
                   securityMap.put('modigie__Phone_Intelligence_Status_Other_Phone__c', 'modigie__Modigie__c');
                   securityMap.put('modigie__Status__c', 'modigie__Modigie__c');
                   
                   Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
                   
                   if(check){
                 
                    Integer runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Status__c = 'In process' WITH SECURITY_ENFORCED];
                    Integer validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Status__c = 'Validated' WITH SECURITY_ENFORCED];
                    Integer invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Status__c = 'Not Available' WITH SECURITY_ENFORCED];
                    Integer remaining = totalMembers - runningJobs - validated - invalidated;
                   
                   serviceCountMap.put('Name','Get Modigie');
                   serviceCountMap.put('Running',runningJobs);
                   serviceCountMap.put('Validated',validated);
                   serviceCountMap.put('Invalidated',invalidated);
                   serviceCountMap.put('Remaining',remaining);
                   serviceCountMap.put('TotalMembers',totalMembers);
                   
                   
                   mMap.put('GetModigie',serviceCountMap);
                   lstMap.add(serviceCountMap);


                  

                   serviceCountMap = new Map<String,Object>();
                   
                   runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Validate_Employer_Status__c = 'In process' WITH SECURITY_ENFORCED];
                   validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Validate_Employer_Status__c = 'Validated' WITH SECURITY_ENFORCED];
                   invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Validate_Employer_Status__c = 'Not Available' WITH SECURITY_ENFORCED]; 
                   remaining = totalMembers - runningJobs - validated - invalidated;
                   
                   serviceCountMap.put('Name','Verify Employer');
                   serviceCountMap.put('Running',runningJobs);
                   serviceCountMap.put('Validated',validated);
                   serviceCountMap.put('Remaining',remaining);
                   serviceCountMap.put('Invalidated',invalidated);
                   serviceCountMap.put('TotalMembers',totalMembers);

                   
                   // mMap.put('VerifyEmployer',serviceCountMap);
                    lstMap.add(serviceCountMap);
                   
                    serviceCountMap = new Map<String,Object>();
                    serviceCountMap.put('Name','Get Phone Insights');
                    serviceCountMap.put('isGetPhoneInsights',true);


                   runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status__c  = 'In process' WITH SECURITY_ENFORCED];
                   validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status__c = 'Validated' WITH SECURITY_ENFORCED];
                   invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status__c = 'Not Available' WITH SECURITY_ENFORCED];
                   remaining = totalMembers - runningJobs - validated - invalidated;

                    List<Map<String,Object>> nestedLst = new List<Map<String,Object>>();

                    Map<String,Object> phoneInsightsCountMap = new Map<String,Object>();


                    phoneInsightsCountMap.put('Name','Mobile');
                    phoneInsightsCountMap.put('Running',runningJobs);
                    phoneInsightsCountMap.put('Validated',validated);
                    phoneInsightsCountMap.put('Remaining',remaining);
                    phoneInsightsCountMap.put('Invalidated',invalidated);
                   
                   //mMap.put('GetPhoneIntelligenceMobile',serviceCountMap);
                   
                   nestedLst.add(phoneInsightsCountMap);

                   phoneInsightsCountMap = new Map<String,Object>();

                    runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Phone__c  = 'In process' WITH SECURITY_ENFORCED];
                   validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Phone__c = 'Validated' WITH SECURITY_ENFORCED];
                   invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Phone__c = 'Not Available' WITH SECURITY_ENFORCED];
                   remaining = totalMembers - runningJobs - validated - invalidated;

                    phoneInsightsCountMap.put('Name','Phone');
                    phoneInsightsCountMap.put('Running',runningJobs);
                    phoneInsightsCountMap.put('Validated',validated);
                    phoneInsightsCountMap.put('Remaining',remaining);
                    phoneInsightsCountMap.put('Invalidated',invalidated);
                   
                   //mMap.put('GetPhoneIntelligenceMobile',serviceCountMap);
                   
                   nestedLst.add(phoneInsightsCountMap);
                   
                   phoneInsightsCountMap = new Map<String,Object>();
                   
                   runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Other_Phone__c  = 'In process' WITH SECURITY_ENFORCED];
                   validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Other_Phone__c = 'Validated' WITH SECURITY_ENFORCED];
                   invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Other_Phone__c = 'Not Available' WITH SECURITY_ENFORCED];
                  // Integer totalContacts = [SELECT count() FROM modigie__Modigie__c WHERE Contact__c IN :lstIds];
                   Integer totalContacts = [SELECT count() FROM CampaignMember WHERE ContactId IN :lstIds AND CampaignId = :recid WITH SECURITY_ENFORCED];
                   remaining = totalContacts - runningJobs - validated - invalidated;

                   phoneInsightsCountMap.put('Name','Other Phone');
                   phoneInsightsCountMap.put('Running',runningJobs);
                   phoneInsightsCountMap.put('Validated',validated);
                   phoneInsightsCountMap.put('Remaining',remaining);
                   phoneInsightsCountMap.put('Invalidated',invalidated);
                   
                   
                   nestedLst.add(phoneInsightsCountMap);

                  serviceCountMap.put('GetPhoneInsightsData', nestedLst);

                    lstMap.add(serviceCountMap);

                    serviceCountMap = new Map<String,Object>();

                    runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Linkedin_Status__c = 'In process' WITH SECURITY_ENFORCED];
                    validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Linkedin_Status__c = 'Validated' WITH SECURITY_ENFORCED];
                    invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Linkedin_Status__c = 'Not Available' WITH SECURITY_ENFORCED];
                    remaining = totalMembers - runningJobs - validated - invalidated;
                   
                   serviceCountMap.put('Name','Get LinkedIn');
                   serviceCountMap.put('Running',runningJobs);
                   serviceCountMap.put('Validated',validated);
                   serviceCountMap.put('Invalidated',invalidated);
                   serviceCountMap.put('Remaining',remaining);
                   serviceCountMap.put('TotalMembers',totalMembers);
                  // mMap.put('GetLinkedIn',serviceCountMap);
                   lstMap.add(serviceCountMap);
                         
                   
                    Map<String, Boolean> mUser = new Map<String, Boolean>();
                    List<PermissionSetAssignment> lstUser = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId =:UserInfo.getUserId() AND PermissionSet.NamespacePrefix = 'modigie' AND PermissionSet.Name in ('Modigie_Admin', 'Modigie_User', 'Modigie_Automation_User')];
                    if(lstUser.size() == 0){
                        mUser.put('ModigieUser', false);
                    }else{
                        mUser.put('ModigieUser', true);
                    }
                    lstMap.add(mUser);
                    
               }
            
            else{
                throw new ModigieLightningCampaignTabControllerException('User does not have permission to query modigie object.');   
            }
            
            return JSON.serialize(lstMap);
            
        }
        catch(Exception e){
            throw new ModigieLightningCampaignTabControllerException(e.getMessage());
            
        }
    }

    public class ModigieLightningCampaignTabControllerException extends Exception{}
}