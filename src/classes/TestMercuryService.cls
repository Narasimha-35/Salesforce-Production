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

	private static testMethod void testCreateIncomeAndExpense() {
		Account acct = TestUtilities.createAccount();
		acct.mercury_People_ID__c = '9c6f5809-08b1-464a-9cc7-71b31903e0aa';
		insert acct;

		Income_And_Expense__c iae = TestUtilities.createIncomeAndExpense();
		iae.account__c = acct.id;
		iae.amount__c = 1;
		iae.balance__c = 2;
		iae.credit_Limit__c = 3;
		iae.category__c = 'Salary';
		iae.frequency__c = 'Yearly';
		iae.recordTypeId = IncomeRecordType.getInstance().id;
		insert iae;

		Income_And_Expense__c iae2 = TestUtilities.createIncomeAndExpense();
		iae2.account__c = acct.id;
		iae2.amount__c = 1;
		iae2.balance__c = 2;
		iae2.credit_Limit__c = 3;
		iae2.category__c = 'Salary';
		iae2.frequency__c = 'Yearly';
		iae2.recordTypeId = ExpenseRecordType.getInstance().id;
		insert iae2;

		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
		MercuryModel.People peop = new MercuryModel.People(acct, MercuryStaticValue.ACF_BRANCH_ID);
		MercuryService.createIncomeAndExpense(iae, peop, MercuryStaticValue.ACF_BRANCH_ID);
		MercuryService.createIncomeAndExpense(iae2, peop, MercuryStaticValue.ACF_BRANCH_ID);
		Test.stopTest();
	}

	private static testMethod void testCreateAssetAndLiability() {
		List<RecordType> recordTypeList = [SELECT id, name, sobjectType FROM RecordType WHERE sobjectType = 'Asset_And_Liability__c'];

		Asset_And_Liability__c aal = TestUtilities.createAssetAndLiability();
		aal.opportunity__c = oppo.id;
		aal.recordTypeId = recordTypeList[0].id;
		aal.account__c = acc.id;
		insert aal;

		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
		MercuryModel.Loan loan = new MercuryModel.Loan(oppo, MercuryStaticValue.ACF_BRANCH_ID);
		MercuryService.createAssetAndLiability(aal, loan, MercuryStaticValue.ACF_BRANCH_ID);
		Test.stopTest();
	}

}
