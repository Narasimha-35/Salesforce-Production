@isTest
public with sharing class TestS3DocumentUtilities {
	public static List<S3Document__c> s3Docs = TestUtilities.createS3Documents(10);
	public static Map<String, Blob> docMap;
	public static HttpRequestResponse httpRR;
	static {
		s3Docs.get(1).isSuccess__c = false;
		s3Docs.get(5).isSuccess__c = false;
		insert s3Docs;

		docMap = new Map<String, Blob>();
		for(S3Document__c doc : s3Docs) {
			docMap.put(doc.name, Blob.valueOf(doc.name));
		}

		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		httpRR = new HttpRequestResponse(req, res);
	}

	private static testMethod void testConstructFailureAsAttachment() {
		List<S3DocumentModel.UploadRequest> uploadRequests = new List<S3DocumentModel.UploadRequest>();
		for(String s : docMap.keySet()) {
			uploadRequests.add(new S3DocumentModel.UploadRequest(s, docMap.get(s), LendiApiStaticValue.TEXT_MINE_TYPE));
		}

		System.debug('[TestS3DocumentUtilities]s3Docs: ' + s3Docs);
		List<Attachment> failList = S3DocumentUtilities.constructFailureAsAttachment(s3Docs, uploadRequests);

		System.assertEquals(2, failList.size());
		System.assertEquals(s3Docs.get(1).id, failList.get(0).parentId);
		System.assertEquals(s3Docs.get(5).id, failList.get(1).parentId);
		System.debug(s3Docs.get(1).name + ' Vs. ' + failList.get(0).body.toString());
		System.assertEquals(s3Docs.get(1).name, failList.get(0).body.toString());
		System.assertEquals(s3Docs.get(5).name, failList.get(1).body.toString());
	}

	private static testMethod void testHandleResponse() {
		httpRR.res.setStatusCode(200);
		try{
			S3DocumentUtilities.handleResponse(httpRR);
			System.assert(true);
		} catch (HttpRequestResponse.HttpException e) {
			System.assert(false);
		}

		httpRR.res.setStatusCode(400);
		try{
			S3DocumentUtilities.handleResponse(httpRR);
			System.assert(false);
		} catch (HttpRequestResponse.HttpException e) {
			System.assert(true);
		}

		httpRR.res.setStatusCode(500);
		try{
			S3DocumentUtilities.handleResponse(httpRR);
			System.assert(false);
		} catch (HttpRequestResponse.HttpException e) {
			System.assert(true);
		}
	}

	//TODO: test insertS3Document
	//TODO: test getS3Document

	private static testMethod void testBuildBasicRequest() {
		HttpRequest req = S3DocumentUtilities.buildBasicRequest('test end point', 'POST');
		System.assertEquals('test end point', req.getEndpoint());
		System.assertEquals('POST', req.getMethod());
	}
}
