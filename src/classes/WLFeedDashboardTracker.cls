@isTest(seeAllData = true)
private class WLFeedDashboardTracker {
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;

    static testMethod void validateacfFeedDashboard() 
    {
        LoadData();
        
        WLFeedDashboard objacfFeedDashboard = new WLFeedDashboard ();
        objacfFeedDashboard.redirect();

    }
    
    private static void LoadData()
    {
        createAccount();
        createContact();
        createUser();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = acfCommontrackerClass.createAccount(objAccount);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = acfCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        system.debug('objContact.id'+objContact.id);
        objUser = acfCommontrackerClass.createuser(objUser);
    }
}