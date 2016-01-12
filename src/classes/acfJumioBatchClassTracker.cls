@isTest(seealldata = true)
private class acfJumioBatchClassTracker{
private static User objUser;
private static Contact objContact;
private static Account objAccount;
private static Opportunity objOpportunity;
private static Lead objLead;


   static testMethod void  myunittest()
     {
        objLead = acfCommonTrackerClass.createLeadForPortal(); 
        LoadData();
       
        Document_Master__c objDocumentMaster  = new Document_Master__c();
        objDocumentMaster.name = 'test';
        objDocumentMaster.acfActive__c = true;
        objDocumentMaster.acf_Source__c = 'Jumio';
        insert objDocumentMaster;
       
        Required_Document__c objRequiredDocument  = new Required_Document__c();
        objRequiredDocument.name = 'test';
        objRequiredDocument.acfStatus__c = 'Pending';
        objRequiredDocument.acfOpportunity__c = objOpportunity.id;
        objRequiredDocument.acfDocument_Master__c = objDocumentMaster.id;
        objRequiredDocument.Lead__c = objLead.id;
        objRequiredDocument.acf_Reference_No__c ='S001';
        insert objRequiredDocument;
        

        
        acf_netverifyResponse_StatusCheck obj = new acf_netverifyResponse_StatusCheck(); 
        acfJumioBatchClass objbatch = new acfJumioBatchClass();
        Database.executeBatch(objBatch);  
        
        }
        
    private static void LoadData()
    {
        createAccount();
        createContact();
        createUser();
        createOpportunity();

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
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    
    
        
  }