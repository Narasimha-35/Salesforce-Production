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
		deleteServicingCalculatorDetail((new Map<Id, ServiceCalculatorDetail__c>(scds)).keySet(), oppoId);

		//TODO: if error roll back
		System.debug(scDetailRes);
	}

	public static void deleteServicingCalculatorDetail(Set<Id> idsToKeep, Id oppoId) {
		delete [SELECT id FROM ServiceCalculatorDetail__c WHERE id NOT IN :idsToKeep AND ServicingCalculator__r.opportunity__c =  :oppoId];
	}

}
