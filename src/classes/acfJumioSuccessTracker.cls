@isTest
private class acfJumioSuccessTracker 
{
    private static User lstUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static Lead objLead;
    private static Document_Master__c objDocumentMaster;
    private static Required_Document__c objRequired_Document;
    
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
        
        acfJumioSuccess obj = new acfJumioSuccess();
        obj.retUrlPage = 'test';
        obj.UpdateSuccessOnLead();
        obj.acfJumioSuccess();
        


    }
    
     static testMethod void validate2() 
    {    
           
        LoadData();
        system.runAs(lstUser)
        {
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        t.acf_Is_Upload_Identity_Verification__c = true;
        insert t;
        
        acfJumioSuccess obj = new acfJumioSuccess();
        obj.retUrlPage = 'test';
        obj.UpdateSuccessOnLead();
        obj.acfJumioSuccess();
        }


    }
    
    
        static testMethod void validate1() 
    {   
           
        LoadData1();
        

        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        t.acf_Is_Upload_Identity_Verification__c = true;
        insert t;
        
        acfJumioSuccess obj = new acfJumioSuccess();
        obj.retUrlPage = 'test';
        obj.UpdateSuccessOnLead();
        obj.acfJumioSuccess();


    }

    
    private static void LoadData()
    {
        createAccount();
        
        createUser();
        createContact();
        createLead();
        createOpportunity();
        createDocumentMaster();
        createRequiredDocument();
    }
    
        private static void LoadData1()
    {
        createAccount();
        //createContact();
        createUser();
        createContact();
 //       createOpportunity();
    }
    
    
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = acfCommontrackerClass.createAccount(objAccount);
    }
    
    static void createLead()
    {
      objLead = new Lead();
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.Status = 'Open';
       objLead.acf_Contact__c = lstUser.ContactId;
        objLead.acfOneTimePassword__c = '724715';
        objLead.acfIs_Identity_Document_Submitted__c = false;
        insert objLead; 
    }
    static void createContact()
    {
         
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        objContact.acf_lead__c = objLead.id;
        objContact = acfCommontrackerClass.createContact(objContact,objAccount);
        
        
    }
    
    static void createuser()
    {
     // lstUser.ContactId=objContact.Id;
     // lstUser = [select id,AccountId, ContactId from User where Id =: UserInfo.getUserId() and IsActive = true];
      objLead=acfCommonTrackerClass.createLeadForPortal();
        lstUser = new User();
      //  objuser = [select Id,Name,IsActive,Email,MobilePhone,ContactId,AccountId from user where id=:userInfo.getUserId() limit 1];
        objAccount=acfCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        lstUser=acfCommonTrackerClass.CreatePortalUser(objAccount.id);
        system.debug(lstuser.AccountId+'------------------------------------');
      
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,lstUser);
    }
    static void createDocumentMaster()
    {
     objDocumentMaster=acfCommontrackerClass.createDocumentMaster(objDocumentMaster);
    }
    static void createRequiredDocument()
    {
    objRequired_Document=new Required_Document__c();
    objRequired_Document.acf_Is_Identity_Verification_Doc__c=true;
    objRequired_Document.Lead__c=objLead.Id;
    objRequired_Document=acfCommontrackerClass.createRequiredDocument(objRequired_Document,objDocumentMaster,objOpportunity);
    }
    
    
}