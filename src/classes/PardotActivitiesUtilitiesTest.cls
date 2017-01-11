@isTest(SeeAllData=true)
private class PardotActivitiesUtilitiesTest {

    static testMethod void getPardoctVisitorActivitiesTest() {
    	//List<Pardot_Visitor_Activity__c> activitiesBefore = [Select Id, Name From Pardot_Visitor_Activity__c];
    	//List<Visitor_Page_View__c> pageViewsBefore = [Select Id, Name From Visitor_Page_View__c];
        Lead lead = new Lead();
        lead.LastName = 'test';
        lead.Email = 'testy@yahoo.com';
        insert lead;
        Test.startTest();
        String testEmail = 'test@yahoo.com';
        PardotActivitiesUtilities.getPardoctVisitorActivities(testEmail, lead);
    	Test.stopTest();
    	//Compare activity size
    	//List<Pardot_Visitor_Activity__c> activitiesAfter = [Select Id, Name From Pardot_Visitor_Activity__c];
    	//List<Visitor_Page_View__c> pageViewsAfter = [Select Id, Name From Visitor_Page_View__c];
    	//Compare activity page view size
    	//System.assert(activitiesAfter.size() > 0);
    	//System.assert(pageViewsAfter.size() > 0);
    	//System.assert(activitiesAfter.size() > activitiesBefore.size());
    	//System.assert(pageViewsAfter.size() > pageViewsBefore.size());
    }
}