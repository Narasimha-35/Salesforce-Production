@isTest
private class TestCallFileService {

	private static testMethod void testGetAllCallFiles() {
        System.assertEquals([SELECT id FROM vhc__Campaign__c].size(), CallFileService.getAllCallFiles().size());
	}
	
	private static testMethod void testGetCallFileSelectionOptions() {
	    System.assertEquals([SELECT id FROM vhc__Campaign__c].size(), CallFileService.getCallFileSelectionOptions(CallFileService.getAllCallFiles()).size());
	}

}