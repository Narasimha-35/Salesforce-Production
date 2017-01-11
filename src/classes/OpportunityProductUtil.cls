/*
* OpportunityProductUtil
*/
public class OpportunityProductUtil {

	public static void persistServiceCalculator(Map<Id, Opportunitylineitem> OppoProds) {
		if(OppoProds == null) return;
		Map<Id, Opportunitylineitem> dedupTally = new Map<Id, Opportunitylineitem>();
		for(Opportunitylineitem oppoProd : OppoProds.values()) dedupTally.put(oppoProd.opportunityId, oppoProd);

		List<ServicingCalculator__c> oldServiceCals = [SELECT id FROM ServicingCalculator__c WHERE opportunity__c IN :dedupTally.keySet()];
		Map<Id, Double> totalLoans = OpportunityUtil.getTotalOpportunityLineItemValue(dedupTally.keySet());
		for(Opportunitylineitem oppoProd : dedupTally.values()) {
			List<AggregateResult> aggregates = [SELECT sum(value__c) FROM Asset_and_liability__c WHERE opportunity__c = :oppoProd.opportunityId AND type__c = 'Asset' AND used_as_Security__c = true];
			Double securityValue = (Double) aggregates[0].get('expr0');
			LendiProductService.persistServiceCalculator(oppoProd.id, totalLoans.get(oppoProd.opportunityId), securityValue);
		}
		Delete oldServiceCals;
	}

}