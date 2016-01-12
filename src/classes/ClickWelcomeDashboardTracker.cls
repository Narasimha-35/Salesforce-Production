@isTest(SeeAllData = false)
private class ClickWelcomeDashboardTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;

    
    static testMethod void validate() 
    {
        LoadData();
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objuser.AccountId;
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Application Taken';
        objOpportunity.CloseDate = System.today();
        insert objOpportunity;
        
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ClickWelcomeDashboard obj = new ClickWelcomeDashboard();
        obj.pge_name = 'ClickEditProfile';
        

    }
    
      static testMethod void validate1() 
    {
        LoadData();
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objuser.AccountId;
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Approval';
        objOpportunity.CloseDate = System.today();
        insert objOpportunity;
        
        
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ClickWelcomeDashboard obj = new ClickWelcomeDashboard();
        obj.pge_name = 'ClickEditProfile';
        

    }
    
       static testMethod void validate2() 
    {
        LoadData();
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objuser.AccountId;
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Loan Document';
        objOpportunity.CloseDate = System.today();
        insert objOpportunity;
        
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ClickWelcomeDashboard obj = new ClickWelcomeDashboard();
        

    }
    
         static testMethod void validate3() 
    {
        LoadData();
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objuser.AccountId;
        objOpportunity.name = 'test';
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
        ClickWelcomeDashboard obj = new ClickWelcomeDashboard();
        

    }
    
     static testMethod void validate4() 
    {
        LoadData();
        
        Lead objLead = new Lead();
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.acfIs_Identity_Document_Rejected__c = false;
        objLead.Status = 'Open';
        objLead.acfOneTimePassword__c = '724715';
        insert objLead;
        
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ClickWelcomeDashboard obj = new ClickWelcomeDashboard();
        obj.pge_name = 'ClickEditProfile';
        

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
        objUser = acfCommontrackerClass.createuser(objUser);
    }
    


    
}