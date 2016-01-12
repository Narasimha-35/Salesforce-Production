@isTest(seealldata = true)
private class acfBankInformationDetailsTracker 
{
    private static Lead objLead;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;

    
    static testMethod void validateacfBankInformationDetailsController() 
    {
        LoadData();
        
      system.runas(objuser){
        acfBankInformationDetails.AllAccountsClass wrap = new acfBankInformationDetails.AllAccountsClass();
        wrap.chk_box =true;
        wrap.accountHolder ='test';
        wrap.name = 'test';
        wrap.accountNumber ='1234';
        wrap.id = '001';
        wrap.bsb ='test';
        wrap.balance = '10000';
        wrap.available = '2000';
        
        acfBankInformationDetails.ErrorMessage wrpp = new acfBankInformationDetails.ErrorMessage();
        wrpp.error = 'error';
        wrpp.errorcode = 12345;
        wrpp.user_token = 'te1234';
        
        acfBankInformationDetails.AutoCompleteBanklList('test');
        
        acfBankInformationDetails objacfbank = new acfBankInformationDetails();
        objacfbank.strParentId = objLead.id;
        objacfbank.strSelectedOption ='test';
        objacfbank.captchaImgUrl ='test';
        

       // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        objacfbank.SelectBankName(); 
        objacfbank.hidepopup(); 
        objacfbank.BankLogin(); 
        objacfbank.FetchStatements(); 
        objacfbank.strBankSlugName = 'anz';
        objacfbank.redirectToNextpage(); 
        objacfbank.skipMethod();
        objacfbank.redirect(); 
        }
    }
    
    private static void LoadData()
    {
        createLead();
        createAccount();
 //       createContact();
        createUser();
        createOpportunity();

    }
    
     static void createLead()
    {
    objLead = acfCommonTrackerClass.createLeadForPortal();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = acfCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        objContact = acfCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser =  acfCommonTrackerClass.CreatePortalUser(objAccount.id); 
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    

    
}