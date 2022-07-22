@RESTResource(urlMapping = '/repository')
global class ModigieRepository 
{
	@HTTPPost
    global static void updateModigieRepository()
    {
       	RestRequest req = RestContext.request;
        
        RestResponse res = RestContext.response;
        
        
        String jsonBody = req.requestBody.toString();
        system.debug('jsonBody'+jsonBody);
        try
        {
            ModigieJsonWrapper.repositoryWrapper body=ModigieJsonUtils.updaterepository(jsonBody);
            system.debug('body'+body);
            /*if(body.featureConfig.tom.fromTime==null || body.featureConfig.tom.fromTime=='')
            {
                res.responseBody = Blob.valueOf('fromTime is missing');
                res.statusCode = 400;
                return;
            }
            if(body.featureConfig.tom.untilTime==null || body.featureConfig.tom.untilTime=='')
            {
                res.responseBody = Blob.valueOf('untilTime is missing');
                res.statusCode = 400;
                return;
            }
            if(body.quota.stopReason.message==null)
            {
                res.responseBody = Blob.valueOf('stopReason is missing');
                res.statusCode = 400;
                return;
            }
            if(body.featureConfig.Performance.rulesets.unlockReason.message==null)
            {
                res.responseBody = Blob.valueOf('unlockReason is missing');
                res.statusCode = 400;
                return;
            }*/
            ModigieApiUtils.create_Repository(body);
        }
        catch(Exception e){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Malformed JSON in request body');
			system.debug('e--->'+e.getLineNumber());
            system.debug('e--->'+e.getMessage());
        }
    }
}