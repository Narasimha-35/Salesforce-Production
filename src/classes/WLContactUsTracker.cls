@isTest(SeeAllData=TRUE)
private class WLContactUsTracker 
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
    
    WLContactus objacfContactUsController = New WLContactus();
    objacfContactUsController.strPagetitle = 'Test';
    objacfContactUsController.strDescription = 'Test2'; 
    objacfContactUsController.strUserName  ='Testing';    
    objacfContactUsController.strUserEmail ='xyz@gmail.com';
    objacfContactUsController.strUserPhone = '9845781245';
    objacfContactUsController.strQuestion = 'Testing Ankit';
    objacfContactUsController.submitCase();   
 }
 
    static testMethod void contactUs1()
  {
//    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    WLContactus objacfContactUsController = New WLContactus();
    objacfContactUsController.strPagetitle = 'Test3';
    objacfContactUsController.strDescription = 'Test23'; 
    objacfContactUsController.strUserName  =null;
    objacfContactUsController.strUserEmail ='xyz@gmail.com';
    objacfContactUsController.strUserPhone = '9845781245';
    objacfContactUsController.strQuestion = 'Testing Ankit';
    objacfContactUsController.submitCase();   
 }
 
    static testMethod void contactUs2()
  {
//    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    WLContactus objacfContactUsController = New WLContactus();
    objacfContactUsController.strPagetitle = 'Test45';
    objacfContactUsController.strDescription = 'Test25'; 
    objacfContactUsController.strUserName  ='Testing';
    objacfContactUsController.strUserEmail =null;
    objacfContactUsController.strUserPhone = '9845781245';
    objacfContactUsController.strQuestion = 'Testing Ankit';
    objacfContactUsController.submitCase();   
 }
 
    static testMethod void contactUs3()
  {
//    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    WLContactus objacfContactUsController = New WLContactus();
    objacfContactUsController.strPagetitle = 'Test56';
    objacfContactUsController.strDescription = 'Test26'; 
    objacfContactUsController.strUserName  ='Testing';
    objacfContactUsController.strUserEmail ='xyz@gmail.com';
    objacfContactUsController.strUserPhone = null;
    objacfContactUsController.strQuestion = 'Testing Ankit';
    objacfContactUsController.submitCase();   
 }
 
    static testMethod void contactUs4()
  {
//    LoadData();
    PageReference pageRef = new PageReference('http://www.google.com');
    Test.setCurrentPage(pageRef);
    
    WLContactus objacfContactUsController = New WLContactus();
    objacfContactUsController.strPagetitle = 'Test67';
    objacfContactUsController.strDescription = 'Test82'; 
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
      objLead.acfPostcode__c = '201435';
      objLead.Lastname = 'Test';
      objLead = WLCommonTrackerClass.createLead(objLead);      
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
    objAccount.LastName = 'Test';
    objAccount.PersonMobilePhone = '982937743'; 
    objAccount.PersonEmail = 'test@gmail.com';
    insert objAccount;
    objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',null);
    
  }
  
  static void createContact()
  {
    objContact = new Contact();
    objContact.Lastname = 'Test';
    objContact.AccountId= objAccount.id;
    objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    
  }
  static void  createMortgageExpert()
    {
      objMortgageExpert= new MortgageExpert__c();
      objMortgageExpert = WLCommonTrackerClass.createMortgageExpert(objMortgageExpert);
    }
  

       
}