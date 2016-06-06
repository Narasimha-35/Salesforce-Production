global with sharing class S3DocumentRecoveryBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {
	String query;
	Integer totalCounter;
	Integer successCounter;

	global S3DocumentRecoveryBatch() {
		query ='SELECT id FROM S3Document__c WHERE isSuccess__c = false';
		totalCounter = 0;
		successCounter = 0;
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<S3Document__c> scope) {
		totalCounter += scope.size();
		List<S3Document__c> s3DocResList = S3DocumentService.reuploadDocuments(scope);
		List<S3Document__c> successList = new List<S3Document__c>();
		for(S3Document__c doc : s3DocResList) {
			if(doc.isSuccess__c) successList.add(doc);
		}
		successCounter += successList.size();
		delete S3DocumentService.getRelatedAttachments(successList);
		update s3DocResList;
	}

	global void finish(Database.BatchableContext BC) {
		System.debug(LoggingLevel.INFO, '[S3DocumentRecoveryBatch] total count: ' + totalCounter);
		System.debug(LoggingLevel.INFO, '[S3DocumentRecoveryBatch] success count: ' + successCounter);

		//TODO: send Email
	}
}
