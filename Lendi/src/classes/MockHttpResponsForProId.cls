@isTest
global class MockHttpResponsForProId implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
       // res.setHeader('Content-Type', 'text/x');
        res.setBody('{"matchDetails":{"matchRule":"002","matchType":"E","propertyId":9216817,"updateDetail":"00000000","updateIndicator":"O"}}');
        res.setStatusCode(200);
        return res;
    }
}