public with sharing class EmailUtilities {

	public static Messaging.EmailFileAttachment constructInlineEmailAttachmentAsPDF(String name, Blob body) {
		return constructEmailAttachment(LendiApiStaticValue.PDF_MINE_TYPE, name, false, body);
	}

	public static Messaging.EmailFileAttachment constructEmailAttachment(String contentType, String name, Boolean isInline, Blob body) {
		Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
		attach.setContentType(contentType);
		attach.setFileName(name);
		attach.setInline(isInline);
		attach.Body = body;
		return attach;
	}

	public static Messaging.SingleEmailMessage constructBasicSingleEmailMessage(List<String> recipants, List<String> ccRecipants, String subject, String htmlBody) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setUseSignature(false);
		mail.setToAddresses(recipants);
		mail.setCcAddresses(ccRecipants);
		mail.setSubject(subject);
		mail.setHtmlBody(htmlBody);
		return mail;
	}

	public static Messaging.SingleEmailMessage addFileAttachment(Messaging.SingleEmailMessage mail, List<Messaging.EmailFileAttachment> attachments) {
		mail.setFileAttachments(attachments);
		return mail;
	}

	public static void sendSingleEmail(Messaging.SingleEmailMessage mail) {
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	}

}
