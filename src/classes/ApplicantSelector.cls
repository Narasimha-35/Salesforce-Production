public with sharing class ApplicantSelector extends SObjectSelector {
	public ApplicantSelector() {
		super('Click_Applicant__c', null, null);
	}

	public ApplicantSelector(Set<String> specFields, Set<String> excludeFields) {
		super('Click_Applicant__c', specFields, excludeFields);
	}

	public List<Click_Applicant__c> getById(List<Id> ids) {
		return (List<Click_Applicant__c>) super.selectByIds(ids);
	}

	public Click_Applicant__c getById(Id rid) {
		return (Click_Applicant__c) super.selectByIds(new List<Id>{rid})[0];
	}
}
