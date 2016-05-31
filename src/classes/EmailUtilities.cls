public with sharing class EmailUtilities {

	public static PageReference constructPageRef(String pageName, Map<String, String> params) {
		PageReference ret = new PageReference('/apex/' + pageName);
		for(String k : params.keySet()) {
			ret.getParameters().put(k, params.get(k));
		}
		return ret;
	}

	//could Throws VisualforceException
	public static Blob getPageAsPDF(PageReference pr) {
		return pr.getContentAsPDF();
	}

	public static Messaging.EmailFileAttachment constructInlineEmailAttachmentAsPDF(String name, Blob body) {
		return constructEmailAttachment('application/pdf', name, false, body);
	}

	public static Messaging.EmailFileAttachment constructEmailAttachment(String contentType, String name, Boolean isInline, Blob body) {
		Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
		attach.setContentType(contentType);
		attach.setFileName(name);
		attach.setInline(isInline);
		attach.Body = body;
		return attach;
	}

	public static Messaging.SingleEmailMessage constructSingleEmailMessage(String recipant, String subject, String htmlBody, Messaging.EmailFileAttachment[] attachments, Id whoId, Id whatId) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setUseSignature(false);
		mail.setToAddresses(new String[] {recipant});
		mail.setSubject(subject);
		mail.setHtmlBody(htmlBody);
		mail.setFileAttachments(attachments);
		if(whoId != null || whatId != null) {
			if(whoId != null) mail.setTargetObjectId(whoId);
			if(whatId != null) mail.setWhatId(whatId);
			mail.setSaveAsActivity(true);
		}
		return mail;
	}

	public static void sendSingleEmail(Messaging.SingleEmailMessage mail) {
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	}

}
