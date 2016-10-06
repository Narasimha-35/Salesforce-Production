@isTest
private class PepperLoanProFeeTriggerHandlerTracker{
 private static Account objAccount;
 private static Pepper_Loan_Product_Fee__c objPepperLoanProductFee;
 private static Pepper_Loan_Product__c  objPepperLoanProduct;
 private static Opportunity objOpportunity;
 
    static testMethod void validate()
    {
        LoadData();
        update objPepperLoanProductFee;
        delete objPepperLoanProductFee;
    }
  
  
    private static void LoadData()
    {
        ACFSwitch__c acfswitch = new ACFSwitch__c();
        acfswitch.PepperLoanProductFeeTriggerSwitch__c = true;
        insert acfswitch;

        createAccount(); 
        createOpportunity(); 
        createPepperLoanProduct();
        createPepperLoanProductFee();
    }
   
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createOpportunity()
    {
        objOpportunity = new Opportunity();
        objOpportunity = WLCommonTrackerClass.createOpportunity1(objOpportunity,objAccount);
    }
    
    static void createPepperLoanProduct()
    {
        objPepperLoanProduct = new Pepper_Loan_Product__c();
        objPepperLoanProduct.Index__c = '1';
        objPepperLoanProduct.Opportunity__c = objOpportunity.id;
        insert objPepperLoanProduct;
    }
    
    static void createPepperLoanProductFee()
    {
        objPepperLoanProductFee = new Pepper_Loan_Product_Fee__c();
        objPepperLoanProductFee.index__c = '1';
        objPepperLoanProductFee.OpportunityId__c = string.valueof(objOpportunity.id);
        insert objPepperLoanProductFee;       
    }
 }