@isTest
public with sharing class TestEmailHistoryService {
	public static List<String> recipants = new List<String>{'anthony.xuan@creditandfinance.com.au', 'chen@creditandfinance.com.au', 'glen.mcrea@creditandfinance.com.au'};
	public static List<String> ccRecipants = new List<String>{'david.hyman@clickloans.com.au', 'martin.lam@creditandfinance.com.au'};
	public static String subject = 'Awesome Subject';
	public static String body = '<h1>This is AweSome</h1>';
	public static List<S3DocumentModel.UploadRequest> uploadRequests;
	public static final String END_POINT = 'www.lendi.com.au';

	public static S3Document__c testDoc = TestUtilities.createS3Document();
	public static MultiStaticResourceCalloutMock multimock;
	static {
		uploadRequests = new List<S3DocumentModel.UploadRequest>();
		S3DocumentModel.UploadRequest req1 = new S3DocumentModel.UploadRequest('doc1', Blob.valueOf('doc1'), S3StaticValue.TEXT_MINE_TYPE);
		S3DocumentModel.UploadRequest req2 = new S3DocumentModel.UploadRequest('doc2', Blob.valueOf('doc2'), S3StaticValue.TEXT_MINE_TYPE);
		uploadRequests.add(req1);
		uploadRequests.add(req2);

		insert new S3DocumentSetting__c (
		domain__c     = 'www.lendi.com.au',
		token__c      = '47847d52-8842-4055-b6e1-9cb71fe42f28',
		apiVersion__c = 'v1',
		entrence__c   = 'api',
		resources__c  = 'docs'
		);
		multimock = new MultiStaticResourceCalloutMock();
		multimock.setStaticResource(S3StaticValue.S3_SERVICE_ENDPOINT, 's3UploadSuccess');
	}

	private static testMethod void testSaveEmailHistory() {
		multimock.setStatusCode(200);
		Test.setMock(HttpCalloutMock.class, multimock);
		Test.startTest();
		EmailHistoryService.saveEmailHistory(recipants, ccRecipants, subject, body, uploadRequests);
		Test.stopTest();

		List<EmailHistory__c> emailHistoryList = [SELECT id, ccRecipants__c, emailContent__c, recipants__c, subject__c FROM EmailHistory__c];
		List<S3Document__c> newDocList = [SELECT id, name, objectKey__c, version__c, contentType__c FROM S3Document__c];

		System.debug('email history: ' + emailHistoryList);
		System.debug('docs: ' + newDocList);

		System.assertEquals(1, emailHistoryList.size());
		System.assertEquals(JSON.serialize(recipants), emailHistoryList[0].recipants__c);
		System.assertEquals(JSON.serialize(ccRecipants), emailHistoryList[0].ccRecipants__c);
		System.assertEquals(subject, emailHistoryList[0].subject__c);
		System.assertEquals(body, emailHistoryList[0].emailContent__c);

		System.assertEquals(2, newDocList.size());
		System.assertEquals('ffab49ad-15de-4b08-9ff3-2e623153f9a5', newDocList[0].objectKey__c);
		System.assertEquals('CK3pm4T6hCkbjsA8KE90wlxl8GX6OdXu', newDocList[0].version__c);
		System.assertEquals(S3StaticValue.TEXT_MINE_TYPE, newDocList[0].contentType__c);
	}

}