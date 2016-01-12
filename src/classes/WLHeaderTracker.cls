@isTest(seeAllData=true)
private class WLHeaderTracker 
{
    private static Lead objLead;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;


    
    static testMethod void validate() 
    {
        LoadData();

        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        
        acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj .Name ='acfcontactus';
        obj .acfDescription__c = 'Ankit Singh';
        obj .acfHeading__c = 'abcd';
        insert obj ;
        
        Cookie  ACFQues = new Cookie('ACFQues',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{ACFQues});
        
        Cookie  ACFAnswers = new Cookie('ACFAnswers',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{ACFAnswers});        
        
        Cookie  IsNewHomeLoan = new Cookie('IsNewHomeLoan',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{IsNewHomeLoan});   
        
        Cookie LeadId = new Cookie('leadId',null,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{LeadId});
        
        acfContentManagementSystem__c   objContentManagementSystem1 = new acfContentManagementSystem__c();
        objContentManagementSystem1.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem1.acfPageName__c = 'common';
        objContentManagementSystem1.acfSectionName__c = 'Footer';
        objContentManagementSystem1.acfSequence__c = 5;
        objContentManagementSystem1.acfDescription__c = 'Online loans';
        objContentManagementSystem1.acfIs_Checked__c = true;
        objContentManagementSystem1.acfHeader_Sequance__c = 4;
//        objContentManagementSystem.acfCMS_Page__c = obj.id;
        insert objContentManagementSystem1;
        
        acfContentManagementSystem__c   objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'common';
        objContentManagementSystem.acfSectionName__c = 'Footer Links';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;
        objContentManagementSystem.acfCMS_Page__c = obj.id;
        insert objContentManagementSystem;
  
        WLHeader objhead = new WLHeader();
        objhead.showConfirmMsg = 'payment done';
        objhead.isLoggedIn = false;
        objhead.strusername = 'deepanshu.chadha@saasforce.in+acf.acf';
        objhead.strPassword = 'test@007007';
        objhead.strTimezoneId = 'America/New_York'; 
        objhead.selectedLinkId = 'test';

        objhead.memberLogin();
        objhead.strforgotUsername = 'deepanshu.chadha@saasforce.in+acf.acf';
        objhead.ResetPassword();
        objhead.resetforgotPopup();
        objhead.clearUserSessionCookies();
  
    }
    
      static testMethod void validate1() 
    {
        LoadData();

        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        
        acfContentManagementSystem__c   objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'common';
        objContentManagementSystem.acfSectionName__c = 'Footer';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;

        insert objContentManagementSystem;
        
        WLHeader objhead = new WLHeader();
        objhead.showConfirmMsg = 'payment done';
        objhead.isLoggedIn = false;
        objhead.strusername = null;
        objhead.strPassword = 'test@007007';
        objhead.strTimezoneId = 'America/New_York'; 

        objhead.memberLogin();
        objhead.strforgotUsername = null;
        objhead.ResetPassword();
        objhead.resetforgotPopup();

    }
    
        static testMethod void validate2() 
    {
        LoadData();

        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        
        acfContentManagementSystem__c   objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'common';
        objContentManagementSystem.acfSectionName__c = 'Footer';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;

        insert objContentManagementSystem;
      
        WLHeader objhead = new WLHeader();
        objhead.showConfirmMsg = 'payment done';
        objhead.isLoggedIn = false;
        objhead.strusername = 'deepanshu.chadha@saasforce.in+acf.acf';
        objhead.strPassword = null;
        objhead.strTimezoneId = 'America/New_York'; 

        objhead.memberLogin();
        objhead.strforgotUsername = 'karthik.test123';
        objhead.ResetPassword();
        objhead.resetforgotPopup();
      
    }
    
      static testMethod void validate3() 
    {   
        LoadData1();                              
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        
        acfContentManagementSystem__c   objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'common';
        objContentManagementSystem.acfSectionName__c = 'Footer';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;

        insert objContentManagementSystem;
       
        WLHeader objhead = new WLHeader();
        objhead.showConfirmMsg = 'payment done';
        objhead.isLoggedIn = false;
        objhead.strusername = 'testing';
        objhead.strPassword = 'test@007007';
        objhead.strTimezoneId = 'America/New_York'; 

        objhead.memberLogin();
        objhead.strforgotUsername = 'testtest';
        objhead.ResetPassword();
        objhead.resetforgotPopup();
        objhead.clearUserSessionCookies();
      
    }
    
          static testMethod void validate4() 
    {   
         LoadData1();
                             
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        
        acfContentManagementSystem__c   objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'common';
        objContentManagementSystem.acfSectionName__c = 'Footer';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;

        insert objContentManagementSystem;
       
        WLHeader objhead = new WLHeader();
                    
        Click_Community_Setup__c commSetup = new Click_Community_Setup__c();
        commSetup.Community_User_Name_Prefix__c = 'WL';
        insert commSetup;
        objhead.showConfirmMsg = 'payment done';
        objhead.isLoggedIn = false;
        objhead.strusername = 'testing';
        objhead.strPassword = 'test@007007';
        objhead.strTimezoneId = 'America/New_York'; 

        objhead.memberLogin();
        objhead.strforgotUsername = '';
        objhead.ResetPassword();
        objhead.resetforgotPopup();
        objhead.clearUserSessionCookies();
      
    }
    
    
    private static void LoadData()
    {
        createLead();
        createAccount();
//        createContact();
        createUser();
      
    }
    
        private static void LoadData1()
    {

        createLead();
        createAccount();
  //      createContact();
        createUser1();
      
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
        objContact.AccountId = objAccount.id;
        objContact.acf_lead__c = objLead.id;
        objContact = WLCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser = WLCommonTrackerClass.CreatePortalUser(objAccount.id); 

      
    }
    
        static void createuser1()
    {
        objUser = new User();
        objUser.isActive = false;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id); 

      
    }
    

   
    
}