public class LendiProductService {
	public static List<ErrorLog__c> errorLogs = new List<ErrorLog__c>();

	@future(callout=true)
	public static void persistServiceCalculator(Id oppoProdId, Double loanAmount, Double securityValue) {
		Opportunitylineitem oppoProd = [SELECT id, assessmentRate__c, rateBuffer__c, click_Type__c, acfRate__c, product2Id, product2.click_Loans_Bank_Detail__c, opportunityId, click_Tenure__c, interest_Only_term__c FROM OpportunityLineItem WHERE id = :oppoProdId];
		if(validateProductData(oppoProd) || validateLoanData(loanAmount, securityValue)) {
			ServicingCalculator__c sfSC = new ServicingCalculator__c();
			sfSc.opportunityId__c = oppoProd.opportunityId;
			insert sfSc;
			insertErrorLog(sfSc);
			return;
		}

		LendiApiService lendiService = new LendiApiService();
		LendiModel.ServiceCalculator lendiSC;
		if(Test.isRunningTest()) {
			lendiSC = new LendiModel.ServiceCalculator();
		} else {
			lendiSC = lendiService.getLendiServiceCalculator(oppoProd, loanAmount, securityValue);
		}
		if(lendiSC == null) return;
		ServicingCalculator__c sfSC = lendiSC.convertToServiceCalculator(oppoProd.opportunityId);

		SavePoint sp = Database.setSavepoint();
		Database.SaveResult scRes = Database.insert(sfSC, false);

		List<ServiceCalculatorDetail__c> incomeAndExpenseSCDS = lendiSC.generateDetails(sfSC.id, LendiModel.INCOME_TYPE);
		List<ServiceCalculatorDetail__c> expensesSCDS         = lendiSC.generateDetails(sfSC.id, LendiModel.EXPENSE_TYPE);
		incomeAndExpenseSCDS.addAll(expensesSCDS);
		List<Database.SaveResult> incomeAndExpenseSCDetailRes = Database.insert(incomeAndExpenseSCDS, false);

		System.debug(incomeAndExpenseSCDetailRes);

		List<ServiceCalculatorDetail__c> liabilitiesSCDS      = lendiSC.generateDetails(sfSC.id, LendiModel.LIABILITY_TYPE);
		List<Database.SaveResult> liabilitiesSCDetailRes      = Database.insert(liabilitiesSCDS, false);

		System.debug(liabilitiesSCDetailRes);
	}

	public static Boolean validateLoanData(Double loanAmount, Double securityValue) {
		Boolean ret = false;
		if(loanAmount == null || loanAmount == 0) {
			stageErrorLog('Loan amount can not be null or 0, please check.');
			ret = true;
		}
		if(securityValue == null || securityValue == 0) {
			stageErrorLog('Security value can not be null or 0, please check.');
			ret = true;
		}
		return ret;
	}

	public static Boolean validateProductData(Opportunitylineitem oppoProd) {
		Boolean ret = false;

		if(oppoProd.product2Id == null) {
			stageErrorLog('Product id can not be null, please check.');
			ret = true;
		}
		if(oppoProd.click_Tenure__c == null || oppoProd.click_Tenure__c == '') {
			stageErrorLog('Product tenure can not be null, please check.');
			ret = true;
		}
		if(oppoProd.click_Type__c == null || oppoProd.click_Type__c == '') {
			stageErrorLog('Product loan type can not be null, please check.');
			ret = true;
		}
		if(oppoProd.assessmentRate__c == null || oppoProd.assessmentRate__c == 0) {
			stageErrorLog('Product assessment rate can not be null nor 0, please check.');
			ret = true;
		}
		if(oppoProd.acfRate__c == null || oppoProd.acfRate__c == 0) {
			stageErrorLog('Product rate can not be null nor 0, please check.');
			ret = true;
		}
		if(oppoProd.rateBuffer__c == null || oppoProd.rateBuffer__c == 0) {
			stageErrorLog('Product rate buffer can not be null nor 0, please check.');
			ret = true;
		}
		if(oppoProd.product2.click_Loans_Bank_Detail__c == null) {
			stageErrorLog('Product bank id can not be null, please check.');
			ret = true;
		}
		if(oppoProd.interest_Only_term__c == null) {
			stageErrorLog('Product interest only term can not be null, please check.');
			ret = true;
		}
		return ret;
	}

	public static void stageErrorLog(String msg) {
		System.debug(msg);
		ErrorLog__c e = new ErrorLog__c();
		e.message__c = msg;
		e.name = msg;
		errorLogs.add(e);
	}

	public static void insertErrorLog(ServicingCalculator__c sfSC) {
		for(ErrorLog__c el : errorLogs) {
			el.servicingCalculator__c = sfSc.id;
		}
		insert errorLogs;
	}

}
