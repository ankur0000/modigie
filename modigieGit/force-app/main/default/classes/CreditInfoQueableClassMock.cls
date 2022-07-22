@isTest 
global class CreditInfoQueableClassMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String response = '{ "creditsLeft": 0, "creditsLimit": -10000, "creditsReserved": 16, "creditsTotal": 150, "customerRef": "CustomerAccount/Tc8Ye55fAxAwDyZhD9BN", "discount": 50 }';
        res.setBody(response);
        res.setStatusCode(200);
        return res;
    }
}