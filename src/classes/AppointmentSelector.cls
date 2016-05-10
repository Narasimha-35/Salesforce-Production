public with sharing class AppointmentSelector extends SObjectSelector {

	public AppointmentSelector() {
		super('Appointment__c', null, null);
	}

	public AppointmentSelector(Set<String> specFields, Set<String> excludeFields) {
		super('Appointment__c', specFields, excludeFields);
	}

	public List<Appointment__c> getById(List<Id> ids) {
		return (List<Appointment__c>) super.selectByIds(ids);
	}

	public Appointment__c getById(Id rid) {
		return (Appointment__c) super.selectByIds(new List<Id>{rid})[0];
	}

}
