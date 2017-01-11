trigger CallTrigger on vhc__Call__c ( 
    before insert, before update, before delete, 
  	after insert, after update, after delete, after undelete) {
		// add switch in
		ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
		if (acfSwitch != null && acfSwitch.get('Call_Trigger_Switch__c') != null && (Boolean) acfSwitch.get('Call_Trigger_Switch__c')) {
			new CallTriggerHandler().run();
		}
}