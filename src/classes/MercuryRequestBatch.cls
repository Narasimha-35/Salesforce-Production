global class MercuryRequestBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

	String query;
	Integer counter;

	global MercuryRequestBatch(Integer start) {
		query = 'SELECT id, Params__c, Type__c FROM AsyncRequest__c WHERE Type__c = \'sync with mercury\' AND Failed__c = false';
		counter = start;
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<AsyncRequest__c> scope) {
		Map<String, Object> param = (Map<String, Object>) JSON.deserializeUntyped((String)(scope[0].get('params__c')));
		try {
			MercuryApiUtilities.syncWithMercury((String) param.get('oppoId'), (String) param.get('accId'));
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

		Integer remainingSize = Database.query(query).size();
		System.debug(LoggingLevel.INFO, '[MercuryRequestBatch] remainingSize: ' + remainingSize);
		if(remainingSize > 0) {
			Database.executeBatch(new MercuryRequestBatch(counter), 1);
		}
	}

}
