@isTest
global class MockHttpResponseGeneratorAVm implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"avmFaresDetail":{"faresCode":"0","faresCondition":"SUCCESS","faresDescription":"SUCCESS","faresFSDScore":"9","faresReferenceID":"NSW:1465287930045-15989922","faresRunDate":"2016-06-07T18:25:30.308+10:00","faresScore":"88","faresValuationDate":"2016-06-07T18:25:30.308+10:00","faresValueEstimate":"816400","faresValueHigh":"886291","faresValueLow":"746510","otmProperties":[2029020,2028986,2027901,2027975,2030654,2030583],"soldProperties":[2028613,2029022,2028609,2030583,2029032,2030560]},"propertyId":2028759,"systemInfo":{"instanceName":"77:8080","requestDate":"2016-06-07T18:25:30.027+10:00"}}');
        res.setStatusCode(200);
        return res;
    }
}