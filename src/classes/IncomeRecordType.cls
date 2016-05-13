public with sharing class IncomeRecordType {
	private static IncomeRecordType instance = null;
	public String id;

	private IncomeRecordType() {
		id = Income_And_Expense__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Income').getRecordTypeId();
	}

	public static IncomeRecordType getInstance() {
		if(instance == null) instance = new IncomeRecordType();
		return instance;
	}
}
