global without sharing class MercuryOpportunityCleanUpBatch implements Database.Batchable<Mercury_Opportunity__c>, Database.AllowsCallouts, Database.stateful {
	Integer newAccountCounter;
	Integer newOpportunityCounter;
	Integer updateAccountCounter;
	Integer updateOpportunityCounter;
	Integer totalSuccessCounter;
	Integer totalRequestHandled;

	public MercuryOpportunityCleanUpBatch() {
	}

	global List<Mercury_Opportunity__c> start(Database.BatchableContext info){
		MercuryOpportunitySelector mos = new MercuryOpportunitySelector();
		return mos.getAll(0);
	}

	global void execute(Database.BatchableContext info, List<Mercury_Opportunity__c> scope){
		AccountSelector accSelector = new AccountSelector();
		MercuryModel.People applicant = null;
		Account applicantAcc = null;
		Opportunity oppo = null;

		for(Mercury_Opportunity__c merc_oppo : scope) {
			if(merc_oppo.merc_people__c == null || merc_oppo.merc_loanPeople__c == null) continue;
			System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] Start cleaning on: ' + merc_oppo);
			applicant = MercuryUtility.getApplicantWithValidEmailFromLoan(merc_oppo);
			System.debug(LoggingLevel.DEBUG, '[MercuryOpportunityCleanUpBatch] The applicant is: ' + applicant);
			if(applicant == null) {
				throw new MercuryUtility.MercuryMismatchException('Fatal: There is no valid Email address in all contacts.');
			}
			System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] Complete Cast People');

			System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] Start Cast Loan');
			oppo = MercuryOpportunityService.castOpportunity(merc_oppo, true);
			oppo.name = oppo.merc_transaction_name__c;
			oppo.stageName = 'Closed Won - Signed';
			oppo.closeDate = oppo.merc_settlement_date__c != null ? oppo.merc_settlement_date__c.date() : Date.today();
			oppo.leadSource = 'Mercury';
			oppo.mercury_Loan_Id__c = oppo.merc_uniqueId__c;
			System.debug(LoggingLevel.INFO, '[MercuryOpportunityCleanUpBatch] Complete Cast Loan');

			List<Account> matchingAccs = accSelector.getByMercuryPeople(applicant);
			System.debug(LoggingLevel.DEBUG, '[MercuryOpportunityCleanUpBatch] matchingAccs is: ' + matchingAccs);

			if(matchingAccs == null) {
				throw new MercuryUtility.MercuryMismatchException('Fatal: empty matching condition. throw Exception.');
			} else if(matchingAccs.size() == 0) {
				//no match create.
				applicantAcc = applicant.convertToAccount(true);
				System.debug(LoggingLevel.DEBUG, '[MercuryOpportunityCleanUpBatch] The applicant\'s Account from Direct Conversion: ' + applicantAcc);
			} else if(matchingAccs.size() == 1) {
				//Email match but not sure is match or not.
				applicantAcc = applicant.mergeToAccount(matchingAccs.get(0), true);
				System.debug(LoggingLevel.DEBUG, '[MercuryOpportunityCleanUpBatch] The applicant\'s Account from Merge Single Account: ' + applicantAcc);
			} else {
				//TODO: multiple Account Matches.
				applicantAcc = MercuryUtility.getMostRecentAppointmentAccountWithouSynced(matchingAccs);
				applicantAcc = applicant.mergeToAccount(applicantAcc, true);
				System.debug(LoggingLevel.DEBUG, '[MercuryOpportunityCleanUpBatch] The applicant\'s Account from Merge Multiple Account: ' + applicantAcc);
			}

			//TODO: should use unit of work
			SavePoint sp = Database.setSavepoint();
			System.debug(LoggingLevel.DEBUG, '[MercuryOpportunityCleanUpBatch] Upserting Account: ' + applicantAcc);
			Database.UpsertResult accRes = Database.upsert(applicantAcc, Account.Fields.Id, false);
			oppo.accountId = applicantAcc.id;
			System.debug(LoggingLevel.DEBUG, '[MercuryOpportunityCleanUpBatch] Upserting Opportunity: ' + oppo);
			Database.SaveResult oppoRes = Database.insert(oppo, false);
			Database.DeleteResult delMercOppoRes = Database.delete(merc_oppo, false);

			if(!accRes.isSuccess() || !oppoRes.isSuccess() || !delMercOppoRes.isSuccess()) {
				System.debug(LoggingLevel.ERROR, 'Error Message' + accRes.getErrors());
				System.debug(LoggingLevel.ERROR, 'Error Message' + oppoRes.getErrors());
				System.debug(LoggingLevel.ERROR, 'Error Message' + delMercOppoRes.getErrors());
				Database.rollback(sp);
			}
		}
	}

	global void finish(Database.BatchableContext info){
	}

}
