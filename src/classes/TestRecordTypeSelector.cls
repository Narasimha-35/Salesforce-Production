@isTest
private class TestRecordTypeSelector {

	private static testMethod void test() {
		RecordTypeSelector rts = new RecordTypeSelector();
		System.assertNotEquals(null, rts.getUniqueRecordType('Account', 'PersonAccount'));
	}

}
