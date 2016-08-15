@isTest
public with sharing class TestDocumentRecoveryScheduler {
	public static MultiStaticResourceCalloutMock multimock;
	static {
		insert new S3DocumentSetting__c (
		domain__c     = 'www.lendi.com.au',
		token__c      = '47847d52-8842-4055-b6e1-9cb71fe42f28',
		apiVersion__c = 'v1',
		entrence__c   = 'api',
		resources__c  = 'docs'
		);
		multimock = new MultiStaticResourceCalloutMock();
		multimock.setStaticResource(LendiApiStaticValue.DOC_SERVICE_ENDPOINT, 's3UploadSuccess');
		multimock.setHeader('Content-Type', 'application/json');
	}

	private static testMethod void testS3DocumentRecoveryScheduler() {
		multimock.setStatusCode(200);
		Test.setMock(HttpCalloutMock.class, multimock);

		List<S3Document__c> testS3Docs = TestUtilities.createS3Documents(10);
		insert testS3Docs;

		List<Attachment> testAtt = new List<Attachment>();
		for(S3Document__c doc : testS3Docs) {
			doc.isSuccess__c = false;
			Attachment att = new Attachment();
			att.name = doc.name;
			att.body = Blob.valueOf(doc.name);
			att.parentId = doc.id;
			testAtt.add(att);
		}
		update testS3Docs;
		insert testAtt;

		Test.startTest();
		S3DocumentRecoveryScheduler s = new S3DocumentRecoveryScheduler();
		s.execute(null);
		Test.stopTest();
	}

}
