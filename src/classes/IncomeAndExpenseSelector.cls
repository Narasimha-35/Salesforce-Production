public with sharing class IncomeAndExpenseSelector extends SObjectSelector {
	public IncomeAndExpenseSelector() {
		super('Income_And_Expense__c', null, null);
	}

	public IncomeAndExpenseSelector(Set<String> specFields, Set<String> excludeFields) {
		super('Income_And_Expense__c', specFields, excludeFields);
	}

	public List<Income_And_Expense__c> getById(List<Id> ids) {
		return (List<Income_And_Expense__c>) super.selectByIds(ids);
	}

	public Income_And_Expense__c getById(Id rid) {
		return (Income_And_Expense__c) super.selectByIds(new List<Id>{rid})[0];
	}

	public List<Income_And_Expense__c> getByAccount(Account acc) {
		return (List<Income_And_Expense__c>) super.selectByOpenCondition('WHERE Account__c = \'' + acc.id + '\'');
	}
}
