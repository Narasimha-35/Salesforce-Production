@isTest(SeeAllData=false)
private class acfContactUsTracker 
{
      private static Lead objLead;
      private static User objUser;
      private static Profile objUserProfile;
      private static string USER_PROFILE_NAME = 'Community User';
      private static Contact objContact;
      private static Account objAccount;
      private static MortgageExpert__c objMortgageExpert;       
    
   static testMethod void contactUs()
  {
    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    acfContactus objacfContactUsController = New acfContactus();
    objacfContactUsController.strUserName  ='Testing';
    objacfContactUsController.strUserEmail ='xyz@gmail.com';
    objacfContactUsController.strUserPhone = '9845781245';
    objacfContactUsController.strQuestion = 'Testing Ankit';
    objacfContactUsController.submitCase();   
 }
 
    static testMethod void contactUs1()
  {
    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    acfContactus objacfContactUsController = New acfContactus();
    objacfContactUsController.strUserName  =null;
    objacfContactUsController.strUserEmail ='xyz@gmail.com';
    objacfContactUsController.strUserPhone = '9845781245';
    objacfContactUsController.strQuestion = 'Testing Ankit';
    objacfContactUsController.submitCase();   
 }
 
    static testMethod void contactUs2()
  {
    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    acfContactus objacfContactUsController = New acfContactus();
    objacfContactUsController.strUserName  ='Testing';
    objacfContactUsController.strUserEmail =null;
    objacfContactUsController.strUserPhone = '9845781245';
    objacfContactUsController.strQuestion = 'Testing Ankit';
    objacfContactUsController.submitCase();   
 }
 
    static testMethod void contactUs3()
  {
    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    acfContactus objacfContactUsController = New acfContactus();
    objacfContactUsController.strUserName  ='Testing';
    objacfContactUsController.strUserEmail ='xyz@gmail.com';
    objacfContactUsController.strUserPhone = null;
    objacfContactUsController.strQuestion = 'Testing Ankit';
    objacfContactUsController.submitCase();   
 }
 
    static testMethod void contactUs4()
  {
    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    acfContactus objacfContactUsController = New acfContactus();
    objacfContactUsController.strUserName  ='Testing';
    objacfContactUsController.strUserEmail ='xyz@gmail.com';
    objacfContactUsController.strUserPhone = '9845781245';
    objacfContactUsController.strQuestion = null;
    objacfContactUsController.submitCase();   
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