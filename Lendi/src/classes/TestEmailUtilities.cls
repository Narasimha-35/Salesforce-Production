@isTest
public with sharing class TestEmailUtilities {
	public static List<String> recipants = new List<String>{'anthony.xuan@creditandfinance.com.au', 'chen@creditandfinance.com.au', 'glen.mcrea@creditandfinance.com.au'};
	public static List<String> ccRecipants = new List<String>{'david.hyman@clickloans.com.au', 'martin.lam@creditandfinance.com.au'};
	public static String subject = 'Awesome Subject';
	public static String body = '<h1>This is AweSome</h1>';

	private static testMethod void testConstructInlineEmailAttachmentAsPDF() {
		Messaging.EmailFileAttachment attachment = EmailUtilities.constructInlineEmailAttachmentAsPDF('test.pdf', Blob.valueOf('something'));
	}

	private static testMethod void testConstructBasicSingleEmailMessage() {
		EmailUtilities.constructBasicSingleEmailMessage(recipants, ccRecipants, subject, body);
	}

}