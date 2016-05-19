@isTest
public class TestOpportunitySelector {

    private static testMethod void testGetByMercuryId() {
        Opportunity o = TestUtilities.createOpportunity();
        o.Mercury_Loan_Id__c = '1234';
        insert o;

        Test.startTest();
        OpportunitySelector os = new OpportunitySelector();
        os.getByMercuryId(o.Mercury_Loan_Id__c);
        Test.stopTest();
    }

}