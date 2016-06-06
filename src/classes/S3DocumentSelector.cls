public with sharing class S3DocumentSelector extends SObjectSelector {
	public S3DocumentSelector() {
		super('S3Document__c', null, null);
	}

	public S3DocumentSelector(Set<String> specFields, Set<String> excludeFields) {
		super('S3Document__c', specFields, excludeFields);
	}

	public List<S3Document__c> getById(List<Id> ids) {
		return (List<S3Document__c>) super.selectByIds(ids);
	}

	public S3Document__c getById(Id rid) {
		return (S3Document__c) super.selectByIds(new List<Id>{rid})[0];
	}

	public List<S3Document__c> getFailedDocuments() {
		return (List<S3Document__c>) super.selectByOpenCondition('WHERE isSuccess__c = false');
	}
}
