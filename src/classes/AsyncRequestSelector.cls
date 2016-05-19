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

	public List<AsyncRequest__c> getSyncBackRequests() {
		return (List<AsyncRequest__c>) super.selectByOpenCondition('WHERE type__c = \'' + AsyncRequestType.MERCURY_TO_SF + '\' AND failed__c = false');
	}

	public List<AsyncRequest__c> getPendingRequests(AsyncRequestType type) {
		return (List<AsyncRequest__c>) super.selectByOpenCondition('WHERE failed__c = false AND type__c = \'' + type + '\'');
	}
}