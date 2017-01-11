@isTest

public class sendEmailTemplateOnOppControllerTracker
{
    private static Lead objLead;
    private static Account objAccount;
    private static Account objpersonAccount;
    private static User objUser;
    private static User objOwner;
    private static User objPartner;
    private static Opportunity objOpp;
    private static Required_Document__c objre;
    private static Document_Master__c objmas;
      private static Contact objContact;   
       private static ID objID;  
        
        
    public static testMethod void validate1()
    {
        LoadData();
        sendEmailTemplateOnOppController objsendEmailController =new sendEmailTemplateOnOppController();
        objsendEmailController.accId =objID;
        objOpp.accountId =objID;
        update objOpp;
        sendEmailTemplateOnOppController.wrapOppInfo objWrapperOppInfo = new sendEmailTemplateOnOppController.wrapOppInfo();
        objWrapperOppInfo.strAccName = 'test';
        objWrapperOppInfo.strAccEmail = 'test@gmail.com';
        objWrapperOppInfo.strOwnerName = 'test';
        objWrapperOppInfo.strOwnerTitle = 'test'; 
        objWrapperOppInfo.strOwnerPhone = '123456789';
        objWrapperOppInfo.strOwnerEmail  = 'test@gmail.com';
        objWrapperOppInfo.strOwnerImgUrl = 'test';
        
        objsendEmailController.getobjWrapOppInfo();
        objsendEmailController.getlstReqDocs(); 
    }
    
     public static testMethod void validate2()
    {
        LoadData();
        sendEmailTemplateOnOppController objsendEmailController =new sendEmailTemplateOnOppController();
        
        sendEmailTemplateOnOppController.wrapOppInfo objWrapperOppInfo = new sendEmailTemplateOnOppController.wrapOppInfo();
        objWrapperOppInfo.strAccName = 'test';
        objWrapperOppInfo.strAccEmail = 'test@gmail.com';
        objWrapperOppInfo.strOwnerName = 'test';
        objWrapperOppInfo.strOwnerTitle = 'test'; 
        objWrapperOppInfo.strOwnerPhone = '123456789';
        objWrapperOppInfo.strOwnerEmail  = 'test@gmail.com';
        objWrapperOppInfo.strOwnerImgUrl = 'test';
        
        objID = objAccount.Id;
        objsendEmailController.accId =objID;
       // objpersonAccount.Id =objID;
        
        //update objAccount;
        
        objsendEmailController.getobjWrapOppInfo();
        objsendEmailController.getlstReqDocs(); 
    }


       public static void LoadData()
    {
        createLead();
        createmasterdoc();
        createPersonAccount();
        createPortalUser();
        createAccount();
        createOpportunity();
        createContact();
       createrequireddoc();
    }
    
     static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLead(objLead); 
    }
    
    static void createAccount()
    {
        objAccount = new Account();
         objAccount = WLCommonTrackerClass.createAccount(objAccount);
        objAccount.Owner = objOwner;
        update objAccount;
         System.debug('objAccount'+objAccount);
    }
    
    static void createPersonAccount()
    {
        objpersonAccount= new Account();
        
        objpersonAccount=WLCommonTrackerClass.CreatePersonAccount('Fname','LName','strPhone','strLead12Email@gmail.com',objLead.Id);
    }
    
    static void createPortalUser()
    {
        objUser = new User();
        objUser = WLCommonTrackerClass.CreatePortalUser(objpersonAccount.id);
    }
    
     static void createOpportunity()
    {
        objOpp= new Opportunity();
        objOpp=WLCommonTrackerClass.createOpportunity1(objOpp,objpersonAccount);
        string recTypeId = ClickCommon.GetRecordTypeId('Opportunity','Click Refi');       
        objOpp.recordTypeId = recTypeId;
        Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(recTypeId).getname();
        update objOpp;
    }
    
    static void createmasterdoc()
    {
        objmas= new Document_Master__c(); 
        objmas= WLCommonTrackerClass.createDocumentMaster(objmas);
    }
    
    static void createrequireddoc()
    {
        objre= new Required_Document__c();
        objre.Lead__c=objLead.Id;
        objre= WLCommonTrackerClass.createRequiredDocument(objre,objmas,objOpp);
    
    }
     static void createContact()
    {
        objContact = new Contact();
        objContact.ACF_BankName__c = 'test';
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
}