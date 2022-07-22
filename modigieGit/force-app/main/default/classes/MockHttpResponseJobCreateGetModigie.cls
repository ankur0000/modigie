@isTest
global class MockHttpResponseJobCreateGetModigie implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint().contains('oauth2/v4/token')){
            res.setHeader('Content-Type', 'application/json');
            String response = '{"id_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjJjNmZhNmY1OTUwYTdjZTQ2NWZeXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL21vZGlnaWUtZW5nY2RpZ2llLWJhY2tlbmQtdXMtMS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJleHAiOjE2MDExMDU2MDgsImlhdCI6MTYwMTEwMjAwOCwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tIiwic3ViIjoiMTAyODk2MDkzNTY0MTU1NDM5OTU0In0.Rw_JO6gUlEsLwzZ2_YuC0IsuSp87ug3LF7k__6Ul28M49EgK6Jepaq7SeZvVJZ4p3K9Zq_PRhjRIpdvDU8XLyVmdWFT7D173ILhSglr0V5NeawpGAYz4AC2eu6HqouCz_jDvzW6CFZQsoDOPr1mR7cVVFN59YYR6D4VSaCEbk7PuRwjPZH5nJCzVMVCiKbHmC70tIQZk4eKBa3cLKJBvY3_7lRDUcNlN"}';
            res.setBody(response);
            res.setStatusCode(200);
        }else{
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id": "Test-Id", "status": "accepted"}');
            res.setStatusCode(202);
        }
        return res;
    }
}