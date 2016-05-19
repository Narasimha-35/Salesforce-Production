@isTest
public with sharing class TestMercuryRequestBatch {
	public static Opportunity oppo {get; set;}
	public static Account account {get; set;}
	public static Contact contact {get; set;}
	static {
		account = TestUtilities.createAccount(true);
		insert account;
		contact = TestUtilities.createContact();
		insert contact;
		oppo = TestUtilities.createOpportunity();
		insert oppo;

		MercuryTestUtilities.setCustomSettings(true);
		MercuryTestUtilities.setMock(oppo.id, account.id);
	}

	public static testMethod void test401() {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setStatusCode(401);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

		System.debug('oppoId: ' + oppo.id + ' accid: ' + account.id);
		List<AsyncRequest__c> tl = new List<AsyncRequest__c>();

		for(Integer i = 0; i < 10; i++) {
			tl.add(TestUtilities.createAsyncRequest(oppo.id, account.id));
		}
		Test.startTest();
		insert tl;
		Test.stopTest();
		System.debug([SELECT id FROM AsyncRequest__c]);
		System.assertEquals(10, [SELECT id FROM AsyncRequest__c].size());
	}

	public static testMethod void test200() {
		System.debug('oppoId: ' + oppo.id + ' accid: ' + account.id);
		List<AsyncRequest__c> tl = new List<AsyncRequest__c>();

		for(Integer i = 0; i < 10; i++) {
			tl.add(TestUtilities.createAsyncRequest(oppo.id, account.id));
		}
		Test.startTest();
		insert tl;
		Test.stopTest();
		System.assertEquals(0, [SELECT id FROM AsyncRequest__c].size());
	}
}