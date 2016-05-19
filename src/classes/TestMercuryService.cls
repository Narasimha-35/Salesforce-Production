@isTest
public with sharing class TestMercuryService {
	private static Opportunity oppo;
	private static Account acc;
	private static Contact cont;
	private static MercuryModel.URLParams urlParam;
	static {
		acc = TestUtilities.createAccount(true);
		insert acc;
		cont = TestUtilities.createContact();
		insert cont;
		oppo = TestUtilities.createOpportunity();
		insert oppo;

		urlParam = new MercuryModel.URLParams();
		urlParam.currentPartnerId = 'P200019';
		urlParam.searchType = 'businessStats';
		urlParam.params = MercuryService.param2;

		MercuryTestUtilities.setCustomSettings(true);
		MercuryTestUtilities.setMock(oppo.id, acc.id, urlParam);
	}

	private static testMethod void testSyncWithMercury401() {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setStatusCode(401);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
		try{
			MercuryService.syncWithMercury(oppo.id, acc.id);
			System.assert(false);
		} catch (MercuryService.MercurySyncException e) {
			System.assert(true);
		}

		Test.stopTest();
	}

	private static testMethod void syncWithMercuryTest() {
		Test.startTest();
		String accountId = acc.Id;
		String oppoId = oppo.Id;
		MercuryService.syncWithMercury(oppoId, accountId);
		Test.stopTest();
	}

	private static testMethod void futureSyncWithMercuryTest1() {
		Test.startTest();
		MercuryService.futureSyncWithMercury(oppo.id, acc.id);
		Test.stopTest();
	}

	private static testMethod void futureSyncWithMercuryTest2() {
		AsyncRequest__c req = AsyncRequestService.createSyncToRequst(acc.id, oppo.id);
		insert req;
		Test.startTest();
		MercuryService.futureSyncWithMercury(req.id);
		Test.stopTest();
	}

	// private static testMethod void getLoansFromMercuryTest() {
	// 	Test.startTest();
	// 	MercuryModel.LoanResponse res = MercuryService.getLoansFromMercury('Opportunity', 'P200019', 'businessStats', MercuryService.param2);
	// 	System.assertEquals(1, res.idList.size());
	// 	Test.stopTest();
	// }

	// TODO: can't get rid of _dc
	// private static testMethod void getLoansFromMercuryTest() {
	// 	Test.startTest();
	// 	MercuryService.getLoansFromMercury('Opportunity', 'P200019', 'businessStats', MercuryService.param2);
	// 	Test.stopTest();
	// }

	private static testMethod void syncWithMercuryTest3() {
		Test.startTest();
		MercuryService.syncWithMercury(oppo.id, acc.id);
		Test.stopTest();
	}

	private static testMethod void getLoanTest() {
		Test.startTest();
		MercuryService.getLoan(oppo.id);
		Test.stopTest();
	}

	// private static testMethod void getSyncBackLoanIdTest() {
	// 	Test.startTest();
	// 	MercuryService.getSyncBackLoanId
	// 	Test.stopTest();
	// }
	//
	// private static testMethod void syncBackLoanTest() {
	// 	Test.startTest();
	// 	MercuryService.syncBackLoan
	// 	Test.stopTest();
	// }

}