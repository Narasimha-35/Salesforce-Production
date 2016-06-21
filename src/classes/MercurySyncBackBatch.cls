global without sharing class MercurySyncBackBatch implements Database.Batchable<String>, Database.AllowsCallouts, Database.stateful {
	Integer successCounter;
	Integer totalLoanNum;
	Integer method;
	Set<String> merc_ids;

	global MercurySyncBackBatch(Integer method) {
		this.method = method;
	}

	global MercurySyncBackBatch(Integer method, Set<String> ids) {
		this.method = method;
		merc_ids = ids;
	}

	global Iterable<String> start(Database.BatchableContext info){
		System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] Entered start...');
		successCounter = 0;
		Set<String> ids;

		if(method == -2) {
			ids = merc_ids;
		} else if(method == -1) {
			System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] Sync Mercury Opportunity by Mismatches...');
			ids = new Set<String>();
			List<Mercury_Opportunity__c> mismatchList = [SELECT id, merc_uniqueId__c FROM Mercury_Opportunity__c];
			for(Mercury_Opportunity__c mo : mismatchList) ids.add(mo.merc_uniqueId__c);
		} else if(method == 0) {
			System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] Sync Mercury Opportunity for all methods...');
			ids = MercuryService.getSyncBackLoanId(1);
			ids.addAll(MercuryService.getSyncBackLoanId(2));
		} else {
			System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] Sync Mercury Opportunity for specified method...');
			ids = MercuryService.getSyncBackLoanId(method);
		}

		System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] total loan size: ' + ids.size());
		System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] loan ids: ' + ids);
		totalLoanNum = ids.size();
		return new List<String>(ids);
	}

	global void execute(Database.BatchableContext info, List<String> scope){
		System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] Entered execute...');
		System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] current scope is: ' + scope);

		List<AsyncRequest__c> errorList = new List<AsyncRequest__c>();
		Map<String, Mercury_Opportunity__c> merc_oppoNeedUpdate = new Map<String, Mercury_Opportunity__c>();
		Map<String, Opportunity> oppoListNeedUpdate = new Map<String, Opportunity>();

		for(String mercId : scope) {
			try {
				MercuryModel.Loan loan = MercuryService.getLoan(mercId);
				Mercury_Opportunity__c merc_oppo = MercuryOpportunityService.castMercuryOpportunity(loan);
				System.debug(LoggingLevel.FINE, '[MercurySyncBackBatch] casted mercury Opportunity: ' + merc_oppo);
				Opportunity oppo = MercuryOpportunityService.castOpportunity(merc_oppo);
				System.debug(LoggingLevel.FINE, '[MercurySyncBackBatch] casted Opportunity: ' + oppo);
				if(oppo.id == null) {
					List<MercuryModel.LoanPeople> mismatchLoanPeople = MercuryService.getLoanPeole(mercId);
					List<MercuryModel.People> mismatchPeople = new List<MercuryModel.People>();
					for(MercuryModel.LoanPeople lp : mismatchLoanPeople) {
						mismatchPeople.add(MercuryService.getPeople(lp.personID));
					}

					merc_oppo.merc_loanPeople__c = JSON.serialize(mismatchLoanPeople);
					System.debug(LoggingLevel.DEBUG, '[MercurySyncBackBatch] Set Loan People: ' + merc_oppo.merc_loanPeople__c);

					merc_oppo.merc_people__c = JSON.serialize(mismatchPeople);
					System.debug(LoggingLevel.DEBUG, '[MercurySyncBackBatch] Set People: ' + merc_oppo.merc_people__c);

					merc_oppoNeedUpdate.put(mercId, merc_oppo);
					System.debug(LoggingLevel.FINE, '[MercurySyncBackBatch] Mercury Opportunity have been put in map');
				} else {
					oppoListNeedUpdate.put(mercId, oppo);
					System.debug(LoggingLevel.FINE, '[MercurySyncBackBatch] Opportunity have been put in map');
				}
			} catch (Utilities.CalloutResponseException re) {
				System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] Enter CalloutResponseException for Mercury id: ' + mercId);
				System.debug(LoggingLevel.DEBUG, '[MercurySyncBackBatch] CalloutResponseException: ' + re.getMessage());
				System.debug(LoggingLevel.DEBUG, '[MercurySyncBackBatch] CalloutResponseException: ' + re.getCause());
				System.debug(LoggingLevel.DEBUG, '[MercurySyncBackBatch] CalloutResponseException: ' + re.getLineNumber());
				System.debug(LoggingLevel.DEBUG, '[MercurySyncBackBatch] CalloutResponseException: ' + re.getStackTraceString());

				AsyncRequest__c errorItem = new AsyncRequest__c();
				errorItem.type__c = '' + AsyncRequestType.MERCURY_TO_SF;
				errorItem.params__c = '{"uniqueId":"' + mercId + '", "objectName":"opportunity"}';
				errorItem.failed__c = true;
				errorItem.errorMessage__c = '' + re.getStatusCode();
				errorList.add(errorItem);
				System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] The Error Item has been added in error list.');
			}
		}

		List<Database.UpsertResult> mercOppoRes = Database.upsert(merc_oppoNeedUpdate.values(), Mercury_Opportunity__c.fields.id, false);
		List<Database.SaveResult> oppoRes = Database.update(oppoListNeedUpdate.values(), false);

		for(Database.UpsertResult res : mercOppoRes) {
			if(res.isSuccess()) {
				successCounter++;
			} else {
				System.debug(LoggingLevel.DEBUG, '[MercurySyncBackBatch] mercOppo upsert Error: ' + res.getErrors());
			}
		}

		for(Database.SaveResult res : oppoRes) {
			if(res.isSuccess()) {
				successCounter++;
			} else {
				System.debug(LoggingLevel.DEBUG, '[MercurySyncBackBatch] oppo update Error: ' + res.getErrors());
			}
		}

		if(errorList.size() != 0) {
			System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] start insert Errors...');
			System.debug(LoggingLevel.DEBUG, '[MercurySyncBackBatch] Errors: ' + errorList);
			insert errorList;
			System.debug(LoggingLevel.INFO, '[MercurySyncBackBatch] The Error list has been inserted into AsyncRequest__c as Failed Request.');
		}
	}

	global void finish(Database.BatchableContext info){
		List<String> recipients = ((String) ACFEmailList__c.getOrgDefaults().get('Mercury_Email_Receiver__c')).split(',');
		String emailBody = 'total number of Loan: ' + totalLoanNum;
		emailBody += '<br/> success counter: ' + successCounter;
		Utilities.sendEmail(recipients, '[MercurySyncBackBatch] report', emailBody);

		//Start clean up Batch
		if(MercuryStaticValue.MERC_SETTINGS.cleanMismatchAfterSyncBack__c) {
			MercuryService.startCleanMercuryOpportunityBatch();
		}
	}

}
