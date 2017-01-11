@isTest
private class acfTaskDashboardbrokerTracker {
    private static user objUser;
    private static acfTask_Master__c objTask;
    private static Opportunity objOpportunity;
    private  static Lead objLead;
    private  static Account objAccount;
    private  static Contact objContact;

    static testMethod void validateacfTaskDashboard() 
    {
        LoadData();
        
        System.runAs(objuser){
        List<Task> tasks = new List<Task>();
        Task objtsk = new Task();
        objtsk.ActivityDate = Date.today().addDays(1);
        objtsk.Subject='Sample Task';
        objtsk.WhatId = UserInfo.getUserId();
   //     objtsk.OwnerId = UserInfo.getUserId();
        objtsk.Status='In Progress';
        tasks.add(objtsk);


        acfTaskDashboard_broker objacfTaskDashboard = new acfTaskDashboard_broker();
        objacfTaskDashboard.tsk_obj = tasks;
        objacfTaskDashboard.user_id =UserInfo.getUserId();
        objacfTaskDashboard.strTasksub = 'test';
        objacfTaskDashboard.redirect();
        objacfTaskDashboard.toOpenTaskdetails();
        }
        
    }
    
    private static void LoadData()
    {   
        createLead();
        createAccount();
        createContact();
        createUser();
        createOpportunity();
        createTask();
        
    }
    
    
static void createLead()
    {
        objLead = new Lead();
        objLead = acfCommonTrackerClass.createLeadForPortal();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        //objAccount.recordtype.name='Business Account';
        objAccount.name='testname';
        insert objAccount;
        //objAccount = acfCommontrackerClass.createAccount(objaccount);
    }
    
    static void createContact()
    {
        
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = acfCommontrackerClass.createPartnerContact(objContact,objAccount);
        
        
        
    }
    
    static void createuser()
    {
        objUser = new User();
        objUser.MobilePhone='+611234567890';
        
        objUser.contactId=objContact.Id;
         List<Profile> lstCommUserProfile = [select id,name from profile where name='Customize Partner User' limit 1];
            //List<Account>lstPersonContact = [select id,PersonContactId from Account where id=:ContactId];
            //User objUser = new User();
            objUser.FirstName = 'test';
            objUser.LastName = 'test';
            objUser.Alias  = ('test'+String.valueof(Math.random())).substring(0,5);
            objUser.LocaleSidKey = 'en_AU';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.MobilePhone = '+6145678904';
            objUser.Username = 'test@fakeEmail.com'+objUser.Alias;
            objUser.Email = 'test@fakeEmail.com';
            objUser.ProfileId = lstCommUserProfile[0].id;
            //objUser.ContactId = lstPersonContact[0].PersonContactId;
            objuser.EmailEncodingKey = 'UTF-8';
            objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
            objUser.TimeZoneSidKey = 'Australia/Brisbane';
            objUser.acfIs_Password_Reset__c = true;
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = false;
            objUser.setOptions(dlo);
            insert(objUser);
            //return objUser;
        
        
        
        //objUser = acfCommonTrackerClass.CreatePartnerPortalUser(objContact.id); 
    }
    static void createOpportunity()
    {
        objOpportunity = new Opportunity();
        //objOpportunity.AccountId =objAccount.Id;
        objOpportunity = acfCommonTrackerClass.createOpportunity(objOpportunity,objuser);
        system.debug(objOpportunity+'------------------------------------');
    }
    
    static void createTask()
    {
        objTask = new acfTask_Master__c();
        objTask = acfCommonTrackerClass.createTask(objtask);
    }
}