@isTest
global class MockHttpResponseGeneratorsVeda implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
       // res.setHeader('Content-Type', 'text/x');
            res.setBody('{"avmFaresDetail":{"faresCode":"0","faresCondition":"SUCCESS","faresDescription":"SUCCESS","faresFSDScore":"11","faresReferenceID":"VIC:1469096069036-1529423","faresRunDate":"2016-07-21T20:14:29.469+10:00","faresScore":"81","faresValuationDate":"2016-07-21T20:14:29.469+10:00","faresValueEstimate":"670937","faresValueHigh":"746893","faresValueLow":"594981","otmProperties":[9220514,9210721,9213533,9220100,9220914,9213758],"soldProperties":[9220514,9221337,9220386,9221887,9220527,9213765]},"propertyId":9220490,"systemInfo":{"instanceName":"71:8080","requestDate":"2016-07-21T20:14:29.017+10:00"}}');
        res.setStatusCode(200);
        return res;
    }
}