public with sharing class S3DocumentService {
	public static final String SERVICE_DOMAIN = S3DocumentSetting__c.getOrgDefaults().domain__c;
	public static final String TOKEN = S3DocumentSetting__c.getOrgDefaults().token__c;

	public static List<S3Document__c> uploadDocument(List<S3DocumentModel.UploadRequest> uploadRequests) {
		List<S3Document__c> ret = new List<S3Document__c>();
		for(S3DocumentModel.UploadRequest req : uploadRequests) {
			HttpRequestResponse httpRR;
			S3Document__c doc = new S3Document__c();
			doc.name = req.name;
			if(req.docId != null) doc.id = req.docId;

			try{
				httpRR = S3DocumentUtilities.insertS3Document(req.data);
				S3DocumentModel.PostResponse postRes = (S3DocumentModel.PostResponse) JSON.deserialize(httpRR.res.getBody(), S3DocumentModel.PostResponse.class);
				//save the reference into salesforce.
				doc.objectKey__c = postRes.file;
				doc.version__c = postRes.version;
				doc.isSuccess__c = true;
			} catch (HttpRequestResponse.HttpException e) {
				doc.isSuccess__c = false;
			}
			ret.add(doc);
		}
		return ret;
	}

	//do I need this?
	// public static S3Document__c updateDocument(S3Document__c oldDoc, Blob content) {
	// 	S3Document__c doc = oldDoc;
	//
	// 	return doc;
	// }

	public static String retrieveDocumentURL(S3Document__c doc) {
		HttpRequestResponse httpRR = S3DocumentUtilities.getS3Document(doc);
		S3DocumentModel.GetResponse getRes = (S3DocumentModel.GetResponse) JSON.deserialize(httpRR.res.getBody(), S3DocumentModel.GetResponse.class);
		return getRes.url;
	}

	// public static Boolean healthCheck() {
	// 	return false;
	// }

	public static List<S3Document__c> reuploadDocuments(List<S3Document__c> docs) {
		List<Attachment> attachments = getRelatedAttachments(docs);
		List<S3DocumentModel.UploadRequest> reqList = new List<S3DocumentModel.UploadRequest>();

		for(Attachment att : attachments) {
			reqList.add(new S3DocumentModel.UploadRequest(att));
		}
		List<S3Document__c> s3DocList = uploadDocument(reqList);

		return s3DocList;
	}

	public static List<Attachment> getRelatedAttachments(List<S3Document__c> docs) {
		List<String> docIds = (List<String>) new List<Id>((new Map<Id, S3Document__c>(docs)).keySet());
		AttachmentSelector attSelecotr = new AttachmentSelector();
		return attSelecotr.getByParentId(docIds);
	}

}
