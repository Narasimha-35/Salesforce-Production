@isTest(SeeAllData =true)
private class acfBookAppbrokerControllerTracker {
    private static User objUser;
    private static Contact objContact;
    private static Lead objLead;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    
    static testMethod void validateacfBookAppointmentController() 
    {
        LoadData();
        System.runAs(objUser)
        {
        acfBookAppointmentController_broker objacfBookAppointmentController = new acfBookAppointmentController_broker();
        objacfBookAppointmentController.acid=objaccount.id;
        objacfBookAppointmentController.isMsgsent = true;
        objacfBookAppointmentController.strPost ='test';
        objacfBookAppointmentController.strfeedmsg ='test';
        objacfBookAppointmentController.strfeedSuccessmsg ='test';
        objacfBookAppointmentController.isError = true;
        objacfBookAppointmentController.showMessage = true;
        objacfBookAppointmentController.successMsg = true;
        objacfBookAppointmentController.selectedDate = 'Schedule';
//        objacfBookAppointmentController.Obj_OppOwner = [select id,Name,FullPhotoUrl,username,MobilePhone from user where id=:objOpportunity.ownerId]; 
     //  objacfBookAppointmentController.usrObj = [select id,username,Name,contactId,accountId,contact.acf_lead__c,Email,firstName,lastName,MobilePhone from user where id=:UserInfo.getuserId()];
     //   objacfBookAppointmentController.usrObj.MobilePhone='+611234567890';
         objacfBookAppointmentController.usrObj=objUser;
        objacfBookAppointmentController.schTimeMethod();
        objacfBookAppointmentController.redirect();
        
        
        objacfBookAppointmentController.strMortgageMsg = 'test';
        objacfBookAppointmentController.Obj_OppOwner=objUser;
        objacfBookAppointmentController.sendmsgToLeadOwner();
        objacfBookAppointmentController.showCalender();
        objacfBookAppointmentController.getItems();
        objacfBookAppointmentController.getTimeItems(); 
        objacfBookAppointmentController.selectedTime='11:30 PM';
        objacfBookAppointmentController.schDate='05/27/2015';
        objacfBookAppointmentController.createTask();
        objacfBookAppointmentController.postQuery();
        }
        
    }
    
     static testMethod void validateacfBookAppointmentController3() 
    {
        LoadData();
        System.runAs(objUser)
        {
        acfBookAppointmentController_broker objacfBookAppointmentController = new acfBookAppointmentController_broker();
        objacfBookAppointmentController.acid=objaccount.id;
        objacfBookAppointmentController.isMsgsent = true;
        objacfBookAppointmentController.strPost ='test';
        objacfBookAppointmentController.strfeedmsg ='test';
        objacfBookAppointmentController.strfeedSuccessmsg ='test';
        objacfBookAppointmentController.isError = true;
        objacfBookAppointmentController.showMessage = true;
        objacfBookAppointmentController.successMsg = true;
        objacfBookAppointmentController.selectedDate = 'Schedule';
//        objacfBookAppointmentController.Obj_OppOwner = [select id,Name,FullPhotoUrl,username,MobilePhone from user where id=:objOpportunity.ownerId]; 
     //  objacfBookAppointmentController.usrObj = [select id,username,Name,contactId,accountId,contact.acf_lead__c,Email,firstName,lastName,MobilePhone from user where id=:UserInfo.getuserId()];
     //   objacfBookAppointmentController.usrObj.MobilePhone='+611234567890';
         objacfBookAppointmentController.usrObj=objUser;
        objacfBookAppointmentController.schTimeMethod();
        objacfBookAppointmentController.redirect();
        
        
        objacfBookAppointmentController.strMortgageMsg = 'test';
        objacfBookAppointmentController.Obj_OppOwner=objUser;
        objacfBookAppointmentController.sendmsgToLeadOwner();
        objacfBookAppointmentController.showCalender();
        objacfBookAppointmentController.getItems();
        objacfBookAppointmentController.getTimeItems(); 
        objacfBookAppointmentController.selectedTime='11:30 PM';
        objacfBookAppointmentController.schDate='05/29/2015';
        objacfBookAppointmentController.createTask();
        objacfBookAppointmentController.postQuery();
        }
        
    }
    
