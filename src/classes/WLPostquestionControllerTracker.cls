@isTest(seeAllData=true)
private class WLPostquestionControllerTracker{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    
    static testMethod void validateController(){
            LoadData();
            WLPostquestionController objpost = new WLPostquestionController();
            objpost.isError = true;
            objpost.ResetPopup();
            objpost.postQuery();
         }     
         
    static testMethod void validateController2(){
            LoadData();
            WLPostquestionController objpost = new WLPostquestionController();
            objpost.isError = true;       
            objpost.ResetPopup();
            objpost.strPost = null;
            objpost.postQuery();
        }
    
    private static void LoadData(){
            createAccount();
  //          createContact();
            createUser();
            createOpportunity();
    }
    
    static void createAccount(){
            objAccount = new Account();
            objAccount = acfCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',null);
    }
    
    static void createContact(){
            objContact = new Contact();
            objContact = WLCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createUser(){
            objUser = new User();
  //          objUser.Contactid = objContact.id;
            objUser = WLCommontrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createOpportunity(){
            objOpportunity = new Opportunity();
            objOpportunity.acfBankdetailStatus__c = 'Skipped';
            objOpportunity = WLCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
/*        acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj .Name ='ClickFAQ';
        obj .acfDescription__c = 'Ankit Singh';
        obj .acfHeading__c = 'abcd';
        insert obj ;
        
        list<acfFAQ__c>  lstacf = new list<acfFAQ__c>(); 
        acfFAQ__c objf = new acfFAQ__c();
        objf.acfAnswer__c  = 'test';
        objf.acfCMSPage__c = obj.id;
        objf.acfFAQType__c = 'Applying for a Loan';
        objf.acfQuestion__c = 'test';
        lstacf.add(objf);
        
        acfFAQ.wrapperFAQType wrap = new acfFAQ.wrapperFAQType();
        acfFAQ.WrapperFAQ wrp = new acfFAQ.WrapperFAQ();
        wrp.id = '1234';
        
        acfFAQ  objFAQ = new acfFAQ();
        objFAQ.strUserName = 'test';
        objFAQ.strUserPhone = 'test';
        objFAQ.strUserEmail = 'test@test.com';
        objFAQ.strQuestion = 'test';
        objFAQ.strErrorMsg = 'test';
        objFAQ.lstacfFAQ = lstacf; 
        objFAQ.submitCase();
        
    
    }*/


}