global class MercuryService {
	public static MercurySettings__c mercSettings = MercurySettings__c.getOrgDefaults();
	public static MercuryModel.Params param1;
	static {
		param1 = new MercuryModel.Params();
		param1.transactionType = 'loan';
		param1.transactionTypeRaw = 'loan';
		param1.groupBy = 'Current Status';
		param1.dateTo = Utilities.getGMTTime((DateTime) Date.today()).getTime();
		param1.dateFrom = Utilities.getGMTTime(((DateTime) Date.today()).addDays(-1)).getTime();
		param1.dateSearchType = 'Target Status';
	}
	public static MercuryModel.Params param2;
	static {
		param2 = new MercuryModel.Params();
		param2.transactionType = 'loan';
		param2.transactionTypeRaw = 'loan';
		param2.groupBy = 'Current Status';
		param2.dateFrom = Utilities.getGMTTime(Utilities.getCurrentMonthStartTime()).getTime();
		param2.dateTo = Utilities.getGMTTime(Utilities.getCurrentMonthStartTime().addMonths(3)).getTime();
		param2.dateSearchType = 'Settlement';
		param2.targetStatus = 'All';
	}

	@future(callout=true)
	public static void futureSyncWithMercury(String oppoId, String accountId) {
		try {
			MercuryService.syncWithMercury(oppoId, accountId);
		} catch (Exception e) {

		}
	}

	@future(callout=true)
	public static void futureSyncWithMercury(Id reqId) {
		AsyncRequestSelector ars = new AsyncRequestSelector();
		AsyncRequest__c req = ars.getById(new List<Id>{reqId})[0];
		Map<String, Object> param = (Map<String, Object>) JSON.deserializeUntyped((String)(req.get('params__c')));
		try {
			MercuryService.syncWithMercury((String) param.get('oppoId'), (String) param.get('accId'));
			Delete req;
		} catch (Exception e) {

		}
	}

	public static MercuryModel.LoanResponse getLoansFromMercury(String sfObjectName, String branchId, String searchType, MercuryModel.Params params) {
		MercuryModel.URLParams p = new MercuryModel.URLParams();
		p.currentPartnerId = branchId;
		p.searchType = searchType;
		p.params = params;
		HttpResponse res = MercuryApiUtilities.sendGetRequest(sfObjectName, p);
		System.debug(res.getBody());
		MercuryModel.LoanResponse lr = (MercuryModel.LoanResponse) JSON.deserialize(res.getBody(), MercuryModel.LoanResponse.class);
		return lr;
	}

	public static void syncWithMercury(String oppoId, String accountId)  {
		String branchId = MercuryUtility.getBrokerBranch(oppoId);
		Id oId = oppoId;
		Id aId = accountId;
		Opportunity oppo = null;
		Account account = null;
		List<Utilities.CalloutResponseException> exceptions = new List<Utilities.CalloutResponseException>();

		//Create Oppo
		System.debug(oppoId);
		System.debug(LoggingLevel.DEBUG, '[MercuryService] Check DML Limit: ' + Limits.getDMLRows());
		try {
			oppo = MercuryApiUtilities.createOppoInMercury(oppoId, branchId);
			System.debug(LoggingLevel.INFO, '[MercuryService.syncWithMercury] Sync Opportunity Success...');
		} catch (Utilities.CalloutResponseException e) {
			System.debug(LoggingLevel.INFO, '[MercuryService.syncWithMercury] Sync Opportunity Error: ' + e.getMessage());
			exceptions.add(e);
		}

		//Create People
		System.debug(accountId);
		System.debug(LoggingLevel.DEBUG, '[MercuryService] Check DML Limit: ' + Limits.getDMLRows());
		try {
			account = MercuryApiUtilities.createPeopleInMercury(accountId, branchId);
			System.debug(LoggingLevel.INFO, '[MercuryService.syncWithMercury] Sync Account Success...');
		} catch (Utilities.CalloutResponseException e) {
			System.debug(LoggingLevel.INFO, '[MercuryService.syncWithMercury] Sync Account Error: ' + e.getMessage());
			exceptions.add(e);
		}

		//Create Connection between Oppo and People
		String oppoAndaccountId = oId + '-' + aId;
		System.debug(LoggingLevel.DEBUG, '[MercuryService] Check DML Limit: ' + Limits.getDMLRows());
		MercuryApiUtilities.createLoanPeopleInMercury(oppoAndaccountId, oId, aId);

		if(oppo != null) update oppo;
		if(account != null) update account;
		if(exceptions.size() > 0) {
			MercuryUtility.sendEmail();
			throw new MercurySyncException(exceptions);
		}
	}

	public static Set<String> getSyncBackLoanId(Integer method) {
		MercuryModel.LoanResponse res = null;
		Set<String> ids = new Set<String>();
		if(method == 1) {
			for(String s : MercuryStaticValue.MERC_SYNC_TARGET_STATUS) {
				param1.targetStatus = s;
				res = getLoansFromMercury('Opportunity', 'P200019', 'businessStats', param1);
				System.debug(LoggingLevel.INFO, '[MercuryService] loans to update: ' + res);
				ids.addAll(res.idList);
			}
		} else if(method == 2) {
			res = getLoansFromMercury('Opportunity', 'P200019', 'businessStats', param2);
			System.debug(LoggingLevel.INFO, '[MercuryService] loans to update: ' + res);
			ids.addAll(res.idList);
		}
		return ids;
	}

	public static void syncBackLoan(Integer method) {
		AsyncRequestService.addSyncBackRequest('Opportunity', getSyncBackLoanId(method));
	}

	public static MercuryModel.Loan getLoan(String loanId) {
		HttpResponse res = MercuryApiUtilities.sendGetRequest('Opportunity', loanId);
		MercuryModel.LoanResponse lr = (MercuryModel.LoanResponse) JSON.deserialize(res.getBody(), MercuryModel.LoanResponse.class);
		if(lr.success) return lr.loans[0];
		return null;
	}

	public static List<MercuryModel.LoanPeople> getLoanPeole(String loanId) {
		MercuryModel.URLParams params = new MercuryModel.URLParams();
		params.loanId = loanId;
		params.method = 'getLoanPeople';
		HttpResponse res = MercuryApiUtilities.sendGetRequest('LoanPeople', params);
		MercuryModel.LoanPeopleResponse lr = (MercuryModel.LoanPeopleResponse) JSON.deserialize(res.getBody(), MercuryModel.LoanPeopleResponse.class);
		if(lr.success) return lr.loanPeople;
		return null;
	}

	public static MercuryModel.People getPeople(String peopleId) {
		HttpResponse res = MercuryApiUtilities.sendGetRequest('Account', peopleId);
		MercuryModel.PersonResponse pr = (MercuryModel.PersonResponse) JSON.deserialize(res.getBody(), MercuryModel.PersonResponse.class);
		if(pr.success) return pr.people;
		return null;
	}

	public static void startCleanMercuryOpportunityBatch() {
		MercuryOpportunityCleanUpBatch b = new MercuryOpportunityCleanUpBatch();
		Database.executeBatch(b, MercuryStaticValue.MERC_CLEAN_BATCH_SIZE);
	}

	webservice static void cleanMercuryOpportunity(String input) {
		MercuryService.startCleanMercuryOpportunityBatch();
	}

	webservice static void applyOnline(Id opportunityId) {
		insert AsyncRequestService.createApplyOnlineRequst(opportunityId);
	}

	//Only update the loan in Mercury
	public static void updateApplication(Opportunity oppo) {
		String branchId = MercuryUtility.getBrokerBranch(oppo.id);
		AccountSelector accSelector = new AccountSelector();
		Account acc = accSelector.getById(oppo.accountId);
		ApplicantSelector apts = new ApplicantSelector();
		List<Click_Applicant__c> applicants = apts.getByAccount(acc);
		IncomeAndExpenseSelector iaeSelector = new IncomeAndExpenseSelector();
		AssetAndLiabilitySelector aalSelecotr = new AssetAndLiabilitySelector();
		List<Asset_And_Liability__c> aalList = aalSelecotr.getByOpportunit(oppo);
		System.debug(LoggingLevel.DEBUG, '[MercuryService.updateApplication] Related A&L list: ' + (new Map<Id, Asset_And_Liability__c>(aalList)).keySet());

		//update loan details
		MercuryModel.Loan loan = new MercuryModel.Loan(oppo, branchId);
		System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to update loan id: ' + loan.uniqueId);
		if(updateLoan(loan)) {
			System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] update loan Success: ' + loan.uniqueId);
		} else {
			System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] update loan Fail: ' + loan.uniqueId);
		}
		for(Asset_And_Liability__c aal : aalList) {
			System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create A&L id: ' + aal.id);
			if(createAssetAndLiability(aal, loan, branchId)) {
				System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] create A&L Success: ' + aal.id);
			} else {
				System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] create A&L Fail: ' + aal.id);
			}
		}

		//upsert applicant details
		for(Click_Applicant__c applicant : applicants) {
			MercuryModel.People people;

			if('1' == applicant.click_Applicant_Number__c) {
				people = new MercuryModel.People(acc, branchId);
				System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to update primary applicant: ' + people.uniqueId);
				if(updatePeople(people)) {
					System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] update applicant Success: ' + people.uniqueId);
				} else {
					System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] update applicant Fail: ' + people.uniqueId);
				}
			} else {
				people = new MercuryModel.People(applicant, branchId);
				System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create applicant: ' + people.uniqueId);
				if(createPeople(people)) {
					System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] create applicant Success: ' + people.uniqueId);
				} else {
					System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] create applicant Fail: ' + people.uniqueId);
				}

				System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create loan people: ' + loan.uniqueId + '-' +  people.uniqueId);
				if(createLoanPeople(people, loan)) {
					System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] create loan people Success: ' + loan.uniqueId + '-' +  people.uniqueId);
				} else {
					System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] create loan people Fail: ' + loan.uniqueId + '-' +  people.uniqueId);
				}
			}

			List<Income_And_Expense__c> iaeList = iaeSelector.getByApplicantId(applicant.id);
			System.debug(LoggingLevel.DEBUG, '[MercuryService.updateApplication] Related Income and Expense list: ' + (new Map<Id, Income_And_Expense__c>(iaeList)).keySet());
			for(Income_And_Expense__c iae : iaeList) {
				System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create Income and Expense id: ' + iae.id);
				if(createIncomeAndExpense(iae, people, branchId)) {
					System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] create Income and Expense Success: ' + iae.id);
				} else {
					System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] create Income and Expense Fail: ' + iae.id);
				}
			}
		}

		System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create Address for Account: ' + acc.id);
		if(createAddress(acc, branchId)) {
			System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] create Address for Account Success: ' + acc.id);
		} else {
			System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] to create Address for Account Fail: ' + acc.id);
		}
	}

	public static Boolean createLoan(MercuryModel.Loan loan) {
		return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(loan));
	}

	public static Boolean updateLoan(MercuryModel.Loan loan) {
		return MercuryApiUtilities.handleResponse(MercuryApiUtilities.updateMercuryRecord(loan));
	}

	public static Boolean createPeople(MercuryModel.People people) {
		return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(people));
	}

	public static Boolean updatePeople(MercuryModel.People people) {
		return MercuryApiUtilities.handleResponse(MercuryApiUtilities.updateMercuryRecord(people));
	}

	public static Boolean createLoanPeople(MercuryModel.People people, MercuryModel.Loan loan) {
		return MercuryApiUtilities.handleResponse(MercuryApiUtilities.createLoanPeopleInMercury(people, loan));
	}

	public static Boolean createIncomeAndExpense(Income_And_Expense__c iae, MercuryModel.People people, String branchId) {
		Model mercModel;
		if(iae.recordTypeId == IncomeRecordType.getInstance().id) {
			System.debug('income');
			mercModel = new MercuryModel.Income(iae, people, branchId);
		} else if(iae.recordTypeId == ExpenseRecordType.getInstance().id) {
			System.debug('expense');
			mercModel = new MercuryModel.Expense(iae, people, branchId);
		}
		return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(mercModel));
	}

	public static Boolean createAddress(Account acc, String branchId) {
		MercuryModel.Address addr = new MercuryModel.Address(acc, branchId);
		return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(addr));
	}

	public static Boolean createAssetAndLiability(Asset_And_Liability__c aal, MercuryModel.Loan loan, String branchId) {
		Model mercModel;
		if(AssetAndLiabilityRecordType.getInstance().rtMapById.get(aal.recordTypeId).getName().startsWith('Asset')) {
			mercModel = new MercuryModel.Asset(aal, loan, branchId);
		} else {
			mercModel = new MercuryModel.Liability(aal, loan, branchId);
		}
		return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(mercModel));
	}

	public class MercurySyncException extends Exception {
		private List<Exception> exceptionList = null;

		public MercurySyncException(List<Exception> exceptionList) {
			this.exceptionList = exceptionList;
		}

		public List<Exception> getExceptions() {
			return exceptionList;
		}
	}

}
