public with sharing class MercurySyncRecoveryScheduler implements Schedulable {

	public void execute(SchedulableContext ctx) {
		if(!MercurySettings__c.getOrgDefaults().RecoverSyncFailure__c) return;
		AsyncRequestSelector ars = new AsyncRequestSelector();
		List<AsyncRequest__c> reqs = ars.getFailedRequests('sync to mercury');
		if(reqs.size() > 0) MercuryService.futureSyncWithMercury(reqs[0].id);
	}

}
