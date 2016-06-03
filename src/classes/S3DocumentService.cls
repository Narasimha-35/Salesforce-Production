public with sharing class S3DocumentService {
	public static final String SERVICE_DOMAIN = S3DocumentSetting__c.getOrgDefaults().domain__c;
	public static final String TOKEN = S3DocumentSetting__c.getOrgDefaults().token__c;

	public static List<S3Document__c> uploadDocument(Map<String, Blob> docMap) {
		List<S3Document__c> docList = new List<S3Document__c>();
		for(String name : docMap.keySet()) {
			//update the content to S3 via lendi S3 service.
			HttpRequestResponse httpRR;
			S3Document__c doc = new S3Document__c();
			doc.name = name;

			try{
				httpRR = S3DocumentUtilities.insertS3Document(docMap.get(name));
				S3DocumentModel.PostResponse postRes = (S3DocumentModel.PostResponse) JSON.deserialize(httpRR.res.getBody(), S3DocumentModel.PostResponse.class);
				//save the reference into salesforce.
				doc.objectKey__c = postRes.file;
				doc.version__c = postRes.version;

			} catch (HttpRequestResponse.HttpException e) {
				doc.version__c = 'Fail';
			}
			docList.add(doc);
		}
		return docList;
	}

	//do I need this?
	public static S3Document__c updateDocument(S3Document__c oldDoc, Blob content) {
		S3Document__c doc = oldDoc;

		return doc;
	}

	public static String retrieveDocumentURL(S3Document__c doc) {
		HttpRequestResponse httpRR = S3DocumentUtilities.getS3Document(doc);
		S3DocumentModel.GetResponse getRes = (S3DocumentModel.GetResponse) JSON.deserialize(httpRR.res.getBody(), S3DocumentModel.GetResponse.class);
		return getRes.url;
	}

	public static Boolean healthCheck() {
		return false;
	}

}
