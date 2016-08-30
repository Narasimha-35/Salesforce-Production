/*
* OpportunityProductUtil
*/
public class OpportunityProductUtil {

	public static void persistServiceCalculator(Map<Id, Opportunitylineitem> newMap) {
		Map<Id, Opportunitylineitem> dedupTally = new Map<Id, Opportunitylineitem>();
		for(Opportunitylineitem oppoProd : newMap.values()) {
			dedupTally.put(oppoProd.Opportunity.id, oppoProd);
		}

		Map<Id, Double> totalLoans = OpportunityUtil.getTotalOpportunityLineItemValue(dedupTally.keySet());
		for(Opportunitylineitem oppoProd : dedupTally.values()) {
			LendiProductService.persistServiceCalculator(oppoProd.Opportunity.id, oppoProd.Product2.id, totalLoans.get(oppoProd.Opportunity.id));
		}
	}

	public static void deleteRelatedServiceCalculator(Map<Id, Opportunitylineitem> oldMap) {
		Map<Id, Opportunitylineitem> dedupTally = new Map<Id, Opportunitylineitem>();
		for(Opportunitylineitem oppoProd : oldMap.values()) {
			dedupTally.put(oppoProd.Opportunity.id, oppoProd);
		}

		ServicingCalculator__c scs = [SELECT id FROM ServicingCalculator__c WHERE opportunity__c IN :dedupTally.keySet()];
		Delete scs;
		Map<Id, Double> totalLoans = OpportunityUtil.getTotalOpportunityLineItemValue(dedupTally.keySet());
		for(Opportunitylineitem oppoProd : dedupTally.values()) {
			LendiProductService.persistServiceCalculator(oppoProd.Opportunity.id, oppoProd.Product2.id, totalLoans.get(oppoProd.Opportunity.id));
		}
	}

}
