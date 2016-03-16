global with sharing class MercuryRetrieveScheduler1 implements Schedulable {

	global void execute(SchedulableContext SC) {
		MercuryService.syncBackLoan(1);
	}

}
