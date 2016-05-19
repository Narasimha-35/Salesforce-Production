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

	//return null is there is no way to match since there is nothing in potential FieldSet
	//else return a list of similar Accounts
	public List<Account> getSimilarAccountsByAccount(Account acc, Set<String> fieldNameSet, String idField) {
		List<Account> ret = null;
		Id temp = Utilities.castId((String) acc.get(idField));
		if(temp != null) ret = getById(new List<Id>{temp});
		if(ret != null && ret.size() == 1) return ret;

		String condition = 'WHERE ';
		for(String field : fieldNameSet) {
			if(acc.get(field) != null && acc.get(field) != ''){
				condition += ' OR ' + field + ' LIKE \'' + acc.get(field) + '\'';
			}
		}
		if(condition == 'WHERE ') return null;
		condition = condition.replaceFirst(' OR ', '');
		ret = (List<Account>) super.selectByOpenCondition(condition);
		return ret;
	}

}