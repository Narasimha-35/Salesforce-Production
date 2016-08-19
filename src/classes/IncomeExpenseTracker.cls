@isTest
private class IncomeExpenseTracker{
    
    private static User objUser;
    private static Income_And_Expense__c objIncomeExpense;
    private static Account objAccount;
    private static Opportunity objOpportunity;
   
   static testMethod void test(){
      ACFSwitch__c acfswitch = new ACFSwitch__c();
      acfswitch.Income_Trigger_Switch__c= true;
      insert acfswitch;
       LoadData();
   }
   
 

   private static void LoadData(){
    createAccount();
    createUser();
    createOpportunity();
    createIncomeExpense();
    }


    static void createAccount(){
    
    objAccount = new Account();
    objAccount = WLCommonTrackerClass.createAccount(objAccount);
   
    }
    
    static void createUser(){
 
    objUser = new User();
    objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createOpportunity(){
    
    objOpportunity = new Opportunity();
    objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
       
    }
    
    
    
    
 
    
    static void createIncomeExpense(){
        objIncomeExpense = new Income_And_Expense__c();
        objIncomeExpense.Account__c = objAccount.Id;
        objIncomeExpense.Amount__c = 52000;
        objIncomeExpense.Frequency__c = 'Weekly';
        insert objIncomeExpense;
        
    }
    
 

}