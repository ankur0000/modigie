@isTest
global class MockHttpResponseGetLinkedinBatch implements HttpCalloutMock 
{
    String contactId;
    public MockHttpResponseGetLinkedinBatch(String str){
        contactId = str;
    }
    
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');  //00Q1U00000Nn2URUAZ00D1U000000z1rKUAQ
        //res.setBody('{ "_hidden_": { "contacts": [ { "index": 0, "input": { "company": "Umpqua Bank", "companyAddress": { "city": null, "country": null, "countryCode": null, "state": null, "stateCode": null, "streetLine": null, "zip": null }, "companyEmail": "brianread@umpquabank.com", "custom1": "0031U00001NcyFYQAZ", "custom2": "string", "custom3": "string", "firstName": "Brian", "lastName": "Read", "linkedInUrl": null, "mobilePhone": null, "otherEmails": null, "otherPhones": null, "otherUrls": null, "twitterHandle": null }, "output": { "company": "Umpqua Bank", "companyAddress": { "city": null, "country": null, "countryCode": null, "state": null, "stateCode": null, "streetLine": null, "zip": null }, "companyEmail": "brianread@umpquabank.com", "custom1": "0031U00001NcyFYQAZ", "custom2": "string", "custom3": "string", "firstName": "Brian", "lastName": "Read", "linkedInUrl": "linkedin.com/in/brian-j-read-65569a8", "mobilePhone": null, "otherEmails": null, "otherPhones": null, "otherUrls": null, "twitterHandle": null }, "status": "done" } ], "job": { "creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "String", "custom2": "String", "custom3": "String", "jobType": "linkedInUrl", "recipeId": "modigie-contactsval-validate_mobile_flow1", "requestId": "", "status": "done" } }, "creditsId": "IB31VDkwiAnKpnK3HL4W", "custom1": "String", "custom2": "String", "custom3": "String", "errors": [], "id": "af1d2432b42b3db254c35e04d0bc60dda990315eea1005505b4ab35b0a1d5241", "name": "/api/val/v1/linkedInUrlJobs/af1d2432b42b3db254c35e04d0bc60dda990315eea1005505b4ab35b0a1d5241", "requestId": "", "results": [ { "custom1": "0031U00001NcyFYQAZ", "custom2": "string", "custom3": "string", "events": [], "linkedInUrl": "linkedin.com/in/brian-j-read-65569a8", "status": "done" } ], "status": "done" }');
        res.setBody('{ "results": [ { "customParameters": [ { "name": "recordIdAndOrgId", "value": "'+contactId+UserInfo.getOrganizationId()+'" } ], "events": [], "id": "cfcd208495d565ef66e7dff9f98764da", "linkedInUrl": "linkedin.com/in/wesley-story-bb30533", "name": "linkedInUrlJobs/97e94ba74725435e4c31a758a6b1321fb50af0bbf7d652982068c8f699236ed2/contacts/cfcd208495d565ef66e7dff9f98764da", "status": "done" } ] }');
        res.setStatusCode(200);
        return res;
                  
     }
}