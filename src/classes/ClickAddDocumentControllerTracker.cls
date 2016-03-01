@isTest(SeeAllData = true)
private class ClickAddDocumentControllerTracker 
{
    private static Lead objLead;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static Required_Document__c objRequiredDocument;
    private static Document_Master__c objDocumentMaster;
    private static Attachment objAttachment;
    private static Click_Uploaded_Documents__c objClickUploadDoc;
    private static Click_Uploaded_Documents__c objClickUploadDocs;
    
    static testMethod void validate() 
    {
        LoadData();  
        
        Database.LeadConvert lc1 = new database.LeadConvert();
        lc1.setLeadId(objAccount.acf_Lead__pc);
        lc1.setDoNotCreateOpportunity(false);
        LeadStatus convertStatus1 = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc1.setConvertedStatus(convertStatus1.MasterLabel);

        Database.LeadConvertResult lcr1 = Database.convertLead(lc1);
        
        Cookie cookieActiveTab = new Cookie('cookieActiveTab','Document',null,-1, true); 
        ApexPages.currentPage().setCookies( new Cookie[]{ cookieActiveTab});  
        system.runAs(objUser) 
        {
            ClickAddDocumentController objClickAddDoc = new ClickAddDocumentController();
            objClickAddDoc.MyAccountId = string.valueOf(objAccount.id);
            objClickAddDoc.strReqDocName = 'test';
            objClickAddDoc.strerrMsg = 'test';
            objClickAddDoc.isDocAdded = true;
            objClickAddDoc.docMasterId = string.valueof(objDocumentMaster.Id);
            objClickAddDoc.getObjAccount();
            objClickAddDoc.insertReqDocument();
            objClickAddDoc.reqDocCancel();
            objClickAddDoc.resetReqDocPopup();
            objClickAddDoc.getDocumentMasterNames();
        }
    }
    
    private static void LoadData()
    {
        createLead();
        createAccount();
        createUser();
        createOpportunity();
        createDocumentMaster();
        createRequiredDocument();
        createAttachment();
        createClickUploadDocument();
    }
    
      
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommontrackerClass.createLeadForPortal();
        system.debug('objLead************'+objLead);
        
        
    }
    
    static void createAccount()
    {
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);
        lc.setDoNotCreateOpportunity(false);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc); 
        Lead objLead1 = new Lead();
        objLead1 = WLCommontrackerClass.createLeadForPortal();

       objAccount = new Account();
       objAccount.acf_Lead__pc = objLead1.id;
       objAccount =  WLCommonTrackerClass.createAccount(objAccount);
    }
    
    
    static void createuser()
    {

        objUser = new User();
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createOpportunity()
    {
      list<Account> lstAccount = [select id from Account where personContactId =: objUser.ContactId limit 1];
      objOpportunity = new Opportunity();
      objOpportunity.AccountId =lstAccount[0].id;
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity =  WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
    }
    
     static void createDocumentMaster()
    {
      objDocumentMaster = new Document_Master__c();
      objDocumentMaster =  WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);
  
    }
    
    static void createRequiredDocument()
    {
        objRequiredDocument = new Required_Document__c ();      
        objRequiredDocument =   WLCommonTrackerClass.createRequiredDocument(objRequiredDocument,objDocumentMaster,objOpportunity);
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
     static void createClickUploadDocument()
    {
        objClickUploadDoc = new Click_Uploaded_Documents__c();
        objClickUploadDoc.Click_Attachment_Id__c = objAttachment.Id;
        objClickUploadDoc.click_Is_deleted__c = true;
        objClickUploadDoc.Click_Loans_Required_Document__c = objRequiredDocument.Id;
        objClickUploadDoc.Name = 'test';
        insert objClickUploadDoc;
        
        objClickUploadDocs = new Click_Uploaded_Documents__c();
        objClickUploadDocs.Click_Attachment_Id__c = objAttachment.Id;
        objClickUploadDocs.click_Is_deleted__c = true;
        objClickUploadDocs.Click_Loans_Required_Document__c = objRequiredDocument.Id;
        objClickUploadDocs.Name = 'test';
        insert objClickUploadDocs;
    }
    
}