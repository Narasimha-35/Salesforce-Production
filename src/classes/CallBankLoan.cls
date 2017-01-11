Public class CallBankLoan
{
    public static void CallLoans(FromBankstatementWrapper.cls_analysis objanalysis,integer SubcategoryIndex,integer CategoryIndex,integer TransactionIndex,List<click_Bank_Statements_Sub_Category__c> lstSubctegory,List<click_Bank_Statement_Data__c> lstctegory,List<click_Bank_Statements_Transactions__c> lstTransaction,string AccountNumber,string ReqDocId)
    {
         if(objanalysis.Loans != null)
        {
            click_Bank_Statement_Data__c objBankStatementData = new click_Bank_Statement_Data__c();
            objBankStatementData.Name = 'Loans';
            objBankStatementData.Click_Statement_No__c = string.valueof(CategoryIndex);
            objBankStatementData.Bank_Statement_Account_Number__c = AccountNumber;
            if(string.isNotEmpty(ReqDocId))
            objBankStatementData.Click_Required_Document_Id__c = ReqDocId;
                        
            FromBankstatementWrapper.cls_Loans ObjLoans = objanalysis.Loans;
            if(ObjLoans.total != null)
            {
                FromBankstatementWrapper.cls_total ObjLoansTotal = ObjLoans.total;
                objBankStatementData.Click_TransactionCount__c = string.valueof(ObjLoansTotal.transactionCount);
                objBankStatementData.click_totalValue__c = string.valueof(ObjLoansTotal.totalValue);
                objBankStatementData.click_monthAvg__c = string.valueof(ObjLoansTotal.monthAvg);
            }
            if(ObjLoans.AmazingLoans != null)
            {
                FromBankstatementWrapper.cls_AmazingLoans ObjLoansAmazingLoans = ObjLoans.AmazingLoans;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssAmazingLoans = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssAmazingLoans.Name = 'Amazing Loans';
                objSubcategoryLoanssAmazingLoans.Dependent__c = 'Amazing Loans';
                objSubcategoryLoanssAmazingLoans.Click_TransactionCount__c = string.valueof(ObjLoansAmazingLoans.transactionCount);
                objSubcategoryLoanssAmazingLoans.click_totalValue__c = string.valueof(ObjLoansAmazingLoans.totalValue);
                objSubcategoryLoanssAmazingLoans.click_monthAvg__c = string.valueof(ObjLoansAmazingLoans.monthAvg);
                objSubcategoryLoanssAmazingLoans.click_minValue__c = string.valueof(ObjLoansAmazingLoans.minValue);
                objSubcategoryLoanssAmazingLoans.click_maxValue__c = string.valueof(ObjLoansAmazingLoans.maxValue);
                objSubcategoryLoanssAmazingLoans.click_firstTransaction__c = ObjLoansAmazingLoans.firstTransaction;
                objSubcategoryLoanssAmazingLoans.click_lastTransaction__c = ObjLoansAmazingLoans.lastTransaction;
                objSubcategoryLoanssAmazingLoans.click_period__c = string.valueof(ObjLoansAmazingLoans.period);
                objSubcategoryLoanssAmazingLoans.click_periodIsRegular__c = string.valueof(ObjLoansAmazingLoans.periodIsRegular);
                objSubcategoryLoanssAmazingLoans.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                objSubcategoryLoanssAmazingLoans.Click_Statement_No__c = string.valueOf(CategoryIndex);
          //    objSubcategoryLoanssAmazingLoans.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssAmazingLoans.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssAmazingLoans.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansAmazingLoans.transactions != null && ObjLoansAmazingLoans.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objAmazingLoansTransaction : ObjLoansAmazingLoans.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Amazing Loans Loans';
                        if(objAmazingLoansTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objAmazingLoansTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objAmazingLoansTransaction.strdate;
                        objTransaction.click_text__c = objAmazingLoansTransaction.text;
                        if(objAmazingLoansTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objAmazingLoansTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objAmazingLoansTransaction.amount);
                        objTransaction.click_type__c = objAmazingLoansTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objAmazingLoansTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssAmazingLoans);
            }
            if(ObjLoans.AMXMoney != null)
            {
                FromBankstatementWrapper.cls_AMXMoney ObjLoansAMXMoney = ObjLoans.AMXMoney;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoansAMXMoney = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoansAMXMoney.Name = 'AMX Money';
                objSubcategoryLoansAMXMoney.Dependent__c = 'AMX Money';
                objSubcategoryLoansAMXMoney.Click_TransactionCount__c = string.valueof(ObjLoansAMXMoney.transactionCount);
                objSubcategoryLoansAMXMoney.click_totalValue__c = string.valueof(ObjLoansAMXMoney.totalValue);
                objSubcategoryLoansAMXMoney.click_monthAvg__c = string.valueof(ObjLoansAMXMoney.monthAvg);
                objSubcategoryLoansAMXMoney.click_minValue__c = string.valueof(ObjLoansAMXMoney.minValue);
                objSubcategoryLoansAMXMoney.click_maxValue__c = string.valueof(ObjLoansAMXMoney.maxValue);
                objSubcategoryLoansAMXMoney.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoansAMXMoney.click_firstTransaction__c = ObjLoansAMXMoney.firstTransaction;
                objSubcategoryLoansAMXMoney.click_lastTransaction__c = ObjLoansAMXMoney.lastTransaction;
                objSubcategoryLoansAMXMoney.click_period__c = string.valueof(ObjLoansAMXMoney.period);
                objSubcategoryLoansAMXMoney.click_periodIsRegular__c = string.valueof(ObjLoansAMXMoney.periodIsRegular);
                objSubcategoryLoansAMXMoney.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //         objSubcategoryLoansAMXMoney.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoansAMXMoney.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoansAMXMoney.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansAMXMoney.transactions != null && ObjLoansAMXMoney.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objAmxMoneyTransaction : ObjLoansAMXMoney.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction AMX Money Loans';
                        if(objAmxMoneyTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objAmxMoneyTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objAmxMoneyTransaction.strdate;
                        objTransaction.click_text__c = objAmxMoneyTransaction.text;
                        if(objAmxMoneyTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objAmxMoneyTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objAmxMoneyTransaction.amount);
                        objTransaction.click_type__c = objAmxMoneyTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objAmxMoneyTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoansAMXMoney);
            }
            if(ObjLoans.AusFinancial != null)
            {
                FromBankstatementWrapper.cls_AusFinancial ObjLoansAusFinancial = ObjLoans.AusFinancial;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssAusFinancial = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssAusFinancial.Name = 'Aus Financial';
                objSubcategoryLoanssAusFinancial.Dependent__c = 'Aus Financial';
                objSubcategoryLoanssAusFinancial.Click_TransactionCount__c = string.valueof(ObjLoansAusFinancial.transactionCount);
                objSubcategoryLoanssAusFinancial.click_totalValue__c = string.valueof(ObjLoansAusFinancial.totalValue);
                objSubcategoryLoanssAusFinancial.click_monthAvg__c = string.valueof(ObjLoansAusFinancial.monthAvg);
                objSubcategoryLoanssAusFinancial.click_minValue__c = string.valueof(ObjLoansAusFinancial.minValue);
                objSubcategoryLoanssAusFinancial.click_maxValue__c = string.valueof(ObjLoansAusFinancial.maxValue);
                objSubcategoryLoanssAusFinancial.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssAusFinancial.click_firstTransaction__c = ObjLoansAusFinancial.firstTransaction;
                objSubcategoryLoanssAusFinancial.click_lastTransaction__c = ObjLoansAusFinancial.lastTransaction;
                objSubcategoryLoanssAusFinancial.click_period__c = string.valueof(ObjLoansAusFinancial.period);
                objSubcategoryLoanssAusFinancial.click_periodIsRegular__c = string.valueof(ObjLoansAusFinancial.periodIsRegular);
                objSubcategoryLoanssAusFinancial.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
     //         objSubcategoryLoanssAusFinancial.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssAusFinancial.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssAusFinancial.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansAusFinancial.transactions != null && ObjLoansAusFinancial.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objAusFinancialTransaction : ObjLoansAusFinancial.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Aus Financial Loans';
                        if(objAusFinancialTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objAusFinancialTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objAusFinancialTransaction.strdate;
                        objTransaction.click_text__c = objAusFinancialTransaction.text;
                        if(objAusFinancialTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objAusFinancialTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objAusFinancialTransaction.amount);
                        objTransaction.click_type__c = objAusFinancialTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objAusFinancialTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssAusFinancial);
            }
            if(ObjLoans.Aussie != null)
            {
                FromBankstatementWrapper.cls_Aussie ObjLoansAussie = ObjLoans.Aussie;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssAussie = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssAussie.Name = 'Aussie';
                objSubcategoryLoanssAussie.Dependent__c = 'Aussie';
                objSubcategoryLoanssAussie.Click_TransactionCount__c = string.valueof(ObjLoansAussie.transactionCount);
                objSubcategoryLoanssAussie.click_totalValue__c = string.valueof(ObjLoansAussie.totalValue);
                objSubcategoryLoanssAussie.click_monthAvg__c = string.valueof(ObjLoansAussie.monthAvg);
                objSubcategoryLoanssAussie.click_minValue__c = string.valueof(ObjLoansAussie.minValue);
                objSubcategoryLoanssAussie.click_maxValue__c = string.valueof(ObjLoansAussie.maxValue);
                objSubcategoryLoanssAussie.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssAussie.click_firstTransaction__c = ObjLoansAussie.firstTransaction;
                objSubcategoryLoanssAussie.click_lastTransaction__c = ObjLoansAussie.lastTransaction;
                objSubcategoryLoanssAussie.click_period__c = string.valueof(ObjLoansAussie.period);
                objSubcategoryLoanssAussie.click_periodIsRegular__c = string.valueof(ObjLoansAussie.periodIsRegular);
                objSubcategoryLoanssAussie.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //     objSubcategoryLoanssAussie.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssAussie.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssAussie.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansAussie.transactions != null && ObjLoansAussie.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objAussieTransaction : ObjLoansAussie.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Aussie Loans';
                        if(objAussieTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objAussieTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objAussieTransaction.strdate;
                        objTransaction.click_text__c = objAussieTransaction.text;
                        if(objAussieTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objAussieTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objAussieTransaction.amount);
                        objTransaction.click_type__c = objAussieTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objAussieTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssAussie);
            }
            if(ObjLoans.AussieCash != null)
            {
                FromBankstatementWrapper.cls_AussieCash ObjLoansAussieCash = ObjLoans.AussieCash;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssAussieCash = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssAussieCash.Name = 'Aussie Cash';
                objSubcategoryLoanssAussieCash.Dependent__c = 'Aussie Cash';
                objSubcategoryLoanssAussieCash.Click_TransactionCount__c = string.valueof(ObjLoansAussieCash.transactionCount);
                objSubcategoryLoanssAussieCash.click_totalValue__c = string.valueof(ObjLoansAussieCash.totalValue);
                objSubcategoryLoanssAussieCash.click_monthAvg__c = string.valueof(ObjLoansAussieCash.monthAvg);
                objSubcategoryLoanssAussieCash.click_minValue__c = string.valueof(ObjLoansAussieCash.minValue);
                objSubcategoryLoanssAussieCash.click_maxValue__c = string.valueof(ObjLoansAussieCash.maxValue);
                objSubcategoryLoanssAussieCash.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssAussieCash.click_firstTransaction__c = ObjLoansAussieCash.firstTransaction;
                objSubcategoryLoanssAussieCash.click_lastTransaction__c = ObjLoansAussieCash.lastTransaction;
                objSubcategoryLoanssAussieCash.click_period__c = string.valueof(ObjLoansAussieCash.period);
                objSubcategoryLoanssAussieCash.click_periodIsRegular__c = string.valueof(ObjLoansAussieCash.periodIsRegular);
                objSubcategoryLoanssAussieCash.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //      objSubcategoryLoanssAussieCash.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssAussieCash.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssAussieCash.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansAussieCash.transactions != null && ObjLoansAussieCash.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objAussieCashTransaction : ObjLoansAussieCash.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction AussieCash Loans';
                        if(objAussieCashTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objAussieCashTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objAussieCashTransaction.strdate;
                        objTransaction.click_text__c = objAussieCashTransaction.text;
                        if(objAussieCashTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objAussieCashTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objAussieCashTransaction.amount);
                        objTransaction.click_type__c = objAussieCashTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objAussieCashTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssAussieCash);
            }
            if(ObjLoans.Baycorp != null)
            {
                FromBankstatementWrapper.cls_Baycorp ObjLoansBaycorp = ObjLoans.Baycorp;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssBaycorp = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssBaycorp.Name = 'Baycorp';
                objSubcategoryLoanssBaycorp.Dependent__c = 'Baycorp';
                objSubcategoryLoanssBaycorp.Click_TransactionCount__c = string.valueof(ObjLoansBaycorp.transactionCount);
                objSubcategoryLoanssBaycorp.click_totalValue__c = string.valueof(ObjLoansBaycorp.totalValue);
                objSubcategoryLoanssBaycorp.click_monthAvg__c = string.valueof(ObjLoansBaycorp.monthAvg);
                objSubcategoryLoanssBaycorp.click_minValue__c = string.valueof(ObjLoansBaycorp.minValue);
                objSubcategoryLoanssBaycorp.click_maxValue__c = string.valueof(ObjLoansBaycorp.maxValue);
                objSubcategoryLoanssBaycorp.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssBaycorp.click_firstTransaction__c = ObjLoansBaycorp.firstTransaction;
                objSubcategoryLoanssBaycorp.click_lastTransaction__c = ObjLoansBaycorp.lastTransaction;
                objSubcategoryLoanssBaycorp.click_period__c = string.valueof(ObjLoansBaycorp.period);
                objSubcategoryLoanssBaycorp.click_periodIsRegular__c = string.valueof(ObjLoansBaycorp.periodIsRegular);
                objSubcategoryLoanssBaycorp.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //    objSubcategoryLoanssBaycorp.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssBaycorp.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssBaycorp.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansBaycorp.transactions != null && ObjLoansBaycorp.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objBaycorpTransaction : ObjLoansBaycorp.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Baycorp Loans';
                        if(objBaycorpTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objBaycorpTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objBaycorpTransaction.strdate;
                        objTransaction.click_text__c = objBaycorpTransaction.text;
                        if(objBaycorpTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objBaycorpTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objBaycorpTransaction.amount);
                        objTransaction.click_type__c = objBaycorpTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objBaycorpTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssBaycorp);
            }
            
            if(ObjLoans.CannonFinance != null)
            {
                FromBankstatementWrapper.cls_CannonFinance ObjLoansCannonFinance = ObjLoans.CannonFinance;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCannonFinance = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCannonFinance.Name = 'Cannon Finance';
                objSubcategoryLoanssCannonFinance.Dependent__c = 'Cannon Finance';
                objSubcategoryLoanssCannonFinance.Click_TransactionCount__c = string.valueof(ObjLoansCannonFinance.transactionCount);
                objSubcategoryLoanssCannonFinance.click_totalValue__c = string.valueof(ObjLoansCannonFinance.totalValue);
                objSubcategoryLoanssCannonFinance.click_monthAvg__c = string.valueof(ObjLoansCannonFinance.monthAvg);
                objSubcategoryLoanssCannonFinance.click_minValue__c = string.valueof(ObjLoansCannonFinance.minValue);
                objSubcategoryLoanssCannonFinance.click_maxValue__c = string.valueof(ObjLoansCannonFinance.maxValue);
                objSubcategoryLoanssCannonFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCannonFinance.click_firstTransaction__c = ObjLoansCannonFinance.firstTransaction;
                objSubcategoryLoanssCannonFinance.click_lastTransaction__c = ObjLoansCannonFinance.lastTransaction;
                objSubcategoryLoanssCannonFinance.click_period__c = string.valueof(ObjLoansCannonFinance.period);
                objSubcategoryLoanssCannonFinance.click_periodIsRegular__c = string.valueof(ObjLoansCannonFinance.periodIsRegular);
                objSubcategoryLoanssCannonFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //   objSubcategoryLoanssCannonFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCannonFinance.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCannonFinance.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCannonFinance.transactions != null && ObjLoansCannonFinance.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCannonFinanceTransaction : ObjLoansCannonFinance.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cannon Finance Loans';
                        if(objCannonFinanceTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCannonFinanceTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCannonFinanceTransaction.strdate;
                        objTransaction.click_text__c = objCannonFinanceTransaction.text;
                        if(objCannonFinanceTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCannonFinanceTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCannonFinanceTransaction.amount);
                        objTransaction.click_type__c = objCannonFinanceTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCannonFinanceTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCannonFinance);
            }
            if(ObjLoans.CashAdvance != null)
            {
                FromBankstatementWrapper.cls_CashAdvance ObjLoansCashAdvance = ObjLoans.CashAdvance;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashAdvance = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashAdvance.Name = 'Cash Advance';
                objSubcategoryLoanssCashAdvance.Dependent__c = 'Cash Advance';
                objSubcategoryLoanssCashAdvance.Click_TransactionCount__c = string.valueof(ObjLoansCashAdvance.transactionCount);
                objSubcategoryLoanssCashAdvance.click_totalValue__c = string.valueof(ObjLoansCashAdvance.totalValue);
                objSubcategoryLoanssCashAdvance.click_monthAvg__c = string.valueof(ObjLoansCashAdvance.monthAvg);
                objSubcategoryLoanssCashAdvance.click_minValue__c = string.valueof(ObjLoansCashAdvance.minValue);
                objSubcategoryLoanssCashAdvance.click_maxValue__c = string.valueof(ObjLoansCashAdvance.maxValue);
                objSubcategoryLoanssCashAdvance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashAdvance.click_firstTransaction__c = ObjLoansCashAdvance.firstTransaction;
                objSubcategoryLoanssCashAdvance.click_lastTransaction__c = ObjLoansCashAdvance.lastTransaction;
                objSubcategoryLoanssCashAdvance.click_period__c = string.valueof(ObjLoansCashAdvance.period);
                objSubcategoryLoanssCashAdvance.click_periodIsRegular__c = string.valueof(ObjLoansCashAdvance.periodIsRegular);
                objSubcategoryLoanssCashAdvance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //    objSubcategoryLoanssCashAdvance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashAdvance.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashAdvance.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashAdvance.transactions != null && ObjLoansCashAdvance.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashAdvanceTransaction : ObjLoansCashAdvance.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Advance Loans';
                        if(objCashAdvanceTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashAdvanceTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashAdvanceTransaction.strdate;
                        objTransaction.click_text__c = objCashAdvanceTransaction.text;
                        if(objCashAdvanceTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashAdvanceTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashAdvanceTransaction.amount);
                        objTransaction.click_type__c = objCashAdvanceTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashAdvanceTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashAdvance);
            }
            if(ObjLoans.CashConverters != null)
            {
                FromBankstatementWrapper.cls_CashConverters ObjLoansCashConverters = ObjLoans.CashConverters;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashConverters = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashConverters.Name = 'Cash Converters';
                objSubcategoryLoanssCashConverters.Dependent__c = 'Cash Converters';
                objSubcategoryLoanssCashConverters.Click_TransactionCount__c = string.valueof(ObjLoansCashConverters.transactionCount);
                objSubcategoryLoanssCashConverters.click_totalValue__c = string.valueof(ObjLoansCashConverters.totalValue);
                objSubcategoryLoanssCashConverters.click_monthAvg__c = string.valueof(ObjLoansCashConverters.monthAvg);
                objSubcategoryLoanssCashConverters.click_minValue__c = string.valueof(ObjLoansCashConverters.minValue);
                objSubcategoryLoanssCashConverters.click_maxValue__c = string.valueof(ObjLoansCashConverters.maxValue);
                objSubcategoryLoanssCashConverters.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashConverters.click_firstTransaction__c = ObjLoansCashConverters.firstTransaction;
                objSubcategoryLoanssCashConverters.click_lastTransaction__c = ObjLoansCashConverters.lastTransaction;
                objSubcategoryLoanssCashConverters.click_period__c = string.valueof(ObjLoansCashConverters.period);
                objSubcategoryLoanssCashConverters.click_periodIsRegular__c = string.valueof(ObjLoansCashConverters.periodIsRegular);
                objSubcategoryLoanssCashConverters.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //    objSubcategoryLoanssCashConverters.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashConverters.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashConverters.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashConverters.transactions != null && ObjLoansCashConverters.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashConvertersTransaction : ObjLoansCashConverters.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Converters Loans';
                        if(objCashConvertersTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashConvertersTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashConvertersTransaction.strdate;
                        objTransaction.click_text__c = objCashConvertersTransaction.text;
                        if(objCashConvertersTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashConvertersTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashConvertersTransaction.amount);
                        objTransaction.click_type__c = objCashConvertersTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashConvertersTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashConverters);
            }
            if(ObjLoans.CashDoctors != null)
            {
                FromBankstatementWrapper.cls_CashDoctors ObjLoansCashDoctors = ObjLoans.CashDoctors;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashDoctors = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashDoctors.Name = 'Cash Doctors';
                objSubcategoryLoanssCashDoctors.Dependent__c = 'Cash Doctors';
                objSubcategoryLoanssCashDoctors.Click_TransactionCount__c = string.valueof(ObjLoansCashDoctors.transactionCount);
                objSubcategoryLoanssCashDoctors.click_totalValue__c = string.valueof(ObjLoansCashDoctors.totalValue);
                objSubcategoryLoanssCashDoctors.click_monthAvg__c = string.valueof(ObjLoansCashDoctors.monthAvg);
                objSubcategoryLoanssCashDoctors.click_minValue__c = string.valueof(ObjLoansCashDoctors.minValue);
                objSubcategoryLoanssCashDoctors.click_maxValue__c = string.valueof(ObjLoansCashDoctors.maxValue);
                objSubcategoryLoanssCashDoctors.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashDoctors.click_firstTransaction__c = ObjLoansCashDoctors.firstTransaction;
                objSubcategoryLoanssCashDoctors.click_lastTransaction__c = ObjLoansCashDoctors.lastTransaction;
                objSubcategoryLoanssCashDoctors.click_period__c = string.valueof(ObjLoansCashDoctors.period);
                objSubcategoryLoanssCashDoctors.click_periodIsRegular__c = string.valueof(ObjLoansCashDoctors.periodIsRegular);
                objSubcategoryLoanssCashDoctors.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //     objSubcategoryLoanssCashDoctors.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashDoctors.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashDoctors.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashDoctors.transactions != null && ObjLoansCashDoctors.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashDoctorsTransaction : ObjLoansCashDoctors.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Doctors Loans';
                        if(objCashDoctorsTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashDoctorsTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashDoctorsTransaction.strdate;
                        objTransaction.click_text__c = objCashDoctorsTransaction.text;
                        if(objCashDoctorsTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashDoctorsTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashDoctorsTransaction.amount);
                        objTransaction.click_type__c = objCashDoctorsTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashDoctorsTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashDoctors);
            }
            if(ObjLoans.CashFirst != null)
            {
                FromBankstatementWrapper.cls_CashFirst ObjLoansCashFirst = ObjLoans.CashFirst;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashFirst = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashFirst.Name = 'Cash First';
                objSubcategoryLoanssCashFirst.Dependent__c = 'Cash First';
                objSubcategoryLoanssCashFirst.Click_TransactionCount__c = string.valueof(ObjLoansCashFirst.transactionCount);
                objSubcategoryLoanssCashFirst.click_totalValue__c = string.valueof(ObjLoansCashFirst.totalValue);
                objSubcategoryLoanssCashFirst.click_monthAvg__c = string.valueof(ObjLoansCashFirst.monthAvg);
                objSubcategoryLoanssCashFirst.click_minValue__c = string.valueof(ObjLoansCashFirst.minValue);
                objSubcategoryLoanssCashFirst.click_maxValue__c = string.valueof(ObjLoansCashFirst.maxValue);
                objSubcategoryLoanssCashFirst.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashFirst.click_firstTransaction__c = ObjLoansCashFirst.firstTransaction;
                objSubcategoryLoanssCashFirst.click_lastTransaction__c = ObjLoansCashFirst.lastTransaction;
                objSubcategoryLoanssCashFirst.click_period__c = string.valueof(ObjLoansCashFirst.period);
                objSubcategoryLoanssCashFirst.click_periodIsRegular__c = string.valueof(ObjLoansCashFirst.periodIsRegular);
                objSubcategoryLoanssCashFirst.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //    objSubcategoryLoanssCashFirst.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashFirst.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashFirst.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashFirst.transactions != null && ObjLoansCashFirst.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashFirstTransaction : ObjLoansCashFirst.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash First Loans';
                        if(objCashFirstTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashFirstTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashFirstTransaction.strdate;
                        objTransaction.click_text__c = objCashFirstTransaction.text;
                        if(objCashFirstTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashFirstTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashFirstTransaction.amount);
                        objTransaction.click_type__c = objCashFirstTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashFirstTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashFirst);
            }
            if(ObjLoans.CashinaFlash != null)
            {
                FromBankstatementWrapper.cls_CashinaFlash ObjLoansCashinaFlash = ObjLoans.CashinaFlash;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashinaFlash = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashinaFlash.Name = 'Cash in a Flash';
                objSubcategoryLoanssCashinaFlash.Dependent__c = 'Cash in a Flash';
                objSubcategoryLoanssCashinaFlash.Click_TransactionCount__c = string.valueof(ObjLoansCashinaFlash.transactionCount);
                objSubcategoryLoanssCashinaFlash.click_totalValue__c = string.valueof(ObjLoansCashinaFlash.totalValue);
                objSubcategoryLoanssCashinaFlash.click_monthAvg__c = string.valueof(ObjLoansCashinaFlash.monthAvg);
                objSubcategoryLoanssCashinaFlash.click_minValue__c = string.valueof(ObjLoansCashinaFlash.minValue);
                objSubcategoryLoanssCashinaFlash.click_maxValue__c = string.valueof(ObjLoansCashinaFlash.maxValue);
                objSubcategoryLoanssCashinaFlash.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashinaFlash.click_firstTransaction__c = ObjLoansCashinaFlash.firstTransaction;
                objSubcategoryLoanssCashinaFlash.click_lastTransaction__c = ObjLoansCashinaFlash.lastTransaction;
                objSubcategoryLoanssCashinaFlash.click_period__c = string.valueof(ObjLoansCashinaFlash.period);
                objSubcategoryLoanssCashinaFlash.click_periodIsRegular__c = string.valueof(ObjLoansCashinaFlash.periodIsRegular);
                objSubcategoryLoanssCashinaFlash.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //    objSubcategoryLoanssCashinaFlash.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashinaFlash.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashinaFlash.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashinaFlash.transactions != null && ObjLoansCashinaFlash.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashinaFlashTransaction : ObjLoansCashinaFlash.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash in a Flash Loans';
                        if(objCashinaFlashTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashinaFlashTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashinaFlashTransaction.strdate;
                        objTransaction.click_text__c = objCashinaFlashTransaction.text;
                        if(objCashinaFlashTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashinaFlashTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashinaFlashTransaction.amount);
                        objTransaction.click_type__c = objCashinaFlashTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashinaFlashTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashinaFlash);
            }
            if(ObjLoans.CashMoney != null)
            {
                FromBankstatementWrapper.cls_CashMoney ObjLoansCashMoney = ObjLoans.CashMoney;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashMoney = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashMoney.Name = 'Cash Money';
                objSubcategoryLoanssCashMoney.Dependent__c = 'Cash Money';
                objSubcategoryLoanssCashMoney.Click_TransactionCount__c = string.valueof(ObjLoansCashMoney.transactionCount);
                objSubcategoryLoanssCashMoney.click_totalValue__c = string.valueof(ObjLoansCashMoney.totalValue);
                objSubcategoryLoanssCashMoney.click_monthAvg__c = string.valueof(ObjLoansCashMoney.monthAvg);
                objSubcategoryLoanssCashMoney.click_minValue__c = string.valueof(ObjLoansCashMoney.minValue);
                objSubcategoryLoanssCashMoney.click_maxValue__c = string.valueof(ObjLoansCashMoney.maxValue);
                objSubcategoryLoanssCashMoney.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashMoney.click_firstTransaction__c = ObjLoansCashMoney.firstTransaction;
                objSubcategoryLoanssCashMoney.click_lastTransaction__c = ObjLoansCashMoney.lastTransaction;
                objSubcategoryLoanssCashMoney.click_period__c = string.valueof(ObjLoansCashMoney.period);
                objSubcategoryLoanssCashMoney.click_periodIsRegular__c = string.valueof(ObjLoansCashMoney.periodIsRegular);
                objSubcategoryLoanssCashMoney.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //     objSubcategoryLoanssCashMoney.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashMoney.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashMoney.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashMoney.transactions != null && ObjLoansCashMoney.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashMoneyTransaction : ObjLoansCashMoney.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Money Loans';
                        if(objCashMoneyTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashMoneyTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashMoneyTransaction.strdate;
                        objTransaction.click_text__c = objCashMoneyTransaction.text;
                        if(objCashMoneyTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashMoneyTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashMoneyTransaction.amount);
                        objTransaction.click_type__c = objCashMoneyTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashMoneyTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashMoney);
            }
            if(ObjLoans.CashNow != null)
            {
                FromBankstatementWrapper.cls_CashNow ObjLoansCashNow = ObjLoans.CashNow;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashNow = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashNow.Name = 'Cash Now';
                objSubcategoryLoanssCashNow.Dependent__c = 'Cash Now';
                objSubcategoryLoanssCashNow.Click_TransactionCount__c = string.valueof(ObjLoansCashNow.transactionCount);
                objSubcategoryLoanssCashNow.click_totalValue__c = string.valueof(ObjLoansCashNow.totalValue);
                objSubcategoryLoanssCashNow.click_monthAvg__c = string.valueof(ObjLoansCashNow.monthAvg);
                objSubcategoryLoanssCashNow.click_minValue__c = string.valueof(ObjLoansCashNow.minValue);
                objSubcategoryLoanssCashNow.click_maxValue__c = string.valueof(ObjLoansCashNow.maxValue);
                objSubcategoryLoanssCashNow.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashNow.click_firstTransaction__c = ObjLoansCashNow.firstTransaction;
                objSubcategoryLoanssCashNow.click_lastTransaction__c = ObjLoansCashNow.lastTransaction;
                objSubcategoryLoanssCashNow.click_period__c = string.valueof(ObjLoansCashNow.period);
                objSubcategoryLoanssCashNow.click_periodIsRegular__c = string.valueof(ObjLoansCashNow.periodIsRegular);
                objSubcategoryLoanssCashNow.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //       objSubcategoryLoanssCashNow.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashNow.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashNow.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashNow.transactions != null && ObjLoansCashNow.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashNowTransaction : ObjLoansCashNow.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Now Loans';
                        if(objCashNowTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashNowTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashNowTransaction.strdate;
                        objTransaction.click_text__c = objCashNowTransaction.text;
                        if(objCashNowTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashNowTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashNowTransaction.amount);
                        objTransaction.click_type__c = objCashNowTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashNowTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashNow);
            }
            if(ObjLoans.CashOz != null)
            {
                FromBankstatementWrapper.cls_CashOz ObjLoansCashOz = ObjLoans.CashOz;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashOz = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashOz.Name = 'Cash Oz';
                objSubcategoryLoanssCashOz.Dependent__c = 'Cash Oz';
                objSubcategoryLoanssCashOz.Click_TransactionCount__c = string.valueof(ObjLoansCashOz.transactionCount);
                objSubcategoryLoanssCashOz.click_totalValue__c = string.valueof(ObjLoansCashOz.totalValue);
                objSubcategoryLoanssCashOz.click_monthAvg__c = string.valueof(ObjLoansCashOz.monthAvg);
                objSubcategoryLoanssCashOz.click_minValue__c = string.valueof(ObjLoansCashOz.minValue);
                objSubcategoryLoanssCashOz.click_maxValue__c = string.valueof(ObjLoansCashOz.maxValue);
                objSubcategoryLoanssCashOz.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashOz.click_firstTransaction__c = ObjLoansCashOz.firstTransaction;
                objSubcategoryLoanssCashOz.click_lastTransaction__c = ObjLoansCashOz.lastTransaction;
                objSubcategoryLoanssCashOz.click_period__c = string.valueof(ObjLoansCashOz.period);
                objSubcategoryLoanssCashOz.click_periodIsRegular__c = string.valueof(ObjLoansCashOz.periodIsRegular);
                objSubcategoryLoanssCashOz.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //      objSubcategoryLoanssCashOz.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashOz.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashOz.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashOz.transactions != null && ObjLoansCashOz.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashOzTransaction : ObjLoansCashOz.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Oz Loans';
                        if(objCashOzTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashOzTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashOzTransaction.strdate;
                        objTransaction.click_text__c = objCashOzTransaction.text;
                        if(objCashOzTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashOzTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashOzTransaction.amount);
                        objTransaction.click_type__c = objCashOzTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashOzTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashOz);
            }
            if(ObjLoans.CashSolutions != null)
            {
                FromBankstatementWrapper.cls_CashSolutions ObjLoansCashSolutions = ObjLoans.CashSolutions;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashSolutions = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashSolutions.Name = 'Cash Solutions';
                objSubcategoryLoanssCashSolutions.Dependent__c = 'Cash Solutions';
                objSubcategoryLoanssCashSolutions.Click_TransactionCount__c = string.valueof(ObjLoansCashSolutions.transactionCount);
                objSubcategoryLoanssCashSolutions.click_totalValue__c = string.valueof(ObjLoansCashSolutions.totalValue);
                objSubcategoryLoanssCashSolutions.click_monthAvg__c = string.valueof(ObjLoansCashSolutions.monthAvg);
                objSubcategoryLoanssCashSolutions.click_minValue__c = string.valueof(ObjLoansCashSolutions.minValue);
                objSubcategoryLoanssCashSolutions.click_maxValue__c = string.valueof(ObjLoansCashSolutions.maxValue);
                objSubcategoryLoanssCashSolutions.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashSolutions.click_firstTransaction__c = ObjLoansCashSolutions.firstTransaction;
                objSubcategoryLoanssCashSolutions.click_lastTransaction__c = ObjLoansCashSolutions.lastTransaction;
                objSubcategoryLoanssCashSolutions.click_period__c = string.valueof(ObjLoansCashSolutions.period);
                objSubcategoryLoanssCashSolutions.click_periodIsRegular__c = string.valueof(ObjLoansCashSolutions.periodIsRegular);
                objSubcategoryLoanssCashSolutions.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //    objSubcategoryLoanssCashSolutions.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashSolutions.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashSolutions.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashSolutions.transactions != null && ObjLoansCashSolutions.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashSolutionsTransaction : ObjLoansCashSolutions.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Solutions Loans';
                        if(objCashSolutionsTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashSolutionsTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashSolutionsTransaction.strdate;
                        objTransaction.click_text__c = objCashSolutionsTransaction.text;
                        if(objCashSolutionsTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashSolutionsTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashSolutionsTransaction.amount);
                        objTransaction.click_type__c = objCashSolutionsTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashSolutionsTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashSolutions);
            }
            if(ObjLoans.CashSmart != null)
            {
                FromBankstatementWrapper.cls_CashSmart ObjLoansCashSmart = ObjLoans.CashSmart;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashSmart = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashSmart.Name = 'Cash Smart';
                objSubcategoryLoanssCashSmart.Dependent__c = 'Cash Smart';
                objSubcategoryLoanssCashSmart.Click_TransactionCount__c = string.valueof(ObjLoansCashSmart.transactionCount);
                objSubcategoryLoanssCashSmart.click_totalValue__c = string.valueof(ObjLoansCashSmart.totalValue);
                objSubcategoryLoanssCashSmart.click_monthAvg__c = string.valueof(ObjLoansCashSmart.monthAvg);
                objSubcategoryLoanssCashSmart.click_minValue__c = string.valueof(ObjLoansCashSmart.minValue);
                objSubcategoryLoanssCashSmart.click_maxValue__c = string.valueof(ObjLoansCashSmart.maxValue);
                objSubcategoryLoanssCashSmart.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashSmart.click_firstTransaction__c = ObjLoansCashSmart.firstTransaction;
                objSubcategoryLoanssCashSmart.click_lastTransaction__c = ObjLoansCashSmart.lastTransaction;
                objSubcategoryLoanssCashSmart.click_period__c = string.valueof(ObjLoansCashSmart.period);
                objSubcategoryLoanssCashSmart.click_periodIsRegular__c = string.valueof(ObjLoansCashSmart.periodIsRegular);
                objSubcategoryLoanssCashSmart.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //        objSubcategoryLoanssCashSmart.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashSmart.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashSmart.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashSmart.transactions != null && ObjLoansCashSmart.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashSmartTransaction : ObjLoansCashSmart.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Smart Loans';
                        if(objCashSmartTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashSmartTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashSmartTransaction.strdate;
                        objTransaction.click_text__c = objCashSmartTransaction.text;
                        if(objCashSmartTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashSmartTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashSmartTransaction.amount);
                        objTransaction.click_type__c = objCashSmartTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashSmartTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashSmart);
            }
            if(ObjLoans.CashStop != null)
            {
                FromBankstatementWrapper.cls_CashStop ObjLoansCashStop = ObjLoans.CashStop;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashStop = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashStop.Name = 'Cash Stop';
                objSubcategoryLoanssCashStop.Dependent__c = 'Cash Stop';
                objSubcategoryLoanssCashStop.Click_TransactionCount__c = string.valueof(ObjLoansCashStop.transactionCount);
                objSubcategoryLoanssCashStop.click_totalValue__c = string.valueof(ObjLoansCashStop.totalValue);
                objSubcategoryLoanssCashStop.click_monthAvg__c = string.valueof(ObjLoansCashStop.monthAvg);
                objSubcategoryLoanssCashStop.click_minValue__c = string.valueof(ObjLoansCashStop.minValue);
                objSubcategoryLoanssCashStop.click_maxValue__c = string.valueof(ObjLoansCashStop.maxValue);
                objSubcategoryLoanssCashStop.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashStop.click_firstTransaction__c = ObjLoansCashStop.firstTransaction;
                objSubcategoryLoanssCashStop.click_lastTransaction__c = ObjLoansCashStop.lastTransaction;
                objSubcategoryLoanssCashStop.click_period__c = string.valueof(ObjLoansCashStop.period);
                objSubcategoryLoanssCashStop.click_periodIsRegular__c = string.valueof(ObjLoansCashStop.periodIsRegular);
                objSubcategoryLoanssCashStop.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //       objSubcategoryLoanssCashStop.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashStop.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashStop.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashStop.transactions != null && ObjLoansCashStop.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashStopTransaction : ObjLoansCashStop.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Stop Loans';
                        if(objCashStopTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashStopTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashStopTransaction.strdate;
                        objTransaction.click_text__c = objCashStopTransaction.text;
                        if(objCashStopTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashStopTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashStopTransaction.amount);
                        objTransaction.click_type__c = objCashStopTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashStopTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashStop);
            }
            if(ObjLoans.CashToday != null)
            {
                FromBankstatementWrapper.cls_CashToday ObjLoansCashToday = ObjLoans.CashToday;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashToday = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashToday.Name = 'Cash Today';
                objSubcategoryLoanssCashToday.Dependent__c = 'Cash Today';
                objSubcategoryLoanssCashToday.Click_TransactionCount__c = string.valueof(ObjLoansCashToday.transactionCount);
                objSubcategoryLoanssCashToday.click_totalValue__c = string.valueof(ObjLoansCashToday.totalValue);
                objSubcategoryLoanssCashToday.click_monthAvg__c = string.valueof(ObjLoansCashToday.monthAvg);
                objSubcategoryLoanssCashToday.click_minValue__c = string.valueof(ObjLoansCashToday.minValue);
                objSubcategoryLoanssCashToday.click_maxValue__c = string.valueof(ObjLoansCashToday.maxValue);
                objSubcategoryLoanssCashToday.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashToday.click_firstTransaction__c = ObjLoansCashToday.firstTransaction;
                objSubcategoryLoanssCashToday.click_lastTransaction__c = ObjLoansCashToday.lastTransaction;
                objSubcategoryLoanssCashToday.click_period__c = string.valueof(ObjLoansCashToday.period);
                objSubcategoryLoanssCashToday.click_periodIsRegular__c = string.valueof(ObjLoansCashToday.periodIsRegular);
                objSubcategoryLoanssCashToday.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //        objSubcategoryLoanssCashToday.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashToday.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashToday.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashToday.transactions != null && ObjLoansCashToday.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashTodayTransaction : ObjLoansCashToday.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Today Loans';
                        if(objCashTodayTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashTodayTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashTodayTransaction.strdate;
                        objTransaction.click_text__c = objCashTodayTransaction.text;
                        if(objCashTodayTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashTodayTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashTodayTransaction.amount);
                        objTransaction.click_type__c = objCashTodayTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashTodayTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashToday);
            }
            if(ObjLoans.CashTrain != null)
            {
                FromBankstatementWrapper.cls_CashTrain ObjLoansCashTrain = ObjLoans.CashTrain;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCashTrain = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCashTrain.Name = 'Cash Train';
                objSubcategoryLoanssCashTrain.Dependent__c = 'Cash Train';
                objSubcategoryLoanssCashTrain.Click_TransactionCount__c = string.valueof(ObjLoansCashTrain.transactionCount);
                objSubcategoryLoanssCashTrain.click_totalValue__c = string.valueof(ObjLoansCashTrain.totalValue);
                objSubcategoryLoanssCashTrain.click_monthAvg__c = string.valueof(ObjLoansCashTrain.monthAvg);
                objSubcategoryLoanssCashTrain.click_minValue__c = string.valueof(ObjLoansCashTrain.minValue);
                objSubcategoryLoanssCashTrain.click_maxValue__c = string.valueof(ObjLoansCashTrain.maxValue);
                objSubcategoryLoanssCashTrain.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCashTrain.click_firstTransaction__c = ObjLoansCashTrain.firstTransaction;
                objSubcategoryLoanssCashTrain.click_lastTransaction__c = ObjLoansCashTrain.lastTransaction;
                objSubcategoryLoanssCashTrain.click_period__c = string.valueof(ObjLoansCashTrain.period);
                objSubcategoryLoanssCashTrain.click_periodIsRegular__c = string.valueof(ObjLoansCashTrain.periodIsRegular);
                objSubcategoryLoanssCashTrain.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //    objSubcategoryLoanssCashTrain.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCashTrain.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCashTrain.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCashTrain.transactions != null && ObjLoansCashTrain.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCashTrainTransaction : ObjLoansCashTrain.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash Train Loans';
                        if(objCashTrainTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCashTrainTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCashTrainTransaction.strdate;
                        objTransaction.click_text__c = objCashTrainTransaction.text;
                        if(objCashTrainTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCashTrainTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCashTrainTransaction.amount);
                        objTransaction.click_type__c = objCashTrainTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCashTrainTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCashTrain);
            }
            if(ObjLoans.CenterOne != null)
            {
                FromBankstatementWrapper.cls_CenterOne ObjLoansCenterOne = ObjLoans.CenterOne;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCenterOne = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCenterOne.Name = 'Cash One';
                objSubcategoryLoanssCenterOne.Dependent__c = 'Cash One';
                objSubcategoryLoanssCenterOne.Click_TransactionCount__c = string.valueof(ObjLoansCenterOne.transactionCount);
                objSubcategoryLoanssCenterOne.click_totalValue__c = string.valueof(ObjLoansCenterOne.totalValue);
                objSubcategoryLoanssCenterOne.click_monthAvg__c = string.valueof(ObjLoansCenterOne.monthAvg);
                objSubcategoryLoanssCenterOne.click_minValue__c = string.valueof(ObjLoansCenterOne.minValue);
                objSubcategoryLoanssCenterOne.click_maxValue__c = string.valueof(ObjLoansCenterOne.maxValue);
                objSubcategoryLoanssCenterOne.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCenterOne.click_firstTransaction__c = ObjLoansCenterOne.firstTransaction;
                objSubcategoryLoanssCenterOne.click_lastTransaction__c = ObjLoansCenterOne.lastTransaction;
                objSubcategoryLoanssCenterOne.click_period__c = string.valueof(ObjLoansCenterOne.period);
                objSubcategoryLoanssCenterOne.click_periodIsRegular__c = string.valueof(ObjLoansCenterOne.periodIsRegular);
                objSubcategoryLoanssCenterOne.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //      objSubcategoryLoanssCenterOne.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCenterOne.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCenterOne.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCenterOne.transactions != null && ObjLoansCenterOne.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCenterOneTransaction : ObjLoansCenterOne.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Cash One Loans';
                        if(objCenterOneTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCenterOneTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCenterOneTransaction.strdate;
                        objTransaction.click_text__c = objCenterOneTransaction.text;
                        if(objCenterOneTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCenterOneTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCenterOneTransaction.amount);
                        objTransaction.click_type__c = objCenterOneTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCenterOneTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCenterOne);
            }
            if(ObjLoans.ChampionLoans != null)
            {
                FromBankstatementWrapper.cls_ChampionLoans ObjLoansChampionLoans = ObjLoans.ChampionLoans;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssChampionLoans = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssChampionLoans.Name = 'Champion Loans';
                objSubcategoryLoanssChampionLoans.Dependent__c = 'Champion Loans';
                objSubcategoryLoanssChampionLoans.Click_TransactionCount__c = string.valueof(ObjLoansChampionLoans.transactionCount);
                objSubcategoryLoanssChampionLoans.click_totalValue__c = string.valueof(ObjLoansChampionLoans.totalValue);
                objSubcategoryLoanssChampionLoans.click_monthAvg__c = string.valueof(ObjLoansChampionLoans.monthAvg);
                objSubcategoryLoanssChampionLoans.click_minValue__c = string.valueof(ObjLoansChampionLoans.minValue);
                objSubcategoryLoanssChampionLoans.click_maxValue__c = string.valueof(ObjLoansChampionLoans.maxValue);
                objSubcategoryLoanssChampionLoans.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssChampionLoans.click_firstTransaction__c = ObjLoansChampionLoans.firstTransaction;
                objSubcategoryLoanssChampionLoans.click_lastTransaction__c = ObjLoansChampionLoans.lastTransaction;
                objSubcategoryLoanssChampionLoans.click_period__c = string.valueof(ObjLoansChampionLoans.period);
                objSubcategoryLoanssChampionLoans.click_periodIsRegular__c = string.valueof(ObjLoansChampionLoans.periodIsRegular);
                objSubcategoryLoanssChampionLoans.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //       objSubcategoryLoanssChampionLoans.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssChampionLoans.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssChampionLoans.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansChampionLoans.transactions != null && ObjLoansChampionLoans.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objChampionLoansTransaction : ObjLoansChampionLoans.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Champion Loans Loans';
                        if(objChampionLoansTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objChampionLoansTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objChampionLoansTransaction.strdate;
                        objTransaction.click_text__c = objChampionLoansTransaction.text;
                        if(objChampionLoansTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objChampionLoansTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objChampionLoansTransaction.amount);
                        objTransaction.click_type__c = objChampionLoansTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objChampionLoansTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssChampionLoans);
            }
            if(ObjLoans.ChampionMoney != null)
            {
                FromBankstatementWrapper.cls_ChampionMoney ObjLoansChampionMoney = ObjLoans.ChampionMoney;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssChampionMoney = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssChampionMoney.Name = 'Champion Money';
                objSubcategoryLoanssChampionMoney.Dependent__c = 'Champion Money';
                objSubcategoryLoanssChampionMoney.Click_TransactionCount__c = string.valueof(ObjLoansChampionMoney.transactionCount);
                objSubcategoryLoanssChampionMoney.click_totalValue__c = string.valueof(ObjLoansChampionMoney.totalValue);
                objSubcategoryLoanssChampionMoney.click_monthAvg__c = string.valueof(ObjLoansChampionMoney.monthAvg);
                objSubcategoryLoanssChampionMoney.click_minValue__c = string.valueof(ObjLoansChampionMoney.minValue);
                objSubcategoryLoanssChampionMoney.click_maxValue__c = string.valueof(ObjLoansChampionMoney.maxValue);
                objSubcategoryLoanssChampionMoney.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssChampionMoney.click_firstTransaction__c = ObjLoansChampionMoney.firstTransaction;
                objSubcategoryLoanssChampionMoney.click_lastTransaction__c = ObjLoansChampionMoney.lastTransaction;
                objSubcategoryLoanssChampionMoney.click_period__c = string.valueof(ObjLoansChampionMoney.period);
                objSubcategoryLoanssChampionMoney.click_periodIsRegular__c = string.valueof(ObjLoansChampionMoney.periodIsRegular);
                objSubcategoryLoanssChampionMoney.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //   objSubcategoryLoanssChampionMoney.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssChampionMoney.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssChampionMoney.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansChampionMoney.transactions != null && ObjLoansChampionMoney.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objChampionMoneyTransaction : ObjLoansChampionMoney.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Champion Money Loans';
                        if(objChampionMoneyTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objChampionMoneyTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objChampionMoneyTransaction.strdate;
                        objTransaction.click_text__c = objChampionMoneyTransaction.text;
                        if(objChampionMoneyTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objChampionMoneyTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objChampionMoneyTransaction.amount);
                        objTransaction.click_type__c = objChampionMoneyTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objChampionMoneyTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssChampionMoney);
            }
            if(ObjLoans.CityFinance != null)
            {
                FromBankstatementWrapper.cls_CityFinance ObjLoansCityFinance = ObjLoans.CityFinance;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCityFinance = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCityFinance.Name = 'City Finance';
                objSubcategoryLoanssCityFinance.Dependent__c = 'City Finance';
                objSubcategoryLoanssCityFinance.Click_TransactionCount__c = string.valueof(ObjLoansCityFinance.transactionCount);
                objSubcategoryLoanssCityFinance.click_totalValue__c = string.valueof(ObjLoansCityFinance.totalValue);
                objSubcategoryLoanssCityFinance.click_monthAvg__c = string.valueof(ObjLoansCityFinance.monthAvg);
                objSubcategoryLoanssCityFinance.click_minValue__c = string.valueof(ObjLoansCityFinance.minValue);
                objSubcategoryLoanssCityFinance.click_maxValue__c = string.valueof(ObjLoansCityFinance.maxValue);
                objSubcategoryLoanssCityFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCityFinance.click_firstTransaction__c = ObjLoansCityFinance.firstTransaction;
                objSubcategoryLoanssCityFinance.click_lastTransaction__c = ObjLoansCityFinance.lastTransaction;
                objSubcategoryLoanssCityFinance.click_period__c = string.valueof(ObjLoansCityFinance.period);
                objSubcategoryLoanssCityFinance.click_periodIsRegular__c = string.valueof(ObjLoansCityFinance.periodIsRegular);
                objSubcategoryLoanssCityFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //        objSubcategoryLoanssCityFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCityFinance.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCityFinance.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCityFinance.transactions != null && ObjLoansCityFinance.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCityFinanceTransaction : ObjLoansCityFinance.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction City Finance Loans';
                        if(objCityFinanceTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCityFinanceTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCityFinanceTransaction.strdate;
                        objTransaction.click_text__c = objCityFinanceTransaction.text;
                        if(objCityFinanceTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCityFinanceTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCityFinanceTransaction.amount);
                        objTransaction.click_type__c = objCityFinanceTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCityFinanceTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCityFinance);
            }
            if(ObjLoans.ClearCash != null)
            {
                FromBankstatementWrapper.cls_ClearCash ObjLoansClearCash = ObjLoans.ClearCash;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssClearCash = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssClearCash.Name = 'Clear Cash';
                objSubcategoryLoanssClearCash.Dependent__c = 'Clear Cash';
                objSubcategoryLoanssClearCash.Click_TransactionCount__c = string.valueof(ObjLoansClearCash.transactionCount);
                objSubcategoryLoanssClearCash.click_totalValue__c = string.valueof(ObjLoansClearCash.totalValue);
                objSubcategoryLoanssClearCash.click_monthAvg__c = string.valueof(ObjLoansClearCash.monthAvg);
                objSubcategoryLoanssClearCash.click_minValue__c = string.valueof(ObjLoansClearCash.minValue);
                objSubcategoryLoanssClearCash.click_maxValue__c = string.valueof(ObjLoansClearCash.maxValue);
                objSubcategoryLoanssClearCash.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssClearCash.click_firstTransaction__c = ObjLoansClearCash.firstTransaction;
                objSubcategoryLoanssClearCash.click_lastTransaction__c = ObjLoansClearCash.lastTransaction;
                objSubcategoryLoanssClearCash.click_period__c = string.valueof(ObjLoansClearCash.period);
                objSubcategoryLoanssClearCash.click_periodIsRegular__c = string.valueof(ObjLoansClearCash.periodIsRegular);
                objSubcategoryLoanssClearCash.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
     //         objSubcategoryLoanssClearCash.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssClearCash.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssClearCash.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansClearCash.transactions != null && ObjLoansClearCash.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objClearCashTransaction : ObjLoansClearCash.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Clear Cash Loans';
                        if(objClearCashTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objClearCashTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objClearCashTransaction.strdate;
                        objTransaction.click_text__c = objClearCashTransaction.text;
                        if(objClearCashTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objClearCashTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objClearCashTransaction.amount);
                        objTransaction.click_type__c = objClearCashTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objClearCashTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssClearCash);
            }
            if(ObjLoans.Credit24 != null)
            {
                FromBankstatementWrapper.cls_Credit24 ObjLoansCredit24 = ObjLoans.Credit24;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCredit24 = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCredit24.Name = 'Credit24';
                objSubcategoryLoanssCredit24.Dependent__c = 'Credit24';
                objSubcategoryLoanssCredit24.Click_TransactionCount__c = string.valueof(ObjLoansCredit24.transactionCount);
                objSubcategoryLoanssCredit24.click_totalValue__c = string.valueof(ObjLoansCredit24.totalValue);
                objSubcategoryLoanssCredit24.click_monthAvg__c = string.valueof(ObjLoansCredit24.monthAvg);
                objSubcategoryLoanssCredit24.click_minValue__c = string.valueof(ObjLoansCredit24.minValue);
                objSubcategoryLoanssCredit24.click_maxValue__c = string.valueof(ObjLoansCredit24.maxValue);
                objSubcategoryLoanssCredit24.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCredit24.click_firstTransaction__c = ObjLoansCredit24.firstTransaction;
                objSubcategoryLoanssCredit24.click_lastTransaction__c = ObjLoansCredit24.lastTransaction;
                objSubcategoryLoanssCredit24.click_period__c = string.valueof(ObjLoansCredit24.period);
                objSubcategoryLoanssCredit24.click_periodIsRegular__c = string.valueof(ObjLoansCredit24.periodIsRegular);
                objSubcategoryLoanssCredit24.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //      objSubcategoryLoanssCredit24.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCredit24.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCredit24.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCredit24.transactions != null && ObjLoansCredit24.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCredit24Transaction : ObjLoansCredit24.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Credit24 Loans';
                        if(objCredit24Transaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCredit24Transaction.strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCredit24Transaction.strdate;
                        objTransaction.click_text__c = objCredit24Transaction.text;
                        if(objCredit24Transaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCredit24Transaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCredit24Transaction.amount);
                        objTransaction.click_type__c = objCredit24Transaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCredit24Transaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCredit24);
            }
            if(ObjLoans.CreditCorp != null)
            {
                FromBankstatementWrapper.cls_CreditCorp ObjLoansCreditCorp = ObjLoans.CreditCorp;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssCreditCorp = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssCreditCorp.Name = 'Credit Corp';
                objSubcategoryLoanssCreditCorp.Dependent__c = 'Credit Corp';
                objSubcategoryLoanssCreditCorp.Click_TransactionCount__c = string.valueof(ObjLoansCreditCorp.transactionCount);
                objSubcategoryLoanssCreditCorp.click_totalValue__c = string.valueof(ObjLoansCreditCorp.totalValue);
                objSubcategoryLoanssCreditCorp.click_monthAvg__c = string.valueof(ObjLoansCreditCorp.monthAvg);
                objSubcategoryLoanssCreditCorp.click_minValue__c = string.valueof(ObjLoansCreditCorp.minValue);
                objSubcategoryLoanssCreditCorp.click_maxValue__c = string.valueof(ObjLoansCreditCorp.maxValue);
                objSubcategoryLoanssCreditCorp.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssCreditCorp.click_firstTransaction__c = ObjLoansCreditCorp.firstTransaction;
                objSubcategoryLoanssCreditCorp.click_lastTransaction__c = ObjLoansCreditCorp.lastTransaction;
                objSubcategoryLoanssCreditCorp.click_period__c = string.valueof(ObjLoansCreditCorp.period);
                objSubcategoryLoanssCreditCorp.click_periodIsRegular__c = string.valueof(ObjLoansCreditCorp.periodIsRegular);
                objSubcategoryLoanssCreditCorp.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
    //          objSubcategoryLoanssCreditCorp.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssCreditCorp.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssCreditCorp.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansCreditCorp.transactions != null && ObjLoansCreditCorp.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCreditCorpTransaction : ObjLoansCreditCorp.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Credit Corp Loans';
                        if(objCreditCorpTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCreditCorpTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCreditCorpTransaction.strdate;
                        objTransaction.click_text__c = objCreditCorpTransaction.text;
                        if(objCreditCorpTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCreditCorpTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCreditCorpTransaction.amount);
                        objTransaction.click_type__c = objCreditCorpTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCreditCorpTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssCreditCorp);
            }
            if(ObjLoans.DebtFix != null)
            {
                FromBankstatementWrapper.cls_DebtFix ObjLoansDebtFix = ObjLoans.DebtFix;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssDebtFix = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssDebtFix.Name = 'Debt Fix';
                objSubcategoryLoanssDebtFix.Dependent__c = 'Debt Fix';
                objSubcategoryLoanssDebtFix.Click_TransactionCount__c = string.valueof(ObjLoansDebtFix.transactionCount);
                objSubcategoryLoanssDebtFix.click_totalValue__c = string.valueof(ObjLoansDebtFix.totalValue);
                objSubcategoryLoanssDebtFix.click_monthAvg__c = string.valueof(ObjLoansDebtFix.monthAvg);
                objSubcategoryLoanssDebtFix.click_minValue__c = string.valueof(ObjLoansDebtFix.minValue);
                objSubcategoryLoanssDebtFix.click_maxValue__c = string.valueof(ObjLoansDebtFix.maxValue);
                objSubcategoryLoanssDebtFix.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssDebtFix.click_firstTransaction__c = ObjLoansDebtFix.firstTransaction;
                objSubcategoryLoanssDebtFix.click_lastTransaction__c = ObjLoansDebtFix.lastTransaction;
                objSubcategoryLoanssDebtFix.click_period__c = string.valueof(ObjLoansDebtFix.period);
                objSubcategoryLoanssDebtFix.click_periodIsRegular__c = string.valueof(ObjLoansDebtFix.periodIsRegular);
                objSubcategoryLoanssDebtFix.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
     //         objSubcategoryLoanssDebtFix.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssDebtFix.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssDebtFix.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansDebtFix.transactions != null && ObjLoansDebtFix.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objDebtFixTransaction : ObjLoansDebtFix.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Debt Fix Loans';
                        if(objDebtFixTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objDebtFixTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objDebtFixTransaction.strdate;
                        objTransaction.click_text__c = objDebtFixTransaction.text;
                        if(objDebtFixTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objDebtFixTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objDebtFixTransaction.amount);
                        objTransaction.click_type__c = objDebtFixTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objDebtFixTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssDebtFix);
            }
            if(ObjLoans.DollarsDirect != null)
            {
                FromBankstatementWrapper.cls_DollarsDirect ObjLoansDollarsDirect = ObjLoans.DollarsDirect;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssDollarsDirect = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssDollarsDirect.Name = 'Dollars Direct';
                objSubcategoryLoanssDollarsDirect.Dependent__c = 'Dollars Direct';
                objSubcategoryLoanssDollarsDirect.Click_TransactionCount__c = string.valueof(ObjLoansDollarsDirect.transactionCount);
                objSubcategoryLoanssDollarsDirect.click_totalValue__c = string.valueof(ObjLoansDollarsDirect.totalValue);
                objSubcategoryLoanssDollarsDirect.click_monthAvg__c = string.valueof(ObjLoansDollarsDirect.monthAvg);
                objSubcategoryLoanssDollarsDirect.click_minValue__c = string.valueof(ObjLoansDollarsDirect.minValue);
                objSubcategoryLoanssDollarsDirect.click_maxValue__c = string.valueof(ObjLoansDollarsDirect.maxValue);
                objSubcategoryLoanssDollarsDirect.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssDollarsDirect.click_firstTransaction__c = ObjLoansDollarsDirect.firstTransaction;
                objSubcategoryLoanssDollarsDirect.click_lastTransaction__c = ObjLoansDollarsDirect.lastTransaction;
                objSubcategoryLoanssDollarsDirect.click_period__c = string.valueof(ObjLoansDollarsDirect.period);
                objSubcategoryLoanssDollarsDirect.click_periodIsRegular__c = string.valueof(ObjLoansDollarsDirect.periodIsRegular);
                objSubcategoryLoanssDollarsDirect.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
   //           objSubcategoryLoanssDollarsDirect.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssDollarsDirect.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssDollarsDirect.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansDollarsDirect.transactions != null && ObjLoansDollarsDirect.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objDollarsDirectTransaction : ObjLoansDollarsDirect.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Dollars Direct Loans';
                        if(objDollarsDirectTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objDollarsDirectTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objDollarsDirectTransaction.strdate;
                        objTransaction.click_text__c = objDollarsDirectTransaction.text;
                        if(objDollarsDirectTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objDollarsDirectTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objDollarsDirectTransaction.amount);
                        objTransaction.click_type__c = objDollarsDirectTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objDollarsDirectTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssDollarsDirect);
            }
            if(ObjLoans.EasyFinancing != null)
            {
                FromBankstatementWrapper.cls_EasyFinancing ObjLoansEasyFinancing = ObjLoans.EasyFinancing;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssEasyFinancing = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssEasyFinancing.Name = 'Easy Financing';
                objSubcategoryLoanssEasyFinancing.Dependent__c = 'Easy Financing';
                objSubcategoryLoanssEasyFinancing.Click_TransactionCount__c = string.valueof(ObjLoansEasyFinancing.transactionCount);
                objSubcategoryLoanssEasyFinancing.click_totalValue__c = string.valueof(ObjLoansEasyFinancing.totalValue);
                objSubcategoryLoanssEasyFinancing.click_monthAvg__c = string.valueof(ObjLoansEasyFinancing.monthAvg);
                objSubcategoryLoanssEasyFinancing.click_minValue__c = string.valueof(ObjLoansEasyFinancing.minValue);
                objSubcategoryLoanssEasyFinancing.click_maxValue__c = string.valueof(ObjLoansEasyFinancing.maxValue);
                objSubcategoryLoanssEasyFinancing.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssEasyFinancing.click_firstTransaction__c = ObjLoansEasyFinancing.firstTransaction;
                objSubcategoryLoanssEasyFinancing.click_lastTransaction__c = ObjLoansEasyFinancing.lastTransaction;
                objSubcategoryLoanssEasyFinancing.click_period__c = string.valueof(ObjLoansEasyFinancing.period);
                objSubcategoryLoanssEasyFinancing.click_periodIsRegular__c = string.valueof(ObjLoansEasyFinancing.periodIsRegular);
                objSubcategoryLoanssEasyFinancing.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
    //          objSubcategoryLoanssEasyFinancing.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssEasyFinancing.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssEasyFinancing.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansEasyFinancing.transactions != null && ObjLoansEasyFinancing.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objEasyFinancingTransaction : ObjLoansEasyFinancing.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Easy Financing Loans';
                        if(objEasyFinancingTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objEasyFinancingTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objEasyFinancingTransaction.strdate;
                        objTransaction.click_text__c = objEasyFinancingTransaction.text;
                        if(objEasyFinancingTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objEasyFinancingTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objEasyFinancingTransaction.amount);
                        objTransaction.click_type__c = objEasyFinancingTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objEasyFinancingTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssEasyFinancing);
            }
            if(ObjLoans.FairGoFinance != null)
            {
                FromBankstatementWrapper.cls_FairGoFinance ObjLoansFairGoFinance = ObjLoans.FairGoFinance;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssFairGoFinance = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssFairGoFinance.Name = 'Fair Go Finance';
                objSubcategoryLoanssFairGoFinance.Dependent__c = 'Fair Go Finance';
                objSubcategoryLoanssFairGoFinance.Click_TransactionCount__c = string.valueof(ObjLoansFairGoFinance.transactionCount);
                objSubcategoryLoanssFairGoFinance.click_totalValue__c = string.valueof(ObjLoansFairGoFinance.totalValue);
                objSubcategoryLoanssFairGoFinance.click_monthAvg__c = string.valueof(ObjLoansFairGoFinance.monthAvg);
                objSubcategoryLoanssFairGoFinance.click_minValue__c = string.valueof(ObjLoansFairGoFinance.minValue);
                objSubcategoryLoanssFairGoFinance.click_maxValue__c = string.valueof(ObjLoansFairGoFinance.maxValue);
                objSubcategoryLoanssFairGoFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssFairGoFinance.click_firstTransaction__c = ObjLoansFairGoFinance.firstTransaction;
                objSubcategoryLoanssFairGoFinance.click_lastTransaction__c = ObjLoansFairGoFinance.lastTransaction;
                objSubcategoryLoanssFairGoFinance.click_period__c = string.valueof(ObjLoansFairGoFinance.period);
                objSubcategoryLoanssFairGoFinance.click_periodIsRegular__c = string.valueof(ObjLoansFairGoFinance.periodIsRegular);
                objSubcategoryLoanssFairGoFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //       objSubcategoryLoanssFairGoFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssFairGoFinance.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssFairGoFinance.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansFairGoFinance.transactions != null && ObjLoansFairGoFinance.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objFairGoFinanceTransaction : ObjLoansFairGoFinance.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Fair Go Finance Loans';
                        if(objFairGoFinanceTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objFairGoFinanceTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objFairGoFinanceTransaction.strdate;
                        objTransaction.click_text__c = objFairGoFinanceTransaction.text;
                        if(objFairGoFinanceTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objFairGoFinanceTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objFairGoFinanceTransaction.amount);
                        objTransaction.click_type__c = objFairGoFinanceTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objFairGoFinanceTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssFairGoFinance);
            }
            if(ObjLoans.Ferratum != null)
            {
                FromBankstatementWrapper.cls_Ferratum ObjLoansFerratum = ObjLoans.Ferratum;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssFerratum = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssFerratum.Name = 'Ferratum';
                objSubcategoryLoanssFerratum.Dependent__c = 'Ferratum';
                objSubcategoryLoanssFerratum.Click_TransactionCount__c = string.valueof(ObjLoansFerratum.transactionCount);
                objSubcategoryLoanssFerratum.click_totalValue__c = string.valueof(ObjLoansFerratum.totalValue);
                objSubcategoryLoanssFerratum.click_monthAvg__c = string.valueof(ObjLoansFerratum.monthAvg);
                objSubcategoryLoanssFerratum.click_minValue__c = string.valueof(ObjLoansFerratum.minValue);
                objSubcategoryLoanssFerratum.click_maxValue__c = string.valueof(ObjLoansFerratum.maxValue);
                objSubcategoryLoanssFerratum.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssFerratum.click_firstTransaction__c = ObjLoansFerratum.firstTransaction;
                objSubcategoryLoanssFerratum.click_lastTransaction__c = ObjLoansFerratum.lastTransaction;
                objSubcategoryLoanssFerratum.click_period__c = string.valueof(ObjLoansFerratum.period);
                objSubcategoryLoanssFerratum.click_periodIsRegular__c = string.valueof(ObjLoansFerratum.periodIsRegular);
                objSubcategoryLoanssFerratum.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //       objSubcategoryLoanssFerratum.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssFerratum.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssFerratum.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansFerratum.transactions != null && ObjLoansFerratum.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objFerratumTransaction : ObjLoansFerratum.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Ferratum Loans';
                        if(objFerratumTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objFerratumTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objFerratumTransaction.strdate;
                        objTransaction.click_text__c = objFerratumTransaction.text;
                        if(objFerratumTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objFerratumTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objFerratumTransaction.amount);
                        objTransaction.click_type__c = objFerratumTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objFerratumTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssFerratum);
            }
            if(ObjLoans.FirstStopMoney != null)
            {
                FromBankstatementWrapper.cls_FirstStopMoney ObjLoansFirstStopMoney = ObjLoans.FirstStopMoney;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssFirstStopMoney = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssFirstStopMoney.Name = 'First Stop Money';
                objSubcategoryLoanssFirstStopMoney.Dependent__c = 'First Stop Money';
                objSubcategoryLoanssFirstStopMoney.Click_TransactionCount__c = string.valueof(ObjLoansFirstStopMoney.transactionCount);
                objSubcategoryLoanssFirstStopMoney.click_totalValue__c = string.valueof(ObjLoansFirstStopMoney.totalValue);
                objSubcategoryLoanssFirstStopMoney.click_monthAvg__c = string.valueof(ObjLoansFirstStopMoney.monthAvg);
                objSubcategoryLoanssFirstStopMoney.click_minValue__c = string.valueof(ObjLoansFirstStopMoney.minValue);
                objSubcategoryLoanssFirstStopMoney.click_maxValue__c = string.valueof(ObjLoansFirstStopMoney.maxValue);
                objSubcategoryLoanssFirstStopMoney.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssFirstStopMoney.click_firstTransaction__c = ObjLoansFirstStopMoney.firstTransaction;
                objSubcategoryLoanssFirstStopMoney.click_lastTransaction__c = ObjLoansFirstStopMoney.lastTransaction;
                objSubcategoryLoanssFirstStopMoney.click_period__c = string.valueof(ObjLoansFirstStopMoney.period);
                objSubcategoryLoanssFirstStopMoney.click_periodIsRegular__c = string.valueof(ObjLoansFirstStopMoney.periodIsRegular);
                objSubcategoryLoanssFirstStopMoney.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //        objSubcategoryLoanssFirstStopMoney.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssFirstStopMoney.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssFirstStopMoney.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansFirstStopMoney.transactions != null && ObjLoansFirstStopMoney.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objFirstStopMoneyTransaction : ObjLoansFirstStopMoney.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction First Stop Money Loans';
                        if(objFirstStopMoneyTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objFirstStopMoneyTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objFirstStopMoneyTransaction.strdate;
                        objTransaction.click_text__c = objFirstStopMoneyTransaction.text;
                        if(objFirstStopMoneyTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objFirstStopMoneyTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objFirstStopMoneyTransaction.amount);
                        objTransaction.click_type__c = objFirstStopMoneyTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objFirstStopMoneyTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssFirstStopMoney);
            }
            if(ObjLoans.FoxSymes != null)
            {
                FromBankstatementWrapper.cls_FoxSymes ObjLoansFoxSymes = ObjLoans.FoxSymes;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssFoxSymes = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssFoxSymes.Name = 'Fox Symes';
                objSubcategoryLoanssFoxSymes.Dependent__c = 'Fox Symes';
                objSubcategoryLoanssFoxSymes.Click_TransactionCount__c = string.valueof(ObjLoansFoxSymes.transactionCount);
                objSubcategoryLoanssFoxSymes.click_totalValue__c = string.valueof(ObjLoansFoxSymes.totalValue);
                objSubcategoryLoanssFoxSymes.click_monthAvg__c = string.valueof(ObjLoansFoxSymes.monthAvg);
                objSubcategoryLoanssFoxSymes.click_minValue__c = string.valueof(ObjLoansFoxSymes.minValue);
                objSubcategoryLoanssFoxSymes.click_maxValue__c = string.valueof(ObjLoansFoxSymes.maxValue);
                objSubcategoryLoanssFoxSymes.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssFoxSymes.click_firstTransaction__c = ObjLoansFoxSymes.firstTransaction;
                objSubcategoryLoanssFoxSymes.click_lastTransaction__c = ObjLoansFoxSymes.lastTransaction;
                objSubcategoryLoanssFoxSymes.click_period__c = string.valueof(ObjLoansFoxSymes.period);
                objSubcategoryLoanssFoxSymes.click_periodIsRegular__c = string.valueof(ObjLoansFoxSymes.periodIsRegular);
                objSubcategoryLoanssFoxSymes.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //      objSubcategoryLoanssFoxSymes.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssFoxSymes.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssFoxSymes.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansFoxSymes.transactions != null && ObjLoansFoxSymes.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objFoxSymesTransaction : ObjLoansFoxSymes.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Fox Symes Loans';
                        if(objFoxSymesTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objFoxSymesTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objFoxSymesTransaction.strdate;
                        objTransaction.click_text__c = objFoxSymesTransaction.text;
                        if(objFoxSymesTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objFoxSymesTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objFoxSymesTransaction.amount);
                        objTransaction.click_type__c = objFoxSymesTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objFoxSymesTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssFoxSymes);
            }
            if(ObjLoans.FundCo != null)
            {
                FromBankstatementWrapper.cls_FundCo ObjLoansFundCo = ObjLoans.FundCo;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssFundCo = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssFundCo.Name = 'FundCo';
                objSubcategoryLoanssFundCo.Dependent__c = 'FundCo';
                objSubcategoryLoanssFundCo.Click_TransactionCount__c = string.valueof(ObjLoansFundCo.transactionCount);
                objSubcategoryLoanssFundCo.click_totalValue__c = string.valueof(ObjLoansFundCo.totalValue);
                objSubcategoryLoanssFundCo.click_monthAvg__c = string.valueof(ObjLoansFundCo.monthAvg);
                objSubcategoryLoanssFundCo.click_minValue__c = string.valueof(ObjLoansFundCo.minValue);
                objSubcategoryLoanssFundCo.click_maxValue__c = string.valueof(ObjLoansFundCo.maxValue);
                objSubcategoryLoanssFundCo.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssFundCo.click_firstTransaction__c = ObjLoansFundCo.firstTransaction;
                objSubcategoryLoanssFundCo.click_lastTransaction__c = ObjLoansFundCo.lastTransaction;
                objSubcategoryLoanssFundCo.click_period__c = string.valueof(ObjLoansFundCo.period);
                objSubcategoryLoanssFundCo.click_periodIsRegular__c = string.valueof(ObjLoansFundCo.periodIsRegular);
                objSubcategoryLoanssFundCo.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
    //          objSubcategoryLoanssFundCo.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssFundCo.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssFundCo.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansFundCo.transactions != null && ObjLoansFundCo.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objFundCoTransaction : ObjLoansFundCo.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction FundCo Loans';
                        if(objFundCoTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objFundCoTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objFundCoTransaction.strdate;
                        objTransaction.click_text__c = objFundCoTransaction.text;
                        if(objFundCoTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objFundCoTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objFundCoTransaction.amount);
                        objTransaction.click_type__c = objFundCoTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objFundCoTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssFundCo);
            }
            if(ObjLoans.JacarandaFinance != null)
            {
                FromBankstatementWrapper.cls_JacarandaFinance ObjLoansJacarandaFinance = ObjLoans.JacarandaFinance;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssJacarandaFinance = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssJacarandaFinance.Name = 'Jacaranda Finance';
                objSubcategoryLoanssJacarandaFinance.Dependent__c = 'Jacaranda Finance';
                objSubcategoryLoanssJacarandaFinance.Click_TransactionCount__c = string.valueof(ObjLoansJacarandaFinance.transactionCount);
                objSubcategoryLoanssJacarandaFinance.click_totalValue__c = string.valueof(ObjLoansJacarandaFinance.totalValue);
                objSubcategoryLoanssJacarandaFinance.click_monthAvg__c = string.valueof(ObjLoansJacarandaFinance.monthAvg);
                objSubcategoryLoanssJacarandaFinance.click_minValue__c = string.valueof(ObjLoansJacarandaFinance.minValue);
                objSubcategoryLoanssJacarandaFinance.click_maxValue__c = string.valueof(ObjLoansJacarandaFinance.maxValue);
                objSubcategoryLoanssJacarandaFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssJacarandaFinance.click_firstTransaction__c = ObjLoansJacarandaFinance.firstTransaction;
                objSubcategoryLoanssJacarandaFinance.click_lastTransaction__c = ObjLoansJacarandaFinance.lastTransaction;
                objSubcategoryLoanssJacarandaFinance.click_period__c = string.valueof(ObjLoansJacarandaFinance.period);
                objSubcategoryLoanssJacarandaFinance.click_periodIsRegular__c = string.valueof(ObjLoansJacarandaFinance.periodIsRegular);
                objSubcategoryLoanssJacarandaFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
     //         objSubcategoryLoanssJacarandaFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssJacarandaFinance.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssJacarandaFinance.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansJacarandaFinance.transactions != null && ObjLoansJacarandaFinance.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objJacarandaFinanceTransaction : ObjLoansJacarandaFinance.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Jacaranda Finance Loans';
                        if(objJacarandaFinanceTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objJacarandaFinanceTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objJacarandaFinanceTransaction.strdate;
                        objTransaction.click_text__c = objJacarandaFinanceTransaction.text;
                        if(objJacarandaFinanceTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objJacarandaFinanceTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objJacarandaFinanceTransaction.amount);
                        objTransaction.click_type__c = objJacarandaFinanceTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objJacarandaFinanceTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssJacarandaFinance);
            }
            if(ObjLoans.JetLending != null)
            {
                FromBankstatementWrapper.cls_JetLending ObjLoansJetLending = ObjLoans.JetLending;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssJetLending = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssJetLending.Name = 'Jet Lending';
                objSubcategoryLoanssJetLending.Dependent__c = 'Jet Lending';
                objSubcategoryLoanssJetLending.Click_TransactionCount__c = string.valueof(ObjLoansJetLending.transactionCount);
                objSubcategoryLoanssJetLending.click_totalValue__c = string.valueof(ObjLoansJetLending.totalValue);
                objSubcategoryLoanssJetLending.click_monthAvg__c = string.valueof(ObjLoansJetLending.monthAvg);
                objSubcategoryLoanssJetLending.click_minValue__c = string.valueof(ObjLoansJetLending.minValue);
                objSubcategoryLoanssJetLending.click_maxValue__c = string.valueof(ObjLoansJetLending.maxValue);
                objSubcategoryLoanssJetLending.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssJetLending.click_firstTransaction__c = ObjLoansJetLending.firstTransaction;
                objSubcategoryLoanssJetLending.click_lastTransaction__c = ObjLoansJetLending.lastTransaction;
                objSubcategoryLoanssJetLending.click_period__c = string.valueof(ObjLoansJetLending.period);
                objSubcategoryLoanssJetLending.click_periodIsRegular__c = string.valueof(ObjLoansJetLending.periodIsRegular);
                objSubcategoryLoanssJetLending.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //     objSubcategoryLoanssJetLending.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssJetLending.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssJetLending.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansJetLending.transactions != null && ObjLoansJetLending.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objJetLendingTransaction : ObjLoansJetLending.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Jet Lending Loans';
                        if(objJetLendingTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objJetLendingTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objJetLendingTransaction.strdate;
                        objTransaction.click_text__c = objJetLendingTransaction.text;
                        if(objJetLendingTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objJetLendingTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objJetLendingTransaction.amount);
                        objTransaction.click_type__c = objJetLendingTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objJetLendingTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssJetLending);
            }
            if(ObjLoans.JPCreditline != null)
            {
                FromBankstatementWrapper.cls_JPCreditline ObjLoansJPCreditline = ObjLoans.JPCreditline;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssJPCreditline = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssJPCreditline.Name = 'JP Creditline';
                objSubcategoryLoanssJPCreditline.Dependent__c = 'JP Creditline';
                objSubcategoryLoanssJPCreditline.Click_TransactionCount__c = string.valueof(ObjLoansJPCreditline.transactionCount);
                objSubcategoryLoanssJPCreditline.click_totalValue__c = string.valueof(ObjLoansJPCreditline.totalValue);
                objSubcategoryLoanssJPCreditline.click_monthAvg__c = string.valueof(ObjLoansJPCreditline.monthAvg);
                objSubcategoryLoanssJPCreditline.click_minValue__c = string.valueof(ObjLoansJPCreditline.minValue);
                objSubcategoryLoanssJPCreditline.click_maxValue__c = string.valueof(ObjLoansJPCreditline.maxValue);
                objSubcategoryLoanssJPCreditline.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssJPCreditline.click_firstTransaction__c = ObjLoansJPCreditline.firstTransaction;
                objSubcategoryLoanssJPCreditline.click_lastTransaction__c = ObjLoansJPCreditline.lastTransaction;
                objSubcategoryLoanssJPCreditline.click_period__c = string.valueof(ObjLoansJPCreditline.period);
                objSubcategoryLoanssJPCreditline.click_periodIsRegular__c = string.valueof(ObjLoansJPCreditline.periodIsRegular);
                objSubcategoryLoanssJPCreditline.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //        objSubcategoryLoanssJPCreditline.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssJPCreditline.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssJPCreditline.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansJPCreditline.transactions != null && ObjLoansJPCreditline.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objJPCreditlineTransaction : ObjLoansJPCreditline.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction JP Creditline Loans';
                        if(objJPCreditlineTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objJPCreditlineTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objJPCreditlineTransaction.strdate;
                        objTransaction.click_text__c = objJPCreditlineTransaction.text;
                        if(objJPCreditlineTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objJPCreditlineTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objJPCreditlineTransaction.amount);
                        objTransaction.click_type__c = objJPCreditlineTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objJPCreditlineTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssJPCreditline);
            }
            if(ObjLoans.K24 != null)
            {
                FromBankstatementWrapper.cls_K24 ObjLoansK24 = ObjLoans.K24;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssK24 = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssK24.Name = 'K24';
                objSubcategoryLoanssK24.Dependent__c = 'K24';
                objSubcategoryLoanssK24.Click_TransactionCount__c = string.valueof(ObjLoansK24.transactionCount);
                objSubcategoryLoanssK24.click_totalValue__c = string.valueof(ObjLoansK24.totalValue);
                objSubcategoryLoanssK24.click_monthAvg__c = string.valueof(ObjLoansK24.monthAvg);
                objSubcategoryLoanssK24.click_minValue__c = string.valueof(ObjLoansK24.minValue);
                objSubcategoryLoanssK24.click_maxValue__c = string.valueof(ObjLoansK24.maxValue);
                objSubcategoryLoanssK24.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssK24.click_firstTransaction__c = ObjLoansK24.firstTransaction;
                objSubcategoryLoanssK24.click_lastTransaction__c = ObjLoansK24.lastTransaction;
                objSubcategoryLoanssK24.click_period__c = string.valueof(ObjLoansK24.period);
                objSubcategoryLoanssK24.click_periodIsRegular__c = string.valueof(ObjLoansK24.periodIsRegular);
                objSubcategoryLoanssK24.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //     objSubcategoryLoanssK24.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssK24.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssK24.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansK24.transactions != null && ObjLoansK24.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objK24Transaction : ObjLoansK24.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction K24 Loans';
                        if(objK24Transaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objK24Transaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objK24Transaction.strdate;
                        objTransaction.click_text__c = objK24Transaction.text;
                        if(objK24Transaction.notes != null)
                        {
                            objTransaction.click_notes__c = objK24Transaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objK24Transaction.amount);
                        objTransaction.click_type__c = objK24Transaction.type;
                        objTransaction.click_balance__c = string.valueOf(objK24Transaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssK24);
            }
            if(ObjLoans.KangarooPayday != null)
            {
                FromBankstatementWrapper.cls_KangarooPayday ObjLoansKangarooPayday = ObjLoans.KangarooPayday;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssKangarooPayday = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssKangarooPayday.Name = 'Kangaroo Payday';
                objSubcategoryLoanssKangarooPayday.Dependent__c = 'Kangaroo Payday';
                objSubcategoryLoanssKangarooPayday.Click_TransactionCount__c = string.valueof(ObjLoansKangarooPayday.transactionCount);
                objSubcategoryLoanssKangarooPayday.click_totalValue__c = string.valueof(ObjLoansKangarooPayday.totalValue);
                objSubcategoryLoanssKangarooPayday.click_monthAvg__c = string.valueof(ObjLoansKangarooPayday.monthAvg);
                objSubcategoryLoanssKangarooPayday.click_minValue__c = string.valueof(ObjLoansKangarooPayday.minValue);
                objSubcategoryLoanssKangarooPayday.click_maxValue__c = string.valueof(ObjLoansKangarooPayday.maxValue);
                objSubcategoryLoanssKangarooPayday.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssKangarooPayday.click_firstTransaction__c = ObjLoansKangarooPayday.firstTransaction;
                objSubcategoryLoanssKangarooPayday.click_lastTransaction__c = ObjLoansKangarooPayday.lastTransaction;
                objSubcategoryLoanssKangarooPayday.click_period__c = string.valueof(ObjLoansKangarooPayday.period);
                objSubcategoryLoanssKangarooPayday.click_periodIsRegular__c = string.valueof(ObjLoansKangarooPayday.periodIsRegular);
                objSubcategoryLoanssKangarooPayday.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //    objSubcategoryLoanssKangarooPayday.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssKangarooPayday.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssKangarooPayday.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansKangarooPayday.transactions != null && ObjLoansKangarooPayday.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objKangarooPaydayTransaction : ObjLoansKangarooPayday.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Kangaroo Payday Loans';
                        if(objKangarooPaydayTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objKangarooPaydayTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objKangarooPaydayTransaction.strdate;
                        objTransaction.click_text__c = objKangarooPaydayTransaction.text;
                        if(objKangarooPaydayTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objKangarooPaydayTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objKangarooPaydayTransaction.amount);
                        objTransaction.click_type__c = objKangarooPaydayTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objKangarooPaydayTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssKangarooPayday);
            }
            if(ObjLoans.Kreditech != null)
            {
                FromBankstatementWrapper.cls_Kreditech ObjLoansKreditech = ObjLoans.Kreditech;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssKreditech = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssKreditech.Name = 'Kreditech';
                objSubcategoryLoanssKreditech.Dependent__c = 'Kreditech';
                objSubcategoryLoanssKreditech.Click_TransactionCount__c = string.valueof(ObjLoansKreditech.transactionCount);
                objSubcategoryLoanssKreditech.click_totalValue__c = string.valueof(ObjLoansKreditech.totalValue);
                objSubcategoryLoanssKreditech.click_monthAvg__c = string.valueof(ObjLoansKreditech.monthAvg);
                objSubcategoryLoanssKreditech.click_minValue__c = string.valueof(ObjLoansKreditech.minValue);
                objSubcategoryLoanssKreditech.click_maxValue__c = string.valueof(ObjLoansKreditech.maxValue);
                objSubcategoryLoanssKreditech.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssKreditech.click_firstTransaction__c = ObjLoansKreditech.firstTransaction;
                objSubcategoryLoanssKreditech.click_lastTransaction__c = ObjLoansKreditech.lastTransaction;
                objSubcategoryLoanssKreditech.click_period__c = string.valueof(ObjLoansKreditech.period);
                objSubcategoryLoanssKreditech.click_periodIsRegular__c = string.valueof(ObjLoansKreditech.periodIsRegular);
                objSubcategoryLoanssKreditech.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
  //            objSubcategoryLoanssKreditech.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssKreditech.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssKreditech.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansKreditech.transactions != null && ObjLoansKreditech.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objKreditechTransaction : ObjLoansKreditech.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Kreditech Loans';
                        if(objKreditechTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objKreditechTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objKreditechTransaction.strdate;
                        objTransaction.click_text__c = objKreditechTransaction.text;
                        if(objKreditechTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objKreditechTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objKreditechTransaction.amount);
                        objTransaction.click_type__c = objKreditechTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objKreditechTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssKreditech);
            }
            if(ObjLoans.KwikFinance != null)
            {
                FromBankstatementWrapper.cls_KwikFinance ObjLoansKwikFinance = ObjLoans.KwikFinance;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssKwikFinance = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssKwikFinance.Name = 'Kwik Finance';
                objSubcategoryLoanssKwikFinance.Dependent__c = 'Kwik Finance';
                objSubcategoryLoanssKwikFinance.Click_TransactionCount__c = string.valueof(ObjLoansKwikFinance.transactionCount);
                objSubcategoryLoanssKwikFinance.click_totalValue__c = string.valueof(ObjLoansKwikFinance.totalValue);
                objSubcategoryLoanssKwikFinance.click_monthAvg__c = string.valueof(ObjLoansKwikFinance.monthAvg);
                objSubcategoryLoanssKwikFinance.click_minValue__c = string.valueof(ObjLoansKwikFinance.minValue);
                objSubcategoryLoanssKwikFinance.click_maxValue__c = string.valueof(ObjLoansKwikFinance.maxValue);
                objSubcategoryLoanssKwikFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssKwikFinance.click_firstTransaction__c = ObjLoansKwikFinance.firstTransaction;
                objSubcategoryLoanssKwikFinance.click_lastTransaction__c = ObjLoansKwikFinance.lastTransaction;
                objSubcategoryLoanssKwikFinance.click_period__c = string.valueof(ObjLoansKwikFinance.period);
                objSubcategoryLoanssKwikFinance.click_periodIsRegular__c = string.valueof(ObjLoansKwikFinance.periodIsRegular);
                objSubcategoryLoanssKwikFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
  //            objSubcategoryLoanssKwikFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssKwikFinance.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssKwikFinance.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansKwikFinance.transactions != null && ObjLoansKwikFinance.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objKwikFinanceTransaction : ObjLoansKwikFinance.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Kwik Finance Loans';
                        if(objKwikFinanceTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objKwikFinanceTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objKwikFinanceTransaction.strdate;
                        objTransaction.click_text__c = objKwikFinanceTransaction.text;
                        if(objKwikFinanceTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objKwikFinanceTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objKwikFinanceTransaction.amount);
                        objTransaction.click_type__c = objKwikFinanceTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objKwikFinanceTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssKwikFinance);
            }
            if(ObjLoans.LionFinance != null)
            {
                FromBankstatementWrapper.cls_LionFinance ObjLoansLionFinance = ObjLoans.LionFinance;
                click_Bank_Statements_Sub_Category__c objSubcategoryLoanssLionFinance = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryLoanssLionFinance.Name = 'Lion Finance';
                objSubcategoryLoanssLionFinance.Dependent__c = 'Lion Finance';
                objSubcategoryLoanssLionFinance.Click_TransactionCount__c = string.valueof(ObjLoansLionFinance.transactionCount);
                objSubcategoryLoanssLionFinance.click_totalValue__c = string.valueof(ObjLoansLionFinance.totalValue);
                objSubcategoryLoanssLionFinance.click_monthAvg__c = string.valueof(ObjLoansLionFinance.monthAvg);
                objSubcategoryLoanssLionFinance.click_minValue__c = string.valueof(ObjLoansLionFinance.minValue);
                objSubcategoryLoanssLionFinance.click_maxValue__c = string.valueof(ObjLoansLionFinance.maxValue);
                objSubcategoryLoanssLionFinance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryLoanssLionFinance.click_firstTransaction__c = ObjLoansLionFinance.firstTransaction;
                objSubcategoryLoanssLionFinance.click_lastTransaction__c = ObjLoansLionFinance.lastTransaction;
                objSubcategoryLoanssLionFinance.click_period__c = string.valueof(ObjLoansLionFinance.period);
                objSubcategoryLoanssLionFinance.click_periodIsRegular__c = string.valueof(ObjLoansLionFinance.periodIsRegular);
                objSubcategoryLoanssLionFinance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
     //         objSubcategoryLoanssLionFinance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryLoanssLionFinance.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryLoanssLionFinance.Click_Required_Document_Id__c = ReqDocId;
                if(ObjLoansLionFinance.transactions != null && ObjLoansLionFinance.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objLionFinanceTransaction : ObjLoansLionFinance.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Lion Finance Loans';
                        if(objLionFinanceTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objLionFinanceTransaction.strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objLionFinanceTransaction.strdate;
                        objTransaction.click_text__c = objLionFinanceTransaction.text;
                        if(objLionFinanceTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objLionFinanceTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objLionFinanceTransaction.amount);
                        objTransaction.click_type__c = objLionFinanceTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objLionFinanceTransaction.balance);
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
                lstSubctegory.add(objSubcategoryLoanssLionFinance);
            }
            CallBankLoanPart2.CallBankLoansrestPart(ObjLoans,objBankStatementData,SubcategoryIndex,CategoryIndex,TransactionIndex,lstSubctegory,lstctegory,lstTransaction,AccountNumber,ReqDocId);
            
        }
    }
}