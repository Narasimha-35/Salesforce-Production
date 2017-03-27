global without sharing class ScheduleGetDNCResult implements Schedulable {
	global String referenceId;
	global String leadId;
	
	public ScheduleGetDNCResult(String aReferenceId, String aLeadId) {
		this.referenceId = aReferenceId;
		this.leadId = aLeadId;
	}
	
	global void execute(SchedulableContext ctx) { 
		DNCWashUtilities.getWashResult(referenceId, leadId);
	}
}