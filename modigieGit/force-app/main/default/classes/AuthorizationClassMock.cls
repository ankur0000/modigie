public class AuthorizationClassMock implements HttpCalloutMock
{
        public HTTPResponse respond(HTTPRequest req) 
        {
        HttpResponse res = new HttpResponse();
        if (req.getEndpoint().contains('oauth2/v4/token')) {
            res.setHeader('Content-Type', 'application/json');
            String response = '{"id_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjJjNmZhNmY1OTUwYTdjZTQ2NWZeXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL21vZGlnaWUtZW5nY2RpZ2llLWJhY2tlbmQtdXMtMS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJleHAiOjE2MDExMDU2MDgsImlhdCI6MTYwMTEwMjAwOCwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tIiwic3ViIjoiMTAyODk2MDkzNTY0MTU1NDM5OTU0In0.Rw_JO6gUlEsLwzZ2_YuC0IsuSp87ug3LF7k__6Ul28M49EgK6Jepaq7SeZvVJZ4p3K9Zq_PRhjRIpdvDU8XLyVmdWFT7D173ILhSglr0V5NeawpGAYz4AC2eu6HqouCz_jDvzW6CFZQsoDOPr1mR7cVVFN59YYR6D4VSaCEbk7PuRwjPZH5nJCzVMVCiKbHmC70tIQZk4eKBa3cLKJBvY3_7lRDUcNlN"}';
            res.setBody(response);
            res.setStatusCode(200);
        }else if (req.getEndpoint().contains('/credits:create')) {
            res.setHeader('Content-Type', 'application/json');
            String response = '{ "balance": { "amount": "0.0000", "currency": { "code": "XXX" } }, "contract": { "contractType": "pay-per-use", "id": "TyMb0CydFd8ZFpuivyQI", "name": "customers/TyMb0CydFd8ZFpuivyQI/contracts/TyMb0CydFd8ZFpuivyQI" }, "createTime": "2022-05-24T04:47:32Z", "creditsLeft": 0, "creditsLimit": 0, "creditsReserved": 0, "creditsTotal": 0, "currency": { "code": "XXX" }, "customer": { "id": "TyMb0CydFd8ZFpuivyQI", "name": "customers/TyMb0CydFd8ZFpuivyQI" }, "customerRef": "CustomerAccount/TyMb0CydFd8ZFpuivyQI", "discount": 0, "id": "R9gDxJC5JiYQutzy4CIz", "minBalanceLimit": { "amount": "0.0000", "currency": { "code": "XXX" } }, "name": "customers/TyMb0CydFd8ZFpuivyQI/credits/R9gDxJC5JiYQutzy4CIz", "quota": { "stopUntilTime": null }, "status": "active", "title": "Jai  Test", "updateTime": null }';
            res.setStatus('Created');
            res.setBody(response);
            res.setStatusCode(200);
        }
		else if (req.getEndpoint().contains('credits:activeOldestFirst')) {
            res.setHeader('Content-Type', 'application/json');
            String response = '{ "items":[{"balance": { "amount": "0.0000", "currency": { "code": "XXX" } }, "contract": { "contractType": "pay-per-use", "id": "TyMb0CydFd8ZFpuivyQI", "name": "customers/TyMb0CydFd8ZFpuivyQI/contracts/TyMb0CydFd8ZFpuivyQI" }, "createTime": "2022-05-24T04:47:32Z", "creditsLeft": 0, "creditsLimit": 0, "creditsReserved": 0, "creditsTotal": 0, "currency": { "code": "XXX" }, "customer": { "id": "TyMb0CydFd8ZFpuivyQI", "name": "customers/TyMb0CydFd8ZFpuivyQI" }, "customerRef": "CustomerAccount/TyMb0CydFd8ZFpuivyQI", "discount": 0, "id": "R9gDxJC5JiYQutzy4CIz", "minBalanceLimit": { "amount": "0.0000", "currency": { "code": "XXX" } }, "name": "customers/TyMb0CydFd8ZFpuivyQI/credits/R9gDxJC5JiYQutzy4CIz", "quota": { "stopUntilTime": null }, "status": "active", "title": "Jai  Test", "updateTime": null}] }';
            res.setStatus('Created');
            res.setBody(response);
            res.setStatusCode(200);
        }
        return res;
    }

}