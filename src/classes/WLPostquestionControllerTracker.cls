@isTest
public class WLPostquestionControllerTracker
{
private static User objUser;
    public static lead objLead ;
    public static Contact objContact;
    public static Account objAccount;
    public static Opportunity objOpportunity;
    public static Click_Community_Setup__c objclcmm;
    
    static testMethod void validate()
    {  
        LoadData();
        system.runas(objUser)
        {
            WLPostquestionController obj = new WLPostquestionController();
            obj.ResetPopup();
            obj.postQuery();
        }
    }
    
    static testMethod void validate1()
    {  
        LoadData();
        system.runas(objUser)
        {
            WLPostquestionController obj = new WLPostquestionController();
            obj.isError = false;
            obj.strPost = null;
            obj.ResetPopup();
            obj.postQuery();
        }
    }
      public static void LoadData()
    {
        createLead();
        createAccount();
        createContact();
        createuser();
    }
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLead(objLead);
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','66666666','test@gmail.com',objLead.id);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        objContact.acf_lead__c = objLead.id;
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    
}