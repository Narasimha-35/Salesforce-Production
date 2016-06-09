global class MercuryRequestBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

	String query;
	String baseQuery;
	String condition;
	Integer counter;

	global MercuryRequestBatch(Integer start) {
		baseQuery = 'SELECT id, Params__c, Type__c FROM AsyncRequest__c ';
		condition = 'WHERE (Type__c = \'' + AsyncRequestType.SF_TO_MERCURY + '\' ';
		condition += 'OR Type__c = \'' + AsyncRequestType.APPLY_ONLINE + '\') ';
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
		if(!ACFSwitch__c.getOrgDefaults().QueuedAsyncRequestSwitch__c) return;
		AsyncRequest__c request = scope[0];
		Map<String, Object> param = (Map<String, Object>) JSON.deserializeUntyped((String)(request.get('params__c')));

		try {
			if(request.type__c == '' + AsyncRequestType.SF_TO_MERCURY) {
				System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] Sync to Mercury...' + param);
				System.debug(LoggingLevel.DEBUG, '[MercuryRequestBatch] Check DML Limit: ' + Limits.getDMLRows());
				MercuryService.syncWithMercury((String) param.get('oppoId'), (String) param.get('accId'));
			} else if(request.type__c == '' + AsyncRequestType.APPLY_ONLINE) {
				OpportunitySelector oppoSelector = new OpportunitySelector();
				Opportunity oppo = oppoSelector.getById((String) param.get('oppoId'));
				MercuryService.updateApplication(oppo);
			}

			System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] Deleting Request...');
			delete scope;
			System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] Removing From Recycle Bin...');
			Database.emptyRecycleBin(scope);
			System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] Mercury Sync Request Executed Successfully: ' + scope[0].id);
			counter++;
		} catch (MercuryService.MercurySyncException re) {
			scope[0].Failed__c = true;
			scope[0].ErrorMessage__c = '' + re.getErrorMessage();
			update scope;
			System.debug(LoggingLevel.DEBUG, '[MercuryRequestBatch] Mercury Sync Request Not Executed Successfully: ' + scope[0].id);
			System.debug(LoggingLevel.DEBUG, '[MercuryRequestBatch] Error Message: ' + re.getMessage());
		} catch (Exception e) {
			scope[0].Failed__c = true;
			scope[0].ErrorMessage__c = '' + e.getMessage();
			update scope;
		}
	}

	global void finish(Database.BatchableContext BC) {
		if(!ACFSwitch__c.getOrgDefaults().QueuedAsyncRequestSwitch__c) return;
		System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] success count: ' + counter);

		Integer remainingSize = Database.query(baseQuery).size();
		System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] remainingSize: ' + remainingSize);
		if(remainingSize > 0) {
			Database.executeBatch(new MercuryRequestBatch(counter), 1);
		}
	}

}
