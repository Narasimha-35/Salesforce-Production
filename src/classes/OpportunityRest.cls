@RestResource(urlMapping='/NobleOak/Opportunity/*')
global class OpportunityRest {
	
	@HttpPost
	global static ResponseHandler doPost() {
		ResponseHandler response = new ResponseHandler();
		try {
			RestRequest req = RestContext.request;
			//Required Fields
			String idValue = req.params.get('oppoId');
			String statusValue = req.params.get('status');
			String noStatusValue = req.params.get('noStatus');
			//Optional Fields
			String  nobleoakUrl = req.params.get('nobleoakUrl');
			String lifeAmount = req.params.get('lifeAmount');
			String lifeMonthlyPremium = req.params.get('lifeMonthlyPremium');
			String lifeAnnualPremium = req.params.get('lifeAnnualPremium');
			String tpdAmount = req.params.get('tpdAmount');
			String tpdMonthlyPremium = req.params.get('tpdMonthlyPremium');
			String tpdAnnualPremium = req.params.get('tpdAnnualPremium');
			String ipAmount = req.params.get('ipAmount');
			String ipMonthlyPremium = req.params.get('ipMonthlyPremium');
			String ipAnnualPremium = req.params.get('ipAnnualPremium');
			String bexAmount = req.params.get('bexAmount');
			String bexMonthlyPremium = req.params.get('bexMonthlyPremium');
			String bexAnnualPremium = req.params.get('bexAnnualPremium');
			String traumaAmount = req.params.get('traumaAmount');
			String traumaMonthlyPremium = req.params.get('traumaMonthlyPremium');
			String traumaAnnualPremium = req.params.get('traumaAnnualPremium');
			String comment = req.params.get('comment');
			Opportunity opp = [Select o.Noble_Url__c, o.Name, o.NO_Trauma_Monthly_Premium__c, o.NO_Trauma_Annual_Premium__c, o.NO_Trauma_Amount__c, o.NO_TPD_Monthly_Premium__c, o.NO_TPD_Annual_Premium__c, o.NO_TPD_Amount__c, o.NO_Status__c, o.NO_Life_Monthly_Premium__c, o.NO_Life_Annual_Premium__c, o.NO_Life_Amount__c, o.NO_IP_Annual_Premium__c, o.NO_IP_Waiting_Period__c, o.NO_IP_Salary_Conti_For__c, o.NO_IP_Monthly_Premium__c, o.NO_IP_Amount__c, o.NO_BEX_Waiting_Period__c, o.NO_BEX_Monthly_Premium__c, o.NO_BEX_Annual_Premium__c, o.NO_BEX_Amount__c, o.Current_Appointment_Status__c From Opportunity o where o.Id = :idValue];
			
			if (opp != null && statusValue != null && statusValue != '' && noStatusValue != null && noStatusValue != '') {
	            response.Status = 'Success';
	            response.ErrorCode = '200';
	            response.Message = 'Record Saved';
	            //set field and update the opportunity
	            opp.Current_Appointment_Status__c = statusValue;
	            opp.NO_Status__c = noStatusValue;
	            //Save all the optional fields
	            Double liftAmountD = lifeAmount != null && lifeAmount.isNumeric() ? Double.valueOf(lifeAmount) : 0;
	            Double lifeMonthlyPremiumD = lifeMonthlyPremium != null && lifeMonthlyPremium.isNumeric() ? Double.valueOf(lifeMonthlyPremium) : 0;
	            Double lifeAnnualPremiumD = lifeAnnualPremium != null && lifeAnnualPremium.isNumeric() ? Double.valueOf(lifeAnnualPremium) : 0;
	            Double tpdAmountD = tpdAmount != null && tpdAmount.isNumeric() ? Double.valueOf(tpdAmount) : 0;
	            Double tpdMonthlyPremiumD = tpdMonthlyPremium != null && tpdMonthlyPremium.isNumeric() ? Double.valueOf(tpdMonthlyPremium) : 0;
	            Double tpdAnnualPremiumD = tpdAnnualPremium != null && tpdAnnualPremium.isNumeric() ? Double.valueOf(tpdAnnualPremium) : 0;
	            Double ipAmountD = ipAmount != null && ipAmount.isNumeric() ? Double.valueOf(ipAmount) : 0;
	            Double ipMonthlyPremiumD = ipMonthlyPremium != null && ipMonthlyPremium.isNumeric() ? Double.valueOf(ipMonthlyPremium) : 0;
	            Double ipAnnualPremiumD = ipAnnualPremium != null && ipAnnualPremium.isNumeric() ? Double.valueOf(ipAnnualPremium) : 0;
	            Double bexAmountD = bexAmount != null && bexAmount.isNumeric() ? Double.valueOf(bexAmount) : 0;
	            Double bexMonthlyPremiumD = bexMonthlyPremium != null && bexMonthlyPremium.isNumeric() ? Double.valueOf(bexMonthlyPremium) : 0;
	            Double bexAnnualPremiumD = bexAnnualPremium != null && bexAnnualPremium.isNumeric() ? Double.valueOf(bexAnnualPremium) : 0;
	            Double traumaAmountD = traumaAmount != null && traumaAmount.isNumeric() ? Double.valueOf(traumaAmount) : 0;
	            Double traumaMonthlyPremiumD = traumaMonthlyPremium != null && traumaMonthlyPremium.isNumeric() ? Double.valueOf(traumaMonthlyPremium) : 0;
	            Double traumaAnnualPremiumD = traumaAnnualPremium != null && traumaAnnualPremium.isNumeric() ? Double.valueOf(traumaAnnualPremium) : 0;
	            //Set the value
	            if (nobleoakUrl != null) {
	            	opp.Noble_Url__c = nobleoakUrl;
	            }
	            if (liftAmountD != 0) {
	            	opp.NO_Life_Amount__c = liftAmountD;
	            }
	            if (lifeMonthlyPremiumD != 0) {
	            	opp.NO_Life_Monthly_Premium__c = lifeMonthlyPremiumD;
	            }
	            if (lifeAnnualPremiumD != 0) {
	            	opp.NO_Life_Annual_Premium__c = lifeAnnualPremiumD;
	            }
	            if (tpdAmountD != 0) {
	            	opp.NO_TPD_Amount__c = tpdAmountD;
	            }
	            if (tpdMonthlyPremiumD != 0) {
	            	opp.NO_TPD_Monthly_Premium__c = tpdMonthlyPremiumD;
	            }
	            if (tpdAnnualPremiumD != 0) {
	            	opp.NO_TPD_Annual_Premium__c = tpdAnnualPremiumD;
	            }
	            if (ipAmountD != 0) {
	            	opp.NO_IP_Amount__c = ipAmountD;
	            }
	            if (ipMonthlyPremiumD != 0) {
	            	opp.NO_IP_Monthly_Premium__c = ipMonthlyPremiumD;
	            }
	            if (ipAnnualPremiumD != 0) {
	            	opp.NO_IP_Annual_Premium__c = ipAnnualPremiumD;
	            }
	            if (bexAmountD != 0) {
	            	opp.NO_BEX_Amount__c = bexAmountD;
	            }
	            if (bexMonthlyPremiumD != 0) {
	            	opp.NO_BEX_Monthly_Premium__c = bexMonthlyPremiumD;
	            }
	            if (bexAnnualPremiumD != 0) {
	            	opp.NO_BEX_Annual_Premium__c = bexAnnualPremiumD;
	            }
	            if (traumaAmountD != 0) {
	            	opp.NO_Trauma_Amount__c = traumaAmountD;
	            }
	            if (traumaMonthlyPremiumD != 0) {
	            	opp.NO_Trauma_Monthly_Premium__c = traumaMonthlyPremiumD;
	            }
	            if (traumaAnnualPremiumD != 0) {
	            	opp.NO_Trauma_Annual_Premium__c = traumaAnnualPremiumD;
	            }
	            if (comment != null) {
	            	opp.NO_Comment__c = comment;
	            }
	            update opp;
			} else {
				response.Status = 'Failed';
				response.ErrorCode = '100';
	            response.Message = 'Invalid input';
			}
		} catch (Exception e) {
			response.ErrorCode = 'Opportunity - 0001';
            response.Status = 'error';
            response.Message = e.getMessage();
		}
		return response;
	}
}