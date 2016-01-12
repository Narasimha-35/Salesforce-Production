@isTest(SeeAllData=false)
private class acfContactUsControllerTracker 
{
      private static Lead objLead;
      private static User objUser;
      private static Profile objUserProfile;
      private static string USER_PROFILE_NAME = 'Community User';
      private static Contact objContact;
      private static Account objAccount;
      private static MortgageExpert__c objMortgageExpert;       
    
   static testMethod void contactUsController()
  {
    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    acfContactUsController objacfContactUsController = New acfContactUsController();
    objacfContactUsController.strUsrName ='Testing';
    objacfContactUsController.strUsrEmail ='xyz@gmail.com';
    objacfContactUsController.strUsrPhone = '9845781245';
    objacfContactUsController.strQues = 'Testing Ankit';
    objacfContactUsController.CreateCaseMethod();   
 }
 
    static testMethod void contactUs1()
  {
    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    acfContactUsController objacfContactUsController = New acfContactUsController ();
    objacfContactUsController.strUsrName = null;
    objacfContactUsController.strUsrEmail ='xyz@gmail.com';
    objacfContactUsController.strUsrPhone = '9845781245';
    objacfContactUsController.strQues = 'Testing Ankit';
    objacfContactUsController.CreateCaseMethod();   
 }
 
    static testMethod void contactUs2()
  {
    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    acfContactUsController objacfContactUsController = New acfContactUsController();
    objacfContactUsController.strUsrName ='Testing';
    objacfContactUsController.strUsrEmail =null;
    objacfContactUsController.strUsrPhone = '9845781245';
    objacfContactUsController.strQues = 'Testing Ankit';
    objacfContactUsController.CreateCaseMethod();   
 }
 
    static testMethod void contactUs3()
  {
    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    acfContactUsController objacfContactUsController = New acfContactUsController();
    objacfContactUsController.strUsrName ='Testing';
    objacfContactUsController.strUsrEmail ='xyz@gmail.com';
    objacfContactUsController.strUsrPhone = null;
    objacfContactUsController.strQues = 'Testing Ankit';
    objacfContactUsController.CreateCaseMethod();   
 }
 
    static testMethod void contactUs4()
  {
    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    acfContactUsController objacfContactUsController = New acfContactUsController();
    objacfContactUsController.strUsrName ='Testing';
    objacfContactUsController.strUsrEmail ='xyz@gmail.com';
    objacfContactUsController.strUsrPhone = '9845781245';
    objacfContactUsController.strQues = null;
    objacfContactUsController.CreateCaseMethod();   
 }
  
  private static void LoadData()
  {
    createAccount();
    createContact();
    createUser(); 
    CreateLead();
    createMortgageExpert();
    createprofile();
     
  }
  
    static void  CreateLead()
    {
      objLead= new Lead();
      objlead.acfPostcode__c = '201435';
      objLead = acfCommonTrackerClass.createLead(objLead);      
    }
  
  static void createuser()
  {
        objuser= new User();
        objuser = [select id,name from User where name like '%guest%'  limit 1];     
  }
  
  static void createprofile()
  {
    objUserProfile= new Profile();
    objUserProfile=[Select id,Name from Profile where name='Community User' limit 1];
  }
   static void createAccount()
  {
    objAccount= new Account();     
    objAccount = acfCommonTrackerClass.createAccount(objAccount);
    
  }
  
  static void createContact()
  {
    objContact = new Contact();
    objContact = acfCommonTrackerClass.createContact(objContact,objAccount);
    
  }
  static void  createMortgageExpert()
    {
      objMortgageExpert= new MortgageExpert__c();
      objMortgageExpert = acfCommonTrackerClass.createMortgageExpert(objMortgageExpert);
    }
  

       
}