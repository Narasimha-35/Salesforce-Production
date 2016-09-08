/*
* OpportunityProductUtil
*/
public class OpportunityProductUtil {

	public static void persistServiceCalculator(Map<Id, Opportunitylineitem> newMap) {
		if(newMap == null) return;
		Map<Id, Opportunitylineitem> dedupTally = new Map<Id, Opportunitylineitem>();
		for(Opportunitylineitem oppoProd : newMap.values()) {
			dedupTally.put(oppoProd.OpportunityId, oppoProd);
		}

		Map<Id, Double> totalLoans = OpportunityUtil.getTotalOpportunityLineItemValue(dedupTally.keySet());
		for(Opportunitylineitem oppoProd : dedupTally.values()) {
			LendiProductService.persistServiceCalculator(oppoProd.OpportunityId, oppoProd.Product2Id, totalLoans.get(oppoProd.OpportunityId));
		}
	}

	public static void deleteRelatedServiceCalculator(Map<Id, Opportunitylineitem> oldMap) {
		if(oldMap == null) return;
		Map<Id, Opportunitylineitem> dedupTally = new Map<Id, Opportunitylineitem>();
		for(Opportunitylineitem oppoProd : oldMap.values()) {
			dedupTally.put(oppoProd.OpportunityId, oppoProd);
		}

		try {
			Delete [SELECT id FROM ServicingCalculator__c WHERE opportunity__c IN :dedupTally.keySet()];

			List<Opportunitylineitem> oppoProds = [SELECT id, OpportunityId, Product2Id FROM Opportunitylineitem WHERE OpportunityId IN :dedupTally.keySet()];
			persistServiceCalculator(new Map<Id, Opportunitylineitem>(oppoProds));
		} catch (Exception e) {
			System.debug('[OpportunityProductUtil] Fail to delete Servicing Calulator...');
		}

	}

}
