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

	static testMethod void createOppoInMercuryTest() {
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		String oppoId = oppo.Id;
		MercuryApiUtilities.createOppoInMercury(token, oppoId, 'P200019');
		Opportunity oppo2 = [select Id, Sync_With_Mercury__c, Sync_With_Mercury_Success__c From Opportunity where Id = :oppoId];
		//System.assertEquals(oppo2.Sync_With_Mercury__c, true);
		//System.assertEquals(oppo2.Sync_With_Mercury_Success__c, true);
	}

	static testMethod void createPeopleInMercuryTest() {
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		String accountId = account.Id;
		MercuryApiUtilities.createPeopleInMercury(token, accountId, 'P200019');
	}

	static testMethod void createLoanPeopleInMercuryTest() {
		String accountId = account.Id;
		String oppoId = oppo.Id;
		String accountAndOppo = account.Id  + '' + oppo.Id;
		String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
		MercuryApiUtilities.createLoanPeopleInMercury(token, accountAndOppo, oppoId, accountId);
	}

	static testMethod void syncWithMercuryTest() {
		String accountId = account.Id;
		String oppoId = oppo.Id;
		MercuryApiUtilities.syncWithMercury(oppoId, accountId);
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
}