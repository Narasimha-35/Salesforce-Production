Public class CallBankLoanPart2
{
    public static void CallBankLoansrestPart(FromBankstatementWrapper.cls_Loans ObjLoans,click_Bank_Statement_Data__c objBankStatementData, integer SubcategoryIndex,integer CategoryIndex,integer TransactionIndex,List<click_Bank_Statements_Sub_Category__c> lstSubctegory,List<click_Bank_Statement_Data__c> lstctegory,List<click_Bank_Statements_Transactions__c> lstTransaction,string AccountNumber,string ReqDocId)
        {
            if(ObjLoans.LoansbyPhone != null)
                {
                    FromBankstatementWrapper.cls_LoansbyPhone ObjLoansLoansbyPhone = ObjLoans.LoansbyPhone;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssLoansbyPhone = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssLoansbyPhone.Name = 'Loans by Phone';
                    objSubcategoryLoanssLoansbyPhone.Dependent__c = 'Loans by Phone';
                    objSubcategoryLoanssLoansbyPhone.Click_TransactionCount__c = string.valueof(ObjLoansLoansbyPhone.transactionCount);
                    objSubcategoryLoanssLoansbyPhone.click_totalValue__c = string.valueof(ObjLoansLoansbyPhone.totalValue);
                    objSubcategoryLoanssLoansbyPhone.click_monthAvg__c = string.valueof(ObjLoansLoansbyPhone.monthAvg);
                    objSubcategoryLoanssLoansbyPhone.click_minValue__c = string.valueof(ObjLoansLoansbyPhone.minValue);
                    objSubcategoryLoanssLoansbyPhone.click_maxValue__c = string.valueof(ObjLoansLoansbyPhone.maxValue);
                    objSubcategoryLoanssLoansbyPhone.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssLoansbyPhone.click_firstTransaction__c = ObjLoansLoansbyPhone.firstTransaction;
                    objSubcategoryLoanssLoansbyPhone.click_lastTransaction__c = ObjLoansLoansbyPhone.lastTransaction;
                    objSubcategoryLoanssLoansbyPhone.click_period__c = string.valueof(ObjLoansLoansbyPhone.period);
                    objSubcategoryLoanssLoansbyPhone.click_periodIsRegular__c = string.valueof(ObjLoansLoansbyPhone.periodIsRegular);
                    objSubcategoryLoanssLoansbyPhone.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryLoanssLoansbyPhone.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssLoansbyPhone.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssLoansbyPhone.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansLoansbyPhone.transactions != null && ObjLoansLoansbyPhone.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objLoansbyPhoneTransaction : ObjLoansLoansbyPhone.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Loans by Phonee Loans';
                            if(objLoansbyPhoneTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objLoansbyPhoneTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objLoansbyPhoneTransaction.strdate;
                            objTransaction.click_text__c = objLoansbyPhoneTransaction.text;
                            if(objLoansbyPhoneTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objLoansbyPhoneTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objLoansbyPhoneTransaction.amount);
                            objTransaction.click_type__c = objLoansbyPhoneTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objLoansbyPhoneTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssLoansbyPhone);
                }
                if(ObjLoans.LoanRanger != null)
                {
                    FromBankstatementWrapper.cls_LoanRanger ObjLoansLoanRanger = ObjLoans.LoanRanger;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssLoanRanger = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssLoanRanger.Name = 'Loan Ranger';
                    objSubcategoryLoanssLoanRanger.Dependent__c = 'Loan Ranger';
                    objSubcategoryLoanssLoanRanger.Click_TransactionCount__c = string.valueof(ObjLoansLoanRanger.transactionCount);
                    objSubcategoryLoanssLoanRanger.click_totalValue__c = string.valueof(ObjLoansLoanRanger.totalValue);
                    objSubcategoryLoanssLoanRanger.click_monthAvg__c = string.valueof(ObjLoansLoanRanger.monthAvg);
                    objSubcategoryLoanssLoanRanger.click_minValue__c = string.valueof(ObjLoansLoanRanger.minValue);
                    objSubcategoryLoanssLoanRanger.click_maxValue__c = string.valueof(ObjLoansLoanRanger.maxValue);
                    objSubcategoryLoanssLoanRanger.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssLoanRanger.click_firstTransaction__c = ObjLoansLoanRanger.firstTransaction;
                    objSubcategoryLoanssLoanRanger.click_lastTransaction__c = ObjLoansLoanRanger.lastTransaction;
                    objSubcategoryLoanssLoanRanger.click_period__c = string.valueof(ObjLoansLoanRanger.period);
                    objSubcategoryLoanssLoanRanger.click_periodIsRegular__c = string.valueof(ObjLoansLoanRanger.periodIsRegular);
                    objSubcategoryLoanssLoanRanger.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryLoanssLoanRanger.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssLoanRanger.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssLoanRanger.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansLoanRanger.transactions != null && ObjLoansLoanRanger.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objLoanRangerTransaction : ObjLoansLoanRanger.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Loan Ranger Loans';
                            if(objLoanRangerTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objLoanRangerTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objLoanRangerTransaction.strdate;
                            objTransaction.click_text__c = objLoanRangerTransaction.text;
                            if(objLoanRangerTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objLoanRangerTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objLoanRangerTransaction.amount);
                            objTransaction.click_type__c = objLoanRangerTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objLoanRangerTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssLoanRanger);
                }
                if(ObjLoans.MaxFinance != null)
                {
                    FromBankstatementWrapper.cls_MaxFinance ObjLoansMaxFinance = ObjLoans.MaxFinance;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssMaxFinance = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssMaxFinance.Name = 'Max Finance';
                    objSubcategoryLoanssMaxFinance.Dependent__c = 'Max Finance';
                    objSubcategoryLoanssMaxFinance.Click_TransactionCount__c = string.valueof(ObjLoansMaxFinance.transactionCount);
                    objSubcategoryLoanssMaxFinance.click_totalValue__c = string.valueof(ObjLoansMaxFinance.totalValue);
                    objSubcategoryLoanssMaxFinance.click_monthAvg__c = string.valueof(ObjLoansMaxFinance.monthAvg);
                    objSubcategoryLoanssMaxFinance.click_minValue__c = string.valueof(ObjLoansMaxFinance.minValue);
                    objSubcategoryLoanssMaxFinance.click_maxValue__c = string.valueof(ObjLoansMaxFinance.maxValue);
                    objSubcategoryLoanssMaxFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssMaxFinance.click_firstTransaction__c = ObjLoansMaxFinance.firstTransaction;
                    objSubcategoryLoanssMaxFinance.click_lastTransaction__c = ObjLoansMaxFinance.lastTransaction;
                    objSubcategoryLoanssMaxFinance.click_period__c = string.valueof(ObjLoansMaxFinance.period);
                    objSubcategoryLoanssMaxFinance.click_periodIsRegular__c = string.valueof(ObjLoansMaxFinance.periodIsRegular);
                    objSubcategoryLoanssMaxFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryLoanssMaxFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssMaxFinance.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssMaxFinance.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansMaxFinance.transactions != null && ObjLoansMaxFinance.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objMaxFinanceTransaction : ObjLoansMaxFinance.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Max Finance Loans';
                            if(objMaxFinanceTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objMaxFinanceTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objMaxFinanceTransaction.strdate;
                            objTransaction.click_text__c = objMaxFinanceTransaction.text;
                            if(objMaxFinanceTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objMaxFinanceTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objMaxFinanceTransaction.amount);
                            objTransaction.click_type__c = objMaxFinanceTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objMaxFinanceTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssMaxFinance);
                }
                if(ObjLoans.MaxFunding != null)
                {
                    FromBankstatementWrapper.cls_MaxFunding ObjLoansMaxFunding = ObjLoans.MaxFunding;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssMaxFunding = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssMaxFunding.Name = 'Max Funding';
                    objSubcategoryLoanssMaxFunding.Dependent__c = 'Max Funding';
                    objSubcategoryLoanssMaxFunding.Click_TransactionCount__c = string.valueof(ObjLoansMaxFunding.transactionCount);
                    objSubcategoryLoanssMaxFunding.click_totalValue__c = string.valueof(ObjLoansMaxFunding.totalValue);
                    objSubcategoryLoanssMaxFunding.click_monthAvg__c = string.valueof(ObjLoansMaxFunding.monthAvg);
                    objSubcategoryLoanssMaxFunding.click_minValue__c = string.valueof(ObjLoansMaxFunding.minValue);
                    objSubcategoryLoanssMaxFunding.click_maxValue__c = string.valueof(ObjLoansMaxFunding.maxValue);
                    objSubcategoryLoanssMaxFunding.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssMaxFunding.click_firstTransaction__c = ObjLoansMaxFunding.firstTransaction;
                    objSubcategoryLoanssMaxFunding.click_lastTransaction__c = ObjLoansMaxFunding.lastTransaction;
                    objSubcategoryLoanssMaxFunding.click_period__c = string.valueof(ObjLoansMaxFunding.period);
                    objSubcategoryLoanssMaxFunding.click_periodIsRegular__c = string.valueof(ObjLoansMaxFunding.periodIsRegular);
                    objSubcategoryLoanssMaxFunding.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
            //      objSubcategoryLoanssMaxFunding.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssMaxFunding.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssMaxFunding.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansMaxFunding.transactions != null && ObjLoansMaxFunding.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objMaxFundingTransaction : ObjLoansMaxFunding.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Max Funding Loans';
                            if(objMaxFundingTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objMaxFundingTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objMaxFundingTransaction.strdate;
                            objTransaction.click_text__c = objMaxFundingTransaction.text;
                            if(objMaxFundingTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objMaxFundingTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objMaxFundingTransaction.amount);
                            objTransaction.click_type__c = objMaxFundingTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objMaxFundingTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssMaxFunding);
                }
                if(ObjLoans.MoneyCentre != null)
                {
                    FromBankstatementWrapper.cls_MoneyCentre ObjLoansMoneyCentre = ObjLoans.MoneyCentre;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssMoneyCentre = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssMoneyCentre.Name = 'MoneyCentre';
                    objSubcategoryLoanssMoneyCentre.Dependent__c = 'MoneyCentre';
                    objSubcategoryLoanssMoneyCentre.Click_TransactionCount__c = string.valueof(ObjLoansMoneyCentre.transactionCount);
                    objSubcategoryLoanssMoneyCentre.click_totalValue__c = string.valueof(ObjLoansMoneyCentre.totalValue);
                    objSubcategoryLoanssMoneyCentre.click_monthAvg__c = string.valueof(ObjLoansMoneyCentre.monthAvg);
                    objSubcategoryLoanssMoneyCentre.click_minValue__c = string.valueof(ObjLoansMoneyCentre.minValue);
                    objSubcategoryLoanssMoneyCentre.click_maxValue__c = string.valueof(ObjLoansMoneyCentre.maxValue);
                    objSubcategoryLoanssMoneyCentre.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssMoneyCentre.click_firstTransaction__c = ObjLoansMoneyCentre.firstTransaction;
                    objSubcategoryLoanssMoneyCentre.click_lastTransaction__c = ObjLoansMoneyCentre.lastTransaction;
                    objSubcategoryLoanssMoneyCentre.click_period__c = string.valueof(ObjLoansMoneyCentre.period);
                    objSubcategoryLoanssMoneyCentre.click_periodIsRegular__c = string.valueof(ObjLoansMoneyCentre.periodIsRegular);
                    objSubcategoryLoanssMoneyCentre.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //           objSubcategoryLoanssMoneyCentre.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssMoneyCentre.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssMoneyCentre.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansMoneyCentre.transactions != null && ObjLoansMoneyCentre.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objMoneyCentreTransaction : ObjLoansMoneyCentre.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction MoneyCentre Loans';
                            if(objMoneyCentreTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objMoneyCentreTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objMoneyCentreTransaction.strdate;
                            objTransaction.click_text__c = objMoneyCentreTransaction.text;
                            if(objMoneyCentreTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objMoneyCentreTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objMoneyCentreTransaction.amount);
                            objTransaction.click_type__c = objMoneyCentreTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objMoneyCentreTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssMoneyCentre);
                }
                if(ObjLoans.MoneyMe != null)
                {
                    FromBankstatementWrapper.cls_MoneyMe ObjLoansMoneyMe = ObjLoans.MoneyMe;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssMoneyMe = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssMoneyMe.Name = 'MoneyMe';
                    objSubcategoryLoanssMoneyMe.Dependent__c = 'MoneyMe';
                    objSubcategoryLoanssMoneyMe.Click_TransactionCount__c = string.valueof(ObjLoansMoneyMe.transactionCount);
                    objSubcategoryLoanssMoneyMe.click_totalValue__c = string.valueof(ObjLoansMoneyMe.totalValue);
                    objSubcategoryLoanssMoneyMe.click_monthAvg__c = string.valueof(ObjLoansMoneyMe.monthAvg);
                    objSubcategoryLoanssMoneyMe.click_minValue__c = string.valueof(ObjLoansMoneyMe.minValue);
                    objSubcategoryLoanssMoneyMe.click_maxValue__c = string.valueof(ObjLoansMoneyMe.maxValue);
                    objSubcategoryLoanssMoneyMe.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssMoneyMe.click_firstTransaction__c = ObjLoansMoneyMe.firstTransaction;
                    objSubcategoryLoanssMoneyMe.click_lastTransaction__c = ObjLoansMoneyMe.lastTransaction;
                    objSubcategoryLoanssMoneyMe.click_period__c = string.valueof(ObjLoansMoneyMe.period);
                    objSubcategoryLoanssMoneyMe.click_periodIsRegular__c = string.valueof(ObjLoansMoneyMe.periodIsRegular);
                    objSubcategoryLoanssMoneyMe.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //           objSubcategoryLoanssMoneyMe.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssMoneyMe.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssMoneyMe.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansMoneyMe.transactions != null && ObjLoansMoneyMe.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objMoneyMeTransaction : ObjLoansMoneyMe.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction MoneyMe Loans';
                            if(objMoneyMeTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objMoneyMeTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objMoneyMeTransaction.strdate;
                            objTransaction.click_text__c = objMoneyMeTransaction.text;
                            if(objMoneyMeTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objMoneyMeTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objMoneyMeTransaction.amount);
                            objTransaction.click_type__c = objMoneyMeTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objMoneyMeTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssMoneyMe);
                }
                if(ObjLoans.MoneyNow != null)
                {
                    FromBankstatementWrapper.cls_MoneyNow ObjLoansMoneyNow = ObjLoans.MoneyNow;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssMoneyNow = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssMoneyNow.Name = 'Money Now';
                    objSubcategoryLoanssMoneyNow.Dependent__c = 'Money Now';
                    objSubcategoryLoanssMoneyNow.Click_TransactionCount__c = string.valueof(ObjLoansMoneyNow.transactionCount);
                    objSubcategoryLoanssMoneyNow.click_totalValue__c = string.valueof(ObjLoansMoneyNow.totalValue);
                    objSubcategoryLoanssMoneyNow.click_monthAvg__c = string.valueof(ObjLoansMoneyNow.monthAvg);
                    objSubcategoryLoanssMoneyNow.click_minValue__c = string.valueof(ObjLoansMoneyNow.minValue);
                    objSubcategoryLoanssMoneyNow.click_maxValue__c = string.valueof(ObjLoansMoneyNow.maxValue);
                    objSubcategoryLoanssMoneyNow.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssMoneyNow.click_firstTransaction__c = ObjLoansMoneyNow.firstTransaction;
                    objSubcategoryLoanssMoneyNow.click_lastTransaction__c = ObjLoansMoneyNow.lastTransaction;
                    objSubcategoryLoanssMoneyNow.click_period__c = string.valueof(ObjLoansMoneyNow.period);
                    objSubcategoryLoanssMoneyNow.click_periodIsRegular__c = string.valueof(ObjLoansMoneyNow.periodIsRegular);
                    objSubcategoryLoanssMoneyNow.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //          objSubcategoryLoanssMoneyNow.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssMoneyNow.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssMoneyNow.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansMoneyNow.transactions != null && ObjLoansMoneyNow.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objMoneyNowTransaction : ObjLoansMoneyNow.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Money Now Loans';
                            if(objMoneyNowTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objMoneyNowTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objMoneyNowTransaction.strdate;
                            objTransaction.click_text__c = objMoneyNowTransaction.text;
                            if(objMoneyNowTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objMoneyNowTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objMoneyNowTransaction.amount);
                            objTransaction.click_type__c = objMoneyNowTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objMoneyNowTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssMoneyNow);
                }
                if(ObjLoans.MoneyPlus != null)
                {
                    FromBankstatementWrapper.cls_MoneyPlus ObjLoansMoneyPlus = ObjLoans.MoneyPlus;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssMoneyPlus = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssMoneyPlus.Name = 'MoneyPlus';
                    objSubcategoryLoanssMoneyPlus.Dependent__c = 'MoneyPlus';
                    objSubcategoryLoanssMoneyPlus.Click_TransactionCount__c = string.valueof(ObjLoansMoneyPlus.transactionCount);
                    objSubcategoryLoanssMoneyPlus.click_totalValue__c = string.valueof(ObjLoansMoneyPlus.totalValue);
                    objSubcategoryLoanssMoneyPlus.click_monthAvg__c = string.valueof(ObjLoansMoneyPlus.monthAvg);
                    objSubcategoryLoanssMoneyPlus.click_minValue__c = string.valueof(ObjLoansMoneyPlus.minValue);
                    objSubcategoryLoanssMoneyPlus.click_maxValue__c = string.valueof(ObjLoansMoneyPlus.maxValue);
                    objSubcategoryLoanssMoneyPlus.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssMoneyPlus.click_firstTransaction__c = ObjLoansMoneyPlus.firstTransaction;
                    objSubcategoryLoanssMoneyPlus.click_lastTransaction__c = ObjLoansMoneyPlus.lastTransaction;
                    objSubcategoryLoanssMoneyPlus.click_period__c = string.valueof(ObjLoansMoneyPlus.period);
                    objSubcategoryLoanssMoneyPlus.click_periodIsRegular__c = string.valueof(ObjLoansMoneyPlus.periodIsRegular);
                    objSubcategoryLoanssMoneyPlus.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //          objSubcategoryLoanssMoneyPlus.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssMoneyPlus.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssMoneyPlus.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansMoneyPlus.transactions != null && ObjLoansMoneyPlus.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objMoneyPlusTransaction : ObjLoansMoneyPlus.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction MoneyPlus Loans';
                            if(objMoneyPlusTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objMoneyPlusTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objMoneyPlusTransaction.strdate;
                            objTransaction.click_text__c = objMoneyPlusTransaction.text;
                            if(objMoneyPlusTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objMoneyPlusTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objMoneyPlusTransaction.amount);
                            objTransaction.click_type__c = objMoneyPlusTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objMoneyPlusTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssMoneyPlus);
                }
                if(ObjLoans.Money3 != null)
                {
                    FromBankstatementWrapper.cls_Money3 ObjLoansMoney3 = ObjLoans.Money3;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssMoney3 = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssMoney3.Name = 'Money3';
                    objSubcategoryLoanssMoney3.Dependent__c = 'Money3';
                    objSubcategoryLoanssMoney3.Click_TransactionCount__c = string.valueof(ObjLoansMoney3.transactionCount);
                    objSubcategoryLoanssMoney3.click_totalValue__c = string.valueof(ObjLoansMoney3.totalValue);
                    objSubcategoryLoanssMoney3.click_monthAvg__c = string.valueof(ObjLoansMoney3.monthAvg);
                    objSubcategoryLoanssMoney3.click_minValue__c = string.valueof(ObjLoansMoney3.minValue);
                    objSubcategoryLoanssMoney3.click_maxValue__c = string.valueof(ObjLoansMoney3.maxValue);
                    objSubcategoryLoanssMoney3.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssMoney3.click_firstTransaction__c = ObjLoansMoney3.firstTransaction; 
                    objSubcategoryLoanssMoney3.click_lastTransaction__c = ObjLoansMoney3.lastTransaction;
                    objSubcategoryLoanssMoney3.click_period__c = string.valueof(ObjLoansMoney3.period);
                    objSubcategoryLoanssMoney3.click_periodIsRegular__c = string.valueof(ObjLoansMoney3.periodIsRegular);
                    objSubcategoryLoanssMoney3.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //          objSubcategoryLoanssMoney3.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssMoney3.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssMoney3.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansMoney3.transactions != null && ObjLoansMoney3.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objMoney3Transaction : ObjLoansMoney3.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Money3 Loans';
                            if(objMoney3Transaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objMoney3Transaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objMoney3Transaction.strdate;
                            objTransaction.click_text__c = objMoney3Transaction.text;
                            if(objMoney3Transaction.notes != null)
                            {
                                objTransaction.click_notes__c = objMoney3Transaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objMoney3Transaction.amount);
                            objTransaction.click_type__c = objMoney3Transaction.type;
                            objTransaction.click_balance__c = string.valueOf(objMoney3Transaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssMoney3);
                }
                if(ObjLoans.MoneyStart != null)
                {
                    FromBankstatementWrapper.cls_MoneyStart ObjLoansMoneyStart = ObjLoans.MoneyStart;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssMoneyStart = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssMoneyStart.Name = 'MoneyStart';
                    objSubcategoryLoanssMoneyStart.Dependent__c = 'MoneyStart';
                    objSubcategoryLoanssMoneyStart.Click_TransactionCount__c = string.valueof(ObjLoansMoneyStart.transactionCount);
                    objSubcategoryLoanssMoneyStart.click_totalValue__c = string.valueof(ObjLoansMoneyStart.totalValue);
                    objSubcategoryLoanssMoneyStart.click_monthAvg__c = string.valueof(ObjLoansMoneyStart.monthAvg);
                    objSubcategoryLoanssMoneyStart.click_minValue__c = string.valueof(ObjLoansMoneyStart.minValue);
                    objSubcategoryLoanssMoneyStart.click_maxValue__c = string.valueof(ObjLoansMoneyStart.maxValue);
                    objSubcategoryLoanssMoneyStart.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssMoneyStart.click_firstTransaction__c = ObjLoansMoneyStart.firstTransaction;
                    objSubcategoryLoanssMoneyStart.click_lastTransaction__c = ObjLoansMoneyStart.lastTransaction;
                    objSubcategoryLoanssMoneyStart.click_period__c = string.valueof(ObjLoansMoneyStart.period);
                    objSubcategoryLoanssMoneyStart.click_periodIsRegular__c = string.valueof(ObjLoansMoneyStart.periodIsRegular);
                    objSubcategoryLoanssMoneyStart.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryLoanssMoneyStart.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssMoneyStart.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssMoneyStart.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansMoneyStart.transactions != null && ObjLoansMoneyStart.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objMoneyStartTransaction : ObjLoansMoneyStart.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction MoneyStart Loans';
                            if(objMoneyStartTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objMoneyStartTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objMoneyStartTransaction.strdate;
                            objTransaction.click_text__c = objMoneyStartTransaction.text;
                            if(objMoneyStartTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objMoneyStartTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objMoneyStartTransaction.amount);
                            objTransaction.click_type__c = objMoneyStartTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objMoneyStartTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssMoneyStart);
                }
                if(ObjLoans.MorganFinance != null)
                {
                    FromBankstatementWrapper.cls_MorganFinance ObjLoansMorganFinance = ObjLoans.MorganFinance;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssMorganFinance = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssMorganFinance.Name = 'Morgan Finance';
                    objSubcategoryLoanssMorganFinance.Dependent__c = 'Morgan Finance';
                    objSubcategoryLoanssMorganFinance.Click_TransactionCount__c = string.valueof(ObjLoansMorganFinance.transactionCount);
                    objSubcategoryLoanssMorganFinance.click_totalValue__c = string.valueof(ObjLoansMorganFinance.totalValue);
                    objSubcategoryLoanssMorganFinance.click_monthAvg__c = string.valueof(ObjLoansMorganFinance.monthAvg);
                    objSubcategoryLoanssMorganFinance.click_minValue__c = string.valueof(ObjLoansMorganFinance.minValue);
                    objSubcategoryLoanssMorganFinance.click_maxValue__c = string.valueof(ObjLoansMorganFinance.maxValue);
                    objSubcategoryLoanssMorganFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssMorganFinance.click_firstTransaction__c = ObjLoansMorganFinance.firstTransaction;
                    objSubcategoryLoanssMorganFinance.click_lastTransaction__c = ObjLoansMorganFinance.lastTransaction;
                    objSubcategoryLoanssMorganFinance.click_period__c = string.valueof(ObjLoansMorganFinance.period);
                    objSubcategoryLoanssMorganFinance.click_periodIsRegular__c = string.valueof(ObjLoansMorganFinance.periodIsRegular);
                    objSubcategoryLoanssMorganFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
             //     objSubcategoryLoanssMorganFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssMorganFinance.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssMorganFinance.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansMorganFinance.transactions != null && ObjLoansMorganFinance.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objMorganFinanceTransaction : ObjLoansMorganFinance.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Morgan Finance Loans';
                            if(objMorganFinanceTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objMorganFinanceTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objMorganFinanceTransaction.strdate;
                            objTransaction.click_text__c = objMorganFinanceTransaction.text;
                            if(objMorganFinanceTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objMorganFinanceTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objMorganFinanceTransaction.amount);
                            objTransaction.click_type__c = objMorganFinanceTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objMorganFinanceTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssMorganFinance);
                }
                if(ObjLoans.MyBudget != null)
                {
                    FromBankstatementWrapper.cls_MyBudget ObjLoansMyBudget = ObjLoans.MyBudget;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssMyBudget = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssMyBudget.Name = 'My Budget';
                    objSubcategoryLoanssMyBudget.Dependent__c = 'My Budget';
                    objSubcategoryLoanssMyBudget.Click_TransactionCount__c = string.valueof(ObjLoansMyBudget.transactionCount);
                    objSubcategoryLoanssMyBudget.click_totalValue__c = string.valueof(ObjLoansMyBudget.totalValue);
                    objSubcategoryLoanssMyBudget.click_monthAvg__c = string.valueof(ObjLoansMyBudget.monthAvg);
                    objSubcategoryLoanssMyBudget.click_minValue__c = string.valueof(ObjLoansMyBudget.minValue);
                    objSubcategoryLoanssMyBudget.click_maxValue__c = string.valueof(ObjLoansMyBudget.maxValue);
                    objSubcategoryLoanssMyBudget.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssMyBudget.click_firstTransaction__c = ObjLoansMyBudget.firstTransaction;
                    objSubcategoryLoanssMyBudget.click_lastTransaction__c = ObjLoansMyBudget.lastTransaction;
                    objSubcategoryLoanssMyBudget.click_period__c = string.valueof(ObjLoansMyBudget.period);
                    objSubcategoryLoanssMyBudget.click_periodIsRegular__c = string.valueof(ObjLoansMyBudget.periodIsRegular);
                    objSubcategoryLoanssMyBudget.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //            objSubcategoryLoanssMyBudget.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssMyBudget.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssMyBudget.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansMyBudget.transactions != null && ObjLoansMyBudget.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objMyBudgetTransaction : ObjLoansMyBudget.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction My Budget Loans';
                            if(objMyBudgetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objMyBudgetTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objMyBudgetTransaction.strdate;
                            objTransaction.click_text__c = objMyBudgetTransaction.text;
                            if(objMyBudgetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objMyBudgetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objMyBudgetTransaction.amount);
                            objTransaction.click_type__c = objMyBudgetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objMyBudgetTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssMyBudget);
                }
                if(ObjLoans.NeedyMoney != null)
                {
                    FromBankstatementWrapper.cls_NeedyMoney ObjLoansNeedyMoney = ObjLoans.NeedyMoney;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssNeedyMoney = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssNeedyMoney.Name = 'Needy Money';
                    objSubcategoryLoanssNeedyMoney.Dependent__c = 'Needy Money';
                    objSubcategoryLoanssNeedyMoney.Click_TransactionCount__c = string.valueof(ObjLoansNeedyMoney.transactionCount);
                    objSubcategoryLoanssNeedyMoney.click_totalValue__c = string.valueof(ObjLoansNeedyMoney.totalValue);
                    objSubcategoryLoanssNeedyMoney.click_monthAvg__c = string.valueof(ObjLoansNeedyMoney.monthAvg);
                    objSubcategoryLoanssNeedyMoney.click_minValue__c = string.valueof(ObjLoansNeedyMoney.minValue);
                    objSubcategoryLoanssNeedyMoney.click_maxValue__c = string.valueof(ObjLoansNeedyMoney.maxValue);
                    objSubcategoryLoanssNeedyMoney.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssNeedyMoney.click_firstTransaction__c = ObjLoansNeedyMoney.firstTransaction;
                    objSubcategoryLoanssNeedyMoney.click_lastTransaction__c = ObjLoansNeedyMoney.lastTransaction;
                    objSubcategoryLoanssNeedyMoney.click_period__c = string.valueof(ObjLoansNeedyMoney.period);
                    objSubcategoryLoanssNeedyMoney.click_periodIsRegular__c = string.valueof(ObjLoansNeedyMoney.periodIsRegular);
                    objSubcategoryLoanssNeedyMoney.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssNeedyMoney.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssNeedyMoney.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssNeedyMoney.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansNeedyMoney.transactions != null && ObjLoansNeedyMoney.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objNeedyMoneyTransaction : ObjLoansNeedyMoney.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Needy Money Loans';
                            if(objNeedyMoneyTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objNeedyMoneyTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objNeedyMoneyTransaction.strdate;
                            objTransaction.click_text__c = objNeedyMoneyTransaction.text;
                            if(objNeedyMoneyTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objNeedyMoneyTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objNeedyMoneyTransaction.amount);
                            objTransaction.click_type__c = objNeedyMoneyTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objNeedyMoneyTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssNeedyMoney);
                }
                if(ObjLoans.Nimble != null)
                {
                    FromBankstatementWrapper.cls_Nimble ObjLoansNimble = ObjLoans.Nimble;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssNimble = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssNimble.Name = 'Nimble';
                    objSubcategoryLoanssNimble.Dependent__c = 'Nimble';
                    objSubcategoryLoanssNimble.Click_TransactionCount__c = string.valueof(ObjLoansNimble.transactionCount);
                    objSubcategoryLoanssNimble.click_totalValue__c = string.valueof(ObjLoansNimble.totalValue);
                    objSubcategoryLoanssNimble.click_monthAvg__c = string.valueof(ObjLoansNimble.monthAvg);
                    objSubcategoryLoanssNimble.click_minValue__c = string.valueof(ObjLoansNimble.minValue);
                    objSubcategoryLoanssNimble.click_maxValue__c = string.valueof(ObjLoansNimble.maxValue);
                    objSubcategoryLoanssNimble.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssNimble.click_firstTransaction__c = ObjLoansNimble.firstTransaction;
                    objSubcategoryLoanssNimble.click_lastTransaction__c = ObjLoansNimble.lastTransaction;
                    objSubcategoryLoanssNimble.click_period__c = string.valueof(ObjLoansNimble.period);
                    objSubcategoryLoanssNimble.click_periodIsRegular__c = string.valueof(ObjLoansNimble.periodIsRegular);
                    objSubcategoryLoanssNimble.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssNimble.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssNimble.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssNimble.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansNimble.transactions != null && ObjLoansNimble.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objNimbleTransaction : ObjLoansNimble.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Nimble Loans';
                            if(objNimbleTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objNimbleTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objNimbleTransaction.strdate;
                            objTransaction.click_text__c = objNimbleTransaction.text;
                            if(objNimbleTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objNimbleTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objNimbleTransaction.amount);
                            objTransaction.click_type__c = objNimbleTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objNimbleTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssNimble);
                }
                if(ObjLoans.OKMoney != null)
                {
                    FromBankstatementWrapper.cls_OKMoney ObjLoansOKMoney = ObjLoans.OKMoney;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssOKMoney = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssOKMoney.Name = 'OKMoney';
                    objSubcategoryLoanssOKMoney.Dependent__c = 'OKMoney';
                    objSubcategoryLoanssOKMoney.Click_TransactionCount__c = string.valueof(ObjLoansOKMoney.transactionCount);
                    objSubcategoryLoanssOKMoney.click_totalValue__c = string.valueof(ObjLoansOKMoney.totalValue);
                    objSubcategoryLoanssOKMoney.click_monthAvg__c = string.valueof(ObjLoansOKMoney.monthAvg);
                    objSubcategoryLoanssOKMoney.click_minValue__c = string.valueof(ObjLoansOKMoney.minValue);
                    objSubcategoryLoanssOKMoney.click_maxValue__c = string.valueof(ObjLoansOKMoney.maxValue);
                    objSubcategoryLoanssOKMoney.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssOKMoney.click_firstTransaction__c = ObjLoansOKMoney.firstTransaction;
                    objSubcategoryLoanssOKMoney.click_lastTransaction__c = ObjLoansOKMoney.lastTransaction;
                    objSubcategoryLoanssOKMoney.click_period__c = string.valueof(ObjLoansOKMoney.period);
                    objSubcategoryLoanssOKMoney.click_periodIsRegular__c = string.valueof(ObjLoansOKMoney.periodIsRegular);
                    objSubcategoryLoanssOKMoney.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
            //      objSubcategoryLoanssOKMoney.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssOKMoney.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssOKMoney.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansOKMoney.transactions != null && ObjLoansOKMoney.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objOKMoneyTransaction : ObjLoansOKMoney.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction OKMoney Loans';
                            if(objOKMoneyTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objOKMoneyTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objOKMoneyTransaction.strdate;
                            objTransaction.click_text__c = objOKMoneyTransaction.text;
                            if(objOKMoneyTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objOKMoneyTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objOKMoneyTransaction.amount);
                            objTransaction.click_type__c = objOKMoneyTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objOKMoneyTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssOKMoney);
                }
                if(ObjLoans.PaydayKing != null)
                {
                    FromBankstatementWrapper.cls_PaydayKing ObjLoansPaydayKing = ObjLoans.PaydayKing;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssPaydayKing = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssPaydayKing.Name = 'Payday King';
                    objSubcategoryLoanssPaydayKing.Dependent__c = 'Payday King';
                    objSubcategoryLoanssPaydayKing.Click_TransactionCount__c = string.valueof(ObjLoansPaydayKing.transactionCount);
                    objSubcategoryLoanssPaydayKing.click_totalValue__c = string.valueof(ObjLoansPaydayKing.totalValue);
                    objSubcategoryLoanssPaydayKing.click_monthAvg__c = string.valueof(ObjLoansPaydayKing.monthAvg);
                    objSubcategoryLoanssPaydayKing.click_minValue__c = string.valueof(ObjLoansPaydayKing.minValue);
                    objSubcategoryLoanssPaydayKing.click_maxValue__c = string.valueof(ObjLoansPaydayKing.maxValue);
                    objSubcategoryLoanssPaydayKing.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssPaydayKing.click_firstTransaction__c = ObjLoansPaydayKing.firstTransaction;
                    objSubcategoryLoanssPaydayKing.click_lastTransaction__c = ObjLoansPaydayKing.lastTransaction;
                    objSubcategoryLoanssPaydayKing.click_period__c = string.valueof(ObjLoansPaydayKing.period);
                    objSubcategoryLoanssPaydayKing.click_periodIsRegular__c = string.valueof(ObjLoansPaydayKing.periodIsRegular);
                    objSubcategoryLoanssPaydayKing.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //           objSubcategoryLoanssPaydayKing.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssPaydayKing.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssPaydayKing.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansPaydayKing.transactions != null && ObjLoansPaydayKing.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objPaydayKingTransaction : ObjLoansPaydayKing.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Payday King Loans';
                            if(objPaydayKingTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPaydayKingTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPaydayKingTransaction.strdate;
                            objTransaction.click_text__c = objPaydayKingTransaction.text;
                            if(objPaydayKingTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPaydayKingTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objPaydayKingTransaction.amount);
                            objTransaction.click_type__c = objPaydayKingTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPaydayKingTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssPaydayKing);
                }
                if(ObjLoans.PaydayLand != null)
                {
                    FromBankstatementWrapper.cls_PaydayLand ObjLoansPaydayLand = ObjLoans.PaydayLand;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssPaydayLand = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssPaydayLand.Name = 'Payday Land';
                    objSubcategoryLoanssPaydayLand.Dependent__c = 'Payday Land';
                    objSubcategoryLoanssPaydayLand.Click_TransactionCount__c = string.valueof(ObjLoansPaydayLand.transactionCount);
                    objSubcategoryLoanssPaydayLand.click_totalValue__c = string.valueof(ObjLoansPaydayLand.totalValue);
                    objSubcategoryLoanssPaydayLand.click_monthAvg__c = string.valueof(ObjLoansPaydayLand.monthAvg);
                    objSubcategoryLoanssPaydayLand.click_minValue__c = string.valueof(ObjLoansPaydayLand.minValue);
                    objSubcategoryLoanssPaydayLand.click_maxValue__c = string.valueof(ObjLoansPaydayLand.maxValue);
                    objSubcategoryLoanssPaydayLand.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssPaydayLand.click_firstTransaction__c = ObjLoansPaydayLand.firstTransaction;
                    objSubcategoryLoanssPaydayLand.click_lastTransaction__c = ObjLoansPaydayLand.lastTransaction;
                    objSubcategoryLoanssPaydayLand.click_period__c = string.valueof(ObjLoansPaydayLand.period);
                    objSubcategoryLoanssPaydayLand.click_periodIsRegular__c = string.valueof(ObjLoansPaydayLand.periodIsRegular);
                    objSubcategoryLoanssPaydayLand.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssPaydayLand.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssPaydayLand.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssPaydayLand.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansPaydayLand.transactions != null && ObjLoansPaydayLand.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objPaydayLandTransaction : ObjLoansPaydayLand.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Payday Land Loans';
                            if(objPaydayLandTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPaydayLandTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPaydayLandTransaction.strdate;
                            objTransaction.click_text__c = objPaydayLandTransaction.text;
                            if(objPaydayLandTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPaydayLandTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objPaydayLandTransaction.amount);
                            objTransaction.click_type__c = objPaydayLandTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPaydayLandTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssPaydayLand);
                }
                if(ObjLoans.PaydayMate != null)
                {
                    FromBankstatementWrapper.cls_PaydayMate ObjLoansPaydayMate = ObjLoans.PaydayMate;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssPaydayMate = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssPaydayMate.Name = 'Payday Mate';
                    objSubcategoryLoanssPaydayMate.Dependent__c = 'Payday Mate';
                    objSubcategoryLoanssPaydayMate.Click_TransactionCount__c = string.valueof(ObjLoansPaydayMate.transactionCount);
                    objSubcategoryLoanssPaydayMate.click_totalValue__c = string.valueof(ObjLoansPaydayMate.totalValue);
                    objSubcategoryLoanssPaydayMate.click_monthAvg__c = string.valueof(ObjLoansPaydayMate.monthAvg);
                    objSubcategoryLoanssPaydayMate.click_minValue__c = string.valueof(ObjLoansPaydayMate.minValue);
                    objSubcategoryLoanssPaydayMate.click_maxValue__c = string.valueof(ObjLoansPaydayMate.maxValue);
                    objSubcategoryLoanssPaydayMate.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssPaydayMate.click_firstTransaction__c = ObjLoansPaydayMate.firstTransaction;
                    objSubcategoryLoanssPaydayMate.click_lastTransaction__c = ObjLoansPaydayMate.lastTransaction;
                    objSubcategoryLoanssPaydayMate.click_period__c = string.valueof(ObjLoansPaydayMate.period);
                    objSubcategoryLoanssPaydayMate.click_periodIsRegular__c = string.valueof(ObjLoansPaydayMate.periodIsRegular);
                    objSubcategoryLoanssPaydayMate.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryLoanssPaydayMate.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssPaydayMate.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssPaydayMate.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansPaydayMate.transactions != null && ObjLoansPaydayMate.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objPaydayMateTransaction : ObjLoansPaydayMate.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Payday Mate Loans';
                            if(objPaydayMateTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPaydayMateTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPaydayMateTransaction.strdate;
                            objTransaction.click_text__c = objPaydayMateTransaction.text;
                            if(objPaydayMateTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPaydayMateTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objPaydayMateTransaction.amount);
                            objTransaction.click_type__c = objPaydayMateTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPaydayMateTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssPaydayMate);
                }
                if(ObjLoans.Payday247 != null)
                {
                    FromBankstatementWrapper.cls_Payday247 ObjLoansPayday247 = ObjLoans.Payday247;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssPayday247 = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssPayday247.Name = 'Payday247';
                    objSubcategoryLoanssPayday247.Dependent__c = 'Payday247';
                    objSubcategoryLoanssPayday247.Click_TransactionCount__c = string.valueof(ObjLoansPayday247.transactionCount);
                    objSubcategoryLoanssPayday247.click_totalValue__c = string.valueof(ObjLoansPayday247.totalValue);
                    objSubcategoryLoanssPayday247.click_monthAvg__c = string.valueof(ObjLoansPayday247.monthAvg);
                    objSubcategoryLoanssPayday247.click_minValue__c = string.valueof(ObjLoansPayday247.minValue);
                    objSubcategoryLoanssPayday247.click_maxValue__c = string.valueof(ObjLoansPayday247.maxValue);
                    objSubcategoryLoanssPayday247.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssPayday247.click_firstTransaction__c = ObjLoansPayday247.firstTransaction;
                    objSubcategoryLoanssPayday247.click_lastTransaction__c = ObjLoansPayday247.lastTransaction;
                    objSubcategoryLoanssPayday247.click_period__c = string.valueof(ObjLoansPayday247.period);
                    objSubcategoryLoanssPayday247.click_periodIsRegular__c = string.valueof(ObjLoansPayday247.periodIsRegular);
                    objSubcategoryLoanssPayday247.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //           objSubcategoryLoanssPayday247.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssPayday247.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssPayday247.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansPayday247.transactions != null && ObjLoansPayday247.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objPayday247Transaction : ObjLoansPayday247.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Payday247 Loans';
                            if(objPayday247Transaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPayday247Transaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPayday247Transaction.strdate;
                            objTransaction.click_text__c = objPayday247Transaction.text;
                            if(objPayday247Transaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPayday247Transaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objPayday247Transaction.amount);
                            objTransaction.click_type__c = objPayday247Transaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPayday247Transaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssPayday247);
                }
                if(ObjLoans.PerfectPayday != null)
                {
                    FromBankstatementWrapper.cls_PerfectPayday ObjLoansPerfectPayday = ObjLoans.PerfectPayday;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssPerfectPayday = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssPerfectPayday.Name = 'Perfect Payday';
                    objSubcategoryLoanssPerfectPayday.Dependent__c = 'Perfect Payday';
                    objSubcategoryLoanssPerfectPayday.Click_TransactionCount__c = string.valueof(ObjLoansPerfectPayday.transactionCount);
                    objSubcategoryLoanssPerfectPayday.click_totalValue__c = string.valueof(ObjLoansPerfectPayday.totalValue);
                    objSubcategoryLoanssPerfectPayday.click_monthAvg__c = string.valueof(ObjLoansPerfectPayday.monthAvg);
                    objSubcategoryLoanssPerfectPayday.click_minValue__c = string.valueof(ObjLoansPerfectPayday.minValue);
                    objSubcategoryLoanssPerfectPayday.click_maxValue__c = string.valueof(ObjLoansPerfectPayday.maxValue);
                    objSubcategoryLoanssPerfectPayday.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssPerfectPayday.click_firstTransaction__c = ObjLoansPerfectPayday.firstTransaction;
                    objSubcategoryLoanssPerfectPayday.click_lastTransaction__c = ObjLoansPerfectPayday.lastTransaction;
                    objSubcategoryLoanssPerfectPayday.click_period__c = string.valueof(ObjLoansPerfectPayday.period);
                    objSubcategoryLoanssPerfectPayday.click_periodIsRegular__c = string.valueof(ObjLoansPerfectPayday.periodIsRegular);
                    objSubcategoryLoanssPerfectPayday.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssPerfectPayday.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssPerfectPayday.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssPerfectPayday.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansPerfectPayday.transactions != null && ObjLoansPerfectPayday.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objPerfectPaydayTransaction : ObjLoansPerfectPayday.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Perfect Payday Loans';
                            if(objPerfectPaydayTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPerfectPaydayTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPerfectPaydayTransaction.strdate;
                            objTransaction.click_text__c = objPerfectPaydayTransaction.text;
                            if(objPerfectPaydayTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPerfectPaydayTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objPerfectPaydayTransaction.amount);
                            objTransaction.click_type__c = objPerfectPaydayTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPerfectPaydayTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssPerfectPayday);
                }
                if(ObjLoans.PersonalFinanceCo != null)
                {
                    FromBankstatementWrapper.cls_PersonalFinanceCo ObjLoansPersonalFinanceCo = ObjLoans.PersonalFinanceCo;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssPersonalFinanceCo = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssPersonalFinanceCo.Name = 'Personal Finance Co';
                    objSubcategoryLoanssPersonalFinanceCo.Dependent__c = 'Personal Finance Co';
                    objSubcategoryLoanssPersonalFinanceCo.Click_TransactionCount__c = string.valueof(ObjLoansPersonalFinanceCo.transactionCount);
                    objSubcategoryLoanssPersonalFinanceCo.click_totalValue__c = string.valueof(ObjLoansPersonalFinanceCo.totalValue);
                    objSubcategoryLoanssPersonalFinanceCo.click_monthAvg__c = string.valueof(ObjLoansPersonalFinanceCo.monthAvg);
                    objSubcategoryLoanssPersonalFinanceCo.click_minValue__c = string.valueof(ObjLoansPersonalFinanceCo.minValue);
                    objSubcategoryLoanssPersonalFinanceCo.click_maxValue__c = string.valueof(ObjLoansPersonalFinanceCo.maxValue);
                    objSubcategoryLoanssPersonalFinanceCo.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssPersonalFinanceCo.click_firstTransaction__c = ObjLoansPersonalFinanceCo.firstTransaction;
                    objSubcategoryLoanssPersonalFinanceCo.click_lastTransaction__c = ObjLoansPersonalFinanceCo.lastTransaction;
                    objSubcategoryLoanssPersonalFinanceCo.click_period__c = string.valueof(ObjLoansPersonalFinanceCo.period);
                    objSubcategoryLoanssPersonalFinanceCo.click_periodIsRegular__c = string.valueof(ObjLoansPersonalFinanceCo.periodIsRegular);
                    objSubcategoryLoanssPersonalFinanceCo.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryLoanssPersonalFinanceCo.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssPersonalFinanceCo.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssPersonalFinanceCo.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansPersonalFinanceCo.transactions != null && ObjLoansPersonalFinanceCo.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objPersonalFinanceCoTransaction : ObjLoansPersonalFinanceCo.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Personal Finance Co Loans';
                            if(objPersonalFinanceCoTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPersonalFinanceCoTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPersonalFinanceCoTransaction.strdate;
                            objTransaction.click_text__c = objPersonalFinanceCoTransaction.text;
                            if(objPersonalFinanceCoTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPersonalFinanceCoTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objPersonalFinanceCoTransaction.amount);
                            objTransaction.click_type__c = objPersonalFinanceCoTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPersonalFinanceCoTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssPersonalFinanceCo);
                }
                if(ObjLoans.PrimeLenders != null)
                {
                    FromBankstatementWrapper.cls_PrimeLenders ObjLoansPrimeLenders = ObjLoans.PrimeLenders;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssPrimeLenders = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssPrimeLenders.Name = 'Prime Lenders';
                    objSubcategoryLoanssPrimeLenders.Dependent__c = 'Prime Lenders';
                    objSubcategoryLoanssPrimeLenders.Click_TransactionCount__c = string.valueof(ObjLoansPrimeLenders.transactionCount);
                    objSubcategoryLoanssPrimeLenders.click_totalValue__c = string.valueof(ObjLoansPrimeLenders.totalValue);
                    objSubcategoryLoanssPrimeLenders.click_monthAvg__c = string.valueof(ObjLoansPrimeLenders.monthAvg);
                    objSubcategoryLoanssPrimeLenders.click_minValue__c = string.valueof(ObjLoansPrimeLenders.minValue);
                    objSubcategoryLoanssPrimeLenders.click_maxValue__c = string.valueof(ObjLoansPrimeLenders.maxValue);
                    objSubcategoryLoanssPrimeLenders.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssPrimeLenders.click_firstTransaction__c = ObjLoansPrimeLenders.firstTransaction;
                    objSubcategoryLoanssPrimeLenders.click_lastTransaction__c = ObjLoansPrimeLenders.lastTransaction;
                    objSubcategoryLoanssPrimeLenders.click_period__c = string.valueof(ObjLoansPrimeLenders.period);
                    objSubcategoryLoanssPrimeLenders.click_periodIsRegular__c = string.valueof(ObjLoansPrimeLenders.periodIsRegular);
                    objSubcategoryLoanssPrimeLenders.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
            //      objSubcategoryLoanssPrimeLenders.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssPrimeLenders.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssPrimeLenders.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansPrimeLenders.transactions != null && ObjLoansPrimeLenders.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objPrimeLendersTransaction : ObjLoansPrimeLenders.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Prime Lenders Loans';
                            if(objPrimeLendersTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPrimeLendersTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPrimeLendersTransaction.strdate;
                            objTransaction.click_text__c = objPrimeLendersTransaction.text;
                            if(objPrimeLendersTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPrimeLendersTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objPrimeLendersTransaction.amount);
                            objTransaction.click_type__c = objPrimeLendersTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPrimeLendersTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssPrimeLenders);
                }
                if(ObjLoans.RapidLoans != null)
                {
                    FromBankstatementWrapper.cls_RapidLoans ObjLoansRapidLoans = ObjLoans.RapidLoans;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssRapidLoans = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssRapidLoans.Name = 'Rapid Loans';
                    objSubcategoryLoanssRapidLoans.Dependent__c = 'Rapid Loans';
                    objSubcategoryLoanssRapidLoans.Click_TransactionCount__c = string.valueof(ObjLoansRapidLoans.transactionCount);
                    objSubcategoryLoanssRapidLoans.click_totalValue__c = string.valueof(ObjLoansRapidLoans.totalValue);
                    objSubcategoryLoanssRapidLoans.click_monthAvg__c = string.valueof(ObjLoansRapidLoans.monthAvg);
                    objSubcategoryLoanssRapidLoans.click_minValue__c = string.valueof(ObjLoansRapidLoans.minValue);
                    objSubcategoryLoanssRapidLoans.click_maxValue__c = string.valueof(ObjLoansRapidLoans.maxValue);
                    objSubcategoryLoanssRapidLoans.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssRapidLoans.click_firstTransaction__c = ObjLoansRapidLoans.firstTransaction;
                    objSubcategoryLoanssRapidLoans.click_lastTransaction__c = ObjLoansRapidLoans.lastTransaction;
                    objSubcategoryLoanssRapidLoans.click_period__c = string.valueof(ObjLoansRapidLoans.period);
                    objSubcategoryLoanssRapidLoans.click_periodIsRegular__c = string.valueof(ObjLoansRapidLoans.periodIsRegular);
                    objSubcategoryLoanssRapidLoans.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssRapidLoans.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssRapidLoans.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssRapidLoans.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansRapidLoans.transactions != null && ObjLoansRapidLoans.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objRapidLoansTransaction : ObjLoansRapidLoans.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Rapid Loans Loans';
                            if(objRapidLoansTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objRapidLoansTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objRapidLoansTransaction.strdate;
                            objTransaction.click_text__c = objRapidLoansTransaction.text;
                            if(objRapidLoansTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objRapidLoansTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objRapidLoansTransaction.amount);
                            objTransaction.click_type__c = objRapidLoansTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objRapidLoansTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssRapidLoans);
                }
                if(ObjLoans.SecureFunding != null)
                {
                    FromBankstatementWrapper.cls_SecureFunding ObjLoansSecureFunding = ObjLoans.SecureFunding;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssSecureFunding = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssSecureFunding.Name = 'Secure Funding';
                    objSubcategoryLoanssSecureFunding.Dependent__c = 'Secure Funding';
                    objSubcategoryLoanssSecureFunding.Click_TransactionCount__c = string.valueof(ObjLoansSecureFunding.transactionCount);
                    objSubcategoryLoanssSecureFunding.click_totalValue__c = string.valueof(ObjLoansSecureFunding.totalValue);
                    objSubcategoryLoanssSecureFunding.click_monthAvg__c = string.valueof(ObjLoansSecureFunding.monthAvg);
                    objSubcategoryLoanssSecureFunding.click_minValue__c = string.valueof(ObjLoansSecureFunding.minValue);
                    objSubcategoryLoanssSecureFunding.click_maxValue__c = string.valueof(ObjLoansSecureFunding.maxValue);
                    objSubcategoryLoanssSecureFunding.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssSecureFunding.click_firstTransaction__c = ObjLoansSecureFunding.firstTransaction;
                    objSubcategoryLoanssSecureFunding.click_lastTransaction__c = ObjLoansSecureFunding.lastTransaction;
                    objSubcategoryLoanssSecureFunding.click_period__c = string.valueof(ObjLoansSecureFunding.period);
                    objSubcategoryLoanssSecureFunding.click_periodIsRegular__c = string.valueof(ObjLoansSecureFunding.periodIsRegular);
                    objSubcategoryLoanssSecureFunding.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssSecureFunding.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssSecureFunding.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssSecureFunding.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansSecureFunding.transactions != null && ObjLoansSecureFunding.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objSecureFundingTransaction : ObjLoansSecureFunding.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Secure Funding Loans';
                            if(objSecureFundingTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSecureFundingTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSecureFundingTransaction.strdate;
                            objTransaction.click_text__c = objSecureFundingTransaction.text;
                            if(objSecureFundingTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSecureFundingTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objSecureFundingTransaction.amount);
                            objTransaction.click_type__c = objSecureFundingTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSecureFundingTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssSecureFunding);
                }
                if(ObjLoans.SpeedyFinance != null)
                {
                    FromBankstatementWrapper.cls_SpeedyFinance ObjLoansSpeedyFinance = ObjLoans.SpeedyFinance;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssSpeedyFinance = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssSpeedyFinance.Name = 'Speedy Finance';
                    objSubcategoryLoanssSpeedyFinance.Dependent__c = 'Speedy Finance';
                    objSubcategoryLoanssSpeedyFinance.Click_TransactionCount__c = string.valueof(ObjLoansSpeedyFinance.transactionCount);
                    objSubcategoryLoanssSpeedyFinance.click_totalValue__c = string.valueof(ObjLoansSpeedyFinance.totalValue);
                    objSubcategoryLoanssSpeedyFinance.click_monthAvg__c = string.valueof(ObjLoansSpeedyFinance.monthAvg);
                    objSubcategoryLoanssSpeedyFinance.click_minValue__c = string.valueof(ObjLoansSpeedyFinance.minValue);
                    objSubcategoryLoanssSpeedyFinance.click_maxValue__c = string.valueof(ObjLoansSpeedyFinance.maxValue);
                    objSubcategoryLoanssSpeedyFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssSpeedyFinance.click_firstTransaction__c = ObjLoansSpeedyFinance.firstTransaction;
                    objSubcategoryLoanssSpeedyFinance.click_lastTransaction__c = ObjLoansSpeedyFinance.lastTransaction;
                    objSubcategoryLoanssSpeedyFinance.click_period__c = string.valueof(ObjLoansSpeedyFinance.period);
                    objSubcategoryLoanssSpeedyFinance.click_periodIsRegular__c = string.valueof(ObjLoansSpeedyFinance.periodIsRegular);
                    objSubcategoryLoanssSpeedyFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryLoanssSpeedyFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssSpeedyFinance.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssSpeedyFinance.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansSpeedyFinance.transactions != null && ObjLoansSpeedyFinance.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objSpeedyFinanceTransaction : ObjLoansSpeedyFinance.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Speedy Finance Loans';
                            if(objSpeedyFinanceTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSpeedyFinanceTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSpeedyFinanceTransaction.strdate;
                            objTransaction.click_text__c = objSpeedyFinanceTransaction.text;
                            if(objSpeedyFinanceTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSpeedyFinanceTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objSpeedyFinanceTransaction.amount);
                            objTransaction.click_type__c = objSpeedyFinanceTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSpeedyFinanceTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssSpeedyFinance);
                }
                if(ObjLoans.SpeedyMoney != null)
                {
                    FromBankstatementWrapper.cls_SpeedyMoney ObjLoansSpeedyMoney = ObjLoans.SpeedyMoney;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssSpeedyMoney = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssSpeedyMoney.Name = 'Speedy Money';
                    objSubcategoryLoanssSpeedyMoney.Dependent__c = 'Speedy Money';
                    objSubcategoryLoanssSpeedyMoney.Click_TransactionCount__c = string.valueof(ObjLoansSpeedyMoney.transactionCount);
                    objSubcategoryLoanssSpeedyMoney.click_totalValue__c = string.valueof(ObjLoansSpeedyMoney.totalValue);
                    objSubcategoryLoanssSpeedyMoney.click_monthAvg__c = string.valueof(ObjLoansSpeedyMoney.monthAvg);
                    objSubcategoryLoanssSpeedyMoney.click_minValue__c = string.valueof(ObjLoansSpeedyMoney.minValue);
                    objSubcategoryLoanssSpeedyMoney.click_maxValue__c = string.valueof(ObjLoansSpeedyMoney.maxValue);
                    objSubcategoryLoanssSpeedyMoney.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssSpeedyMoney.click_firstTransaction__c = ObjLoansSpeedyMoney.firstTransaction;
                    objSubcategoryLoanssSpeedyMoney.click_lastTransaction__c = ObjLoansSpeedyMoney.lastTransaction;
                    objSubcategoryLoanssSpeedyMoney.click_period__c = string.valueof(ObjLoansSpeedyMoney.period);
                    objSubcategoryLoanssSpeedyMoney.click_periodIsRegular__c = string.valueof(ObjLoansSpeedyMoney.periodIsRegular);
                    objSubcategoryLoanssSpeedyMoney.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryLoanssSpeedyMoney.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssSpeedyMoney.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssSpeedyMoney.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansSpeedyMoney.transactions != null && ObjLoansSpeedyMoney.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objSpeedyMoneyTransaction : ObjLoansSpeedyMoney.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Speedy Money Loans';
                            if(objSpeedyMoneyTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSpeedyMoneyTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSpeedyMoneyTransaction.strdate;
                            objTransaction.click_text__c = objSpeedyMoneyTransaction.text;
                            if(objSpeedyMoneyTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSpeedyMoneyTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objSpeedyMoneyTransaction.amount);
                            objTransaction.click_type__c = objSpeedyMoneyTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSpeedyMoneyTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssSpeedyMoney);
                }
                if(ObjLoans.SpotLoans != null)
                {
                    FromBankstatementWrapper.cls_SpotLoans ObjLoansSpotLoans = ObjLoans.SpotLoans;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssSpotLoans = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssSpotLoans.Name = 'Spot Loans';
                    objSubcategoryLoanssSpotLoans.Dependent__c = 'Spot Loans';
                    objSubcategoryLoanssSpotLoans.Click_TransactionCount__c = string.valueof(ObjLoansSpotLoans.transactionCount);
                    objSubcategoryLoanssSpotLoans.click_totalValue__c = string.valueof(ObjLoansSpotLoans.totalValue);
                    objSubcategoryLoanssSpotLoans.click_monthAvg__c = string.valueof(ObjLoansSpotLoans.monthAvg);
                    objSubcategoryLoanssSpotLoans.click_minValue__c = string.valueof(ObjLoansSpotLoans.minValue);
                    objSubcategoryLoanssSpotLoans.click_maxValue__c = string.valueof(ObjLoansSpotLoans.maxValue);
                    objSubcategoryLoanssSpotLoans.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssSpotLoans.click_firstTransaction__c = ObjLoansSpotLoans.firstTransaction;
                    objSubcategoryLoanssSpotLoans.click_lastTransaction__c = ObjLoansSpotLoans.lastTransaction;
                    objSubcategoryLoanssSpotLoans.click_period__c = string.valueof(ObjLoansSpotLoans.period);
                    objSubcategoryLoanssSpotLoans.click_periodIsRegular__c = string.valueof(ObjLoansSpotLoans.periodIsRegular);
                    objSubcategoryLoanssSpotLoans.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryLoanssSpotLoans.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssSpotLoans.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssSpotLoans.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansSpotLoans.transactions != null && ObjLoansSpotLoans.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objSpotLoansTransaction : ObjLoansSpotLoans.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Spot Loans Loans';
                            if(objSpotLoansTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSpotLoansTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSpotLoansTransaction.strdate;
                            objTransaction.click_text__c = objSpotLoansTransaction.text;
                            if(objSpotLoansTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSpotLoansTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objSpotLoansTransaction.amount);
                            objTransaction.click_type__c = objSpotLoansTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSpotLoansTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssSpotLoans);
                }
                if(ObjLoans.SRGFinance != null)
                {
                    FromBankstatementWrapper.cls_SRGFinance ObjLoansSRGFinance = ObjLoans.SRGFinance;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssSRGFinance = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssSRGFinance.Name = 'SRG Finance';
                    objSubcategoryLoanssSRGFinance.Dependent__c = 'SRG Finance';
                    objSubcategoryLoanssSRGFinance.Click_TransactionCount__c = string.valueof(ObjLoansSRGFinance.transactionCount);
                    objSubcategoryLoanssSRGFinance.click_totalValue__c = string.valueof(ObjLoansSRGFinance.totalValue);
                    objSubcategoryLoanssSRGFinance.click_monthAvg__c = string.valueof(ObjLoansSRGFinance.monthAvg);
                    objSubcategoryLoanssSRGFinance.click_minValue__c = string.valueof(ObjLoansSRGFinance.minValue);
                    objSubcategoryLoanssSRGFinance.click_maxValue__c = string.valueof(ObjLoansSRGFinance.maxValue);
                    objSubcategoryLoanssSRGFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssSRGFinance.click_firstTransaction__c = ObjLoansSRGFinance.firstTransaction;
                    objSubcategoryLoanssSRGFinance.click_lastTransaction__c = ObjLoansSRGFinance.lastTransaction;
                    objSubcategoryLoanssSRGFinance.click_period__c = string.valueof(ObjLoansSRGFinance.period);
                    objSubcategoryLoanssSRGFinance.click_periodIsRegular__c = string.valueof(ObjLoansSRGFinance.periodIsRegular);
                    objSubcategoryLoanssSRGFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
            //      objSubcategoryLoanssSRGFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssSRGFinance.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssSRGFinance.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansSRGFinance.transactions != null && ObjLoansSRGFinance.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objSRGFinanceTransaction : ObjLoansSRGFinance.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction SRG Finance Loans';
                            if(objSRGFinanceTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSRGFinanceTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSRGFinanceTransaction.strdate;
                            objTransaction.click_text__c = objSRGFinanceTransaction.text;
                            if(objSRGFinanceTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSRGFinanceTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objSRGFinanceTransaction.amount);
                            objTransaction.click_type__c = objSRGFinanceTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSRGFinanceTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssSRGFinance);
                }
                if(ObjLoans.StressLess != null)
                {
                    FromBankstatementWrapper.cls_StressLess ObjLoansStressLess = ObjLoans.StressLess;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssStressLess = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssStressLess.Name = 'Stress Less';
                    objSubcategoryLoanssStressLess.Dependent__c = 'Stress Less';
                    objSubcategoryLoanssStressLess.Click_TransactionCount__c = string.valueof(ObjLoansStressLess.transactionCount);
                    objSubcategoryLoanssStressLess.click_totalValue__c = string.valueof(ObjLoansStressLess.totalValue);
                    objSubcategoryLoanssStressLess.click_monthAvg__c = string.valueof(ObjLoansStressLess.monthAvg);
                    objSubcategoryLoanssStressLess.click_minValue__c = string.valueof(ObjLoansStressLess.minValue);
                    objSubcategoryLoanssStressLess.click_maxValue__c = string.valueof(ObjLoansStressLess.maxValue);
                    objSubcategoryLoanssStressLess.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssStressLess.click_firstTransaction__c = ObjLoansStressLess.firstTransaction;
                    objSubcategoryLoanssStressLess.click_lastTransaction__c = ObjLoansStressLess.lastTransaction;
                    objSubcategoryLoanssStressLess.click_period__c = string.valueof(ObjLoansStressLess.period);
                    objSubcategoryLoanssStressLess.click_periodIsRegular__c = string.valueof(ObjLoansStressLess.periodIsRegular);
                    objSubcategoryLoanssStressLess.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssStressLess.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssStressLess.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssStressLess.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansStressLess.transactions != null && ObjLoansStressLess.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objStressLessTransaction : ObjLoansStressLess.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Stress Less Loans';
                            if(objStressLessTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objStressLessTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objStressLessTransaction.strdate;
                            objTransaction.click_text__c = objStressLessTransaction.text;
                            if(objStressLessTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objStressLessTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objStressLessTransaction.amount);
                            objTransaction.click_type__c = objStressLessTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objStressLessTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssStressLess);
                }
                if(ObjLoans.SunshineLoans != null)
                {
                    FromBankstatementWrapper.cls_SunshineLoans ObjLoansSunshineLoans = ObjLoans.SunshineLoans;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssSunshineLoans = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssSunshineLoans.Name = 'Sunshine Loans';
                    objSubcategoryLoanssSunshineLoans.Dependent__c = 'Sunshine Loans';
                    objSubcategoryLoanssSunshineLoans.Click_TransactionCount__c = string.valueof(ObjLoansSunshineLoans.transactionCount);
                    objSubcategoryLoanssSunshineLoans.click_totalValue__c = string.valueof(ObjLoansSunshineLoans.totalValue);
                    objSubcategoryLoanssSunshineLoans.click_monthAvg__c = string.valueof(ObjLoansSunshineLoans.monthAvg);
                    objSubcategoryLoanssSunshineLoans.click_minValue__c = string.valueof(ObjLoansSunshineLoans.minValue);
                    objSubcategoryLoanssSunshineLoans.click_maxValue__c = string.valueof(ObjLoansSunshineLoans.maxValue);
                    objSubcategoryLoanssSunshineLoans.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssSunshineLoans.click_firstTransaction__c = ObjLoansSunshineLoans.firstTransaction;
                    objSubcategoryLoanssSunshineLoans.click_lastTransaction__c = ObjLoansSunshineLoans.lastTransaction;
                    objSubcategoryLoanssSunshineLoans.click_period__c = string.valueof(ObjLoansSunshineLoans.period);
                    objSubcategoryLoanssSunshineLoans.click_periodIsRegular__c = string.valueof(ObjLoansSunshineLoans.periodIsRegular);
                    objSubcategoryLoanssSunshineLoans.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //          objSubcategoryLoanssSunshineLoans.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssSunshineLoans.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssSunshineLoans.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansSunshineLoans.transactions != null && ObjLoansSunshineLoans.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objSunshineLoansTransaction : ObjLoansSunshineLoans.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Sunshine Loans Loans';
                            if(objSunshineLoansTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSunshineLoansTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSunshineLoansTransaction.strdate;
                            objTransaction.click_text__c = objSunshineLoansTransaction.text;
                            if(objSunshineLoansTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSunshineLoansTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objSunshineLoansTransaction.amount);
                            objTransaction.click_type__c = objSunshineLoansTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSunshineLoansTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssSunshineLoans);
                }
                if(ObjLoans.SwooshFinance != null)
                {
                    FromBankstatementWrapper.cls_SwooshFinance ObjLoansSwooshFinance = ObjLoans.SwooshFinance;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssSwooshFinance = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssSwooshFinance.Name = 'Swoosh Finance';
                    objSubcategoryLoanssSwooshFinance.Dependent__c = 'Swoosh Finance';
                    objSubcategoryLoanssSwooshFinance.Click_TransactionCount__c = string.valueof(ObjLoansSwooshFinance.transactionCount);
                    objSubcategoryLoanssSwooshFinance.click_totalValue__c = string.valueof(ObjLoansSwooshFinance.totalValue);
                    objSubcategoryLoanssSwooshFinance.click_monthAvg__c = string.valueof(ObjLoansSwooshFinance.monthAvg);
                    objSubcategoryLoanssSwooshFinance.click_minValue__c = string.valueof(ObjLoansSwooshFinance.minValue);
                    objSubcategoryLoanssSwooshFinance.click_maxValue__c = string.valueof(ObjLoansSwooshFinance.maxValue);
                    objSubcategoryLoanssSwooshFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssSwooshFinance.click_firstTransaction__c = ObjLoansSwooshFinance.firstTransaction;
                    objSubcategoryLoanssSwooshFinance.click_lastTransaction__c = ObjLoansSwooshFinance.lastTransaction;
                    objSubcategoryLoanssSwooshFinance.click_period__c = string.valueof(ObjLoansSwooshFinance.period);
                    objSubcategoryLoanssSwooshFinance.click_periodIsRegular__c = string.valueof(ObjLoansSwooshFinance.periodIsRegular);
                    objSubcategoryLoanssSwooshFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //          objSubcategoryLoanssSwooshFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssSwooshFinance.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssSwooshFinance.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansSwooshFinance.transactions != null && ObjLoansSwooshFinance.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objSwooshFinanceTransaction : ObjLoansSwooshFinance.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Swoosh Finance Loans';
                            if(objSwooshFinanceTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSwooshFinanceTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSwooshFinanceTransaction.strdate;
                            objTransaction.click_text__c = objSwooshFinanceTransaction.text;
                            if(objSwooshFinanceTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSwooshFinanceTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objSwooshFinanceTransaction.amount);
                            objTransaction.click_type__c = objSwooshFinanceTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSwooshFinanceTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssSwooshFinance);
                }
                if(ObjLoans.TeleLoans != null)
                {
                    FromBankstatementWrapper.cls_TeleLoans ObjLoansTeleLoans = ObjLoans.TeleLoans;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssTeleLoans = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssTeleLoans.Name = 'Tele Loans';
                    objSubcategoryLoanssTeleLoans.Dependent__c = 'Tele Loans';
                    objSubcategoryLoanssTeleLoans.Click_TransactionCount__c = string.valueof(ObjLoansTeleLoans.transactionCount);
                    objSubcategoryLoanssTeleLoans.click_totalValue__c = string.valueof(ObjLoansTeleLoans.totalValue);
                    objSubcategoryLoanssTeleLoans.click_monthAvg__c = string.valueof(ObjLoansTeleLoans.monthAvg);
                    objSubcategoryLoanssTeleLoans.click_minValue__c = string.valueof(ObjLoansTeleLoans.minValue);
                    objSubcategoryLoanssTeleLoans.click_maxValue__c = string.valueof(ObjLoansTeleLoans.maxValue);
                    objSubcategoryLoanssTeleLoans.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssTeleLoans.click_firstTransaction__c = ObjLoansTeleLoans.firstTransaction;
                    objSubcategoryLoanssTeleLoans.click_lastTransaction__c = ObjLoansTeleLoans.lastTransaction;
                    objSubcategoryLoanssTeleLoans.click_period__c = string.valueof(ObjLoansTeleLoans.period);
                    objSubcategoryLoanssTeleLoans.click_periodIsRegular__c = string.valueof(ObjLoansTeleLoans.periodIsRegular);
                    objSubcategoryLoanssTeleLoans.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssTeleLoans.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssTeleLoans.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssTeleLoans.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansTeleLoans.transactions != null && ObjLoansTeleLoans.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objTeleLoansTransaction : ObjLoansTeleLoans.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Tele Loans Loans';
                            if(objTeleLoansTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objTeleLoansTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objTeleLoansTransaction.strdate;
                            objTransaction.click_text__c = objTeleLoansTransaction.text;
                            if(objTeleLoansTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objTeleLoansTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objTeleLoansTransaction.amount);
                            objTransaction.click_type__c = objTeleLoansTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objTeleLoansTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssTeleLoans);
                }
                if(ObjLoans.Thorn != null)
                {
                    FromBankstatementWrapper.cls_Thorn ObjLoansThorn = ObjLoans.Thorn;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssThorn = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssThorn.Name = 'Thorn';
                    objSubcategoryLoanssThorn.Dependent__c = 'Thorn';
                    objSubcategoryLoanssThorn.Click_TransactionCount__c = string.valueof(ObjLoansThorn.transactionCount);
                    objSubcategoryLoanssThorn.click_totalValue__c = string.valueof(ObjLoansThorn.totalValue);
                    objSubcategoryLoanssThorn.click_monthAvg__c = string.valueof(ObjLoansThorn.monthAvg);
                    objSubcategoryLoanssThorn.click_minValue__c = string.valueof(ObjLoansThorn.minValue);
                    objSubcategoryLoanssThorn.click_maxValue__c = string.valueof(ObjLoansThorn.maxValue);
                    objSubcategoryLoanssThorn.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssThorn.click_firstTransaction__c = ObjLoansThorn.firstTransaction;
                    objSubcategoryLoanssThorn.click_lastTransaction__c = ObjLoansThorn.lastTransaction;
                    objSubcategoryLoanssThorn.click_period__c = string.valueof(ObjLoansThorn.period);
                    objSubcategoryLoanssThorn.click_periodIsRegular__c = string.valueof(ObjLoansThorn.periodIsRegular);
                    objSubcategoryLoanssThorn.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssThorn.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssThorn.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssThorn.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansThorn.transactions != null && ObjLoansThorn.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objThornTransaction : ObjLoansThorn.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Thorn Loans';
                            if(objThornTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objThornTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objThornTransaction.strdate;
                            objTransaction.click_text__c = objThornTransaction.text;
                            if(objThornTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objThornTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objThornTransaction.amount);
                            objTransaction.click_type__c = objThornTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objThornTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssThorn);
                }
                if(ObjLoans.VictoryFunding != null)
                {
                    FromBankstatementWrapper.cls_VictoryFunding ObjLoansVictoryFunding = ObjLoans.VictoryFunding;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssVictoryFunding = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssVictoryFunding.Name = 'Victory Funding';
                    objSubcategoryLoanssVictoryFunding.Dependent__c = 'Victory Funding';
                    objSubcategoryLoanssVictoryFunding.Click_TransactionCount__c = string.valueof(ObjLoansVictoryFunding.transactionCount);
                    objSubcategoryLoanssVictoryFunding.click_totalValue__c = string.valueof(ObjLoansVictoryFunding.totalValue);
                    objSubcategoryLoanssVictoryFunding.click_monthAvg__c = string.valueof(ObjLoansVictoryFunding.monthAvg);
                    objSubcategoryLoanssVictoryFunding.click_minValue__c = string.valueof(ObjLoansVictoryFunding.minValue);
                    objSubcategoryLoanssVictoryFunding.click_maxValue__c = string.valueof(ObjLoansVictoryFunding.maxValue);
                    objSubcategoryLoanssVictoryFunding.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssVictoryFunding.click_firstTransaction__c = ObjLoansVictoryFunding.firstTransaction;
                    objSubcategoryLoanssVictoryFunding.click_lastTransaction__c = ObjLoansVictoryFunding.lastTransaction;
                    objSubcategoryLoanssVictoryFunding.click_period__c = string.valueof(ObjLoansVictoryFunding.period);
                    objSubcategoryLoanssVictoryFunding.click_periodIsRegular__c = string.valueof(ObjLoansVictoryFunding.periodIsRegular);
                    objSubcategoryLoanssVictoryFunding.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
            //      objSubcategoryLoanssVictoryFunding.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssVictoryFunding.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssVictoryFunding.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansVictoryFunding.transactions != null && ObjLoansVictoryFunding.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objVictoryFundingTransaction : ObjLoansVictoryFunding.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Victory Funding Loans';
                            if(objVictoryFundingTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objVictoryFundingTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objVictoryFundingTransaction.strdate;
                            objTransaction.click_text__c = objVictoryFundingTransaction.text;
                            if(objVictoryFundingTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objVictoryFundingTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objVictoryFundingTransaction.amount);
                            objTransaction.click_type__c = objVictoryFundingTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objVictoryFundingTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssVictoryFunding);
                }
                if(ObjLoans.WebMoneyline != null)
                {
                    FromBankstatementWrapper.cls_WebMoneyline ObjLoansWebMoneyline = ObjLoans.WebMoneyline;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssWebMoneyline = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssWebMoneyline.Name = 'Web Moneyline';
                    objSubcategoryLoanssWebMoneyline.Dependent__c = 'Web Moneyline';
                    objSubcategoryLoanssWebMoneyline.Click_TransactionCount__c = string.valueof(ObjLoansWebMoneyline.transactionCount);
                    objSubcategoryLoanssWebMoneyline.click_totalValue__c = string.valueof(ObjLoansWebMoneyline.totalValue);
                    objSubcategoryLoanssWebMoneyline.click_monthAvg__c = string.valueof(ObjLoansWebMoneyline.monthAvg);
                    objSubcategoryLoanssWebMoneyline.click_minValue__c = string.valueof(ObjLoansWebMoneyline.minValue);
                    objSubcategoryLoanssWebMoneyline.click_maxValue__c = string.valueof(ObjLoansWebMoneyline.maxValue);
                    objSubcategoryLoanssWebMoneyline.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssWebMoneyline.click_firstTransaction__c = ObjLoansWebMoneyline.firstTransaction;
                    objSubcategoryLoanssWebMoneyline.click_lastTransaction__c = ObjLoansWebMoneyline.lastTransaction;
                    objSubcategoryLoanssWebMoneyline.click_period__c = string.valueof(ObjLoansWebMoneyline.period);
                    objSubcategoryLoanssWebMoneyline.click_periodIsRegular__c = string.valueof(ObjLoansWebMoneyline.periodIsRegular);
                    objSubcategoryLoanssWebMoneyline.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //          objSubcategoryLoanssWebMoneyline.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssWebMoneyline.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssWebMoneyline.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansWebMoneyline.transactions != null && ObjLoansWebMoneyline.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objWebMoneylineTransaction : ObjLoansWebMoneyline.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Web Moneyline Loans';
                            if(objWebMoneylineTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objWebMoneylineTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objWebMoneylineTransaction.strdate;
                            objTransaction.click_text__c = objWebMoneylineTransaction.text;
                            if(objWebMoneylineTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objWebMoneylineTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objWebMoneylineTransaction.amount);
                            objTransaction.click_type__c = objWebMoneylineTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objWebMoneylineTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssWebMoneyline);
                }
                if(ObjLoans.YesLoans != null)
                {
                    FromBankstatementWrapper.cls_YesLoans ObjLoansYesLoans = ObjLoans.YesLoans;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssYesLoans = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssYesLoans.Name = 'Yes Loans';
                    objSubcategoryLoanssYesLoans.Dependent__c = 'Yes Loans';
                    objSubcategoryLoanssYesLoans.Click_TransactionCount__c = string.valueof(ObjLoansYesLoans.transactionCount);
                    objSubcategoryLoanssYesLoans.click_totalValue__c = string.valueof(ObjLoansYesLoans.totalValue);
                    objSubcategoryLoanssYesLoans.click_monthAvg__c = string.valueof(ObjLoansYesLoans.monthAvg);
                    objSubcategoryLoanssYesLoans.click_minValue__c = string.valueof(ObjLoansYesLoans.minValue);
                    objSubcategoryLoanssYesLoans.click_maxValue__c = string.valueof(ObjLoansYesLoans.maxValue);
                    objSubcategoryLoanssYesLoans.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssYesLoans.click_firstTransaction__c = ObjLoansYesLoans.firstTransaction;
                    objSubcategoryLoanssYesLoans.click_lastTransaction__c = ObjLoansYesLoans.lastTransaction;
                    objSubcategoryLoanssYesLoans.click_period__c = string.valueof(ObjLoansYesLoans.period);
                    objSubcategoryLoanssYesLoans.click_periodIsRegular__c = string.valueof(ObjLoansYesLoans.periodIsRegular);
                    objSubcategoryLoanssYesLoans.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryLoanssYesLoans.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssYesLoans.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssYesLoans.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansYesLoans.transactions != null && ObjLoansYesLoans.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objYesLoansTransaction : ObjLoansYesLoans.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Yes Loans Loans';
                            if(objYesLoansTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objYesLoansTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objYesLoansTransaction.strdate;
                            objTransaction.click_text__c = objYesLoansTransaction.text;
                            if(objYesLoansTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objYesLoansTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objYesLoansTransaction.amount);
                            objTransaction.click_type__c = objYesLoansTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objYesLoansTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssYesLoans);
                }
                if(ObjLoans.CollectionHouse != null)
                {
                    FromBankstatementWrapper.cls_CollectionHouse ObjLoansCollectionHouse = ObjLoans.CollectionHouse;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCollectionHouse = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssCollectionHouse.Name = 'Collection House';
                    objSubcategoryLoanssCollectionHouse.Dependent__c = 'Collection House';
                    objSubcategoryLoanssCollectionHouse.Click_TransactionCount__c = string.valueof(ObjLoansCollectionHouse.transactionCount);
                    objSubcategoryLoanssCollectionHouse.click_totalValue__c = string.valueof(ObjLoansCollectionHouse.totalValue);
                    objSubcategoryLoanssCollectionHouse.click_monthAvg__c = string.valueof(ObjLoansCollectionHouse.monthAvg);
                    objSubcategoryLoanssCollectionHouse.click_minValue__c = string.valueof(ObjLoansCollectionHouse.minValue);
                    objSubcategoryLoanssCollectionHouse.click_maxValue__c = string.valueof(ObjLoansCollectionHouse.maxValue);
                    objSubcategoryLoanssCollectionHouse.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssCollectionHouse.click_firstTransaction__c = ObjLoansCollectionHouse.firstTransaction;
                    objSubcategoryLoanssCollectionHouse.click_lastTransaction__c = ObjLoansCollectionHouse.lastTransaction;
                    objSubcategoryLoanssCollectionHouse.click_period__c = string.valueof(ObjLoansCollectionHouse.period);
                    objSubcategoryLoanssCollectionHouse.click_periodIsRegular__c = string.valueof(ObjLoansCollectionHouse.periodIsRegular);
                    objSubcategoryLoanssCollectionHouse.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
   //               objSubcategoryLoanssCollectionHouse.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssCollectionHouse.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssCollectionHouse.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansCollectionHouse.transactions != null && ObjLoansCollectionHouse.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objCollectionHouseTransaction : ObjLoansCollectionHouse.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Collection House Loans';
                            if(objCollectionHouseTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objCollectionHouseTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objCollectionHouseTransaction.strdate;
                            objTransaction.click_text__c = objCollectionHouseTransaction.text;
                            if(objCollectionHouseTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objCollectionHouseTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objCollectionHouseTransaction.amount);
                            objTransaction.click_type__c = objCollectionHouseTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objCollectionHouseTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssCollectionHouse);
                }
                if(ObjLoans.ToyotaFinance != null)
                {
                    FromBankstatementWrapper.cls_ToyotaFinance ObjLoansToyotaFinance = ObjLoans.ToyotaFinance;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssToyotaFinance = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssToyotaFinance.Name = 'Toyota Finance';
                    objSubcategoryLoanssToyotaFinance.Dependent__c = 'Toyota Finance';
                    objSubcategoryLoanssToyotaFinance.Click_TransactionCount__c = string.valueof(ObjLoansToyotaFinance.transactionCount);
                    objSubcategoryLoanssToyotaFinance.click_totalValue__c = string.valueof(ObjLoansToyotaFinance.totalValue);
                    objSubcategoryLoanssToyotaFinance.click_monthAvg__c = string.valueof(ObjLoansToyotaFinance.monthAvg);
                    objSubcategoryLoanssToyotaFinance.click_minValue__c = string.valueof(ObjLoansToyotaFinance.minValue);
                    objSubcategoryLoanssToyotaFinance.click_maxValue__c = string.valueof(ObjLoansToyotaFinance.maxValue);
                    objSubcategoryLoanssToyotaFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssToyotaFinance.click_firstTransaction__c = ObjLoansToyotaFinance.firstTransaction;
                    objSubcategoryLoanssToyotaFinance.click_lastTransaction__c = ObjLoansToyotaFinance.lastTransaction;
                    objSubcategoryLoanssToyotaFinance.click_period__c = string.valueof(ObjLoansToyotaFinance.period);
                    objSubcategoryLoanssToyotaFinance.click_periodIsRegular__c = string.valueof(ObjLoansToyotaFinance.periodIsRegular);
                    objSubcategoryLoanssToyotaFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssToyotaFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssToyotaFinance.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssToyotaFinance.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansToyotaFinance.transactions != null && ObjLoansToyotaFinance.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objToyotaFinanceTransaction : ObjLoansToyotaFinance.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Toyota Finance Loans';
                            if(objToyotaFinanceTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objToyotaFinanceTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objToyotaFinanceTransaction.strdate;
                            objTransaction.click_text__c = objToyotaFinanceTransaction.text;
                            if(objToyotaFinanceTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objToyotaFinanceTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objToyotaFinanceTransaction.amount);
                            objTransaction.click_type__c = objToyotaFinanceTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objToyotaFinanceTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssToyotaFinance);
                }
                if(ObjLoans.ImpactFinancial != null)
                {
                    FromBankstatementWrapper.cls_ImpactFinancial ObjLoansImpactFinancial = ObjLoans.ImpactFinancial;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssImpactFinancial = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssImpactFinancial.Name = 'Impact Financial';
                    objSubcategoryLoanssImpactFinancial.Dependent__c = 'Impact Financial';
                    objSubcategoryLoanssImpactFinancial.Click_TransactionCount__c = string.valueof(ObjLoansImpactFinancial.transactionCount);
                    objSubcategoryLoanssImpactFinancial.click_totalValue__c = string.valueof(ObjLoansImpactFinancial.totalValue);
                    objSubcategoryLoanssImpactFinancial.click_monthAvg__c = string.valueof(ObjLoansImpactFinancial.monthAvg);
                    objSubcategoryLoanssImpactFinancial.click_minValue__c = string.valueof(ObjLoansImpactFinancial.minValue);
                    objSubcategoryLoanssImpactFinancial.click_maxValue__c = string.valueof(ObjLoansImpactFinancial.maxValue);
                    objSubcategoryLoanssImpactFinancial.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssImpactFinancial.click_firstTransaction__c = ObjLoansImpactFinancial.firstTransaction;
                    objSubcategoryLoanssImpactFinancial.click_lastTransaction__c = ObjLoansImpactFinancial.lastTransaction;
                    objSubcategoryLoanssImpactFinancial.click_period__c = string.valueof(ObjLoansImpactFinancial.period);
                    objSubcategoryLoanssImpactFinancial.click_periodIsRegular__c = string.valueof(ObjLoansImpactFinancial.periodIsRegular);
                    objSubcategoryLoanssImpactFinancial.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryLoanssImpactFinancial.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssImpactFinancial.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssImpactFinancial.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansImpactFinancial.transactions != null && ObjLoansImpactFinancial.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objImpactFinancialTransaction : ObjLoansImpactFinancial.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Impact Financial Loans';
                            if(objImpactFinancialTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objImpactFinancialTransaction.strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objImpactFinancialTransaction.strdate;
                            objTransaction.click_text__c = objImpactFinancialTransaction.text;
                            if(objImpactFinancialTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objImpactFinancialTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objImpactFinancialTransaction.amount);
                            objTransaction.click_type__c = objImpactFinancialTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objImpactFinancialTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssImpactFinancial);
                }
                if(ObjLoans.YamahaMotorFinance != null)
                {
                    FromBankstatementWrapper.cls_YamahaMotorFinance ObjLoansYamahaMotorFinance = ObjLoans.YamahaMotorFinance;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssYamahaMotorFinance = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssYamahaMotorFinance.Name = 'Yamaha Motor Finance';
                    objSubcategoryLoanssYamahaMotorFinance.Dependent__c = 'Yamaha Motor Finance';
                    objSubcategoryLoanssYamahaMotorFinance.Click_TransactionCount__c = string.valueof(ObjLoansYamahaMotorFinance.transactionCount);
                    objSubcategoryLoanssYamahaMotorFinance.click_totalValue__c = string.valueof(ObjLoansYamahaMotorFinance.totalValue);
                    objSubcategoryLoanssYamahaMotorFinance.click_monthAvg__c = string.valueof(ObjLoansYamahaMotorFinance.monthAvg);
                    objSubcategoryLoanssYamahaMotorFinance.click_minValue__c = string.valueof(ObjLoansYamahaMotorFinance.minValue);
                    objSubcategoryLoanssYamahaMotorFinance.click_maxValue__c = string.valueof(ObjLoansYamahaMotorFinance.maxValue);
                    objSubcategoryLoanssYamahaMotorFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssYamahaMotorFinance.click_firstTransaction__c = ObjLoansYamahaMotorFinance.firstTransaction;
                    objSubcategoryLoanssYamahaMotorFinance.click_lastTransaction__c = ObjLoansYamahaMotorFinance.lastTransaction;
                    objSubcategoryLoanssYamahaMotorFinance.click_period__c = string.valueof(ObjLoansYamahaMotorFinance.period);
                    objSubcategoryLoanssYamahaMotorFinance.click_periodIsRegular__c = string.valueof(ObjLoansYamahaMotorFinance.periodIsRegular);
                    objSubcategoryLoanssYamahaMotorFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
            //      objSubcategoryLoanssYamahaMotorFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssYamahaMotorFinance.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssYamahaMotorFinance.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansYamahaMotorFinance.transactions != null && ObjLoansYamahaMotorFinance.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objYamahaMotorFinanceTransaction : ObjLoansYamahaMotorFinance.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Yamaha Motor Finance Loans';
                            if(objYamahaMotorFinanceTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objYamahaMotorFinanceTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objYamahaMotorFinanceTransaction.strdate;
                            objTransaction.click_text__c = objYamahaMotorFinanceTransaction.text;
                            if(objYamahaMotorFinanceTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objYamahaMotorFinanceTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objYamahaMotorFinanceTransaction.amount);
                            objTransaction.click_type__c = objYamahaMotorFinanceTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objYamahaMotorFinanceTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssYamahaMotorFinance);
                }
                if(ObjLoans.HomeLoan != null)
                {
                    FromBankstatementWrapper.cls_HomeLoan ObjLoansHomeLoan = ObjLoans.HomeLoan;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssHomeLoan = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssHomeLoan.Name = 'Home Loan';
                    objSubcategoryLoanssHomeLoan.Dependent__c = 'Home Loan';
                    objSubcategoryLoanssHomeLoan.Click_TransactionCount__c = string.valueof(ObjLoansHomeLoan.transactionCount);
                    objSubcategoryLoanssHomeLoan.click_totalValue__c = string.valueof(ObjLoansHomeLoan.totalValue);
                    objSubcategoryLoanssHomeLoan.click_monthAvg__c = string.valueof(ObjLoansHomeLoan.monthAvg);
                    objSubcategoryLoanssHomeLoan.click_minValue__c = string.valueof(ObjLoansHomeLoan.minValue);
                    objSubcategoryLoanssHomeLoan.click_maxValue__c = string.valueof(ObjLoansHomeLoan.maxValue);
                    objSubcategoryLoanssHomeLoan.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssHomeLoan.click_firstTransaction__c = ObjLoansHomeLoan.firstTransaction;
                    objSubcategoryLoanssHomeLoan.click_lastTransaction__c = ObjLoansHomeLoan.lastTransaction;
                    objSubcategoryLoanssHomeLoan.click_period__c = string.valueof(ObjLoansHomeLoan.period);
                    objSubcategoryLoanssHomeLoan.click_periodIsRegular__c = string.valueof(ObjLoansHomeLoan.periodIsRegular);
                    objSubcategoryLoanssHomeLoan.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryLoanssHomeLoan.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssHomeLoan.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssHomeLoan.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansHomeLoan.transactions != null && ObjLoansHomeLoan.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objHomeLoanTransaction : ObjLoansHomeLoan.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Home Loan Loans';
                            if(objHomeLoanTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objHomeLoanTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objHomeLoanTransaction.strdate;
                            objTransaction.click_text__c = objHomeLoanTransaction.text;
                            if(objHomeLoanTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objHomeLoanTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objHomeLoanTransaction.amount);
                            objTransaction.click_type__c = objHomeLoanTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objHomeLoanTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                    SubcategoryIndex++;
                    lstSubctegory.add(objSubcategoryLoanssHomeLoan);
                }
                if(ObjLoans.Generic != null)
                {
                    FromBankstatementWrapper.cls_Generic ObjLoansGeneric = ObjLoans.Generic;
                    click_Bank_Statements_Sub_Category__c objSubcategoryLoanssGeneric = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryLoanssGeneric.Name = 'Generic';
                    objSubcategoryLoanssGeneric.Dependent__c = 'Generic';
                    objSubcategoryLoanssGeneric.Click_TransactionCount__c = string.valueof(ObjLoansGeneric.transactionCount);
                    objSubcategoryLoanssGeneric.click_totalValue__c = string.valueof(ObjLoansGeneric.totalValue);
                    objSubcategoryLoanssGeneric.click_monthAvg__c = string.valueof(ObjLoansGeneric.monthAvg);
                    objSubcategoryLoanssGeneric.click_minValue__c = string.valueof(ObjLoansGeneric.minValue);
                    objSubcategoryLoanssGeneric.click_maxValue__c = string.valueof(ObjLoansGeneric.maxValue);
                    objSubcategoryLoanssGeneric.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryLoanssGeneric.click_firstTransaction__c = ObjLoansGeneric.firstTransaction;
                    objSubcategoryLoanssGeneric.click_lastTransaction__c = ObjLoansGeneric.lastTransaction;
                    objSubcategoryLoanssGeneric.click_period__c = string.valueof(ObjLoansGeneric.period);
                    objSubcategoryLoanssGeneric.click_periodIsRegular__c = string.valueof(ObjLoansGeneric.periodIsRegular);
                    objSubcategoryLoanssGeneric.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryLoanssGeneric.Click_Bank_Statements_Account__c = objBankStatementAccId;
                    objSubcategoryLoanssGeneric.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryLoanssGeneric.Click_Required_Document_Id__c = ReqDocId;
                    if(ObjLoansGeneric.transactions != null && ObjLoansGeneric.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objGenericTransaction : ObjLoansGeneric.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Generic Loans';
                            if(objGenericTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objGenericTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objGenericTransaction.strdate;
                            objTransaction.click_text__c = objGenericTransaction.text;
                            if(objGenericTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objGenericTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objGenericTransaction.amount);
                            objTransaction.click_type__c = objGenericTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objGenericTransaction.balance);
                            objTransaction.Click_Statement_No__c = string.valueOf(CategoryIndex);
                            objTransaction.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                            objTransaction.Click_Transaction_No__c = string.valueOf(TransactionIndex);
                            objTransaction.Bank_Statement_Account_Number__c = AccountNumber;
                            if(string.isNotEmpty(ReqDocId))
                            objTransaction.Click_Required_Document_Id__c = ReqDocId;
                            lstTransaction.add(objTransaction);
                            TransactionIndex++;
                        }
                    }
                        SubcategoryIndex++;
                        lstSubctegory.add(objSubcategoryLoanssGeneric);
                }
                lstctegory.add(objBankStatementData);
                CategoryIndex++;
            }
        }