@isTest(SeeAllData = false)
private class WLEditprofileControllerTracker {
    private static User objUser;
    private static Contact objContact;
    private static Lead objLead;
    private static Account objAccount;

    static testMethod void validateacfEditprofileController() 
    {
        LoadData();
        WLEditprofileController objacfEditprofileController = new WLEditprofileController ();
        objacfEditprofileController.strDocumentName = 'test';
        objacfEditprofileController.imgUrl = 'test';
        
        list<Contact> lstcon = new list<Contact>(); 
        Contact objCont = new Contact();
        objCont.LastName = 'test';
        objCont.email = 'swati.sharma@saasfocus.com';
        lstcon.add(objCont);
        
        if(lstcon.size() >0 && lstcon != null){
        insert lstcon;
        }
        objacfEditprofileController.List_con = lstcon;
        objacfEditprofileController.getattach();
        objacfEditprofileController.getdocattach();
        objacfEditprofileController.isValidPassword('swatisharma10');
        objacfEditprofileController.saveMethod();
        objacfEditprofileController.UploadDragableFile();
        objacfEditprofileController.uploadDoc();
        objacfEditprofileController.deleteImage();
        objacfEditprofileController.Cancel();
        objacfEditprofileController.redirect();
    }
    
    
     static testMethod void validateacfEditprofileController1() 
    {
        LoadData();
        document objdoc = new document();
        objdoc.name = 'DefaultChatterImage';
        objdoc.FolderId = UserInfo.getUserId();
        insert objdoc;
        
        WLEditprofileController objacfEditprofileController = new WLEditprofileController ();
        objacfEditprofileController.strDocumentName = 'test';
        objacfEditprofileController.imgUrl = 'test';     
        objacfEditprofileController.getattach();
        objacfEditprofileController.getdocattach();
        objacfEditprofileController.isValidPassword('swatisharma10');
        //objacfEditprofileController.saveMethod();
        objacfEditprofileController.UploadDragableFile();
        objacfEditprofileController.uploadDoc();
        objacfEditprofileController.deleteImage();
        objacfEditprofileController.Cancel();
    }
    
    
    private static void LoadData()
    {
        createlead();
        createAccount();
  //      createContact();
        createUser();
    }
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLead(objLead);
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        objContact.acf_lead__c = objLead.id;
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
  //      objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    
   
    
}