public with sharing class S3DocumentRecoveryScheduler implements Schedulable {

	public void execute(SchedulableContext ctx) {
		S3DocumentRecoveryBatch b = new S3DocumentRecoveryBatch();
		Database.executeBatch(b, 10);
	}

}