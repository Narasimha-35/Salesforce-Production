@isTest
     
      private class acfJumioBatchClassTracker{
      private static User objUser;
      private static Contact objContact;
      private static Account objAccount;
      private static Opportunity objOpportunity;
      private static Lead objLead;
       
   static testMethod void  myunittest()
     {   
        
            LoadData();
                test.starttest();
           
            objLead = acfCommonTrackerClass.createLeadForPortal(); 
            
            Document_Master__c objDocumentMaster  = new Document_Master__c();
            objDocumentMaster.name = 'test';
            objDocumentMaster.acfActive__c = true;
            objDocumentMaster.acf_Source__c = 'Jumio';
            insert objDocumentMaster;
            
            Required_Document__c objRequiredDocument  = new Required_Document__c();
            objRequiredDocument.name = 'test';
            objRequiredDocument.acfStatus__c = 'Awaited';
            objRequiredDocument.acfOpportunity__c = objOpportunity.id;
            objRequiredDocument.acfDocument_Master__c = objDocumentMaster.id;
            objRequiredDocument.Lead__c = objLead.id;
            objRequiredDocument.acf_Reference_No__c ='S001';
            insert objRequiredDocument;
            List<Required_Document__c > lst=new  List<Required_Document__c >();
            lst.add(objRequiredDocument);
              acf_netverifyResponse_StatusCheck obj = new acf_netverifyResponse_StatusCheck(); 
        obj.status='Pending';
            //   insert obj;
            Jumio_Credentials__c objJumioCredential = new Jumio_Credentials__c(); 
            objJumioCredential .name='Credential';
            objJumioCredential .Active_API_secret__c='test';
            objJumioCredential.EndPoint__c='trte';
            insert objJumioCredential ;
            Database.BatchableContext BC;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators123Pending()); 
          
            
            acfJumioBatchClass objbatch = new acfJumioBatchClass();
            Database.executeBatch(objBatch);  
            //objbatch.execute(bc,lst);
            test.stoptest();
         
            
        }
        
         static testMethod void  myunittest1()
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
        objRequiredDocument.acfStatus__c = 'Awaited';
        objRequiredDocument.acfOpportunity__c = objOpportunity.id;
        objRequiredDocument.acfDocument_Master__c = objDocumentMaster.id;
        objRequiredDocument.Lead__c = objLead.id;
        objRequiredDocument.acf_Reference_No__c ='S001';
        insert objRequiredDocument;
        List<Required_Document__c > lst=new  List<Required_Document__c >();
        lst.add(objRequiredDocument);
        
        acf_netverifyResponse_StatusCheck obj = new acf_netverifyResponse_StatusCheck(); 
        obj.status='DONE';
        //   insert obj;
        Jumio_Credentials__c objJumioCredential = new Jumio_Credentials__c(); 
        objJumioCredential .name='Credential';
        objJumioCredential .Active_API_secret__c='test';
        objJumioCredential.EndPoint__c='trte';
        insert objJumioCredential ;
        Database.BatchableContext BC;
        test.starttest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators123());
        acfJumioBatchClass objbatch = new acfJumioBatchClass();
        Database.executeBatch(objBatch);  
        objbatch.execute(bc,lst);
        test.stoptest();
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