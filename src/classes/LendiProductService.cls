public class LendiProductService {

	@future(callout=true)
	public static void persistServiceCalculator(Id oppoId, Id prodId, Double amount) {
		LendiApiService lendiService                            = new LendiApiService();
		LendiModel.ServiceCalculator lendiSC                    = lendiService.getLendiServiceCalculator(oppoId, prodId, amount);
		ServicingCalculator__c sfSC                             = lendiSC.convertToServiceCalculator(oppoId);

		SavePoint sp                                            = Database.setSavepoint();
		Database.UpsertResult scRes                             = Database.upsert(sfSC, ServicingCalculator__c.Fields.opportunityId__c, false);

		List<ServiceCalculatorDetail__c> incomeAndExpenseSCDS   = lendiSC.generateDetails(sfSC.id, LendiModel.INCOME_TYPE);
		List<ServiceCalculatorDetail__c> expensesSCDS           = lendiSC.generateDetails(sfSC.id, LendiModel.EXPENSE_TYPE);

		incomeAndExpenseSCDS.addAll(expensesSCDS);
		List<Database.UpsertResult> incomeAndExpenseSCDetailRes = Database.upsert(incomeAndExpenseSCDS, ServiceCalculatorDetail__c.Fields.incomeAndExpenseId__c, false);

		List<ServiceCalculatorDetail__c> liabilitiesSCDS        = lendiSC.generateDetails(sfSC.id, LendiModel.LIABILITY_TYPE);
		List<Database.UpsertResult> liabilitiesSCDetailRes      = Database.upsert(liabilitiesSCDS, ServiceCalculatorDetail__c.Fields.assetAndLiabilityId__c, false);

		incomeAndExpenseSCDS.addAll(liabilitiesSCDS);
		Set<Id> newIds = (new Map<Id, ServiceCalculatorDetail__c>(incomeAndExpenseSCDS)).keySet();
		deleteServicingCalculatorDetail(newIds, oppoId);
	}

	public static void deleteServicingCalculatorDetail(Set<Id> idsToKeep, Id oppoId) {
		delete [SELECT id FROM ServiceCalculatorDetail__c WHERE id NOT IN :idsToKeep AND ServicingCalculator__r.opportunity__c = :oppoId];
	}

}
