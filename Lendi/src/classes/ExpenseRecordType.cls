public with sharing class ExpenseRecordType {
	private static ExpenseRecordType instance = null;
	public String id;

	private ExpenseRecordType() {
		id = Income_And_Expense__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Expense').getRecordTypeId();
	}

	public static ExpenseRecordType getInstance() {
		if(instance == null) instance = new ExpenseRecordType();
		return instance;
	}
}