@isTest
private class TestCallFileMemberDomain {

	private static testMethod void test() {
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
      
      CallFileMemberDomain cfmd = new CallFileMemberDomain(cml);
      cfmd.updatePriority('HIGH', true);
      for(vhc__Campaign_Member__c cm : cfmd.records) {
          System.assertEquals('HIGH', cm.vhc__Priority__c);
        System.assertEquals(true, cm.Update_Priority_By_Postcode__c);
      }
	}
	
	private static testMethod void testGetPickListItem() {
	    System.assertEquals(Schema.SObjectType.vhc__Campaign_Member__c.fields.getMap().get('vhc__Priority__c').getDescribe().getPicklistValues(), CallFileMemberDomain.getPickListItem('vhc__Priority__c'));
	    System.assertNotEquals(null, CallFileMemberDomain.generateSelectOptionByPickListEntry(CallFileMemberDomain.getPickListItem('vhc__Priority__c')));
	}

}