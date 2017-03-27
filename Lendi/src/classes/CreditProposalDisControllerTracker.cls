@isTest
public class CreditProposalDisControllerTracker
{
  
private static Opportunity objOpportunity;
private static List<Opportunity> lstOpp;
private static User objUser;
private static Lead objLead;
private static Broker__c objBroker;
private static Product2 objProduct2;
private static Account objAccount;
private static Account objPersonAccount;
private static OpportunityLineItem objOLI;
private static Income_And_Expense__c objIncomeExpense;
private static Asset_And_Liability__c objAssetandLiablility;
private static click_Applicant__c objApplicant;
private static Funding_Position_Detail__c objFPD;
private static Market__c objMarket;
private static List<Product2> lstProduct;
private static List<OpportunityLineItem> lstOLI;
private static List<click_Applicant__c> lstApplicant;
private static List<Funding_Position_Detail__c> lstFPD;
private static Funding_Position__c objFundingPos;
private static List<Asset_And_Liability__c> lstAssetLiab;
private static List<Income_And_Expense__c> lstIncomeExpense;
private static List<Pricebook2> lstpbk1;
private static Product2 objProd;
//private static List<Product2> lstProduct2;
private static List<PricebookEntry> lstpbe1;
private static string strLeadFName;
private static string strLName;
private static string strPhone;
private static string strLeadEmail;
private static Id strLeadId;
private static Id OpptyId;


 static testMethod void validate()
 {  
   
  LoadData();
 
     apexpages.currentpage().getparameters().put('id',objOpportunity.Id);
  
     lstProduct = new List<Product2>();
     objProd = new Product2();
     objProd.Name = 'test1';
     objProd.acfApplication_Fee__c = 230;
     objProd.acfLegal_Fees__c = 100;
     objProd.ACF_Comparison_Rate__c = 10;
     objProd.IsActive = true;
     //insert objProd;
     
     Product2 objProduct3 = new Product2();
     objProduct3.Name = 'test2';
     objProduct3.acfApplication_Fee__c = 140;
     objProduct3.ACF_Comparison_Rate__c = 200;
     objProduct3.acfLegal_Fees__c = 150;
     objProduct3.IsActive = true;
    // insert objProduct3;
     
     lstProduct.add(objProd);
     lstProduct.add(objProduct3);
     insert lstProduct;
     
    OpportunityLineItem objOppLI = new OpportunityLineItem();
        List<priceBook2> lstPB = new List<priceBook2>();
        
        lstPB = [select id,name from priceBook2 where isActive= true and isStandard = true limit 1];
        Id pbId = Test.getStandardPricebookId();
          
        List<PricebookEntry> listPBE = new List<PricebookEntry>();
        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Pricebook2ID = pbId;
        pbe2.Product2Id = lstProduct[0].Id;
        pbe2.UnitPrice = 50;
        pbe2.isActive = true;
        
        insert pbe2;
        listPBE.add(pbe2);
        OpportunityLineItem  objOppLineItem = new OpportunityLineItem (OpportunityID=objOpportunity.id,lender__c='ANZ',PriceBookEntryID=listPBE[0].id,Quantity=1,TotalPrice=100);
        insert objOppLineItem;
       
    lstFPD = new List<Funding_Position_Detail__c>();
    objFPD.Name = 'FPD1';
    update objFPD;
    lstFPD.add(objFPD);
   // insert lstFPD;
    
    lstApplicant = new List<click_Applicant__c>();
    lstApplicant.add(objApplicant);
    test.startTest();
     CreditProposalDisclosureController objCPD = new CreditProposalDisclosureController();  
    test.stoptest();
    //insert lstApplicant;    
 }
 
