@isTest 
global class JwtapexMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if (req.getEndpoint().contains('oauth2/v4/token')) {
            res.setHeader('Content-Type', 'application/json');
            String response = '{"id_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjJjNmZhNmY1OTUwYTdjZTQ2NWZeXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL21vZGlnaWUtZW5nY2RpZ2llLWJhY2tlbmQtdXMtMS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJleHAiOjE2MDExMDU2MDgsImlhdCI6MTYwMTEwMjAwOCwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tIiwic3ViIjoiMTAyODk2MDkzNTY0MTU1NDM5OTU0In0.Rw_JO6gUlEsLwzZ2_YuC0IsuSp87ug3LF7k__6Ul28M49EgK6Jepaq7SeZvVJZ4p3K9Zq_PRhjRIpdvDU8XLyVmdWFT7D173ILhSglr0V5NeawpGAYz4AC2eu6HqouCz_jDvzW6CFZQsoDOPr1mR7cVVFN59YYR6D4VSaCEbk7PuRwjPZH5nJCzVMVCiKbHmC70tIQZk4eKBa3cLKJBvY3_7lRDUcNlN"}';
            res.setBody(response);
            res.setStatusCode(200);
        }else if (req.getEndpoint().contains('api/v1/mobilePhoneJobs') || req.getEndpoint().contains('/v1/phoneIntelJobs') || req.getEndpoint().contains('v1/verifyEmployerJobs')) {
            res.setHeader('Content-Type', 'application/json');
            String response = '{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}';
            res.setBody(response);
            res.setStatusCode(202);
        }else if (req.getEndpoint().contains('api/v1/credits/')) {
            res.setHeader('Content-Type', 'application/json');
            String response = '{ "creditsLeft": 10, "creditsLimit": -10000, "creditsReserved": 16, "creditsTotal": 150, "customerRef": "CustomerAccount/Tc8Ye55fAxAwDyZhD9BN", "discount": 50 }';
            res.setBody(response);
            res.setStatusCode(202);
        }else if (req.getEndpoint().contains('api/v1/linkedInUrlJobs')) {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "my-job-field-1", "custom2": "my-job-field-2", "custom3": "my-job-field-3", "errors": [], "id": "05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "name": "/api/val/v1/linkedInUrlJobs/05e32e6dfaf34538ed1e2710f4547fbdc9579242ac1055b33135b9a6281ce427", "requestId": "06", "results": [], "status": "accepted"}');
            res.setStatusCode(202);
        }

        return res;
    }
}