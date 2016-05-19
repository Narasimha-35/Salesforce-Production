@isTest

private class acfTriggerOnOpportunityHandlerTracker
{

    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    
    static testMethod void validate()
    {
       LoadData();
        List<Opportunity> lstOpp = new List<Opportunity>();
        
          acfTriggerOnOpportunityHandler triggerOnOpp = new acfTriggerOnOpportunityHandler();
      //    objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
        
          
        objOpportunity = new Opportunity();
        objOpportunity.AccountId = objuser.AccountId;
        objOpportunity.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Application Taken';
        objOpportunity.CloseDate = System.today();
        objOpportunity.acfAsset_House_Worth__c = 200000;
        lstOpp.add(objOpportunity);
        insert lstOpp;
     //   triggerOnOpp.OnAfterInsert(lstOpp);
        lstOpp[0].name ='test27';
        update lstOpp;
          map<id,opportunity> mapOpp = new map<id,opportunity>();
        
        triggerOnOpp.onAfterUpdate(lstOpp,mapOpp);
    
    }
    
    private static void LoadData()
    {
        createAccount();
        createContact();
        createUser();
      //  createOpportunity();
        
    }  
     
        
    static void createAccount()
    {
        objAccount = new Account();
        objAccount.acfApproximately_how_much_is_your_house__pc = 10000000;
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
   
  

}