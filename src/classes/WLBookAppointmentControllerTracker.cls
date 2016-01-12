@isTest(SeeAllData =true)
private class WLBookAppointmentControllerTracker {
    private static User objUser;
    private static Contact objContact;
    private static Lead objLead;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    
    static testMethod void validateWLBookAppointmentController() 
    {
        LoadData();
        System.runAs(objUser)
        {
        WLBookAppointmentController objacfBookAppointmentController = new WLBookAppointmentController ();
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
    
     static testMethod void validateWLBookAppointmentController3() 
    {
        LoadData();
        System.runAs(objUser)
        {
        WLBookAppointmentController objacfBookAppointmentController = new WLBookAppointmentController ();
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
    
     static testMethod void validateWLBookAppointmentController2() 
    {
        LoadData();
        WLBookAppointmentController objacfBookAppointmentController = new WLBookAppointmentController ();
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
    
      static testMethod void validateacfBookAppointmentController1() 
    {
        LoadData1();
        WLBookAppointmentController objacfBookAppointmentController = new WLBookAppointmentController ();
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
    }
    
     
    
     private static void LoadData()
    {
        createLead();
        createAccount();
  //      createContact();
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
        //objContact.AccountId = objAccount.id;
        objContact.acf_lead__c = objLead.id;
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    { 
        objUser = new User();
        objUser.MobilePhone='+611234567890';
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id); 
    }
    
    
     static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
    }
    
}