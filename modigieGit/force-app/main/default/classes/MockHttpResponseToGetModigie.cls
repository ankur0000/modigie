@isTest
global class MockHttpResponseToGetModigie implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}');
        res.setStatusCode(200);
        return res;
        
    }
}