global with sharing class OpportunityService {

	webservice static void syncOppoToMercury(Id oppoId) {
		OpportunitySelector os = new OpportunitySelector();
		Opportunity o = os.getById(oppoId);

		system.debug(LoggingLevel.INFO, o);
		insert AsyncRequestService.createSyncToRequst(o.AccountId, o.id);
	}

}