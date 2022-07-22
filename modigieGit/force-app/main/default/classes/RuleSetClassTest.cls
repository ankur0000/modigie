@isTest
public class RuleSetClassTest {

    @isTest
    public static void testGetAnalysisPreSave(){
        List<Map<String,String>> leadcriteriaData = new List<Map<String,String>> {
            new Map<String,String> {'CriteriaValue'=> 'Test', 'SelectedOperator'=> 'nct', 'SelectedField'=> 'title'},
            new Map<String,String> {'CriteriaValue'=> 'Test;;Non;;Enrich;;Abacas', 'SelectedOperator'=> 'equals', 'SelectedField'=> 'firstname'},
            new Map<String,String> {'CriteriaValue'=> '22498439', 'SelectedOperator'=> 'gte', 'SelectedField'=> 'numberofemployees'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'equals', 'SelectedField'=> 'createddate'},
            new Map<String,String> {'CriteriaValue'=> 'True', 'SelectedOperator'=> 'null', 'SelectedField'=> 'donotcall'},
            new Map<String,String> {'CriteriaValue'=> 'Test;;Non;;Enrich;;Abacas', 'SelectedOperator'=> 'notEquals', 'SelectedField'=> 'firstname'},
            new Map<String,String> {'CriteriaValue'=> 'www', 'SelectedOperator'=> 'sw', 'SelectedField'=> 'lastname'},
            new Map<String,String> {'CriteriaValue'=> '69426938', 'SelectedOperator'=> 'equals', 'SelectedField'=> 'mobilephone'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'notEquals', 'SelectedField'=> 'lastmodifieddate'},
            new Map<String,String> {'CriteriaValue'=> 'A,B,C,D', 'SelectedOperator'=> 'equals', 'SelectedField'=> 'status'},
            new Map<String,String> {'CriteriaValue'=> 'E,F,G,H', 'SelectedOperator'=> 'notEquals', 'SelectedField'=> 'status'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'lt', 'SelectedField'=> 'lastmodifieddate'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'lte', 'SelectedField'=> 'lastmodifieddate'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'gt', 'SelectedField'=> 'lastmodifieddate'},
            new Map<String,String> {'CriteriaValue'=> 'True', 'SelectedOperator'=> 'equals', 'SelectedField'=> 'donotcall'},
            new Map<String,String> {'CriteriaValue'=> 'False', 'SelectedOperator'=> 'notEquals', 'SelectedField'=> 'donotcall'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'gte', 'SelectedField'=> 'lastmodifieddate'}
        };
        List<Map<String,String>> conCriteriaData = new List<Map<String,String>> {
            new Map<String,String> {'CriteriaValue'=> 'Test', 'SelectedOperator'=> 'nct', 'SelectedField'=> 'title'},
            new Map<String,String> {'CriteriaValue'=> 'Test;;Non;;Enrich;;Abacas', 'SelectedOperator'=> 'equals', 'SelectedField'=> 'firstname'},
            new Map<String,String> {'CriteriaValue'=> '1999-07-12', 'SelectedOperator'=> 'gte', 'SelectedField'=> 'birthdate'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'equals', 'SelectedField'=> 'createddate'},
            new Map<String,String> {'CriteriaValue'=> 'True', 'SelectedOperator'=> 'null', 'SelectedField'=> 'donotcall'},
            new Map<String,String> {'CriteriaValue'=> 'Test;;Non;;Enrich;;Abacas', 'SelectedOperator'=> 'notEquals', 'SelectedField'=> 'firstname'},
            new Map<String,String> {'CriteriaValue'=> 'www', 'SelectedOperator'=> 'sw', 'SelectedField'=> 'lastname'},
            new Map<String,String> {'CriteriaValue'=> '69426938', 'SelectedOperator'=> 'equals', 'SelectedField'=> 'mobilephone'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'notEquals', 'SelectedField'=> 'lastmodifieddate'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'lt', 'SelectedField'=> 'lastmodifieddate'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'lte', 'SelectedField'=> 'lastmodifieddate'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'gt', 'SelectedField'=> 'lastmodifieddate'},
            new Map<String,String> {'CriteriaValue'=> 'A,B,C,D', 'SelectedOperator'=> 'equals', 'SelectedField'=> 'cleanstatus'},
            new Map<String,String> {'CriteriaValue'=> 'E,F,G,H', 'SelectedOperator'=> 'notEquals', 'SelectedField'=> 'cleanstatus'},
            new Map<String,String> {'CriteriaValue'=> 'True', 'SelectedOperator'=> 'equals', 'SelectedField'=> 'donotcall'},
            new Map<String,String> {'CriteriaValue'=> 'False', 'SelectedOperator'=> 'notEquals', 'SelectedField'=> 'donotcall'},
            new Map<String,String> {'CriteriaValue'=> '2022-04-04', 'SelectedOperator'=> 'gte', 'SelectedField'=> 'lastmodifieddate'}
        };
        List<List<Map<String,String>>> criteriaData = new List<List<Map<String,String>>> { leadcriteriaData, conCriteriaData };

        List<String> logicCriteria = new List<String>();
        logicCriteria.add('3');
        logicCriteria.add('1 AND 2 AND (3 OR 4 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11) AND 5 AND 12 AND 13 AND 14 AND 15 AND 16 AND 17');
        logicCriteria.add('3');
        logicCriteria.add('1 AND 2 AND (3 OR 4 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11) AND 5 AND 12 AND 13 AND 14 AND 15 AND 16 AND 17');
        Test.startTest();
        Map<String, Object> mapResult = RuleSetClass.getAnalysisPreSave(criteriaData, logicCriteria, false);
        System.debug('mapResult -> ' + mapResult);
        Test.stopTest();
        System.assert(!mapResult.isEmpty());
    }
    
