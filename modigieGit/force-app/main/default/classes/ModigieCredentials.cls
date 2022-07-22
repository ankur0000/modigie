@RESTResource(urlMapping = '/credential')
global class ModigieCredentials {
    @HTTPPost
    global static void updateModigieCredentials(){
        RestRequest req = RestContext.request;
        
        RestResponse res = RestContext.response;
        
        
        String jsonBody = req.requestBody.toString();
        system.debug('jsonBody'+jsonBody);
        try{
            ModigieJsonWrapper.ModigieCredentials body = ModigieJsonUtils.updateModigieCredentials(jsonBody);
            /*if(body.apiKey.keyString==null || body.apiKey.keyString=='')
            {
                res.responseBody = Blob.valueOf('KeyString is missing');
                res.statusCode = 400;
                return;
            }
            if(body.serviceAccount.clientEmail==null || body.serviceAccount.clientEmail=='')
            {
                res.responseBody = Blob.valueOf('clientEmail is missing');
                res.statusCode = 400;
                return;
            }
            if(body.serviceAccount.privateKey==null || body.serviceAccount.privateKey=='')
            {
                res.responseBody = Blob.valueOf('privateKey is missing');
                res.statusCode = 400;
                return;
            }
            if(body.updateTime==null)
            {
                res.responseBody = Blob.valueOf('updateTime is missing');
                res.statusCode = 400;
                return;
            }*/
            AuthorizationClass.saveAuthenticationCredentials(body.apiKey.keyString, body.serviceAccount.clientEmail, body.serviceAccount.privateKey,body.updateTime);
        }
        catch(Exception e){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Malformed JSON in request body');
            system.debug('e'+e.getMessage());
            system.debug('e'+e.getStackTraceString());
        }
        
    }
}