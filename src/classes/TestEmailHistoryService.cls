@isTest
public with sharing class TestEmailHistoryService {
	public static List<String> recipants = new List<String>{'anthony.xuan@creditandfinance.com.au', 'chen@creditandfinance.com.au', 'glen.mcrea@creditandfinance.com.au'};
	public static List<String> ccRecipants = new List<String>{'david.hyman@clickloans.com.au', 'martin.lam@creditandfinance.com.au'};
	public static String subject = 'Awesome Subject';
	public static String body = '<h1>This is AweSome</h1>';
	public static List<S3DocumentModel.UploadRequest> uploadRequests;

	public static S3Document__c testDoc = TestUtilities.createS3Document();
	public static MultiStaticResourceCalloutMock multimock;
	static {
		uploadRequests = new List<S3DocumentModel.UploadRequest>();
		S3DocumentModel.UploadRequest req1 = new S3DocumentModel.UploadRequest('doc1', Blob.valueOf('doc1'));
		S3DocumentModel.UploadRequest req2 = new S3DocumentModel.UploadRequest('doc2', Blob.valueOf('doc2'));
		uploadRequests.add(req1);
		uploadRequests.add(req2);

		insert new S3DocumentSetting__c(domain__c = 'www.lendi.com.au', token__c = '47847d52-8842-4055-b6e1-9cb71fe42f28');
		multimock = new MultiStaticResourceCalloutMock();
		multimock.setStaticResource(S3DocumentService.SERVICE_DOMAIN + '/file/' + testDoc.objectKey__c + '/' + testDoc.version__c, 's3RetrieveSuccess');
		multimock.setStaticResource(S3DocumentService.SERVICE_DOMAIN, 's3UploadSuccess');
		multimock.setHeader('Content-Type', 'application/json');
	}

	private static testMethod void testSaveEmailHistory() {
		multimock.setStatusCode(200);
		Test.setMock(HttpCalloutMock.class, multimock);
		Test.startTest();
		EmailHistoryService.saveEmailHistory(recipants, ccRecipants, subject, body, uploadRequests);
		Test.stopTest();

		List<EmailHistory__c> emailHistoryList = [SELECT id, ccRecipants__c, emailContent__c, recipants__c, subject__c FROM EmailHistory__c];
		List<S3Document__c> newDocList = [SELECT id, name, objectKey__c, version__c FROM S3Document__c];

		System.debug('email history: ' + emailHistoryList);
		System.debug('docs: ' + newDocList);

		System.assertEquals(1, emailHistoryList.size());
		System.assertEquals(JSON.serialize(recipants), emailHistoryList[0].recipants__c);
		System.assertEquals(JSON.serialize(ccRecipants), emailHistoryList[0].ccRecipants__c);
		System.assertEquals(subject, emailHistoryList[0].subject__c);
		System.assertEquals(body, emailHistoryList[0].emailContent__c);

		System.assertEquals(2, newDocList.size());
		System.assertEquals('f9c2b7e0-2863-11e6-80bb-bb4552b59e84', newDocList[0].objectKey__c);
		System.assertEquals('GCOWn09kbNBHPWuqmA5dLss9STLEb15s', newDocList[0].version__c);
	}

}
