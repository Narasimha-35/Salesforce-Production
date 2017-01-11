@isTest
public class acfTriggerOnOpportunityLineItemTracker
{
        
        
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity1;
    private static Product2 objPro;
    private static PriceBookEntry pbEntry;
    private static OpportunityLineItem oppLine;
    private static Document_Master__c objDocMas;
    private static Required_Document__c objReqDoc;
    private static OpportunityLineItem oli2;
    private static Click_Applicant__c oppClick;
    private static E_Consent__c eobj;
    
static testMethod void validate()
{

        LoadData();
        Product_Document__c objProDocument = new Product_Document__c ();
        objProDocument.Product__c= objPro.id;
        objProDocument.Click_Loans_Document_Master__c = objDocMas.id;
        insert objProDocument;
        
        oppLine.acfApplication_Fee__c = 1;
        oppLine.acfValuation_Fee__c= 1;
        oppLine.acfLegal_Fees__c= 1;
        oppLine.acfOngoing_Fees__c= 1;
        oppLine.acfRate__c= 1;
        oppLine.clickMonthly_Fees__c= 1;
        oppLine.clickEstablishment_Fee__c= 1;
        oppLine.clickMortgage_Risk_Fee__c= 1;
        oppLine.clickTitle_Protection_Fee__c= 1;
        oppLine.acfComparison_Rate__c = 1;
        oppLine.clickTotal_Upfront_Fee__c = 12;
        update oppLine;
        test.starttest();
        Delete oppline;
        test.stoptest();
} 
 
    private static void LoadData()
    {
            ACFSwitch__c acfswitch = new ACFSwitch__c();
        acfswitch.Opportunity_Line_Item_Switch__c = true;    
        insert acfswitch;
        createAccount();
        createContact();
        createUser();
        createOpportunity();
        createProduct();
        createPriceBookEntry();
        createOpportunityLineItem();
        createDocumentMaster();
        createRequiredDocument();
        createClickApplicant();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount.acfApproximately_how_much_is_your_house__pc = 10000000;
        objAccount.acfAsset_House_Worth__c = 765;
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
        system.debug('###'+objAccount);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
     static void createProduct()
    {
        objPro = new Product2();
        objPro.acfvarTenure_In_Years__c = 1;
        objPro = WLCommonTrackerClass.createProduct(objPro);
    }
    
     static void createPriceBookEntry()
    {
        pbEntry = new PriceBookEntry();
        pbEntry.UnitPrice = 300;
        pbEntry.PriceBook2Id = Test.getStandardPricebookId();
        pbEntry.Product2Id = objPro.Id;
        pbEntry.IsActive = true;
        insert pbEntry ; 
    }

     static void createOpportunity()
    {
      objOpportunity1 = new Opportunity();
      objOpportunity1.accountid=  objAccount.Id;
      objOpportunity1 = WLCommonTrackerClass.createOpportunity(objOpportunity1,objUser);
      objOpportunity1.name = 'test23';
      update objOpportunity1;
   
    }
    
     static void createOpportunityLineItem()
    {
        oppLine = new OpportunityLineItem();
        oppLine.pricebookentryid=pbEntry.Id;
        oppLine.TotalPrice=2000;
        oppLine.Quantity = 2;
        oppLine.OpportunityID = objOpportunity1.Id;
        oppLine.lender__c = 'ANZ';
        insert oppLine;
    }
    static void createClickApplicant(){
        oppClick = new Click_Applicant__c();
        oppClick = WLCommonTrackerClass.createApplicant(oppClick,objAccount,objOpportunity1);
    }
    static void createEConsent(){
        eObj = new E_Consent__c();
        eObj = WLCommonTrackerClass.createEconsent(oppClick);
    }
    
      static void createDocumentMaster()
    {
        objDocMas = new Document_Master__c();
        objDocMas = WLCommonTrackerClass.createDocumentMaster(objDocMas);
    }
    
      static void createRequiredDocument()
    {
        objReqDoc = new Required_Document__c();
        objReqDoc= WLCommonTrackerClass.createRequiredDocument(objReqDoc,objDocMas,objOpportunity1);
    }
    
}