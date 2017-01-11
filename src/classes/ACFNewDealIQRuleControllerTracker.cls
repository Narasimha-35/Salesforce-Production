@isTest
public class ACFNewDealIQRuleControllerTracker
{
   
      public static Document_Master__c docobj;
        private static Lead objLead;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
     private static Opportunity objOpportunity;
     private static product2 objPro;
     private static PriceBookEntry pbEntry;
     private static OpportunityLineItem oppLine;
    static testMethod void validate()
    {LoadData();
        docobj=new Document_Master__c ();
        docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
        
        Global_DealIQ_Condition__c objcon=new Global_DealIQ_Condition__c();
        objcon.name='test';
        objcon.Category__c='Character';
        objcon.Active__c=true;
        objcon.Object_Rule_Works_On__c='Product';
        objcon.RecordRuleWorksOn__c='tesrt';
        objcon.Req_Doc_Created__c=true;
        objcon.Document_Master__c=docobj.id;
        insert objcon;
      //  ApexPages.currentPage().getParameters().put('dealId',objcon.id);
        
        ACFNewDealIQRuleController dealObj=new ACFNewDealIQRuleController();
        dealObj.dealId=objcon.id;
        
        dealObj.getDealIQRuleListDetail();
        dealObj.deleteCondition();
        dealObj.navigateToPage();
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
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
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
      objOpportunity.acfLoan_Amount_c__c=12;
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