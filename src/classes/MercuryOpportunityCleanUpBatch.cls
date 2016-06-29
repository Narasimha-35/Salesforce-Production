global without sharing class MercuryOpportunityCleanUpBatch implements Database.Batchable<Mercury_Opportunity__c>, Database.AllowsCallouts, Database.stateful {
	Integer totalSuccessCounter = 0;
	Integer totalRequestHandled = 0;
	final String SELF_GEN_ID = '50eee77a-4fd1-11e3-8721-00155d0a3619';
	List<Mercury_Opportunity__c> merc_oppo_scopeList = null;

	public MercuryOpportunityCleanUpBatch() {
	}

	public MercuryOpportunityCleanUpBatch(List<Mercury_Opportunity__c> merc_oppo_scopeList) {
		this.merc_oppo_scopeList = merc_oppo_scopeList;
	}

	global List<Mercury_Opportunity__c> start(Database.BatchableContext info){
		MercuryOpportunitySelector mos = new MercuryOpportunitySelector();
		if(merc_oppo_scopeList != null) return merc_oppo_scopeList;
		return mos.getAll(0);
	}

	global void execute(Database.BatchableContext info, List<Mercury_Opportunity__c> scope){
		MercuryModel.People applicant = null;
		Opportunity oppo = null;
		Account applicantAcc = null;

		for(Mercury_Opportunity__c merc_oppo : scope) {
			totalRequestHandled++;

			try{
				if(merc_oppo.merc_people__c == null || merc_oppo.merc_loanPeople__c == null) continue;
				System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] Start cleaning on: ' + merc_oppo);
				applicant = MercuryUtility.getApplicant(merc_oppo);
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

				//make sure no account is get created
				if(applicantAcc.id == null && merc_oppo.merc_lead_source__c != SELF_GEN_ID) continue;
				//merge and update the last not synced oppo for given acc
				if(applicantAcc.id != null) oppo = MercuryUtility.mergeWithLastNotSyncedOppo(oppo, applicantAcc);

				if(MercuryUtility.removeMercuryOpportunityAndCreateOpportunity(applicantAcc, oppo, merc_oppo)) totalSuccessCounter++;
			} catch (Exception e) {
				System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] UnexpectedException, continue...');
			}
		}
	}

	global void finish(Database.BatchableContext info){
		List<String> recipients = ((String) ACFEmailList__c.getOrgDefaults().get('Mercury_Email_Receiver__c')).split(',');
		String emailBody = 'total number of request handled: ' + totalRequestHandled;
		emailBody += '<br/> success counter: ' + totalSuccessCounter;
		Utilities.sendEmail(recipients, '[MercuryOpportunityCleanUpBatch] report', emailBody);
	}

}
