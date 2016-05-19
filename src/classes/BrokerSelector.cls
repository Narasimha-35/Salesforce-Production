public with sharing class BrokerSelector extends SObjectSelector {

	public BrokerSelector() {
		super('Broker__c', null, null);
	}

	public BrokerSelector(Set<String> specFields, Set<String> excludeFields) {
		super('Broker__c', specFields, excludeFields);
	}

	public List<Broker__c> getById(List<Id> ids) {
		return (List<Broker__c>) super.selectByIds(ids);
	}

	public Broker__c getById(Id rid) {
		return (Broker__c) super.selectByIds(new List<Id>{rid})[0];
	}

}