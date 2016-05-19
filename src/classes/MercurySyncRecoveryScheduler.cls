public with sharing class MercurySyncRecoveryScheduler implements Schedulable {

	//only recover 401, 5+, 503
	public void execute(SchedulableContext ctx) {
		if(!MercurySettings__c.getOrgDefaults().RecoverSyncFailure__c) return;
		AsyncRequestSelector ars = new AsyncRequestSelector();
		List<AsyncRequest__c> reqs = ars.getFailedRequests('' + AsyncRequestType.SF_TO_MERCURY);
		reqs.addAll(ars.getFailedRequests('' + AsyncRequestType.MERCURY_TO_SF));

		List<AsyncRequest__c> recoverList = new List<AsyncRequest__c>();
		for(AsyncRequest__c r : reqs){
			if(r.ErrorMessage__c.contains('StatusCode=401') || r.ErrorMessage__c.contains('StatusCode=503') || r.ErrorMessage__c.contains('Invalid integer: 5+')) {
				r.Failed__c = false;
				recoverList.add(r);
			}
		}
		System.debug(LoggingLevel.INFO, '[MercurySyncRecoveryScheduler] Recover List ' + recoverList);
		update recoverList;

		if(!ACFSwitch__c.getOrgDefaults().QueuedAsyncRequestSwitch__c) return;
		AsyncApexJobSelector aajs = new AsyncApexJobSelector();
		if(recoverList.size() != 0 && aajs.getInCompleteJobs().size() == 0) {
			System.debug(LoggingLevel.INFO, '[MercurySyncRecoveryScheduler] Execute Async Request...');
			Database.executeBatch(new MercuryRequestBatch(0), 1);
		}
	}

}