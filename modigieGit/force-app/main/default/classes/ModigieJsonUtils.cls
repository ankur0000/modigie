public class ModigieJsonUtils {
    // Modigie Credit List Data
    public  static ModigieJsonWrapper.creditListWrapper getCreditList(String jsonResponse) {
        jsonResponse=jsonResponse.replaceALL('"currency":', '"currency_x":');
        ModigieJsonWrapper.creditListWrapper creditListWrpResponse = (ModigieJsonWrapper.creditListWrapper)JSON.deserialize(jsonResponse, ModigieJsonWrapper.creditListWrapper.class);
        return creditListWrpResponse;
    }
    
    
    public  static ModigieJsonWrapper.itemsWrapper createCreditAccount(String jsonResponse) {
        jsonResponse=jsonResponse.replaceALL('"currency":', '"currency_x":');
        ModigieJsonWrapper.itemsWrapper creditListWrpResponse = (ModigieJsonWrapper.itemsWrapper)JSON.deserialize(jsonResponse, ModigieJsonWrapper.itemsWrapper.class);
        return creditListWrpResponse;
    }
    
    public  static ModigieJsonWrapper.ModigieCredentials updateModigieCredentials(String jsonResponse) {
        jsonResponse=jsonResponse.replaceALL('"currency":', '"currency_x":');
        ModigieJsonWrapper.ModigieCredentials creditListWrpResponse = (ModigieJsonWrapper.ModigieCredentials)JSON.deserialize(jsonResponse, ModigieJsonWrapper.ModigieCredentials.class);
        return creditListWrpResponse;
    }
    
    public  static ModigieJsonWrapper.repositoryWrapper updaterepository(String jsonResponse) {
        jsonResponse=jsonResponse.replaceALL('"currency":', '"currency_x":');
        ModigieJsonWrapper.repositoryWrapper repositoryWrpResponse = (ModigieJsonWrapper.repositoryWrapper)JSON.deserialize(jsonResponse, ModigieJsonWrapper.repositoryWrapper.class);
        return repositoryWrpResponse;
    }
}