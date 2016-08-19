@isTest 
public class IncomeExpenseTriggerHandlerTracker{
    
    static testMethod void call() {
     ACFSwitch__c acfswitch = new ACFSwitch__c();
       acfswitch.Income_Trigger_Switch__c= true;    
       insert acfswitch;
     Income_And_Expense__c   obj = new Income_And_Expense__c  ();
     obj.Amount__c = 1000;
     
     Insert   obj ;
     //IncomeExpenseTriggerHandler ieObj = new IncomeExpenseTriggerHandler ();
     //ieObj.afterInsert();
     
     
     
       
    }
}