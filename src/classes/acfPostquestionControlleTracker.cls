@isTest(SeeAllData = true)
private class acfPostquestionControlleTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;

    
    static testMethod void validate() 
    {

        LoadData();
        acfPostquestionController objpost = new acfPostquestionController();
        objpost.isError = true;
        objpost.ResetPopup();
        objpost.postQuery();

    }
    
        
    static testMethod void validate1() 
    {

        LoadData();
        acfPostquestionController objpost = new acfPostquestionController();
        objpost.isError = true;       
        objpost.ResetPopup();
        objpost.strPost = null;
        objpost.postQuery();

    }
    
    private static void LoadData()
    {
        createAccount();
        createContact();
        createUser();
        createOpportunity();

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
        objUser = acfCommontrackerClass.createuser(objUser);
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    

    
}