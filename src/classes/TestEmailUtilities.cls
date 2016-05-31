@isTest
public with sharing class TestEmailUtilities {

	private static testMethod void testConstructPageRef() {
		System.assertNotEquals('', EmailUtilities.constructPageRef('Account', new Map<String, String>{'id' => 'aaaa'}).getURL());
	}

	private static testMethod void testConstructInlineEmailAttachmentAsPDF() {
		Messaging.EmailFileAttachment attachment = EmailUtilities.constructInlineEmailAttachmentAsPDF('test.pdf', Blob.valueOf('something'));
	}

	private static testMethod void testConstructSingleEmailMessage() {
		EmailUtilities.constructSingleEmailMessage('', 'subject', 'body', new Messaging.EmailFileAttachment[]{}, null, null);
	}

}
