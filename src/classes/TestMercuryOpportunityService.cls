@isTest
public with sharing class TestMercuryOpportunityService {

	private static testMethod void testCastLoanWithSFId() {
		Opportunity oppo = testUtilities.createOpportunity();
		insert oppo;

		MercuryModel.loan l = new MercuryModel.loan();
		l.uniqueId = oppo.id;
		l.loanName = 'test loan';

		Mercury_Opportunity__c mo = MercuryOpportunityService.castMercuryOpportunity(l);
		Opportunity newOppo = MercuryOpportunityService.castOpportunity(mo);
		System.assertEquals(oppo.id, newOppo.id);
		System.assertEquals(l.loanName, mo.merc_transaction_name__c);
		System.assertEquals(mo.merc_transaction_name__c, newOppo.merc_transaction_name__c);
	}

	private static testMethod void testCastLoanWithoutSFId() {
		MercuryModel.loan l = new MercuryModel.loan();
		l.uniqueId = 'abc';
		l.loanName = 'test loan';

		Mercury_Opportunity__c o = MercuryOpportunityService.castMercuryOpportunity(l);
		System.assertEquals(null, o.id);
		System.assertEquals('abc', o.get(MercuryUtility.loanOpportunityMap.get('uniqueId')));
		System.assertEquals(l.loanName, o.merc_transaction_name__c);
	}

	public static testMethod void testCastMercuryOpportunity() {
		Mercury_Opportunity__c mo = new Mercury_Opportunity__c();
		mo.merc_current_status__c = 'test';
		Opportunity o = MercuryOpportunityService.castOpportunity(mo);
		System.assertEquals(o.merc_current_status__c, mo.merc_current_status__c);
		System.assertEquals(o.merc_last_sync_time__c, mo.merc_last_sync_time__c);
	}

}