@isTest
global class MockHttpResponseGeneratorPropertyId implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"matchDetails":{"matchRule":"002","matchType":"E","propertyId":2028759,"updateDetail":"00000000","updateIndicator":"O"}}');
        res.setStatusCode(200);
        return res;
    }
}