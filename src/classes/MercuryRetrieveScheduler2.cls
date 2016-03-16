global with sharing class MercuryRetrieveScheduler2 implements Schedulable {

	global void execute(SchedulableContext SC) {
		MercuryService.syncBackLoan(2);
	}

}
