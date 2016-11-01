global class ServicingCalculatorService {

	webservice static void ServicingCalculatorService(String oppoId) {
		List<Opportunitylineitem> oppoProds = [SELECT id, opportunityId, product2Id FROM Opportunitylineitem WHERE opportunityId = :oppoId];
		OpportunityProductUtil.persistServiceCalculator(new Map<Id, Opportunitylineitem>(oppoProds));
	}

}
