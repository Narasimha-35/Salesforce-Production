public with sharing class RecordTypeSelector extends SObjectSelector{

	public RecordTypeSelector() {
		super('RecordType', null, null);
	}

	public RecordType getUniqueRecordType(String SObjectName, String DeveloperName) {
		String condition = 'WHERE SObjectType=\'' + SObjectName + '\' AND DeveloperName=\'' + DeveloperName + '\' AND IsActive=true';
		return (RecordType) super.selectByOpenCondition(condition)[0];
	}

}
