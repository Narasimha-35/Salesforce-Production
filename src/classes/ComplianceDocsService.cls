public with sharing class ComplianceDocsService {
	public static final String EMAIL_SUBJECT = ComplianceDocs__c.getOrgDefaults().emailSubject__c;

	public static void sendComplianceDocsEmail(List<String> recipants, List<String> ccRecipants, String bodyHtmlString, Map<String, PageReference> pageRefsMap) {
		List<S3DocumentModel.UploadRequest> uploadRequests = new List<S3DocumentModel.UploadRequest>();

		Messaging.SingleEmailMessage mail = EmailUtilities.constructBasicSingleEmailMessage(recipants, ccRecipants, EMAIL_SUBJECT, bodyHtmlString);
		List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
		Integer i = 0;
		for(String name : pageRefsMap.keySet()) {
			PageReference pr = pageRefsMap.get(name);
			String fileName = name;
			Blob content = Utilities.getPageAsPDF(pr);
			uploadRequests.add(new S3DocumentModel.UploadRequest(fileName, content, LendiApiStaticValue.PDF_MINE_TYPE));
			fileAttachments.add(EmailUtilities.constructInlineEmailAttachmentAsPDF(fileName, content));
		}
		mail = EmailUtilities.addFileAttachment(mail, fileAttachments);

		// Save history
		EmailHistoryService.saveEmailHistory(recipants, ccRecipants, EMAIL_SUBJECT, bodyHtmlString, uploadRequests);
		// Send Email
		EmailUtilities.sendSingleEmail(mail);
	}
}
