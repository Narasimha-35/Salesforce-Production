@isTest(SeeAllData = false)
private class ClickWelcomeDashboardBrokerTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity1;

    
    static testMethod void validate() 
    {
        LoadData();
        Click_Community_Setup__c obj1 = new Click_Community_Setup__c();
        obj1.Click_Network_ID__c = Network.getNetworkId();
        obj1.Click_IsActive__c = true;
        obj1.Click_Page_Prefix__c = 'Click';
  //      obj1.click_Home_Page_URL__c = 'https://uat-creditandfinance.cs5.force.com/ClickLoans';
        insert obj1;      
        
        
      Opportunity objOpportunity = new Opportunity();
      objOpportunity.AccountId =objAccount.id;
      Recordtype rt=[select id from Recordtype where name='Click Refi' and sobjecttype='opportunity' limit 1];
      objOpportunity.recordtypeid = rt.id;
      
      objOpportunity.acfDate_Conditionally_Approved__c = system.today();
      objOpportunity.Description = 'test';
      objOpportunity.acfApproval_Conditions__c = 'testing';
      objOpportunity.acfDate_Formally_Approved__c = system.today();
      objOpportunity.acfDate_Docs_Generated__c = system.today();
      objOpportunity.acfExpected_Settlement_Date__c = system.today().adddays(+3);
      objOpportunity.acf_Status__c = 'Conditionally Approved';
      objOpportunity.acfTenure__c = 2.5;
      objOpportunity.name = 'test';
      objOpportunity.Stagename = 'Application Taken';
      objOpportunity.CloseDate = System.today();
      //objOpportunity.      
      insert objOpportunity;
        
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cid',objAccount.id);
        ClickWelcomeDashboardclone obj = new ClickWelcomeDashboardclone();
        obj.pge_name = 'ClickEditProfile';
        
        

    }
    
      static testMethod void validate1() 
    {
        LoadData1();
        Click_Community_Setup__c obj1 = new Click_Community_Setup__c();
        obj1.Click_Network_ID__c = Network.getNetworkId();
        obj1.Click_IsActive__c = true;
        obj1.Click_Page_Prefix__c = 'Click';
//        obj1.click_Home_Page_URL__c = 'https://uat-creditandfinance.cs5.force.com/ClickLoans';
        insert obj1;    
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objuser.AccountId;
        objOpportunity.name = 'test';
        objOpportunity.recordtypeid = ClickCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.Stagename = 'Approval';
        objOpportunity.CloseDate = System.today();
        insert objOpportunity;
        
        
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ClickWelcomeDashboardclone obj = new ClickWelcomeDashboardclone();
        obj.pge_name = 'ClickEditProfile';
        

    }
    
       static testMethod void validate2() 
    {
        LoadData1();
        Click_Community_Setup__c obj1 = new Click_Community_Setup__c();
        obj1.Click_Network_ID__c = Network.getNetworkId();
        obj1.Click_IsActive__c = true;
        obj1.Click_Page_Prefix__c = 'Click';
 //       obj1.click_Home_Page_URL__c = 'https://uat-creditandfinance.cs5.force.com/ClickLoans';
        insert obj1;     
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objuser.AccountId;
        objOpportunity.name = 'test';
        objOpportunity.recordtypeid = ClickCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.Stagename = 'Loan Document';
        objOpportunity.CloseDate = System.today();
        insert objOpportunity;
        
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ClickWelcomeDashboard obj = new ClickWelcomeDashboard();
        

    }
    
         static testMethod void validate3() 
    {
        LoadData1();
        Click_Community_Setup__c obj1 = new Click_Community_Setup__c();
        obj1.Click_Network_ID__c = Network.getNetworkId();
        obj1.Click_IsActive__c = true;
        obj1.Click_Page_Prefix__c = 'Click';
 //       obj1.click_Home_Page_URL__c = 'https://uat-creditandfinance.cs5.force.com/ClickLoans';
        insert obj1;   
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objuser.AccountId;
        objOpportunity.name = 'test';
        objOpportunity.recordtypeid = ClickCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.Stagename = 'Settlement';
        objOpportunity.CloseDate = System.today();
        insert objOpportunity; 
        
         acfContentManagementSystem__c   objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'acfLogin';
        objContentManagementSystem.acfSectionName__c = 'Dashboard';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;
        objContentManagementSystem.Click_Community_Setup__c = obj1.Id;
        insert objContentManagementSystem;
        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='test';
        t.Status='open';
        t.Priority='Normal';
        t.WhatId = objOpportunity.id;
        insert t;

        
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ClickWelcomeDashboardclone obj = new ClickWelcomeDashboardclone();
        

    }
    
     /*static testMethod void validate4() 
    {
        LoadData1();
        
        system.runas(objUser)
        {
        Lead objLead = new Lead();
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.acfIs_Identity_Document_Rejected__c = false;
        objLead.RecordTypeId = ClickCommon.GetRecordTypeId('Lead','Click Refi');
        objLead.Status = 'Open';
        objLead.acfOneTimePassword__c = '724715';
        insert objLead;
        
 //       objUser.contact.acf_lead__c = objLead.id;
 //       update objUser;
        
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ClickWelcomeDashboardclone obj = new ClickWelcomeDashboardclone();
        obj.pge_name = 'WLEditProfile';
        }
        

    }*/
    
    
    private static void LoadData()
    {
        createAccount();
  //    createContact();
        createUser();
        createOpportunity();

    }
    
     private static void LoadData1()
    {
        createAccount();
  //    createContact();
        createUser();
  //      createOpportunity();

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
      objOpportunity1 = new Opportunity();
      objOpportunity1 = WLCommonTrackerClass.createOpportunity(objOpportunity1,objUser);
    }
    
}