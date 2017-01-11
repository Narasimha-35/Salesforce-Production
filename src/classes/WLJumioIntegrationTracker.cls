@isTest(SeeAllData = true)
private class WLJumioIntegrationTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;

    
    static testMethod void validate() 
    {  
        Lead objLead = new Lead();
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.Status = 'Open';
        objLead.acfOneTimePassword__c = '724715';
        insert objLead;
        
       LoadData();
       Jumio_Credentials__c objJumioCredential = Jumio_Credentials__c.getValues('Credential');
       String strUserName = objJumioCredential.Merchant_API_token__c;
       String strPassword = objJumioCredential.Active_API_secret__c;    
       String strEndPoint = objJumioCredential.EndPoint__c;
       String strAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(strUserName + ':' + strPassword));
       
      
       
       WLJumioIntegration.RootObject objcls = new WLJumioIntegration.RootObject();
       objcls.timestamp = 'test';
       objcls.authorizationToken = 'test';
       objcls.clientRedirectUrl = 'test';
       objcls.jumioIdScanReference = 'test';
       Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
       
       
       WLJumioIntegration obj = new WLJumioIntegration();
       obj.strIframeURL = 'test';
       obj.strLeadId = string.valueof(objLead.id);
       obj.CallToJumio();
       obj.redirectToNextPage();
       Test.stopTest();
    }
    
    private static void LoadData()
    {
        createAccount();
 //       createContact();
        createUser();
        createOpportunity();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommontrackerClass.createAccount(objAccount);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = WLCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
   //     objuser.ContactId = objContact.id;
        objUser = WLCommontrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = WLCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }

    
}