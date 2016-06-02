@isTest
public with sharing class TestS3DocumentService {
   static {
      S3DocumentSetting__c setting = new S3DocumentSetting__c(domain__c = 'www.lendi.com.au/file');
      insert setting;

      MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
      multimock.setStaticResource(S3DocumentService.SERVICE_DOMAIN, 's3RetrieveSuccess');
      multimock.setStatusCode(200);
      multimock.setHeader('Content-Type', 'application/json');
      Test.setMock(HttpCalloutMock.class, multimock);
   }

   public static testMethod void testRetrieveDocumentURL() {
      String url = S3DocumentService.retrieveDocumentURL();
      System.assertEquals('s3.amazon.com/abc', url);
   }

}
