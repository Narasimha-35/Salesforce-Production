@isTest(SeeAllData = true)
private class WLJumioSuccessTracker 
{
    private static User ObjUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static Lead objLead;
    private static Document_Master__c objDocumentMaster;
    private static Required_Document__c objRequiredDocument;
    
    static testMethod void validate() 
    {             
        LoadData();
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        t.acf_Is_Upload_Identity_Verification__c = true;
        insert t;
        
        WLJumioSuccess obj = new WLJumioSuccess();
        obj.retUrlPage = 'test';
        obj.UpdateSuccessOnLead();
        obj.WLJumioSuccess();
    }
    
     static testMethod void validate1() 
    {             
   /*     LoadData1();
        objLead.acf_Contact__c = objUser.ContactId;
        update objLead;
        
        objRequiredDocument.Lead__c = objLead.id;
        update objRequiredDocument;      */
        
   
        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        t.acf_Is_Upload_Identity_Verification__c = true;
        insert t;
        
        WLJumioSuccess obj = new WLJumioSuccess();
        obj.retUrlPage = 'test';
        obj.UpdateSuccessOnLead();
        obj.WLJumioSuccess();
    }
      
    private static void LoadData()
    {
        createLead();
        createAccount();             
        createContact();    
        createUser();
        createOpportunity();
        createDocumentMaster();
        createRequiredDocument();
    }
    
    private static void LoadData1()
    {
                   
 //     createContact();    
        createUser();
        createLead();
        createAccount();  
        createOpportunity();
        createDocumentMaster();
        createRequiredDocument();
    }
        
    static void createAccount()
    {
       objAccount = new Account();
       objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommontrackerClass.createLeadForPortal();
        system.debug('objLead************'+objLead);
    }
    static void createContact()
    {
        objContact = new Contact();
        objContact =    WLCommonTrackerClass.createContact(objContact,objAccount);        
    }
    
    static void createuser()
    {
        objUser = new User();
        objUser =   WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createOpportunity()
    {
        objOpportunity = new Opportunity();
        list<Account> lstAccount = [select id from Account where personContactId =: objUser.ContactId limit 1];
        objOpportunity.AccountId = lstAccount[0].id;
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
        objRequiredDocument.acfOpportunity__c = objOpportunity.id;
        objRequiredDocument.acf_Bank_Statement_Doc__c=true;
        objRequiredDocument.acf_Is_Identity_Verification_Doc__c=true;     
        objRequiredDocument =   WLCommonTrackerClass.createRequiredDocument(objRequiredDocument,objDocumentMaster,objOpportunity);
    }
    
    
}