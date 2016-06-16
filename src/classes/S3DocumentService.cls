public with sharing class S3DocumentService {

	//TODO: send as a bluk
	public static List<S3Document__c> uploadDocument(List<S3DocumentModel.UploadRequest> uploadRequests) {
		List<S3Document__c> ret = new List<S3Document__c>();
		for(S3DocumentModel.UploadRequest req : uploadRequests) {
			HttpRequestResponse httpRR;
			S3Document__c doc = new S3Document__c();
			doc.name = req.name;
			doc.contentType__c = req.type;
			if(req.sf_s3DocumentId != null) doc.id = req.sf_s3DocumentId;

			try{
				httpRR = S3DocumentUtilities.insertS3Document(new List<S3DocumentModel.UploadRequest>{req});
				System.debug(LoggingLevel.DEBUG, '[S3DocumentService] http response body: ' + httpRR.res.getBody());
				S3DocumentModel.Response res = (S3DocumentModel.Response) JSON.deserialize(httpRR.res.getBody(), S3DocumentModel.Response.class);

				//save the reference into salesforce.
				doc.objectKey__c = res.data.documents[0].key;
				doc.version__c = res.data.documents[0].version;
				doc.isSuccess__c = true;

				System.debug(LoggingLevel.INFO, 'File is successfully created in S3: ' + doc.objectKey__c);
			} catch (HttpRequestResponse.HttpException e) {
				// handle API specific Exception
				doc.isSuccess__c = false;
				System.debug(LoggingLevel.INFO, 'File is fail to created in S3' + doc.name);
				System.debug('[S3DocumentService] HttpRequestResponse.HttpException: ' + e.getMessage());
			} catch (Exception e) {
				// handle UnexpectedException
				doc.isSuccess__c = false;
				System.debug(LoggingLevel.INFO, 'File is fail to created in S3' + doc.name);
				System.debug('[S3DocumentService] UnexpectedException: ' + e.getMessage());
			}
			ret.add(doc);
		}
		return ret;
	}

	public static List<S3Document__c> reuploadDocuments(List<S3Document__c> docs) {
		Map<Id, S3Document__c> docMap = new Map<Id, S3Document__c>(docs);
		List<Attachment> attachments = S3DocumentUtilities.getRelatedAttachments(docs);
		List<S3DocumentModel.UploadRequest> reqList = new List<S3DocumentModel.UploadRequest>();

		for(Attachment att : attachments) {
			reqList.add(new S3DocumentModel.UploadRequest(att, docMap.get(att.parentId).contentType__c));
		}
		List<S3Document__c> s3DocList = uploadDocument(reqList);

		return s3DocList;
	}

	public static List<Attachment> constructFailureAsAttachment(List<S3Document__c> s3Docs, List<S3DocumentModel.UploadRequest> uploadRequests) {
		return S3DocumentUtilities.constructFailureAsAttachment(s3Docs, uploadRequests);
	}

}
