@isTest

        public class acfTriggerOnRequiredDocumnetHandlerTrac
     {
        private static Lead objLead;
        private static User objUser;
        private static Contact objContact;
        private static Account objAccount;
        private static Opportunity objOpp;
        private static click_Applicant__c objClickApp;
        private static Click_Community_Setup__c  cmmset;
         private static Required_Document__c objre;
        private static Document_Master__c objmas;

        static testMethod void validate()
        {
        loadData();
         Document_Master__c masobj=new Document_Master__c();
        masobj.name='test';
        masobj.Click_Community_Setup__c=cmmset.id;
        insert masobj;
        
        Required_Document__c docobj=new Required_Document__c();
        docobj.name='test';
        docobj.acfDocument_Master__c=masobj.id;
        docobj.Click_Applicant__c=objClickApp.id;
        docobj.acf_Is_Identity_Verification_Doc__c=true;
        docobj.acf_Bank_Statement_Doc__c=true;
        docobj.Click_Is_E_consent__c=true;
        //docobj.Click_Is_Note_Type__c='Note';
        insert docobj;
        docobj.acfOpportunity__c=objOpp.id;
        update docobj;
        
        List<Document_Schema__c> lstDoc1 = new List<Document_Schema__c>();
        Document_Schema__c scobj1=new Document_Schema__c();
        scobj1.name='test';
        scobj1.Field_Display_Name__c='test';
        scobj1.Field_Value__c='test';
        scobj1.Click_Loans_Required_Document__c=docobj.id;
        scobj1.Click_Loans_Document_Master__c=objmas.id;
        insert scobj1;
        lstDoc1.add(scobj1);
    }
   
   static testMethod void validate1()
        {
        loadData();
         Document_Master__c masobj=new Document_Master__c();
        masobj.name='test';
        masobj.Click_Community_Setup__c=cmmset.id;
        insert masobj;
        
        List<Document_Schema__c> lstDoc = new List<Document_Schema__c>();
        Document_Schema__c scobj=new Document_Schema__c();
        scobj.name='test';
        scobj.Field_Display_Name__c='test';
        scobj.Field_Value__c='test';
        scobj.Click_Loans_Required_Document__c=objre.id;
        scobj.Click_Loans_Document_Master__c=masobj.id;
        insert scobj;
        lstDoc.add(scobj);
        
        Required_Document__c docobj=new Required_Document__c();
        docobj.name='test';
        docobj.acfDocument_Master__c=masobj.id;
        docobj.Click_Applicant__c=objClickApp.id;
        docobj.acf_Is_Identity_Verification_Doc__c=true;
        docobj.acf_Bank_Statement_Doc__c=true;
        docobj.Click_Is_E_consent__c=true;
        //docobj.Click_Is_Note_Type__c='Note';
        insert docobj;
        docobj.acfOpportunity__c=objOpp.id;
        update docobj;
        
        }
   
 private static void LoadData()
    {
        createLead();
        createAccount();
        createContact();
         createmasterdoc();
        createUser();
        createOpportunity();
        createcommunitysetup();
        createclickApplicant();
         createrequireddoc();
      }

  static void createLead()
    {
        objLead=new Lead();
        objLead=WLCommonTrackerClass.createLead(objLead);
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','88','test@gmail.com',objLead.id);
        objAccount.acfAsset_House_Worth__c=55;
        update objAccount; 
    }
    
    static void createContact()
    {
        objContact = new Contact();
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount );
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createOpportunity()
    {
        objOpp = new Opportunity();
        objOpp = WLCommonTrackerClass.createOpportunity(objOpp,objUser);
     
    }
     static void createclickApplicant()
    {
        objClickApp = new click_Applicant__c();
        objClickApp = WLCommonTrackerClass.createApplicant(objClickApp,objAccount,objOpp);
        objClickApp.acfEconsent__c='I Consent';
        update objClickApp ;
         
    }    
     static void createcommunitysetup()
    {
       cmmset= new Click_Community_Setup__c ();
       cmmset=WLCommonTrackerClass.createcommunitysetup();
    }
    
   static void createmasterdoc()
    {
        objmas= new Document_Master__c(); 
        objmas= WLCommonTrackerClass.createDocumentMaster(objmas);
    }
    
    static void createrequireddoc()
    {
        objre= new Required_Document__c();
        objre= WLCommonTrackerClass.createRequiredDocument(objre,objmas,objOpp);
    }
}