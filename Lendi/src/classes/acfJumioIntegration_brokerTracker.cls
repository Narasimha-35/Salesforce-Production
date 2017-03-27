@isTest
public class acfJumioIntegration_brokerTracker
{

        private static User objUser;
        private static Contact objContact;
        private static Account objAccount;
        private static Account objpersonAccount;
        private static Opportunity objOpp;
        private static Lead objLead;
        private static Id objid;
        private static Jumio_Credentials__c objJum;
        private static Required_Document__c objre;
        private static Document_Master__c objmas;
        private static Click_Community_Setup__c objclcmm;
        
        
        static testMethod void validate1()
       {
    
        LoadData();
         Apexpages.currentpage().getparameters().put('cid',objpersonAccount.Id);
         acfJumioIntegration_broker clsObj = new acfJumioIntegration_broker();
         
         acfJumioIntegration_broker.RootObject objWrapCls = new  acfJumioIntegration_broker.RootObject();
       objWrapCls .timestamp = 'test';
       objWrapCls .authorizationToken = 'test';
       objWrapCls .clientRedirectUrl = 'test';
       objWrapCls .jumioIdScanReference = 'test';
         
         Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators12());
     //  try
     //  {
       clsObj.CallToJumio();
    //   }
     //  catch(Exception e)
     //  {
       
      // }
       Test.stopTest();
         }
         
          static testMethod void validate2()
       {
    
        LoadData();
         Apexpages.currentpage().getparameters().put('cid',objpersonAccount.Id);
         acfJumioIntegration_broker clsObj = new acfJumioIntegration_broker();
          clsObj.redirectToNextPage();
        
         }
         
    private static void LoadData()
      {
        createLead();
        createAccount();
        createContact();
        createmasterdoc();
        createPersonAccount();
        createJumiocred();
        createclickCommunitySetup();
        createPortalUser();
        createCurrentLoggedInLeadId();
        createOpportunity();
        createrequireddoc();
      }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLead(objLead);
    }
    
    static void createJumiocred()
    {
     objJum=new Jumio_Credentials__c();
     objJum.name='Credential';
     objJum.Merchant_API_token__c='test';
     objJum.Active_API_secret__c='test';
     objJum.EndPoint__c='test';
     insert objJum;
    
    }
    
    static void createclickCommunitySetup() 
    {
        objclcmm= new Click_Community_Setup__c();
        objclcmm= ClickCommon.getCommunitySetup('');
    }
    
     static void createCurrentLoggedInLeadId()
     {
     objid=ClickCommon.getCurrentLoggedInLeadId(objUser.Id);
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
        objUser = WLCommonTrackerClass.CreatePortalUser(objpersonAccount.id);
    
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
     static void createmasterdoc()
    {
        objmas= new Document_Master__c(); 
        objmas= WLCommonTrackerClass.createDocumentMaster(objmas);
    }
    
    static void createrequireddoc()
    {
        objre= new Required_Document__c();
        objre= WLCommonTrackerClass.createRequiredDocument(objre,objmas,objOpp);
    }

 }