@isTest(SeeAllData = false)
private class EmailtoAccountOwnerforcommentTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;

  static testMethod void validate() 
   { 
   
   LoadData();
   id currentloggedinUserId = userinfo.getuserid(); 
    
    FeedItem objfeeditem = new FeedItem();
    objfeeditem.Body = 'test';
    objfeeditem.parentId = objAccount.id;
    insert objfeeditem;
    
   FeedComment obj = new FeedComment();
   obj.CommentBody = 'test';
   obj.FeedItemId = objfeeditem.id;
 //  obj.InsertedById = currentloggedinUserId ;
   insert obj;


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