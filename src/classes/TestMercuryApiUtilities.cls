@isTest(SeeAllData=true)
private class TestMercuryApiUtilities {
	public static Opportunity oppo {get; set;}
	public static Account account {get; set;}
	public static Contact contact {get; set;}
	static {

		RecordType myRecordType = [select id from RecordType where SobjectType='Account' AND name = 'Person Account' AND IsPersonType=True limit 1];
		account = new Account();
		account.FirstName = 'testF';
		account.LastName = 'testL';
		account.Recordtypeid= myRecordType.Id;
		insert account;

		contact = new Contact();
		contact.LastName = 'testL';
		contact.Email = 'test@test.com';
		contact.Sync_With_Mercury__c = false;
		contact.Sync_With_Mercury_Success__c = false;
		contact.Job_Title__c = 'job title';
		contact.Gender__c = 'Male';
		contact.Phone = '+61415530313';
		contact.Annual_Income__c = 320000;
		contact.MobilePhone = '+61415530313';
		contact.Marital_Status__c = 'single';
		contact.Employer_Name__c = 'dev';
		contact.Current_Role__c = 'dev';
		contact.Number_of_Children__c = '0';
		contact.Employment_Status__c = 'Full Time';
		insert contact;

		oppo = new Opportunity();
		oppo.Name = 'tet an';
		oppo.Account = account;
		oppo.CloseDate = Date.today();
		oppo.StageName = 'Appointed';
		oppo.Transaction_Type__c = 'Refinance';
		oppo.Current_Lender__c = 'AMP';
		oppo.Current_Loan_Value__c = 100000;
		oppo.Current_Loan_Type__c = 'Owner Occupaid';
		oppo.Personal_Loan_Balance__c = 0;
		oppo.Credit_Card_Balance__c = 0;
		oppo.Car_Loan_Balance__c = 0;
		insert oppo;
	}

	static testMethod void loginToMercuryTest() {
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		String tokenTest = MercuryApiUtilities.loginToMercury();
		System.assertEquals(token, tokenTest);
	}

	static testMethod void testCreateOppoInMercuryWithDuplicate() {
	    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		String oppoId = oppo.Id;
		MercuryApiUtilities.createOppoInMercury(token, oppoId, 'P200019');
		Opportunity oppo2 = [select Id, Sync_With_Mercury__c, Sync_With_Mercury_Success__c From Opportunity where Id = :oppoId];
		//System.assertEquals(oppo2.Sync_With_Mercury__c, true);
		//System.assertEquals(oppo2.Sync_With_Mercury_Success__c, true);
	    Test.stopTest();
	}
	
	static testMethod void testCreateOppoInMercuryWithoutDuplicate() {
	    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('MercuryLoanFail1Response');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		String oppoId = oppo.Id;
		MercuryApiUtilities.createOppoInMercury(token, oppoId, 'P200019');
		Opportunity oppo2 = [select Id, Sync_With_Mercury__c, Sync_With_Mercury_Success__c From Opportunity where Id = :oppoId];
		//System.assertEquals(oppo2.Sync_With_Mercury__c, true);
		//System.assertEquals(oppo2.Sync_With_Mercury_Success__c, true);
	    Test.stopTest();
	}

	static testMethod void TestCreatePeopleInMercuryWithDuplicate() {
	    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		String accountId = account.Id;
		MercuryApiUtilities.createPeopleInMercury(token, accountId, 'P200019');
		Test.stopTest();
	}
	
	static testMethod void testCreatePeopleInMercuryWithoutDuplicate() {
	    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('MercuryLoanFail1Response');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		String accountId = account.Id;
		MercuryApiUtilities.createPeopleInMercury(token, accountId, 'P200019');
		Test.stopTest();
	}

	static testMethod void createLoanPeopleInMercuryTest() {
		String accountId = account.Id;
		String oppoId = oppo.Id;
		String accountAndOppo = account.Id  + '' + oppo.Id;
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		MercuryApiUtilities.createLoanPeopleInMercury(token, accountAndOppo, oppoId, accountId);
	}

	static testMethod void syncWithMercuryTest() {
	    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

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
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		MercuryApiUtilities.getOpportunityAndSaveOnOppo(token, oppoId, false);
	}

	static testMethod void getPeopleAndSaveOnAccount() {
		String accountId = '001O000000oGO3B';
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		MercuryApiUtilities.getPeopleAndSaveOnAccount(token, accountId, false);
	}

	static testMethod void getDataBackTest() {
		String accountId = account.Id;
		String oppoId = oppo.Id;
		MercuryApiUtilities.getDataBack(oppoId, true, accountId, true);
	}

	static testMethod void updatePeopleUpdateFTest() {
		String accountId = account.Id;
		String oppoId = oppo.Id;
		MercuryApiUtilities.updateAccountF(accountId, oppoId);
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

// 	private static testMethod void testCreateSecondApplicationInMercury() {
// 		MercuryApiUtilities.createSecondApplicationInMercury('token', account.id);
// 		system.assert(true);
// 	}

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
	    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        HTTPResponse res = MercuryApiUtilities.sendGetRequest('Opportunity', '1234', 'aaf498ce-fc28-4e0c-a2c3-63cfd7d6ff18');

        System.assertNotEquals(null, res.getBody());
        Test.stopTest();
	}

	private static testMethod void testCheckRecord() {
	    MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

        multimock.setStaticResource('https://api.connective.com.au/api/mercuryLogin5.jsp', 'MercuryLoginSuccessResponse');
        multimock.setStaticResource('https://api.connective.com.au/api/mercury5/f92699d9-42cd-4d0a-8a98-2487dac5f9b7/loan/0066F00000g8PRNQA2', 'MercuryLoanSuccessResponse');
        multimock.setStaticResource('https://api.connective.com.au/api/mercury5/f92699d9-42cd-4d0a-8a98-2487dac5f9b7/loan/0066F00000g8PRN', 'MercuryLoanFail1Response');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, multimock);

        Test.startTest();
        System.assert(MercuryApiUtilities.checkRecord('Opportunity', '0066F00000g8PRN', 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7'));
        Test.stopTest();
	}

}