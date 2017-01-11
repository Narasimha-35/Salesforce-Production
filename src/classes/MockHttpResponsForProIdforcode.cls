@isTest
global class MockHttpResponsForProIdforcode implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
       // res.setHeader('Content-Type', 'text/x');
        res.setBody('{"matchDetails":{"matchRule":"002","matchType":"E","propertyId":3596570,"updateDetail":"00000000","updateIndicator":"O"}}');
        res.setStatusCode(100);
        return res;
    }
}