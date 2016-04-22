public with sharing class OpportunitySelector extends SObjectSelector{

	public OpportunitySelector() {
		super('Opportunity', null, null);
	}

	public OpportunitySelector(Set<String> specFields, Set<String> excludeFields) {
		super('Opportunity', specFields, excludeFields);
	}

	public List<Opportunity> getById(List<Id> ids) {
		return (List<Opportunity>) super.selectByIds(ids);
	}

	public Opportunity getById(Id rid) {
		return (Opportunity) super.selectByIds(new List<Id>{rid})[0];
	}

	public Opportunity getByMercuryId(String rid) {
		return (Opportunity) super.selectByOpenCondition('WHERE Mercury_Loan_Id__c LIKE \'' + rid + '\'')[0];
	}

	public List<Opportunity> getByAccountId(String rid) {
		return (List<Opportunity>) super.selectByOpenCondition('WHERE Accountid = \'' + rid + '\'');
	}
}
