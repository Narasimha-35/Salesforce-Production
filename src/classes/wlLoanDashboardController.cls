public class wlLoanDashboardController 
{
    public integer prodListIndex{get;set;}
    public decimal strRate{get;set;}
    public decimal strComparsionRate{get;set;}
    public decimal strMonthlyPayment{get;set;}
    public decimal strLoanFees{get;set;}
    public string strLVRProductId{get;set;}
    public decimal EstimatedSaving{get;set;}
    public decimal NoOfYears{get;set;}
    public boolean IsApplication{get;set;}
    public boolean IsApproval{get;set;}
    public boolean IsLoanDocument{get;set;}
    public boolean IsSettlement{get;set;}
    public boolean IsSettled{get;set;}
    public boolean isButtonvisible {get;set;}
    public string strCustomLabelValue{get;set;}
    public string DateConditionallyApproved{get;set;}
    public string DateFormallyApproved{get;set;}
    public string DateDocsGenerated{get;set;}
    public string DateExpectedSettlement{get;set;}
    public string strConditionsOfApproval{get;set;}
    public string strDescription{get;set;}
    public boolean isPasswordReset {get;set;}
    public boolean isCurrentLoanPanelDisplay {get;set;} 
    //Added By Lokesh on 16-12-14
    public Id OpportunityId;
    public List<WrapperProducts>lstWrapperProduct{get;set;}
    //Added by karthik on 08-05-2015
    public WrapperProducts objCurrentLoanDetails{get;set;}
    Public wlLoanDashboardController() 
    {
         IsApplication = false;
         IsApproval = false;
         IsLoanDocument = false;
         IsSettlement = false;
         IsSettled = false;
         isButtonvisible = true;
         isPasswordReset = false;
         lstWrapperProduct = new List<WrapperProducts>();
         objCurrentLoanDetails = new WrapperProducts(); 
        //Created by lokesh on 15-12-2014
        strRate = 0.00;
        strComparsionRate = 0.00;
        strMonthlyPayment = 0.00;
        strLoanFees  = 0.00;
        List<User> lstUser = [select id,acfIs_Password_Reset__c from User where id =: UserInfo.getuserId() AND IsActive =: true];
        If(lstUser != null && lstUser.size()>0){
           isPasswordReset = lstUser[0].acfIs_Password_Reset__c;
        }
        OpportunityId = clickCommon.getCurrentLoggedInOpportunityId(userinfo.getUserId(),'');        
        if(OpportunityId <> null)
        {
           double HouseValue,LVR;   
           List<Opportunity>lstOpportunity = [select id,Account.acfCurrent_Loan_Amount__pc,stageName,Description,acfApproval_Conditions__c,acfDate_Conditionally_Approved__c,acfDate_Formally_Approved__c,acfDate_Docs_Generated__c,acfExpected_Settlement_Date__c,acf_Status__c,Account.acfCurrent_Rate__pc,Account.acfApproximately_how_much_is_your_house__pc,Account.acfWhat_is_your_current_payment_type__pc,acfTenure__c from opportunity where AccountId<>null and id=:OpportunityId];
           system.debug('@#%#$%lstOpportunity'+lstOpportunity);
           
           if(lstOpportunity <> null && lstOpportunity.size()>0 && lstOpportunity[0].Account.acfCurrent_Loan_Amount__pc <> null && lstOpportunity[0].Account.acfApproximately_how_much_is_your_house__pc <> null)
           {
               
                if(IsValidDecimal(lstOpportunity[0].Account.acfApproximately_how_much_is_your_house__pc))
                      HouseValue = double.valueof(lstOpportunity[0].Account.acfApproximately_how_much_is_your_house__pc);
                else
                      HouseValue = 0.00;   
                LVR =  ((lstOpportunity[0].Account.acfCurrent_Loan_Amount__pc/HouseValue)* 100);
                system.debug('@#$%%'+LVR);
                //Display Opportunity Products      
                DisplayOpportunityLIProducts(OpportunityId,lstOpportunity[0].Account.acfCurrent_Loan_Amount__pc,lstOpportunity[0].Account.acfWhat_is_your_current_payment_type__pc);
               //Displaying Loan Products if Opportunity status is Application   
               if(lstOpportunity[0].stageName  == 'Application Taken' /*Added by Sumit*/|| lstOpportunity[0].stageName == 'Appointed')
               {
                 strDescription = lstOpportunity[0].Description;
                 DisplayLoanProducts(OpportunityId,HouseValue,LVR,lstOpportunity[0].Account.acfCurrent_Loan_Amount__pc,lstOpportunity[0].Account.acfWhat_is_your_current_payment_type__pc);
                 IsApplication = true;
               }
               else if(lstOpportunity[0].stageName  == 'Approval')
               {
                  strDescription = lstOpportunity[0].Description;
                  strCustomLabelValue = 'AcfApproval';
                  if(lstOpportunity[0].acfDate_Conditionally_Approved__c <> null)
                    DateConditionallyApproved = ConvertDateToString(lstOpportunity[0].acfDate_Conditionally_Approved__c);
                  strConditionsOfApproval     =  lstOpportunity[0].acfApproval_Conditions__c;
                  IsApproval = true;
               }
               else if(lstOpportunity[0].stageName  == 'Loan Document')
               {
                  strDescription = lstOpportunity[0].Description;
                  strCustomLabelValue = 'acfLoanDocument';
                  if(lstOpportunity[0].acfDate_Conditionally_Approved__c <> null)
                    DateConditionallyApproved = ConvertDateToString(lstOpportunity[0].acfDate_Conditionally_Approved__c);
                  if(lstOpportunity[0].acfDate_Formally_Approved__c <> null)
                    DateFormallyApproved = ConvertDateToString(lstOpportunity[0].acfDate_Formally_Approved__c);
                  if(lstOpportunity[0].acfDate_Docs_Generated__c <> null)
                    DateDocsGenerated = ConvertDateToString(lstOpportunity[0].acfDate_Docs_Generated__c);       
                  IsLoanDocument = true;
               }  
               else if(lstOpportunity[0].stageName  == 'Settlement' && lstOpportunity[0].acf_Status__c  == 'Approved and pending settlement')
               {
                    strDescription = lstOpportunity[0].Description;
                    strCustomLabelValue = 'AcfSettlement';
                    if(lstOpportunity[0].acfDate_Conditionally_Approved__c <> null)
                        DateConditionallyApproved = ConvertDateToString(lstOpportunity[0].acfDate_Conditionally_Approved__c);
                    if(lstOpportunity[0].acfDate_Formally_Approved__c <> null)
                        DateFormallyApproved = ConvertDateToString(lstOpportunity[0].acfDate_Formally_Approved__c);
                    if(lstOpportunity[0].acfDate_Docs_Generated__c <> null)
                        DateDocsGenerated = ConvertDateToString(lstOpportunity[0].acfDate_Docs_Generated__c);
                    if(lstOpportunity[0].acfExpected_Settlement_Date__c <> null)
                        DateExpectedSettlement = ConvertDateToString(lstOpportunity[0].acfExpected_Settlement_Date__c); 
                    IsSettlement = true;
               }
               else if(lstOpportunity[0].stageName  == 'Settlement' && lstOpportunity[0].acf_Status__c  == 'Settled')
               {
                    strDescription = lstOpportunity[0].Description;
                    strCustomLabelValue = 'acfLoan_Dashboard_Settled';
                    if(lstOpportunity[0].acfDate_Conditionally_Approved__c <> null)
                        DateConditionallyApproved = ConvertDateToString(lstOpportunity[0].acfDate_Conditionally_Approved__c);
                    if(lstOpportunity[0].acfDate_Formally_Approved__c <> null)
                        DateFormallyApproved = ConvertDateToString(lstOpportunity[0].acfDate_Formally_Approved__c);
                    if(lstOpportunity[0].acfDate_Docs_Generated__c <> null)
                        DateDocsGenerated = ConvertDateToString(lstOpportunity[0].acfDate_Docs_Generated__c);
                    if(lstOpportunity[0].acfExpected_Settlement_Date__c <> null)
                        DateExpectedSettlement = ConvertDateToString(lstOpportunity[0].acfExpected_Settlement_Date__c); 
                    IsSettled = true;
               }      
           }
        }
    }
    // Display Data from Opportunity Product.
    public void DisplayOpportunityLIProducts(Id OpportunityId,decimal CurrentLoan,string PaymentType)
    {
        system.debug('Sumit Called method DisplayOpportunityLIProducts OpportunityId = ' + OpportunityId + '  CurrentLoan = '+ CurrentLoan+ ' PaymentType = '+ PaymentType);
      if(OpportunityId <> null && CurrentLoan <> null && PaymentType <> null)
      { 
            //For Dispalying Values from Opportunity Line Items If any
           List<OpportunityLineItem> lstOpplst = [select id,Product2Id,acfComparison_Rate__c,acfRate__c,UnitPrice,product2.name,acfApplication_Fee__c, 
                                                   acfOngoing_Fees__c,acfTotal_Fee__c,acfLegal_Fees__c,Product2.ClickFeature_1__c,Product2.ClickFeature_2__c,
                                                    Product2.ClickFeature_3__c,Product2.acfDebit_Card__c,Product2.acfRedraw__c,Product2.acfInterest_Only__c,
                                                    Product2.acfOffset_Account__c,Product2.acfMultiple_Splits__c,Product2.acfAdd_Repayments__c,product2.acfTenure_in_Years__c,
                                                    product2.recordtype.name,Product2.Click_Loans_Bank_Detail__r.acfBank_Name__c
                                                    from OpportunityLineItem where OpportunityId=:OpportunityId limit 1];
           If(lstOpplst != null && lstOpplst.size()>0)
           {
               system.debug('Sumit lstOpplst = '+ lstOpplst );
                   isCurrentLoanPanelDisplay  = true; 
                   for(OpportunityLineItem OppLi: lstOpplst)
                   {
                        objCurrentLoanDetails.decRate = OppLi.acfRate__c;
                        objCurrentLoanDetails.decComparisionRate= OppLi.acfComparison_Rate__c;
                        objCurrentLoanDetails.decMonthlyPayment= integer.valueof(OppLi.UnitPrice);
                        if(OppLi.product2.recordtype.name == 'Variable' && OppLi.product2.acfOffset_Account__c == false)
                        {
                             objCurrentLoanDetails.ProductName = OppLi.product2.name;
                        }else if(OppLi.product2.recordtype.name == 'Variable' && OppLi.product2.acfOffset_Account__c == true) 
                                {
                                    objCurrentLoanDetails.ProductName = OppLi.product2.name;
                                }
                        if(OppLi.product2.recordtype.name == 'Fixed')
                        {
                            objCurrentLoanDetails.ProductName = OppLi.product2.acfTenure_in_Years__c+' Yr '+OppLi.product2.name;
                        }
                        objCurrentLoanDetails.ApplicationFee    =  OppLi.acfApplication_Fee__c;
                        objCurrentLoanDetails.OngoingFees    =  OppLi.acfOngoing_Fees__c;
                        objCurrentLoanDetails.TotalFee    =  OppLi.acfTotal_Fee__c;
                        objCurrentLoanDetails.LegalFees    =  OppLi.acfLegal_Fees__c;
                        objCurrentLoanDetails.strBankName = OppLi.Product2.Click_Loans_Bank_Detail__r.acfBank_Name__c;  
                        
                      
                        if(OppLi.Product2.ClickFeature_1__c != null)
                            objCurrentLoanDetails.Feature_1 = OppLi.Product2.ClickFeature_1__c;
                        if(OppLi.Product2.ClickFeature_2__c != null)
                            objCurrentLoanDetails.Feature_2 = OppLi.Product2.ClickFeature_2__c; 
                        if(OppLi.Product2.ClickFeature_3__c != null)
                            objCurrentLoanDetails.Feature_3 = OppLi.Product2.ClickFeature_3__c;
                        objCurrentLoanDetails.AddRepayments    =  OppLi.Product2.acfAdd_Repayments__c;
                        objCurrentLoanDetails.AddRepayments = false;
                        objCurrentLoanDetails.DebitCard    =  OppLi.Product2.acfDebit_Card__c;
                        objCurrentLoanDetails.Redraw   =  OppLi.Product2.acfRedraw__c;
                        objCurrentLoanDetails.InterestOnly    =  OppLi.Product2.acfInterest_Only__c;
                        objCurrentLoanDetails.OffsetAccount    =  OppLi.Product2.acfOffset_Account__c;
                        objCurrentLoanDetails.MultipleSplits    =  OppLi.Product2.acfMultiple_Splits__c;
                        
                   }
           }else{
                  isCurrentLoanPanelDisplay  = false;
                 }
      }             
    }
   
    //To display Products
    public pageReference DisplayLoanProducts(Id OpportunityId,double HouseValue,double LVR,decimal CurrentLoanAmount,string strPaymentType)
    { 
        map<string,LVR_Rate__c>mapProductIdToLVR = new map<string,LVR_Rate__c>();
        set<string>setProductIdToExclude = new set<string>();
        Integer IndexCount   = 0;
        double usrLVR = 0;
        List<LVR_Rate__c> lstProductIdToLVR = new list<LVR_Rate__c>();
        if(CurrentLoanAmount != null && HouseValue != null)
            usrLVR = (CurrentLoanAmount/HouseValue)*100;
        decimal decVariableRate = 0;
        decimal decFixedRate = 0;
        list<LVR_Rate__c> lstFixedLoans = new list<LVR_Rate__c>();
        list<LVR_Rate__c> lstBasicVariableLoans = new list<LVR_Rate__c>();
        list<LVR_Rate__c> lstOffsetVariableLoans = new list<LVR_Rate__c>();
        system.debug('usrLVr@@'+usrLVR +'===='+CurrentLoanAmount+'===='+HouseValue);
        boolean isFixed1YrCompleted = false;
        boolean isFixed2YrCompleted = false;
        boolean isFixed3yrCompleted = false;
        boolean isFixed4yrCompleted = false;
        boolean isFixed5yrCompleted = false;
        
        for(acfSuggested_Product__c objSuggestedProduct:[select id,acfFilter__c,acfProduct__c,acfProduct_Family__c from acfSuggested_Product__c where acfOpportunity__c=:OpportunityId])
        {
            if(objSuggestedProduct.acfFilter__c <> null && objSuggestedProduct.acfProduct__c <> null && objSuggestedProduct.acfFilter__c == 'Exclude')
            {
                setProductIdToExclude.add(objSuggestedProduct.acfProduct__c);
            }
            
        }
         // changes done by Ankit for Adding bank functionality
        set<id> setOfBankDetailId = new set<id>();
        List<Click_Loans_Bank__c> lstbank = new List<Click_Loans_Bank__c>();
        if(ClickCommon.getCommunitySetup(Network.getNetworkId()).Id <> null)
        {
            lstbank = [select id,Click_Loans_Bank_Detail__c,Community_Setup__c from Click_Loans_Bank__c where Community_Setup__c =:ClickCommon.getCommunitySetup(Network.getNetworkId()).Id];
        }
        if(lstbank.size() > 0 && lstbank != null)
        {
            for(Click_Loans_Bank__c objbank : lstbank)
            {
                    setOfBankDetailId.add(objbank.Click_Loans_Bank_Detail__c);
            }
        }
        //product filter logic added by karthik on 08-05-2015
        if(setOfBankDetailId <> null)
        {
            for(LVR_Rate__c objLVR:[select id,clickFixed_Interest_Rate__c,acfLVR__c,acfRate__c,acfProduct__r.name,acfProduct__r.acfType__c,acfProduct__c,acfTotal_Fee__c,acfProduct__r.acfvarTenure_In_Years__c,
                                    acfProduct__r.acfTenure_in_Years__c,acfProduct__r.ACF_Comparison_Rate__c,acfProduct__r.acfLoan_Size__c,
                                    acfProduct__r.Family,ACF_Comparison_Rate__c,acfProduct__r.RecordType.Name, acfProduct__r.ClickFeature_1__c, acfProduct__r.ClickFeature_2__c, acfProduct__r.ClickFeature_3__c,
                                    acfApplication_Fee__c, acfLegal_Fees__c, acfValuation_Fee__c,acfOngoing_Fees_annual__c,
                                    acfMonthly_Fees__c,acfAnnual_Fees__c,acfEstablishment_Fee__c,acfMortgage_Risk_Fee__c,acfTitle_Protection_Fee__c,
                                    acfProduct__r.acfAdd_Repayments__c, acfProduct__r.acfRedraw__c, acfProduct__r.acfDebit_Card__c, acfProduct__r.acfInterest_Only__c, acfProduct__r.acfMultiple_Splits__c, acfProduct__r.acfOffset_Account__c,
                                    clickLoan_Size_From__c,clickLVR_From__c, acfProduct__r.Click_Loans_Bank_Detail__r.acfBank_Name__c
                                    from LVR_Rate__c 
                                    where clickLoan_Size_From__c <: CurrentLoanAmount 
                                    and acfLoan_Size__c >=:CurrentLoanAmount 
                                    and clickLVR_From__c <: usrLVR 
                                    and acfLVR__c>=:usrLVR 
                                    and acfProduct__r.Click_Loans_Bank_Detail__c =: setOfBankDetailId
                                    order by acfTerm_in_Years__c,acfRate__c,clickFixed_Interest_Rate__c asc])
            {

                        if(setProductIdToExclude <> null && setProductIdToExclude.size()>0 && setProductIdToExclude.contains(objLVR.acfProduct__c))
                        {
                            continue;
                        }
                       
                       If(objLVR.acfProduct__r.Recordtype.Name == 'Variable' && objLVR.acfProduct__r.acfOffset_Account__c == false)
                            {
                               lstBasicVariableLoans.add(objLVR); 
                            }
                            if(objLVR.acfProduct__r.Recordtype.Name == 'Variable' && objLVR.acfProduct__r.acfOffset_Account__c == true)                      
                            {
                                lstOffsetVariableLoans.add(objLVR);
                            }         
                            if(objLVR.acfProduct__r.Recordtype.Name == 'Fixed')
                            {
                               if(objLVR.acfProduct__r.acfTenure_in_Years__c == '1' && isFixed1YrCompleted == false)
                               {
                                lstFixedLoans.add(objLVR);
                                isFixed1YrCompleted = true;
                               }
                               if(objLVR.acfProduct__r.acfTenure_in_Years__c == '2' && isFixed2YrCompleted == false)
                               {
                                   lstFixedLoans.add(objLVR);
                                   isFixed2YrCompleted = true;
                               }
                               if(objLVR.acfProduct__r.acfTenure_in_Years__c == '3' && isFixed3yrCompleted == false)
                               {
                                   lstFixedLoans.add(objLVR);
                                   isFixed3yrCompleted = true;
                               }
                               if(objLVR.acfProduct__r.acfTenure_in_Years__c == '4' && isFixed4yrCompleted == false && lstFixedLoans.size()<3)
                               {
                                   lstFixedLoans.add(objLVR);
                                   isFixed4yrCompleted = true;
                               }
                               if(objLVR.acfProduct__r.acfTenure_in_Years__c == '5' && isFixed5yrCompleted == false && lstFixedLoans.size()<3)
                               {
                                   lstFixedLoans.add(objLVR);
                                   isFixed5yrCompleted = true;
                               }
                            }
            }
        }
        
        if(lstBasicVariableLoans != null && lstBasicVariableLoans.size()>0)
         {
             lstProductIdToLVR.add(lstBasicVariableLoans[0]);
         }
         if(lstOffsetVariableLoans != null && lstOffsetVariableLoans.size()>0)
         {
             lstProductIdToLVR.add(lstOffsetVariableLoans[0]);
         }
         if(lstFixedLoans != null && lstFixedLoans.size()>0)
         {
             lstProductIdToLVR.addall(lstFixedLoans);
         }
         if(lstProductIdToLVR <> null && lstProductIdToLVR.size()>0)
         {
            for(LVR_Rate__c objLVRRate:lstProductIdToLVR)
            {
                WrapperProducts objWrapVariableProduct = new WrapperProducts();
                objWrapVariableProduct.decRate = objLVRRate.acfRate__c;
                objWrapVariableProduct.strRateType = objLVRRate.acfProduct__r.RecordType.Name;
                objWrapVariableProduct.decComparisionRate = objLVRRate.ACF_Comparison_Rate__c;
                objWrapVariableProduct.strcomparisionType = '';
                objWrapVariableProduct.IndexNo     = IndexCount;
                objWrapVariableProduct.ProductId   =  objLVRRate.acfProduct__c; 
                objWrapVariableProduct.strBankName = objLVRRate.acfProduct__r.Click_Loans_Bank_Detail__r.acfBank_Name__c;
               
                objWrapVariableProduct.ProdLVRID   =  objLVRRate.id;
                
                if(objLVRRate.acfApplication_Fee__c != null)
                    objWrapVariableProduct.ApplicationFee    =  objLVRRate.acfApplication_Fee__c;
                if(objLVRRate.acfOngoing_Fees_annual__c != null)
                    objWrapVariableProduct.OngoingFees    =  objLVRRate.acfOngoing_Fees_annual__c;
                if(objLVRRate.acfTotal_Fee__c != null)
                    objWrapVariableProduct.TotalFee    =  objLVRRate.acfTotal_Fee__c;
                if(objLVRRate.acfLegal_Fees__c != null)
                    objWrapVariableProduct.LegalFees    =  objLVRRate.acfLegal_Fees__c;
                    
                if(objLVRRate.acfAnnual_Fees__c != null)
                    objWrapVariableProduct.AnnualFee =  objLVRRate.acfAnnual_Fees__c;
                if(objLVRRate.acfMonthly_Fees__c != null)
                    objWrapVariableProduct.MonthlyFee =  objLVRRate.acfMonthly_Fees__c;
                if(objLVRRate.acfEstablishment_Fee__c != null)
                    objWrapVariableProduct.EstablishmentFee =  objLVRRate.acfEstablishment_Fee__c;
                if(objLVRRate.acfMortgage_Risk_Fee__c != null)
                    objWrapVariableProduct.MortgageRiskFee =  objLVRRate.acfMortgage_Risk_Fee__c;
                if(objLVRRate.acfTitle_Protection_Fee__c != null)
                    objWrapVariableProduct.TitleProtectionFee =  objLVRRate.acfTitle_Protection_Fee__c;
                if(objLVRRate.acfValuation_Fee__c != null)
                    objWrapVariableProduct.ValuationFee =  objLVRRate.acfValuation_Fee__c;
                    
              
                if(objLVRRate.acfProduct__r.ClickFeature_1__c != null)
                    objWrapVariableProduct.Feature_1 = objLVRRate.acfProduct__r.ClickFeature_1__c;
                if(objLVRRate.acfProduct__r.ClickFeature_2__c != null)
                    objWrapVariableProduct.Feature_2 = objLVRRate.acfProduct__r.ClickFeature_2__c;  
                if(objLVRRate.acfProduct__r.ClickFeature_3__c != null)
                    objWrapVariableProduct.Feature_3 = objLVRRate.acfProduct__r.ClickFeature_3__c;
                
                objWrapVariableProduct.AddRepayments    =  objLVRRate.acfProduct__r.acfAdd_Repayments__c;
                objWrapVariableProduct.DebitCard    =  objLVRRate.acfProduct__r.acfDebit_Card__c;
                objWrapVariableProduct.Redraw   =  objLVRRate.acfProduct__r.acfRedraw__c;
                objWrapVariableProduct.InterestOnly    =  objLVRRate.acfProduct__r.acfInterest_Only__c;
                objWrapVariableProduct.OffsetAccount    =  objLVRRate.acfProduct__r.acfOffset_Account__c;
                objWrapVariableProduct.MultipleSplits    =  objLVRRate.acfProduct__r.acfMultiple_Splits__c;
                
                If(objLVRRate.acfProduct__r.RecordType.Name == 'Fixed' && objLVRRate.acfProduct__r.acfvarTenure_In_Years__c != null && objLVRRate.clickFixed_Interest_Rate__c != null)
                {
                    objWrapVariableProduct.decRate = objLVRRate.clickFixed_Interest_Rate__c;
                    objWrapVariableProduct.ProductName = objLVRRate.acfProduct__r.acfTenure_in_Years__c+' Yr '+objLVRRate.acfProduct__r.name;
                    if(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c != null)
                    {
                        objWrapVariableProduct.TenureInMonth = (objLVRRate.acfProduct__r.acfvarTenure_In_Years__c)*12;
                        objWrapVariableProduct.TenureInYears = objLVRRate.acfProduct__r.acfvarTenure_In_Years__c;
                    }
                    //objWrapVariableProduct.EstimatedSaving = DisplayEstimatedSaving(currentRate,objLVRRate.acfRate__c,CurrentLoanAmount,strPaymentType,Decimal.valueof(objLVRRate.acfProduct__r.acfTenure_in_Years__c));
                    if(CurrentLoanAmount != null && strPaymentType != null && objLVRRate.clickFixed_Interest_Rate__c != null && objLVRRate.acfProduct__r.acfvarTenure_In_Years__c != null)
                        objWrapVariableProduct.decMonthlyPayment   = integer.valueof(acfCommon.calculateMonthlyPayment(CurrentLoanAmount,double.valueof(objLVRRate.clickFixed_Interest_Rate__c),strPaymentType,double.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c)));
                }
                If(objLVRRate.acfProduct__r.RecordType.Name == 'Variable')
                {
                   if( objLVRRate.acfProduct__r.acfOffset_Account__c == false)
                   {
                       objWrapVariableProduct.ProductName =  objLVRRate.acfProduct__r.name;
                   }else{
                           objWrapVariableProduct.ProductName =  objLVRRate.acfProduct__r.name;
                           }
                   objWrapVariableProduct.TenureInMonth = (objLVRRate.acfProduct__r.acfvarTenure_In_Years__c)*12;
                    objWrapVariableProduct.TenureInYears = objLVRRate.acfProduct__r.acfvarTenure_In_Years__c;    
                   if(CurrentLoanAmount != null && strPaymentType != null && objLVRRate.acfRate__c != null && objLVRRate.acfProduct__r.acfvarTenure_In_Years__c != null)
                    objWrapVariableProduct.decMonthlyPayment   = integer.valueof(acfCommon.calculateMonthlyPayment(CurrentLoanAmount,double.valueof(objLVRRate.acfRate__c),strPaymentType,double.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c)));
                    system.debug('Sumit objWrapVariableProduct ::'+objWrapVariableProduct);
                }
                objWrapVariableProduct.LoanFees   =  objLVRRate.acfTotal_Fee__c; 
                
                //system.debug('123456+2345'+objLVRRate.acfProduct__r.acfTenure_in_Years__c+'----------'+objLVRRate.id);                   
                lstWrapperProduct.add(objWrapVariableProduct);
                IndexCount++;                
             }
             IndexCount = lstWrapperProduct.size();
            }
        return null;
    }
    
    Public pagereference redirect()
    {
        String oppId = ClickCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId(),''); 
        If(oppId != null && oppId <> ''){
           return null;
        }else{
                String retUrl  = CLickCommon.sendReturnUrl(userInfo.getuserId(),false,'clickDashboard',Network.getNetworkId()); 
                Pagereference pageref= new Pagereference(retUrl);
                return pageref;
             }
    } 
    
    public boolean IsValidDecimal(decimal decValue)
    {
        try
        {
            decimal decimalValue = decValue;
            return true;
        }
        catch(Exception Ex)
        {
            return false;
        }
    }
    
    public string ConvertDateToString(Date DtDate)
    {
        map<Integer,String>mapMonthValueToMonthName;
        mapMonthValueToMonthName = new map<Integer,String>();
        mapMonthValueToMonthName.put(1,'January');
        mapMonthValueToMonthName.put(2,'February');
        mapMonthValueToMonthName.put(3,'March');
        mapMonthValueToMonthName.put(4,'April');
        mapMonthValueToMonthName.put(5,'May');
        mapMonthValueToMonthName.put(6,'June');
        mapMonthValueToMonthName.put(7,'July');
        mapMonthValueToMonthName.put(8,'August');
        mapMonthValueToMonthName.put(9,'September');
        mapMonthValueToMonthName.put(10,'October');
        mapMonthValueToMonthName.put(11,'November');
        mapMonthValueToMonthName.put(12,'December');    
       string strDay =  string.valueof(DtDate.day());

     return mapMonthValueToMonthName.get(DtDate.month())+' '+strDay+', '+DtDate.year();
    }  
    
    public class WrapperProducts
    { 
        public decimal decRate{get;set;}
        public string ProductName{get;set;}
        public string strRateType{get;set;}
        public decimal decComparisionRate{get;set;}
        public string strcomparisionType{get;set;}
        public integer decMonthlyPayment{get;set;}  
        public string strRating{get;set;} 
        public Id ProductId{get;set;}
        public Id ProdLVRID{get;set;}
        public decimal TenureInMonth{get;set;}
        public decimal LoanFees{get;set;}
        public Integer IndexNo{get;set;}   
        public decimal EstimatedSaving{get;set;}     
        public decimal TenureInYears{get;set;} 
        public string strBankName {get;set;}
        
        public decimal ApplicationFee {get;set;} 
        public decimal OngoingFees {get;set;} 
        public decimal TotalFee {get;set;} 
        public decimal LegalFees {get;set;}
        
        public decimal MonthlyFee {get;set;} 
        public decimal AnnualFee {get;set;} 
        public decimal EstablishmentFee {get;set;} 
        public decimal MortgageRiskFee {get;set;} 
        public decimal TitleProtectionFee {get;set;}
        public decimal ValuationFee {get;set;}
        
        public string Feature_1 {get;set;} 
        public string Feature_2 {get;set;} 
        public string Feature_3 {get;set;} 
        
        public boolean AddRepayments {get;set;}
        public boolean DebitCard {get;set;}
        public boolean Redraw {get;set;}
        public boolean InterestOnly {get;set;}
        public boolean OffsetAccount {get;set;}
        public boolean MultipleSplits {get;set;}
        
        public WrapperProducts()
        {
            ApplicationFee    =  0;
            OngoingFees    =  0;
            TotalFee    =  0;
            LegalFees    =  0;
            decMonthlyPayment = 0;
            MonthlyFee = 0; 
            AnnualFee = 0;
            EstablishmentFee = 0;
            MortgageRiskFee = 0;
            TitleProtectionFee = 0;
            ValuationFee = 0;
        }
    }
}