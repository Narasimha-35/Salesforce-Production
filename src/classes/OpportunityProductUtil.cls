/*
* OpportunityProductUtil
*/
public class OpportunityProductUtil {

	public static void persistServiceCalculator(Map<Id, Opportunitylineitem> OppoProds) {
		if(OppoProds == null) return;
		Map<Id, Opportunitylineitem> dedupTally = new Map<Id, Opportunitylineitem>();
		for(Opportunitylineitem oppoProd : OppoProds.values()) dedupTally.put(oppoProd.OpportunityId, oppoProd);

        List<ServicingCalculator__c> oldServiceCals = [SELECT id FROM ServicingCalculator__c WHERE opportunity__c IN :dedupTally.keySet()];
		Map<Id, Double> totalLoans = OpportunityUtil.getTotalOpportunityLineItemValue(dedupTally.keySet());
		for(Opportunitylineitem oppoProd : dedupTally.values()) {
			LendiProductService.persistServiceCalculator(oppoProd.OpportunityId, oppoProd.Product2Id, totalLoans.get(oppoProd.OpportunityId));
		}
		Delete oldServiceCals;
	}

}
