global without sharing class ScheduleGetPardotActivity implements Schedulable {
	global void execute(SchedulableContext ctx) { 
		BatchLeadActivityUpdate job = new BatchLeadActivityUpdate();
		database.executebatch(job, 1);
	}
}