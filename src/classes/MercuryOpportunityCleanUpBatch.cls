global without sharing class MercuryOpportunityCleanUpBatch implements Database.Batchable<Mercury_Opportunity__c>, Database.AllowsCallouts, Database.stateful {
	Integer totalSuccessCounter = 0;
	Integer totalRequestHandled = 0;

	public MercuryOpportunityCleanUpBatch() {
	}

	global List<Mercury_Opportunity__c> start(Database.BatchableContext info){
		MercuryOpportunitySelector mos = new MercuryOpportunitySelector();
		return mos.getAll(0);
	}

	global void execute(Database.BatchableContext info, List<Mercury_Opportunity__c> scope){
		MercuryModel.People applicant = null;
		Opportunity oppo = null;
		Account applicantAcc = null;

		for(Mercury_Opportunity__c merc_oppo : scope) {
			totalRequestHandled++;

			if(merc_oppo.merc_people__c == null || merc_oppo.merc_loanPeople__c == null) continue;
			System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] Start cleaning on: ' + merc_oppo);
			applicant = MercuryUtility.getApplicantWithValidEmailFromLoan(merc_oppo);
			System.debug(LoggingLevel.DEBUG, '[MercuryOpportunityCleanUpBatch] The applicant is: ' + applicant);
			if(applicant == null) {
				System.debug(LoggingLevel.ERROR, '[MercuryOpportunityCleanUpBatch] There is no valid Email address in all contacts.');
				continue;
			}
			System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] Complete Cast People');

			System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] Start Cast Loan');
			oppo = MercuryUtility.constructOpportunityFromMercuryOpp(merc_oppo);
			System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] Complete Cast Loan: ' + oppo);

			applicantAcc = MercuryUtility.getApplicantAccount(applicant);
			System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] The applicant Account is: ' + applicantAcc);
			if(applicantAcc == null) continue;

			if(MercuryUtility.removeMercuryOpportunityAndCreateOpportunity(applicantAcc, oppo, merc_oppo)) totalSuccessCounter++;
		}
	}

	global void finish(Database.BatchableContext info){
		List<String> recipients = ((String) ACFEmailList__c.getOrgDefaults().get('Mercury_Email_Receiver__c')).split(',');
		String emailBody = 'total number of request handled: ' + totalRequestHandled;
		emailBody += '<br/> success counter: ' + totalSuccessCounter;
		Utilities.sendEmail(recipients, '[MercuryOpportunityCleanUpBatch] report', emailBody);
	}

}
