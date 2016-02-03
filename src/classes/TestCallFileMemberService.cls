@isTest(SeeAllData = true)
private class TestCallFileMemberService {

	private static testMethod void testGetPrioritySelectOption() {
	    System.assertEquals(CallFileMemberDomain.getPickListItem('vhc__Priority__c').size(), CallFileMemberService.getPrioritySelectOption().size());
	}
	
	private static testMethod void testGetCallFileMemberByCallFileAndPostcodeCount() {
	    List<vhc__Campaign__c> callFiles = CallFileService.getAllCallFiles();
	    CallFileMemberSelector cfms = new CallFileMemberSelector(new Set < String > {'PostCode__c', 'Update_Priority_By_Postcode__c', 'vhc__Priority__c'}, null);
	    String condition = CallFileMemberService.getSOQLCondition(callfiles[0], '2000', '3000', 'HIGH');
	    System.assertEquals(CallFileMemberService.getCallFileMemberByCallFileAndPostcodeCount(callfiles[0], '2000', '3000', 'HIGH'), cfms.selectCountByOpenCondition(condition));
	    
	    System.assertEquals(cfms.getQueryPartOne() + condition, CallFileMemberService.getSOQLQuery(callfiles[0], '2000', '3000', 'HIGH'));
	}
	
	private static testMethod void testUpdatePriority() {
	  List<vhc__Campaign__c> cl = TestUtilities.createTestCallFile(2);
      insert cl;
      Map<vhc__Campaign__c, Integer> campNumMap = new Map<vhc__Campaign__c, Integer>();
      for(vhc__Campaign__c c : cl) {
         campNumMap.put(c, 2);
      }
      List<vhc__Campaign_Member__c> cml = TestUtilities.createTestCallFileMember(campNumMap);
      insert cml;

      List<Id> ids = new List<Id>();
      for(vhc__Campaign_Member__c cm : cml) ids.add(cm.id);

      CallFileMemberService.updatePriority(cml, 'HIGH', true);
      for(vhc__Campaign_Member__c cm : cml){
        System.assertEquals('HIGH', cm.vhc__Priority__c);
        System.assertEquals(true, cm.Update_Priority_By_Postcode__c);
      } 
      
	}

}