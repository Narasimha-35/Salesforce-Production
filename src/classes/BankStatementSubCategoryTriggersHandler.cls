//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#      Date                    Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0         25-03-2016              Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
public class BankStatementSubCategoryTriggersHandler extends TriggerHandler
 {  
    public override void BeforeInsert() {
     //  updateClickBankStatementSubCategory(trigger.New);
     }
     
      public override void AfterInsert() {
        system.debug('test'+trigger.New); 
        createFinancialsSource(trigger.New);
     }
     
   /*------------------------------------------------------------------------------------------------------
     This Method is used to Link BankStatementCategory with BankStatementAccount Object.
     ------------------------------------------------------------------------------------------------------*/
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
    
    
  /* -------------------------------------------------------------------------------
     This method is used to create Financial Source tagged with Income and Expense. 
     when Bank Statement subcategory object under Income Type Bank Statement category 
     is created.
     --------------------------------------------------------------------------------*/  
    public void createFinancialsSource(list<click_Bank_Statements_Sub_Category__c> lstTriggerNew)
    {
        if(lstTriggerNew.size() >0)  
        {   
            List<click_Bank_Statements_Sub_Category__c> lstBankStatesubCategory = [select id,Bank_Statement_Category__c,
                                                                                   Bank_Statement_Category__r.Name,Click_TransactionCount__c,
                                                                                   click_monthAvg__c,Click_Required_Document_Id__c from 
                                                                                   click_Bank_Statements_Sub_Category__c where id=:lstTriggerNew];
            system.debug('test'+lstTriggerNew);  
            map<id,id> mapBankstatementSubCategoryIdToReqDocId = new map<id,id>();   
            for(click_Bank_Statements_Sub_Category__c objbankStatementsubcategory : lstBankStatesubCategory)
            {
                if(objbankStatementsubcategory.Bank_Statement_Category__c != null && string.isNotEmpty(objbankStatementsubcategory.Bank_Statement_Category__r.Name) && objbankStatementsubcategory.Bank_Statement_Category__r.Name == 'Income'
                   && integer.valueof(objbankStatementsubcategory.Click_TransactionCount__c) > 0)
                {
                   
                    if(string.isNotEmpty(objbankStatementsubcategory.Click_Required_Document_Id__c))
                    {
                        mapBankstatementSubCategoryIdToReqDocId.put(objbankStatementsubcategory.id,Id.valueof(objbankStatementsubcategory.Click_Required_Document_Id__c));
                        system.debug('mapBankstatementSubCategoryIdToReqDocId********'+mapBankstatementSubCategoryIdToReqDocId);
                    }
                }
            } 
            
            map<id,id> mapReqDocIdToAccountId = new map<id,id>(); 
            if(mapBankstatementSubCategoryIdToReqDocId != null && mapBankstatementSubCategoryIdToReqDocId.size() > 0
               && mapBankstatementSubCategoryIdToReqDocId.keyset() != null && mapBankstatementSubCategoryIdToReqDocId.keyset().size() > 0
               && mapBankstatementSubCategoryIdToReqDocId.values() != null
               && mapBankstatementSubCategoryIdToReqDocId.values().size() > 0)  
            {
                 List<Required_Document__c> lstReqDoc = [select id,Lead__c,Lead__r.isconverted,Lead__r.acf_partner_account__c,acfOpportunity__c,
                                                         acfOpportunity__r.AccountId from Required_Document__c
                                                         where id=:mapBankstatementSubCategoryIdToReqDocId.values()];
                 system.debug('lstReqDoc ********'+lstReqDoc);                                        
                                                     
                 if(lstReqDoc != null && lstReqDoc.size() > 0)
                 {
                     for(Required_Document__c objReqDoc : lstReqDoc)
                     {
                         if(objReqDoc.Lead__r.isconverted == false)
                         {
                             system.debug('test111********'+objReqDoc.Lead__r.acf_partner_account__c); 
                             if(objReqDoc.Lead__r.acf_partner_account__c != null)
                                 mapReqDocIdToAccountId.put(objReqDoc.id,objReqDoc.Lead__r.acf_partner_account__c); 
                             system.debug('mapReqDocIdToAccountId********'+mapReqDocIdToAccountId); 
                         }
                         else
                         {
                             if(objReqDoc.acfOpportunity__r.AccountId != null)
                                 mapReqDocIdToAccountId.put(objReqDoc.id,objReqDoc.acfOpportunity__r.AccountId);
                             system.debug('mapReqDocIdToAccountId111111********'+mapReqDocIdToAccountId);     
                         }
                     }
                 }                                            
            }
            
            map<id,id> mapAccIdToApplicantId = new map<id,id>();
            map<id,id> mapApplicantIdToIncomeAndExpId = new map<id,id>();
            if(mapReqDocIdToAccountId != null && mapReqDocIdToAccountId.size() > 0 && mapReqDocIdToAccountId.keyset() != null 
               && mapReqDocIdToAccountId.keyset().size() > 0 && mapReqDocIdToAccountId.values() != null && mapReqDocIdToAccountId.values().size() > 0)
            {
                 List<click_Applicant__c> lstApplicant = [select id,click_Account__c,(select id,Category__c,CreatedDate,Recordtype.Name from Income_And_Expenses__r where
                                                          (Category__c = 'Full Time - PAYG'  OR Category__c = 'Self Employed')and Recordtype.Name IN ('Income') ORDER BY CreatedDate ASC Limit 1),
                                                          click_Applicant_Number__c from click_Applicant__c
                                                          where click_Account__c=:mapReqDocIdToAccountId.values() and click_Applicant_Number__c = '1'];
                 system.debug('lstApplicant ********'+lstApplicant);                                      
                 if(lstApplicant != null && lstApplicant.size() > 0)
                 {
                     for(click_Applicant__c objApplicant : lstApplicant)
                     {
                         if(objApplicant.click_Account__c != null)
                             mapAccIdToApplicantId.put(objApplicant.click_Account__c,objApplicant.id);
                         system.debug('mapAccIdToApplicantId********'+mapAccIdToApplicantId);    
                         if(objApplicant.Income_And_Expenses__r != null && objApplicant.Income_And_Expenses__r.size() > 0)
                             mapApplicantIdToIncomeAndExpId.put(objApplicant.id,objApplicant.Income_And_Expenses__r[0].id); 
                         system.debug('mapApplicantIdToIncomeAndExpId********'+mapApplicantIdToIncomeAndExpId);                 
                     }
                 } 
            } 
            List<Financials_Source__c> lstFinancialSource = new List<Financials_Source__c>();
            for(click_Bank_Statements_Sub_Category__c objbnkStatementSubCategory : lstBankStatesubCategory)
            {
                if(objbnkStatementSubCategory.Bank_Statement_Category__c != null && string.isNotEmpty(objbnkStatementSubCategory.Bank_Statement_Category__r.Name) && objbnkStatementSubCategory.Bank_Statement_Category__r.Name == 'Income'
                   && integer.valueof(objbnkStatementSubCategory.Click_TransactionCount__c) > 0)
                {
                    Financials_Source__c objFinancialSource = new Financials_Source__c();
                    objFinancialSource.Source__c = 'Bank Statements';
                    objFinancialSource.Bank_Statements_Sub_Category__c = objbnkStatementSubCategory.id;
                    if(string.isNotEmpty(objbnkStatementSubCategory.click_monthAvg__c))
                    {
                        Decimal decAmt = decimal.valueof(objbnkStatementSubCategory.click_monthAvg__c)*12;
                        objFinancialSource.Amount__c = decAmt;
                    }
                    if(string.isNotEmpty(objbnkStatementSubCategory.Click_Required_Document_Id__c))
                       objFinancialSource.Click_Loans_Required_Document__c = id.valueof(objbnkStatementSubCategory.Click_Required_Document_Id__c);
                    if(mapBankstatementSubCategoryIdToReqDocId != null && mapBankstatementSubCategoryIdToReqDocId.size() > 0
                       && mapBankstatementSubCategoryIdToReqDocId.get(objbnkStatementSubCategory.id) != null && mapReqDocIdToAccountId != null 
                       && mapReqDocIdToAccountId.size() > 0 && mapReqDocIdToAccountId.get(mapBankstatementSubCategoryIdToReqDocId.get(objbnkStatementSubCategory.id)) != null && mapAccIdToApplicantId != null && mapAccIdToApplicantId.size() > 0 && mapAccIdToApplicantId.get(mapReqDocIdToAccountId.get(mapBankstatementSubCategoryIdToReqDocId.get(objbnkStatementSubCategory.id))) != null
                       && mapApplicantIdToIncomeAndExpId != null && mapApplicantIdToIncomeAndExpId.size() > 0 && mapApplicantIdToIncomeAndExpId.get(mapAccIdToApplicantId.get(mapReqDocIdToAccountId.get(mapBankstatementSubCategoryIdToReqDocId.get(objbnkStatementSubCategory.id)))) != null)
                    {
                        objFinancialSource.Income_And_Expense__c =  mapApplicantIdToIncomeAndExpId.get(mapAccIdToApplicantId.get(mapReqDocIdToAccountId.get(mapBankstatementSubCategoryIdToReqDocId.get(objbnkStatementSubCategory.id))));
                    }
                    lstFinancialSource.add(objFinancialSource);
                }
            }  
            
            if(lstFinancialSource != null && lstFinancialSource.size() > 0)
            {
                insert lstFinancialSource;
            }
        }
    }
}