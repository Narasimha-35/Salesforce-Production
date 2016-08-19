/*
 =============================================================================
    Name                             Date                                version
    =============================================================================
   Ashna                           14/6/2016                                1.0
    =============================================================================
*/
@isTest
public class WLBankInformationDetailsTracker
{
        Public static string strEndpoint;
        Public static string strApiKey;
        private static User objUser;
        private static Account objpersonAccount;
        private static Opportunity objOpp;
        private static Lead objLead;
         private static Id objid;
        private static acfBank_Statement_Credential__c objBankstmtCredential;
        private static acfBank_Detail__c objBank ;
        private static acfBank_Information__c objBankQuestions;
         private static Click_Community_Setup__c objclcmm;
         private static Required_Document__c objre;
         private static Document_Master__c objmas;
         public list<string> lstUserCredentials;
         public list<string> lstUserQuearyType;

    static testMethod void validate()
    {
         
        loaddata();
        Apexpages.currentpage().getparameters().put('id',objOpp.id);
       
        WLBankInformationDetails objwlbankinfo=new WLBankInformationDetails();
       WLBankInformationDetails.AutoCompleteBanklList('test');
         
        objBankstmtCredential =new acfBank_Statement_Credential__c();
        objBankstmtCredential.name='Credential';
        objBankstmtCredential.acfEndPoint_Url__c='https://bankstatements.com.au/api/v1/';
        objBankstmtCredential.acfX_API_KEY__c='FCWFJVDVVQYY7Z4TYAZAH7WWVLVSI1OO8BBTRHRO';
        insert objBankstmtCredential;  
      
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators12());
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators2());
        system.debug('###123'+ new MockHttpResponseGenerators12());
          
        objwlbankinfo.strBankSlugName='HSBC';
        WLbankStatementRequest objrequest=new WLbankStatementRequest();
        objwlbankinfo.SelectBankName();
        
        WLBankInformationDetails.ErrorMessage clsobjerror=new WLBankInformationDetails.ErrorMessage();
        clsobjerror.error='error';
        clsobjerror.errorcode=123;
        clsobjerror.user_token='usertoken';
        
        WLBankInformationDetails.AllAccountsClass clsobjacc=new WLBankInformationDetails.AllAccountsClass();
       List<WLBankInformationDetails.AllAccountsClass> lstobjacc=new List<WLBankInformationDetails.AllAccountsClass>();
        clsobjacc.chk_box=true;
        clsobjacc.accountHolder='testholder';
        clsobjacc.name='test'; 
        clsobjacc.accountNumber='123456'; 
        clsobjacc.id='123';
        clsobjacc.bsb='test';
        clsobjacc.balance='987654';  
        clsobjacc.available='testavl';  
        lstobjacc.add(clsobjacc);
        //lstobjacc.lstBankAccounts = lstobjacc;
        system.runas(objuser)
     {
        objwlbankinfo.gobackmethod();
        objwlbankinfo.redirect();
        objwlbankinfo.skipMethod();
        objid=ClickCommon.getCurrentLoggedInLeadId(objLead.id);
        objwlbankinfo.FetchStatements();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators2());
        objwlbankinfo.BankLogin();
        objwlbankinfo.hidepopup();
         Apexpages.currentpage().getparameters().put('Docid',objre.id);
        objwlbankinfo.redirectToNextpage();
        test.stoptest();
        
   }
    }
    
    
     static testMethod void validate1()
    {
     
        loaddata1();
        
        WLBankInformationDetails objwlbankinfo=new WLBankInformationDetails();
         
         objwlbankinfo.SelectBankName();
        WLBankInformationDetails.AutoCompleteBanklList('test');
        
        objBankstmtCredential =new acfBank_Statement_Credential__c();
        objBankstmtCredential.name='Credential';
        objBankstmtCredential.acfEndPoint_Url__c='https://bankstatements.com.au/api/v1/';
        objBankstmtCredential.acfX_API_KEY__c='FCWFJVDVVQYY7Z4TYAZAH7WWVLVSI1OO8BBTRHRO';
        insert objBankstmtCredential;  
          
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators12());
        
        objwlbankinfo.strBankSlugName='HSBC';
        WLbankStatementRequest objrequest=new WLbankStatementRequest();
        objwlbankinfo.SelectBankName();
       
        WLBankInformationDetails.ErrorMessage clsobjerror=new WLBankInformationDetails.ErrorMessage();
        clsobjerror.error='error';
        clsobjerror.errorcode=123;
        clsobjerror.user_token='usertoken';
        
        WLBankInformationDetails.AllAccountsClass clsobjacc=new WLBankInformationDetails.AllAccountsClass();
        clsobjacc.chk_box=true;
        clsobjacc.accountHolder='testholder';
        clsobjacc.name='test'; 
        clsobjacc.accountNumber='123456'; 
        clsobjacc.id='123';
        clsobjacc.bsb='test';
        clsobjacc.balance='987654';  
        clsobjacc.available='testavl';  

        system.runas(objuser)
     {
        objwlbankinfo.gobackmethod();
        objwlbankinfo.redirect();
        objwlbankinfo.skipMethod();
        objid=ClickCommon.getCurrentLoggedInLeadId(objLead.id);
        objwlbankinfo.FetchStatements();
        objwlbankinfo.BankLogin();
        objwlbankinfo.hidepopup();
        objwlbankinfo.strParentId = objLead.id;
        objwlbankinfo.redirectToNextpage();
        test.stoptest();
       
   }
    }

         static testMethod void validate2()
    {
     
        loaddata();
        WLBankInformationDetails objwlbankinfo=new WLBankInformationDetails();
        objwlbankinfo.strBankName = 'bank_of_statements';
       WLBankInformationDetails.AutoCompleteBanklList('test');
        
        objBankstmtCredential =new acfBank_Statement_Credential__c();
        objBankstmtCredential.name='Credential';
        objBankstmtCredential.acfEndPoint_Url__c='https://bankstatements.com.au/api/v1/';
        objBankstmtCredential.acfX_API_KEY__c='FCWFJVDVVQYY7Z4TYAZAH7WWVLVSI1OO8BBTRHRO';
        insert objBankstmtCredential;  
        
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators12());
       
        objwlbankinfo.strBankSlugName='bank_of_statements';
        WLbankStatementRequest objrequest=new WLbankStatementRequest();
        objwlbankinfo.SelectBankName();
        
        WLBankInformationDetails.ErrorMessage clsobjerror=new WLBankInformationDetails.ErrorMessage();
        clsobjerror.error='error';
        clsobjerror.errorcode=123;
        clsobjerror.user_token='usertoken';
        
        WLBankInformationDetails.AllAccountsClass clsobjacc=new WLBankInformationDetails.AllAccountsClass();
        clsobjacc.chk_box=true;
        clsobjacc.accountHolder='testholder';
        clsobjacc.name='test'; 
        clsobjacc.accountNumber='123456'; 
        clsobjacc.id='123';
        clsobjacc.bsb='test';
        clsobjacc.balance='987654';  
        clsobjacc.available='testavl';  

        system.runas(objuser)
     {
        objwlbankinfo.gobackmethod();
        objwlbankinfo.redirect();
        objwlbankinfo.skipMethod();
        objid=ClickCommon.getCurrentLoggedInLeadId(objLead.id);
        objwlbankinfo.FetchStatements();
        objwlbankinfo.BankLogin();
        objwlbankinfo.hidepopup();
        objwlbankinfo.redirectToNextpage();
        test.stoptest();
        
   }
    }

    public static void loaddata()
    {
        createclickCommunitySetup();
        createLead();
        createPersonAccount();
        createPortalUser();
        createOpportunity();
          createBankQuestions();
        createBankDetail();
        createmasterdoc();
        createrequireddoc();
       
    }
    
    public static void loaddata1()
    {
       
        createLead();
        createPersonAccount();
        createPortalUser();
        createOpportunity();
        createBankDetail();
        createBankQuestions() ;
        createmasterdoc();
        createrequireddoc();
       
    }
    
    
    static void createclickCommunitySetup() 
    {
        objclcmm= new Click_Community_Setup__c();
         objclcmm= WLCommonTrackerClass.createcommunitysetup();
        objclcmm= ClickCommon.getCommunitySetup('');
        system.debug('setup1234'+objclcmm);
    }
    
    static void createBankQuestions() 
    {
        objBankQuestions=new acfBank_Information__c();
        objBankQuestions=WLCommonTrackerClass.createBankQuestions(); 
    }
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLead(objLead); 
    }
    
    static void createBankDetail()
    {
        objBank = new acfBank_Detail__c();
        objBank =  WLCommonTrackerClass.createBankDetail();
    }
    
    static void createPersonAccount()
    {
        objpersonAccount= new Account();
        objpersonAccount=WLCommonTrackerClass.CreatePersonAccount('Fname','LName','strPhone','strLead12Email@gmail.com',objLead.Id);
    }
    
    static void createPortalUser()
    {
        objUser = new User();
        objUser = WLCommonTrackerClass.CreatePortalUser(objpersonAccount.id);
    }
    
    static void createOpportunity()
    {
        objOpp= new Opportunity();
        objOpp.AccountId =objuser.AccountId;
        objOpp.name = 'test';
        objOpp.Stagename = 'Settlement';
        objOpp=WLCommonTrackerClass.createOpportunity(objOpp,objUser);
    }
    
    static void createrequireddoc()
    {
        objre= new Required_Document__c();
        objre= WLCommonTrackerClass.createRequiredDocument(objre,objmas,objOpp);
        objre.Lead__c = objLead .id;
       update objre;
    }
    
     static void createmasterdoc()
    {
        objmas= new Document_Master__c(); 
        objmas= WLCommonTrackerClass.createDocumentMaster(objmas);
    }
}