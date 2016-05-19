@isTest
public with sharing class TestAsyncRequestService {

	private static testMethod void testAddSyncBackRequest() {
		MercuryModel.LoanResponse lr = new MercuryModel.LoanResponse();
		lr.loans = new List<MercuryModel.loan>();
		for(Integer i = 0; i < 10; i++) {
			MercuryModel.Loan l = new MercuryModel.Loan();
			l.uniqueId = '' + i;
			lr.loans.add(l);
		}

		System.debug(lr.idList);
		AsyncRequestService.addSyncBackRequest('Opportunity', new set<String>(lr.idList));
		AsyncRequestSelector ars = new AsyncRequestSelector();
		List<AsyncRequest__c> res = ars.getSyncBackRequests();
		System.assertEquals(10, res.size());
		Integer i = 0;
		for(AsyncRequest__c ar : res) {
			System.debug(ar);

			System.assertEquals('' + AsyncRequestType.MERCURY_TO_SF, ar.type__c);
			System.assertEquals('' + i, ((Map<String, Object>) JSON.deserializeUntyped(ar.params__c)).get('uniqueId'));
			i++;
		}
	}

}