     static testMethod void validateacfBookAppointmentController2() 
    {
        LoadData();
        acfBookAppointmentController_broker objacfBookAppointmentController = new acfBookAppointmentController_broker();
        objacfBookAppointmentController.acid=objaccount.id;
        objacfBookAppointmentController.isMsgsent = true;
        
        objacfBookAppointmentController.strPost ='test';
        objacfBookAppointmentController.strfeedmsg ='test';
        objacfBookAppointmentController.strfeedSuccessmsg ='test';
        objacfBookAppointmentController.isError = true;
        objacfBookAppointmentController.showMessage = true;
        objacfBookAppointmentController.successMsg = true;
        objacfBookAppointmentController.selectedDate = 'Schedule';
//        objacfBookAppointmentController.Obj_OppOwner = [select id,Name,FullPhotoUrl,username,MobilePhone from user where id=:objOpportunity.ownerId]; 
     //  objacfBookAppointmentController.usrObj = [select id,username,Name,contactId,accountId,contact.acf_lead__c,Email,firstName,lastName,MobilePhone from user where id=:UserInfo.getuserId()];
     //   objacfBookAppointmentController.usrObj.MobilePhone='+611234567890';
        // objacfBookAppointmentController.usrObj=objUser;
        objacfBookAppointmentController.schTimeMethod();
        objacfBookAppointmentController.redirect();
        
        
        objacfBookAppointmentController.strMortgageMsg = 'test';
       // objacfBookAppointmentController.Obj_OppOwner=objUser;
        objacfBookAppointmentController.sendmsgToLeadOwner();
        objacfBookAppointmentController.showCalender();
        objacfBookAppointmentController.getItems();
        objacfBookAppointmentController.getTimeItems(); 
        objacfBookAppointmentController.selectedTime='11:30 PM';
        objacfBookAppointmentController.schDate='05/27/2015';
        objacfBookAppointmentController.createTask();
        objacfBookAppointmentController.postQuery();
        
        
    }
    
      /*static testMethod void validateacfBookAppointmentController1() 
    {
        LoadData1();
        acfBookAppointmentController_broker objacfBookAppointmentController = new acfBookAppointmentController_broker();
        objacfBookAppointmentController.acid=objaccount.id;
        objacfBookAppointmentController.isMsgsent = true;
        objacfBookAppointmentController.strPost ='test';
        objacfBookAppointmentController.strfeedmsg ='test';
        objacfBookAppointmentController.strfeedSuccessmsg ='test';
        objacfBookAppointmentController.isError = true;
        objacfBookAppointmentController.showMessage = true;
        objacfBookAppointmentController.successMsg = true;
        objacfBookAppointmentController.selectedDate = 'Schedule';
       
        
        
        objacfBookAppointmentController.schTimeMethod();
        objacfBookAppointmentController.redirect();
        objacfBookAppointmentController.strMortgageMsg = null;
        objacfBookAppointmentController.sendmsgToLeadOwner();
        objacfBookAppointmentController.showCalender();
        objacfBookAppointmentController.getItems();
        objacfBookAppointmentController.getTimeItems();     
        objacfBookAppointmentController.createTask();
        objacfBookAppointmentController.postQuery();
    }*/
    
     
    
     private static void LoadData()
    {
        createLead();
        createAccount();
        createContact();
        createUser();
        createOpportunity();
    }
    
         private static void LoadData1()
    {
        createLead();
        createAccount();
  //      createContact();
        createUser();
  //      createOpportunity();
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
    }
    
    
     static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    
}