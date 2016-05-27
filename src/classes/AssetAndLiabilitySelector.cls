public with sharing class AssetAndLiabilitySelector extends SObjectSelector{
	public AssetAndLiabilitySelector() {
		super('Asset_And_Liability__c', null, null);
	}

	public AssetAndLiabilitySelector(Set<String> specFields, Set<String> excludeFields) {
		super('Asset_And_Liability__c', specFields, excludeFields);
	}

	public List<Asset_And_Liability__c> getById(List<Id> ids) {
		return (List<Asset_And_Liability__c>) super.selectByIds(ids);
	}

	public Asset_And_Liability__c getById(Id rid) {
		return (Asset_And_Liability__c) super.selectByIds(new List<Id>{rid})[0];
	}

	public List<Asset_And_Liability__c> getByOpportunit(Opportunity oppo) {
		return (List<Asset_And_Liability__c>) super.selectByOpenCondition('WHERE Opportunity__c = \'' + oppo.id + '\'');
	}
}
