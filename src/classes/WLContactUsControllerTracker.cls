@isTest
public class WLContactUsControllerTracker
{
    private static User objUser;
    private static User objUser1;
    private static Lead objLead;
    private static Contact objContact;
    private static Account objAccount;
    private static Click_Community_Setup__c objclcmm;
    private static Account objPersonAccount;
    private static Opportunity objOpportunity ;
    private static MortgageExpert__c objMortage;
   
    static testMethod void validate()
    {
        LoadData1();
        PageReference pageRef =new PageReference('https://www.google.co.in/');
        Test.setCurrentPage(pageRef);
        WLContactUsController objWLContactUsController =new WLContactUsController();
        objWLContactUsController.strUsrName = 'ashna';
        objWLContactUsController.strUsrEmail = 'swati.sharma@saasfocus.com';
        objWLContactUsController.strUsrPhone = '+619654922845';
        objWLContactUsController.strQues = 'what is this';
        objWLContactUsController.CreateCaseMethod();
       
    }
    
    static testMethod void validate1()
    {
        LoadDatavalidate1();
        PageReference pageRef =new PageReference('https://www.google.co.in/');
        Test.setCurrentPage(pageRef);
        WLContactUsController objWLContactUsController =new WLContactUsController();
        objWLContactUsController.strUsrName = 'ashna';
        objWLContactUsController.strUsrEmail = 'test@fakeEmail.com';
        objWLContactUsController.strUsrPhone = '+619654922845';
        objWLContactUsController.strQues = 'what is this';
        objWLContactUsController.CreateCaseMethod();
       
    }
     static testMethod void validate1a()
    {
        PageReference pageRef =new PageReference('https://www.google.co.in/');
        Test.setCurrentPage(pageRef);
        WLContactUsController objWLContactUsController =new WLContactUsController();
        objWLContactUsController.strUsrName = '';
        objWLContactUsController.strUsrEmail = 'test@fakeEmail.com';
        objWLContactUsController.strUsrPhone = '+619654922845';
        objWLContactUsController.strQues = 'what is this';
        objWLContactUsController.CreateCaseMethod();
       
    }
    
    static testMethod void validate1c()
    {
        PageReference pageRef =new PageReference('https://www.google.co.in/');
        Test.setCurrentPage(pageRef);
        WLContactUsController objWLContactUsController =new WLContactUsController();
        objWLContactUsController.strUsrName = 'ashna';
        objWLContactUsController.strUsrEmail = '';
        objWLContactUsController.strUsrPhone = '+619654922845';
        objWLContactUsController.strQues = 'what is this';
        objWLContactUsController.CreateCaseMethod(); 
    }
    
    static testMethod void validate1d()
    {
        PageReference pageRef =new PageReference('https://www.google.co.in/');
        Test.setCurrentPage(pageRef);
        WLContactUsController objWLContactUsController =new WLContactUsController();
        objWLContactUsController.strUsrName = 'ashna';
        objWLContactUsController.strUsrEmail = 'test@fakeEmail.com';
        objWLContactUsController.strUsrPhone = '';
        objWLContactUsController.strQues = 'what is this';
        objWLContactUsController.CreateCaseMethod();
       
    }
    static testMethod void validate1e()
    {
        PageReference pageRef =new PageReference('https://www.google.co.in/');
        Test.setCurrentPage(pageRef);
        WLContactUsController objWLContactUsController =new WLContactUsController();
        objWLContactUsController.strUsrName = 'ashna';
        objWLContactUsController.strUsrEmail = 'test@fakeEmail.com';
        objWLContactUsController.strUsrPhone = '+619654922845';
        objWLContactUsController.strQues = '';
        objWLContactUsController.CreateCaseMethod();
       
    }
    
   static testMethod void validate2()
    {
        createLead1();
        createclickCommunitySetup2();
        Schema.DescribeSObjectResult leadRT = Schema.SObjectType.Lead;
        PageReference pageRef =new PageReference('https://www.google.co.in/');
        Test.setCurrentPage(pageRef);
        WLContactUsController objWLContactUsController =new WLContactUsController();
        objWLContactUsController.strUsrName = 'ashna';
        objWLContactUsController.strUsrEmail = 'test@fakeEmail.com';
        objWLContactUsController.strUsrPhone = '+619654922845';
        objWLContactUsController.strQues = 'what is this';
        objWLContactUsController.CreateCaseMethod(); 
    }  
    
     private static void LoadDatavalidate1()
    {
        createclickCommunitySetup1() ;
        createAccount();
        createuser();  
    }
    
     static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
        objAccount.PersonEmail ='test@fakeEmail.com';
        update objAccount;
    }
    
   static void createuser()
    {
        objUser1 = new User();
        objUser1 = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    private static void LoadData2()
    {
        createclickCommunitySetup2() ;
        createLead2();
 
    }
      
      static void createLead2()
    {
    objLead=new Lead();
    objLead=WLCommonTrackerClass.createLead(objLead);
    }
    
    static void createAccount2()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createContact2()
    {
        objContact = new Contact();
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
      static void createclickCommunitySetup2() 
    {
        objclcmm= new Click_Community_Setup__c();
        objclcmm= ClickCommon.getCommunitySetup('test');
    }
    
      static void createMortgage2() 
    {
        objMortage= new MortgageExpert__c ();
        objMortage= WLCommonTrackerClass.createMortgageExpert(objMortage);
    }
    
     private static void LoadData1()
    {
        createclickCommunitySetup1() ;
        createLead1();
        createAccount1();
        createpersonAccount1();
        createuser1();
        createOpportunity1(); 
        createMortgage1();    
    }
    
    static void createLead1()
    {
    objLead=new Lead();
    objLead=WLCommonTrackerClass.createLead(objLead);
    }
    
    static void createAccount1()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createpersonAccount1()
    {
        objPersonAccount=new Account();
        objPersonAccount=WLCommonTrackerClass.CreatePersonAccount('FName','LName','strPhone','strLeadEmail@gmail.com',objLead.Id);
    }
    
    static void createContact1()
    {
        objContact = new Contact();
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
     static void createuser1()
    {
        objUser = new User();
        objUser.IsActive =true;
        objUser = WLCommonTrackerClass.CreatePortalUser(objPersonAccount.id);
    }
    
    static void createOpportunity1()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity =  WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
    }
    
      static void createclickCommunitySetup1() 
    {
        objclcmm= new Click_Community_Setup__c();
        objclcmm= ClickCommon.getCommunitySetup('null');
    }
    
      static void createMortgage1() 
    {
        objMortage= new MortgageExpert__c ();
        objMortage= WLCommonTrackerClass.createMortgageExpert(objMortage);
    }

}