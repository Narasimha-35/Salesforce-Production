@RestResource(urlMapping='/NobleOak/InsuranceCalculation/*')
global class APICalculateInsurranceAmount {
	
	@HttpPost
	global static ResultWithStatus doPost() {
		ResultWithStatus result = new ResultWithStatus();
		try { 
			RestRequest req = RestContext.request;
			//required fields
			String insuranceType = req.params.get('insuranceType');
			String ageNextBday = req.params.get('ageNextBday');
			String totalAmountInsurance = req.params.get('totalAmountInsurance');
			String gendar = req.params.get('gendar');
			String isSmoke = req.params.get('isSmoker');
			//default occupation
			String occupation = req.params.get('occupation') != null ? req.params.get('occupation') : 'White Collar' ;
			
			if (insuranceType != null) {
				if (insuranceType == 'life') {
					if (ageNextBday != null && totalAmountInsurance != null && gendar != null && isSmoke != null) {
						Integer ageNextBdayN = Integer.valueOf(ageNextBday);
						Boolean isSmokeB = Boolean.valueOf(isSmoke);
						decimal totalAmountInsuranceN = Decimal.valueOf(totalAmountInsurance);
						NobleOakUtilities.ResultForInsuranceCalculation calResult = NobleOakUtilities.calculateForLife(ageNextBdayN, totalAmountInsuranceN, gendar, isSmokeB, occupation);
						result.monthlyAmount = calResult.monthlyPayment;
						result.annuallyAmount = calResult.annuallyPayment;
			            result.status = 'success';
			            result.errorMessage = '';
					} else {
						result.monthlyAmount = 0;
						result.annuallyAmount = 0;
			            result.status = 'error';
			            result.errorMessage = 'Necessay fields for calculating Life are missing';
					}
				}
			} else {
				result.monthlyAmount = 0;
				result.annuallyAmount = 0;
	            result.status = 'error';
	            result.errorMessage = 'Insurance Type can not be null';
			}
			
		} catch (Exception e) {
			result.monthlyAmount = 0;
			result.annuallyAmount = 0;
            result.status = 'error';
            result.errorMessage = e.getMessage();
		}
		return result;
	}
	
	global class ResultWithStatus {
		global decimal monthlyAmount { get; set; }
		global decimal annuallyAmount { get; set; }
		global String status { get; set;}
		global String errorMessage { get; set; } 
	}
}