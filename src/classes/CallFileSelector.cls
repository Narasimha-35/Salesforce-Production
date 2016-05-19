/**
 * Author: Anthony Xuan
 * Create Date: 20/01/2016
 */

public class CallFileSelector extends SObjectSelector {
   public CallFileSelector() {
        super('vhc__Campaign__c', null, null);
   }

   public CallFileSelector(Set<String> specFields, Set<String> excludeFields) {
        super('vhc__Campaign__c', specFields, excludeFields);
   }

   public List<vhc__Campaign__c> getById(List<Id> ids) {
        return (List<vhc__Campaign__c>) super.selectByIds(ids);
   }

   public List<vhc__Campaign__c> getByOpenCondition(String condition) {
        return (List<vhc__Campaign__c>) super.selectByOpenCondition(condition);
   }
}