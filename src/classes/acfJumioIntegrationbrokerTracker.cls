@isTest(SeeAllData = true)
private class acfJumioIntegrationbrokerTracker
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
       
      
       
       acfJumioIntegration_broker.RootObject objcls = new  acfJumioIntegration_broker.RootObject();
       objcls.timestamp = 'test';
       objcls.authorizationToken = 'test';
       objcls.clientRedirectUrl = 'test';
       objcls.jumioIdScanReference = 'test';
       
      
       Account acc = [select id from account where acf_Lead__pc != null limit 1];
       ApexPages.currentPage().getParameters().put('cid',acc.id);
      
       
       acfJumioIntegration_broker obj = new    acfJumioIntegration_broker();
       obj.strIframeURL = 'test';
       obj.strLeadId = string.valueof(objLead.id);
        Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
       try
       {
       obj.CallToJumio();
       }
       catch(Exception e)
       {
       
       }
       obj.redirectToNextPage();
       Test.stopTest();
       acfJumioIntegration_broker.parse('{"var":"data"}');
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
        //objAccount.recordtype.name='Business Account';
        objAccount.name='testname';
        insert objAccount;
    }
    
    static void createContact()
    {
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = acfCommontrackerClass.createPartnerContact(objContact,objAccount);
        
    }
    
    static void createuser()
    {
       objUser = new User();
        objUser.MobilePhone='+611234567890';
        
        objUser.contactId=objContact.Id;
         List<Profile> lstCommUserProfile = [select id,name from profile where name='Customize Partner User' limit 1];
            //List<Account>lstPersonContact = [select id,PersonContactId from Account where id=:ContactId];
            //User objUser = new User();
            objUser.FirstName = 'test';
            objUser.LastName = 'test';
            objUser.Alias  = ('test'+String.valueof(Math.random())).substring(0,5);
            objUser.LocaleSidKey = 'en_AU';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.MobilePhone = '+6145678904';
            objUser.Username = 'test@fakeEmail.com'+objUser.Alias;
            objUser.Email = 'test@fakeEmail.com';
            objUser.ProfileId = lstCommUserProfile[0].id;
            //objUser.ContactId = lstPersonContact[0].PersonContactId;
            objuser.EmailEncodingKey = 'UTF-8';
            objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
            objUser.TimeZoneSidKey = 'Australia/Brisbane';
            objUser.acfIs_Password_Reset__c = true;
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = false;
            objUser.setOptions(dlo);
            insert(objUser);
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }

    
}