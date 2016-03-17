//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#    Date              Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0                       Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
public without sharing class BankStatementSubCategoryTriggerHandler
 {
   public void OnAfterInsert(list<click_Bank_Statements_Sub_Category__c> triggerNew, map<id,click_Bank_Statements_Sub_Category__c> triggerOldMap)
    {
        
    }       
   public void OnAfterUpdate(list<click_Bank_Statements_Sub_Category__c> triggerNew, map<id,click_Bank_Statements_Sub_Category__c> triggerOldMap,list<click_Bank_Statements_Sub_Category__c> triggerOld)
    {
      
    }
   public void OnBeforeInsert(list<click_Bank_Statements_Sub_Category__c> triggerNew)
    {
         updateClickBankStatementSubCategory(triggerNew);
    }
   public void OnBeforeUpdate(list<click_Bank_Statements_Sub_Category__c> triggerNew, map<id,click_Bank_Statements_Sub_Category__c> triggerOldMap)
    {

    }
   public void OnBeforeDelete(list<click_Bank_Statements_Sub_Category__c> triggerOld, map<id,click_Bank_Statements_Sub_Category__c> triggerOldMap)
    {
        
    }
   public void OnAfterDelete(list<click_Bank_Statements_Sub_Category__c> triggerOld, map<id,click_Bank_Statements_Sub_Category__c> triggerOldMap)
    {
         
    }
   public void OnAfterUnDelete(list<click_Bank_Statements_Sub_Category__c> triggerNew)
    {
         
    }
    
    
    public void updateClickBankStatementSubCategory(list<click_Bank_Statements_Sub_Category__c> triggerNew)
    {
        Map<string,String> mapBnkStatementDataCategoryUniqueIdToId = new Map<string,string>();
        set<string> setOfUniqueId = new set<string>();
        if(triggerNew.size() >0)  
        {        
            for(click_Bank_Statements_Sub_Category__c objbankStatementSubCategory : triggerNew)
            {
                string strUniqueId = '';
                if(string.isNotEmpty(objbankStatementSubCategory.Click_Required_Document_Id__c)  
                    && string.isNotEmpty(objbankStatementSubCategory.Click_Statement_No__c)
                   && string.isNotEmpty(objbankStatementSubCategory.Bank_Statement_Account_Number__c))
                {
                    strUniqueId = objbankStatementSubCategory.Click_Required_Document_Id__c+objbankStatementSubCategory.Bank_Statement_Account_Number__c+objbankStatementSubCategory.Click_Statement_No__c;
                    strUniqueId = strUniqueId.trim();
                    setOfUniqueId.add(strUniqueId);    
                }
            } 
            system.debug('setOfUniqueId8************'+setOfUniqueId);   
        }
        list<click_Bank_Statement_Data__c> lstBankStatementData = new list<click_Bank_Statement_Data__c>();
        if(setOfUniqueId <> null && setOfUniqueId.size() > 0)
        {
                      
            lstBankStatementData = [select id,Bank_Statement_Account_Number__c,Click_Required_Document_Id__c,Click_Statement_No__c,
                                    Click_UniqueId__c from click_Bank_Statement_Data__c where Click_UniqueId__c IN:setOfUniqueId];
            system.debug('lstBankStatementData ************'+lstBankStatementData);
                                                                                      
        }
        
        if(lstBankStatementData <> null && lstBankStatementData .size() > 0)
        {
            for(click_Bank_Statement_Data__c objBankStateData : lstBankStatementData)
            {
                mapBnkStatementDataCategoryUniqueIdToId.put(objBankStateData.Click_UniqueId__c,objBankStateData.Id);
                system.debug('mapBnkStatementDataCategoryUniqueIdToId************'+mapBnkStatementDataCategoryUniqueIdToId);
            }
        }
        
        for(click_Bank_Statements_Sub_Category__c objbnkStateSubCategory : triggerNew)
        {
            if(string.isNotEmpty(objbnkStateSubCategory.Click_Required_Document_Id__c) && string.isNotEmpty(objbnkStateSubCategory.Click_Statement_No__c)
               && string.isNotEmpty(objbnkStateSubCategory.Bank_Statement_Account_Number__c)
               && mapBnkStatementDataCategoryUniqueIdToId.get(objbnkStateSubCategory.Click_Required_Document_Id__c+objbnkStateSubCategory.Bank_Statement_Account_Number__c+objbnkStateSubCategory.Click_Statement_No__c) != null)
            {
                objbnkStateSubCategory.Bank_Statement_Category__c = mapBnkStatementDataCategoryUniqueIdToId.get(objbnkStateSubCategory.Click_Required_Document_Id__c+objbnkStateSubCategory.Bank_Statement_Account_Number__c+objbnkStateSubCategory.Click_Statement_No__c);
                 system.debug('!@#$%^&************'+mapBnkStatementDataCategoryUniqueIdToId.get(objbnkStateSubCategory.Click_Required_Document_Id__c+objbnkStateSubCategory.Bank_Statement_Account_Number__c+objbnkStateSubCategory.Click_Statement_No__c));
            }
        }
    }
    
}