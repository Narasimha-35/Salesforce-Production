@isTest
public with sharing class TestS3DocumentService {
   public static S3Document__c testDoc = TestUtilities.createS3Document();
   public static MultiStaticResourceCalloutMock multimock;
   static {
      insert new S3DocumentSetting__c(domain__c = 'www.lendi.com.au', token__c = '47847d52-8842-4055-b6e1-9cb71fe42f28');
      multimock = new MultiStaticResourceCalloutMock();
      multimock.setStaticResource(S3DocumentService.SERVICE_DOMAIN + '/file/' + testDoc.objectKey__c + '/' + testDoc.version__c, 's3RetrieveSuccess');
      multimock.setStaticResource(S3DocumentService.SERVICE_DOMAIN, 's3UploadSuccess');
      multimock.setHeader('Content-Type', 'application/json');
   }

   public static testMethod void testUploadDocumentSuccess() {
      multimock.setStatusCode(200);
      Test.setMock(HttpCalloutMock.class, multimock);

      S3DocumentModel.UploadRequest uploadReq = new S3DocumentModel.UploadRequest();
      uploadReq.name = 'abc';
      uploadReq.data = Blob.valueOf('abc.pdf');
      List<S3DocumentModel.UploadRequest> uploadRequests = new List<S3DocumentModel.UploadRequest>{uploadReq};

      Test.startTest();
      S3Document__c doc = S3DocumentService.uploadDocument(uploadRequests).get(0);
      Test.stopTest();

      System.assertEquals(uploadReq.name, doc.name);
      System.assertEquals('f9c2b7e0-2863-11e6-80bb-bb4552b59e84', doc.objectKey__c);
      System.assertEquals('GCOWn09kbNBHPWuqmA5dLss9STLEb15s', doc.version__c);
   }

   //TODO:
   public static testMethod void testUploadDocumentFail() {

   }

   //TODO:
   // public static testMethod void testUpdateDocumentSuccess() {
   //    multimock.setStatusCode(200);
   //    Test.setMock(HttpCalloutMock.class, multimock);
   //
   //    Blob data = Blob.valueOf('abc.pdf');
   //
   //    Test.startTest();
   //    S3Document__c doc = S3DocumentService.updateDocument(testDoc, data);
   //    Test.stopTest();
   //
   //    System.assertEquals(testDoc.name, doc.name);
   //    System.assertEquals('f9c2b7e0-2863-11e6-80bb-bb4552b59e84', doc.objectKey__c);
   //    System.assertNotEquals('GCOWn09kbNBHPWuqmA5dLss9STLEb15s', doc.version__c);
   // }

   //TODO:
   public static testMethod void testUpdateDocumentFail() {

   }

   public static testMethod void testRetrieveDocumentURLSuccess() {
      multimock.setStatusCode(200);
      Test.setMock(HttpCalloutMock.class, multimock);

      Test.startTest();
      String url = S3DocumentService.retrieveDocumentURL(testDoc);
      Test.stopTest();

      System.assertEquals('s3.amazon.com/abc', url);
   }

   public static testMethod void testRetrieveDocumentURLFail() {
      multimock.setStatusCode(401);
      Test.setMock(HttpCalloutMock.class, multimock);

      Test.startTest();
      try{
         String url = S3DocumentService.retrieveDocumentURL(testDoc);
         System.assert(false);
      } catch (HttpRequestResponse.HttpException e) {
         System.assert(true);
      }
      Test.stopTest();
   }

}
