@isTest(SeeAllData=true)
private class TestPrioritiseCampaignMemberCtrl {

	private static testMethod void test() {
        PrioritiseCampaignMemberCtrl ctrl = new PrioritiseCampaignMemberCtrl();
        ctrl.postcodeFrom = ' 2000 ';
        ctrl.postcodeTo = ' 30000 ';
        ctrl.cleanInputs();
        System.assertEquals('2000', ctrl.postcodeFrom);
        System.assertEquals('30000', ctrl.postcodeTo);
        System.assert(ctrl.validatePostcode(ctrl.postcodeFrom));
        System.assert(!ctrl.validatePostcode(ctrl.postcodeTo));
        List<vhc__Campaign__c> callFiles = CallFileService.getAllCallFiles();
        
        ctrl.callFiles = callFiles;
        System.assert(ctrl.callFileOptions != null);
        System.assert(ctrl.priorityOptions != null);
        
        ctrl.selectedCallFileId = callFiles[0].id;
        ctrl.searchCallFileMembers();
        ctrl.priority = 'HIGH';
        System.assert(''.equals(ctrl.query));
        
        ctrl.postcodeTo = '3000';
        ctrl.searchCallFileMembers();
        System.assertEquals(CallFileMemberService.getCallFileMemberByCallFileAndPostcodeCount(callFiles[0], '2000', '3000', 'HIGH'), ctrl.selectedCallFileMemberSize);
        
        ctrl.query += ' LIMIT 200';
        ctrl.updateCallFileMembers();
	}

}