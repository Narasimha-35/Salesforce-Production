@isTest
public with sharing class TestMercuryUtility {
    private static final String testLoanPeopleString = '[{"uniqueId":"40b636b6-c648-11e5-9595-00155d006737","relationship":"Primary Applicant","personID":"60D00D0F-5B95-C513-60AB-8BD151219DFB","loanID":"A6A55E3C-CDDD-15D8-BCB9-8BD5F0EC380C","email":"shereehenley@grapevine.com.au"},{"uniqueId":"44c87532-c648-11e5-9595-00155d006737","relationship":"Applicant","personID":"1F4CF421-6803-DC7C-0600-8BD46BE29407","loanID":"A6A55E3C-CDDD-15D8-BCB9-8BD5F0EC380C","email":"shereehenley@grapevine.com.au"}]';

    private static testMethod void testGetEmailOfPrimaryApplicantFromMercuryOpportunity() {
        Mercury_Opportunity__c merc_oppo = new Mercury_Opportunity__c();
        merc_oppo.merc_loanPeople__c = testLoanPeopleString;
        System.assertEquals('shereehenley@grapevine.com.au', MercuryUtility.getEmailOfPrimaryApplicantFromMercuryOpportunity(merc_oppo));
    }

    private static testMethod void testGetEmailListFromMercuryOpportunity() {
        Mercury_Opportunity__c merc_oppo = new Mercury_Opportunity__c();
        merc_oppo.merc_loanPeople__c = testLoanPeopleString;
        List<String> emails = MercuryUtility.getEmailListFromMercuryOpportunity(merc_oppo);
        List<String> expected = new List<String>{'shereehenley@grapevine.com.au', 'shereehenley@grapevine.com.au'};
        for(Integer i = 0; i < emails.size(); i++) {
            System.assertEquals(expected[i], emails[i]);
        }
        System.assertEquals(2, emails.size());
    }

}
