public class CustomMetadataUtils implements Metadata.DeployCallback {
    @AuraEnabled 
    public static void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            //Success
            System.debug('Success Result-' + result);
        } else {
            //Failed
            System.debug('Failed Result-' + result);
        }
    }

    @AuraEnabled
    public static void updateCustomMetadata (String fullName, String label, Map<String, Object> fieldWithValuesMap){

        Metadata.CustomMetadata cMetadata = new Metadata.CustomMetadata();
        cMetadata.fullName = fullName;
        cMetadata.label = label;
        
        for (String key: fieldWithValuesMap.keySet()) {
        
            Metadata.CustomMetadataValue cMetadataValue = new Metadata.CustomMetadataValue();
            cMetadataValue.Field = key;
            cMetadataValue.Value = fieldWithValuesMap.get(key); 
            cMetadata.values.add(cMetadataValue);
        
        }
        
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        
        mdContainer.addMetadata(cMetadata);
        
        CustomMetadataUtils callback = new CustomMetadataUtils();
        if(!Test.isRunningTest()){
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
            System.debug('Successullly Inserted...........'+jobId);
        }
    }
}