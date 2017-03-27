global class IntercomUtilities {
    webService static String returnUserUrl (String email) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.intercom.io/users?email=' + email);
        req.setMethod('GET');
             
        // Specify the required user name and password to access the endpoint
        // As well as the header and header information
        
        String username = 'hho61r9c';
        String password = '422dae82a58ded14e0028180a76a58ee8a0e4977';
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', 'application/json');
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        JSONParser parser = JSON.createParser(res.getBody());
        String userid = 'noUserId';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'id')) {
                    // Get the value.
                    parser.nextToken();
                    // Compute the grand total price for all invoices.
                    userid = parser.getText();
                    break;
                }
        }
        String url = 'https://app.intercom.io/a/apps/hho61r9c/users/' + userid + '/all-conversations';
        System.debug(url);
        return url;
    }
}