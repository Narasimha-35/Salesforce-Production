public with sharing class AsyncRequestService {

	public static void addSyncBackRequest(String objectName, Set<String> uniqueIds) {
		List<AsyncRequest__c> arl = new List<AsyncRequest__c>();
		for(String s : uniqueIds) {
			arl.add(new AsyncRequest__c(type__c = '' + AsyncRequestType.MERCURY_TO_SF, params__c = '{"uniqueId":"' + s + '", "objectName":"' + objectName + '"}'));
		}
		insert arl;
	}

	public static AsyncRequest__c createSyncToRequst(String accId, String oppoId) {
		return new AsyncRequest__c(type__c = '' + AsyncRequestType.SF_TO_MERCURY, params__c = '{"accId":"' + accId + '", "oppoId":"' + oppoId + '"}');
	}

}
