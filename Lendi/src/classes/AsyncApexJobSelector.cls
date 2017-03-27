/**
* Author: Anthony Xuan
* Create Date: 19/01/2016
*/
public with sharing class AsyncApexJobSelector extends SObjectSelector {
	private static final Id batchId = MercurySettings__c.getOrgDefaults().MercuryBatchId__c;

	public AsyncApexJobSelector() {
		super('AsyncApexJob', null, null);
	}

	public AsyncApexJobSelector(Set<String> specFields, Set<String> excludeFields) {
		super('AsyncApexJob', specFields, excludeFields);
	}

	public List<AsyncApexJob> getById(List<Id> ids) {
		return (List<AsyncApexJob>) super.selectByIds(ids);
	}

	public List<AsyncApexJob> getIncompleteJobs() {
		return (List<AsyncApexJob>) super.selectByOpenCondition('WHERE apexclassId = \'' + batchId + '\' AND Status != \'Aborted\' AND Status != \'Completed\' AND Status != \'Failed\'');
	}
}