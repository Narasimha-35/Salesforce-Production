@isTest(SeeAllData=false)
private class acfApprovalConditionTracker 
{
	private static User objuser;
    private static Opportunity objOpportunity;
    private static Account objAccount;
    private static Lead objLead;
    static testMethod void myUnitTest() 
    {
    	objLead = acfCommonTrackerClass.createLeadForPortal();
        objAccount = acfCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        objuser    =  acfCommonTrackerClass.CreatePortalUser(objAccount.id);
        objOpportunity  =  new Opportunity();
        objOpportunity.AccountId =  objAccount.id;
        objOpportunity.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.Name = 'test';
        objOpportunity.StageName = 'Application Taken';
        objOpportunity.acfConditions_of_Approval__c = 'Text and Document';
        objOpportunity.CloseDate = system.today();
        insert objOpportunity;
        Document_Master__c objDoc = new Document_Master__c();
        objDoc.acfActive__c = true;
        objDoc.Name = 'testDoc';
        insert objDoc;
        Required_Document__c objReqDoc = new Required_Document__c();
        objReqDoc.acfDocument_Master__c = objDoc.id;
        objReqDoc.acfOpportunity__c = objOpportunity.id;
        insert objReqDoc;
        ApexPages.StandardController sc = new ApexPages.standardController(objOpportunity);
        acfApprovalCondition objApp = new acfApprovalCondition(sc);
        objApp.ShowEditable();
        objApp.MakeUnEditable();
        objApp.ShowDocumentSection();
        objApp.lstRequiredDocList = new List<string>(); 
        objApp.lstRequiredDocList.add(objDoc.id);
        objApp.UpdateCondition();
    }
    static testMethod void myUnitTest1() 
    {
    	objLead = acfCommonTrackerClass.createLeadForPortal();
        objAccount = acfCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        objuser    =  acfCommonTrackerClass.CreatePortalUser(objAccount.id);
        objOpportunity  =  new Opportunity();
        objOpportunity.AccountId =  objAccount.id;
        objOpportunity.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.Name = 'test';
        objOpportunity.StageName = 'Application Taken';
        objOpportunity.acfConditions_of_Approval__c = 'Text';
        objOpportunity.CloseDate = system.today();
        insert objOpportunity;
        Document_Master__c objDoc = new Document_Master__c();
        objDoc.acfActive__c = true;
        objDoc.Name = 'testDoc';
        insert objDoc;
        Required_Document__c objReqDoc = new Required_Document__c();
        objReqDoc.acfDocument_Master__c = objDoc.id;
        objReqDoc.acfOpportunity__c = objOpportunity.id;
        insert objReqDoc;
        ApexPages.StandardController sc = new ApexPages.standardController(objOpportunity);
        acfApprovalCondition objApp = new acfApprovalCondition(sc);
        objApp.ShowEditable();
        objApp.MakeUnEditable();
        objApp.ShowDocumentSection();
        objApp.lstRequiredDocList = new List<string>(); 
        objApp.lstRequiredDocList.add(objDoc.id);
        objApp.UpdateCondition();
    }
}