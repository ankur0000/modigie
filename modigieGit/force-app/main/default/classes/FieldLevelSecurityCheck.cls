global with sharing class FieldLevelSecurityCheck 
{
   private static Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

    global static Boolean checkSecurity(Map<String, String> securityMap)
    {
        
        Boolean var=false;
        try{
            for(String str : securityMap.keySet()){
                
                
                if(FieldLevelSecurityCheck.canReadObject(securityMap.get(str))&&
                   FieldLevelSecurityCheck.canCreateObject(securityMap.get(str))&&
                   FieldLevelSecurityCheck.canUpdateObject(securityMap.get(str))&&
                   FieldLevelSecurityCheck.canReadField(securityMap.get(str), str)&&
                   FieldLevelSecurityCheck.canCreateField(securityMap.get(str), str)&&
                   FieldLevelSecurityCheck.canUpdateField(securityMap.get(str), str)){
                       var = true;
                   }
                else{
                    var = false;
                    break;
                }
            }
        }
        catch(Exception e){
        }
        return var;
    }

    global static Boolean checkSecurityForRead(Map<String, String> securityMap)
    {
        
        Boolean var=false;
        try{
            for(String str : securityMap.keySet()){
                
                
                if(FieldLevelSecurityCheck.canReadObject(securityMap.get(str))&&
                   FieldLevelSecurityCheck.canCreateObject(securityMap.get(str))&&
                   FieldLevelSecurityCheck.canUpdateObject(securityMap.get(str))&&
                   FieldLevelSecurityCheck.canReadField(securityMap.get(str), str)){
                       var = true;
                   }
                else{
                    var = false;
                    break;
                }
            }
        }
        catch(Exception e){
        }
        return var;
    }
    
    global static Boolean canReadObject(String objectName)
    {
        //Schema.DescribeSObjectResult sObjResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Schema.DescribeSObjectResult sObjResult = globalDescribe.get(objectName).getDescribe();
        return sObjResult.isAccessible();
    }
    global static Boolean canReadField(String objectName, String fieldName)
    {
        //Schema.DescribeFieldResult sObjFieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        Schema.DescribeFieldResult sObjFieldResult = globalDescribe.get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        return sObjFieldResult.isAccessible();
    }
    global static Boolean canCreateObject(String objectName)
    {
        //Schema.DescribeSObjectResult sObjResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Schema.DescribeSObjectResult sObjResult = globalDescribe.get(objectName).getDescribe();
        return sObjResult.isCreateable();
    }
    global static Boolean canCreateField(String objectName, String fieldName)
    {
        //Schema.DescribeFieldResult sObjFieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        Schema.DescribeFieldResult sObjFieldResult = globalDescribe.get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        return sObjFieldResult.isCreateable();
    }
    global static Boolean canUpdateObject(String objectName)
    {
        //Schema.DescribeSObjectResult sObjResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Schema.DescribeSObjectResult sObjResult = globalDescribe.get(objectName).getDescribe();
        return sObjResult.isUpdateable();
    }
    global static Boolean canUpdateField(String objectName, String fieldName)
    {
        //Schema.DescribeFieldResult sObjFieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        Schema.DescribeFieldResult sObjFieldResult = globalDescribe.get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        return sObjFieldResult.isUpdateable(); 
    }
    global static Boolean canDeleteObject(String objectName)
    {
        //Schema.DescribeSObjectResult sObjResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Schema.DescribeSObjectResult sObjResult = globalDescribe.get(objectName).getDescribe();
        return sObjResult.isDeletable();
    }

}