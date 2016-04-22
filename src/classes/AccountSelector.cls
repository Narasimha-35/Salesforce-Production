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
		String condition = 'WHERE ';
		for(String s : matchList) {
			if(peop.get(s) != null && peop.get(s) != ''){
				condition += ' AND ' + mercuryAccountFieldNameMap.get(s) + ' LIKE \'' + peop.get(s) + '\'';
			} else {
				return null;
			}
		}
		condition = condition.replaceFirst(' AND ', '');
		return (List<Account>) super.selectByOpenCondition(condition);
	}

}
