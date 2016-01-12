@isTest(seealldata = true)
private class acfBankInformationDetailsBrokerTracker
{
    private static Lead objLead;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
	
     
    
    static testMethod void validateacfBankInformationDetailsController() 
    {
        LoadData();
        
      system.runas(objuser){
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cid',objAccount.id);  
        acfBankInformationDetails_broker.AllAccountsClass wrap = new acfBankInformationDetails_broker.AllAccountsClass();
        wrap.chk_box =true;
        wrap.accountHolder ='test';
        wrap.name = 'test';
        wrap.accountNumber ='1234';
        wrap.id = '001';
        wrap.bsb ='test';
        wrap.balance = '10000';
        wrap.available = '2000';
        
        acfBankInformationDetails_broker.ErrorMessage wrpp = new acfBankInformationDetails_broker.ErrorMessage();
        wrpp.error = 'error';
        wrpp.errorcode = 12345;
        wrpp.user_token = 'te1234';
        
        acfBankInformationDetails_broker.AutoCompleteBanklList('test');
          acfBankInformationDetails_broker.AutoCompleteBanklList('');
          
        
        acfBankInformationDetails_broker objacfbank = new acfBankInformationDetails_broker();
        objacfbank.redirect();
        objacfbank.strParentId = objLead.id;
        objacfbank.strSelectedOption ='test';
        objacfbank.captchaImgUrl ='test';
        
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        //objacfbank.strBankSlugName = 'bank_of_statements';
        objacfbank.BankLogin();
        objacfbank.lstWaterMarkText.add('asdasdas');
        acfbankStatementRequest obj = new acfbankStatementRequest();
        Institution objBankLoginDetail = obj.FetchInstitutionDetails('beyondbank');
        Institution.Credential temp123=new Institution.Credential();
        temp123.name='test';
        temp123.fieldID='asdasda';
        temp123.type='asdasda';
        objacfbank.lstCredentials.add(temp123);
        objacfbank.BankLogin();
          
        objacfbank.SelectBankName(); 
        
        objacfbank.strBankSlugName = 'bank_of_statements';
        objacfbank.SelectBankName(); 
        objacfbank.hidepopup(); 
        objacfbank.BankLogin(); 
        objacfbank.FetchStatements(); 
          /////////////////////////////////////////////
          
          acfBankInformationDetails_broker.AllAccountsClass all_account = new acfBankInformationDetails_broker.AllAccountsClass();
          
          all_account.accountHolder = 'dasdasdasda';
          all_account.name = 'asdasdasda';
          all_account.id = 'dasdasdas';
          all_account.available = 'asdasdasda';
          all_account.balance = 'asdasdasd';
          all_account.bsb = 'asdasdas';
          all_account.accountNumber = 'asdasdasdas';
          all_account.chk_box = true;
          objacfbank.lstBankAccounts.add(all_account);
          objacfbank.FetchStatements(); 
         ///////////////////////////////////////// 
       
        test.stoptest();
        objacfbank.redirectToNextpage(); 
        objacfbank.skipMethod();
        objacfbank.gobackmethod();
        objacfbank.redirect(); 
       // opportunity opptemp=[select id from opportunity limit 1];
       objacfbank.loggedInOppId=objOpportunity.Id;
        
        list<string> strList=new list<string>();
          strList.add('asdasd');
          strList.add('asdasd');
          strList.add('asdasd');
          
        objacfbank.lstUserCredentials=strList;
        objacfbank.lstUserQuearyType=strList;
        objacfbank.lstWaterMarkText=strList;
        
        acfBank_Detail__c objtemp1=new acfBank_Detail__c();
        
        objacfbank.lstbank.add(objtemp1);          
        Institution.Credential objtemp12=new Institution.Credential();
          
        
        }
    }
    
    private static void LoadData()
    {
        createLead();
        createAccount();
        createContact();
        createUser();
        createOpportunity();

    }
    
     static void createLead()
    {
    objLead = acfCommonTrackerClass.createLeadForPortal();
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
        objContact = acfCommontrackerClass.createPartnerContact(objContact,objAccount);
        objcontact.acf_lead__c=objlead.id;
        update objcontact;
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