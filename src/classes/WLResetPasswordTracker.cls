@isTest(SeeAllData = false)
private class WLResetPasswordTracker 
{
    private static User objUser;
     private static User objUser1;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static Click_Community_Setup__c objclcmm;
    
    static testMethod void validateController() 
    {
       LoadData();
       PageReference pageRef = new PageReference('http://www.changepassword.com');
       Test.setCurrentPage(pageRef);
       WLResetPassword objreset = new WLResetPassword();
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
       WLResetPassword objreset = new WLResetPassword();
       objreset.IsLoginAttemptCompleted = true;
       objreset.stroldPassword = null;
       objreset.strnewPassword = 'test@007007';
       objreset.strverifynewPassword = 'test@007007';
       objreset.pageName = 'clickeditprofile';
       objreset.ChkValidPassword('test');

       objreset.ResetPassword();
       objreset.ChkValidPassword('test');
       

    }
    
       static testMethod void validateController2() 
    {
       LoadData();
       PageReference pageRef = new PageReference('http://www.google.com');
       Test.setCurrentPage(pageRef);
       WLResetPassword objreset = new WLResetPassword();
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
       PageReference pageRef = new PageReference('http://changepassword');
       Test.setCurrentPage(pageRef);
       WLResetPassword objreset = new WLResetPassword();
       objreset.IsLoginAttemptCompleted = true;
       objreset.stroldPassword = 'Ankit';
       objreset.strnewPassword = 'testtesttt';
       objreset.strverifynewPassword = 'testtesttt';
       objreset.pageName = 'clickeditprofile';

       objreset.ResetPassword();
       objreset.ChkValidPassword('testtesttt');
       

    }
     static testMethod void validateController7() 
    {
       LoadData();
       PageReference pageRef = new PageReference('http://www.changepassword.com');
       Test.setCurrentPage(pageRef);
       WLResetPassword objreset = new WLResetPassword();
       objreset.IsLoginAttemptCompleted = true;
       objreset.stroldPassword = 'ankit';
       objreset.strnewPassword = 'test@007007';
       objreset.strverifynewPassword = 'test@007007';
       objreset.pageName = 'ashish';
   
       objreset.ResetPassword();
       objreset.ChkValidPassword('test');
       

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
       WLResetPassword objreset = new WLResetPassword();
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
        createclickCommunitySetup();

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
    
    
     static void createclickCommunitySetup() 
    {
        objclcmm= new Click_Community_Setup__c();
        objclcmm.Click_IsActive__c=true;
        objclcmm.Click_Page_Prefix__c='Click';
        objclcmm.Community_User_Name_Prefix__c='test';
        insert objclcmm;
        //objclcmm= ClickCommon.getCommunitySetup('');
        
    }
}