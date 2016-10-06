public class LendiProductService {

	@future(callout=true)
	public static void persistServiceCalculator(Id oppoId, Id prodId, Double amount) {
		LendiApiService lendiService                          = new LendiApiService();
		LendiModel.ServiceCalculator lendiSC                  = lendiService.getLendiServiceCalculator(oppoId, prodId, amount);
		if(lendiSC == null) return;
		ServicingCalculator__c sfSC                           = lendiSC.convertToServiceCalculator(oppoId);

		SavePoint sp                                          = Database.setSavepoint();
		Database.SaveResult scRes                             = Database.insert(sfSC, false);

		List<ServiceCalculatorDetail__c> incomeAndExpenseSCDS = lendiSC.generateDetails(sfSC.id, LendiModel.INCOME_TYPE);
		List<ServiceCalculatorDetail__c> expensesSCDS         = lendiSC.generateDetails(sfSC.id, LendiModel.EXPENSE_TYPE);
        incomeAndExpenseSCDS.addAll(expensesSCDS);
		List<Database.SaveResult> incomeAndExpenseSCDetailRes = Database.insert(incomeAndExpenseSCDS, false);

		List<ServiceCalculatorDetail__c> liabilitiesSCDS      = lendiSC.generateDetails(sfSC.id, LendiModel.LIABILITY_TYPE);
		List<Database.SaveResult> liabilitiesSCDetailRes      = Database.insert(liabilitiesSCDS, false);
	}

}
