public class LendiProductService {

	@future(callout=true)
	public static void persistServiceCalculator(Id oppoId, Id prodId, Double amount) {
		LendiApiService lendiService = new LendiApiService();
		LendiModel.ServiceCalculator lendiSC = lendiService.getLendiServiceCalculator(oppoId, prodId, amount);
		ServicingCalculator__c sfSC = lendiSC.convertToServiceCalculator(oppoId);

		SavePoint sp = Database.setSavepoint();
		Database.UpsertResult scRes = Database.upsert(sfSC, ServicingCalculator__c.Fields.opportunityId__c, false);

		System.debug(sfSC.id);
		List<ServiceCalculatorDetail__c> scds = lendiSC.generateDetails(sfSC.id);
		System.debug(scds);
		List<Database.UpsertResult> scDetailRes = Database.upsert(scds, ServiceCalculatorDetail__c.Fields.incomeAndExpenseId__c, false);
		//TODO: delete other sc details

		System.debug(scDetailRes);
	}

}
