/**
 * Author: Anthony Xuan
 * Create Date: 19/01/2016
 */
@isTest
public class TestCallFileMemberSelector {

   static testMethod void testGetByIds() {
      List<vhc__Campaign__c> cl = TestUtilities.createTestCallFile(100);
      insert cl;
      Map<vhc__Campaign__c, Integer> campNumMap = new Map<vhc__Campaign__c, Integer>();
      for(vhc__Campaign__c c : cl) {
         campNumMap.put(c, 2);
      }
      List<vhc__Campaign_Member__c> cml = TestUtilities.createTestCallFileMember(campNumMap);
      insert cml;

      List<Id> ids = new List<Id>();
      for(vhc__Campaign_Member__c cm : cml) ids.add(cm.id);

      Test.startTest();

      //Test selection by specify field name
      CallFileMemberSelector cfms = new CallFileMemberSelector(new Set<String>{'name'}, null);
      List<vhc__Campaign_Member__c> res = cfms.getById(ids);
      System.assertEquals(ids.size(), res.size());
      try{
         res[0].get('name');
      } catch (Exception e) {
         //field name is not been selected
         System.assert(false);
      }
      //field 'name' is been selected
      System.assert(true);
      
      try{
          res[0].get('CreatedBy');
          System.assert(false);
      } catch (Exception e) {
          System.assert(true);
      }

      //Test selection by not specify field name
      cfms = new CallFileMemberSelector();
      res = cfms.getById(ids);
      System.assertEquals(ids.size(), res.size());
      try{
         res[0].get('name');
      } catch (Exception e) {
         //field name is not been selected
         System.assert(false);
      }
      //field 'name' is been selected
      System.assert(true);

      Test.stopTest();
   }
   
   static testMethod void testGetByOpenCondition() {
      List<vhc__Campaign__c> cl = TestUtilities.createTestCallFile(100);
      insert cl;
      Map<vhc__Campaign__c, Integer> campNumMap = new Map<vhc__Campaign__c, Integer>();
      for(vhc__Campaign__c c : cl) {
         campNumMap.put(c, 2);
      }
      List<vhc__Campaign_Member__c> cml = TestUtilities.createTestCallFileMember(campNumMap);
      insert cml;

      List<Id> ids = new List<Id>();
      for(vhc__Campaign_Member__c cm : cml) ids.add(cm.id);

      Test.startTest();
      
      CallFileMemberSelector cfms = new CallFileMemberSelector(new Set<String>{'name'}, null);
      List<vhc__Campaign_Member__c> res = cfms.getByOpenCondition('WHERE vhc__Campaign__c = \'' + cl[0].id + '\'');
      System.assertEquals(2, res.size());
      
      Test.stopTest();
   }

}