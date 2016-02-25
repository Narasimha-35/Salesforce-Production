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
			MercuryApiUtilities.syncWithMercury(oppoId, accountId);
		} catch (Exception e) {

		}
	}

	@future(callout=true)
	public static void futureSyncWithMercury(Id reqId) {
		AsyncRequestSelector ars = new AsyncRequestSelector();
		AsyncRequest__c req = ars.getById(new List<Id>{reqId})[0];
		Map<String, Object> param = (Map<String, Object>) JSON.deserializeUntyped((String)(req.get('params__c')));
		try {
			MercuryApiUtilities.syncWithMercury((String) param.get('oppoId'), (String) param.get('accId'));
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

	public static MercuryModel.Loan getLoan(String uniqueId) {
		HttpResponse res = MercuryApiUtilities.sendGetRequest('Opportunity', uniqueId);
		MercuryModel.LoanResponse lr = (MercuryModel.LoanResponse) JSON.deserialize(res.getBody(), MercuryModel.LoanResponse.class);
		if(lr.success) return lr.loans[0];
		return null;
	}

	public static void syncBackLoan(Integer method) {
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
		AsyncRequestService.addSyncBackRequest('Opportunity', ids);
	}

}
