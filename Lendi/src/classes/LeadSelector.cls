public with sharing class LeadSelector extends SObjectSelector {

	public LeadSelector() {
		super('Lead', null, null);
	}

	public LeadSelector(Set<String> specFields, Set<String> excludeFields) {
		super('Lead', specFields, excludeFields);
	}

	public List<Lead> getById(List<Id> ids) {
		return (List<Lead>) super.selectByIds(ids);
	}

	public Lead getById(Id rid) {
		return (Lead) super.selectByIds(new List<Id>{rid})[0];
	}

}