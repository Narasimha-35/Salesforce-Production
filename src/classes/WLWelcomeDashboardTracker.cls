/*
 =============================================================================
    Name                             Date                                version
    =============================================================================
   Ashna                           07/6/2016                                1.0
    =============================================================================
*/

@isTest
private class WLWelcomeDashboardTracker 
{
    private static User objUser;
    private static Lead objLead;
    private static Contact objContact;
    private static Account objAccount;
    private static Account objpersonAccount;
    private static Opportunity objOpp; 
    private static Click_Community_Setup__c objClcommset;
    
    
    
    static testMethod void validate() 
    {
        LoadData();
        PageReference pageRef = new PageReference('https://clickloans.com.au/ClickPreloginQuestions');
        Test.setCurrentPage(pageRef);
        WLWelcomeDashboard wlwelDash=new WLWelcomeDashboard();
        wlwelDash.Dashboard();
        wlwelDash.setMyOpportunityIds(objOpp.Id);
        wlwelDash.CountTasks=123;
         wlwelDash.pge_name='ashna';
         wlwelDash.isDocumentRejected=true;
         wlwelDash.isshow=true;
         wlwelDash.strHeaderName='ash';
         wlwelDash.strDescriptionName='ashi';
        wlwelDash.getMyOpportunityIds();
        wlwelDash.Dashboard();
        Id logid=ClickCommon.getCurrentLoggedInLeadId(objUser.id);
        //objClcommset=ClickCommon.getCommunitySetup(Network.getNetworkId());
        //wlwelDash.pge_name = 'ClickEditProfile';
       // Opportunity objO1= new Opportunity();
        //objO1=WLCommonTrackerClass.createOpportunity(objO1,objUser);
         //String objstr=objO1.Id;
        //objO1.id=objstr;
    }
       
    private static void LoadData()
    {
        createLead();
        createAccount();
        createContact();
        createPersonAccount();
        createPortalUser();
        createOpportunity();
        
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLead(objLead);
    }
    
    
    static void createContact()
    {
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
    static void createPersonAccount()
    {
        objpersonAccount= new Account();
        objpersonAccount=WLCommonTrackerClass.CreatePersonAccount('Fname','LName','strPhone','strLeadEmail@gmail.com',objLead.Id);
    }
    static void createPortalUser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        //objuser.AccountId = objAccount.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objpersonAccount.id);
    }
    
    static void createOpportunity()
    {
    objOpp= new Opportunity();
    objOpp.AccountId =objuser.AccountId;
     String recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Click Refi').getRecordTypeId();
     objOpp.recordtypeid =recordtypeid;
    //objOpp.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
    objOpp.name = 'test';
    objOpp.Stagename = 'Settlement';
    objOpp.CloseDate = System.today();
    objOpp=WLCommonTrackerClass.createOpportunity(objOpp,objUser);
    }
}