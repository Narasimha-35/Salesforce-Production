@isTest
private class BankStatementCategoryHandlerTracker {
 
 private static click_Bank_Statement_Data__c objBankStmtData;
 private static list<click_Bank_Statement_Data__c> lstBnkStmtData;
 private static click_Bank_Statements_Account__c objBankStmtAcc;
 private static list<click_Bank_Statements_Account__c> lstBankStmtAcc;
 private static Required_Document__c objRequiredDocument;
 private static Document_Master__c  objDocumentMaster;
 private static Opportunity objOpportunity;
 private static User objUser;
 private Id clickReqDocId;
 
 

 static testMethod void createBankStatementAccount(){
    
     
    Map<Id, click_Bank_Statement_Data__c> mapIdWithclickBankStatementData = new Map<Id,click_Bank_Statement_Data__c>();
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
 //   objBankStmtData.click_Bank_Statements_Account__c = lstBankStmtAcc[0].Id;
    objBankStmtData.Click_Required_Document_Id__c = string.valueof(objRequiredDocument.id);
    objBankStmtData.closingBalance__c = '1200';
    objBankStmtData.openingBalance__c = '500';
    objBankStmtData.Bank_Statement_Account_Number__c = lstBankStmtAcc[0].Account_Number__c;
    lstBnkStmtData.add(objBankStmtData);

    if(lstBnkStmtData.size()>0 && lstBnkStmtData!=null){

    insert lstBnkStmtData; 
    
    BankStatementCategoryHandler objBankStatementCategoryHandler =  new BankStatementCategoryHandler();
    
    
    objBankStatementCategoryHandler.OnAfterDelete(lstBnkStmtData,mapIdWithclickBankStatementData );
    objBankStatementCategoryHandler.OnBeforeDelete(lstBnkStmtData,mapIdWithclickBankStatementData);
    objBankStatementCategoryHandler.OnBeforeUpdate(lstBnkStmtData,mapIdWithclickBankStatementData);
    objBankStatementCategoryHandler.OnAfterUnDelete(lstBnkStmtData);
     
     update lstBnkStmtData;
     
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
 
 /*
private static void LoadData(){



objUser = WLCommonTrackerClass.createUser(objUser);

objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);

objDocumentMaster = WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);

objClickLoansRecDoc = WLCommonTrackerClass.createRequiredDocument(objRequiredDocument,objDocumentMaster,objOpportunity);


 }
*/