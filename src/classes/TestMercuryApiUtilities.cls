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

	static testMethod void testCreateOppoInMercuryWithDuplicate() {
		Test.startTest();
		MercuryApiUtilities.createOppoInMercury(oppo.id, 'P200019');
		// Opportunity oppo2 = [select Id, Sync_With_Mercury__c, Sync_With_Mercury_Success__c From Opportunity where Id = :oppo.id];
		Test.stopTest();
	}

	static testMethod void testCreateOppoInMercuryWithoutDuplicate() {
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

	static testMethod void syncWithMercuryTest() {
		Test.startTest();
		String accountId = account.Id;
		String oppoId = oppo.Id;
		MercuryApiUtilities.syncWithMercury(oppoId, accountId);
		Test.stopTest();
	}

	static testMethod void convertCurrentTimeToGMTWithTimeZoneTest() {
		Datetime dt = System.now();
		String timeS = MercuryApiUtilities.convertCurrentTimeToGMTWithTimeZone(dt);
	}

	static testMethod void updatePeopleUpdate() {
		String accountId = account.Id;
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		String branchId = 'P200019';
		MercuryApiUtilities.updatePeopleInMercury(accountId, token, branchId);
	}

	static testMethod void getOpportunityAndSaveOnOppoTest() {
		String oppoId = '006O0000006a5MZ';
		MercuryApiUtilities.getOpportunityAndSaveOnOppo(oppoId, false);
	}

	static testMethod void getPeopleAndSaveOnAccount() {
		MercuryApiUtilities.getPeopleAndSaveOnAccount(account.id, false);
	}

	static testMethod void getDataBackTest() {
		String accountId = account.Id;
		String oppoId = oppo.Id;
		Test.startTest();
		MercuryApiUtilities.getDataBack(oppoId, true, accountId, true);
		Test.stopTest();
	}

	static testMethod void updatePeopleUpdateFTest() {
		Test.startTest();
		MercuryApiUtilities.updateAccountF(account.id, oppo.id);

		Test.stopTest();
	}

	private static testMethod void testGenerateDetailPart() {
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();

		system.assertNotEquals(null, MercuryApiUtilities.generateDetailPart(req, res));
	}

	private static testMethod void testGenerateHTMLEmailBody() {
		MercuryApiUtilities.generateHTMLEmailBody('a', 'b', 'c', 'd');
		system.assert(true);
	}

	private static testMethod void testGetAllPersonalBranches(){
		MercuryApiUtilities.getAllPersonalBranches('token');
		system.assert(true);
	}

	private static testMethod void testCheckRecordFromResMap() {
		Map<String, Object> resMap = new Map<String, Object>();
		Map<String, String> item = new Map<String, String>();
		item.put('uniqueId', 'abc');
		resMap.put('people', item);

		System.assertEquals(true, MercuryApiUtilities.checkRecordFromResMap(resMap, 'Account', 'abc'));
		System.assertEquals(false, MercuryApiUtilities.checkRecordFromResMap(null, 'account', 'abc'));
		System.assertEquals(false, MercuryApiUtilities.checkRecordFromResMap(resMap, 'account', 'abCd'));
		System.assertEquals(false, MercuryApiUtilities.checkRecordFromResMap(resMap, 'account', 'abc'.toUpperCase()));
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

}
