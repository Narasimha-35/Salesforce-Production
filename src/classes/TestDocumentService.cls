@isTest
public with sharing class TestDocumentService {
   public static S3Document__c testDoc = TestUtilities.createS3Document();
   public static MultiStaticResourceCalloutMock multimock;
   static {
      LendiApiTestUtilities.setLendiApiCustomSetting();
      multimock = new MultiStaticResourceCalloutMock();
      multimock.setStaticResource(LendiApiStaticValue.DOC_SERVICE_ENDPOINT, 's3UploadSuccess');
      System.debug('[TestS3DocumentService] end point: ' + LendiApiStaticValue.DOC_SERVICE_ENDPOINT);
      System.debug('[TestS3DocumentService] static resources: ' + 's3UploadSuccess');
      multimock.setHeader('Content-Type', 'multipart/form-data; boundary=' + LendiApiStaticValue.MULTIPART_BOUNDARY);
   }

   public static testMethod void testUploadDocumentSuccess() {
      multimock.setStatusCode(200);
      Test.setMock(HttpCalloutMock.class, multimock);

      S3DocumentModel.UploadRequest uploadReq = new S3DocumentModel.UploadRequest();
      uploadReq.name = 'abc';
      uploadReq.data = Blob.valueOf('abc.pdf');
      List<S3DocumentModel.UploadRequest> uploadRequests = new List<S3DocumentModel.UploadRequest>{uploadReq};

      Test.startTest();
      S3Document__c doc = S3DocumentService.uploadDocument(uploadRequests)[0];
      Test.stopTest();

      System.assertEquals(uploadReq.name, doc.name);
      System.assertEquals('ffab49ad-15de-4b08-9ff3-2e623153f9a5', doc.objectKey__c);
      System.assertEquals('CK3pm4T6hCkbjsA8KE90wlxl8GX6OdXu', doc.version__c);
   }

   //TODO:
   public static testMethod void testUploadDocumentFail4xx() {
      multimock.setStatusCode(400);
      Test.setMock(HttpCalloutMock.class, multimock);

      S3DocumentModel.UploadRequest uploadReq = new S3DocumentModel.UploadRequest();
      uploadReq.name = 'abc';
      uploadReq.data = Blob.valueOf('abc.pdf');
      List<S3DocumentModel.UploadRequest> uploadRequests = new List<S3DocumentModel.UploadRequest>{uploadReq};

      Test.startTest();
      S3Document__c doc = S3DocumentService.uploadDocument(uploadRequests).get(0);
      Test.stopTest();
   }

}
