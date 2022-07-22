global with sharing class CreditInfoQueableClass implements System.Queueable, Database.AllowsCallouts{
    
    
    global void execute(System.QueueableContext objContext)
    {
        try{
           
            
            //do your @Future stuff here with this.key2val
            List<modigie__Modigie_Service_Account__mdt> modigieCredential = ModigieApiUtils.getServiceAccountDetails();
            String accesstoken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Email__c, 'https://modigie-credits-backend-bqqdnyh5lq-uc.a.run.app', modigieCredential[0].modigie__Private_Key__c);
            //String accesstoken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Service_Account_Credentials__c, 'https://modigie-credits-backend-kyaxv4ttua-uc.a.run.app', modigieCredential[0].modigie__Private_Key__c);
            
            List<modigie__creditAccountUsers__c> cau = [SELECT Id, Name, modigie__Credit_Id__c FROM modigie__creditAccountUsers__c
                                                  WHERE modigie__User_Id__c =: Userinfo.getUserId() LIMIT 1];
            String creditAccountId;
            if(!cau.isEmpty()){
                creditAccountId = cau[0].modigie__Credit_Id__c;
            }
            else{
                List<modigie__creditAccountDetails__c> cad = [SELECT Id, Name, modigie__Credit_Id__c, modigie__Default__c FROM modigie__creditAccountDetails__c
                                                        WHERE modigie__Default__c = true LIMIT 1];
                if(!cad.isEmpty()){
                creditAccountId = cad[0].modigie__Credit_Id__c;
                }
            }

            Http http = new Http();
            HttpRequest request = new HttpRequest(); 
            request.setMethod('GET');
            request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c); 
            request.setHeader('Authorization', accesstoken);
            request.setEndpoint('https://modigie-credits-gateway-bqqdnyh5lq-uc.a.run.app/api/v1/credits/' + creditAccountId);// Production Environment Endpoints
            //request.setEndpoint('https://modigie-credits-gateway-kyaxv4ttua-uc.a.run.app/api/v1/credits/' + modigieCredential[0].modigie__Credits_Account_Id__c + '?key=' + modigieCredential[0].modigie__Api_key__c); Staging Enviroment Endpoints
        
            request.setTimeout(120000);
            HttpResponse response = http.send(request);
            
            String responseBody = response.getBody();
            Map<String,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(responseBody);
            
            Map<String,Object> resMap2 = (Map<String,Object>)resMap.get('balance');
 
            Integer remainingCredits = decimal.valueOf((String)resMap2.get('amount')).intValue();
            
            
            //Integer remainingCredits = (Integer)resMap2.get('amount');
            
            Integer purchasedCredits = (Integer)resMap.get('creditsTotal');
            Integer creditsReserved = (Integer)resMap.get('creditsReserved');
            List<modigie__Modigie_Credit__c> modiCredit = [SELECT Name,  modigie__Validation_Key__c, modigie__Reserved__c, modigie__Date_Last_Synced__c,modigie__Remaining_Credits__c FROM modigie__Modigie_Credit__c WITH SECURITY_ENFORCED LIMIT 1];
            
            

                
                modigie__Modigie_Credit__c creditsToUpsert = new modigie__Modigie_Credit__c();
                
                if(modiCredit.size() > 0){
                    creditsToUpsert.Id = modiCredit[0].Id;
                }
                
                creditsToUpsert.modigie__Remaining_Credits__c = remainingCredits;
                creditsToUpsert.modigie__Date_Last_Synced__c = System.today();
                creditsToUpsert.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                creditsToUpsert.modigie__Purchased__c = purchasedCredits;
                creditsToUpsert.modigie__Used__c = purchasedCredits - remainingCredits;
                creditsToUpsert.modigie__Reserved__c = creditsReserved;
                if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credit__c')&&
                FieldLevelSecurityCheck.canCreateObject('modigie__Modigie_Credit__c')&&
                FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Credit__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Remaining_Credits__c')&&
                FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credit__c','modigie__Remaining_Credits__c')&&
                FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Remaining_Credits__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c')&&
                FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c')&&
                FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Validation_Key__c')&&
                FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credit__c','modigie__Validation_Key__c')&&
                FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Validation_Key__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Purchased__c')&&
                FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credit__c','modigie__Purchased__c')&&
                FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Purchased__c')&&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Used__c')&&
                FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credit__c','modigie__Used__c')&&
                FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Used__c') &&
                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Reserved__c')&&
                FieldLevelSecurityCheck.canCreateField('modigie__Modigie_Credit__c','modigie__Reserved__c')&&
                 FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Credit__c','modigie__Reserved__c'))
                {
                    upsert creditsToUpsert;
                }
                else{
                    throw new CreditInfoQueableClassException('User does not have permission to edit modigie credit object.');
                }
        }
        catch(Exception e){
        }
    }
    global class CreditInfoQueableClassException extends Exception{}
}