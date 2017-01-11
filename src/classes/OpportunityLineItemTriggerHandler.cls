public class OpportunityLineItemTriggerHandler {

	public void afterInsert(Map<Id, Opportunitylineitem> newMap) {
		if(!ControlSwitchs.ServicingCalulator) return;
		OpportunityProductUtil.persistServiceCalculator(newMap);
	}

	public void afterUpdate(Map<Id, Opportunitylineitem> newMap, Map<Id, Opportunitylineitem> oldMap) {
		if(!ControlSwitchs.ServicingCalulator) return;
		OpportunityProductUtil.persistServiceCalculator(newMap);
	}

	public void afterDelete(Map<Id, Opportunitylineitem> oldMap) {
		if(!ControlSwitchs.ServicingCalulator) return;
		OpportunityProductUtil.persistServiceCalculator(oldMap);
	}

}