@isTest
public with sharing class DealIQTriggerHandlerTracker {
    private static Lead objLead;
        private static User objUser;
        private static Contact objContact;
        private static Account objAccount;
        private static Opportunity objOpp;
        private static click_Applicant__c objClickApp;
        private static Click_Community_Setup__c  cmmset;
        private static Required_Document__c objre;
        private static Document_Master__c objmas;

        static testMethod void validate(){
            loadData();
            ACFSwitch__c acfswitch = new ACFSwitch__c();
            acfswitch.Trigger_Switch_DealIQCondition__c = true;
            insert acfswitch;
            
            Document_Master__c masobj=new Document_Master__c();
            masobj.name='test';
            masobj.Click_Community_Setup__c=cmmset.id;
            insert masobj;
            
            Global_DealIQ_Condition__c dealRule = new Global_DealIQ_Condition__c();
            dealRule.Name =  'Test';
            dealRule.Document_Master__c = masobj.id;
            insert dealRule;
            
            acfDealIQ_Condition__c dealCond = new acfDealIQ_Condition__c();
            dealCond.acfOpportunity__c = objOpp.id;
            dealCond.acfGlobal_DealIQ_Rule__c = dealRule.id;
            dealCond.Name = 'Test Demo';
            system.debug('hiii');
            insert dealCond;
            
            
        }
        
        static void LoadData(){
            createLead();
            createAccount();
            createContact();
            createmasterdoc();
            createUser();
            createOpportunity();
            createcommunitysetup();
        }

      static void createLead(){
            objLead=new Lead();
            objLead=WLCommonTrackerClass.createLead(objLead);
       }
    
    static void createAccount(){
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','88','test@gmail.com',objLead.id);
        objAccount.acfAsset_House_Worth__c=55;
        update objAccount; 
    }
    
    static void createContact(){
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
    
}