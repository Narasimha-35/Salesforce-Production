/**
 * Author: Anthony Xuan
 * Create Date: 19/01/2016
 * Last Modify By: Anthony Xuan
 * Last Modify Date : 21/01/2016
 */

public class CallFileMemberDomain {
    @testVisible
    private List<vhc__Campaign_Member__c> records = null;

    public CallFileMemberDomain(List<vhc__Campaign_Member__c> records) {
        this.records = records;
    }

    public void commitUpdate() {
        update records;
    }

    public List<vhc__Campaign_Member__c> updatePriority(String priority, Boolean isByPostcode) {
        For(vhc__Campaign_Member__c  cm : records) {
            cm.Update_Priority_By_Postcode__c = isByPostcode;
            cm.vhc__Priority__c = priority;
        }
        return records;
    }

    public static List<Schema.PicklistEntry> getPickListItem(String fieldName) {
        Schema.DescribeFieldResult fieldResult = Schema.SObjectType.vhc__Campaign_Member__c.fields.getMap().get(fieldName).getDescribe();
        return fieldResult.getPicklistValues();
    }

    public static List<SelectOption> generateSelectOptionByPickListEntry(List<Schema.PicklistEntry> plel) {
        List<SelectOption> ret = new List<SelectOption>();

        for(Schema.PicklistEntry ple : plel) {
            if(ple.isActive()) ret.add(new SelectOption(ple.getValue(), ple.getValue()));
        }

        return ret;
    }

}
