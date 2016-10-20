public class LendiProductService {

	@future(callout=true)
	public static void persistServiceCalculator(Id oppoProdId, Double amount) {
		Opportunitylineitem oppoProd = [SELECT id, assessmentRate__c, rateBuffer__c, click_Type__c, acfRate__c, product2Id, product2.click_Loans_Bank_Detail__c, opportunityId FROM OpportunityLineItem WHERE id = :oppoProdId];
		LendiApiService lendiService = new LendiApiService();
		LendiModel.ServiceCalculator lendiSC;
		if(Test.isRunningTest()) {
			lendiSC = new LendiModel.ServiceCalculator();
		} else {
			lendiSC = lendiService.getLendiServiceCalculator(oppoProd, amount);
		}
		if(lendiSC == null) return;
		ServicingCalculator__c sfSC = lendiSC.convertToServiceCalculator(oppoProd.opportunityId);

		SavePoint sp = Database.setSavepoint();
		Database.SaveResult scRes = Database.insert(sfSC, false);

		List<ServiceCalculatorDetail__c> incomeAndExpenseSCDS = lendiSC.generateDetails(sfSC.id, LendiModel.INCOME_TYPE);
		List<ServiceCalculatorDetail__c> expensesSCDS         = lendiSC.generateDetails(sfSC.id, LendiModel.EXPENSE_TYPE);
		incomeAndExpenseSCDS.addAll(expensesSCDS);
		List<Database.SaveResult> incomeAndExpenseSCDetailRes = Database.insert(incomeAndExpenseSCDS, false);

		List<ServiceCalculatorDetail__c> liabilitiesSCDS      = lendiSC.generateDetails(sfSC.id, LendiModel.LIABILITY_TYPE);
		List<Database.SaveResult> liabilitiesSCDetailRes      = Database.insert(liabilitiesSCDS, false);
	}

}
