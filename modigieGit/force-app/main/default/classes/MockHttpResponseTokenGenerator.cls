@isTest
global class MockHttpResponseTokenGenerator implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"user": {"user_email": "modigie@gmail.com","user_token": "e3d900bc7a5432133dba097cd0eb3e15cb45de4a2c35bae0f89f0f3329dc823f"}}');
        res.setStatusCode(200);
        return res;
    }
}