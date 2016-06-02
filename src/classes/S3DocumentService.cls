public with sharing class S3DocumentService {
	public static final String SERVICE_DOMAIN = S3DocumentSetting__c.getOrgDefaults().domain__c;

	public static Boolean uploadDocument(S3Document__c doc, Blob content) {
		//update the content to S3 via lendi S3 service, if exception happens try few times if still not working return false.

		//save the reference into salesforce. if exception send Email to Developer with S3 reference so the admin user know how to manually recover.

		return true;
	}

	public static String retrieveDocumentURL(S3Document__c doc) {
		HttpRequest req = buildRequest(SERVICE_DOMAIN, 'GET', doc);
		return 'url';
	}

	public static Boolean healthCheck() {
		return false;
	}

	public static HttpRequest buildRequest(String endPoint, String method, S3Document__c doc) {
		HttpRequest req = new HttpRequest();
		req.setHeader('Content-Type', 'application/json');
		req.setEndPoint(endPoint);
		req.setMethod(method);
		return req;
	}

}
