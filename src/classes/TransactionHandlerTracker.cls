@isTest
private class TransactionHandlerTracker{

 private static click_Bank_Statement_Data__c objBankStmtData;
 private static click_Bank_Statements_Sub_Category__c objBankStmtSubCat;
 private static click_Bank_Statements_Transactions__c objBankStatementTransaction;
 private static List<click_Bank_Statements_Transactions__c> listbanktrans;
 
 private static list<click_Bank_Statement_Data__c> lstBnkStmtData;
 private static click_Bank_Statements_Account__c objBankStmtAcc;
 private static list<click_Bank_Statements_Account__c> lstBankStmtAcc;

 private static Required_Document__c objRequiredDocument;
 private static Document_Master__c  objDocumentMaster;
 private static Opportunity objOpportunity;
 private static User objUser;
 private Id clickReqDocId;
 


 static testMethod void validate(){


 // objUser = WLCommonTrackerClass.createUser(objUser);
 // objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
 // objDocumentMaster = WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);
    objRequiredDocument = new Required_Document__c();
    objRequiredDocument.Name = 'Click Loan required doc';
    insert objRequiredDocument;


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
    
     

    lstBnkStmtData = new List<click_Bank_Statement_Data__c>();
    objBankStmtData = new click_Bank_Statement_Data__c();
    objBankStmtData.Name = 'test bank data';
    objBankStmtData.click_Bank_Statements_Account__c = lstBankStmtAcc[0].Id;
    objBankStmtData.Click_Required_Document_Id__c = 'testId123';
    objBankStmtData.closingBalance__c = '1200';
    objBankStmtData.openingBalance__c = '500';
    objBankStmtData.Bank_Statement_Account_Number__c = 'BNK112344';
    lstBnkStmtData.add(objBankStmtData);

    if(lstBnkStmtData.size()>0 && lstBnkStmtData!=null){

    insert lstBnkStmtData; 
   
    system.debug('lstBnkStmtData++++++++++++++' +lstBnkStmtData);
    
   
    objBankStmtSubCat = new click_Bank_Statements_Sub_Category__c ();
    objBankStmtSubCat.Name = 'demo bank sub category';
    objBankStmtSubCat.Bank_Statement_Category__c = objBankStmtData.Id;
    objBankStmtSubCat.Click_Required_Document_Id__c = 'abc123';
    objBankStmtSubCat.Click_Statement_No__c= 'abc12345';
    objBankStmtSubCat.Bank_Statement_Account_Number__c ='BNKAC123';
    insert objBankStmtSubCat;
    
    
    listbanktrans = new list<click_Bank_Statements_Transactions__c>();
    objBankStatementTransaction = new click_Bank_Statements_Transactions__c();
    objBankStatementTransaction.Name = 'My first test transaction';
    objBankStatementTransaction.Bank_Statements_Sub_Category__c = objBankStmtSubCat.Id;
    objBankStatementTransaction.Click_Required_Document_Id__c = 'ID1010';
    objBankStatementTransaction.Click_Statement_No__c = 'STMT123';
    objBankStatementTransaction.Bank_Statement_Account_Number__c = 'BNKAC123';
    objBankStatementTransaction.Click_Subcategory_Index__c = 'Index-123';
    listbanktrans.add(objBankStatementTransaction);
    insert listbanktrans;
    
    TransactionHandler objtranshandler = new TransactionHandler(); 
    map<id,click_Bank_Statements_Transactions__c> triggerOldMap = new map<id,click_Bank_Statements_Transactions__c>();
    objtranshandler.OnAfterUpdate(listbanktrans, triggerOldMap, listbanktrans);
    
    List<click_Bank_Statements_Sub_Category__c> lstBankStatementSubCategory = new list<click_Bank_Statements_Sub_Category__c>();
    lstBankStatementSubCategory = [select id,Bank_Statement_Account_Number__c,Click_Required_Document_Id__c,
                                            Click_Statement_No__c,Click_Subcategory_Index__c,Click_Unique_Id__c
                                            from click_Bank_Statements_Sub_Category__c];
                                            

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