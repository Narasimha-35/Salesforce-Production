@isTest
public class WLDealIQcontrollerTracker
{
    private static Lead objLead;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static product2 objPro;
    private static PriceBookEntry pbEntry;
    private static OpportunityLineItem oppLine;
    private static ServicingCalculator__c objServicing;
    private static EmailHistory__c objEmailHistory;
    private static acfDealIQ_Condition__c objDealIqCondition;
    private static S3Document__c objS3Document;

    static testMethod void validate()
    {
        Test.setMock(HttpCalloutMock.class, new  MockHttpResponseGeneratorforLendi ());
        LoadData();
        ApexPages.currentPage().getParameters().put('id',objOpportunity.Id);
        ApexPages.currentPage().getParameters().put('DealIqIds',objDealIqCondition.Id);
        WLDealIQcontroller objDealIq = new WLDealIQcontroller();
        objDealIq.DealIqRecord();
        objDealIq.updateDealIqRecord();
        objDealIq.goBack();
        objDealIq.sendDealIqRequest();
    }
    
    static testMethod void getBankList()
    {
        Test.setMock(HttpCalloutMock.class, new  MockHttpResponseGeneratorforLendi ());
        WLDealIQcontroller objDealIq = new WLDealIQcontroller();
        objDealIq.getBankList();
        WLDealIQcontroller.Bank bank = new WLDealIQcontroller.Bank ();
        bank.bank_sf_id   = '';
        bank.bank_uuid  = '';
        bank.bank_short_name   = '';
        bank.bank_full_name  = '';        
        WLDealIQcontroller.Bankdata  obh  = new WLDealIQcontroller.Bankdata();        
        obh.service_calculator_uuid  = '';
        obh.maximum_borrowing  ='';
        obh.Bank  = bank;  
    }
    
   private static void LoadData()
    {
        createLead();
        createAccount();
        createContact();
        createUser();
        createOpportunity();
        createProduct();
        createPriceBookEntry();
        createOpportunityLineItem();
        
        Global_DealIQ_Condition__c objdealIqRule = new Global_DealIQ_Condition__c();
        objdealIqRule.Active__c = true;
        objdealIqRule.Category__c = 'Character';
        objdealIqRule.Object_Rule_Works_On__c = 'Product';
        insert objdealIqRule;
        
        objServicing = new ServicingCalculator__c();
        objServicing.Max_Borrowing_Power__c = 654323456;
        objServicing.Net_Monthly_Surplus__c = 7654;
        objServicing.Opportunity__c = objOpportunity.id;
        objServicing.OpportunityId__c = objOpportunity.id;
        objServicing.Services_Funds_Requested__c = false;
        objServicing.Services_Funds_Required__c = false;
        insert objServicing;
        
        objEmailHistory = new EmailHistory__c();
        objEmailHistory.ccRecipants__c = 'ankit2gmail.com';
        objEmailHistory.emailContent__c = 'ankit2gmail.com';
        objEmailHistory.AcfOpportunity__c = objOpportunity.Id;
        objEmailHistory.recipants__c = 'ankit2gmail.com';
        objEmailHistory.subject__c = 'Ankit Singh';
        insert objEmailHistory;
        
        objS3Document = new S3Document__c();
        objS3Document.emailHistory__c = objEmailHistory.id;
        objS3Document.Name = 'test';
        objS3Document.contentType__c = 'pdf';
        insert objS3Document;
        
        objDealIqCondition = new acfDealIQ_Condition__c();
        objDealIqCondition.acfComments__c = 'test';
        objDealIqCondition.acfOpportunity__c = objOpportunity.Id;
        objDealIqCondition.acfStatus__c = 'Open';
        objDealIqCondition.acfGlobal_DealIQ_Rule__c = objdealIqRule.Id;
        insert objDealIqCondition;
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
      objOpportunity = new Opportunity();
      objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
      objOpportunity.AccountId = objAccount.id;
      objOpportunity.acfLoan_Amount_c__c=3000;
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity.acfApproximately_how_much_is_your_house__c=90;
      objOpportunity.create_from_custom_clone_button__c=true;
      objOpportunity.acfAsset_House_Worth__c=20;
      update objOpportunity;
    }
    static void createProduct()
    {
        objPro=new product2();
        objPro=WLCommonTrackerClass.createProduct(objPro);
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
    
     static void createOpportunityLineItem()
    {
        oppLine = new OpportunityLineItem();
        oppLine.pricebookentryid=pbEntry.Id;
        oppLine.TotalPrice=2000;
        oppLine.Quantity = 2;
        oppLine.lender__c='test';
        oppLine.OpportunityID = objOpportunity.Id;
        insert oppLine;
    }

}