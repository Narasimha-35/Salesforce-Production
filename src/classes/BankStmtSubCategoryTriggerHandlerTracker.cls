@isTest
private class BankStmtSubCategoryTriggerHandlerTracker{

 private static click_Bank_Statement_Data__c objBankStmtData;
 private static click_Bank_Statements_Sub_Category__c objBankStmtSubCat;
 private static click_Bank_Statements_Sub_Category__c objBnkStatSubCategory2;
 private static list<click_Bank_Statement_Data__c> lstBnkStmtData;
 private static click_Bank_Statements_Account__c objBankStmtAcc;
 private static list<click_Bank_Statements_Account__c> lstBankStmtAcc;
 private static Income_And_Expense__c objIncome;
 private static Required_Document__c objRequiredDocument;
 private static Document_Master__c  objDocumentMaster;
 private static Opportunity objOpportunity;
 private static User objUser;
 private static Account objAccount;
 private static Lead objLead;
 private static click_Bank_Statement_Data__c objBankstmtcat;
 private static click_Applicant__c objApp;
 private static Financials_Source__c objFinancialSource;
 private Id clickReqDocId;
 

 static testMethod void createBankStatementAccount(){


 // objUser = WLCommonTrackerClass.createUser(objUser);
 // objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
 // objDocumentMaster = WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);
 
          ACFSwitch__c acfswitch = new ACFSwitch__c();
           acfswitch.Bank_Statement_SubCategory_TriggerSwitch__c = true;
             insert acfswitch;
         
 
    objRequiredDocument = new Required_Document__c();
    objRequiredDocument.Name = 'Click Loan required doc';
    insert objRequiredDocument;
    
     objLead = new Lead();
        objLead.isconverted = false;
        objLead = WLCommonTrackerClass.createLead(objLead);
    
    
     objAccount = new Account();
        list<lead> lstLead = [select id,isConverted from lead where id =: objLead.id];
        if(lstLead != null && lstLead.size()>0)
        {
            if(lstLead[0].isConverted == false)
                objAccount.acf_Lead__pc = lstLead[0].id;
        }
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    
         objApp = new click_Applicant__c();
         objApp.acfAnnual_profit_income__c = '3234';
         objApp.acf_applicant_Monthlly_Salary__c = 45;
         objApp.clickApp_1_Monthly_Expenses__c  = 654.54;
         objApp.click_Applicant_Number__c = '1';
         objApp.click_Account__c = objAccount.id;
         insert objApp;
    

     Id IncomeRecordTypeId = Schema.SObjectType.Income_And_Expense__c.getRecordTypeInfosByName().get('Income').getRecordTypeId();
     objIncome = new Income_And_Expense__c();
     objIncome.recordTypeId = IncomeRecordTypeId;
     objIncome.Amount__c = 45;
     objIncome.Category__c = 'Full Time - PAYG';
     objIncome.Applicant__c = objApp.Id;
     insert objIncome;
    

    lstBankStmtAcc = new list<click_Bank_Statements_Account__c>();
    objBankStmtAcc = new click_Bank_Statements_Account__c();

    objBankStmtAcc.Name = 'Test BankStatement Account';
    objBankStmtAcc.Account_Holder__c = 'Manish Bhasin';
    objBankStmtAcc.Account_Number__c = 'ABC123';
    objBankStmtAcc.Click_Loans_Required_Document__c = objRequiredDocument.Id;
    lstBankStmtAcc.add(objBankStmtAcc);

    if(lstBankStmtAcc.size()>0 && lstBankStmtAcc!=null){
    insert lstBankStmtAcc;

//  objBankStmtAcc.Account_Holder__c = 'Mb';
//  update objBankStmtAcc;
   }
    system.debug('lstBankStmtAcc------------' +lstBankStmtAcc);
    system.assertEquals('Test BankStatement Account',objBankStmtAcc.Name);
    
     objBnkStatSubCategory2 = new click_Bank_Statements_Sub_Category__c();
    objBnkStatSubCategory2.Name = 'Wages';
    objBnkStatSubCategory2.Click_Required_Document_Id__c = string.valueof(objRequiredDocument.Id);
    objBnkStatSubCategory2.Bank_Statement_Account_Number__c = 'BNK1234';
    objBnkStatSubCategory2.Click_Statement_No__c = 'acsds1212';
    insert objBnkStatSubCategory2;
 
    String strUniqueID = '';
    strUniqueID = objBnkStatSubCategory2.Click_Required_Document_Id__c + objBnkStatSubCategory2.Bank_Statement_Account_Number__c + objBnkStatSubCategory2.Click_Statement_No__c;
   

    lstBnkStmtData = new List<click_Bank_Statement_Data__c>();
    objBankStmtData = new click_Bank_Statement_Data__c();
    objBankStmtData.Name = 'Income';
    objBankStmtData.click_Bank_Statements_Account__c = lstBankStmtAcc[0].Id;
    objBankStmtData.Click_Required_Document_Id__c = 'testId123';
   // objBankStmtData.Click_UniqueId__c = strUniqueID;
    objBankStmtData.closingBalance__c = '1200';
    objBankStmtData.openingBalance__c = '500';
    objBankStmtData.Bank_Statement_Account_Number__c = 'BNK112344';
    objBankStmtData.Click_Statement_No__c = 'BANK121343';
    lstBnkStmtData.add(objBankStmtData);
    
    if(lstBnkStmtData.size()>0 && lstBnkStmtData!=null){

    insert lstBnkStmtData; 
   
    system.debug('lstBnkStmtData++++++++++++++' +lstBnkStmtData);
    
     objBankstmtcat = new click_Bank_Statement_Data__c();      
        objBankstmtcat.Name = 'Income';   
        insert objBankstmtcat;
    
    
   
    
    objBankStmtSubCat = new click_Bank_Statements_Sub_Category__c();
    objBankStmtSubCat.Name = objBankstmtcat.Name;
    objBankStmtSubCat.Click_TransactionCount__c = '3';  
    objBankStmtSubCat.click_monthAvg__c = '432';
    objBankStmtSubCat.Bank_Statement_Category__c = objBankStmtData.Id;
    objBankStmtSubCat.Click_Required_Document_Id__c = string.valueof(objRequiredDocument.Id);
    if(objBankstmtcat.Name != null)
    {
    objBankStmtSubCat.Name = objBankstmtcat.Name;
    }
    objBankStmtSubCat.Click_Statement_No__c= 'abc12345';
    objBankStmtSubCat.Bank_Statement_Account_Number__c ='BNKAC123';
   
       
  //  insert objBankStmtSubCat;
    
    List<click_Bank_Statements_Sub_Category__c> lstbnkstmtsubcat = new List<click_Bank_Statements_Sub_Category__c>();
    lstbnkstmtsubcat.add(objBankStmtSubCat);
    insert lstbnkstmtsubcat;
    update lstbnkstmtsubcat;
    
    List<Financials_Source__c> lstFinancesource = new List<Financials_Source__c>(); 
    objFinancialSource = new Financials_Source__c();
    objFinancialSource.Source__c = 'Bank Stmt';
    objFinancialSource.Bank_Statements_Sub_Category__c = lstbnkstmtsubcat[0].id;
    objFinancialSource.Amount__c = decimal.valueof(lstbnkstmtsubcat[0].click_monthAvg__c)*12;
    objFinancialSource.Click_Loans_Required_Document__c = id.valueof(lstbnkstmtsubcat[0].Click_Required_Document_Id__c);
    lstFinancesource.add(objFinancialSource);
    insert lstFinancesource;
    
   // objFinancialSource = new Financials_Source__c();
    
    
    BankStatementSubCategoryTriggersHandler bnkstmtsubcat = new BankStatementSubCategoryTriggersHandler();
    map<id,click_Bank_Statements_Sub_Category__c> mapBankStmtSubCat = new map<id,click_Bank_Statements_Sub_Category__c>();
    bnkstmtsubcat.updateClickBankStatementSubCategory(lstbnkstmtsubcat);
    bnkstmtsubcat.createFinancialsSource(lstbnkstmtsubcat);
    
  //  bnkstmtsubcat.OnBeforeDelete(lstbnkstmtsubcat,mapBankStmtSubCat);
  //  bnkstmtsubcat.OnAfterDelete(lstbnkstmtsubcat,mapBankStmtSubCat);
  //  bnkstmtsubcat.OnAfterUnDelete(lstbnkstmtsubcat);
   // delete lstbnkstmtsubcat;
    
    
    List<click_Bank_Statement_Data__c> LstBnkStmtData2 = new List<click_Bank_Statement_Data__c>();
    click_Bank_Statement_Data__c objBankStmtData2 = new click_Bank_Statement_Data__c();
    objBankStmtData2.Click_Required_Document_Id__c = objBankStmtData.Bank_Statement_Account_Number__c;
    insert objBankStmtData2;

     }
    
    
    
   //  clickReqDocId = lstBnkStmtData[0].Click_Required_Document_Id__c;
   List<click_Bank_Statements_Account__c> list2 = new List<click_Bank_Statements_Account__c>();
     click_Bank_Statements_Account__c clkbnkstmtacc = new click_Bank_Statements_Account__c();

  }
}