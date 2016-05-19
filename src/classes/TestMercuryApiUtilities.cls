@isTest(SeeAllData=true)
private class TestMercuryApiUtilities {
	private static Opportunity oppo {get; set;}
	private static Account account {get; set;}
	private static Contact contact {get; set;}
	static {
		account = TestUtilities.createAccount(true);
		insert account;
		contact = TestUtilities.createContact();
		insert contact;
		oppo = TestUtilities.createOpportunity();
		insert oppo;

		MercuryTestUtilities.setMock(oppo.id, account.id);
	}

	private static testMethod void testCreateOppo401() {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setStatusCode(401);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
		try{
			MercuryApiUtilities.createOppoInMercury(oppo.id, 'P200019', true);
			System.assert(false);
		} catch (Utilities.CalloutResponseException e) {
			System.assert(true);
		}

		Test.stopTest();
		System.debug([SELECT id, params__c, failed__c FROM AsyncRequest__c]);
	}

	private static testMethod void testCreatePeople401() {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setStatusCode(401);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
		try{
			MercuryApiUtilities.createPeopleInMercury(account.id, 'P200019', true);
			System.assert(false);
		} catch (Utilities.CalloutResponseException e) {
			System.assert(true);
		}

		Test.stopTest();
		System.debug([SELECT id, params__c, failed__c FROM AsyncRequest__c]);
	}
	//TODO:Test sync one success one fail
	//TODO:Test sync one success one fail reversed
	//TODO:Test sync link fail

	static testMethod void testCreateOppoInMercuryWithDuplicate() {
		Test.startTest();
		MercuryApiUtilities.createOppoInMercury(oppo.id, 'P200019');
		// Opportunity oppo2 = [select Id, Sync_With_Mercury__c, Sync_With_Mercury_Success__c From Opportunity where Id = :oppo.id];
		Test.stopTest();
	}

	static testMethod void testCreateOppoInMercuryWithoutDuplicate() {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
		MercuryApiUtilities.createOppoInMercury(oppo.id, 'P200019', true);
		// Opportunity oppo2 = [select Id, Sync_With_Mercury__c, Sync_With_Mercury_Success__c From Opportunity where Id = :oppo.id];
		Test.stopTest();
	}

	static testMethod void testCreatePeopleInMercuryWithDuplicate() {
		Test.startTest();
		MercuryApiUtilities.createPeopleInMercury(account.id, 'P200019');
		Test.stopTest();
	}

	static testMethod void testCreatePeopleInMercuryWithoutDuplicate() {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
		MercuryApiUtilities.createPeopleInMercury(account.id, 'P200019', true);
		Test.stopTest();
	}

	static testMethod void createLoanPeopleInMercuryTest() {
		String accountId = account.Id;
		String oppoId = oppo.Id;
		String accountAndOppo = account.Id  + '' + oppo.Id;
		Test.startTest();
		MercuryApiUtilities.createLoanPeopleInMercury(accountAndOppo, oppoId, accountId);
		Test.stopTest();
	}

	private static testMethod void testHandleGetResponse() {
		HTTPResponse res = new HTTPResponse();
		res.setStatusCode(400);
		System.assertEquals(null, MercuryApiUtilities.handleGetResponse(res));

		res.setStatusCode(200);
		System.assertEquals(null, MercuryApiUtilities.handleGetResponse(res));

		Map<String, Object> resMap = new Map<String, Object>();
		resMap.put('success', false);
		res.setBody(JSON.serialize(resMap));
		System.assertEquals(null, MercuryApiUtilities.handleGetResponse(res));

		resMap.put('success', true);
		res.setBody(JSON.serialize(resMap));
		System.debug(MercuryApiUtilities.handleGetResponse(res));
		System.assertNotEquals(null, MercuryApiUtilities.handleGetResponse(res));
	}

	private static testMethod void testSendGetRequest() {
		Test.startTest();
		HTTPResponse res = MercuryApiUtilities.sendGetRequest('Opportunity', ((String) oppo.id).left(15));
		System.assertEquals(200, res.getStatusCode());
		Test.stopTest();
	}

	private static testMethod void testCheckRecord() {
		Test.startTest();
		System.assert(MercuryApiUtilities.checkRecord('Opportunity', ((String) oppo.id).left(15)));
		Test.stopTest();
	}

	private static testMethod void testGetAuthToken() {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
		System.assertEquals('aaf498ce-fc28-4e0c-a2c3-63cfd7d6ff18', MercuryApiUtilities.getAuthToken());
		Test.stopTest();
	}

	// 	private static testMethod void testCreateSecondApplicationInMercury() {
	// 		MercuryApiUtilities.createSecondApplicationInMercury('token', account.id);
	// 		system.assert(true);
	// 	}

	private static testMethod void testCreateIncomeAndExpense() {
		Account acc = TestUtilities.createAccount();
		acc.mercury_People_ID__c = '9c6f5809-08b1-464a-9cc7-71b31903e0aa';
		insert acc;

		Income_And_Expense__c iae = TestUtilities.createIncomeAndExpense();
		iae.account__c = acc.id;
		iae.amount__c = 1;
		iae.balance__c = 2;
		iae.credit_Limit__c = 3;
		iae.category__c = 'Salary';
		iae.frequency__c = 'Yearly';
		iae.recordTypeId = IncomeRecordType.getInstance().id;
		insert iae;

		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
		MercuryApiUtilities.createIncomeAndExpense(iae, acc, 'P200019');
		Test.stopTest();
	}

}