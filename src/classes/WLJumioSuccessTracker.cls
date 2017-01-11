/*
 =============================================================================
    Name                             Date                                version
    =============================================================================
   Ashna                           08/6/2016                                1.0
    =============================================================================
*/

@isTest
private class WLJumioSuccessTracker 
{
        private static User objUser;
        private static Contact objContact;
        private static Account objAccount;
        private static Account objpersonAccount;
        private static Opportunity objOpp;
        private static List<Opportunity> lstOpp;
        private static Lead objLead;
        private static Id objid;
        private static acfTask_Master__c objtask;
        private static Required_Document__c objre;
        private static Document_Master__c objmas;
        private static Click_Community_Setup__c objclcmm;
   
     static testMethod void validate1()
       {
        Loaddata(); 
        system.runAs(objUser)
        {
        WLJumioSuccess wljumsucc=new WLJumioSuccess();
        wljumsucc.UpdateSuccessOnLead();
         lstopp=new List<Opportunity>();
         lstopp.add(objOpp);
        wljumsucc.retUrlPage='test';
        wljumsucc.siteURL='test';
        wljumsucc.WLJumioSuccess();
        objclcmm=new Click_Community_Setup__c();
        ApexPages.currentPage().getParameters().put('id',objOpp.Id); 
        wljumsucc.UpdateSuccessOnLead();
        ApexPages.currentPage().getParameters().put('Docid',objre.Id); 
       
        wljumsucc.UpdateSuccessOnLead();
        }
       }
        
        static testMethod void validate2()
       {
        Loaddata(); 
        //system.runAs(objUser)
       // {
        WLJumioSuccess wljumsucc=new WLJumioSuccess();
        ApexPages.currentPage().getParameters().put('id',objOpp.Id); 
        wljumsucc.UpdateSuccessOnLead();
        ApexPages.currentPage().getParameters().put('Docid',objre.Id); 
        wljumsucc.UpdateSuccessOnLead();
       // }
       }
     
     private static void LoadData()
      {
        createLead();
        createAccount();
        createContact();
        createmasterdoc();
        createtask();
        createclickCommunitySetup();
        createPersonAccount();
        createPortalUser();
        createOpportunity();
        createrequireddoc();
        
      }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
     static void createtask()
    {
        objtask= new acfTask_Master__c ();
        objtask= WLCommonTrackerClass.createtask(objtask);
    }
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLead(objLead);
    }
    
    static void createclickCommunitySetup() 
    {
        objclcmm= new Click_Community_Setup__c();
        objclcmm.Click_IsActive__c=true;
        objclcmm.Click_Page_Prefix__c='test';
        insert objclcmm;
        objclcmm= ClickCommon.getCommunitySetup('');
        
    }
    
    static void createContact()
    {
        objContact = new Contact();
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
    static void createPersonAccount()
    {
        objpersonAccount= new Account();
        objpersonAccount=WLCommonTrackerClass.CreatePersonAccount('Fname','LName','strPhone','strLead12Email@gmail.com',objLead.Id);
    }
    static void createPortalUser()
    {
        objUser = new User();
        objUser.ContactId = objContact.id;
        //objUser.IsActive = true;
        objUser = WLCommonTrackerClass.CreatePortalUser(objpersonAccount.id);
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
        objre.acf_Is_Identity_Verification_Doc__c=true;
        update objre;
        
    }
    
    static void createOpportunity()
    {
        objOpp= new Opportunity();
        objOpp.AccountId =objuser.AccountId;
        String recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Click Refi').getRecordTypeId();
        objOpp.recordtypeid =recordtypeid;
        objOpp.name = 'test';
        objOpp.Stagename = 'Settlement';
        objOpp.CloseDate = System.today();
        objOpp=WLCommonTrackerClass.createOpportunity(objOpp,objUser);
    }

 }