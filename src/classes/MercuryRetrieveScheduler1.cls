global with sharing class MercuryRetrieveScheduler1 implements Schedulable {

	global void execute(SchedulableContext SC) {
        MercurySyncBackBatch msbb = new MercurySyncBackBatch(0);
		Database.executeBatch(msbb, 5);
	}

}