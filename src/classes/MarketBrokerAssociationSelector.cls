public with sharing class MarketBrokerAssociationSelector extends SObjectSelector {

	public MarketBrokerAssociationSelector() {
		super('Market_Broker_Association__c', null, null);
	}

	public MarketBrokerAssociationSelector(Set<String> specFields, Set<String> excludeFields) {
		super('Market_Broker_Association__c', specFields, excludeFields);
	}

	public List<Market_Broker_Association__c> getById(List<Id> ids) {
		return (List<Market_Broker_Association__c>) super.selectByIds(ids);
	}

	public Market_Broker_Association__c getById(Id rid) {
		return (Market_Broker_Association__c) super.selectByIds(new List<Id>{rid})[0];
	}

}
