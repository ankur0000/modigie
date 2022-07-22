@isTest
global class MockHttpResponseForEscalation implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status": "success", "jobid": "12345", "escalated_records": 5, "user": {"user_email": "modigie@gmail.com", "user_token": "71ed0fcbb475432139c420351fac831431d635cce831e6fcf09e22dbccbd17"}}');
        res.setStatusCode(200);
        return res;
        
    }
}