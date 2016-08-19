public with sharing class AssetAndLiabilityRecordType {
	private static AssetAndLiabilityRecordType instance = null;
	public Map<String, Schema.RecordTypeInfo> rtMapByName;
	public Map<Id, Schema.RecordTypeInfo> rtMapById;

	private AssetAndLiabilityRecordType() {
		Schema.DescribeSObjectResult describe = Asset_And_Liability__c.sObjectType.getDescribe();
		rtMapByName = describe.getRecordTypeInfosByName();
		rtMapById = describe.getRecordTypeInfosById();
	}

	public static AssetAndLiabilityRecordType getInstance() {
		if(instance == null) instance = new AssetAndLiabilityRecordType();
		return instance;
	}
}