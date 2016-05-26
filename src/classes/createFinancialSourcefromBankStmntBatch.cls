//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#      Date                    Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0         25-03-2016              Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
// This Batch Class is used to create Financial Source from bank Statement for Existing Record
// --------------------------------------------------------------------------------------------
global class createFinancialSourcefromBankStmntBatch implements Database.Batchable<sObject>{

global Database.QueryLocator start(Database.BatchableContext BC) {
        string strIncome='Income';
        String query = 'select id,OwnerId,Bank_Statement_Category__c,Bank_Statement_Category__r.Name,isdeleted, ';
               query +='Click_TransactionCount__c,click_monthAvg__c,Click_Required_Document_Id__c ';
               query += 'from click_Bank_Statements_Sub_Category__c where (Bank_Statement_Category__c != null AND ';
               query += 'Bank_Statement_Category__r.Name =: strIncome AND isdeleted=false AND Click_Required_Document_Id__c != null) ';      
        return Database.getQueryLocator(query);
       } 
       
  global void execute(Database.BatchableContext BC, List<click_Bank_Statements_Sub_Category__c> lstBankStatesubCategory) {
       map<id,id> mapBankstatementSubCategoryIdToReqDocId = new map<id,id>(); 
       for(click_Bank_Statements_Sub_Category__c objbankStatementsubcategory : lstBankStatesubCategory)
       {
         if(objbankStatementsubcategory.Bank_Statement_Category__c != null && string.isNotEmpty(objbankStatementsubcategory.Bank_Statement_Category__r.Name) && objbankStatementsubcategory.Bank_Statement_Category__r.Name == 'Income'
            && integer.valueof(objbankStatementsubcategory.Click_TransactionCount__c) > 0)
         {
            if(string.isNotEmpty(objbankStatementsubcategory.Click_Required_Document_Id__c))
            {
                mapBankstatementSubCategoryIdToReqDocId.put(objbankStatementsubcategory.id,Id.valueof(objbankStatementsubcategory.Click_Required_Document_Id__c));
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
                                                     where id=:mapBankstatementSubCategoryIdToReqDocId.values() And isdeleted=false];                                    
             if(lstReqDoc != null && lstReqDoc.size() > 0)
             {
                 for(Required_Document__c objReqDoc : lstReqDoc)
                 {
                     if(objReqDoc.Lead__r.isconverted == false)
                     {  
                         if(objReqDoc.Lead__r.acf_partner_account__c != null)
                             mapReqDocIdToAccountId.put(objReqDoc.id,objReqDoc.Lead__r.acf_partner_account__c); 
                     }
                     else
                     {
                         if(objReqDoc.acfOpportunity__r.AccountId != null)
                             mapReqDocIdToAccountId.put(objReqDoc.id,objReqDoc.acfOpportunity__r.AccountId);      
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
                                                      where click_Account__c=:mapReqDocIdToAccountId.values() and click_Applicant_Number__c = '1' And isdeleted=false];
                                                 
             if(lstApplicant != null && lstApplicant.size() > 0)
             {
                 for(click_Applicant__c objApplicant : lstApplicant)
                 {
                     if(objApplicant.click_Account__c != null)
                         mapAccIdToApplicantId.put(objApplicant.click_Account__c,objApplicant.id);
                      
                     if(objApplicant.Income_And_Expenses__r != null && objApplicant.Income_And_Expenses__r.size() > 0)
                         mapApplicantIdToIncomeAndExpId.put(objApplicant.id,objApplicant.Income_And_Expenses__r[0].id); 
                                     
                 }
             } 
        } 
        List<Financials_Source__c> lstFinancialSource = new List<Financials_Source__c>();
        for(click_Bank_Statements_Sub_Category__c objbnkStatementSubCategory : lstBankStatesubCategory)
        {
            system.debug('objbnkStatementSubCategory +++++++++'+objbnkStatementSubCategory );
            if(objbnkStatementSubCategory.Bank_Statement_Category__c != null && string.isNotEmpty(objbnkStatementSubCategory.Bank_Statement_Category__r.Name)
               && objbnkStatementSubCategory.Bank_Statement_Category__r.Name == 'Income'
               && integer.valueof(objbnkStatementSubCategory.Click_TransactionCount__c) > 0)
            {
                Financials_Source__c objFinancialSource = new Financials_Source__c();
                objFinancialSource.Source__c = 'Bank Statements';
                if(objbnkStatementSubCategory.id != null)
                    objFinancialSource.Bank_Statements_Sub_Category__c = objbnkStatementSubCategory.id;
                if(string.isNotEmpty(objbnkStatementSubCategory.click_monthAvg__c))
                {
                    Decimal decAmt = decimal.valueof(objbnkStatementSubCategory.click_monthAvg__c)*12;
                    objFinancialSource.Amount__c = decAmt;
                }
                if(string.isNotEmpty(objbnkStatementSubCategory.Click_Required_Document_Id__c))
                   objFinancialSource.Click_Loans_Required_Document__c= id.valueof(objbnkStatementSubCategory.Click_Required_Document_Id__c.trim());
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
            Database.insert(lstFinancialSource,false);
        }
      
     }
    
     global void finish(Database.BatchableContext BC) {
    }
    
  }