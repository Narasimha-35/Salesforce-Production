public with sharing class AccountSelector extends SObjectSelector {

	public AccountSelector() {
		super('Account', null, null);
	}

	public AccountSelector(Set<String> specFields, Set<String> excludeFields) {
		super('Account', specFields, excludeFields);
	}

	public List<Account> getById(List<Id> ids) {
		return (List<Account>) super.selectByIds(ids);
	}

	public Account getById(Id rid) {
		return (Account) super.selectByIds(new List<Id>{rid})[0];
	}

}
