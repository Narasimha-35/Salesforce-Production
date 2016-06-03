public with sharing class EmailHistoryService {

	public static void saveEmailHistory(List<String> recipants, List<String> ccRecipants, String emailSubject, String htmlBody, Map<String, Blob> docMap) {
		//update doc to s3
		List<S3Document__c> s3Docs;
		try{
			s3Docs = S3DocumentService.uploadDocument(docMap);
		} catch (CalloutException e) { //TODO: remove this Exception handle
			// for demo use.
			s3Docs = new List<S3Document__c>();

			for(String name : docMap.keySet()) {
				S3Document__c doc = new S3Document__c();
				doc.name = name;
				doc.objectKey__c = 'demo object key';
				doc.version__c = 'demo object version';
				s3Docs.add(doc);
			}
		}

		//register to SF as doc Reference email history
		emailHistory__c eh = new emailHistory__c();
		eh.emailContent__c = htmlBody;
		eh.subject__c = emailSubject;
		eh.recipants__c = JSON.serialize(recipants);
		eh.ccRecipants__c = JSON.serialize(ccRecipants);
		insert eh;

		for(S3Document__c doc : s3Docs) {
			doc.emailHistory__c = eh.id;
		}

		insert s3Docs;

		List<Attachment> errorList = new List<Attachment>();
		for(S3Document__c doc : s3Docs) {
			if(doc.version__c == 'Fail') {
				Attachment attachment = new Attachment();
				attachment.name = doc.name;
				attachment.body = docMap.get(doc.name);
				attachment.parentId = doc.id;
				errorList.add(attachment);
			}
		}
		insert errorList;
	}

}
