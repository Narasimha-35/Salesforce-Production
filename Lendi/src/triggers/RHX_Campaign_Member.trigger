trigger RHX_Campaign_Member on vhc__Campaign_Member__c (after delete, after insert, after undelete, after update, before delete) {

    Type rollClass = System.Type.forName('rh2', 'ParentUtil');
    
    if(rollClass != null) {
     rh2.ParentUtil pu = (rh2.ParentUtil) rollClass.newInstance();
        if (trigger.isAfter) {
            pu.performTriggerRollups(trigger.oldMap, trigger.newMap, new String[]{' vhc__Campaign_Member__c'}, null);
        }
    }
}