/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
global class MockHttpResponseGenerators12 implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"institutions":[{"slug":"bank_of_statements","name":"Bank of Statements","credentials":[{"name":"Username","fieldID":"username","type":"TEXT","description":"","values":"","keyboardType":"default"},{"name":"Password","fieldID":"password","type":"password","description":"","values":"","keyboardType":"default"}],"status":"","searchable":"1","display":"0","searchVal":"","region":"","export_with_password":"0","estatements_supported":"0","transaction_listings_supported":"0","requires_preload":"0","requires_mfa":"0","updated_at":"2015-05-20 12:36:11","max_days":"365"}]}');
        res.setStatusCode(200);
        return res;
    }
}