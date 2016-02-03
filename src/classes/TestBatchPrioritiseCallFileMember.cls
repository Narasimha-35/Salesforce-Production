@isTest
public class TestBatchPrioritiseCallFileMember {

   static testMethod void test() {
      List < vhc__Campaign__c > cfl = TestUtilities.createTestCallFile(2);
      insert cfl;
      Map < vhc__Campaign__c, Integer > campNumMap = new Map < vhc__Campaign__c, Integer > ();
      for (vhc__Campaign__c c: cfl) {
         campNumMap.put(c, 100);
      }
      List < vhc__Campaign_Member__c > cfml = TestUtilities.createTestCallFileMember(campNumMap);

      Lead tlead = new lead(PostalCode = '2000', lastname = 'test');
      insert tlead;

      for (vhc__Campaign_Member__c cfm: cfml) {
         cfm.vhc__Lead__c = tlead.id;
         cfm.vhc__Priority__c = 'LOW';
         cfm.Update_Priority_By_Postcode__c = false;
      }
      insert cfml;

      Test.startTest();
      String postcodeFrom = '2000';
      String postcodeTo = '2000';
      String newPriority = 'HIGH';

      String query = CallFileMemberService.getSOQLQuery(cfl[0], postcodeFrom, postcodeTo, newPriority);
      BatchPrioritiseCallFileMember cfBatch = new BatchPrioritiseCallFileMember(query, newPriority, false);
      Database.executeBatch(cfBatch, 200);

      Test.stopTest();

      CallFileMemberSelector cfms = new CallFileMemberSelector();
      List < vhc__Campaign_Member__c > res = cfms.getByOpenCondition('WHERE vhc__Campaign__c = \'' + cfl[0].id + '\'');
      for (vhc__Campaign_Member__c cfm: res) {
        System.assertEquals('HIGH', cfm.vhc__Priority__c);
      }
   }

}