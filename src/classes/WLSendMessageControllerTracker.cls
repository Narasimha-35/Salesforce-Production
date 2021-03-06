@isTest
private class WLSendMessageControllerTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Lead objLead;
    private static Opportunity objOpportunity;
    
    static testMethod void validate() 
    {
        LoadData();
        system.runas(objUser)
        {
            WLSendMessageController obj = new WLSendMessageController();
            obj.strMortgageMsg = 'test'; 
            obj.selectedDate = 'Schedule';
            obj.strPost = 'test'; 
            obj.selectedTime = '9.00';
            obj.schDate = '09/11/2015';
            
            obj.schTimeMethod();
            obj.redirect();
            obj.Obj_OppOwner=objUser;
            obj.sendmsgToLeadOwner();
            obj.showCalender();
            obj.getItems();
            obj.getTimeItems();
            obj.usrObj=objUser;
            obj.Obj_OppOwner=objUser;
            obj.selectedDate='Schedule';
            obj.selectedTime='4:30 PM';
            obj.schDate='05/27/2015:4.30';
            obj.createTask();
            obj.postQuery();
        }

    }
    
        
    static testMethod void validate1() 
    {
        LoadData();
        WLSendMessageController obj = new WLSendMessageController();
        obj.strMortgageMsg = null; 
        obj.strPost = 'test';
        obj.selectedDate = 'ASAP';
        obj.isMsgsent = true;
        obj.isError = true;
        obj.schTimeMethod();
        obj.redirect();
        obj.sendmsgToLeadOwner();
        obj.showCalender();
        obj.getItems();
        obj.getTimeItems();
        obj.createTask();
        obj.postQuery();
        

    }
    
        static testMethod void validate2() 
    {
   //     LoadData();
        WLSendMessageController obj = new WLSendMessageController();
        obj.strMortgageMsg = 'test'; 
        obj.isMsgsent = true;
        obj.isError = true;
        obj.schTimeMethod();
        obj.redirect();
        obj.sendmsgToLeadOwner();
        obj.showCalender();
        obj.getItems();
        obj.getTimeItems();
        obj.createTask();
        obj.postQuery();
        

    }
    
    private static void LoadData()
    {
        createAccount();
        createContact();
        createLead();
        createUser();
        createOpportunity();

    }
    
      static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLeadForPortal();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        //objContact.Account = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objUser.MobilePhone='+611234567890';
        objUser.contactId=objContact.Id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id); 
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
    }
    

    
}