//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#    Date              Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0                       Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
public  class TransactionHandler
 {
   public void OnAfterInsert(list<click_Bank_Statements_Transactions__c> triggerNew, map<id,click_Bank_Statements_Transactions__c> triggerOldMap)
    {
      
    }       
   public void OnAfterUpdate(list<click_Bank_Statements_Transactions__c> triggerNew, map<id,click_Bank_Statements_Transactions__c> triggerOldMap,list<click_Bank_Statements_Transactions__c> triggerOld)
    {
      
    }
   public void OnBeforeInsert(list<click_Bank_Statements_Transactions__c> triggerNew)
    {
          updateClickBankStatementTransaction(triggerNew);
    }
   public void OnBeforeUpdate(list<click_Bank_Statements_Transactions__c> triggerNew, map<id,click_Bank_Statements_Transactions__c> triggerOldMap)
    {

    }
   public void OnBeforeDelete(list<click_Bank_Statements_Transactions__c> triggerOld, map<id,click_Bank_Statements_Transactions__c> triggerOldMap)
    {
        
    }
   public void OnAfterDelete(list<click_Bank_Statements_Transactions__c> triggerOld, map<id,click_Bank_Statements_Transactions__c> triggerOldMap)
    {
         
    }
   public void OnAfterUnDelete(list<click_Bank_Statements_Transactions__c> triggerNew)
    {
         
    }
    
  public void updateClickBankStatementTransaction(list<click_Bank_Statements_Transactions__c> lstTriggerNew)
    {
       Map<string,String> mapBnkStatementSubCategoryUniqueIdToId = new Map<string,string>();
       set<string> setOfUniqueId = new set<string>();
       if(lstTriggerNew.size() >0)  
       {        
           for(click_Bank_Statements_Transactions__c objTransaction : lstTriggerNew)
           {
               string strUniqueId = '';
               if(string.isNotEmpty(objTransaction.Click_Required_Document_Id__c) && string.isNotEmpty(objTransaction.Click_Statement_No__c)
                 && string.isNotEmpty(objTransaction.Bank_Statement_Account_Number__c) && string.isNotEmpty(objTransaction.Click_Subcategory_Index__c))
               {
                   strUniqueId = objTransaction.Click_Required_Document_Id__c+'-:-'+objTransaction.Bank_Statement_Account_Number__c+'-:-'+objTransaction.Click_Statement_No__c+'-:-'+objTransaction.Click_Subcategory_Index__c;
                   setOfUniqueId.add(strUniqueId);
               }
           }    
       }
       list<click_Bank_Statements_Sub_Category__c> lstBankStatementSubCategory = new list<click_Bank_Statements_Sub_Category__c>();
       if(setOfUniqueId <> null && setOfUniqueId.size() > 0)
       {
            lstBankStatementSubCategory = [select id,Bank_Statement_Account_Number__c,Click_Required_Document_Id__c,
                                            Click_Statement_No__c,Click_Subcategory_Index__c,Click_Unique_Id__c
                                            from click_Bank_Statements_Sub_Category__c
                                            where Click_Unique_Id__c IN : setOfUniqueId];                  
       }
        if(lstBankStatementSubCategory <> null && lstBankStatementSubCategory.size() > 0)
        {
            for(click_Bank_Statements_Sub_Category__c objBankStateSubCategory : lstBankStatementSubCategory)
            {
                mapBnkStatementSubCategoryUniqueIdToId.put(objBankStateSubCategory.Click_Unique_Id__c,objBankStateSubCategory.Id);  
            }
        }
         for(click_Bank_Statements_Transactions__c objTransaction : lstTriggerNew)
        {  
            if(string.isNotEmpty(objTransaction.Click_Required_Document_Id__c) && string.isNotEmpty(objTransaction.Click_Statement_No__c)
               && string.isNotEmpty(objTransaction.Bank_Statement_Account_Number__c) && string.isNotEmpty(objTransaction.Click_Subcategory_Index__c)
               && mapBnkStatementSubCategoryUniqueIdToId.get(objTransaction.Click_Required_Document_Id__c+'-:-'+objTransaction.Bank_Statement_Account_Number__c+'-:-'+objTransaction.Click_Statement_No__c+'-:-'+objTransaction.Click_Subcategory_Index__c) != null)
            {
                objTransaction.Bank_Statements_Sub_Category__c = mapBnkStatementSubCategoryUniqueIdToId.get(objTransaction.Click_Required_Document_Id__c+'-:-'+objTransaction.Bank_Statement_Account_Number__c+'-:-'+objTransaction.Click_Statement_No__c+'-:-'+objTransaction.Click_Subcategory_Index__c);
            }
        }
    }
 }