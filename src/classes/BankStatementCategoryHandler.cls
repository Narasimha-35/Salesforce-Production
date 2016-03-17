//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#    Date              Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0                       Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
public  class BankStatementCategoryHandler
 {
   public void OnAfterInsert(list<click_Bank_Statement_Data__c> triggerNew, map<id,click_Bank_Statement_Data__c> triggerOldMap)
    {
      
    }       
   public void OnAfterUpdate(list<click_Bank_Statement_Data__c> triggerNew, map<id,click_Bank_Statement_Data__c> triggerOldMap,list<click_Bank_Statement_Data__c> triggerOld)
    {
      
    }   

   public void OnBeforeInsert(list<click_Bank_Statement_Data__c> triggerNew)
    {
       UpdateBankStatementAccount(triggerNew);
    }
   public void OnBeforeUpdate(list<click_Bank_Statement_Data__c> triggerNew, map<id,click_Bank_Statement_Data__c> triggerOldMap)
    {

    }
   public void OnBeforeDelete(list<click_Bank_Statement_Data__c> triggerOld, map<id,click_Bank_Statement_Data__c> triggerOldMap)
    {
        
    }
   public void OnAfterDelete(list<click_Bank_Statement_Data__c> triggerOld, map<id,click_Bank_Statement_Data__c> triggerOldMap)
    {
         
    }
   public void OnAfterUnDelete(list<click_Bank_Statement_Data__c> triggerNew)
    {
    
    }  
    // This Method is used to Link BankStatementCategory with BankStatementAccount Object.
    
public void UpdateBankStatementAccount(list<click_Bank_Statement_Data__c> lstTriggerNew)
    {
        Map<string,String> mapAccNumberToAccId = new Map<string,string>();
        Map<string,String> mapAccNumberToReqDocId = new Map<string,string>();
        set<string> setOfBankStatementDataReqDocId = new set<string>();
        if(lstTriggerNew.size() >0)  
        {        
            for(click_Bank_Statement_Data__c objbankStatementData : lstTriggerNew)
            {
                if(string.isNotEmpty(objbankStatementData.Click_Required_Document_Id__c))
                {
                    setOfBankStatementDataReqDocId.add(objbankStatementData.Click_Required_Document_Id__c);
                }
            }    
        }
        list<click_Bank_Statements_Account__c> lstBankStatementAccount = new list<click_Bank_Statements_Account__c>();
        if(setOfBankStatementDataReqDocId <> null)
        {
            lstBankStatementAccount = [select id,Account_Number__c,Click_Loans_Required_Document__c
                                       from click_Bank_Statements_Account__c
                                       where Click_Loans_Required_Document__c IN : setOfBankStatementDataReqDocId];             
        }
        
        system.debug('lstBankStatementAccount---------'+lstBankStatementAccount);
    
        if(lstBankStatementAccount <> null && lstBankStatementAccount.size() > 0)
        {          
            for(click_Bank_Statements_Account__c objBankStateAcc : lstBankStatementAccount)
            {
                mapAccNumberToAccId.put(objBankStateAcc.Account_Number__c,objBankStateAcc.Id);
                mapAccNumberToReqDocId.put(objBankStateAcc.Account_Number__c,string.valueOf(objBankStateAcc.Click_Loans_Required_Document__c));
            }
        }
    
        for(click_Bank_Statement_Data__c objBS : lstTriggerNew)
        {
            if(mapAccNumberToAccId != null && mapAccNumberToAccId.containsKey(objBS.Bank_Statement_Account_Number__c)
              && mapAccNumberToReqDocId.get(objBS.Bank_Statement_Account_Number__c) == objBS.Click_Required_Document_Id__c)
            {
                objBS.click_Bank_Statements_Account__c = mapAccNumberToAccId.get(objBS.Bank_Statement_Account_Number__c);
            }
        }
    }
}