public class LeadWithCustomButtonControllerExtension {
	public Lead lead;
	public String currectCreditHistory {get; set;}
	public String employmentStatus {get; set;}
	public String housingStatus {get; set;}
	public String mortgageStatus {get; set;}
	public String interestType {get; set;}
	public String lastRefinance {get; set;}
	public String fixedExpiry {get; set;}
	public String lookingToBuy {get; set;}
	public Integer loadAmount {get; set;} 
	public Double interestRate {get; set;}
	public String currentLender {get; set;}
	
	public LeadWithCustomButtonControllerExtension(ApexPages.StandardController stdController) {
		this.lead = (Lead)stdController.getRecord();
		this.lead = LeadDAO.getLeadById(lead.Id);
		Date lateRefinanceDate = lead.Last_Refinance__c;
		if (lateRefinanceDate != null) {
			DateTime dtValue = DateTime.newInstance(lateRefinanceDate.year(), lateRefinanceDate.month(), lateRefinanceDate.day());
			this.lastRefinance = dtValue.format('yyyy-MM-dd');
		}
		Date fixedExpiryDate = lead.Fixed_Rate_Expiry__c;
		if (fixedExpiryDate != null) {
			DateTime dtValue = DateTime.newInstance(fixedExpiryDate.year(), fixedExpiryDate.month(), fixedExpiryDate.day());
			this.fixedExpiry = dtValue.format('yyyy-MM-dd');
		}
	}
	
	public void saveCurrentLender() {
		if (currentLender == null) {
			return;
		}
		lead.Current_Lender__c = currentLender;
		update lead;
	}
	
	public void saveLoadAmount() {
		if (loadAmount == null) {
			return;
		}
		lead.Current_Loan_Value__c = loadAmount;
		update lead;
	}
	
	public void saveInterestRate() {
		if (interestRate == null) {
			return;
		}
		lead.Current_Interest_Rate__c = interestRate;
		update lead;
	}
	
	public void saveCreditHistory() {
		if (currectCreditHistory == null) {
			return;
		}
		lead.Credit_History__c = currectCreditHistory;
		update lead;
	}
	
	public void saveEmploymentStatus() {
		if (employmentStatus == null) {
			return;
		}
		lead.Employment_Status__c = employmentStatus;
		update lead;
	}
	
	public void saveHousingStatus() {
		if (housingStatus == null) {
			return;
		}
		lead.Housing_Status__c = housingStatus;
		update lead;
	}
	
	public void saveMortgageStatus() {
		if (mortgageStatus == null) {
			return;
		}
		lead.Current_Loan_Type__c = mortgageStatus;
		update lead;
	}
	
	public void saveInterestType() {
		if (interestType == null) {
			return;
		}
		lead.Current_Interest_Rate_Type__c = interestType;
		update lead;
	}
	
	public void saveLookingToBuy() {
		if (lookingToBuy == null) {
			return;
		}
		lead.Looking_To_Buy__c = lookingToBuy;
		update lead;
	}
	
	public void saveLastRefinanceDate() {
		if (lastRefinance == null) {
			return;
		}
		String[] dateComponent = lastRefinance.split('-');
		Date lfDate = Date.newInstance(Integer.valueOf(dateComponent[0]), Integer.valueOf(dateComponent[1]), Integer.valueOf(dateComponent[2]));
		lead.Last_Refinance__c = lfDate;
		update lead;
	}
	
	public void saveFixedExpiryDate() {
		if (fixedExpiry == null) {
			return;
		}
		String[] dateComponent = fixedExpiry.split('-');
		Date feDate = Date.newInstance(Integer.valueOf(dateComponent[0]), Integer.valueOf(dateComponent[1]), Integer.valueOf(dateComponent[2]));
 		lead.Fixed_Rate_Expiry__c = feDate;
 		update lead;
 	}
 	 	
}