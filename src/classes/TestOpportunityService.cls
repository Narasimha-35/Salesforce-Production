@isTest
public with sharing class TestOpportunityService {

	private static testMethod void testCastLoanWithSFId() {
		Opportunity oppo = testUtilities.createOpportunity();
		insert oppo;

		MercuryModel.loan l = new MercuryModel.loan();
		l.uniqueId = oppo.id;
		l.loanName = 'test loan';

		Opportunity o = OpportunityService.castLoan(l);
		System.assertEquals(oppo.id, o.id);
		System.assertEquals(l.loanName, o.merc_transaction_name__c);
	}

	private static testMethod void testCastLoanWithoutSFId() {
		MercuryModel.loan l = new MercuryModel.loan();
		l.uniqueId = 'abc';
		l.loanName = 'test loan';

		Opportunity o = OpportunityService.castLoan(l);
		System.assertEquals(null, o.id);
		System.assertEquals('abc', o.get(MercuryModel.loanOpportunityMap.get('uniqueId')));
		System.assertEquals(l.loanName, o.merc_transaction_name__c);
	}

	public static testMethod void testCastMercuryOpportunity() {
		Opportunity o = TestUtilities.createOpportunity();
		o.merc_current_status__c = 'test';
		Mercury_Opportunity__c mo = OpportunityService.castMercuryOpportunity(o);
		System.assertEquals(o.merc_current_status__c, mo.merc_current_status__c);
	}

}
