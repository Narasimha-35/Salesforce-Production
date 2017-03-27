@isTest(seeAllData = true)
public class LendiProductServiceTest {

	private static testMethod void testValidateLoanData() {
		System.assertEquals(true, LendiProductService.validateLoanData(0, 100));
		System.assertEquals(true, LendiProductService.validateLoanData(100, 0));
		System.assertEquals(true, LendiProductService.validateLoanData(0, 0));
		System.assertEquals(false, LendiProductService.validateLoanData(100, 100));
	}

	private static testMethod void testValidateProductData() {
		Opportunitylineitem oppoProd = new Opportunitylineitem();
		Opportunity oppo = TestUtilities.createOpportunity();
		insert oppo;
		oppoProd.opportunityId = oppo.id;

		System.assertEquals(true, LendiProductService.validateProductData(oppoProd));

		Product2 p = new Product2(name = 'test');
		insert p;
		Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
		insert new PriceBookEntry(pricebook2id = standardPB.id, product2id = p.id, unitprice = 1, isActive = true);
		List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE Product2Id=:p.id LIMIT 1];
		oppoProd.pricebookEntryId = priceBookList[0].id;
		oppoProd.totalPrice = 1;
		insert oppoProd;
		System.assertEquals(true, LendiProductService.validateProductData(oppoProd));

		oppoProd.click_Tenure__c = '30';
		System.assertEquals(true, LendiProductService.validateProductData(oppoProd));

		oppoProd.click_Type__c = 'Interest Only';
		System.assertEquals(true, LendiProductService.validateProductData(oppoProd));

		p.assessmentRate__c = 7;
		update p;
		System.assertEquals(true, LendiProductService.validateProductData(oppoProd));

		oppoProd.acfRate__c = 4;
		System.assertEquals(true, LendiProductService.validateProductData(oppoProd));

		p.rateBuffer__c = 2;
		update p;
		System.assertEquals(true, LendiProductService.validateProductData(oppoProd));

		AcfBank_Detail__c bank = new AcfBank_Detail__c();
		insert bank;
		p.click_Loans_Bank_Detail__c = bank.id;
		update p;
		System.assertEquals(true, LendiProductService.validateProductData(oppoProd));

		System.debug('======================');
		oppoProd = [SELECT id, opportunityId, pricebookEntryId, totalPrice, click_Tenure__c, click_Type__c, acfRate__c, interest_Only_term__c, assessmentRate__c, rateBuffer__c, product2.click_Loans_Bank_Detail__c FROM Opportunitylineitem WHERE id = :oppoProd.id LIMIT 1];
		oppoProd.interest_Only_term__c = 30;
		oppoProd.click_Type__c = 'Interest Only';
		oppoProd.acfRate__c = 4;
		System.assertEquals(false, LendiProductService.validateProductData(oppoProd));
	}

}