     private static void LoadData()
     {
     
        createLead();
        createPersonAccount();
        createAccount();
        createuser();
        createMarket();
        createBroker();
        createAccount();
        createOpportunity();
        createProduct();
        createOpportunityLineItem();
        createFundingPosition();
        createAssetLiab();
        createFPD();
        createApplicant();
        createIncomeandExpense();
     }
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLead(objLead);
    }
       
    static void createPersonAccount()
    {
        strLeadFName = 'Manish Test';
        strLName = 'Bhasin Test';
        strPhone = '9811152100';
        strLeadEmail = 'lead@gmail.com';
        strLeadId = WLCommonTrackerClass.CreatePersonAccountNew(strLeadId);
        objPersonAccount = new Account();
        objPersonAccount = WLCommonTrackerClass.CreatePersonAccount(strLeadFName,strLName,strPhone,strLeadEmail,strLeadId);
    }   
    
    static void createUser()
    {
        objUser = new User();
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createMarket()
    {
         objMarket = new Market__c();
         objMarket.Name = 'Test market';
         insert objMarket;
    }
    
    static void createBroker()
    {
         objBroker = new Broker__c();
         objBroker.ACL_Licence__c = 'BR123';
         objBroker.ACL_Address__c = '23/4 Perky St';
         objBroker.ACL_EDR_Membership_No__c = '4356';
         objBroker.ACL_EDR_Scheme__c = 'Test scheme';
         objBroker.ACL_Email__c = 'salesforce123@gmail.com';
         objBroker.ACL_Holder__c = 'Test Holder';
         objBroker.ACL_Phone__c = '9854111220';
         objBroker.ACR__c = 'ACS123';
         objBroker.MobilePhone__c = '9852140201';
         objBroker.Street_Address__c = '23/4 Perky St';
         objBroker.City__c = 'Sydney';
         objBroker.Primary_Market__c = objMarket.Id;
         objBroker.ACR_EDR_Membership_No__c = 'EDR123';
         objBroker.ACR_EDR_Scheme_Name__c = 'EDRSCH123';
         
         objBroker.ACR_EDR_Expiry__c = system.today();//Date.newInstance(22,12,2012);
         objBroker.ACR_EDR_Expiry_Date__c = system.today();//Date.newInstance(12,11,2014);
         objBroker.Active_Broker__c = true;
         objBroker.Email__c = 'sale23@gmail.com';
         objBroker.Representative_Email__c = 'sfdc123@gmail.com';
         objBroker.Representative_Business_Address__c = 'WA';
         insert objBroker;
     }
     
     static void createAccount()
     {
         objAccount = new Account();
         objAccount = WLCommonTrackerClass.createAccount(objAccount);
     }
     
     static void createOpportunity()
     {
        objOpportunity = new Opportunity();
        lstOpp = new List<Opportunity>();
        objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
        
        objOpportunity.CurrentAssignedBroker__c = objBroker.Id;
        update objOpportunity;
        
      
        // lstOpp.add(objOpportunity);
    }
    
    static void createProduct()
    {
        lstProduct = new List<Product2>();
        objProduct2 = new Product2();
        objProduct2 = WLCommonTrackerClass.createProduct(objProduct2);    
        
    }
    
    static void createOpportunityLineItem()
    {
        objOLI = new OpportunityLineItem();
        lstpbk1 = new List<priceBook2>();
        lstpbk1= [select id,name from priceBook2 where isActive= true and isStandard = true limit 1];
        Id pricebookId = Test.getStandardPricebookId();
          
        lstpbe1 = new List<PricebookEntry>();
        PricebookEntry pbe1 = new PricebookEntry();
        pbe1.Pricebook2ID = pricebookId;
        pbe1.Product2Id = objProduct2.Id;
        pbe1.UnitPrice = 50;
        pbe1.isActive = true;
        
        insert pbe1;
        lstpbe1.add(pbe1);
        objOLI = new OpportunityLineItem (OpportunityID=objOpportunity.id,lender__c='ANZ',PriceBookEntryID=lstpbe1[0].id,Quantity=1,TotalPrice=100);
        insert objOLI;
    }
    
    static void createFundingPosition()
    { 
       objFundingPos = new Funding_Position__c();
       objFundingPos = WLCommonTrackerClass.createFundingPosition(objAccount,objOpportunity);
      // objFundingPos.Opportunity__c = objOpportunity.Id;
      // insert objFundingPos;
    }    
    
    static void createAssetLiab()
    {
        objAssetandLiablility  = new Asset_And_Liability__c();
        objAssetandLiablility =  WLCommonTrackerClass.createAssetandLiablility(objAssetandLiablility,objAccount);
        objAssetandLiablility.Opportunity__c = objOpportunity.Id;
        update objAssetandLiablility;
        lstAssetLiab = new List<Asset_And_Liability__c>();
        lstAssetLiab.add(objAssetandLiablility);
        //insert lstAssetLiab;
         
    }
     
    static void createFPD()
    {
        objFPD = new Funding_Position_Detail__c();
        objFPD = WLCommonTrackerClass.createFundingPositionDetail(objAssetandLiablility,objFundingPos);  
    }
    
   static void createApplicant()
   {
      objApplicant = new click_Applicant__c();
      objApplicant.acf_applicant_DOB__c = string.valueOf(date.newinstance(1960,2,17));
      objApplicant = WLCommonTrackerClass.createApplicant(objApplicant,objAccount,objOpportunity); 
   }
   
   static void createIncomeandExpense()
   {
        objIncomeExpense = new Income_And_Expense__c();
        objIncomeExpense = WLCommonTrackerClass.createIncomeExpense(objIncomeExpense,objApplicant);    
   } 
    
    
}