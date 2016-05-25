public with sharing class IncomeAndExpenseRecordType {
	private static IncomeAndExpenseRecordType instance = null;
	public Map<String, Schema.RecordTypeInfo> rtMapByName;
	public Map<Id, Schema.RecordTypeInfo> rtMapById;

	private IncomeAndExpenseRecordType() {
		Schema.DescribeSObjectResult describe = Asset_And_Liability__c.sObjectType.getDescribe();
		rtMapByName = describe.getRecordTypeInfosByName();
		rtMapById = describe.getRecordTypeInfosById();
	}

	public static IncomeAndExpenseRecordType getInstance() {
		if(instance == null) instance = new IncomeAndExpenseRecordType();
		return instance;
	}
}
