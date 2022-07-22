/************************************************************************ 
*  @authors Taurun Gyanchandani
*  @date    15 July 2020
*  @name    ModigieCreditInfoClass
*  @description This class is used before every modigie contact enrichment API to ensure the credits so that user can make callouts when user press any of the four services button.
***********************************************************************/ 
public with sharing class ModigieCreditInfoClass {
    
    
/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    15 July 2020
*  @name   makeCreditInfoGetCallout (Action Method)
*  @return returns a Continuation object.
***********************************************************************/ 
    
    // @Depricated
    // public static Integer makeCreditInfoGetCallout(){
    //     List<modigie__Modigie_Credentials__c> modigieCredential = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1]; 
    //     String accesstoken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Service_Account_Credentials__c, 'https://modigie-credits-backend-bqqdnyh5lq-uc.a.run.app', modigieCredential[0].modigie__Private_Key__c);
    //     //String accesstoken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Service_Account_Credentials__c, 'https://modigie-credits-backend-kyaxv4ttua-uc.a.run.app', modigieCredential[0].modigie__Private_Key__c);
        
    //     Http http = new Http();
    //     HttpRequest request = new HttpRequest();
    //     request.setMethod('GET');
    //     //request.setHeader('Content-Type', ' application/json');
    //     request.setHeader('Authorization', accesstoken);
    //     request.setHeader('x-api-key', modigieCredential[0].modigie__Api_key__c);
    //     request.setEndpoint('https://modigie-credits-gateway-bqqdnyh5lq-uc.a.run.app/api/v1/credits/' + modigieCredential[0].modigie__Credits_Account_Id__c); //Production Environment Endpoints
    //     //request.setEndpoint('https://modigie-credits-gateway-kyaxv4ttua-uc.a.run.app/api/v1/credits/' + modigieCredential[0].modigie__Credits_Account_Id__c + '?key=' + modigieCredential[0].modigie__Api_key__c); //Staging Environment Endpoints
    //     request.setTimeout(60000);
    //     HttpResponse response = http.send(request);
        
    //     //request.setEndpoint('https://modigie-credits-gateway-pjcfvhz2qq-uc.a.run.app/api/val/v1/credits/iisBqmpPxHp2bnH6Di0W?key=AIzaSyBLc3OdT_waobCALoDVF1GzKKbRHWrDDts');
        
    //     String responseBody = response.getBody();
    //     Map<String,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(responseBody);
        
    //     //String response = '{ "creditsLeft": 120, "creditsLimit": -10000, "creditsReserved": 16, "creditsTotal": 22000, "customerRef": "CustomerAccount/Tc8Ye55fAxAwDyZhD9BN", "discount": 50 }';
    //     //Map<String,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(response);
        
    //     Integer remainingCredits = (Integer)resMap.get('creditsLeft');
        
    //     return remainingCredits;
    // }


    // @Depricated
    // public static void saveCreditInfoAfterCallout(){
    //     List<modigie__Modigie_Credentials__c> modigieCredential = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1]; 
    //     String accesstoken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Service_Account_Credentials__c, 'https://modigie-credits-backend-bqqdnyh5lq-uc.a.run.app', modigieCredential[0].modigie__Private_Key__c);
        
    //     Http http = new Http();
    //     HttpRequest request = new HttpRequest();
    //     request.setMethod('GET');
    //     //request.setHeader('Content-Type', ' application/json');
    //     request.setHeader('Authorization', accesstoken);
    //     request.setHeader('x-api-key', modigieCredential[0].modigie__Api_key__c);
    //     request.setEndpoint('https://modigie-credits-gateway-bqqdnyh5lq-uc.a.run.app/api/v1/credits/' + modigieCredential[0].modigie__Credits_Account_Id__c);
    //     //request.setEndpoint('https://modigie-credits-gateway-pjcfvhz2qq-uc.a.run.app/api/val/v1/credits/iisBqmpPxHp2bnH6Di0W?key=AIzaSyBLc3OdT_waobCALoDVF1GzKKbRHWrDDts');
    //     request.setTimeout(60000);
    //     HttpResponse response = http.send(request);
        
    //     //request.setEndpoint('https://modigie-credits-gateway-pjcfvhz2qq-uc.a.run.app/api/val/v1/credits/iisBqmpPxHp2bnH6Di0W?key=AIzaSyBLc3OdT_waobCALoDVF1GzKKbRHWrDDts');
        
    //     String responseBody = response.getBody();
    //     Map<String,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(responseBody);
        
    //     //String response = '{ "creditsLeft": 0, "creditsLimit": -10000, "creditsReserved": 16, "creditsTotal": 150, "customerRef": "CustomerAccount/Tc8Ye55fAxAwDyZhD9BN", "discount": 50 }';
    //     //Map<String,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(response);
        
    //     Integer remainingCredits = (Integer)resMap.get('creditsLeft');
    //     Integer purchasedCredits = (Integer)resMap.get('creditsTotal');
    //     List<modigie__Modigie_Credit__c> modiCredit = [SELECT Name,  modigie__Validation_Key__c, modigie__Date_Last_Synced__c,modigie__Remaining_Credits__c FROM modigie__Modigie_Credit__c WITH SECURITY_ENFORCED LIMIT 1];
        
    //     Map<String, String> securityMap = new Map<String, String>();
        
    //     securityMap.put('modigie__Remaining_Credits__c', 'modigie__Modigie_Credit__c');
    //     securityMap.put('modigie__Date_Last_Synced__c', 'modigie__Modigie_Credit__c');
    //     securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie_Credit__c');
    //     securityMap.put('modigie__Purchased__c', 'modigie__Modigie_Credit__c');
    //     securityMap.put('modigie__Used__c', 'modigie__Modigie_Credit__c');
        
    //     Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
    //     if(modiCredit.size() > 0){
    //         modiCredit[0].modigie__Remaining_Credits__c = remainingCredits;
    //         modiCredit[0].modigie__Date_Last_Synced__c = System.today();
    //         modiCredit[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
    //         modiCredit[0].modigie__Purchased__c = purchasedCredits;
    //         modiCredit[0].modigie__Used__c = purchasedCredits - remainingCredits;
    //     }
        
    //     if(check){
    //     update modiCredit;
    //     }
    // }
    
    
}