@isTest
global class MockHttpResponseGenerators123Pending implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"timestamp":"2015-05-27T10:58:28.245Z","scanReference":"0e9b9f48-5dbc-4cf1-a05a-8c8358c170ee","status":"Pending"}');
        res.setStatusCode(200);
        return res;
    }
}