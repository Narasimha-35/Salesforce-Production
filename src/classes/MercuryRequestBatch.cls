global class MercuryRequestBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

	String query;
	String baseQuery;
	String condition;
	Integer counter;

	global MercuryRequestBatch(Integer start) {
		baseQuery = 'SELECT id, Params__c, Type__c FROM AsyncRequest__c ';
		condition = 'WHERE (Type__c = \'' + AsyncRequestType.SF_TO_MERCURY + '\' ';
		condition += 'OR Type__c = \'' + AsyncRequestType.MERCURY_TO_SF + '\') ';
		condition += 'AND Failed__c = false ';
		baseQuery += condition;
		query = baseQuery + ' LIMIT 1';
		counter = start;

		System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] Batch Query: ' + baseQuery);
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<AsyncRequest__c> scope) {
		AsyncRequest__c request = scope[0];
		Map<String, Object> param = (Map<String, Object>) JSON.deserializeUntyped((String)(request.get('params__c')));

		try {
			if(request.type__c == '' + AsyncRequestType.SF_TO_MERCURY) {
				System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] Sync to Mercury...' + param);
				MercuryApiUtilities.syncWithMercury((String) param.get('oppoId'), (String) param.get('accId'));
			} else if(request.type__c == '' + AsyncRequestType.MERCURY_TO_SF) {
				System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] Sync from Mercury...' + param);
				if((String) param.get('objectName') == 'Opportunity') {
					MercuryModel.Loan loan = MercuryService.getLoan((String) param.get('uniqueId'));
					Opportunity o = OpportunityService.castLoan(loan);
					System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] casted Opportunity: ' + o);
					OpportunitySelector os = new OpportunitySelector();
					List<Opportunity> ol = os.getByMercuryId(new List<String>{loan.uniqueId});

					if(Utilities.castId(loan.uniqueId) != null || ol.size() == 1) {
						//update Opportunity
						if(Utilities.castId(loan.uniqueId) != null) {
							o.id = loan.uniqueId;
						} else {
							o.id = ol[0].id;
						}
						update o;
						System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] update Opportunity: ' + o);
					} else {
						//insert into mercury Opportunity
						Mercury_Opportunity__c mo = OpportunityService.castMercuryOpportunity(o);
						System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] insert mercury Opportunity: ' + mo);
						insert mo;
					}
				}
			}

			System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] Deleting Request...');
			delete scope;
			System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] Removing From Recycle Bin...');
			Database.emptyRecycleBin(scope);
			System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] Mercury Sync Request Executed Successfully: ' + scope[0].id);
			counter++;
		} catch (Exception e) {
			scope[0].Failed__c = true;
			scope[0].ErrorMessage__c = e.getMessage();
			update scope;
			System.debug(LoggingLevel.DEBUG, '[MercuryRequestBatch] Mercury Sync Request Not Executed Successfully: ' + scope[0].id);
			System.debug(LoggingLevel.DEBUG, '[MercuryRequestBatch] Error Message: ' + e.getMessage());
		}
	}

	global void finish(Database.BatchableContext BC) {
		System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] success count: ' + counter);

		Integer remainingSize = Database.query(baseQuery).size();
		System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] remainingSize: ' + remainingSize);
		if(remainingSize > 0) {
			Database.executeBatch(new MercuryRequestBatch(counter), 1);
		}
	}

}
