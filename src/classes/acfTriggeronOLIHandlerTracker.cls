@isTest(SeeAllData = true)
private class acfTriggeronOLIHandlerTracker 
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

    
    static testMethod void validate() 
    {
        LoadData();
        
        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.Name = 'Upto 90,0000';
        objLVR.acfProduct__c = objPro.Id;
        objLVR.acfLoan_Size__c = 100000;
        objLVR.clickLoan_Size_From__c  = 100000;
        objLVR.clickLVR_From__c = 100000;
        objLVR.acfLVR__c = 100000;
        objLVR.clickFixed_Interest_Rate__c = 4;
        insert objLVR;
        
        Product_Document__c objProDocument = new Product_Document__c ();
        objProDocument.Product__c = objPro.id;
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
      
        List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();

        oli2 = new OpportunityLineItem();
        oli2.pricebookentryid=pbEntry.Id;
        oli2.TotalPrice=2000;
        oli2.Quantity = 2;
        oli2.OpportunityID = objOpportunity1.Id;
       // insert oli2;

        lstOLI.add(oli2);
        insert lstOLI;
        update lstOLI;
        acfTriggerOnOpportunityLineItemHandler trigOnOLIhandler = new acfTriggerOnOpportunityLineItemHandler();
        trigOnOLIhandler.OnAfterDelete(lstOLI);
        delete lstOLI;

       
    }
    
    
    private static void LoadData()
    {
        createAccount();
        createContact();
        createUser();
        createOpportunity();
        createProduct();
        createPriceBookEntry();
        createOpportunityLineItem();
        createDocumentMaster();
        createRequiredDocument();

    }
    
       static void createAccount()
    {
        objAccount = new Account();
        objAccount.acfApproximately_how_much_is_your_house__pc = 10000000;
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
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
    }
    
     static void createOpportunityLineItem()
    {
        oppLine = new OpportunityLineItem();
        oppLine.pricebookentryid=pbEntry.Id;
        oppLine.TotalPrice=2000;
        oppLine.Quantity = 2;
        oppLine.OpportunityID = objOpportunity1.Id;
        insert oppLine;
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