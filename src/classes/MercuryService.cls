/**
* See https://github.com/financialforcedev/fflib-apex-common for more info
*
* Install library via
*   https://githubsfdeploy.herokuapp.com/app/githubdeploy/financialforcedev/fflib-apex-common
*/

/**
* Encapsulates all service layer logic for a given function or module in the application
*
* For more guidelines and details see
*   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Service_Layer
*
**/
public class MercuryService {

	public class MercurySyncException extends Exception {
		private List<Exception> exceptionList = null;

		public MercurySyncException(List<Exception> exceptionList) {
			this.exceptionList = exceptionList;
		}

		public List<Exception> getExceptions() {
			return exceptionList;
		}
	}

	public static final List<String> p1RequiredStatus;
	static {
		p1RequiredStatus = new List<String>{
			'Signed',
			'Signed - Additional Docs Required',
			'Submit to Production',
			'Submitted - On Hold',
			'AIP',
			'Submit to Production WIP',
			'Submitted',
			'Submitted MIR',
			'Conditional Approval',
			'Unconditional Approval',
			'Pending Settlement',
			'Settled (not paid)',
			'Settled'
		};
	}
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
		String branchId = MercuryApiUtilities.getBrokerBranch(oppoId);
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
			MercuryApiUtilities.sendEmail();
			throw new MercurySyncException(exceptions);
		}
	}

	public static Set<String> getSyncBackLoanId(Integer method) {
		MercuryModel.LoanResponse res = null;
		Set<String> ids = new Set<String>();
		if(method == 1) {
			for(String s : p1RequiredStatus) {
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

}
