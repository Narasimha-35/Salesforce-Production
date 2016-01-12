@isTest(SeeAllData = true)
private class acfResetPasswordTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;

    
    static testMethod void validateController() 
    {
       LoadData();
       PageReference pageRef = new PageReference('http://www.google.com');
       Test.setCurrentPage(pageRef);
       acfResetPassword objreset = new acfResetPassword();
       objreset.IsLoginAttemptCompleted = true;
       objreset.stroldPassword = 'ankit';
       objreset.strnewPassword = 'test@007007';
       objreset.strverifynewPassword = 'test@007007';
       objreset.pageName = 'clickeditprofile';
   
       objreset.ResetPassword();
       objreset.ChkValidPassword('test');
       

    }
    
        static testMethod void validateController1() 
    {
       LoadData();
       PageReference pageRef = new PageReference('http://www.google.com');
       Test.setCurrentPage(pageRef);
       acfResetPassword objreset = new acfResetPassword();
       objreset.IsLoginAttemptCompleted = true;
       objreset.stroldPassword = null;
       objreset.strnewPassword = 'test@007007';
       objreset.strverifynewPassword = 'test@007007';
       objreset.pageName = 'clickeditprofile';

       objreset.ResetPassword();
       objreset.ChkValidPassword('test');
       

    }
    
       static testMethod void validateController2() 
    {
       LoadData();
       PageReference pageRef = new PageReference('http://www.google.com');
       Test.setCurrentPage(pageRef);
       acfResetPassword objreset = new acfResetPassword();
       objreset.IsLoginAttemptCompleted = true;
       objreset.stroldPassword = 'Ankit';
       objreset.strnewPassword = 'test@0';
       objreset.strverifynewPassword = 'test@007007';
       objreset.pageName = 'clickeditprofile';

       objreset.ResetPassword();
       objreset.ChkValidPassword('test');
       

    }
    
           static testMethod void validateController3() 
    {
       LoadData();
       PageReference pageRef = new PageReference('http://www.google.com');
       Test.setCurrentPage(pageRef);
       acfResetPassword objreset = new acfResetPassword();
       objreset.IsLoginAttemptCompleted = true;
       objreset.stroldPassword = 'Ankit';
       objreset.strnewPassword = 'testtesttt';
       objreset.strverifynewPassword = 'testtesttt';
       objreset.pageName = 'clickeditprofile';

       objreset.ResetPassword();
       objreset.ChkValidPassword('testtesttt');
       

    }
    
     static testMethod void validateController4() 
    {
       LoadData();
       Lead objLead=acfCommontrackerClass.createLeadForPortal();
       objAccount=acfCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
       objuser=acfCommonTrackerClass.CreatePortalUser(objAccount.id);
       system.debug('----------------------'+objUser);
       System.runAs(objUser)
           {
       PageReference pageRef = new PageReference('http://www.google.com');
       Test.setCurrentPage(pageRef);
       acfResetPassword objreset = new acfResetPassword();
       objreset.IsLoginAttemptCompleted = true;
       objreset.stroldPassword = 'ankit';
       objreset.strnewPassword = 'test@007007';
       objreset.strverifynewPassword = 'test@007007';
       objreset.pageName = 'clickeditprofile';
       objreset.stroldPassword='testtesttest';
       objreset.strnewPassword='testtesttest1';
       objreset.strverifynewPassword='testtesttest1';
       objreset.ResetPassword();
       objreset.ChkValidPassword('test');
           }
       

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