public with sharing class MercurySyncRecoveryScheduler implements Schedulable {

	public void execute(SchedulableContext ctx) {
		System.debug(LoggingLevel.INFO, '[MercurySyncRecoveryScheduler] enter scheduler');
		if(!MercurySettings__c.getOrgDefaults().RecoverSyncFailure__c) return;
		AsyncRequestSelector ars = new AsyncRequestSelector();
		List<AsyncRequest__c> reqs = ars.getFailedRequests('sync to mercury');
		if(reqs.size() > 0) MercuryService.futureSyncWithMercury(reqs[0].id);

		System.schedule('Hourly', '0 0 * * * ?', new MercurySyncRecoveryScheduler());
	}

}
