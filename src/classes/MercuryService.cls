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

}
