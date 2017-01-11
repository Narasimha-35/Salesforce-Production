@isTest
private class ClickSendMessageBrokerControllerTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Lead objLead;
    private static Opportunity objOpportunity;
    
    static testMethod void validate() 
    {
        LoadData();
        ClickSendMessageController_broker obj = new ClickSendMessageController_broker();
        obj.acid=objAccount.id;
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
    
        
    static testMethod void validate1() 
    {
        LoadData();
        ClickSendMessageController_broker obj = new ClickSendMessageController_broker();
        obj.acid=objAccount.id; 
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
        ClickSendMessageController_broker obj = new ClickSendMessageController_broker();
        //obj.acid=objAccount.id;
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
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    

    
}