    @isTest
    public static void testGetAnalysis(){
        RuleSetFactoryTest.insertAnalysisUseCase('Test0');
        RuleSetFactoryTest.insertUseCase('Test1');
        Test.startTest();
        Map<String, Object> mapResult = RuleSetClass.getAnalysis([SELECT Id FROM modigie__Modigie_Rule_Sets__c WHERE modigie__Rule_Set_Name__c = 'Test0' LIMIT 1].id);
        mapResult = RuleSetClass.getAnalysis([SELECT Id FROM modigie__Modigie_Rule_Sets__c WHERE modigie__Rule_Set_Name__c = 'Test1' LIMIT 1].id);
        System.debug('mapResult -> ' + mapResult);
        Test.stopTest();
        System.assert(!mapResult.isEmpty());
    }

    @isTest
    public static void testGetRuleSetQueryLogic(){
        RuleSetFactoryTest.insertUseCase('Test');
        Test.startTest();
        String leadLogic = RuleSetClass.GetRuleSetQueryLogic([SELECT Id FROM modigie__Modigie_Rule_Sets__c LIMIT 1].id, 'Lead');
        String conLogic = RuleSetClass.GetRuleSetQueryLogic([SELECT Id FROM modigie__Modigie_Rule_Sets__c LIMIT 1].id, 'Contact');
        Test.stopTest();
        System.assert(leadLogic != null && conLogic != null);
    }

