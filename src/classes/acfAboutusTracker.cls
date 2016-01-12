@isTest(SeeAllData = false)
private class acfAboutusTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;


    
    static testMethod void validateacfDashboardDocumentController() 
    { 
        LoadData();
        acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj .Name ='clickaboutus';
        obj .acfDescription__c = 'Ankit Singh';
        obj .acfHeading__c = 'abcd';
        insert obj ;

        acfContentManagementSystem__c   objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'ClickHome';
        objContentManagementSystem.acfSectionName__c = 'Footer Links';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;
        insert objContentManagementSystem;
        
        acfAboutus objabout = new acfAboutus();
        

    }
    
    private static void LoadData()
    {
        createAccount();
        createContact();
        createUser();

    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = acfCommontrackerClass.createAccount(objAccount);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = acfCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = acfCommontrackerClass.createuser(objUser);
    }
    

    

    
}