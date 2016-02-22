public with sharing class AsyncRequestSelector extends SObjectSelector{
	public AsyncRequestSelector() {
		super('AsyncRequest__c', null, null);
	}

	public List<AsyncRequest__c> getById(List<Id> ids) {
		return (List<AsyncRequest__c>) super.selectByIds(ids);
	}

	public List<AsyncRequest__c> getFailedRequests(String type) {
		return (List<AsyncRequest__c>) super.selectByOpenCondition('WHERE failed__c = true AND type__c = \'' + type + '\'');
	}
}