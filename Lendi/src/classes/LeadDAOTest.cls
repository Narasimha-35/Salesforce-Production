@isTest(SeeAllData=true)
private class LeadDAOTest {

    static testMethod void getLeadByIdTest() {
        // TO DO: implement unit test
        Lead lead = new Lead();
        lead.LastName = 'testtest';
        insert lead;
        Lead newLead = LeadDAO.getLeadById(lead.Id);
        System.assert(newLead != null);
    }
}