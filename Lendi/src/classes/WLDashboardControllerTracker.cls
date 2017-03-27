@isTest(SeeAllData = true)
private class WLDashboardControllerTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;

    
    static testMethod void validate() 
    {       
        LoadData();
        Cookie cookieActiveTab = new Cookie('cookieActiveTab ','true','true',72000, false); 
        ApexPages.currentPage().setCookies( new Cookie[]{ cookieActiveTab});
        WLDashboardController obj = new WLDashboardController();
        obj.redirect();
        obj.SetCurrentTab();
        
 
    }
    
    private static void LoadData()
    {
        createAccount();
//        createContact();
        createUser();
        createOpportunity();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
  //      objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
    }
    

}