    @isTest
    public static void testGetCurrentQueue(){
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        fieldWithValuesMap.put('modigie__API_Key__c', GetModigieButtonTest.generateRandomString(72));
        fieldWithValuesMap.put('modigie__Email__c', 'test@invalid.test');
        fieldWithValuesMap.put('modigie__Customer_ID__c', GetModigieButtonTest.generateRandomString(18));
        fieldWithValuesMap.put('modigie__Private_Key__c', 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmCAs751eesgN+\nIdJNhXIcwvqFDkK/dtUEqFvDs4QhzuObkwSpNVxdcHWTJtPdQf6wNp3eqShMC+3u\nUYq2gp2I3I56Ez0QzYjriKH4fmU88ooTqZKqGGNYUaTv1e8V8RGxuhRJYGeIhrm+\nevURGTU4W0P15A4+ULNBY3W7CWO0w8yyy3Mgqf7aWopvPvAiLIlyvvZfPv9R1Du+\nYTyU0cu0RsTlSv1KuEVvYUbA1rlURX2EXlWgMeHPiTW3oHsmC88kYDxYwvAzaE66\nfuGLd6MCfh3w6EJKSj90CV2gzBdI4OZ6JqK21uoFPOywlYBaPrmDdpzBJ2i5fp08\nM550aczRAgMBAAECggEACBgJiymtm/EH6k7WCJ0uKVCIg7LEpn6RpyTZd16BnR/P\nuPp3blPJfU0hkDNC/gzs8HRzKQMEUcO9nUH4ognXSfAdmn4kWpS4fWn3Ymyv/QMC\nX+/C9HuUoT42rRH38jECuLAuc77JQU63EJ4AIy2gSm9pjlvIJXnL6U7C0yPDqnDS\ngLY2VmakgH2GcxpQlxp3CpQfL+RqOLZPah+FTBS+JEDkIAOJkLaNi/1DOTLxi5e2\nGh3QEAs2NfeatxY/VLQvkKRqVyHyh+d+raSX9Kd/+hdpsFDYN96xcg4IgGxcty8p\nGAk5biBcToA81WVI++k9o8HlCkEDOT7QhRvqE4RCOQKBgQDZ30JlaJDVOHJxhXvZ\nrLFHb5RIGKBaLrv+3/4VqxNwErJKTo39E0IjScWoL95TBs3K/lXtuOzTrBJ923/7\nYzrzGxsXm8V2JoU01OhudDNj9+ImzTOU0i+yqNmFv4CabMC03pxd7C2Bvdo6cPmZ\n2dy71skxP0AYZacVt15W2FK4iQKBgQDDFk4a8PYBC/v+deU0+W2qHZiTVOJnjFxY\nwjo2etfAM9oFG7fgVeaXu1pbnLSr7mUP21imajzPyMsWt2vQ9wc0fdu/AGAC8QKq\nRFuT0D8T1b5O13YDuFqMF72++9F4oR8FB8xME0PHqaY82YvIwhcL/NKyI3+Hg+fk\n9GMU/oLQCQKBgQCTD+VUaCGjGwf84po30x6S1pkjlSPf273gC7gJTkG/m48nIyEq\nm25APZKitTT/nA8bH1RHM1UAiByvQZOAz3lCEaDW7bl6yAOQJsqBjAQITZEkmcxg\nfwPdN6YkZqBbHF9zdvPbXglVkx4T5qBEnk8lp5SEnmoYTb1bpjuSqVAk6QKBgDLT\nMtIOCOlI6APpTye3+/wf7cokiT+U79In9+aNpnvqhlhiWktV1ded9fJ8Jw3L9ARn\njvb8Io+3rkFi0/IDCZuBVqiyPlFF3P3jBUDDNkvCmewMcjCR7PUmkkaZcH9O6rfy\nyiTft/7ike60dph9CGgVHAdQ/D6f/OBHUzD7BbWRAoGAJJRjruSl0CVFfkNVE57O\n8+CKVyECaVbw56kXK4Hg+K9k89EdYvdAHwWkt4cWx7/RzkEh08t+vCyqx3+CINQF\nLTRWFOEjGdQP03ky6vt9RyYrFZJVEzRNfyuKyGH43GqXDCNyd75qAQlkkXNrAd9L\nSZhLfx3r4R4BcjMHjsZN+DA');
      	CustomMetadataUtils.updateCustomMetadata('Modigie_Service_Account.Default_Service_Credential','Default_Service_Credential',fieldWithValuesMap);            
	
        RuleSetFactoryTest.insertUseCase('Test');
        RuleSetFactoryTest.createQueue('Test', 'both');
        Test.startTest();
        Integer currentQueue = RuleSetClass.getCurrentQueue([SELECT Id FROM modigie__Modigie_Rule_Sets__c LIMIT 1].id);
        Test.stopTest();
        System.assert(currentQueue > 0);
    }

    @isTest
    public static void testGetRuleSetName(){
        RuleSetFactoryTest.insertUseCase('Test');
        Test.startTest();
        String ruleName = RuleSetClass.GetRuleSetName([SELECT Id FROM modigie__Modigie_Rule_Sets__c LIMIT 1].id);
        Test.stopTest();
        System.assert(ruleName == 'Test');
    }
}