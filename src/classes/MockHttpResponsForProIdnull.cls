@isTest
global class MockHttpResponsForProIdnull implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
       // res.setHeader('Content-Type', 'text/x');
        res.setBody('{"matchDetails":{"matchRule":"002","matchType":"E","propertyId":null,"updateDetail":"00000000","updateIndicator":"O"}}');
        res.setStatusCode(100);
        return res;
    }
}