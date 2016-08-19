global without sharing class acfFetchBankStatementFile{
public static string resp = '';
public static string strreq = '';
@future(callout=true)
  public static void BankStatementFetchFile(string user_Token, string selectedAccounts, string bankname,string strEndpoint,string strApiKey,string ReqDocId) {
     try
     {
        String body = '{"user_token":"'+user_Token+'","accounts":{"'+bankname+'":['+selectedAccounts+']}}';
        Integer SubcategoryIndex = 1;
        Integer CategoryIndex = 1;
        Integer TransactionIndex = 1;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/statements');
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('X-API-KEY',strApiKey);
        req.setbody(body);
        req.setTimeout(120000);
        
        strreq = body;
        System.debug('!!!!Statement Body -'+body);
        
        Http http = new Http();
        HTTPResponse objresponse = http.send(req);
        String Statuscode = String.valueOf(objresponse.getStatusCode());
        resp = objresponse.getBody();
        
        System.debug('!!!! JSON Response - '+resp);
        
         //To fetch zip file
        HttpRequest reqest = new HttpRequest();
        reqest.setEndpoint(strEndpoint+'/files?X-API-KEY='+strApiKey+'&user_token='+user_Token);
        reqest.setMethod('GET');    
        Http httpreq = new Http();
        HTTPResponse objZipresponse = httpreq.send(reqest); 
        system.debug('objresponse?????' + objZipresponse.getBody());        
        Blob objBlob = objZipresponse.getBodyAsBlob();       
        system.debug('status???' + objZipresponse.getBodyAsBlob());
        if(objBlob <> null && ReqDocId<> null && ReqDocId<> '')
        {
            Attachment attach = new Attachment();
            attach.Body = objBlob;
            attach.Name = 'Bankstatement.zip';
            attach.ContentType = 'application/zip';            
            attach.ParentID = ReqDocId;
            insert attach;  
        }
        else
        {
            list<string> lstToaddress = new list<string>();
            string strEmail = '';
            if(System.label.acf_Bank_Statement_Response_Error_Email != null && System.label.acf_Bank_Statement_Response_Error_Email !='')
                strEmail = System.label.acf_Bank_Statement_Response_Error_Email;
            if(strEmail != null && strEmail != '')  
            {
                string[] strToaddress = strEmail.split(';');
                for(string strObjEmail : strToaddress)
                {
                    lstToaddress.add(strObjEmail);
                }
            }
            if(!lstToaddress.isEmpty())
            {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                string strSubject = 'Bank Statement Zip Issue';
                string strContent = 'Required Document Id:'+ReqDocId+'\n Exception: File does not exist.';
                email.setToAddresses(lstToaddress);   
                email.setSubject(strSubject);
                email.setSenderDisplayName('ACF Support');
                email.setPlainTextBody(strContent);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }
    
       
        if(string.isNotEmpty(resp))
        {
            if(resp.Contains('accounts'))
            {
                string strRemoveaccount = resp.left(12);
                resp = resp.removestart(strRemoveaccount);               
            }  
            if(resp.Contains('date'))
            resp = resp.replaceAll('date','strDate');
            if(resp.Contains(bankname))
            resp = resp.replaceFirst(bankname,'BankName');
            if(resp.Contains('Other Debits'))
            resp = resp.replaceAll('Other Debits','OtherDebits');
            if(resp.Contains('Maternity Payment'))
            resp = resp.replaceFirst('Maternity Payment','MaternityPayment');
            if(resp.Contains('Family Benefits'))
            resp = resp.replaceFirst('Family Benefits','FamilyBenefits');
            if(resp.Contains('Schoolkids Bonus'))
            resp = resp.replaceFirst('Schoolkids Bonus','SchoolkidsBonus');
            if(resp.Contains('Parenting Payment'))
            resp = resp.replaceFirst('Parenting Payment','ParentingPayment');
            if(resp.Contains('Carers Benefits'))
            resp = resp.replaceFirst('Carers Benefits','CarersBenefits');
            if(resp.Contains('Youth Allowance'))
            resp = resp.replaceFirst('Youth Allowance','YouthAllowance');
            if(resp.Contains('Amazing Loans'))
            resp = resp.replaceFirst('Amazing Loans','AmazingLoans');
            if(resp.Contains('AMX Money'))
            resp = resp.replaceFirst('AMX Money','AMXMoney');
            if(resp.Contains('Aus Financial'))
            resp = resp.replaceFirst('Aus Financial','AusFinancial');
            if(resp.Contains('Aussie Cash'))
            resp = resp.replaceFirst('Aussie Cash','AussieCash');
            if(resp.Contains('Cannon Finance'))
            resp = resp.replaceFirst('Cannon Finance','CannonFinance');
            if(resp.Contains('Cash Advance'))
            resp = resp.replaceFirst('Cash Advance','CashAdvance');
            if(resp.Contains('Cash Converters'))
            resp = resp.replaceFirst('Cash Converters','CashConverters');
            if(resp.Contains('Cash Doctors'))
            resp = resp.replaceFirst('Cash Doctors','CashDoctors');
            if(resp.Contains('Cash First'))
            resp = resp.replaceFirst('Cash First','CashFirst');
            if(resp.Contains('Cash in a Flash'))
            resp = resp.replaceFirst('Cash in a Flash','CashinaFlash');
            if(resp.Contains('Cash Money'))
            resp = resp.replaceFirst('Cash Money','CashMoney');
            if(resp.Contains('Cash Now'))
            resp = resp.replaceFirst('Cash Now','CashNow');
            if(resp.Contains('Cash Oz'))
            resp = resp.replaceFirst('Cash Oz','CashOz');
            if(resp.Contains('Cash Solutions'))
            resp = resp.replaceFirst('Cash Solutions','CashSolutions');
            if(resp.Contains('Cash Smart'))
            resp = resp.replaceFirst('Cash Smart','CashSmart');
            if(resp.Contains('Cash Stop'))
            resp = resp.replaceFirst('Cash Stop','CashStop');
            if(resp.Contains('Cash Today'))
            resp = resp.replaceFirst('Cash Today','CashToday');
            if(resp.Contains('Cash Train'))
            resp = resp.replaceFirst('Cash Train','CashTrain');
            if(resp.Contains('Center One'))
            resp = resp.replaceFirst('Center One','CenterOne');
            if(resp.Contains('Champion Loans'))
            resp = resp.replaceFirst('Champion Loans','ChampionLoans');
            if(resp.Contains('Champion Money'))
            resp = resp.replaceFirst('Champion Money','ChampionMoney');
            if(resp.Contains('City Finance'))
            resp = resp.replaceFirst('City Finance','CityFinance');
            if(resp.Contains('Clear Cash'))
            resp = resp.replaceFirst('Clear Cash','ClearCash');
            if(resp.Contains('Credit Corp'))
            resp = resp.replaceFirst('Credit Corp','CreditCorp');
            if(resp.Contains('Debt Fix'))
            resp = resp.replaceFirst('Debt Fix','DebtFix');
            if(resp.Contains('Dollars Direct'))
            resp = resp.replaceFirst('Dollars Direct','DollarsDirect');
            if(resp.Contains('Easy Financing'))
            resp = resp.replaceFirst('Easy Financing','EasyFinancing');
            if(resp.Contains('Fair Go Finance'))
            resp = resp.replaceFirst('Fair Go Finance','FairGoFinance');
            if(resp.Contains('First Stop Money'))
            resp = resp.replaceFirst('First Stop Money','FirstStopMoney');
            if(resp.Contains('Fox Symes'))
            resp = resp.replaceFirst('Fox Symes','FoxSymes');
            if(resp.Contains('Jacaranda Finance'))
            resp = resp.replaceFirst('Jacaranda Finance','JacarandaFinance');
            if(resp.Contains('Jet Lending'))
            resp = resp.replaceFirst('Jet Lending','JetLending');
            if(resp.Contains('JP Creditline'))
            resp = resp.replaceFirst('JP Creditline','JPCreditline');
            if(resp.Contains('Kangaroo Payday'))
            resp = resp.replaceFirst('Kangaroo Payday','KangarooPayday');
            if(resp.Contains('Kwik Finance'))
            resp = resp.replaceFirst('Kwik Finance','KwikFinance');
            if(resp.Contains('Lion Finance'))
            resp = resp.replaceFirst('Lion Finance','LionFinance');
            if(resp.Contains('Loans by Phone'))
            resp = resp.replaceFirst('Loans by Phone','LoansbyPhone');
            if(resp.Contains('Loan Ranger'))
            resp = resp.replaceFirst('Loan Ranger','LoanRanger');
            if(resp.Contains('Max Finance'))
            resp = resp.replaceFirst('Max Finance','MaxFinance');
            if(resp.Contains('Max Funding'))
            resp = resp.replaceFirst('Max Funding','MaxFunding');
            if(resp.Contains('Money Now'))
            resp = resp.replaceFirst('Money Now','MoneyNow');
            if(resp.Contains('Morgan Finance'))
            resp = resp.replaceFirst('Morgan Finance','MorganFinance');
            if(resp.Contains('My Budget'))
            resp = resp.replaceFirst('My Budget','MyBudget');
            if(resp.Contains('Needy Money'))
            resp = resp.replaceFirst('Needy Money','NeedyMoney');
            if(resp.Contains('OK Money'))
            resp = resp.replaceFirst('OK Money','OKMoney');
            if(resp.Contains('Payday King'))
            resp = resp.replaceFirst('Payday King','PaydayKing');
            if(resp.Contains('Payday Land'))
            resp = resp.replaceFirst('Payday Land','PaydayLand');
            if(resp.Contains('Payday Mate'))
            resp = resp.replaceFirst('Payday Mate','PaydayMate');
            if(resp.Contains('Personal Finance Co'))
            resp = resp.replaceFirst('Personal Finance Co','PersonalFinanceCo');
            if(resp.Contains('Prime Lenders'))
            resp = resp.replaceFirst('Prime Lenders','PrimeLenders');
            if(resp.Contains('Perfect Payday'))
            resp = resp.replaceFirst('Perfect Payday','PerfectPayday');
            if(resp.Contains('Rapid Loans'))
            resp = resp.replaceFirst('Rapid Loans','RapidLoans');
            if(resp.Contains('Secure Funding'))
            resp = resp.replaceFirst('Secure Funding','SecureFunding');
            if(resp.Contains('Speedy Finance'))
            resp = resp.replaceFirst('Speedy Finance','SpeedyFinance');
            if(resp.Contains('Speedy Money'))
            resp = resp.replaceFirst('Speedy Money','SpeedyMoney');
            if(resp.Contains('Spot Loans'))
            resp = resp.replaceFirst('Spot Loans','SpotLoans');
            if(resp.Contains('SRG Finance'))
            resp = resp.replaceFirst('SRG Finance','SRG Finance');
            if(resp.Contains('Stress Less'))
            resp = resp.replaceFirst('Stress Less','StressLess');
            if(resp.Contains('Sunshine Loans'))
            resp = resp.replaceFirst('Sunshine Loans','SunshineLoans');
            if(resp.Contains('Swoosh Finance'))
            resp = resp.replaceFirst('Swoosh Finance','SwooshFinance');
            if(resp.Contains('Tele Loans'))
            resp = resp.replaceFirst('Tele Loans','TeleLoans');
            if(resp.Contains('Victory Funding'))
            resp = resp.replaceFirst('Victory Funding','VictoryFunding');
            if(resp.Contains('Web Moneyline'))
            resp = resp.replaceFirst('Web Moneyline','WebMoneyline');
            if(resp.Contains('Yes Loans'))
            resp = resp.replaceFirst('Yes Loans','YesLoans');
            if(resp.Contains('Collection House'))
            resp = resp.replaceFirst('Collection House','CollectionHouse');
            if(resp.Contains('Toyota Finance'))
            resp = resp.replaceFirst('Toyota Finance','ToyotaFinance');
            if(resp.Contains('Impact Financial'))
            resp = resp.replaceFirst('Impact Financial','ImpactFinancial');
            if(resp.Contains('Yamaha Motor Finance'))
            resp = resp.replaceFirst('Yamaha Motor Finance','YamahaMotorFinance');
            if(resp.Contains('Home Loan'))
            resp = resp.replaceFirst('Home Loan','HomeLoan');
            if(resp.Contains('Roxy Palace'))
            resp = resp.replaceFirst('Roxy Palace','RoxyPalace');
            if(resp.Contains('Tom Waterhouse'))
            resp = resp.replaceFirst('Tom Waterhouse','TomWaterhouse');
            if(resp.Contains('William Hill'))
            resp = resp.replaceFirst('William Hill','WilliamHill');
            if(resp.Contains('Paygate Payments'))
            resp = resp.replaceFirst('Paygate Payments','PaygatePayments');
            if(resp.Contains('Web Moneyline'))
            resp = resp.replaceFirst('Web Moneyline','WebMoneyline');
            if(resp.Contains('user_token'))
            {
                string strRemoveusertoken = resp.right(39);
                resp = resp.replace(strRemoveusertoken,'');
            }       
            system.debug('resp***********************************'+resp);
            
        }
        if(objresponse.getStatusCode() == 200)
        {
        
             FromBankstatementWrapper objfrmBnkStatementWrapper = new FromBankstatementWrapper();
             objfrmBnkStatementWrapper = FromBankstatementWrapper.parse(resp);
            
            List<click_Bank_Statements_Account__c> lstBankStatementAcc = new List<click_Bank_Statements_Account__c>();
            List<click_Bank_Statements_Sub_Category__c> lstSubctegory = new List<click_Bank_Statements_Sub_Category__c>();
            List<click_Bank_Statement_Data__c> lstctegory = new List<click_Bank_Statement_Data__c>();
            List<click_Bank_Statements_Transactions__c> lstTransaction = new List<click_Bank_Statements_Transactions__c>();
        
            if(objfrmBnkStatementWrapper != null)
            {
                system.debug('debug--------objfrmBnkStatementWrapper ----------'+objfrmBnkStatementWrapper);
                if(objfrmBnkStatementWrapper.bankname != null)    
                {   
            /*      List<click_Bank_Statements_Account__c> lstBankStatAcc = [select id,Account_Number__c from click_Bank_Statements_Account__c];
                    map<string,string> mapAccNumberToAccId = new map<string,string>();
                    if(lstBankStatAcc <> null && lstBankStatAcc.size() > 0)
                    {
                        for(click_Bank_Statements_Account__c objBnkstatementAcc : lstBankStatAcc)
                        {
                            if(string.isNotEmpty(objBnkstatementAcc.Account_Number__c))
                            {
                                mapAccNumberToAccId.put(objBnkstatementAcc.Account_Number__c,objBnkstatementAcc.Id);
                            }
                        }
                    }        */
                    system.debug('debug----------------------------------------');
                    FromBankstatementWrapper.cls_BankName objBankOfStatement = objfrmBnkStatementWrapper.bankname;
                    if(objBankOfStatement.accounts <> null && objBankOfStatement.accounts.size() > 0)
                    {  
                        system.debug('debug------------debug----------------------------'+ReqDocId);
                        for(FromBankstatementWrapper.cls_accounts objAccount : objBankOfStatement.accounts)
                        {
                            CategoryIndex = 1;
                            SubcategoryIndex = 1;
                            TransactionIndex = 1;
                            
                    //        if(!mapAccNumberToAccId.containskey(objAccount.accountNumber))
                    //        {
                                click_Bank_Statements_Account__c objBankStatementAcc = new click_Bank_Statements_Account__c();
                                objBankStatementAcc.Name = objAccount.name;
                                objBankStatementAcc.Account_Holder__c = objAccount.accountHolder;
                                objBankStatementAcc.Account_Number__c = objAccount.accountNumber;
                                objBankStatementAcc.Available__c = objAccount.available;
                                objBankStatementAcc.Balance__c = objAccount.balance;
                                objBankStatementAcc.bsb__c = objAccount.bsb;
                                objBankStatementAcc.click_id__c = objAccount.id;
                                objBankStatementAcc.click_institution__c = objAccount.institution;
                                if(string.isNotEmpty(ReqDocId))
                                objBankStatementAcc.Click_Loans_Required_Document__c = Id.valueof(ReqDocId);
                                lstBankStatementAcc.add(objBankStatementAcc);
                                system.debug('objBankStatementAcc***********************************'+objBankStatementAcc);
                    //        }
                                
                                
                                if(objAccount.statementData != null)
                                {

                                        FromBankstatementWrapper.cls_statementData objStatementData = objAccount.statementData;
                                        click_Bank_Statement_Data__c objBankStatementData = new click_Bank_Statement_Data__c();
                                        objBankStatementData.Name = 'Bank Statement Data';
                                        objBankStatementData.closingBalance__c = objStatementData.closingBalance;
                                        objBankStatementData.daysInNegative__c = string.valueOf(objStatementData.daysInNegative);
                                        objBankStatementData.endDate__c = objStatementData.endDate;
                                        objBankStatementData.errorMessage__c = objStatementData.errorMessage;
                                        objBankStatementData.maxBalance__c = objStatementData.maxBalance;
                                        objBankStatementData.minBalance__c = objStatementData.minBalance;
                                        objBankStatementData.minDayEndBalance__c = objStatementData.minDayEndBalance;
                                        objBankStatementData.openingBalance__c = objStatementData.openingBalance;
                                        objBankStatementData.startDate__c = objStatementData.startDate;
                                        objBankStatementData.totalCredits__c = objStatementData.totalCredits;
                                        objBankStatementData.totalDebits__c = objStatementData.totalDebits;
                                        objBankStatementData.Click_Statement_No__c = string.valueof(CategoryIndex);
                                        objBankStatementData.Bank_Statement_Account_Number__c = objAccount.accountNumber;
                                        if(string.isNotEmpty(ReqDocId))
                                        objBankStatementData.Click_Required_Document_Id__c = ReqDocId;
                                /*        if(objStatementData.dayEndBalances != null && objStatementData.dayEndBalances.size() > 0)
                                        {
                                            objBankStatementData.dayEndBalances__c = '';
                                            for(FromBankstatementWrapper.cls_dayEndBalances objDayEndBalance : objStatementData.dayEndBalances)
                                            {
                                                if(string.isNotEmpty(objDayEndBalance.strDate))
                                                objBankStatementData.dayEndBalances__c += '['+objDayEndBalance.strDate+ ', ';
                                                if(string.isNotEmpty(objDayEndBalance.balance))
                                                objBankStatementData.dayEndBalances__c += objDayEndBalance.balance+ '] ';
                                            }
                                        }
                                                                    
                                        if(objStatementData.details != null && objStatementData.details.size() > 0)
                                        {
                                            for(FromBankstatementWrapper.cls_details objdetail : objStatementData.details)
                                            {
                                                click_Bank_Statements_Sub_Category__c objSubcategorydetail = new click_Bank_Statements_Sub_Category__c();
                                                objSubcategorydetail.Name = 'Detail';
                                                if(objdetail.strDateObj != null)
                                                {
                                                    objSubcategorydetail.click_dateObj__c = '';
                                                    FromBankstatementWrapper.cls_strDateObj  objDateObj = objdetail.strDateObj;
                                                    if(string.isNotEmpty(objDateObj.strDate))
                                                    objSubcategorydetail.click_dateObj__c += objDateObj.strDate + ',';
                                                    if(objDateObj.timezone_type <> null)
                                                    objSubcategorydetail.click_dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                                    if(string.isNotEmpty(objDateObj.timezone))
                                                    objSubcategorydetail.click_dateObj__c += objDateObj.timezone;
                                                }
                                                objSubcategorydetail.click_date__c = objdetail.strdate;
                                                objSubcategorydetail.click_text__c = objdetail.text;
                                                if(objdetail.notes != null)
                                                {
                                                    objTransaction.click_notes__c = objdetail.notes;
                                                    objSubcategorydetail.click_notes__c = '';
                                                }
                                                objSubcategorydetail.click_amount__c = string.valueOf(objdetail.amount);
                                                objSubcategorydetail.click_type__c = objdetail.type;
                                                objSubcategorydetail.Click_Statement_No__c = string.valueOf(CategoryIndex);
                                                objSubcategorydetail.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                                                objSubcategorydetail.click_balance__c = string.valueOf(objdetail.balance);
                                          //    objSubcategorydetail.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                                                objSubcategorydetail.Bank_Statement_Account_Number__c = objAccount.accountNumber;
                                                if(string.isNotEmpty(ReqDocId))
                                                objSubcategorydetail.Click_Required_Document_Id__c = ReqDocId;
                                          // commented Tags for now.      
                                                if(objdetail.tags != null && objdetail.tags.size() > 0)
                                                {
                                                    objSubcategorydetail.click_tags__c = '';
                                                    for(FromBankstatementWrapper.cls_tags objtag : objdetail.tags)
                                                    {
                                                         
                                                        if(objtag.Income<> null && objtag.Income<> '')
                                                        {
                                                            objSubcategorydetail.click_tags__c += objtag.Income+ ';';
                                                        }
                                                      else if(objtag.strBenefits <> null && objtag.strBenefits <> '')
                                                        {
                                                            objSubcategorydetail.click_tags__c += objtag.strBenefits+';';
                                                        }
                                                        else if(objtag.strIncome <> null && objtag.strIncome <> '')
                                                        {
                                                            objSubcategorydetail.click_tags__c += objtag.strIncome+';';
                                                        }
                                                        else if(objtag.strLoans <> null && objtag.strLoans <> '')
                                                        {
                                                            objSubcategorydetail.click_tags__c += objtag.strLoans+';';
                                                        }
                                                        else if(objtag.strShortTermLender <> null && objtag.strShortTermLender <> '')
                                                        {
                                                            objSubcategorydetail.click_tags__c += objtag.strShortTermLender+';';
                                                        }
                                                        else if(objtag.strRent <> null && objtag.strRent <> '')
                                                        {
                                                            objSubcategorydetail.click_tags__c += objtag.strRent+';';
                                                        }
                                                        else if(objtag.strOtherDebits <> null && objtag.strOtherDebits <> '')
                                                        {
                                                            objSubcategorydetail.click_tags__c += objtag.strOtherDebits+';';
                                                        }
                                                    }
                                                }    
                                                lstSubctegory.add(objSubcategorydetail);
                                                SubcategoryIndex++;
                                            }
                                        }      */
                                        CategoryIndex++;
                                        lstctegory.add(objBankStatementData);
                                        if(objStatementData.analysis != null)
                                        {
                                            FromBankstatementWrapper.cls_analysis objanalysis = objStatementData.analysis;
                                            CallIncome(objanalysis,SubcategoryIndex,CategoryIndex,TransactionIndex,lstSubctegory,lstctegory,lstTransaction,objAccount.accountNumber,ReqDocId);
                                            
                                            
                                        }      
                                        
                                  //  }
                                }      
                        }
                        CategoryIndex = 1;
                    }
                }
            }
            if(lstBankStatementAcc <> null && lstBankStatementAcc.size() > 0)
            {
                insert lstBankStatementAcc;
                system.debug('lstBankStatementAcc***********************************'+lstBankStatementAcc);
            }
           
            if(lstctegory <> null && lstctegory.size() > 0)
            {
                insert lstctegory;
                system.debug('lstctegory***********************************'+lstctegory);
            }
             if(lstSubctegory <> null && lstSubctegory.size() > 0)
            {
                insert lstSubctegory;
                system.debug('lstSubctegory***********************************'+lstSubctegory);
            }
            if(lstTransaction <> null && lstTransaction.size() > 0)
            {
                insert lstTransaction;
                system.debug('lstTransaction***********************************'+lstTransaction);
            } 
        } 
      }
      catch(Exception Ex)
      {
            // sending email when any exception occurs. 
            list<string> lstToaddress = new list<string>();
            string strEmail='';
            if(System.label.acf_Bank_Statement_Response_Error_Email != null && System.label.acf_Bank_Statement_Response_Error_Email !='')
                strEmail = System.label.acf_Bank_Statement_Response_Error_Email;
            if(strEmail != null && strEmail != '')
            {
                string[] strToaddress = strEmail.split(';');
                for(string strObjEmail : strToaddress)
                {
                    lstToaddress.add(strObjEmail);
                }
            }
            if(!lstToaddress.isEmpty())
            {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('BankStatement Response');
                if(resp != null && resp != '')
                {
                    Blob b = blob.valueOf(resp);
                    efa.setBody(b);
                }
                
                Messaging.EmailFileAttachment efas = new Messaging.EmailFileAttachment();
                efas.setFileName('BankStatement Request');
                Blob bl = blob.valueOf(strreq);
                efas.setBody(bl);

                system.debug('!@#$%%%^'+Ex.getmessage());
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                string strSubject = 'Bank Statement Response Issue';
                string strContent = 'Required Document Id:'+ReqDocId+'\n Exception:'+Ex.getmessage();
                email.setToAddresses(lstToaddress);   
                email.setSubject(strSubject);
                email.setSenderDisplayName('ACF Support');
                email.setPlainTextBody(strContent);
                if(resp != null && resp != '')
                {
                    email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa,efas});
                }
                else{
                    email.setFileAttachments(new Messaging.EmailFileAttachment[] {efas});
                }
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
      } 
    }     
    public static void CallBenefits(FromBankstatementWrapper.cls_analysis objanalysis,integer SubcategoryIndex,integer CategoryIndex,integer TransactionIndex,List<click_Bank_Statements_Sub_Category__c> lstSubctegory,List<click_Bank_Statement_Data__c> lstctegory,List<click_Bank_Statements_Transactions__c> lstTransaction,string AccountNumber,String ReqDocId)
    {
        if(objanalysis.Benefits != null)
        {
            click_Bank_Statement_Data__c objBankStatementData = new click_Bank_Statement_Data__c();
            objBankStatementData.Name = 'Benefits';
            objBankStatementData.Click_Statement_No__c = string.valueof(CategoryIndex);
            objBankStatementData.Bank_Statement_Account_Number__c = AccountNumber;
            if(string.isNotEmpty(ReqDocId))
            objBankStatementData.Click_Required_Document_Id__c = ReqDocId;
            
            FromBankstatementWrapper.cls_Benefits ObjBenefits = objanalysis.Benefits ;
            if(ObjBenefits.total != null)
            {
                FromBankstatementWrapper.cls_total ObjBenefitsTotal = ObjBenefits.total;
                objBankStatementData.Click_TransactionCount__c = string.valueof(ObjBenefitsTotal.transactionCount);
                objBankStatementData.click_totalValue__c = string.valueof(ObjBenefitsTotal.totalValue);
                objBankStatementData.click_monthAvg__c = string.valueof(ObjBenefitsTotal.monthAvg);
            }
            if(ObjBenefits.MaternityPayment != null)
            {
                FromBankstatementWrapper.cls_MaternityPayment ObjBenefitsMaternityPayment = ObjBenefits.MaternityPayment;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsMaternityPayment = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsMaternityPayment.Name = 'Maternity Payment';
                objSubcategoryBenefitsMaternityPayment.Dependent__c = 'Maternity Payment';
                objSubcategoryBenefitsMaternityPayment.Click_TransactionCount__c = string.valueof(ObjBenefitsMaternityPayment.transactionCount);
                objSubcategoryBenefitsMaternityPayment.click_totalValue__c = string.valueof(ObjBenefitsMaternityPayment.totalValue);
                objSubcategoryBenefitsMaternityPayment.click_monthAvg__c = string.valueof(ObjBenefitsMaternityPayment.monthAvg);
                objSubcategoryBenefitsMaternityPayment.click_minValue__c = string.valueof(ObjBenefitsMaternityPayment.minValue);
                objSubcategoryBenefitsMaternityPayment.click_maxValue__c = string.valueof(ObjBenefitsMaternityPayment.maxValue);
                objSubcategoryBenefitsMaternityPayment.click_firstTransaction__c = ObjBenefitsMaternityPayment.firstTransaction;
                objSubcategoryBenefitsMaternityPayment.click_lastTransaction__c = ObjBenefitsMaternityPayment.lastTransaction;
                objSubcategoryBenefitsMaternityPayment.click_period__c = string.valueof(ObjBenefitsMaternityPayment.period);
                objSubcategoryBenefitsMaternityPayment.click_periodIsRegular__c = string.valueof(ObjBenefitsMaternityPayment.periodIsRegular);
                objSubcategoryBenefitsMaternityPayment.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                objSubcategoryBenefitsMaternityPayment.Click_Statement_No__c = string.valueOf(CategoryIndex);
         //     objSubcategoryBenefitsMaternityPayment.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsMaternityPayment.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsMaternityPayment.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsMaternityPayment.transactions != null && ObjBenefitsMaternityPayment.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objMPTransaction : ObjBenefitsMaternityPayment.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Maternity Payment Benefits';
                        if(objMPTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objMPTransaction.strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objMPTransaction.strdate;
                        objTransaction.click_text__c = objMPTransaction.text;
                        if(objMPTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objMPTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objMPTransaction.amount);
                        objTransaction.click_type__c = objMPTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objMPTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsMaternityPayment);
            }
            if(ObjBenefits.FamilyBenefits != null)
            {
                FromBankstatementWrapper.cls_FamilyBenefits ObjBenefitsFamilyBenefits = ObjBenefits.FamilyBenefits;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsFamilyBenefits = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsFamilyBenefits.Name = 'Family Benefits';
                objSubcategoryBenefitsFamilyBenefits.Dependent__c = 'Family Benefits';
                objSubcategoryBenefitsFamilyBenefits.Click_TransactionCount__c = string.valueof(ObjBenefitsFamilyBenefits.transactionCount);
                objSubcategoryBenefitsFamilyBenefits.click_totalValue__c = string.valueof(ObjBenefitsFamilyBenefits.totalValue);
                objSubcategoryBenefitsFamilyBenefits.click_monthAvg__c = string.valueof(ObjBenefitsFamilyBenefits.monthAvg);
                objSubcategoryBenefitsFamilyBenefits.click_minValue__c = string.valueof(ObjBenefitsFamilyBenefits.minValue);
                objSubcategoryBenefitsFamilyBenefits.click_maxValue__c = string.valueof(ObjBenefitsFamilyBenefits.maxValue);
                objSubcategoryBenefitsFamilyBenefits.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryBenefitsFamilyBenefits.click_firstTransaction__c = ObjBenefitsFamilyBenefits.firstTransaction;
                objSubcategoryBenefitsFamilyBenefits.click_lastTransaction__c = ObjBenefitsFamilyBenefits.lastTransaction;
                objSubcategoryBenefitsFamilyBenefits.click_period__c = string.valueof(ObjBenefitsFamilyBenefits.period);
                objSubcategoryBenefitsFamilyBenefits.click_periodIsRegular__c = string.valueof(ObjBenefitsFamilyBenefits.periodIsRegular);
                objSubcategoryBenefitsFamilyBenefits.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //    objSubcategoryBenefitsFamilyBenefits.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsFamilyBenefits.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsFamilyBenefits.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsFamilyBenefits.transactions != null && ObjBenefitsFamilyBenefits.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objFBTransaction : ObjBenefitsFamilyBenefits.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction FamilyBenefits Benefits';
                        if(objFBTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objFBTransaction.strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objFBTransaction.strdate;
                        objTransaction.click_text__c = objFBTransaction.text;
                        if(objFBTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objFBTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objFBTransaction.amount);
                        objTransaction.click_type__c = objFBTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objFBTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsFamilyBenefits);
            }
            if(ObjBenefits.SchoolkidsBonus != null)
            {
                FromBankstatementWrapper.cls_SchoolkidsBonus ObjBenefitsSchoolkidsBonus = ObjBenefits.SchoolkidsBonus;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsSchoolkidsBonus = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsSchoolkidsBonus.Name = 'Schoolkids Bonus';
                objSubcategoryBenefitsSchoolkidsBonus.Dependent__c = 'Schoolkids Bonus';
                objSubcategoryBenefitsSchoolkidsBonus.Click_TransactionCount__c = string.valueof(ObjBenefitsSchoolkidsBonus.transactionCount);
                objSubcategoryBenefitsSchoolkidsBonus.click_totalValue__c = string.valueof(ObjBenefitsSchoolkidsBonus.totalValue);
                objSubcategoryBenefitsSchoolkidsBonus.click_monthAvg__c = string.valueof(ObjBenefitsSchoolkidsBonus.monthAvg);
                objSubcategoryBenefitsSchoolkidsBonus.click_minValue__c = string.valueof(ObjBenefitsSchoolkidsBonus.minValue);
                objSubcategoryBenefitsSchoolkidsBonus.click_maxValue__c = string.valueof(ObjBenefitsSchoolkidsBonus.maxValue);
                objSubcategoryBenefitsSchoolkidsBonus.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryBenefitsSchoolkidsBonus.click_firstTransaction__c = ObjBenefitsSchoolkidsBonus.firstTransaction;
                objSubcategoryBenefitsSchoolkidsBonus.click_lastTransaction__c = ObjBenefitsSchoolkidsBonus.lastTransaction;
                objSubcategoryBenefitsSchoolkidsBonus.click_period__c = string.valueof(ObjBenefitsSchoolkidsBonus.period);
                objSubcategoryBenefitsSchoolkidsBonus.click_periodIsRegular__c = string.valueof(ObjBenefitsSchoolkidsBonus.periodIsRegular);
                objSubcategoryBenefitsSchoolkidsBonus.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //        objSubcategoryBenefitsSchoolkidsBonus.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsSchoolkidsBonus.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsSchoolkidsBonus.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsSchoolkidsBonus.transactions != null && ObjBenefitsSchoolkidsBonus.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objSBTransaction : ObjBenefitsSchoolkidsBonus.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Schoolkids Bonus Benefits';
                        if(objSBTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objSBTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objSBTransaction.strdate;
                        objTransaction.click_text__c = objSBTransaction.text;
                        if(objSBTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objSBTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objSBTransaction.amount);
                        objTransaction.click_type__c = objSBTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objSBTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsSchoolkidsBonus);
            }
            if(ObjBenefits.ParentingPayment != null)
            {
                FromBankstatementWrapper.cls_ParentingPayment ObjBenefitsParentingPayment = ObjBenefits.ParentingPayment;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsParentingPayment = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsParentingPayment.Name = 'Parenting Payment';
                objSubcategoryBenefitsParentingPayment.Dependent__c = 'Parenting Payment';
                objSubcategoryBenefitsParentingPayment.Click_TransactionCount__c = string.valueof(ObjBenefitsParentingPayment.transactionCount);
                objSubcategoryBenefitsParentingPayment.click_totalValue__c = string.valueof(ObjBenefitsParentingPayment.totalValue);
                objSubcategoryBenefitsParentingPayment.click_monthAvg__c = string.valueof(ObjBenefitsParentingPayment.monthAvg);
                objSubcategoryBenefitsParentingPayment.click_minValue__c = string.valueof(ObjBenefitsParentingPayment.minValue);
                objSubcategoryBenefitsParentingPayment.click_maxValue__c = string.valueof(ObjBenefitsParentingPayment.maxValue);
                objSubcategoryBenefitsParentingPayment.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryBenefitsParentingPayment.click_firstTransaction__c = ObjBenefitsParentingPayment.firstTransaction;
                objSubcategoryBenefitsParentingPayment.click_lastTransaction__c = ObjBenefitsParentingPayment.lastTransaction;
                objSubcategoryBenefitsParentingPayment.click_period__c = string.valueof(ObjBenefitsParentingPayment.period);
                objSubcategoryBenefitsParentingPayment.click_periodIsRegular__c = string.valueof(ObjBenefitsParentingPayment.periodIsRegular);
                objSubcategoryBenefitsParentingPayment.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //       objSubcategoryBenefitsParentingPayment.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsParentingPayment.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsParentingPayment.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsParentingPayment.transactions != null && ObjBenefitsParentingPayment.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objPPTransaction : ObjBenefitsParentingPayment.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction ParentingPayment Benefits';
                        if(objPPTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objPPTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objPPTransaction.strdate;
                        objTransaction.click_text__c = objPPTransaction.text;
                        if(objPPTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objPPTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objPPTransaction.amount);
                        objTransaction.click_type__c = objPPTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objPPTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsParentingPayment);
            }
            if(ObjBenefits.CarersBenefits != null)
            {
                FromBankstatementWrapper.cls_CarersBenefits ObjBenefitsCarersBenefits = ObjBenefits.CarersBenefits;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsCarersBenefits = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsCarersBenefits.Name = 'Carers Benefits';
                objSubcategoryBenefitsCarersBenefits.Dependent__c = 'Carers Benefits';
                objSubcategoryBenefitsCarersBenefits.Click_TransactionCount__c = string.valueof(ObjBenefitsCarersBenefits.transactionCount);
                objSubcategoryBenefitsCarersBenefits.click_totalValue__c = string.valueof(ObjBenefitsCarersBenefits.totalValue);
                objSubcategoryBenefitsCarersBenefits.click_monthAvg__c = string.valueof(ObjBenefitsCarersBenefits.monthAvg);
                objSubcategoryBenefitsCarersBenefits.click_minValue__c = string.valueof(ObjBenefitsCarersBenefits.minValue);
                objSubcategoryBenefitsCarersBenefits.click_maxValue__c = string.valueof(ObjBenefitsCarersBenefits.maxValue);
                objSubcategoryBenefitsCarersBenefits.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryBenefitsCarersBenefits.click_firstTransaction__c = ObjBenefitsCarersBenefits.firstTransaction;
                objSubcategoryBenefitsCarersBenefits.click_lastTransaction__c = ObjBenefitsCarersBenefits.lastTransaction;
                objSubcategoryBenefitsCarersBenefits.click_period__c = string.valueof(ObjBenefitsCarersBenefits.period);
                objSubcategoryBenefitsCarersBenefits.click_periodIsRegular__c = string.valueof(ObjBenefitsCarersBenefits.periodIsRegular);
                objSubcategoryBenefitsCarersBenefits.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //        objSubcategoryBenefitsCarersBenefits.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsCarersBenefits.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsCarersBenefits.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsCarersBenefits.transactions != null && ObjBenefitsCarersBenefits.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCBTransaction : ObjBenefitsCarersBenefits.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction CarersBenefits Benefits';
                        if(objCBTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCBTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCBTransaction.strdate;
                        objTransaction.click_text__c = objCBTransaction.text;
                        if(objCBTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCBTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCBTransaction.amount);
                        objTransaction.click_type__c = objCBTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCBTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsCarersBenefits);
            }
            if(ObjBenefits.YouthAllowance != null)
            {
                FromBankstatementWrapper.cls_YouthAllowance ObjBenefitsYouthAllowance = ObjBenefits.YouthAllowance;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsYouthAllowance = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsYouthAllowance.Name = 'Youth Allowance';
                objSubcategoryBenefitsYouthAllowance.Dependent__c = 'Youth Allowance';
                objSubcategoryBenefitsYouthAllowance.Click_TransactionCount__c = string.valueof(ObjBenefitsYouthAllowance.transactionCount);
                objSubcategoryBenefitsYouthAllowance.click_totalValue__c = string.valueof(ObjBenefitsYouthAllowance.totalValue);
                objSubcategoryBenefitsYouthAllowance.click_monthAvg__c = string.valueof(ObjBenefitsYouthAllowance.monthAvg);
                objSubcategoryBenefitsYouthAllowance.click_minValue__c = string.valueof(ObjBenefitsYouthAllowance.minValue);
                objSubcategoryBenefitsYouthAllowance.click_maxValue__c = string.valueof(ObjBenefitsYouthAllowance.maxValue);
                objSubcategoryBenefitsYouthAllowance.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryBenefitsYouthAllowance.click_firstTransaction__c = ObjBenefitsYouthAllowance.firstTransaction;
                objSubcategoryBenefitsYouthAllowance.click_lastTransaction__c = ObjBenefitsYouthAllowance.lastTransaction;
                objSubcategoryBenefitsYouthAllowance.click_period__c = string.valueof(ObjBenefitsYouthAllowance.period);
                objSubcategoryBenefitsYouthAllowance.click_periodIsRegular__c = string.valueof(ObjBenefitsYouthAllowance.periodIsRegular);
                objSubcategoryBenefitsYouthAllowance.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //      objSubcategoryBenefitsYouthAllowance.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsYouthAllowance.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsYouthAllowance.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsYouthAllowance.transactions != null && ObjBenefitsYouthAllowance.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objCBTransaction : ObjBenefitsYouthAllowance.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction YouthAllowance Benefits';
                        if(objCBTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objCBTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objCBTransaction.strdate;
                        objTransaction.click_text__c = objCBTransaction.text;
                        if(objCBTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objCBTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objCBTransaction.amount);
                        objTransaction.click_type__c = objCBTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objCBTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsYouthAllowance);
            }
            if(ObjBenefits.Newstart != null)
            {
                FromBankstatementWrapper.cls_Newstart ObjBenefitsNewstart = ObjBenefits.Newstart;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsNewstart = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsNewstart.Name = 'Newstart';
                objSubcategoryBenefitsNewstart.Dependent__c = 'Newstart';
                objSubcategoryBenefitsNewstart.Click_TransactionCount__c = string.valueof(ObjBenefitsNewstart.transactionCount);
                objSubcategoryBenefitsNewstart.click_totalValue__c = string.valueof(ObjBenefitsNewstart.totalValue);
                objSubcategoryBenefitsNewstart.click_monthAvg__c = string.valueof(ObjBenefitsNewstart.monthAvg);
                objSubcategoryBenefitsNewstart.click_minValue__c = string.valueof(ObjBenefitsNewstart.minValue);
                objSubcategoryBenefitsNewstart.click_maxValue__c = string.valueof(ObjBenefitsNewstart.maxValue);
                objSubcategoryBenefitsNewstart.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryBenefitsNewstart.click_firstTransaction__c = ObjBenefitsNewstart.firstTransaction;
                objSubcategoryBenefitsNewstart.click_lastTransaction__c = ObjBenefitsNewstart.lastTransaction;
                objSubcategoryBenefitsNewstart.click_period__c = string.valueof(ObjBenefitsNewstart.period);
                objSubcategoryBenefitsNewstart.click_periodIsRegular__c = string.valueof(ObjBenefitsNewstart.periodIsRegular);
                objSubcategoryBenefitsNewstart.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //      objSubcategoryBenefitsNewstart.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsNewstart.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsNewstart.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsNewstart.transactions != null && ObjBenefitsNewstart.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objNewstartTransaction : ObjBenefitsNewstart.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Newstart Benefits';
                        if(objNewstartTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objNewstartTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objNewstartTransaction.strdate;
                        objTransaction.click_text__c = objNewstartTransaction.text;
                        if(objNewstartTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objNewstartTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objNewstartTransaction.amount);
                        objTransaction.click_type__c = objNewstartTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objNewstartTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsNewstart);
            }
            if(ObjBenefits.Pension != null)
            {
                FromBankstatementWrapper.cls_Pension ObjBenefitsPension = ObjBenefits.Pension;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsPension = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsPension.Name = 'Pension';
                objSubcategoryBenefitsPension.Dependent__c = 'Pension';
                objSubcategoryBenefitsPension.Click_TransactionCount__c = string.valueof(ObjBenefitsPension.transactionCount);
                objSubcategoryBenefitsPension.click_totalValue__c = string.valueof(ObjBenefitsPension.totalValue);
                objSubcategoryBenefitsPension.click_monthAvg__c = string.valueof(ObjBenefitsPension.monthAvg);
                objSubcategoryBenefitsPension.click_minValue__c = string.valueof(ObjBenefitsPension.minValue);
                objSubcategoryBenefitsPension.click_maxValue__c = string.valueof(ObjBenefitsPension.maxValue);
                objSubcategoryBenefitsPension.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryBenefitsPension.click_firstTransaction__c = ObjBenefitsPension.firstTransaction;
                objSubcategoryBenefitsPension.click_lastTransaction__c = ObjBenefitsPension.lastTransaction;
                objSubcategoryBenefitsPension.click_period__c = string.valueof(ObjBenefitsPension.period);
                objSubcategoryBenefitsPension.click_periodIsRegular__c = string.valueof(ObjBenefitsPension.periodIsRegular);
                objSubcategoryBenefitsPension.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //      objSubcategoryBenefitsPension.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsPension.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsPension.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsPension.transactions != null && ObjBenefitsPension.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objPensionTransaction : ObjBenefitsPension.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Pension Benefits';
                        if(objPensionTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objPensionTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objPensionTransaction.strdate;
                        objTransaction.click_text__c = objPensionTransaction.text;
                        if(objPensionTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objPensionTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objPensionTransaction.amount);
                        objTransaction.click_type__c = objPensionTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objPensionTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsPension);
            }
            if(ObjBenefits.AusStudy != null)
            {
                FromBankstatementWrapper.cls_AusStudy ObjBenefitsAusStudy = ObjBenefits.AusStudy;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsAusStudy = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsAusStudy.Name = 'AusStudy';
                objSubcategoryBenefitsAusStudy.Dependent__c = 'AusStudy';
                objSubcategoryBenefitsAusStudy.Click_TransactionCount__c = string.valueof(ObjBenefitsAusStudy.transactionCount);
                objSubcategoryBenefitsAusStudy.click_totalValue__c = string.valueof(ObjBenefitsAusStudy.totalValue);
                objSubcategoryBenefitsAusStudy.click_monthAvg__c = string.valueof(ObjBenefitsAusStudy.monthAvg);
                objSubcategoryBenefitsAusStudy.click_minValue__c = string.valueof(ObjBenefitsAusStudy.minValue);
                objSubcategoryBenefitsAusStudy.click_maxValue__c = string.valueof(ObjBenefitsAusStudy.maxValue);
                objSubcategoryBenefitsAusStudy.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryBenefitsAusStudy.click_firstTransaction__c = ObjBenefitsAusStudy.firstTransaction;
                objSubcategoryBenefitsAusStudy.click_lastTransaction__c = ObjBenefitsAusStudy.lastTransaction;
                objSubcategoryBenefitsAusStudy.click_period__c = string.valueof(ObjBenefitsAusStudy.period);
                objSubcategoryBenefitsAusStudy.click_periodIsRegular__c = string.valueof(ObjBenefitsAusStudy.periodIsRegular);
                objSubcategoryBenefitsAusStudy.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //     objSubcategoryBenefitsAusStudy.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsAusStudy.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsAusStudy.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsAusStudy.transactions != null && ObjBenefitsAusStudy.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objAusStudyTransaction : ObjBenefitsAusStudy.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction AusStudy Benefits';
                        if(objAusStudyTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objAusStudyTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objAusStudyTransaction.strdate;
                        objTransaction.click_text__c = objAusStudyTransaction.text;
                        if(objAusStudyTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objAusStudyTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objAusStudyTransaction.amount);
                        objTransaction.click_type__c = objAusStudyTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objAusStudyTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsAusStudy);
            }
            if(ObjBenefits.Medicare != null)
            {
                FromBankstatementWrapper.cls_Medicare ObjBenefitsMedicare = ObjBenefits.Medicare;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsMedicare = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsMedicare.Name = 'Medicare';
                objSubcategoryBenefitsMedicare.Dependent__c = 'Medicare';
                objSubcategoryBenefitsMedicare.Click_TransactionCount__c = string.valueof(ObjBenefitsMedicare.transactionCount);
                objSubcategoryBenefitsMedicare.click_totalValue__c = string.valueof(ObjBenefitsMedicare.totalValue);
                objSubcategoryBenefitsMedicare.click_monthAvg__c = string.valueof(ObjBenefitsMedicare.monthAvg);
                objSubcategoryBenefitsMedicare.click_minValue__c = string.valueof(ObjBenefitsMedicare.minValue);
                objSubcategoryBenefitsMedicare.click_maxValue__c = string.valueof(ObjBenefitsMedicare.maxValue);
                objSubcategoryBenefitsMedicare.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryBenefitsMedicare.click_firstTransaction__c = ObjBenefitsMedicare.firstTransaction;
                objSubcategoryBenefitsMedicare.click_lastTransaction__c = ObjBenefitsMedicare.lastTransaction;
                objSubcategoryBenefitsMedicare.click_period__c = string.valueof(ObjBenefitsMedicare.period);
                objSubcategoryBenefitsMedicare.click_periodIsRegular__c = string.valueof(ObjBenefitsMedicare.periodIsRegular);
                objSubcategoryBenefitsMedicare.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //   objSubcategoryBenefitsMedicare.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsMedicare.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsMedicare.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsMedicare.transactions != null && ObjBenefitsMedicare.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objMedicareTransaction : ObjBenefitsMedicare.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Medicare Benefits';
                        if(objMedicareTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objMedicareTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objMedicareTransaction.strdate;
                        objTransaction.click_text__c = objMedicareTransaction.text;
                        if(objMedicareTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objMedicareTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objMedicareTransaction.amount);
                        objTransaction.click_type__c = objMedicareTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objMedicareTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsMedicare);
            }
            if(ObjBenefits.Other != null)
            {
                FromBankstatementWrapper.cls_Other ObjBenefitsOther = ObjBenefits.Other;
                click_Bank_Statements_Sub_Category__c objSubcategoryBenefitsOther = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryBenefitsOther.Name = 'Other';
                objSubcategoryBenefitsOther.Dependent__c = 'Other';
                objSubcategoryBenefitsOther.Click_TransactionCount__c = string.valueof(ObjBenefitsOther.transactionCount);
                objSubcategoryBenefitsOther.click_totalValue__c = string.valueof(ObjBenefitsOther.totalValue);
                objSubcategoryBenefitsOther.click_monthAvg__c = string.valueof(ObjBenefitsOther.monthAvg);
                objSubcategoryBenefitsOther.click_minValue__c = string.valueof(ObjBenefitsOther.minValue);
                objSubcategoryBenefitsOther.click_maxValue__c = string.valueof(ObjBenefitsOther.maxValue);
                objSubcategoryBenefitsOther.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryBenefitsOther.click_firstTransaction__c = ObjBenefitsOther.firstTransaction;
                objSubcategoryBenefitsOther.click_lastTransaction__c = ObjBenefitsOther.lastTransaction;
                objSubcategoryBenefitsOther.click_period__c = string.valueof(ObjBenefitsOther.period);
                objSubcategoryBenefitsOther.click_periodIsRegular__c = string.valueof(ObjBenefitsOther.periodIsRegular);
                objSubcategoryBenefitsOther.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
            //  objSubcategoryBenefitsOther.Click_Bank_Statements_Account__c = objBankStatementAccId;
                objSubcategoryBenefitsOther.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryBenefitsOther.Click_Required_Document_Id__c = ReqDocId;
                if(ObjBenefitsOther.transactions != null && ObjBenefitsOther.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objOtherTransaction : ObjBenefitsOther.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Other Benefits';
                        if(objOtherTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objOtherTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objOtherTransaction.strdate;
                        objTransaction.click_text__c = objOtherTransaction.text;
                        if(objOtherTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objOtherTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objOtherTransaction.amount);
                        objTransaction.click_type__c = objOtherTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objOtherTransaction.balance);
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
                lstSubctegory.add(objSubcategoryBenefitsOther);
            }
            lstctegory.add(objBankStatementData);
            CategoryIndex++;
         } 
         CallDishonours(objanalysis,SubcategoryIndex,CategoryIndex,TransactionIndex,lstSubctegory,lstctegory,lstTransaction,AccountNumber,ReqDocId);
    }  
            public static void CallIncome(FromBankstatementWrapper.cls_analysis objanalysis,integer SubcategoryIndex,integer CategoryIndex,integer TransactionIndex,List<click_Bank_Statements_Sub_Category__c> lstSubctegory,List<click_Bank_Statement_Data__c> lstctegory,List<click_Bank_Statements_Transactions__c> lstTransaction,string AccountNumber,string ReqDocId)
            {
                 if(objanalysis.Income != null)
                {
                    click_Bank_Statement_Data__c objBankStatementData = new click_Bank_Statement_Data__c();
                    objBankStatementData.Name = 'Income';
                    objBankStatementData.Click_Statement_No__c = string.valueof(CategoryIndex);
                    objBankStatementData.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objBankStatementData.Click_Required_Document_Id__c = ReqDocId;
                                   
                    FromBankstatementWrapper.cls_Income ObjIncome = objanalysis.Income;
                    if(ObjIncome.total != null)
                    {
                        FromBankstatementWrapper.cls_total objIncomeTotal = ObjIncome.total;
                        objBankStatementData.Click_TransactionCount__c = string.valueof(objIncomeTotal.transactionCount);
                        objBankStatementData.click_totalValue__c = string.valueof(objIncomeTotal.totalValue);
                        objBankStatementData.click_monthAvg__c = string.valueof(objIncomeTotal.monthAvg);
                    }
                    if(ObjIncome.Wages != null)
                    {
                        FromBankstatementWrapper.cls_Wages objIncomeWages = ObjIncome.Wages;
                        click_Bank_Statements_Sub_Category__c objSubcategoryIncomeWages = new click_Bank_Statements_Sub_Category__c();
                        objSubcategoryIncomeWages.Name = 'Wages';
                        objSubcategoryIncomeWages.Dependent__c = 'Wages';
                        objSubcategoryIncomeWages.Click_TransactionCount__c = string.valueof(objIncomeWages.transactionCount);
                        objSubcategoryIncomeWages.click_totalValue__c = string.valueof(objIncomeWages.totalValue);
                        objSubcategoryIncomeWages.click_monthAvg__c = string.valueof(objIncomeWages.monthAvg);
                        objSubcategoryIncomeWages.click_minValue__c = objIncomeWages.minValue;
                        objSubcategoryIncomeWages.click_maxValue__c = objIncomeWages.maxValue;
                        objSubcategoryIncomeWages.click_firstTransaction__c = objIncomeWages.firstTransaction;
                        objSubcategoryIncomeWages.click_lastTransaction__c = objIncomeWages.lastTransaction;
                        objSubcategoryIncomeWages.Click_Statement_No__c = string.valueOf(CategoryIndex);
                        objSubcategoryIncomeWages.click_period__c = string.valueof(objIncomeWages.period);
                        objSubcategoryIncomeWages.click_periodIsRegular__c = string.valueof(objIncomeWages.periodIsRegular);
                        objSubcategoryIncomeWages.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                 //     objSubcategoryIncomeWages.Click_Bank_Statements_Account__c = objBankStatementAccId;
                        objSubcategoryIncomeWages.Bank_Statement_Account_Number__c = AccountNumber;
                        if(string.isNotEmpty(ReqDocId))
                        objSubcategoryIncomeWages.Click_Required_Document_Id__c = ReqDocId;
                        if(objIncomeWages.transactions != null && objIncomeWages.transactions.size() > 0)
                        {
                            for(FromBankstatementWrapper.cls_transactions objWagesTransaction : objIncomeWages.transactions)
                            {
                                click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                                objTransaction.Name = 'Transaction Wages Income';
                                if(objWagesTransaction.strDateObj != null)
                                {
                                    objTransaction.dateObj__c = '';
                                    FromBankstatementWrapper.cls_strDateObj  objDateObj = objWagesTransaction .strDateObj;
                                    if(string.isNotEmpty(objDateObj.strDate))
                                    objTransaction.dateObj__c += objDateObj.strDate + ',';
                                    if(objDateObj.timezone_type <> null)
                                    objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                    if(string.isNotEmpty(objDateObj.timezone))
                                    objTransaction.dateObj__c += objDateObj.timezone;
                                }
                                objTransaction.click_date__c = objWagesTransaction.strdate;
                                objTransaction.click_text__c = objWagesTransaction.text;
                                if(objWagesTransaction.notes != null)
                                {
                                    objTransaction.click_notes__c = objWagesTransaction.notes;
                                    
                                }
                                objTransaction.click_amount__c = string.valueOf(objWagesTransaction.amount);
                                objTransaction.click_type__c = objWagesTransaction.type;
                                objTransaction.click_balance__c = string.valueOf(objWagesTransaction.balance);
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
                        lstSubctegory.add(objSubcategoryIncomeWages);
                    }
                    if(ObjIncome.Rent != null)
                    {
                        FromBankstatementWrapper.cls_Rent objIncomeRent = ObjIncome.Rent;
                        click_Bank_Statements_Sub_Category__c objSubcategoryIncomeRent = new click_Bank_Statements_Sub_Category__c();
                        objSubcategoryIncomeRent.Name = 'Rent';
                        objSubcategoryIncomeRent.Dependent__c = 'Rent';
                        objSubcategoryIncomeRent.Click_TransactionCount__c = string.valueof(objIncomeRent.transactionCount);
                        objSubcategoryIncomeRent.click_totalValue__c = string.valueof(objIncomeRent.totalValue);
                        objSubcategoryIncomeRent.click_monthAvg__c = string.valueof(objIncomeRent.monthAvg);
                        objSubcategoryIncomeRent.click_minValue__c = objIncomeRent.minValue;
                        objSubcategoryIncomeRent.click_maxValue__c = objIncomeRent.maxValue;
                        objSubcategoryIncomeRent.click_firstTransaction__c = objIncomeRent.firstTransaction;
                        objSubcategoryIncomeRent.click_lastTransaction__c = objIncomeRent.lastTransaction;
                        objSubcategoryIncomeRent.Click_Statement_No__c = string.valueOf(CategoryIndex);
                        objSubcategoryIncomeRent.click_period__c = string.valueof(objIncomeRent.period);
                        objSubcategoryIncomeRent.click_periodIsRegular__c = string.valueof(objIncomeRent.periodIsRegular);
                        objSubcategoryIncomeRent.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                 //     objSubcategoryIncomeRent.Click_Bank_Statements_Account__c = objBankStatementAccId;
                        objSubcategoryIncomeRent.Bank_Statement_Account_Number__c = AccountNumber;
                        if(string.isNotEmpty(ReqDocId))
                        objSubcategoryIncomeRent.Click_Required_Document_Id__c = ReqDocId;
                        if(objIncomeRent.transactions != null && objIncomeRent.transactions.size() > 0)
                        {
                             for(FromBankstatementWrapper.cls_transactions objRentTransaction : objIncomeRent.transactions)
                            {
                                click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                                objTransaction.Name = 'Transaction Rent Income';
                                if(objRentTransaction.strDateObj != null)
                                {
                                    objTransaction.dateObj__c = '';
                                    FromBankstatementWrapper.cls_strDateObj  objDateObj = objRentTransaction .strDateObj;
                                    if(string.isNotEmpty(objDateObj.strDate))
                                        objTransaction.dateObj__c += objDateObj.strDate + ',';
                                    if(objDateObj.timezone_type <> null)
                                        objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                    if(string.isNotEmpty(objDateObj.timezone))
                                        objTransaction.dateObj__c += objDateObj.timezone;
                                }
                                objTransaction.click_date__c = objRentTransaction.strdate;
                                objTransaction.click_text__c = objRentTransaction.text;
                                if(objRentTransaction.notes != null)
                                {
                                    objTransaction.click_notes__c = objRentTransaction.notes;
                                    
                                }
                                objTransaction.click_amount__c = string.valueOf(objRentTransaction.amount);
                                objTransaction.click_type__c = objRentTransaction.type;
                                objTransaction.click_balance__c = string.valueOf(objRentTransaction.balance);
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
                        lstSubctegory.add(objSubcategoryIncomeRent);
                    }
                    if(ObjIncome.Interest != null)
                    {
                        FromBankstatementWrapper.cls_Interest objIncomeInterest = ObjIncome.Interest;
                        click_Bank_Statements_Sub_Category__c objSubcategoryIncomeInterest = new click_Bank_Statements_Sub_Category__c();
                        objSubcategoryIncomeInterest.Name = 'Interest';
                        objSubcategoryIncomeInterest.Dependent__c = 'Interest';
                        objSubcategoryIncomeInterest.Click_TransactionCount__c = string.valueof(objIncomeInterest.transactionCount);
                        objSubcategoryIncomeInterest.click_totalValue__c = string.valueof(objIncomeInterest.totalValue);
                        objSubcategoryIncomeInterest.click_monthAvg__c = string.valueof(objIncomeInterest.monthAvg);
                        objSubcategoryIncomeInterest.click_minValue__c = objIncomeInterest.minValue;
                        objSubcategoryIncomeInterest.click_maxValue__c = objIncomeInterest.maxValue;
                        objSubcategoryIncomeInterest.click_firstTransaction__c = objIncomeInterest.firstTransaction;
                        objSubcategoryIncomeInterest.click_lastTransaction__c = objIncomeInterest.lastTransaction;
                        objSubcategoryIncomeInterest.Click_Statement_No__c = string.valueOf(CategoryIndex);
                        objSubcategoryIncomeInterest.click_period__c = string.valueof(objIncomeInterest.period);
                        objSubcategoryIncomeInterest.click_periodIsRegular__c = string.valueof(objIncomeInterest.periodIsRegular);
                        objSubcategoryIncomeInterest.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                 //     objSubcategoryIncomeInterest.Click_Bank_Statements_Account__c = objBankStatementAccId;
                        objSubcategoryIncomeInterest.Bank_Statement_Account_Number__c = AccountNumber;
                        if(string.isNotEmpty(ReqDocId))
                        objSubcategoryIncomeInterest.Click_Required_Document_Id__c = ReqDocId;
                        if(objIncomeInterest.transactions != null && objIncomeInterest.transactions.size() > 0)
                        {
                             for(FromBankstatementWrapper.cls_transactions objInterestTransaction : objIncomeInterest.transactions)
                            {
                                click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                                objTransaction.Name = 'Transaction Interest Income';
                                if(objInterestTransaction.strDateObj != null)
                                {
                                    objTransaction.dateObj__c = '';
                                    FromBankstatementWrapper.cls_strDateObj  objDateObj = objInterestTransaction .strDateObj;
                                    if(string.isNotEmpty(objDateObj.strDate))
                                    objTransaction.dateObj__c += objDateObj.strDate + ',';
                                    if(objDateObj.timezone_type <> null)
                                    objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                    if(string.isNotEmpty(objDateObj.timezone))
                                    objTransaction.dateObj__c += objDateObj.timezone;
                                }
                                objTransaction.click_date__c = objInterestTransaction.strdate;
                                objTransaction.click_text__c = objInterestTransaction.text;
                                if(objInterestTransaction.notes != null)
                                {
                                    objTransaction.click_notes__c = objInterestTransaction.notes;
                                    
                                }
                                objTransaction.click_amount__c = string.valueOf(objInterestTransaction.amount);
                                objTransaction.click_type__c = objInterestTransaction.type;
                                objTransaction.click_balance__c = string.valueOf(objInterestTransaction.balance);
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
                        lstSubctegory.add(objSubcategoryIncomeInterest);
                    }
                    
                    lstctegory.add(objBankStatementData);
                    CategoryIndex++;
                }
                CallBenefits(objanalysis,SubcategoryIndex,CategoryIndex,TransactionIndex,lstSubctegory,lstctegory,lstTransaction,AccountNumber,ReqDocId);
            } 
            public static void CallDishonours(FromBankstatementWrapper.cls_analysis objanalysis,integer SubcategoryIndex,integer CategoryIndex,integer TransactionIndex,List<click_Bank_Statements_Sub_Category__c> lstSubctegory,List<click_Bank_Statement_Data__c> lstctegory,List<click_Bank_Statements_Transactions__c> lstTransaction,string AccountNumber,string ReqDocId)
            {
                if(objanalysis.Dishonours != null)
                {
                    click_Bank_Statement_Data__c objBankStatementData = new click_Bank_Statement_Data__c();
                    objBankStatementData.Name = 'Dishonours';
                    objBankStatementData.Click_Statement_No__c = string.valueof(CategoryIndex);
                    objBankStatementData.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objBankStatementData.Click_Required_Document_Id__c = ReqDocId;
                    
                    
                    FromBankstatementWrapper.cls_Dishonours ObjDishonour = objanalysis.Dishonours;
                    if(ObjDishonour.total != null)
                    {
                        FromBankstatementWrapper.cls_total ObjDishonourTotal = ObjDishonour.total;
                        objBankStatementData.Click_TransactionCount__c = string.valueof(ObjDishonourTotal.transactionCount);
                        objBankStatementData.click_totalValue__c = string.valueof(ObjDishonourTotal.totalValue);
                        objBankStatementData.click_monthAvg__c = string.valueof(ObjDishonourTotal.monthAvg);
                    }
                    if(ObjDishonour.Overdrawn != null)
                    {
                        FromBankstatementWrapper.cls_Overdrawn ObjDishonourOverdrawn = ObjDishonour.Overdrawn;
                        click_Bank_Statements_Sub_Category__c objSubcategoryDishonoursOverdrawn = new click_Bank_Statements_Sub_Category__c();
                        objSubcategoryDishonoursOverdrawn.Name = 'Overdrawn';
                        objSubcategoryDishonoursOverdrawn.Dependent__c = 'Overdrawn';
                        objSubcategoryDishonoursOverdrawn.Click_TransactionCount__c = string.valueof(ObjDishonourOverdrawn.transactionCount);
                        objSubcategoryDishonoursOverdrawn.click_totalValue__c = string.valueof(ObjDishonourOverdrawn.totalValue);
                        objSubcategoryDishonoursOverdrawn.click_monthAvg__c = string.valueof(ObjDishonourOverdrawn.monthAvg);
                        objSubcategoryDishonoursOverdrawn.click_minValue__c = string.valueof(ObjDishonourOverdrawn.minValue);
                        objSubcategoryDishonoursOverdrawn.click_maxValue__c = string.valueof(ObjDishonourOverdrawn.maxValue);
                        objSubcategoryDishonoursOverdrawn.click_firstTransaction__c = ObjDishonourOverdrawn.firstTransaction;
                        objSubcategoryDishonoursOverdrawn.click_lastTransaction__c = ObjDishonourOverdrawn.lastTransaction;
                        objSubcategoryDishonoursOverdrawn.click_period__c = string.valueof(ObjDishonourOverdrawn.period);
                        objSubcategoryDishonoursOverdrawn.click_periodIsRegular__c = string.valueof(ObjDishonourOverdrawn.periodIsRegular);
                        objSubcategoryDishonoursOverdrawn.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                        objSubcategoryDishonoursOverdrawn.Click_Statement_No__c = string.valueOf(CategoryIndex);
                  //    objSubcategoryDishonoursOverdrawn.Click_Bank_Statements_Account__c = objBankStatementAccId;
                        objSubcategoryDishonoursOverdrawn.Bank_Statement_Account_Number__c = AccountNumber;
                        if(string.isNotEmpty(ReqDocId))
                        objSubcategoryDishonoursOverdrawn.Click_Required_Document_Id__c = ReqDocId;
                        if(ObjDishonourOverdrawn.transactions != null && ObjDishonourOverdrawn.transactions.size() > 0)
                        {
                            for(FromBankstatementWrapper.cls_transactions objoverDrawnTransaction : ObjDishonourOverdrawn.transactions)
                            {
                                click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                                objTransaction.Name = 'Transaction Overdrawn Dishonours';
                                if(objoverDrawnTransaction.strDateObj != null)
                                {
                                    objTransaction.dateObj__c = '';
                                    FromBankstatementWrapper.cls_strDateObj  objDateObj = objoverDrawnTransaction .strDateObj;
                                    if(string.isNotEmpty(objDateObj.strDate))
                                    objTransaction.dateObj__c += objDateObj.strDate + ',';
                                    if(objDateObj.timezone_type <> null)
                                    objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                    if(string.isNotEmpty(objDateObj.timezone))
                                    objTransaction.dateObj__c += objDateObj.timezone;
                                }
                                objTransaction.click_date__c = objoverDrawnTransaction.strdate;
                                objTransaction.click_text__c = objoverDrawnTransaction.text;
                                if(objoverDrawnTransaction.notes != null)
                                {
                                    objTransaction.click_notes__c = objoverDrawnTransaction.notes;
                                    
                                }
                                objTransaction.click_amount__c = string.valueOf(objoverDrawnTransaction.amount);
                                objTransaction.click_type__c = objoverDrawnTransaction.type;
                                objTransaction.click_balance__c = string.valueOf(objoverDrawnTransaction.balance);
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
                        lstSubctegory.add(objSubcategoryDishonoursOverdrawn);
                    }
                    if(ObjDishonour.Dishonour != null)
                    {
                        FromBankstatementWrapper.cls_Dishonour ObjDishonourDishonour = ObjDishonour.Dishonour;
                        click_Bank_Statements_Sub_Category__c objSubcategoryDishonoursDishonour = new click_Bank_Statements_Sub_Category__c();
                        objSubcategoryDishonoursDishonour.Name = 'Family Dishonours';
                        objSubcategoryDishonoursDishonour.Dependent__c = 'Family Dishonours';
                        objSubcategoryDishonoursDishonour.Click_TransactionCount__c = string.valueof(ObjDishonourDishonour.transactionCount);
                        objSubcategoryDishonoursDishonour.click_totalValue__c = string.valueof(ObjDishonourDishonour.totalValue);
                        objSubcategoryDishonoursDishonour.click_monthAvg__c = string.valueof(ObjDishonourDishonour.monthAvg);
                        objSubcategoryDishonoursDishonour.click_minValue__c = string.valueof(ObjDishonourDishonour.minValue);
                        objSubcategoryDishonoursDishonour.click_maxValue__c = string.valueof(ObjDishonourDishonour.maxValue);
                        objSubcategoryDishonoursDishonour.Click_Statement_No__c = string.valueOf(CategoryIndex);
                        objSubcategoryDishonoursDishonour.click_firstTransaction__c = ObjDishonourDishonour.firstTransaction;
                        objSubcategoryDishonoursDishonour.click_lastTransaction__c = ObjDishonourDishonour.lastTransaction;
                        objSubcategoryDishonoursDishonour.click_period__c = string.valueof(ObjDishonourDishonour.period);
                        objSubcategoryDishonoursDishonour.click_periodIsRegular__c = string.valueof(ObjDishonourDishonour.periodIsRegular);
                        objSubcategoryDishonoursDishonour.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
              //        objSubcategoryDishonoursDishonour.Click_Bank_Statements_Account__c = objBankStatementAccId;
                        objSubcategoryDishonoursDishonour.Bank_Statement_Account_Number__c = AccountNumber;
                        if(string.isNotEmpty(ReqDocId))
                        objSubcategoryDishonoursDishonour.Click_Required_Document_Id__c = ReqDocId;
                        if(ObjDishonourDishonour.transactions != null && ObjDishonourDishonour.transactions.size() > 0)
                        {
                            for(FromBankstatementWrapper.cls_transactions objDishonourTransaction : ObjDishonourDishonour.transactions)
                            {
                                click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                                objTransaction.Name = 'Transaction Dishonour Dishonours';
                                if(objDishonourTransaction.strDateObj != null)
                                {
                                    objTransaction.dateObj__c = '';
                                    FromBankstatementWrapper.cls_strDateObj  objDateObj = objDishonourTransaction .strDateObj;
                                    if(string.isNotEmpty(objDateObj.strDate))
                                    objTransaction.dateObj__c += objDateObj.strDate + ',';
                                    if(objDateObj.timezone_type <> null)
                                    objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                    if(string.isNotEmpty(objDateObj.timezone))
                                    objTransaction.dateObj__c += objDateObj.timezone;
                                }
                                objTransaction.click_date__c = objDishonourTransaction.strdate;
                                objTransaction.click_text__c = objDishonourTransaction.text;
                                if(objDishonourTransaction.notes != null)
                                {
                                    objTransaction.click_notes__c = objDishonourTransaction.notes;
                                    
                                }
                                objTransaction.click_amount__c = string.valueOf(objDishonourTransaction.amount);
                                objTransaction.click_type__c = objDishonourTransaction.type;
                                objTransaction.click_balance__c = string.valueOf(objDishonourTransaction.balance);
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
                        lstSubctegory.add(objSubcategoryDishonoursDishonour);
                    }
                    if(ObjDishonour.Returns != null)
                    {
                        FromBankstatementWrapper.cls_Return ObjDishonourReturns = ObjDishonour.Returns;
                        click_Bank_Statements_Sub_Category__c objSubcategoryDishonoursReturns = new click_Bank_Statements_Sub_Category__c();
                        objSubcategoryDishonoursReturns.Name = 'Returns';
                        objSubcategoryDishonoursReturns.Dependent__c = 'Returns';
                        objSubcategoryDishonoursReturns.Click_TransactionCount__c = string.valueof(ObjDishonourReturns.transactionCount);
                        objSubcategoryDishonoursReturns.click_totalValue__c = string.valueof(ObjDishonourReturns.totalValue);
                        objSubcategoryDishonoursReturns.click_monthAvg__c = string.valueof(ObjDishonourReturns.monthAvg);
                        objSubcategoryDishonoursReturns.click_minValue__c = string.valueof(ObjDishonourReturns.minValue);
                        objSubcategoryDishonoursReturns.click_maxValue__c = string.valueof(ObjDishonourReturns.maxValue);
                        objSubcategoryDishonoursReturns.Click_Statement_No__c = string.valueOf(CategoryIndex);
                        objSubcategoryDishonoursReturns.click_firstTransaction__c = ObjDishonourReturns.firstTransaction;
                        objSubcategoryDishonoursReturns.click_lastTransaction__c = ObjDishonourReturns.lastTransaction;
                        objSubcategoryDishonoursReturns.click_period__c = string.valueof(ObjDishonourReturns.period);
                        objSubcategoryDishonoursReturns.click_periodIsRegular__c = string.valueof(ObjDishonourReturns.periodIsRegular);
                        objSubcategoryDishonoursReturns.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
               //       objSubcategoryDishonoursReturns.Click_Bank_Statements_Account__c = objBankStatementAccId;
                        objSubcategoryDishonoursReturns.Bank_Statement_Account_Number__c = AccountNumber;
                        if(string.isNotEmpty(ReqDocId))
                        objSubcategoryDishonoursReturns.Click_Required_Document_Id__c = ReqDocId;
                        if(ObjDishonourReturns.transactions != null && ObjDishonourReturns.transactions.size() > 0)
                        {
                            for(FromBankstatementWrapper.cls_transactions objReturnTransaction : ObjDishonourReturns.transactions)
                            {
                                click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                                objTransaction.Name = 'Transaction Returns Dishonours';
                                if(objReturnTransaction.strDateObj != null)
                                {
                                    objTransaction.dateObj__c = '';
                                    FromBankstatementWrapper.cls_strDateObj  objDateObj = objReturnTransaction .strDateObj;
                                    if(string.isNotEmpty(objDateObj.strDate))
                                    objTransaction.dateObj__c += objDateObj.strDate + ',';
                                    if(objDateObj.timezone_type <> null)
                                    objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                    if(string.isNotEmpty(objDateObj.timezone))
                                    objTransaction.dateObj__c += objDateObj.timezone;
                                }
                                objTransaction.click_date__c = objReturnTransaction.strdate;
                                objTransaction.click_text__c = objReturnTransaction.text;
                                if(objReturnTransaction.notes != null)
                                {
                                    objTransaction.click_notes__c = objReturnTransaction.notes;
                                    
                                }
                                objTransaction.click_amount__c = string.valueOf(objReturnTransaction.amount);
                                objTransaction.click_type__c = objReturnTransaction.type;
                                objTransaction.click_balance__c = string.valueOf(objReturnTransaction.balance);
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
                        lstSubctegory.add(objSubcategoryDishonoursReturns);
                    }
                    if(ObjDishonour.Reversal != null)
                    {
                        FromBankstatementWrapper.cls_Reversal ObjDishonourReversal = ObjDishonour.Reversal;
                        click_Bank_Statements_Sub_Category__c objSubcategoryDishonoursReversal = new click_Bank_Statements_Sub_Category__c();
                        objSubcategoryDishonoursReversal.Name = 'Reversal';
                        objSubcategoryDishonoursReversal.Dependent__c = 'Reversal';
                        objSubcategoryDishonoursReversal.Click_TransactionCount__c = string.valueof(ObjDishonourReversal.transactionCount);
                        objSubcategoryDishonoursReversal.click_totalValue__c = string.valueof(ObjDishonourReversal.totalValue);
                        objSubcategoryDishonoursReversal.click_monthAvg__c = string.valueof(ObjDishonourReversal.monthAvg);
                        objSubcategoryDishonoursReversal.click_minValue__c = string.valueof(ObjDishonourReversal.minValue);
                        objSubcategoryDishonoursReversal.click_maxValue__c = string.valueof(ObjDishonourReversal.maxValue);
                        objSubcategoryDishonoursReversal.Click_Statement_No__c = string.valueOf(CategoryIndex);
                        objSubcategoryDishonoursReversal.click_firstTransaction__c = ObjDishonourReversal.firstTransaction;
                        objSubcategoryDishonoursReversal.click_lastTransaction__c = ObjDishonourReversal.lastTransaction;
                        objSubcategoryDishonoursReversal.click_period__c = string.valueof(ObjDishonourReversal.period);
                        objSubcategoryDishonoursReversal.click_periodIsRegular__c = string.valueof(ObjDishonourReversal.periodIsRegular);
                        objSubcategoryDishonoursReversal.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
              //        objSubcategoryDishonoursReversal.Click_Bank_Statements_Account__c = objBankStatementAccId;
                        objSubcategoryDishonoursReversal.Bank_Statement_Account_Number__c = AccountNumber;
                        if(string.isNotEmpty(ReqDocId))
                        objSubcategoryDishonoursReversal.Click_Required_Document_Id__c = ReqDocId;
                        if(ObjDishonourReversal.transactions != null && ObjDishonourReversal.transactions.size() > 0)
                        {
                            for(FromBankstatementWrapper.cls_transactions objPPTransaction : ObjDishonourReversal.transactions)
                            {
                                click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                                objTransaction.Name = 'Transaction Reversal Dishonours';
                                if(objPPTransaction.strDateObj != null)
                                {
                                    objTransaction.dateObj__c = '';
                                    FromBankstatementWrapper.cls_strDateObj  objDateObj = objPPTransaction .strDateObj;
                                    if(string.isNotEmpty(objDateObj.strDate))
                                    objTransaction.dateObj__c += objDateObj.strDate + ',';
                                    if(objDateObj.timezone_type <> null)
                                    objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                    if(string.isNotEmpty(objDateObj.timezone))
                                    objTransaction.dateObj__c += objDateObj.timezone;
                                }
                                objTransaction.click_date__c = objPPTransaction.strdate;
                                objTransaction.click_text__c = objPPTransaction.text;
                                if(objPPTransaction.notes != null)
                                {
                                    objTransaction.click_notes__c = objPPTransaction.notes;
                                    
                                }
                                objTransaction.click_amount__c = string.valueOf(objPPTransaction.amount);
                                objTransaction.click_type__c = objPPTransaction.type;
                                objTransaction.click_balance__c = string.valueOf(objPPTransaction.balance);
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
                        lstSubctegory.add(objSubcategoryDishonoursReversal);
                    }
                    lstctegory.add(objBankStatementData);
                    CategoryIndex++;
                } 
                if(objanalysis.Rent != null)
            {
                click_Bank_Statement_Data__c objBankStatementData = new click_Bank_Statement_Data__c();
                objBankStatementData.Name = 'Rent';
                objBankStatementData.Click_Statement_No__c = string.valueof(CategoryIndex);
                objBankStatementData.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objBankStatementData.Click_Required_Document_Id__c = ReqDocId;
                
                
                FromBankstatementWrapper.cls_Rent ObjRent = objanalysis.Rent;
                click_Bank_Statements_Sub_Category__c objSubcategoryRent = new click_Bank_Statements_Sub_Category__c();
                objSubcategoryRent.Name = 'Rent';
                objSubcategoryRent.Dependent__c = 'Rent';
                objSubcategoryRent.Click_TransactionCount__c = string.valueof(ObjRent.transactionCount);
                objSubcategoryRent.click_totalValue__c = string.valueof(ObjRent.totalValue);
                objSubcategoryRent.click_monthAvg__c = string.valueof(ObjRent.monthAvg);
                objSubcategoryRent.click_minValue__c = ObjRent.minValue;
                objSubcategoryRent.click_maxValue__c = ObjRent.maxValue;
                objSubcategoryRent.click_firstTransaction__c = ObjRent.firstTransaction;
                objSubcategoryRent.click_lastTransaction__c = ObjRent.lastTransaction;
                objSubcategoryRent.Click_Statement_No__c = string.valueOf(CategoryIndex);
                objSubcategoryRent.click_period__c = string.valueof(ObjRent.period);
                objSubcategoryRent.click_periodIsRegular__c = string.valueof(ObjRent.periodIsRegular);
                objSubcategoryRent.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
            //  objSubcategoryRent.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                objSubcategoryRent.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objSubcategoryRent.Click_Required_Document_Id__c = ReqDocId;
                if(ObjRent.transactions != null && ObjRent.transactions.size() > 0)
                {
                    for(FromBankstatementWrapper.cls_transactions objRentTransaction : ObjRent.transactions)
                    {
                        click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                        objTransaction.Name = 'Transaction Rent';
                        if(objRentTransaction.strDateObj != null)
                        {
                            objTransaction.dateObj__c = '';
                            FromBankstatementWrapper.cls_strDateObj  objDateObj = objRentTransaction .strDateObj;
                            if(string.isNotEmpty(objDateObj.strDate))
                            objTransaction.dateObj__c += objDateObj.strDate + ',';
                            if(objDateObj.timezone_type <> null)
                            objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                            if(string.isNotEmpty(objDateObj.timezone))
                            objTransaction.dateObj__c += objDateObj.timezone;
                        }
                        objTransaction.click_date__c = objRentTransaction.strdate;
                        objTransaction.click_text__c = objRentTransaction.text;
                        if(objRentTransaction.notes != null)
                        {
                            objTransaction.click_notes__c = objRentTransaction.notes;
                            
                        }
                        objTransaction.click_amount__c = string.valueOf(objRentTransaction.amount);
                        objTransaction.click_type__c = objRentTransaction.type;
                        objTransaction.click_balance__c = string.valueOf(objRentTransaction.balance);
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
                lstSubctegory.add(objSubcategoryRent);
                lstctegory.add(objBankStatementData);
                CategoryIndex++;
            }
            if(objanalysis.Gambling != null)
            {
                click_Bank_Statement_Data__c objBankStatementData = new click_Bank_Statement_Data__c();
                objBankStatementData.Name = 'Gambling';
                objBankStatementData.Click_Statement_No__c = string.valueof(CategoryIndex);
                objBankStatementData.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objBankStatementData.Click_Required_Document_Id__c = ReqDocId;
                                
                FromBankstatementWrapper.cls_Gambling ObjGambling = objanalysis.Gambling;
                if(ObjGambling.total != null)
                {
                    FromBankstatementWrapper.cls_total objGamblingTotal = ObjGambling.total;
                    objBankStatementData.Click_TransactionCount__c = string.valueof(objGamblingTotal.transactionCount);
                    objBankStatementData.click_totalValue__c = string.valueof(objGamblingTotal.totalValue);
                    objBankStatementData.click_monthAvg__c = string.valueof(objGamblingTotal.monthAvg);
                }
                if(ObjGambling.Bet10 != null)
                {
                    FromBankstatementWrapper.cls_10Bet objGamblingBet10 = ObjGambling.Bet10;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingBet10 = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingBet10.Name = '10Bet';
                    objSubcategoryGamblingBet10.Dependent__c = '10Bet';
                    objSubcategoryGamblingBet10.Click_TransactionCount__c = string.valueof(objGamblingBet10.transactionCount);
                    objSubcategoryGamblingBet10.click_totalValue__c = string.valueof(objGamblingBet10.totalValue);
                    objSubcategoryGamblingBet10.click_monthAvg__c = string.valueof(objGamblingBet10.monthAvg);
                    objSubcategoryGamblingBet10.click_minValue__c = string.valueof(objGamblingBet10.minValue);
                    objSubcategoryGamblingBet10.click_maxValue__c = string.valueof(objGamblingBet10.maxValue);
                    objSubcategoryGamblingBet10.click_firstTransaction__c = objGamblingBet10.firstTransaction;
                    objSubcategoryGamblingBet10.click_lastTransaction__c = objGamblingBet10.lastTransaction;
                    objSubcategoryGamblingBet10.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingBet10.click_period__c = string.valueof(objGamblingBet10.period);
                    objSubcategoryGamblingBet10.click_periodIsRegular__c = string.valueof(objGamblingBet10.periodIsRegular);
                    objSubcategoryGamblingBet10.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
               //   objSubcategoryGamblingBet10.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingBet10.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingBet10.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingBet10.transactions != null && objGamblingBet10.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objBet10Transaction : objGamblingBet10.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction 10Bet Gambling';
                            if(objBet10Transaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objBet10Transaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objBet10Transaction.strdate;
                            objTransaction.click_text__c = objBet10Transaction.text;
                            if(objBet10Transaction.notes != null)
                            {
                                objTransaction.click_notes__c = objBet10Transaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objBet10Transaction.amount);
                            objTransaction.click_type__c = objBet10Transaction.type;
                            objTransaction.click_balance__c = string.valueOf(objBet10Transaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingBet10);
                }
                if(ObjGambling.AusBet != null)
                {
                    FromBankstatementWrapper.cls_AusBet objGamblingAusBet = ObjGambling.AusBet;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingAusBet = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingAusBet.Name = 'AusBet';
                    objSubcategoryGamblingAusBet.Dependent__c = 'AusBet';
                    objSubcategoryGamblingAusBet.Click_TransactionCount__c = string.valueof(objGamblingAusBet.transactionCount);
                    objSubcategoryGamblingAusBet.click_totalValue__c = string.valueof(objGamblingAusBet.totalValue);
                    objSubcategoryGamblingAusBet.click_monthAvg__c = string.valueof(objGamblingAusBet.monthAvg);
                    objSubcategoryGamblingAusBet.click_minValue__c = string.valueof(objGamblingAusBet.minValue);
                    objSubcategoryGamblingAusBet.click_maxValue__c = string.valueof(objGamblingAusBet.maxValue);
                    objSubcategoryGamblingAusBet.click_firstTransaction__c = objGamblingAusBet.firstTransaction;
                    objSubcategoryGamblingAusBet.click_lastTransaction__c = objGamblingAusBet.lastTransaction;
                    objSubcategoryGamblingAusBet.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingAusBet.click_period__c = string.valueof(objGamblingAusBet.period);
                    objSubcategoryGamblingAusBet.click_periodIsRegular__c = string.valueof(objGamblingAusBet.periodIsRegular);
                    objSubcategoryGamblingAusBet.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryGamblingAusBet.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingAusBet.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingAusBet.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingAusBet.transactions != null && objGamblingAusBet.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objAusBetTransaction : objGamblingAusBet.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction AusBet Gambling';
                            if(objAusBetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objAusBetTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objAusBetTransaction.strdate;
                            objTransaction.click_text__c = objAusBetTransaction.text;
                            if(objAusBetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objAusBetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objAusBetTransaction.amount);
                            objTransaction.click_type__c = objAusBetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objAusBetTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingAusBet);
                }
                if(ObjGambling.Bet365 != null)
                {
                    FromBankstatementWrapper.cls_Bet365 objGamblingBet365 = ObjGambling.Bet365;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingBet365 = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingBet365.Name = 'Bet365';
                    objSubcategoryGamblingBet365.Dependent__c = 'Bet365';
                    objSubcategoryGamblingBet365.Click_TransactionCount__c = string.valueof(objGamblingBet365.transactionCount);
                    objSubcategoryGamblingBet365.click_totalValue__c = string.valueof(objGamblingBet365.totalValue);
                    objSubcategoryGamblingBet365.click_monthAvg__c = string.valueof(objGamblingBet365.monthAvg);
                    objSubcategoryGamblingBet365.click_minValue__c = string.valueof(objGamblingBet365.minValue);
                    objSubcategoryGamblingBet365.click_maxValue__c = string.valueof(objGamblingBet365.maxValue);
                    objSubcategoryGamblingBet365.click_firstTransaction__c = objGamblingBet365.firstTransaction;
                    objSubcategoryGamblingBet365.click_lastTransaction__c = objGamblingBet365.lastTransaction;
                    objSubcategoryGamblingBet365.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingBet365.click_period__c = string.valueof(objGamblingBet365.period);
                    objSubcategoryGamblingBet365.click_periodIsRegular__c = string.valueof(objGamblingBet365.periodIsRegular);
                    objSubcategoryGamblingBet365.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
               //   objSubcategoryGamblingBet365.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingBet365.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingBet365.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingBet365.transactions != null && objGamblingBet365.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objBet365Transaction : objGamblingBet365.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Bet365 Gambling';
                            if(objBet365Transaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objBet365Transaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objBet365Transaction.strdate;
                            objTransaction.click_text__c = objBet365Transaction.text;
                            if(objBet365Transaction.notes != null)
                            {
                                objTransaction.click_notes__c = objBet365Transaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objBet365Transaction.amount);
                            objTransaction.click_type__c = objBet365Transaction.type;
                            objTransaction.click_balance__c = string.valueOf(objBet365Transaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingBet365);
                }
                if(ObjGambling.BetFair != null)
                {
                    FromBankstatementWrapper.cls_BetFair objGamblingBetFair = ObjGambling.BetFair;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingBetFair = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingBetFair.Name = 'BetFair';
                    objSubcategoryGamblingBetFair.Dependent__c = 'BetFair';
                    objSubcategoryGamblingBetFair.Click_TransactionCount__c = string.valueof(objGamblingBetFair.transactionCount);
                    objSubcategoryGamblingBetFair.click_totalValue__c = string.valueof(objGamblingBetFair.totalValue);
                    objSubcategoryGamblingBetFair.click_monthAvg__c = string.valueof(objGamblingBetFair.monthAvg);
                    objSubcategoryGamblingBetFair.click_minValue__c = string.valueof(objGamblingBetFair.minValue);
                    objSubcategoryGamblingBetFair.click_maxValue__c = string.valueof(objGamblingBetFair.maxValue);
                    objSubcategoryGamblingBetFair.click_firstTransaction__c = objGamblingBetFair.firstTransaction;
                    objSubcategoryGamblingBetFair.click_lastTransaction__c = objGamblingBetFair.lastTransaction;
                    objSubcategoryGamblingBetFair.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingBetFair.click_period__c = string.valueof(objGamblingBetFair.period);
                    objSubcategoryGamblingBetFair.click_periodIsRegular__c = string.valueof(objGamblingBetFair.periodIsRegular);
                    objSubcategoryGamblingBetFair.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryGamblingBetFair.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingBetFair.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingBetFair.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingBetFair.transactions != null && objGamblingBetFair.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objBetFairTransaction : objGamblingBetFair.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction BetFair Gambling';
                            if(objBetFairTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objBetFairTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objBetFairTransaction.strdate;
                            objTransaction.click_text__c = objBetFairTransaction.text;
                            if(objBetFairTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objBetFairTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objBetFairTransaction.amount);
                            objTransaction.click_type__c = objBetFairTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objBetFairTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingBetFair);
                }
                if(ObjGambling.BetStar != null)
                {
                    FromBankstatementWrapper.cls_BetStar objGamblingBetStar = ObjGambling.BetStar;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingBetStar = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingBetStar.Name = 'BetStar';
                    objSubcategoryGamblingBetStar.Dependent__c = 'BetStar';
                    objSubcategoryGamblingBetStar.Click_TransactionCount__c = string.valueof(objGamblingBetStar.transactionCount);
                    objSubcategoryGamblingBetStar.click_totalValue__c = string.valueof(objGamblingBetStar.totalValue);
                    objSubcategoryGamblingBetStar.click_monthAvg__c = string.valueof(objGamblingBetStar.monthAvg);
                    objSubcategoryGamblingBetStar.click_minValue__c = string.valueof(objGamblingBetStar.minValue);
                    objSubcategoryGamblingBetStar.click_maxValue__c = string.valueof(objGamblingBetStar.maxValue);
                    objSubcategoryGamblingBetStar.click_firstTransaction__c = objGamblingBetStar.firstTransaction;
                    objSubcategoryGamblingBetStar.click_lastTransaction__c = objGamblingBetStar.lastTransaction;
                    objSubcategoryGamblingBetStar.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingBetStar.click_period__c = string.valueof(objGamblingBetStar.period);
                    objSubcategoryGamblingBetStar.click_periodIsRegular__c = string.valueof(objGamblingBetStar.periodIsRegular);
                    objSubcategoryGamblingBetStar.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
            //      objSubcategoryGamblingBetStar.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingBetStar.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingBetStar.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingBetStar.transactions != null && objGamblingBetStar.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objBetStarTransaction : objGamblingBetStar.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction BetStar Gambling';
                            if(objBetStarTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objBetStarTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objBetStarTransaction.strdate;
                            objTransaction.click_text__c = objBetStarTransaction.text;
                            if(objBetStarTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objBetStarTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objBetStarTransaction.amount);
                            objTransaction.click_type__c = objBetStarTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objBetStarTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingBetStar);
                }
                if(ObjGambling.Bookmaker != null)
                {
                    FromBankstatementWrapper.cls_Bookmaker objGamblingBookmaker = ObjGambling.Bookmaker;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingBookmaker = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingBookmaker.Name = 'Bookmaker';
                    objSubcategoryGamblingBookmaker.Dependent__c = 'Bookmaker';
                    objSubcategoryGamblingBookmaker.Click_TransactionCount__c = string.valueof(objGamblingBookmaker.transactionCount);
                    objSubcategoryGamblingBookmaker.click_totalValue__c = string.valueof(objGamblingBookmaker.totalValue);
                    objSubcategoryGamblingBookmaker.click_monthAvg__c = string.valueof(objGamblingBookmaker.monthAvg);
                    objSubcategoryGamblingBookmaker.click_minValue__c = string.valueof(objGamblingBookmaker.minValue);
                    objSubcategoryGamblingBookmaker.click_maxValue__c = string.valueof(objGamblingBookmaker.maxValue);
                    objSubcategoryGamblingBookmaker.click_firstTransaction__c = objGamblingBookmaker.firstTransaction;
                    objSubcategoryGamblingBookmaker.click_lastTransaction__c = objGamblingBookmaker.lastTransaction;
                    objSubcategoryGamblingBookmaker.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingBookmaker.click_period__c = string.valueof(objGamblingBookmaker.period);
                    objSubcategoryGamblingBookmaker.click_periodIsRegular__c = string.valueof(objGamblingBookmaker.periodIsRegular);
                    objSubcategoryGamblingBookmaker.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //          objSubcategoryGamblingBookmaker.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingBookmaker.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingBookmaker.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingBookmaker.transactions != null && objGamblingBookmaker.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objBookmakerTransaction : objGamblingBookmaker.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Bookmaker Gambling';
                            if(objBookmakerTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objBookmakerTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objBookmakerTransaction.strdate;
                            objTransaction.click_text__c = objBookmakerTransaction.text;
                            if(objBookmakerTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objBookmakerTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objBookmakerTransaction.amount);
                            objTransaction.click_type__c = objBookmakerTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objBookmakerTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingBookmaker);
                }
                if(ObjGambling.Centrebet != null)
                {
                    FromBankstatementWrapper.cls_Centrebet objGamblingCentrebet = ObjGambling.Centrebet;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingCentrebet = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingCentrebet.Name = 'Centrebet';
                    objSubcategoryGamblingCentrebet.Dependent__c = 'Centrebet';
                    objSubcategoryGamblingCentrebet.Click_TransactionCount__c = string.valueof(objGamblingCentrebet.transactionCount);
                    objSubcategoryGamblingCentrebet.click_totalValue__c = string.valueof(objGamblingCentrebet.totalValue);
                    objSubcategoryGamblingCentrebet.click_monthAvg__c = string.valueof(objGamblingCentrebet.monthAvg);
                    objSubcategoryGamblingCentrebet.click_minValue__c = string.valueof(objGamblingCentrebet.minValue);
                    objSubcategoryGamblingCentrebet.click_maxValue__c = string.valueof(objGamblingCentrebet.maxValue);
                    objSubcategoryGamblingCentrebet.click_firstTransaction__c = objGamblingCentrebet.firstTransaction;
                    objSubcategoryGamblingCentrebet.click_lastTransaction__c = objGamblingCentrebet.lastTransaction;
                    objSubcategoryGamblingCentrebet.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingCentrebet.click_period__c = string.valueof(objGamblingCentrebet.period);
                    objSubcategoryGamblingCentrebet.click_periodIsRegular__c = string.valueof(objGamblingCentrebet.periodIsRegular);
                    objSubcategoryGamblingCentrebet.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryGamblingCentrebet.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingCentrebet.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingCentrebet.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingCentrebet.transactions != null && objGamblingCentrebet.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objCentrebetTransaction : objGamblingCentrebet.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Centrebet Gambling';
                            if(objCentrebetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objCentrebetTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objCentrebetTransaction.strdate;
                            objTransaction.click_text__c = objCentrebetTransaction.text;
                            if(objCentrebetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objCentrebetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objCentrebetTransaction.amount);
                            objTransaction.click_type__c = objCentrebetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objCentrebetTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingCentrebet);
                }
                if(ObjGambling.ClassicBet != null)
                {
                    FromBankstatementWrapper.cls_ClassicBet objGamblingClassicBet = ObjGambling.ClassicBet;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingClassicBet = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingClassicBet.Name = 'ClassicBet';
                    objSubcategoryGamblingClassicBet.Dependent__c = 'ClassicBet';
                    objSubcategoryGamblingClassicBet.Click_TransactionCount__c = string.valueof(objGamblingClassicBet.transactionCount);
                    objSubcategoryGamblingClassicBet.click_totalValue__c = string.valueof(objGamblingClassicBet.totalValue);
                    objSubcategoryGamblingClassicBet.click_monthAvg__c = string.valueof(objGamblingClassicBet.monthAvg);
                    objSubcategoryGamblingClassicBet.click_minValue__c = string.valueof(objGamblingClassicBet.minValue);
                    objSubcategoryGamblingClassicBet.click_maxValue__c = string.valueof(objGamblingClassicBet.maxValue);
                    objSubcategoryGamblingClassicBet.click_firstTransaction__c = objGamblingClassicBet.firstTransaction;
                    objSubcategoryGamblingClassicBet.click_lastTransaction__c = objGamblingClassicBet.lastTransaction;
                    objSubcategoryGamblingClassicBet.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingClassicBet.click_period__c = string.valueof(objGamblingClassicBet.period);
                    objSubcategoryGamblingClassicBet.click_periodIsRegular__c = string.valueof(objGamblingClassicBet.periodIsRegular);
                    objSubcategoryGamblingClassicBet.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryGamblingClassicBet.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingClassicBet.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingClassicBet.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingClassicBet.transactions != null && objGamblingClassicBet.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objClassicBetTransaction : objGamblingClassicBet.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction ClassicBet Gambling';
                            if(objClassicBetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objClassicBetTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objClassicBetTransaction.strdate;
                            objTransaction.click_text__c = objClassicBetTransaction.text;
                            if(objClassicBetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objClassicBetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objClassicBetTransaction.amount);
                            objTransaction.click_type__c = objClassicBetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objClassicBetTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingClassicBet);
                }
                if(ObjGambling.CrownBet != null)
                {
                    FromBankstatementWrapper.cls_CrownBet objGamblingCrownBet = ObjGambling.CrownBet;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingCrownBet = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingCrownBet.Name = 'CrownBet';
                    objSubcategoryGamblingCrownBet.Dependent__c = 'CrownBet';
                    objSubcategoryGamblingCrownBet.Click_TransactionCount__c = string.valueof(objGamblingCrownBet.transactionCount);
                    objSubcategoryGamblingCrownBet.click_totalValue__c = string.valueof(objGamblingCrownBet.totalValue);
                    objSubcategoryGamblingCrownBet.click_monthAvg__c = string.valueof(objGamblingCrownBet.monthAvg);
                    objSubcategoryGamblingCrownBet.click_minValue__c = string.valueof(objGamblingCrownBet.minValue);
                    objSubcategoryGamblingCrownBet.click_maxValue__c = string.valueof(objGamblingCrownBet.maxValue);
                    objSubcategoryGamblingCrownBet.click_firstTransaction__c = objGamblingCrownBet.firstTransaction;
                    objSubcategoryGamblingCrownBet.click_lastTransaction__c = objGamblingCrownBet.lastTransaction;
                    objSubcategoryGamblingCrownBet.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingCrownBet.click_period__c = string.valueof(objGamblingCrownBet.period);
                    objSubcategoryGamblingCrownBet.click_periodIsRegular__c = string.valueof(objGamblingCrownBet.periodIsRegular);
                    objSubcategoryGamblingCrownBet.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
            //      objSubcategoryGamblingCrownBet.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingCrownBet.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingCrownBet.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingCrownBet.transactions != null && objGamblingCrownBet.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objCrownBetTransaction : objGamblingCrownBet.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction CrownBet Gambling';
                            if(objCrownBetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objCrownBetTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objCrownBetTransaction.strdate;
                            objTransaction.click_text__c = objCrownBetTransaction.text;
                            if(objCrownBetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objCrownBetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objCrownBetTransaction.amount);
                            objTransaction.click_type__c = objCrownBetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objCrownBetTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingCrownBet);
                }
                if(ObjGambling.DigiMedia != null)
                {
                    FromBankstatementWrapper.cls_DigiMedia objGamblingDigiMedia = ObjGambling.DigiMedia;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingDigiMedia = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingDigiMedia.Name = 'DigiMedia';
                    objSubcategoryGamblingDigiMedia.Dependent__c = 'DigiMedia';
                    objSubcategoryGamblingDigiMedia.Click_TransactionCount__c = string.valueof(objGamblingDigiMedia.transactionCount);
                    objSubcategoryGamblingDigiMedia.click_totalValue__c = string.valueof(objGamblingDigiMedia.totalValue);
                    objSubcategoryGamblingDigiMedia.click_monthAvg__c = string.valueof(objGamblingDigiMedia.monthAvg);
                    objSubcategoryGamblingDigiMedia.click_minValue__c = string.valueof(objGamblingDigiMedia.minValue);
                    objSubcategoryGamblingDigiMedia.click_maxValue__c = string.valueof(objGamblingDigiMedia.maxValue);
                    objSubcategoryGamblingDigiMedia.click_firstTransaction__c = objGamblingDigiMedia.firstTransaction;
                    objSubcategoryGamblingDigiMedia.click_lastTransaction__c = objGamblingDigiMedia.lastTransaction;
                    objSubcategoryGamblingDigiMedia.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingDigiMedia.click_period__c = string.valueof(objGamblingDigiMedia.period);
                    objSubcategoryGamblingDigiMedia.click_periodIsRegular__c = string.valueof(objGamblingDigiMedia.periodIsRegular);
                    objSubcategoryGamblingDigiMedia.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryGamblingDigiMedia.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingDigiMedia.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingDigiMedia.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingDigiMedia.transactions != null && objGamblingDigiMedia.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objDigiMediaTransaction : objGamblingDigiMedia.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction DigiMedia Gambling';
                            if(objDigiMediaTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objDigiMediaTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objDigiMediaTransaction.strdate;
                            objTransaction.click_text__c = objDigiMediaTransaction.text;
                            if(objDigiMediaTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objDigiMediaTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objDigiMediaTransaction.amount);
                            objTransaction.click_type__c = objDigiMediaTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objDigiMediaTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingDigiMedia);
                }
                if(ObjGambling.Ladbrokes != null)
                {
                    FromBankstatementWrapper.cls_Ladbrokes objGamblingLadbrokes = ObjGambling.Ladbrokes;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingLadbrokes = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingLadbrokes.Name = 'Ladbrokes';
                    objSubcategoryGamblingLadbrokes.Dependent__c = 'Ladbrokes';
                    objSubcategoryGamblingLadbrokes.Click_TransactionCount__c = string.valueof(objGamblingLadbrokes.transactionCount);
                    objSubcategoryGamblingLadbrokes.click_totalValue__c = string.valueof(objGamblingLadbrokes.totalValue);
                    objSubcategoryGamblingLadbrokes.click_monthAvg__c = string.valueof(objGamblingLadbrokes.monthAvg);
                    objSubcategoryGamblingLadbrokes.click_minValue__c = string.valueof(objGamblingLadbrokes.minValue);
                    objSubcategoryGamblingLadbrokes.click_maxValue__c = string.valueof(objGamblingLadbrokes.maxValue);
                    objSubcategoryGamblingLadbrokes.click_firstTransaction__c = objGamblingLadbrokes.firstTransaction;
                    objSubcategoryGamblingLadbrokes.click_lastTransaction__c = objGamblingLadbrokes.lastTransaction;
                    objSubcategoryGamblingLadbrokes.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingLadbrokes.click_period__c = string.valueof(objGamblingLadbrokes.period);
                    objSubcategoryGamblingLadbrokes.click_periodIsRegular__c = string.valueof(objGamblingLadbrokes.periodIsRegular);
                    objSubcategoryGamblingLadbrokes.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
     //             objSubcategoryGamblingLadbrokes.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingLadbrokes.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingLadbrokes.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingLadbrokes.transactions != null && objGamblingLadbrokes.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objLadbrokesTransaction : objGamblingLadbrokes.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Ladbrokes Gambling';
                            if(objLadbrokesTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objLadbrokesTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objLadbrokesTransaction.strdate;
                            objTransaction.click_text__c = objLadbrokesTransaction.text;
                            if(objLadbrokesTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objLadbrokesTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objLadbrokesTransaction.amount);
                            objTransaction.click_type__c = objLadbrokesTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objLadbrokesTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingLadbrokes);
                }
                if(ObjGambling.LeoVegas != null)
                {
                    FromBankstatementWrapper.cls_LeoVegas objGamblingLeoVegas = ObjGambling.LeoVegas;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingLeoVegas = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingLeoVegas.Name = 'LeoVegas';
                    objSubcategoryGamblingLeoVegas.Dependent__c = 'LeoVegas';
                    objSubcategoryGamblingLeoVegas.Click_TransactionCount__c = string.valueof(objGamblingLeoVegas.transactionCount);
                    objSubcategoryGamblingLeoVegas.click_totalValue__c = string.valueof(objGamblingLeoVegas.totalValue);
                    objSubcategoryGamblingLeoVegas.click_monthAvg__c = string.valueof(objGamblingLeoVegas.monthAvg);
                    objSubcategoryGamblingLeoVegas.click_minValue__c = string.valueof(objGamblingLeoVegas.minValue);
                    objSubcategoryGamblingLeoVegas.click_maxValue__c = string.valueof(objGamblingLeoVegas.maxValue);
                    objSubcategoryGamblingLeoVegas.click_firstTransaction__c = objGamblingLeoVegas.firstTransaction;
                    objSubcategoryGamblingLeoVegas.click_lastTransaction__c = objGamblingLeoVegas.lastTransaction;
                    objSubcategoryGamblingLeoVegas.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingLeoVegas.click_period__c = string.valueof(objGamblingLeoVegas.period);
                    objSubcategoryGamblingLeoVegas.click_periodIsRegular__c = string.valueof(objGamblingLeoVegas.periodIsRegular);
                    objSubcategoryGamblingLeoVegas.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //          objSubcategoryGamblingLeoVegas.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingLeoVegas.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingLeoVegas.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingLeoVegas.transactions != null && objGamblingLeoVegas.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objLeoVegasTransaction : objGamblingLeoVegas.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction LeoVegas Gambling';
                            if(objLeoVegasTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objLeoVegasTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objLeoVegasTransaction.strdate;
                            objTransaction.click_text__c = objLeoVegasTransaction.text;
                            if(objLeoVegasTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objLeoVegasTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objLeoVegasTransaction.amount);
                            objTransaction.click_type__c = objLeoVegasTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objLeoVegasTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingLeoVegas);
                }
                if(ObjGambling.Luxbet != null)
                {
                    FromBankstatementWrapper.cls_Luxbet objGamblingLuxbet = ObjGambling.Luxbet;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingLuxbet = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingLuxbet.Name = 'Luxbet';
                    objSubcategoryGamblingLuxbet.Dependent__c = 'Luxbet';
                    objSubcategoryGamblingLuxbet.Click_TransactionCount__c = string.valueof(objGamblingLuxbet.transactionCount);
                    objSubcategoryGamblingLuxbet.click_totalValue__c = string.valueof(objGamblingLuxbet.totalValue);
                    objSubcategoryGamblingLuxbet.click_monthAvg__c = string.valueof(objGamblingLuxbet.monthAvg);
                    objSubcategoryGamblingLuxbet.click_minValue__c = string.valueof(objGamblingLuxbet.minValue);
                    objSubcategoryGamblingLuxbet.click_maxValue__c = string.valueof(objGamblingLuxbet.maxValue);
                    objSubcategoryGamblingLuxbet.click_firstTransaction__c = objGamblingLuxbet.firstTransaction;
                    objSubcategoryGamblingLuxbet.click_lastTransaction__c = objGamblingLuxbet.lastTransaction;
                    objSubcategoryGamblingLuxbet.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingLuxbet.click_period__c = string.valueof(objGamblingLuxbet.period);
                    objSubcategoryGamblingLuxbet.click_periodIsRegular__c = string.valueof(objGamblingLuxbet.periodIsRegular);
                    objSubcategoryGamblingLuxbet.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryGamblingLuxbet.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingLuxbet.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingLuxbet.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingLuxbet.transactions != null && objGamblingLuxbet.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objLuxbetTransaction : objGamblingLuxbet.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Luxbet Gambling';
                            if(objLuxbetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objLuxbetTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objLuxbetTransaction.strdate;
                            objTransaction.click_text__c = objLuxbetTransaction.text;
                            if(objLuxbetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objLuxbetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objLuxbetTransaction.amount);
                            objTransaction.click_type__c = objLuxbetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objLuxbetTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingLuxbet);
                }
                if(ObjGambling.OzBet != null)
                {
                    FromBankstatementWrapper.cls_OzBet objGamblingOzBet = ObjGambling.OzBet;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingOzBet = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingOzBet.Name = 'OzBet';
                    objSubcategoryGamblingOzBet.Dependent__c = 'OzBet';
                    objSubcategoryGamblingOzBet.Click_TransactionCount__c = string.valueof(objGamblingOzBet.transactionCount);
                    objSubcategoryGamblingOzBet.click_totalValue__c = string.valueof(objGamblingOzBet.totalValue);
                    objSubcategoryGamblingOzBet.click_monthAvg__c = string.valueof(objGamblingOzBet.monthAvg);
                    objSubcategoryGamblingOzBet.click_minValue__c = string.valueof(objGamblingOzBet.minValue);
                    objSubcategoryGamblingOzBet.click_maxValue__c = string.valueof(objGamblingOzBet.maxValue);
                    objSubcategoryGamblingOzBet.click_firstTransaction__c = objGamblingOzBet.firstTransaction;
                    objSubcategoryGamblingOzBet.click_lastTransaction__c = objGamblingOzBet.lastTransaction;
                    objSubcategoryGamblingOzBet.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingOzBet.click_period__c = string.valueof(objGamblingOzBet.period);
                    objSubcategoryGamblingOzBet.click_periodIsRegular__c = string.valueof(objGamblingOzBet.periodIsRegular);
                    objSubcategoryGamblingOzBet.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryGamblingOzBet.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingOzBet.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingOzBet.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingOzBet.transactions != null && objGamblingOzBet.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objOzBetTransaction : objGamblingOzBet.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction OzBet Gambling';
                            if(objOzBetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objOzBetTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objOzBetTransaction.strdate;
                            objTransaction.click_text__c = objOzBetTransaction.text;
                            if(objOzBetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objOzBetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objOzBetTransaction.amount);
                            objTransaction.click_type__c = objOzBetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objOzBetTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingOzBet);
                }
                if(ObjGambling.Palmerbet != null)
                {
                    FromBankstatementWrapper.cls_Palmerbet objGamblingPalmerbet = ObjGambling.Palmerbet;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingPalmerbet = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingPalmerbet.Name = 'Palmerbet';
                    objSubcategoryGamblingPalmerbet.Dependent__c = 'Palmerbet';
                    objSubcategoryGamblingPalmerbet.Click_TransactionCount__c = string.valueof(objGamblingPalmerbet.transactionCount);
                    objSubcategoryGamblingPalmerbet.click_totalValue__c = string.valueof(objGamblingPalmerbet.totalValue);
                    objSubcategoryGamblingPalmerbet.click_monthAvg__c = string.valueof(objGamblingPalmerbet.monthAvg);
                    objSubcategoryGamblingPalmerbet.click_minValue__c = string.valueof(objGamblingPalmerbet.minValue);
                    objSubcategoryGamblingPalmerbet.click_maxValue__c = string.valueof(objGamblingPalmerbet.maxValue);
                    objSubcategoryGamblingPalmerbet.click_firstTransaction__c = objGamblingPalmerbet.firstTransaction;
                    objSubcategoryGamblingPalmerbet.click_lastTransaction__c = objGamblingPalmerbet.lastTransaction;
                    objSubcategoryGamblingPalmerbet.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingPalmerbet.click_period__c = string.valueof(objGamblingPalmerbet.period);
                    objSubcategoryGamblingPalmerbet.click_periodIsRegular__c = string.valueof(objGamblingPalmerbet.periodIsRegular);
                    objSubcategoryGamblingPalmerbet.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryGamblingPalmerbet.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingPalmerbet.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingPalmerbet.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingPalmerbet.transactions != null && objGamblingPalmerbet.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objPalmerbetTransaction : objGamblingPalmerbet.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Palmerbet Gambling';
                            if(objPalmerbetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPalmerbetTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPalmerbetTransaction.strdate;
                            objTransaction.click_text__c = objPalmerbetTransaction.text;
                            if(objPalmerbetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPalmerbetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objPalmerbetTransaction.amount);
                            objTransaction.click_type__c = objPalmerbetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPalmerbetTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingPalmerbet);
                }
                if(ObjGambling.Punters != null)
                {
                    FromBankstatementWrapper.cls_Punters objGamblingPunters = ObjGambling.Punters;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingPunters = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingPunters.Name = 'Punters';
                    objSubcategoryGamblingPunters.Dependent__c = 'Punters';
                    objSubcategoryGamblingPunters.Click_TransactionCount__c = string.valueof(objGamblingPunters.transactionCount);
                    objSubcategoryGamblingPunters.click_totalValue__c = string.valueof(objGamblingPunters.totalValue);
                    objSubcategoryGamblingPunters.click_monthAvg__c = string.valueof(objGamblingPunters.monthAvg);
                    objSubcategoryGamblingPunters.click_minValue__c = string.valueof(objGamblingPunters.minValue);
                    objSubcategoryGamblingPunters.click_maxValue__c = string.valueof(objGamblingPunters.maxValue);
                    objSubcategoryGamblingPunters.click_firstTransaction__c = objGamblingPunters.firstTransaction;
                    objSubcategoryGamblingPunters.click_lastTransaction__c = objGamblingPunters.lastTransaction;
                    objSubcategoryGamblingPunters.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingPunters.click_period__c = string.valueof(objGamblingPunters.period);
                    objSubcategoryGamblingPunters.click_periodIsRegular__c = string.valueof(objGamblingPunters.periodIsRegular);
                    objSubcategoryGamblingPunters.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryGamblingPunters.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingPunters.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingPunters.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingPunters.transactions != null && objGamblingPunters.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objPuntersTransaction : objGamblingPunters.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Punters Gambling';
                            if(objPuntersTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPuntersTransaction.strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPuntersTransaction.strdate;
                            objTransaction.click_text__c = objPuntersTransaction.text;
                            if(objPuntersTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPuntersTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objPuntersTransaction.amount);
                            objTransaction.click_type__c = objPuntersTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPuntersTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingPunters);
                }
                if(ObjGambling.Pokerstars != null)
                {
                    FromBankstatementWrapper.cls_Pokerstars objGamblingPokerstars = ObjGambling.Pokerstars;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingPokerstars = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingPokerstars.Name = 'Pokerstars';
                    objSubcategoryGamblingPokerstars.Dependent__c = 'Pokerstars';
                    objSubcategoryGamblingPokerstars.Click_TransactionCount__c = string.valueof(objGamblingPokerstars.transactionCount);
                    objSubcategoryGamblingPokerstars.click_totalValue__c = string.valueof(objGamblingPokerstars.totalValue);
                    objSubcategoryGamblingPokerstars.click_monthAvg__c = string.valueof(objGamblingPokerstars.monthAvg);
                    objSubcategoryGamblingPokerstars.click_minValue__c = string.valueof(objGamblingPokerstars.minValue);
                    objSubcategoryGamblingPokerstars.click_maxValue__c = string.valueof(objGamblingPokerstars.maxValue);
                    objSubcategoryGamblingPokerstars.click_firstTransaction__c = objGamblingPokerstars.firstTransaction;
                    objSubcategoryGamblingPokerstars.click_lastTransaction__c = objGamblingPokerstars.lastTransaction;
                    objSubcategoryGamblingPokerstars.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingPokerstars.click_period__c = string.valueof(objGamblingPokerstars.period);
                    objSubcategoryGamblingPokerstars.click_periodIsRegular__c = string.valueof(objGamblingPokerstars.periodIsRegular);
                    objSubcategoryGamblingPokerstars.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
                //  objSubcategoryGamblingPokerstars.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingPokerstars.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingPokerstars.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingPokerstars.transactions != null && objGamblingPokerstars.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objPokerstarsTransaction : objGamblingPokerstars.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Pokerstars Gambling';
                            if(objPokerstarsTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPokerstarsTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPokerstarsTransaction.strdate;
                            objTransaction.click_text__c = objPokerstarsTransaction.text;
                            if(objPokerstarsTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPokerstarsTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objPokerstarsTransaction.amount);
                            objTransaction.click_type__c = objPokerstarsTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPokerstarsTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingPokerstars);
                }
                if(ObjGambling.RoxyPalace != null)
                {
                    FromBankstatementWrapper.cls_RoxyPalace objGamblingRoxyPalace = ObjGambling.RoxyPalace;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingRoxyPalace = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingRoxyPalace.Name = 'Roxy Palace';
                    objSubcategoryGamblingRoxyPalace.Dependent__c = 'Roxy Palace';
                    objSubcategoryGamblingRoxyPalace.Click_TransactionCount__c = string.valueof(objGamblingRoxyPalace.transactionCount);
                    objSubcategoryGamblingRoxyPalace.click_totalValue__c = string.valueof(objGamblingRoxyPalace.totalValue);
                    objSubcategoryGamblingRoxyPalace.click_monthAvg__c = string.valueof(objGamblingRoxyPalace.monthAvg);
                    objSubcategoryGamblingRoxyPalace.click_minValue__c = string.valueof(objGamblingRoxyPalace.minValue);
                    objSubcategoryGamblingRoxyPalace.click_maxValue__c = string.valueof(objGamblingRoxyPalace.maxValue);
                    objSubcategoryGamblingRoxyPalace.click_firstTransaction__c = objGamblingRoxyPalace.firstTransaction;
                    objSubcategoryGamblingRoxyPalace.click_lastTransaction__c = objGamblingRoxyPalace.lastTransaction;
                    objSubcategoryGamblingRoxyPalace.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingRoxyPalace.click_period__c = string.valueof(objGamblingRoxyPalace.period);
                    objSubcategoryGamblingRoxyPalace.click_periodIsRegular__c = string.valueof(objGamblingRoxyPalace.periodIsRegular);
                    objSubcategoryGamblingRoxyPalace.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryGamblingRoxyPalace.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingRoxyPalace.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingRoxyPalace.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingRoxyPalace.transactions != null && objGamblingRoxyPalace.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objRoxyPalaceTransaction : objGamblingRoxyPalace.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Roxy Palace Gambling';
                            if(objRoxyPalaceTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objRoxyPalaceTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objRoxyPalaceTransaction.strdate;
                            objTransaction.click_text__c = objRoxyPalaceTransaction.text;
                            if(objRoxyPalaceTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objRoxyPalaceTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objRoxyPalaceTransaction.amount);
                            objTransaction.click_type__c = objRoxyPalaceTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objRoxyPalaceTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingRoxyPalace);
                }
                if(ObjGambling.Sportsbet != null)
                {
                    FromBankstatementWrapper.cls_Sportsbet objGamblingSportsbet = ObjGambling.Sportsbet;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingSportsbet = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingSportsbet.Name = 'Sportsbet';
                    objSubcategoryGamblingSportsbet.Dependent__c = 'Sportsbet';
                    objSubcategoryGamblingSportsbet.Click_TransactionCount__c = string.valueof(objGamblingSportsbet.transactionCount);
                    objSubcategoryGamblingSportsbet.click_totalValue__c = string.valueof(objGamblingSportsbet.totalValue);
                    objSubcategoryGamblingSportsbet.click_monthAvg__c = string.valueof(objGamblingSportsbet.monthAvg);
                    objSubcategoryGamblingSportsbet.click_minValue__c = string.valueof(objGamblingSportsbet.minValue);
                    objSubcategoryGamblingSportsbet.click_maxValue__c = string.valueof(objGamblingSportsbet.maxValue);
                    objSubcategoryGamblingSportsbet.click_firstTransaction__c = objGamblingSportsbet.firstTransaction;
                    objSubcategoryGamblingSportsbet.click_lastTransaction__c = objGamblingSportsbet.lastTransaction;
                    objSubcategoryGamblingSportsbet.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingSportsbet.click_period__c = string.valueof(objGamblingSportsbet.period);
                    objSubcategoryGamblingSportsbet.click_periodIsRegular__c = string.valueof(objGamblingSportsbet.periodIsRegular);
                    objSubcategoryGamblingSportsbet.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
     //             objSubcategoryGamblingSportsbet.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingSportsbet.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingSportsbet.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingSportsbet.transactions != null && objGamblingSportsbet.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objSportsbetTransaction : objGamblingSportsbet.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Sportsbet Gambling';
                            if(objSportsbetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSportsbetTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSportsbetTransaction.strdate;
                            objTransaction.click_text__c = objSportsbetTransaction.text;
                            if(objSportsbetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSportsbetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objSportsbetTransaction.amount);
                            objTransaction.click_type__c = objSportsbetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSportsbetTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingSportsbet);
                }
                if(ObjGambling.Sportsbetting != null)
                {
                    FromBankstatementWrapper.cls_Sportsbetting objGamblingSportsbetting = ObjGambling.Sportsbetting;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingSportsbetting = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingSportsbetting.Name = 'Sportsbetting';
                    objSubcategoryGamblingSportsbetting.Dependent__c = 'Sportsbetting';
                    objSubcategoryGamblingSportsbetting.Click_TransactionCount__c = string.valueof(objGamblingSportsbetting.transactionCount);
                    objSubcategoryGamblingSportsbetting.click_totalValue__c = string.valueof(objGamblingSportsbetting.totalValue);
                    objSubcategoryGamblingSportsbetting.click_monthAvg__c = string.valueof(objGamblingSportsbetting.monthAvg);
                    objSubcategoryGamblingSportsbetting.click_minValue__c = string.valueof(objGamblingSportsbetting.minValue);
                    objSubcategoryGamblingSportsbetting.click_maxValue__c = string.valueof(objGamblingSportsbetting.maxValue);
                    objSubcategoryGamblingSportsbetting.click_firstTransaction__c = objGamblingSportsbetting.firstTransaction;
                    objSubcategoryGamblingSportsbetting.click_lastTransaction__c = objGamblingSportsbetting.lastTransaction;
                    objSubcategoryGamblingSportsbetting.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingSportsbetting.click_period__c = string.valueof(objGamblingSportsbetting.period);
                    objSubcategoryGamblingSportsbetting.click_periodIsRegular__c = string.valueof(objGamblingSportsbetting.periodIsRegular);
                    objSubcategoryGamblingSportsbetting.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
               //   objSubcategoryGamblingSportsbetting.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingSportsbetting.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingSportsbetting.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingSportsbetting.transactions != null && objGamblingSportsbetting.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objSportsbettingTransaction : objGamblingSportsbetting.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Sportsbetting Gambling';
                            if(objSportsbettingTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSportsbettingTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSportsbettingTransaction.strdate;
                            objTransaction.click_text__c = objSportsbettingTransaction.text;
                            if(objSportsbettingTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSportsbettingTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objSportsbettingTransaction.amount);
                            objTransaction.click_type__c = objSportsbettingTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSportsbettingTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingSportsbetting);
                }
                if(ObjGambling.Sportingbet != null)
                {
                    FromBankstatementWrapper.cls_Sportingbet objGamblingSportingbet = ObjGambling.Sportingbet;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingSportingbet = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingSportingbet.Name = 'Sportingbet';
                    objSubcategoryGamblingSportingbet.Dependent__c = 'Sportingbet';
                    objSubcategoryGamblingSportingbet.Click_TransactionCount__c = string.valueof(objGamblingSportingbet.transactionCount);
                    objSubcategoryGamblingSportingbet.click_totalValue__c = string.valueof(objGamblingSportingbet.totalValue);
                    objSubcategoryGamblingSportingbet.click_monthAvg__c = string.valueof(objGamblingSportingbet.monthAvg);
                    objSubcategoryGamblingSportingbet.click_minValue__c = string.valueof(objGamblingSportingbet.minValue);
                    objSubcategoryGamblingSportingbet.click_maxValue__c = string.valueof(objGamblingSportingbet.maxValue);
                    objSubcategoryGamblingSportingbet.click_firstTransaction__c = objGamblingSportingbet.firstTransaction;
                    objSubcategoryGamblingSportingbet.click_lastTransaction__c = objGamblingSportingbet.lastTransaction;
                    objSubcategoryGamblingSportingbet.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingSportingbet.click_period__c = string.valueof(objGamblingSportingbet.period);
                    objSubcategoryGamblingSportingbet.click_periodIsRegular__c = string.valueof(objGamblingSportingbet.periodIsRegular);
                    objSubcategoryGamblingSportingbet.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryGamblingSportingbet.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingSportingbet.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingSportingbet.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingSportingbet.transactions != null && objGamblingSportingbet.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objSportingbetTransaction : objGamblingSportingbet.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Sportingbet Gambling';
                            if(objSportingbetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSportingbetTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSportingbetTransaction.strdate;
                            objTransaction.click_text__c = objSportingbetTransaction.text;
                            if(objSportingbetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSportingbetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objSportingbetTransaction.amount);
                            objTransaction.click_type__c = objSportingbetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSportingbetTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingSportingbet);
                }
                if(ObjGambling.TABTouch != null)
                {
                    FromBankstatementWrapper.cls_TABTouch objGamblingTABTouch = ObjGambling.TABTouch;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingTABTouch = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingTABTouch.Name = 'TABTouch';
                    objSubcategoryGamblingTABTouch.Dependent__c = 'TABTouch';
                    objSubcategoryGamblingTABTouch.Click_TransactionCount__c = string.valueof(objGamblingTABTouch.transactionCount);
                    objSubcategoryGamblingTABTouch.click_totalValue__c = string.valueof(objGamblingTABTouch.totalValue);
                    objSubcategoryGamblingTABTouch.click_monthAvg__c = string.valueof(objGamblingTABTouch.monthAvg);
                    objSubcategoryGamblingTABTouch.click_minValue__c = string.valueof(objGamblingTABTouch.minValue);
                    objSubcategoryGamblingTABTouch.click_maxValue__c = string.valueof(objGamblingTABTouch.maxValue);
                    objSubcategoryGamblingTABTouch.click_firstTransaction__c = objGamblingTABTouch.firstTransaction;
                    objSubcategoryGamblingTABTouch.click_lastTransaction__c = objGamblingTABTouch.lastTransaction;
                    objSubcategoryGamblingTABTouch.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingTABTouch.click_period__c = string.valueof(objGamblingTABTouch.period);
                    objSubcategoryGamblingTABTouch.click_periodIsRegular__c = string.valueof(objGamblingTABTouch.periodIsRegular);
                    objSubcategoryGamblingTABTouch.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //            objSubcategoryGamblingTABTouch.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingTABTouch.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingTABTouch.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingTABTouch.transactions != null && objGamblingTABTouch.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objTABTouchTransaction : objGamblingTABTouch.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction TABTouch Gambling';
                            if(objTABTouchTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objTABTouchTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objTABTouchTransaction.strdate;
                            objTransaction.click_text__c = objTABTouchTransaction.text;
                            if(objTABTouchTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objTABTouchTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objTABTouchTransaction.amount);
                            objTransaction.click_type__c = objTABTouchTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objTABTouchTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingTABTouch);
                }
                if(ObjGambling.Tatts != null)
                {
                    FromBankstatementWrapper.cls_Tatts objGamblingTatts = ObjGambling.Tatts;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingTatts = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingTatts.Name = 'Tatts';
                    objSubcategoryGamblingTatts.Dependent__c = 'Tatts';
                    objSubcategoryGamblingTatts.Click_TransactionCount__c = string.valueof(objGamblingTatts.transactionCount);
                    objSubcategoryGamblingTatts.click_totalValue__c = string.valueof(objGamblingTatts.totalValue);
                    objSubcategoryGamblingTatts.click_monthAvg__c = string.valueof(objGamblingTatts.monthAvg);
                    objSubcategoryGamblingTatts.click_minValue__c = string.valueof(objGamblingTatts.minValue);
                    objSubcategoryGamblingTatts.click_maxValue__c = string.valueof(objGamblingTatts.maxValue);
                    objSubcategoryGamblingTatts.click_firstTransaction__c = objGamblingTatts.firstTransaction;
                    objSubcategoryGamblingTatts.click_lastTransaction__c = objGamblingTatts.lastTransaction;
                    objSubcategoryGamblingTatts.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingTatts.click_period__c = string.valueof(objGamblingTatts.period);
                    objSubcategoryGamblingTatts.click_periodIsRegular__c = string.valueof(objGamblingTatts.periodIsRegular);
                    objSubcategoryGamblingTatts.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryGamblingTatts.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingTatts.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingTatts.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingTatts.transactions != null && objGamblingTatts.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objTattsTransaction : objGamblingTatts.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Tatts Gambling';
                            if(objTattsTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objTattsTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objTattsTransaction.strdate;
                            objTransaction.click_text__c = objTattsTransaction.text;
                            if(objTattsTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objTattsTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objTattsTransaction.amount);
                            objTransaction.click_type__c = objTattsTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objTattsTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingTatts);
                }
                if(ObjGambling.TomWaterhouse != null)
                {
                    FromBankstatementWrapper.cls_TomWaterhouse objGamblingTomWaterhouse = ObjGambling.TomWaterhouse;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingTomWaterhouse = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingTomWaterhouse.Name = 'Tom Waterhouse';
                    objSubcategoryGamblingTomWaterhouse.Dependent__c = 'Tom Waterhouse';
                    objSubcategoryGamblingTomWaterhouse.Click_TransactionCount__c = string.valueof(objGamblingTomWaterhouse.transactionCount);
                    objSubcategoryGamblingTomWaterhouse.click_totalValue__c = string.valueof(objGamblingTomWaterhouse.totalValue);
                    objSubcategoryGamblingTomWaterhouse.click_monthAvg__c = string.valueof(objGamblingTomWaterhouse.monthAvg);
                    objSubcategoryGamblingTomWaterhouse.click_minValue__c = string.valueof(objGamblingTomWaterhouse.minValue);
                    objSubcategoryGamblingTomWaterhouse.click_maxValue__c = string.valueof(objGamblingTomWaterhouse.maxValue);
                    objSubcategoryGamblingTomWaterhouse.click_firstTransaction__c = objGamblingTomWaterhouse.firstTransaction;
                    objSubcategoryGamblingTomWaterhouse.click_lastTransaction__c = objGamblingTomWaterhouse.lastTransaction;
                    objSubcategoryGamblingTomWaterhouse.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingTomWaterhouse.click_period__c = string.valueof(objGamblingTomWaterhouse.period);
                    objSubcategoryGamblingTomWaterhouse.click_periodIsRegular__c = string.valueof(objGamblingTomWaterhouse.periodIsRegular);
                    objSubcategoryGamblingTomWaterhouse.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //            objSubcategoryGamblingTomWaterhouse.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingTomWaterhouse.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingTomWaterhouse.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingTomWaterhouse.transactions != null && objGamblingTomWaterhouse.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objTomWaterhouseTransaction : objGamblingTomWaterhouse.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Tom Waterhouse Gambling';
                            if(objTomWaterhouseTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objTomWaterhouseTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objTomWaterhouseTransaction.strdate;
                            objTransaction.click_text__c = objTomWaterhouseTransaction.text;
                            if(objTomWaterhouseTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objTomWaterhouseTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objTomWaterhouseTransaction.amount);
                            objTransaction.click_type__c = objTomWaterhouseTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objTomWaterhouseTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingTomWaterhouse);
                }
                if(ObjGambling.UBET != null)
                {
                    FromBankstatementWrapper.cls_UBET objGamblingUBET = ObjGambling.UBET;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingUBET = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingUBET.Name = 'UBET';
                    objSubcategoryGamblingUBET.Dependent__c = 'UBET';
                    objSubcategoryGamblingUBET.Click_TransactionCount__c = string.valueof(objGamblingUBET.transactionCount);
                    objSubcategoryGamblingUBET.click_totalValue__c = string.valueof(objGamblingUBET.totalValue);
                    objSubcategoryGamblingUBET.click_monthAvg__c = string.valueof(objGamblingUBET.monthAvg);
                    objSubcategoryGamblingUBET.click_minValue__c = string.valueof(objGamblingUBET.minValue);
                    objSubcategoryGamblingUBET.click_maxValue__c = string.valueof(objGamblingUBET.maxValue);
                    objSubcategoryGamblingUBET.click_firstTransaction__c = objGamblingUBET.firstTransaction;
                    objSubcategoryGamblingUBET.click_lastTransaction__c = objGamblingUBET.lastTransaction;
                    objSubcategoryGamblingUBET.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingUBET.click_period__c = string.valueof(objGamblingUBET.period);
                    objSubcategoryGamblingUBET.click_periodIsRegular__c = string.valueof(objGamblingUBET.periodIsRegular);
                    objSubcategoryGamblingUBET.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
       //           objSubcategoryGamblingUBET.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingUBET.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingUBET.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingUBET.transactions != null && objGamblingUBET.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objUBETTransaction : objGamblingUBET.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction UBET Gambling';
                            if(objUBETTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objUBETTransaction.strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objUBETTransaction.strdate;
                            objTransaction.click_text__c = objUBETTransaction.text;
                            if(objUBETTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objUBETTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objUBETTransaction.amount);
                            objTransaction.click_type__c = objUBETTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objUBETTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingUBET);
                }
                if(ObjGambling.Unibet != null)
                {
                    FromBankstatementWrapper.cls_Unibet objGamblingUnibet = ObjGambling.Unibet;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingUnibet = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingUnibet.Name = 'Unibet';
                    objSubcategoryGamblingUnibet.Dependent__c = 'Unibet';
                    objSubcategoryGamblingUnibet.Click_TransactionCount__c = string.valueof(objGamblingUnibet.transactionCount);
                    objSubcategoryGamblingUnibet.click_totalValue__c = string.valueof(objGamblingUnibet.totalValue);
                    objSubcategoryGamblingUnibet.click_monthAvg__c = string.valueof(objGamblingUnibet.monthAvg);
                    objSubcategoryGamblingUnibet.click_minValue__c = string.valueof(objGamblingUnibet.minValue);
                    objSubcategoryGamblingUnibet.click_maxValue__c = string.valueof(objGamblingUnibet.maxValue);
                    objSubcategoryGamblingUnibet.click_firstTransaction__c = objGamblingUnibet.firstTransaction;
                    objSubcategoryGamblingUnibet.click_lastTransaction__c = objGamblingUnibet.lastTransaction;
                    objSubcategoryGamblingUnibet.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingUnibet.click_period__c = string.valueof(objGamblingUnibet.period);
                    objSubcategoryGamblingUnibet.click_periodIsRegular__c = string.valueof(objGamblingUnibet.periodIsRegular);
                    objSubcategoryGamblingUnibet.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
         //         objSubcategoryGamblingUnibet.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingUnibet.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingUnibet.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingUnibet.transactions != null && objGamblingUnibet.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objUnibetTransaction : objGamblingUnibet.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Unibet Gambling';
                            if(objUnibetTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objUnibetTransaction.strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objUnibetTransaction.strdate;
                            objTransaction.click_text__c = objUnibetTransaction.text;
                            if(objUnibetTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objUnibetTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objUnibetTransaction.amount);
                            objTransaction.click_type__c = objUnibetTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objUnibetTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingUnibet);
                }
                if(ObjGambling.WilliamHill != null)
                {
                    FromBankstatementWrapper.cls_WilliamHill objGamblingWilliamHill = ObjGambling.WilliamHill;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingWilliamHill = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingWilliamHill.Name = 'William Hill';
                    objSubcategoryGamblingWilliamHill.Dependent__c = 'William Hill';
                    objSubcategoryGamblingWilliamHill.Click_TransactionCount__c = string.valueof(objGamblingWilliamHill.transactionCount);
                    objSubcategoryGamblingWilliamHill.click_totalValue__c = string.valueof(objGamblingWilliamHill.totalValue);
                    objSubcategoryGamblingWilliamHill.click_monthAvg__c = string.valueof(objGamblingWilliamHill.monthAvg);
                    objSubcategoryGamblingWilliamHill.click_minValue__c = string.valueof(objGamblingWilliamHill.minValue);
                    objSubcategoryGamblingWilliamHill.click_maxValue__c = string.valueof(objGamblingWilliamHill.maxValue);
                    objSubcategoryGamblingWilliamHill.click_firstTransaction__c = objGamblingWilliamHill.firstTransaction;
                    objSubcategoryGamblingWilliamHill.click_lastTransaction__c = objGamblingWilliamHill.lastTransaction;
                    objSubcategoryGamblingWilliamHill.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingWilliamHill.click_period__c = string.valueof(objGamblingWilliamHill.period);
                    objSubcategoryGamblingWilliamHill.click_periodIsRegular__c = string.valueof(objGamblingWilliamHill.periodIsRegular);
                    objSubcategoryGamblingWilliamHill.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //          objSubcategoryGamblingWilliamHill.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingWilliamHill.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingWilliamHill.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingWilliamHill.transactions != null && objGamblingWilliamHill.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objWilliamHillTransaction : objGamblingWilliamHill.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction William Hill Gambling';
                            if(objWilliamHillTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objWilliamHillTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objWilliamHillTransaction.strdate;
                            objTransaction.click_text__c = objWilliamHillTransaction.text;
                            if(objWilliamHillTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objWilliamHillTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objWilliamHillTransaction.amount);
                            objTransaction.click_type__c = objWilliamHillTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objWilliamHillTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingWilliamHill);
                }
                if(ObjGambling.Casino != null)
                {
                    FromBankstatementWrapper.cls_Casino objGamblingCasino = ObjGambling.Casino;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingCasino = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingCasino.Name = 'Casino';
                    objSubcategoryGamblingCasino.Dependent__c = 'Casino';
                    objSubcategoryGamblingCasino.Click_TransactionCount__c = string.valueof(objGamblingCasino.transactionCount);
                    objSubcategoryGamblingCasino.click_totalValue__c = string.valueof(objGamblingCasino.totalValue);
                    objSubcategoryGamblingCasino.click_monthAvg__c = string.valueof(objGamblingCasino.monthAvg);
                    objSubcategoryGamblingCasino.click_minValue__c = string.valueof(objGamblingCasino.minValue);
                    objSubcategoryGamblingCasino.click_maxValue__c = string.valueof(objGamblingCasino.maxValue);
                    objSubcategoryGamblingCasino.click_firstTransaction__c = objGamblingCasino.firstTransaction;
                    objSubcategoryGamblingCasino.click_lastTransaction__c = objGamblingCasino.lastTransaction;
                    objSubcategoryGamblingCasino.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingCasino.click_period__c = string.valueof(objGamblingCasino.period);
                    objSubcategoryGamblingCasino.click_periodIsRegular__c = string.valueof(objGamblingCasino.periodIsRegular);
                    objSubcategoryGamblingCasino.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
        //          objSubcategoryGamblingCasino.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingCasino.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingCasino.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingCasino.transactions != null && objGamblingCasino.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objCasinoTransaction : objGamblingCasino.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Casino Gambling';
                            if(objCasinoTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objCasinoTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objCasinoTransaction.strdate;
                            objTransaction.click_text__c = objCasinoTransaction.text;
                            if(objCasinoTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objCasinoTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objCasinoTransaction.amount);
                            objTransaction.click_type__c = objCasinoTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objCasinoTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingCasino);
                }
                if(ObjGambling.Lottery != null)
                {
                    FromBankstatementWrapper.cls_Lottery objGamblingLottery = ObjGambling.Lottery;
                    click_Bank_Statements_Sub_Category__c objSubcategoryGamblingLottery = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryGamblingLottery.Name = 'Lottery';
                    objSubcategoryGamblingLottery.Dependent__c = 'Lottery';
                    objSubcategoryGamblingLottery.Click_TransactionCount__c = string.valueof(objGamblingLottery.transactionCount);
                    objSubcategoryGamblingLottery.click_totalValue__c = string.valueof(objGamblingLottery.totalValue);
                    objSubcategoryGamblingLottery.click_monthAvg__c = string.valueof(objGamblingLottery.monthAvg);
                    objSubcategoryGamblingLottery.click_minValue__c = string.valueof(objGamblingLottery.minValue);
                    objSubcategoryGamblingLottery.click_maxValue__c = string.valueof(objGamblingLottery.maxValue);
                    objSubcategoryGamblingLottery.click_firstTransaction__c = objGamblingLottery.firstTransaction;
                    objSubcategoryGamblingLottery.click_lastTransaction__c = objGamblingLottery.lastTransaction;
                    objSubcategoryGamblingLottery.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryGamblingLottery.click_period__c = string.valueof(objGamblingLottery.period);
                    objSubcategoryGamblingLottery.click_periodIsRegular__c = string.valueof(objGamblingLottery.periodIsRegular);
                    objSubcategoryGamblingLottery.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
      //            objSubcategoryGamblingLottery.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryGamblingLottery.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryGamblingLottery.Click_Required_Document_Id__c = ReqDocId;
                    if(objGamblingLottery.transactions != null && objGamblingLottery.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objLotteryTransaction : objGamblingLottery.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Lottery Gambling';
                            if(objLotteryTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objLotteryTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objLotteryTransaction.strdate;
                            objTransaction.click_text__c = objLotteryTransaction.text;
                            if(objLotteryTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objLotteryTransaction.notes;
                                
                            }
                            objTransaction.click_amount__c = string.valueOf(objLotteryTransaction.amount);
                            objTransaction.click_type__c = objLotteryTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objLotteryTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryGamblingLottery);
                }
                lstctegory.add(objBankStatementData);
                CategoryIndex++;
            }
            if(objanalysis.OtherDebits != null)
            {
                click_Bank_Statement_Data__c objBankStatementData = new click_Bank_Statement_Data__c();
                objBankStatementData.Name = 'OtherDebits';
                objBankStatementData.Click_Statement_No__c = string.valueof(CategoryIndex);
                objBankStatementData.Bank_Statement_Account_Number__c = AccountNumber;
                if(string.isNotEmpty(ReqDocId))
                objBankStatementData.Click_Required_Document_Id__c = ReqDocId;
                                
                FromBankstatementWrapper.cls_OtherDebits ObjOtherDebits = objanalysis.OtherDebits;
                if(ObjOtherDebits.total != null)
                {
                    
                    FromBankstatementWrapper.cls_total objOtherDebitsTotal = ObjOtherDebits.total;
                    objBankStatementData.Click_TransactionCount__c = string.valueof(objOtherDebitsTotal.transactionCount);
                    objBankStatementData.click_totalValue__c = string.valueof(objOtherDebitsTotal.totalValue);
                    objBankStatementData.click_monthAvg__c = string.valueof(objOtherDebitsTotal.monthAvg);
                }
                if(ObjOtherDebits.PaygatePayments != null)
                {
                    FromBankstatementWrapper.cls_PaygatePayments objOtherDebitsPaygatePayments = ObjOtherDebits.PaygatePayments;
                    click_Bank_Statements_Sub_Category__c objSubcategoryOtherDebitsPaygatePayments = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryOtherDebitsPaygatePayments.Name = 'Paygate Payments';
                    objSubcategoryOtherDebitsPaygatePayments.Dependent__c = 'Paygate Payments';
                    objSubcategoryOtherDebitsPaygatePayments.Click_TransactionCount__c = string.valueof(objOtherDebitsPaygatePayments.transactionCount);
                    objSubcategoryOtherDebitsPaygatePayments.click_totalValue__c = string.valueof(objOtherDebitsPaygatePayments.totalValue);
                    objSubcategoryOtherDebitsPaygatePayments.click_monthAvg__c = string.valueof(objOtherDebitsPaygatePayments.monthAvg);
                    objSubcategoryOtherDebitsPaygatePayments.click_minValue__c = string.valueof(objOtherDebitsPaygatePayments.minValue);
                    objSubcategoryOtherDebitsPaygatePayments.click_maxValue__c = string.valueof(objOtherDebitsPaygatePayments.maxValue);
                    objSubcategoryOtherDebitsPaygatePayments.click_firstTransaction__c = objOtherDebitsPaygatePayments.firstTransaction;
                    objSubcategoryOtherDebitsPaygatePayments.click_lastTransaction__c = objOtherDebitsPaygatePayments.lastTransaction;
                    objSubcategoryOtherDebitsPaygatePayments.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryOtherDebitsPaygatePayments.click_period__c = string.valueof(objOtherDebitsPaygatePayments.period);
                    objSubcategoryOtherDebitsPaygatePayments.click_periodIsRegular__c = string.valueof(objOtherDebitsPaygatePayments.periodIsRegular);
                    objSubcategoryOtherDebitsPaygatePayments.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
     //             objSubcategoryOtherDebitsPaygatePayments.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryOtherDebitsPaygatePayments.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryOtherDebitsPaygatePayments.Click_Required_Document_Id__c = ReqDocId;
                    if(objOtherDebitsPaygatePayments.transactions != null && objOtherDebitsPaygatePayments.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objPaygatePaymentsTransaction : objOtherDebitsPaygatePayments.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Paygate Payments Other Debits';
                            if(objPaygatePaymentsTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objPaygatePaymentsTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objPaygatePaymentsTransaction.strdate;
                            objTransaction.click_text__c = objPaygatePaymentsTransaction.text;
                            if(objPaygatePaymentsTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objPaygatePaymentsTransaction.notes;

                            }
                            objTransaction.click_amount__c = string.valueOf(objPaygatePaymentsTransaction.amount);
                            objTransaction.click_type__c = objPaygatePaymentsTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objPaygatePaymentsTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryOtherDebitsPaygatePayments);
                }
                if(ObjOtherDebits.SPER != null)
                {
                    FromBankstatementWrapper.cls_SPER objOtherDebitsSPER = ObjOtherDebits.SPER;
                    click_Bank_Statements_Sub_Category__c objSubcategoryOtherDebitsSPER = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryOtherDebitsSPER.Name = 'SPER';
                    objSubcategoryOtherDebitsSPER.Dependent__c = 'SPER';
                    objSubcategoryOtherDebitsSPER.Click_TransactionCount__c = string.valueof(objOtherDebitsSPER.transactionCount);
                    objSubcategoryOtherDebitsSPER.click_totalValue__c = string.valueof(objOtherDebitsSPER.totalValue);
                    objSubcategoryOtherDebitsSPER.click_monthAvg__c = string.valueof(objOtherDebitsSPER.monthAvg);
                    objSubcategoryOtherDebitsSPER.click_minValue__c = string.valueof(objOtherDebitsSPER.minValue);
                    objSubcategoryOtherDebitsSPER.click_maxValue__c = string.valueof(objOtherDebitsSPER.maxValue);
                    objSubcategoryOtherDebitsSPER.click_firstTransaction__c = objOtherDebitsSPER.firstTransaction ;
                    objSubcategoryOtherDebitsSPER.click_lastTransaction__c = objOtherDebitsSPER.lastTransaction;
                    objSubcategoryOtherDebitsSPER.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryOtherDebitsSPER.click_period__c = string.valueof(objOtherDebitsSPER.period);
                    objSubcategoryOtherDebitsSPER.click_periodIsRegular__c = string.valueof(objOtherDebitsSPER.periodIsRegular);
                    objSubcategoryOtherDebitsSPER.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
          //        objSubcategoryOtherDebitsSPER.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryOtherDebitsSPER.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryOtherDebitsSPER.Click_Required_Document_Id__c = ReqDocId;
                    if(objOtherDebitsSPER.transactions != null && objOtherDebitsSPER.transactions.size() > 0)
                    {
                         for(FromBankstatementWrapper.cls_transactions objSPERTransaction : objOtherDebitsSPER.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction SPER Other Debits';
                            if(objSPERTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objSPERTransaction .strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objSPERTransaction.strdate;
                            objTransaction.click_text__c = objSPERTransaction.text;
                            if(objSPERTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objSPERTransaction.notes;
                            }
                            objTransaction.click_amount__c = string.valueOf(objSPERTransaction.amount);
                            objTransaction.click_type__c = objSPERTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objSPERTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryOtherDebitsSPER);
                }
                if(ObjOtherDebits.Certegy != null)
                {
                    FromBankstatementWrapper.cls_Certegy objOtherDebitsCertegy = ObjOtherDebits.Certegy;
                    click_Bank_Statements_Sub_Category__c objSubcategoryOtherDebitsCertegy = new click_Bank_Statements_Sub_Category__c();
                    objSubcategoryOtherDebitsCertegy.Name = 'Certegy';
                    objSubcategoryOtherDebitsCertegy.Dependent__c = 'Certegy';
                    objSubcategoryOtherDebitsCertegy.Click_TransactionCount__c = string.valueof(objOtherDebitsCertegy.transactionCount);
                    objSubcategoryOtherDebitsCertegy.click_totalValue__c = string.valueof(objOtherDebitsCertegy.totalValue);
                    objSubcategoryOtherDebitsCertegy.click_monthAvg__c = string.valueof(objOtherDebitsCertegy.monthAvg);
                    objSubcategoryOtherDebitsCertegy.click_minValue__c = string.valueof(objOtherDebitsCertegy.minValue);
                    objSubcategoryOtherDebitsCertegy.click_maxValue__c = string.valueof(objOtherDebitsCertegy.maxValue);
                    objSubcategoryOtherDebitsCertegy.click_firstTransaction__c = objOtherDebitsCertegy.firstTransaction;
                    objSubcategoryOtherDebitsCertegy.click_lastTransaction__c = objOtherDebitsCertegy.lastTransaction;
                    objSubcategoryOtherDebitsCertegy.Click_Statement_No__c = string.valueOf(CategoryIndex);
                    objSubcategoryOtherDebitsCertegy.click_period__c = string.valueof(objOtherDebitsCertegy.period);
                    objSubcategoryOtherDebitsCertegy.click_periodIsRegular__c = string.valueof(objOtherDebitsCertegy.periodIsRegular);
                    objSubcategoryOtherDebitsCertegy.Click_Subcategory_Index__c = string.valueOf(SubcategoryIndex);
           //       objSubcategoryOtherDebitsCertegy.Click_Bank_Statements_Account__c = objBankStatementAcc.Id;
                    objSubcategoryOtherDebitsCertegy.Bank_Statement_Account_Number__c = AccountNumber;
                    if(string.isNotEmpty(ReqDocId))
                    objSubcategoryOtherDebitsCertegy.Click_Required_Document_Id__c = ReqDocId;
                    if(objOtherDebitsCertegy.transactions != null && objOtherDebitsCertegy.transactions.size() > 0)
                    {
                        for(FromBankstatementWrapper.cls_transactions objCertegyTransaction : objOtherDebitsCertegy.transactions)
                        {
                            click_Bank_Statements_Transactions__c objTransaction = new click_Bank_Statements_Transactions__c();
                            objTransaction.Name = 'Transaction Certegy Other Debits';
                            if(objCertegyTransaction.strDateObj != null)
                            {
                                objTransaction.dateObj__c = '';
                                FromBankstatementWrapper.cls_strDateObj  objDateObj = objCertegyTransaction.strDateObj;
                                if(string.isNotEmpty(objDateObj.strDate))
                                objTransaction.dateObj__c += objDateObj.strDate + ',';
                                if(objDateObj.timezone_type <> null)
                                objTransaction.dateObj__c += string.valueof(objDateObj.timezone_type) + ',';
                                if(string.isNotEmpty(objDateObj.timezone))
                                objTransaction.dateObj__c += objDateObj.timezone;
                            }
                            objTransaction.click_date__c = objCertegyTransaction.strdate;
                            objTransaction.click_text__c = objCertegyTransaction.text;
                            if(objCertegyTransaction.notes != null)
                            {
                                objTransaction.click_notes__c = objCertegyTransaction.notes;
                            }
                            objTransaction.click_amount__c = string.valueOf(objCertegyTransaction.amount);
                            objTransaction.click_type__c = objCertegyTransaction.type;
                            objTransaction.click_balance__c = string.valueOf(objCertegyTransaction.balance);
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
                    lstSubctegory.add(objSubcategoryOtherDebitsCertegy);
                } 
                lstctegory.add(objBankStatementData);
                CategoryIndex++;
            }   CallBankLoan.CallLoans(objanalysis,SubcategoryIndex,CategoryIndex,TransactionIndex,lstSubctegory,lstctegory,lstTransaction,AccountNumber,ReqDocId);
            }              
    }