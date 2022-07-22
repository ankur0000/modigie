@isTest
global class MockHttpResponseToCheckEscalation implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status": "VALIDATED","user": {"user_email": "modigie@gmail.com","user_token": "71ed0fcbb475432139c420351fac831431d635cce831e6fcf09e22dbccbd17","company_url": "https://www.linkedin.com/in/modigie"},"person": {"first_name": "Laura","last_name": "Lim","email": "laura.lim@salesforce.com","company": "Saleforce","linkedin_url": "https://www.linkedin.com/in/laura-lim"},"results": {"jobid": "12345","client": "modigie.com","phone_1": "946537","phone_2": "258963"}}');
        res.setStatusCode(200);
        return res;
        
    }
}