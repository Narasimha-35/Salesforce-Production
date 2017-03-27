@isTest
                        
global class MockHttpResponseGenerator1 implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint() == 'https://netverify.com/api/netverify/v2/initiateNetverify'){
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            System.assertEquals('https://netverify.com/api/netverify/v2/initiateNetverify', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            
            // Create a fake response
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"timestamp": "2012-08-16T10:27:29.494Z","authorizationToken": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx","clientRedirectUrl": "https://[your-domain-prefix].netverify.com/v2?authorizationToken=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx","jumioIdScanReference": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"}');
            res.setStatusCode(201);
        } 
        if(req.getEndpoint() == 'https://test.bankstatements.com.au/api/v1/institutions' ){     
            // Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"institutions":[{"slug":"bank_of_statements","name":"Bank of Statements","credentials":[{"name":"Username","fieldID":"username","type":"TEXT","description":"","values":"","keyboardType":"default"},{"name":"Password","fieldID":"password","type":"password","description":"","values":"","keyboardType":"default"}],"status":"","searchable":"1","display":"0","searchVal":"","region":"","export_with_password":"0","estatements_supported":"0","transaction_listings_supported":"0","requires_preload":"0","requires_mfa":"0","updated_at":"2015-05-20 12:36:11","max_days":"365"}]}');
            res.setStatusCode(200);
        }
        return res;
    }
}