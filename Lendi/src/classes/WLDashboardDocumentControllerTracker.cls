@isTest
private class WLDashboardDocumentControllerTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static Required_Document__c objRequiredDocument;
    private static Document_Master__c objDocumentMaster;
    private static Attachment objAttachment;
    private static Click_Uploaded_Documents__c objClickUploadDoc;
    private static Click_Uploaded_Documents__c objClickUploadDocs;
    
    static testMethod void validateacfDashboardDocumentController() 
    {
        LoadData();
        Note objNote = new Note();
        objNote.ParentId = objRequiredDocument.Id;  
        objNote.Body = 'test';
        objNote.Title = 'test';
        insert objNote;
        string reqDocId = Apexpages.currentPage().getParameters().put('recName',objRequiredDocument.Id);
        list<Attachment> lstAttach = new list<Attachment>();
        Attachment objAttach = new Attachment(); 
        objAttach .ParentId =objRequiredDocument.Id;  
        objAttach .Name = 'Test Attachment for Parent';  
        objAttach .Body = Blob.valueOf('Test Data');  
        lstAttach.add(objAttach);
        
        Attachment objAttachs = new Attachment(); 
        objAttachs .ParentId =objRequiredDocument.Id;  
        objAttachs .Name = 'Test Attachment for Parent';  
        objAttachs .Body = Blob.valueOf('Test Data');  
        lstAttach.add(objAttachs);
        if(lstAttach != null && lstAttach.size() > 0)
        insert lstAttach;
        
        objClickUploadDocs.Click_Attachment_Id__c = lstAttach[0].Id;
        update objClickUploadDocs;
        objClickUploadDoc.Click_Attachment_Id__c = lstAttach[0].Id;
        update objClickUploadDoc;
   
        Cookie User_Id = new Cookie('DocPopUp','true',null,72000, false); 
        ApexPages.currentPage().setCookies( new Cookie[]{ User_Id });
        
        List<WLDashboardDocumentController.wrapAttachDocs> lstwrap = new List<WLDashboardDocumentController.wrapAttachDocs>();
        WLDashboardDocumentController.wrapAttachDocs objwrapatt = new WLDashboardDocumentController.wrapAttachDocs();
        objwrapatt.strDocName = 'test';
        objwrapatt.isDeleted= true;
        objwrapatt.attachId= lstAttach[0].id;
        objwrapatt.imgUrl= 'test.com';
        lstwrap.add(objwrapatt);
        
        WLDashboardDocumentController.wrapAttachDocs objwrapattach = new WLDashboardDocumentController.wrapAttachDocs();
        objwrapattach.strDocName = 'test';
        objwrapattach.isDeleted= true;
        objwrapattach.attachId= lstAttach[0].id;
        objwrapattach.imgUrl= 'test.com';
        lstwrap.add(objwrapattach);
        
        WLDashboardDocumentController.WrapperDocuments wrap = new WLDashboardDocumentController.WrapperDocuments();
        wrap.imageURL = 'test';
        wrap.objRequiredDocumnets = objRequiredDocument;
        wrap.attList = lstAttach;
        wrap.lstWrapAttachDocs = lstwrap;
        WLDashboardDocumentController objacfDashboardDocumentController = new WLDashboardDocumentController();
        objacfDashboardDocumentController.IndexNo = 0;
        objacfDashboardDocumentController.IndexNo1= 0;
        objacfDashboardDocumentController.strDocumentName= 'test';
        WLDashboardDocumentController.attachBlob(string.valueof(objRequiredDocument.id),'','test','test','test',0);
        objacfDashboardDocumentController.getattach();
        objacfDashboardDocumentController.getdocattach();
        objacfDashboardDocumentController.BindWrapperDocument(objOpportunity.Id);
        objacfDashboardDocumentController.redirect();
        WLDashboardDocumentController.uploadMultipleDoc(1,string.valueof(objOpportunity.Id));
        objacfDashboardDocumentController.fetchDocName();
        objacfDashboardDocumentController.frameURL();
        objacfDashboardDocumentController.addNotes();
        objacfDashboardDocumentController.ResetPopup1();
        objacfDashboardDocumentController.attach=objAttachment;
        objacfDashboardDocumentController.uploadDoc();
        objacfDashboardDocumentController.docattach=objAttachment;
        objacfDashboardDocumentController.UploadDocumentsNotification();
        objacfDashboardDocumentController.previewdoc();
        objacfDashboardDocumentController.DeleteDoc();
        objacfDashboardDocumentController.downloadFile();
        objacfDashboardDocumentController.deleteFile_Acf();
    }
    
      static testMethod void validateacfDashboardDocumentController1() 
    {
        //test.Starttest();
       
        LoadData();
        objOpportunity.AccountId =objAccount.id;
        update objOpportunity;

        Cookie User_Id = new Cookie('DocPopUp','true',null,72000, false); 
        ApexPages.currentPage().setCookies( new Cookie[]{ User_Id });
        WLDashboardDocumentController.WrapperDocuments wrap = new WLDashboardDocumentController.WrapperDocuments();
        wrap.imageURL ='test';
        WLDashboardDocumentController objacfDashboardDocumentController = new WLDashboardDocumentController();
        
        objacfDashboardDocumentController.fetchDocName();
        objacfDashboardDocumentController.frameURL();
        objacfDashboardDocumentController.addNotes();
        objacfDashboardDocumentController.ResetPopup1();
        objacfDashboardDocumentController.IndexNo = 0;
        objacfDashboardDocumentController.strDocumentName= 'test';
        objacfDashboardDocumentController.getattach();
        objacfDashboardDocumentController.getdocattach();
        objacfDashboardDocumentController.BindWrapperDocument(objOpportunity.Id);
        objacfDashboardDocumentController.redirect();
        objacfDashboardDocumentController.DeleteDoc();
        objacfDashboardDocumentController.attach=objAttachment;
        objacfDashboardDocumentController.uploadDoc();
        objacfDashboardDocumentController.docattach=objAttachment;
        objacfDashboardDocumentController.UploadDocumentsNotification();
        objacfDashboardDocumentController.DeleteDoc();
        objacfDashboardDocumentController.previewdoc();
        //test.Stoptest();
    }
    
     static testMethod void validateacfDashboardDocumentController2() 
    {
        LoadData();
               
        list<Attachment> lstAttach = new list<Attachment>();
        Attachment objAttach = new Attachment(); 
        objAttach .ParentId =objRequiredDocument.Id;  
        objAttach .Name = 'Test Attachment for Parent';  
        objAttach .Body = Blob.valueOf('Test Data');  
        lstAttach.add(objAttach);
        
        Attachment objAttachs = new Attachment(); 
        objAttachs .ParentId =objRequiredDocument.Id;  
        objAttachs .Name = 'Test Attachment for Parent';  
        objAttachs .Body = Blob.valueOf('Test Data');  
        lstAttach.add(objAttachs);
        if(lstAttach != null && lstAttach.size() > 0)
        insert lstAttach;
        
        objClickUploadDocs.Click_Attachment_Id__c = lstAttach[0].Id;
        objClickUploadDocs.click_Is_deleted__c = false;
        update objClickUploadDocs;
        objClickUploadDoc.Click_Attachment_Id__c = lstAttach[0].Id;
        objClickUploadDoc.click_Is_deleted__c = false;
        update objClickUploadDoc;
   
        Cookie User_Id = new Cookie('DocPopUp','true',null,72000, false); 
        ApexPages.currentPage().setCookies( new Cookie[]{ User_Id });
        
        List<WLDashboardDocumentController.wrapAttachDocs> lstwrap = new List<WLDashboardDocumentController.wrapAttachDocs>();
        WLDashboardDocumentController.wrapAttachDocs objwrapatt = new WLDashboardDocumentController.wrapAttachDocs();
        objwrapatt.strDocName = 'test';
        objwrapatt.isDeleted= true;
        objwrapatt.attachId= lstAttach[0].id;
        objwrapatt.imgUrl= 'test.com';
        lstwrap.add(objwrapatt);
        
        WLDashboardDocumentController.wrapAttachDocs objwrapattach = new WLDashboardDocumentController.wrapAttachDocs();
        objwrapattach.strDocName = 'test';
        objwrapattach.isDeleted= true;
        objwrapattach.attachId= lstAttach[0].id;
        objwrapattach.imgUrl= 'test.com';
        lstwrap.add(objwrapattach);
        
        WLDashboardDocumentController.WrapperDocuments wrap = new WLDashboardDocumentController.WrapperDocuments();
        wrap.imageURL = 'test';
        wrap.objRequiredDocumnets = objRequiredDocument;
        wrap.attList = lstAttach;
        wrap.lstWrapAttachDocs = lstwrap;
        WLDashboardDocumentController objacfDashboardDocumentController = new WLDashboardDocumentController();
        
        objacfDashboardDocumentController.IndexNo = 0;
        objacfDashboardDocumentController.IndexNo1= 0;
        objacfDashboardDocumentController.strDocumentName= 'test';
        WLDashboardDocumentController.attachBlob(string.valueof(objRequiredDocument.id),'','test','test','test',0);
        objacfDashboardDocumentController.getattach();
        objacfDashboardDocumentController.getdocattach();
        objacfDashboardDocumentController.BindWrapperDocument(objOpportunity.Id);
        objacfDashboardDocumentController.redirect();
        WLDashboardDocumentController.uploadMultipleDoc(1,string.valueof(objOpportunity.Id));
        objacfDashboardDocumentController.fetchDocName();
        objacfDashboardDocumentController.frameURL();
        objacfDashboardDocumentController.addNotes();
        objacfDashboardDocumentController.ResetPopup1();
        objacfDashboardDocumentController.attach=objAttachment;
        objacfDashboardDocumentController.uploadDoc();
        objacfDashboardDocumentController.docattach=objAttachment;
        objacfDashboardDocumentController.UploadDocumentsNotification();
        objacfDashboardDocumentController.previewdoc();
        objacfDashboardDocumentController.DeleteDoc();
    }
    
    private static void LoadData()
    {
        createAccount();
        createUser();
        createOpportunity();
        createDocumentMaster();
        createRequiredDocument();
        createAttachment();
        createClickUploadDocument();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount =    WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        objContact =    WLCommonTrackerClass.createContact(objContact,objAccount);
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
      objDocumentMaster =   WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);
  
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
    
    static testMethod void validateacfDashboardDocumentController12() 
    {
        //test.Starttest();
       
        LoadData();
         acfBank_Detail__c  bank = new acfBank_Detail__c();
           bank.acfBank_Name__c  =  'bank';
           insert bank;
           objRequiredDocument.Bankid__C =bank.ID ;
           objRequiredDocument.EconsentID__C =bank.ID ;
           Update objRequiredDocument ;
        objOpportunity.AccountId =objAccount.id;
        update objOpportunity;
//List<acf_Bank_Template__c>  lstBank = [Select Id ,Body__c,Bank_Name__c from acf_Bank_Template__c
             
             
            
          
            acf_Bank_Template__c  ccc= new acf_Bank_Template__c();
            ccc.Body__c ='';
           ccc.Click_Loans_Bank_Detail__c=    Bank .ID;
           insert ccc;
                    
        Cookie User_Id = new Cookie('DocPopUp','true',null,72000, false); 
        ApexPages.currentPage().setCookies( new Cookie[]{ User_Id });
        WLDashboardDocumentController.WrapperDocuments wrap = new WLDashboardDocumentController.WrapperDocuments();
        wrap.imageURL ='test';
        apexpages.currentpage().getparameters().put('ReqDocsId' , objRequiredDocument.ID);

        WLDashboardDocumentController objacfDashboardDocumentController = new WLDashboardDocumentController();
        
        
        objacfDashboardDocumentController.SendBankNotificationagain();
        objacfDashboardDocumentController.SendBankNotification();
        objacfDashboardDocumentController.SendMailforEconsent();
        objacfDashboardDocumentController.VerifyEconsent();
        objacfDashboardDocumentController.setMyOpportunityIds(objOpportunity.ID);
        String temp =objacfDashboardDocumentController.getMyOpportunityIds();
        //test.Stoptest();
    }
    
}