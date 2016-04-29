public with sharing class AccountSelector extends SObjectSelector {
	private Map<String, String> mercuryAccountFieldNameMap = new Map<String, String> {
		'firstName' => 'firstName',
		'lastName'  => 'lastName',
		'email'     => 'PersonEmail'
	};
	private List<String> matchList = new List<String> {
		'email'
	};

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

	public List<Account> getByMercuryPeople(MercuryModel.People peop) {
		List<Account> ret = null;
		Id temp = Utilities.castId(peop.uniqueId);
		if(temp != null) ret = getById(new List<Id>{temp});
		if(ret.size() == 1) return ret;

		String condition = 'WHERE ';
		for(String s : matchList) {
			if(peop.get(s) != null && peop.get(s) != ''){
				condition += ' AND ' + mercuryAccountFieldNameMap.get(s) + ' LIKE \'' + peop.get(s) + '\'';
			} else {
				return null;
			}
		}
		condition = condition.replaceFirst(' AND ', '');
		ret = (List<Account>) super.selectByOpenCondition(condition);
		return ret;
	}

}
