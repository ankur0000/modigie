@RESTResource(urlMapping = '/creditAccount')
global class ModigieCreditAccounts {
	@HTTPPost
    global static void updateModigieCreditAccounts(){
        RestRequest req = RestContext.request;
        
        RestResponse res = RestContext.response;
        
        
        String jsonBody = req.requestBody.toString();
        try{
            
            ModigieJsonWrapper.itemsWrapper body=ModigieJsonUtils.createCreditAccount(jsonBody);
            
            /*if(body.balance.amount==null)
            {
                res.responseBody = Blob.valueOf('amount is missing');
                res.statusCode = 400;
                return;
            }
            if(body.id==null)
            {
                res.responseBody = Blob.valueOf('id is missing');
                res.statusCode = 400;
                return;
            }
            if(body.currency_x.code==null)
            {
                res.responseBody = Blob.valueOf('Currency code is missing');
                res.statusCode = 400;
                return;
            }
            if(body.status==null)
            {
                res.responseBody = Blob.valueOf('Status is missing');
                res.statusCode = 400;
                return;
            }
            if(body.Title==null)
            {
                res.responseBody = Blob.valueOf('Title is missing');
                res.statusCode = 400;
                return;
            }
            if(body.quota.stopReason.message==null)
            {
                res.responseBody = Blob.valueOf('message is missing');
                res.statusCode = 400;
                return;
            }
            if(body.updateTime==null)
            {
                res.responseBody = Blob.valueOf('updateTime is missing');
                res.statusCode = 400;
                return;
            }*/
            
            ModigieApiUtils.createCredit_Account(body);
        }
        catch(Exception e){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Malformed JSON in request body');
			system.debug('e--->'+e.getLineNumber());
            system.debug('e--->'+e.getMessage());
        }
        
    }
}