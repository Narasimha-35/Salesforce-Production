@isTest(SeeAllData = true)
private class acfDashboardDocBrokerControllerTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static Required_Document__c objRequiredDocument;
    private static Document_Master__c objDocumentMaster;
    private static Attachment objAttachment;
    
    static testMethod void validateacfDashboardDocumentController() 
    {
        //test.Starttest();
       
        LoadData();
//        List<Attachment> attachments=[select id, name from Attachment where parent.id=:objRequiredDocument.id];
        Cookie User_Id = new Cookie('DocPopUp','true',null,72000, false); 
        ApexPages.currentPage().setCookies( new Cookie[]{ User_Id });
        acfDashboardDocumentController_broker.WrapperDocuments wrap = new acfDashboardDocumentController_broker.WrapperDocuments();
        wrap.imageURL ='test';
        acfDashboardDocumentController_broker objacfDashboardDocumentController = new acfDashboardDocumentController_broker();
  //      objacfDashboardDocumentController.attach = attachments[0];
 //        objacfDashboardDocumentController.docattach=  attachments[0];
        objacfDashboardDocumentController .acid=objaccount.id; 
        objacfDashboardDocumentController.IndexNo = 0;
        objacfDashboardDocumentController.strDocumentName= 'test';
        objacfDashboardDocumentController.getattach();
        objacfDashboardDocumentController.getdocattach();
        objacfDashboardDocumentController.BindWrapperDocument(objOpportunity.Id);
        objacfDashboardDocumentController.redirect();
        objacfDashboardDocumentController.attach=objAttachment;
        objacfDashboardDocumentController.uploadDoc();
        objacfDashboardDocumentController.docattach=objAttachment;
        objacfDashboardDocumentController.UploadDragableFile();
        //objacfDashboardDocumentController.SendmailForDocumentUpload();
        objacfDashboardDocumentController.UploadDocumentsNotification();
        objacfDashboardDocumentController.DeleteDoc();
        objacfDashboardDocumentController.previewdoc();
        //test.Stoptest();
    }
    
    private static void LoadData()
    {
        createAccount();
        createContact();
        createUser();
        createOpportunity();
        createDocumentMaster();
        createRequiredDocument();
        createAttachment();
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
        objUser = acfCommontrackerClass.CreatePartnerUser(objUser);
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    
     static void createDocumentMaster()
    {
      objDocumentMaster = new Document_Master__c();
      objDocumentMaster = acfCommontrackerClass.createDocumentMaster(objDocumentMaster);
  
    }
    
    static void createRequiredDocument()
    {
        objRequiredDocument = new Required_Document__c ();      
        objRequiredDocument = acfCommontrackerClass.createRequiredDocument(objRequiredDocument,objDocumentMaster,objOpportunity);
        objRequiredDocument.acf_Bank_Statement_Doc__c=true;
        objRequiredDocument.acf_Is_Identity_Verification_Doc__c=true;
        update objRequiredDocument;
        system.debug('objRequiredDocument'+objRequiredDocument);
    }
    static void createAttachment()
    {
        objAttachment=new Attachment(); 
        objAttachment.ParentId =objRequiredDocument.Id;  
        objAttachment.Name = 'Test Attachment for Parent';  
        objAttachment.Body = Blob.valueOf('Test Data');  
        insert objAttachment;
        
    }
    
}