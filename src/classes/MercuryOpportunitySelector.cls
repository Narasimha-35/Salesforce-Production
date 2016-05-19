public with sharing class MercuryOpportunitySelector extends SObjectSelector {
	public MercuryOpportunitySelector() {
		super('Mercury_Opportunity__c', null, null);
	}

	public MercuryOpportunitySelector(Set<String> specFields, Set<String> excludeFields) {
		super('Mercury_Opportunity__c', specFields, excludeFields);
	}

	public List<Mercury_Opportunity__c> getById(List<Id> ids) {
		return (List<Mercury_Opportunity__c>) super.selectByIds(ids);
	}

	public Mercury_Opportunity__c getById(Id rid) {
		return (Mercury_Opportunity__c) super.selectByIds(new List<Id>{rid})[0];
	}

	public Mercury_Opportunity__c getByMercuryUniqueId(String rid) {
		return (Mercury_Opportunity__c) super.selectByOpenCondition('WHERE merc_uniqueId__c = \'' + rid + '\'')[0];
	}

	public List<Mercury_Opportunity__c> getAll(Integer lmt) {
		return (List<Mercury_Opportunity__c>) super.selectByOpenCondition('', null, lmt);
	}
}