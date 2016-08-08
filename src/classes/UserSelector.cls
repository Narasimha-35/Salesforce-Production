public with sharing class UserSelector extends SObjectSelector {
	public UserSelector() {
		super('User', null, null);
	}

	public UserSelector(Set<String> specFields, Set<String> excludeFields) {
		super('User', specFields, excludeFields);
	}

	public List<User> getById(List<Id> ids) {
		return (List<User>) super.selectByIds(ids);
	}

	public User getById(Id rid) {
		return (User) super.selectByIds(new List<Id>{rid})[0];
	}

	public List<User> getActiveUser() {
		return (List<User>) super.selectByOpenCondition('WHERE IsActive = true');
	}
}
