global with sharing class OpportunityService {

	webservice static void syncOppoToMercury(Id oppoId) {
		OpportunitySelector os = new OpportunitySelector();
		Opportunity o = os.getById(oppoId);

		system.debug(LoggingLevel.INFO, o);
		insert AsyncRequestService.createSyncToRequst(o.AccountId, o.id);
	}

	public static void sendComplianceDocsEmail(List<String> recipants, List<String> ccRecipants, List<PageReference> pageRefs) {
		String emailSubject = 'Hello World! Compliance Docs';
		String htmlBody = '<h1>Amazing HTML Body</h1>';
		Map<String, Blob> docMap = new Map<String, Blob>();

		Messaging.SingleEmailMessage mail = EmailUtilities.constructBasicSingleEmailMessage(recipants, ccRecipants, emailSubject, htmlBody);
		List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
		Integer i = 0;
		for(PageReference pr : pageRefs) {
			//TODO: change the name
			String fileName = 'Fantastic Document Name' + i++;
			Blob content = Utilities.getPageAsPDF(pr);
			docMap.put(fileName, content);
			fileAttachments.add(EmailUtilities.constructInlineEmailAttachmentAsPDF(fileName, content));
		}
		mail = EmailUtilities.addFileAttachment(mail, fileAttachments);

		// Save history
		EmailHistoryService.saveEmailHistory(recipants, ccRecipants, emailSubject, htmlBody, docMap);
		// Send Email
		EmailUtilities.sendSingleEmail(mail);
	}

}
