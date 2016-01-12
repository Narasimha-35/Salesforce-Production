@isTest(seealldata = true)
private class WLBankInformationDetailsTracker 
{
    private static Lead objLead;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    acfBank_Detail__c bnkObj;

    
    public static testMethod void validateWLBankInformationDetailsController() 
    {
        LoadData();
        
      system.runas(objuser){
        WLBankInformationDetails.AllAccountsClass wrap = new WLBankInformationDetails.AllAccountsClass();
        wrap.chk_box =true;
        wrap.accountHolder ='test';
        wrap.name = 'test';
        wrap.accountNumber ='1234';
        wrap.id = '001';
        wrap.bsb ='test';
        wrap.balance = '10000';
        wrap.available = '2000';
        
        WLBankInformationDetails.ErrorMessage wrpp = new WLBankInformationDetails.ErrorMessage();
        wrpp.error = 'error';
        wrpp.errorcode = 12345;
        wrpp.user_token = 'te1234';
        
        WLBankInformationDetails.AutoCompleteBanklList('test');
        
        WLBankInformationDetails objacfbank = new WLBankInformationDetails();
        Click_Community_Setup__c objCommunitySetUp = new Click_Community_Setup__c ();
        objCommunitySetUp.Click_Page_Prefix__c ='WL';
        insert objCommunitySetUp; 
        objacfbank.strParentId = objLead.id;
        objacfbank.strSelectedOption ='test';
        objacfbank.captchaImgUrl ='test';
        test.starttest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       objacfbank.strBankSlugName = 'HSBC';
        //objacfbank.SelectBankName(); 
        objacfbank.hidepopup(); 
        
        Institution.Credential objCred = new Institution.Credential();
        objCred.name = 'test';
        objCred.fieldID = 'test';
        objacfbank.lstCredentials.add(objCred);
        objacfbank.BankLogin(); 
        
        WLBankInformationDetails.AllAccountsClass objAAC = new WLBankInformationDetails.AllAccountsClass();
        objAAC.id = objAccount.Id;
        objAAC.chk_box = true;
        objacfbank.lstBankAccounts.add(objAAC);
        
        objacfbank.FetchStatements(); 
        
        objacfbank.strBankSlugName = 'anz';
        objacfbank.redirectToNextpage(); 
        objacfbank.skipMethod();
        objacfbank.redirect(); 
        test.stoptest();
        }
    }
    
    private static void LoadData()
    {
        createLead();
        createAccount();
 //     createContact();
        createUser();
        createOpportunity();

    }
    
     static void createLead()
    {
        objLead = WLCommonTrackerClass.createLeadForPortal();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        objContact = WLCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser =  WLCommonTrackerClass.CreatePortalUser(objAccount.id); 
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
    }
}