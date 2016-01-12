@isTest(SeeAllData =true)
private class WLFAQTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;

    
    static testMethod void validateController() 
    {
    
//        LoadData();
            
        acfCMS_Page__c obj = new acfCMS_Page__c ();
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
        

    }
    
        static testMethod void validateController1() 
    {
    
//        LoadData();
            
        acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj .Name ='ClickFAQ';
        obj .acfDescription__c = 'Ankit Singh';
        obj .acfHeading__c = 'abcd';
        insert obj ;
        
        list<acfFAQ__c>  lstacf = new list<acfFAQ__c>(); 
        acfFAQ__c objf = new acfFAQ__c();
        objf.acfAnswer__c = 'test';
        objf.acfCMSPage__c = obj.id;
        objf.acfFAQType__c = 'Applying for a Loan';
        objf.acfQuestion__c = 'test';
        lstacf.add(objf);
        
        acfFAQ.wrapperFAQType wrap = new acfFAQ.wrapperFAQType();
        acfFAQ.WrapperFAQ wrp = new acfFAQ.WrapperFAQ();
        wrp.id = '1234';
        
        acfFAQ  objFAQ = new acfFAQ();
        objFAQ.strUserName = null;
        objFAQ.strUserPhone = 'test';
        objFAQ.strUserEmail = 'test@test.com';
        objFAQ.strQuestion = 'test';
        objFAQ.strErrorMsg = 'test';
        objFAQ.lstacfFAQ = lstacf; 
        objFAQ.submitCase();
        

    }
    
        static testMethod void validateController2() 
    {
    
//        LoadData();
            
        acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj .Name ='ClickFAQ';
        obj .acfDescription__c = 'Ankit Singh';
        obj .acfHeading__c = 'abcd';
        insert obj ;
        
        list<acfFAQ__c>  lstacf = new list<acfFAQ__c>(); 
        acfFAQ__c objf = new acfFAQ__c();
        objf.acfAnswer__c = 'test';
        objf.acfCMSPage__c = obj.id;
        objf.acfFAQType__c = 'Applying for a Loan';
        objf.acfQuestion__c = 'test';
        lstacf.add(objf);
        
        acfFAQ.wrapperFAQType wrap = new acfFAQ.wrapperFAQType();
        acfFAQ.WrapperFAQ wrp = new acfFAQ.WrapperFAQ();
        wrp.id = '1234';
        
        acfFAQ  objFAQ = new acfFAQ();
        objFAQ.strUserName = 'test';
        objFAQ.strUserPhone = null;
        objFAQ.strUserEmail = 'test@test.com';
        objFAQ.strQuestion = 'test';
        objFAQ.strErrorMsg = 'test';
        objFAQ.lstacfFAQ = lstacf; 
        objFAQ.submitCase();
        

    }
    
        static testMethod void validateController3() 
    {
    
//        LoadData();
            
        acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj .Name ='ClickFAQ';
        obj .acfDescription__c = 'Ankit Singh';
        obj .acfHeading__c = 'abcd';
        insert obj ;
        
        list<acfFAQ__c>  lstacf = new list<acfFAQ__c>(); 
        acfFAQ__c objf = new acfFAQ__c();
        objf.acfAnswer__c = 'test';
        objf.acfCMSPage__c = obj.id;
        objf.acfFAQType__c = 'Applying for a Loan';
        objf.acfQuestion__c = 'test';
        lstacf.add(objf);
        
        WLFAQ.wrapperFAQType wrap = new WLFAQ.wrapperFAQType();
        WLFAQ.WrapperFAQ wrp = new WLFAQ.WrapperFAQ();
        wrp.id = '1234';
        
        WLFAQ  objFAQ = new WLFAQ();
        objFAQ.strUserName = 'test';
        objFAQ.strUserPhone = 'test';
        objFAQ.strUserEmail = null;
        objFAQ.strQuestion = 'test';
        objFAQ.strErrorMsg = 'test';
        objFAQ.lstacfFAQ = lstacf; 
        objFAQ.submitCase();
        

    }
    
        static testMethod void validateController4() 
    {
    
//        LoadData();
            
        acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj .Name ='ClickFAQ';
        obj .acfDescription__c = 'Ankit Singh';
        obj .acfHeading__c = 'abcd';
        insert obj ;
        
        list<acfFAQ__c>  lstacf = new list<acfFAQ__c>(); 
        acfFAQ__c objf = new acfFAQ__c();
        objf.acfAnswer__c = 'test';
        objf.acfCMSPage__c = obj.id;
        objf.acfFAQType__c = 'Applying for a Loan';
        objf.acfQuestion__c = 'test';
        lstacf.add(objf);
        
        WLFAQ.wrapperFAQType wrap = new WLFAQ.wrapperFAQType();
        WLFAQ.WrapperFAQ wrp = new WLFAQ.WrapperFAQ();
        wrp.id = '1234';
        
        WLFAQ  objFAQ = new WLFAQ();
        objFAQ.strUserName = 'test';
        objFAQ.strUserPhone = 'test';
        objFAQ.strUserEmail = 'test@test.com';
        objFAQ.strQuestion = null;
        objFAQ.strErrorMsg = 'test';
        objFAQ.lstacfFAQ = lstacf; 
        objFAQ.submitCase();
        

    }
    
        static testMethod void validateController5() 
    {
    
 //       LoadData();
            
        acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj .Name ='ClickFAQ';
        obj .acfDescription__c = 'Ankit Singh';
        obj .acfHeading__c = 'abcd';
        insert obj ;
        
        list<acfFAQ__c>  lstacf = new list<acfFAQ__c>(); 
        acfFAQ__c objf = new acfFAQ__c();
        objf.acfAnswer__c = 'test';
        objf.acfCMSPage__c = obj.id;
        objf.acfFAQType__c = 'Applying for a Loan';
        objf.acfQuestion__c = 'test';
        lstacf.add(objf);
        
        WLFAQ.wrapperFAQType wrap = new WLFAQ.wrapperFAQType();
        WLFAQ.WrapperFAQ wrp = new WLFAQ.WrapperFAQ();
        wrp.id = '1234';
        
        Lead objL = new Lead();
        objL.FirstName = '+619654922845';
        objL.LastName = '+619654922845';
        objL.Email = 'test@test.com';
        objL.MobilePhone = '+619654922845';
        objL.Status = 'Open';
        objL.acfOneTimePassword__c = '724715';
        
        WLFAQ  objFAQ = new WLFAQ();
        objFAQ.strUserName = 'test@test.com';
        objFAQ.strUserPhone = 'test';
        objFAQ.strUserEmail = 'test@test.com';
        objFAQ.strQuestion = 'test';
        objFAQ.strErrorMsg = null;
        objFAQ.lstacfFAQ = lstacf; 
        objFAQ.submitCase();
        

    }
    
    
     static testMethod void validateController6() 
    {
    
       acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj .Name ='ClickFAQ';
        obj .acfDescription__c = 'Ankit Singh';
        obj .acfHeading__c = 'abcd';
        insert obj ;
        
        list<acfFAQ__c>  lstacf = new list<acfFAQ__c>(); 
        acfFAQ__c objf = new acfFAQ__c();
        objf.acfAnswer__c = 'test';
        objf.acfCMSPage__c = obj.id;
        objf.acfFAQType__c = 'Applying for a Loan';
        objf.acfQuestion__c = 'test';
        lstacf.add(objf);
        
        WLFAQ.wrapperFAQType wrap = new WLFAQ.wrapperFAQType();
        WLFAQ.WrapperFAQ wrp = new WLFAQ.WrapperFAQ();
        wrp.id = '1234';
        
        Lead objL = new Lead();
        objL.FirstName = '+619654922845';
        objL.LastName = '+619654922845';
        objL.Email = 'test@test.com';
        objL.MobilePhone = '+619654922845';
        objL.Status = 'Open';
        objL.acfOneTimePassword__c = '724715';
        
        WLFAQ  objFAQ = new WLFAQ();
        objFAQ.strUserName = 'test@test.com';
        objFAQ.strUserPhone = 'test';
        objFAQ.strUserEmail = 'testtest@test.com';
        objFAQ.strQuestion = 'test';
        objFAQ.strErrorMsg = null;
        objFAQ.lstacfFAQ = lstacf; 
        objFAQ.submitCase();
        

    }
    
    
    private static void LoadData()
    {
        createAccount();
  //      createContact();
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
        objuser.ContactId = objContact.id;
        objUser = WLCommontrackerClass.createuser(objUser);
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = WLCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    

    
}