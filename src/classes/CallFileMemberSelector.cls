/**
 * Author: Anthony Xuan
 * Create Date: 19/01/2016
 */
public class CallFileMemberSelector extends SObjectSelector {
    public CallFileMemberSelector() {
        super('vhc__Campaign_Member__c', null, null);
    }

    public CallFileMemberSelector(Set<String> specFields, Set<String> excludeFields) {
        super('vhc__Campaign_Member__c', specFields, excludeFields);
    }

    public List<vhc__Campaign_Member__c> getById(List<Id> ids) {
        return (List<vhc__Campaign_Member__c>) super.selectByIds(ids);
    }

    // public List<vhc__Campaign_Member__c> getByConditionMatching(Map<String, String> conditionMap) {
    //     return (List<vhc__Campaign_Member__c>) super.selectByConditionMatching(conditionMap);
    // }

    public List<vhc__Campaign_Member__c> getByOpenCondition(String condition) {
        return (List<vhc__Campaign_Member__c>) super.selectByOpenCondition(condition);
    }
}
