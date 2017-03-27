public class ScheduleUpdateCallFilePriority {
	public void execute(SchedulableContext ctx) {
		List<vhc__Campaign_Member__c> members = new List<vhc__Campaign_Member__c>();
		for (vhc__Campaign_Member__c member : [Select Id, Already_Update_Priority__c, Times_Of_Email_Open__c, vhc__Priority__c From vhc__Campaign_Member__c where Times_Of_Email_Open__c > 0 and Already_Update_Priority__c != true and vhc__Priority__c != 'HIGH']) {
			member.vhc__Priority__c = 'High';
			members.add(member);
		}
		update members;
	}
}