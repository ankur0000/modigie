@isTest
global class MockHttpResponseClientInfoGenerator implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"client": {"url": "https://www.modigie.com","name": "Modigie","credits": 392}}');
        res.setStatusCode(200);
        return res;
    }
}