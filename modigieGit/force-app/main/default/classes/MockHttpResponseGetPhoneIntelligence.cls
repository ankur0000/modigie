@isTest
global class MockHttpResponseGetPhoneIntelligence implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "", "custom2": "", "custom3": "", "errors": [], "id": "94062e4b91f82506e576db365b6201c4d5cabf5214af9746f9990cb3f4a81400", "name": "/api/val/v1/phoneIntelJobs/94062e4b91f82506e576db365b6201c4d5cabf5214af9746f9990cb3f4a81400", "requestId": "", "results": [], "status": "accepted"}');
        res.setStatusCode(200);
        return res;
    }
}