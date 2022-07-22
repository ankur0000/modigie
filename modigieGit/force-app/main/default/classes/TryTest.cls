public class TryTest {
    // private static final String BEARER_STRING = 'Bearer ';

    // @Depricated
    // public static String testEndpoint(){
    	
    //    /* Blob headerValue = Blob.valueOf('eyJhbGciOiJSUzI1NiIsImtpZCI6Ijc0NGY2MGU5ZmI1MTVhMmEwMWMxMWViZWIyMjg3MTI4NjA1NDA3MTEiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL21vZGlnaWUtdmFsLWJhY2tlbmQtcGpjZnZoejJxcS11Yy5hLnJ1bi5hcHAiLCJhenAiOiJtb2RpZ2llLXNhbGVzZm9yY2UtYXBwLTNAbW9kaWdpZS1iZXZhbC1kZXYtMi5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImVtYWlsIjoibW9kaWdpZS1zYWxlc2ZvcmNlLWFwcC0zQG1vZGlnaWUtYmV2YWwtZGV2LTIuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiZXhwIjoxNTk3MTYwMzg2LCJpYXQiOjE1OTcxNTY3ODYsImlzcyI6Imh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbSIsInN1YiI6IjExMzA5NjY2ODEyMDYxMDAyMjM2NyJ9.EuLweAvVHFuN7hCyq-JNP7RdvriKBqoxbJ0eCPtLwIk7zm08paRwYsReQ8COWKu3h8B0r2BYe_i0I2G3kBZsEux--1T5XJDGW55deqKHvxxzmY2-2WR18CAw7LPJ8t6djE0CJyAhfIHpfQa8QdGQ42-x2jq7ZDrwyTEhCkae1fYD1l9_s_Czc30KunHi2775qW3oGX2CxHexXr9r51ApaN-8j2ZjCFnAFpW27hOS1yF71CXG_cWK865kmXaZd44VonJFprILxP4XQQXhLsAbeQXbTbScfZCPIKQjBgcu02beS-dOndC0NFLBmufEaVZEBr4ldTqs5RG5QNxVjcs6Qg' + ':');
    //     String authorizationHeader = 'Bearer ' + EncodingUtil.base64Encode(headerValue);
        
        
    //     string url = '&' + EncodingUtil.urlEncode('key', 'UTF-8') + '=' + EncodingUtil.urlEncode('AIzaSyDlol0-ZaUln9pdHbZzOAZb1DEQyOHD9gc', 'UTF-8');
        
    //     Http http = new Http();
        
    //     HttpRequest request = new HttpRequest();
    //     request.setEndpoint('https://modigie-val-gateway-pjcfvhz2qq-uc.a.run.app/api/val/v1/linkedInUrlJobs/ed16b6296e782a7fb2e2cd4317b9e36d7dd79a6231448623f4b761747707745f');
    //     request.setMethod('GET');
    //     request.setTimeout(60000);
    // 	//request.setHeader('Authorization', 'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Ijc0NGY2MGU5ZmI1MTVhMmEwMWMxMWViZWIyMjg3MTI4NjA1NDA3MTEiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL21vZGlnaWUtdmFsLWJhY2tlbmQtcGpjZnZoejJxcS11Yy5hLnJ1bi5hcHAiLCJhenAiOiJtb2RpZ2llLXNhbGVzZm9yY2UtYXBwLTNAbW9kaWdpZS1iZXZhbC1kZXYtMi5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImVtYWlsIjoibW9kaWdpZS1zYWxlc2ZvcmNlLWFwcC0zQG1vZGlnaWUtYmV2YWwtZGV2LTIuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiZXhwIjoxNTk3MTYwMzg2LCJpYXQiOjE1OTcxNTY3ODYsImlzcyI6Imh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbSIsInN1YiI6IjExMzA5NjY2ODEyMDYxMDAyMjM2NyJ9.EuLweAvVHFuN7hCyq-JNP7RdvriKBqoxbJ0eCPtLwIk7zm08paRwYsReQ8COWKu3h8B0r2BYe_i0I2G3kBZsEux--1T5XJDGW55deqKHvxxzmY2-2WR18CAw7LPJ8t6djE0CJyAhfIHpfQa8QdGQ42-x2jq7ZDrwyTEhCkae1fYD1l9_s_Czc30KunHi2775qW3oGX2CxHexXr9r51ApaN-8j2ZjCFnAFpW27hOS1yF71CXG_cWK865kmXaZd44VonJFprILxP4XQQXhLsAbeQXbTbScfZCPIKQjBgcu02beS-dOndC0NFLBmufEaVZEBr4ldTqs5RG5QNxVjcs6Qg');
    //     request.setHeader('Authorization', authorizationHeader);
    //     request.setBody(url);
    //     HttpResponse response = http.send(request);
    //     // Parse the JSON response*/
    //     String URL = 'https://modigie-val-gateway-pjcfvhz2qq-uc.a.run.app/api/val/v1/linkedInUrlJobs/ed16b6296e782a7fb2e2cd4317b9e36d7dd79a6231448623f4b761747707745f?key=AIzaSyDlol0-ZaUln9pdHbZzOAZb1DEQyOHD9gc';
		
        
    //     //String endpoint = 'https://modigie-val-gateway-pjcfvhz2qq-uc.a.run.app/api/val/v1/linkedInUrlJobs/ed16b6296e782a7fb2e2cd4317b9e36d7dd79a6231448623f4b761747707745f';
    //     //String body = 'key='+'AIzaSyDlol0-ZaUln9pdHbZzOAZb1DEQyOHD9gc';
    //     HttpRequest req = new HttpRequest();
    //     req.setTimeout(60000);
    //     req.setEndpoint(URL);
    //     //req.setEndpoint(endpoint);
    //     req.setMethod('GET');
    //     //req.setbody(body);
    //     Http http = new Http();
    //     HTTPResponse response = http.send(req);
        
    //     return response.getBody();
    // }


    // @Depricated
    // public static void testAPI(){
       
        
    //     String url = 'https://modigie-val-gateway-pjcfvhz2qq-uc.a.run.app/api/val/v1/linkedInUrlJobs?key=AIzaSyDlol0-ZaUln9pdHbZzOAZb1DEQyOHD9gc';
    //     Http http = new Http();
    //     HttpRequest request = new HttpRequest();
    //     request.setEndpoint(url);
    //     request.setMethod('POST');
    //     request.setTimeout(60000);
    //     request.setHeader('content-type','application/json');
    //     request.setHeader('Authorization', 'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImJjNDk1MzBlMWZmOTA4M2RkNWVlYWEwNmJlMmNlNDM3ZjQ5YzkwNWUiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL21vZGlnaWUtdmFsLWJhY2tlbmQtcGpjZnZoejJxcS11Yy5hLnJ1bi5hcHAiLCJhenAiOiJtb2RpZ2llLXNhbGVzZm9yY2UtYXBwLTNAbW9kaWdpZS1iZXZhbC1kZXYtMi5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImVtYWlsIjoibW9kaWdpZS1zYWxlc2ZvcmNlLWFwcC0zQG1vZGlnaWUtYmV2YWwtZGV2LTIuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiZXhwIjoxNTk4ODY4MDY0LCJpYXQiOjE1OTg4NjQ0NjQsImlzcyI6Imh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbSIsInN1YiI6IjExMzA5NjY2ODEyMDYxMDAyMjM2NyJ9.TM7bO4Zr595dKdmtvRVkyeevOqPAbgJzaHQARVIndaM4iEtvEcc4xhelrFkz50JERbok29-TduOiPFbMxmeePQtHPfwex06BH44l6T7FTKjHhfqF1KOFVv4ar9BQT2Xi-vGWPFWL5IIUJw_9oiyGiroIkvdQ9TGQjitFMyRyUFL7_6Dg-GUgkKuvonJcLCa3PtJ7gfCav4H4LCtrV9BF-ZmK_7CCIkU_vRl__r3giN6qpFsQYi5VwKHhowQn-9rOgostPvFBR5L07Xw1EYD_tOyF360E0pqu_gTWYhQ85_Z32qtPwfuNehty0_GtK6JUXF0UHjdBzya8NCMpgoL4Yw');
    //     request.setBody('{ "creditsId": "bhDZAiA0XNVnEV8u1qoL", "contacts": [ { "company": "James B Nutter", "customParameters" :[{"name":"recidOrdgId", "value":"sampleId12"}], "firstName": "Cheryl", "lastName": "Jones", "linkedInUrl": "https://www.linkedin.com/in/cheryl-jones-b58bb111", "companyEmail":"cheryl.jones@jbnutter.com", "mobilePhones":["+18169357690"] } ] }');
    //     HttpResponse response = http.send(request);

    // }

}    
    /*public static String method2(){
        string chargeUrl = billingUtility.baseurl + '/v1/charges';
        amount = ((amount)*100);
        Integer stripeAmt = Integer.valueOf(amount);
        HttpRequest http = new HttpRequest();
        http.setEndpoint(chargeUrl);
        http.setMethod('POST');
        Blob headerValue = Blob.valueOf(billingUtility.apiKey + ':');
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
       
        string url = '&' + EncodingUtil.urlEncode('customer', 'UTF-8') + '=' + EncodingUtil.urlEncode(customerId, 'UTF-8') + '&';
        url += EncodingUtil.urlEncode('amount', 'UTF-8') + '=' + EncodingUtil.urlEncode(string.valueOf(stripeAmt), 'UTF-8') + '&';
        url += EncodingUtil.urlEncode('currency', 'UTF-8') + '=' + EncodingUtil.urlEncode(string.valueOf(currencyCode), 'UTF-8') + '&';
       
        http.setBody(url);
       
        Integer statusCode;
        Http con = new Http();
        HttpResponse hs = new HttpResponse();
       
        hs = con.send(http);

    }*/