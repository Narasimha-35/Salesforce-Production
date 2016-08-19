public class CreditProposalDisclosureController {
 
    public string strAclHolder{get;set;}
    public string strAclAddress{get;set;}
    public string strAclLicenceNo{get;set;}
    public string strProdName{get;set;}
    public string strAccountAddress{get;set;}
    public Decimal OLILoanAmt{get;set;}
    public decimal OLIRate{get;set;}
    public Decimal OLIRepayment{get;set;}
    public string strOLILoanTerm{get;set;}
    public string strOLILender{get;set;}
    public string strBrokerFullName{get;set;}
    public string strBrokerAddress{get;set;}
    public string strBrokerEmail{get;set;}
    public string strBrokerPhone{get;set;}
    public string strBrokerRepsEmail{get;set;}
    public string strBrokerMob{get;set;}
    public string strBrokerCRNo{get;set;}
    public string strBrokerEDR{get;set;}
    public string BrokerACLMemberNo{get;set;}
    public string BrokerACRMemberNo{get;set;}
    public string strOLIProdName{get;set;}
    public string strOLIPaymentType{get;set;}
    public decimal formulaTotalFee{get;set;}
    public decimal FundingPosLMI{get;set;}
    public string strApplicantName{get;set;}
    public string strBrokerACLEmail{get;set;}
    public string strBrokerRepEmail{get;set;}
    public string strProduct2Name{get;set;}
    public Decimal OppAmount{get;set;}
    public Decimal Product2ApplFee{get;set;}
    public Decimal Product2LegalFee{get;set;}
    public decimal Product2AnnualFee{get;set;}
    public decimal Product2Monthlyfee{get;set;}
    public decimal Product2TC{get;set;}
    public decimal Product2UFC{get;set;}
    public decimal Produt2TCRatePm{get;set;}
    public integer decApplicantAge{get;set;}
    public decimal formulaUFC{get;set;}
    public decimal formulaTCpm{get;set;}
    public decimal formulaPartnerCommMin{get;set;}
    public decimal formulaPartnerCommMax{get;set;}
    public decimal formulaCreditAvailable{get;set;}
    public decimal ApplMonthlyExpenses{get;set;}
    public decimal EstMonthlyPAY{get;set;}
    public decimal formulaCostOfLoan{get;set;}
    public string strDocCurrentDate{get;set;}
    public string formulaCurrentDate{get;set;}
    public Decimal SumofAppMonthlyExp{get;set;}
    public Decimal strTotalCostofLoan{get;set;}
    public decimal strOLIApplFee{get;set;}
    public string AssesmentDate{get;set;}
    public Decimal strProd2LegalFee{get;set;}
    public Decimal strOLIAnnualFee;
    public string Prod2AnnualFee;
    public Decimal Prod2MonthlyFee;
    public string strOLIProd2Monthlyfee;
    public string strCurrentLender{get;set;}
    public Decimal decLVRApplFee{get;set;}
    public Decimal decLVRLegalFee{get;set;}
    public Decimal decLVRAnnualFee{get;set;}
    public Decimal decLVRMonthlyFee{get;set;}
    
    
    public Map<String,String> MapOfFundingPos {get;set;}
    public  String labelname{get;set;}
  //  public integer intageFormula;
    public List<Opportunity> lstOpp{get;set;}
    public Id OpportunityId{get;set;}
    public Id CurrentUserId{get;set;}
    public List<Product2> lstProduct{get;set;}
    public List<LVR_Rate__c> lstLVRRate{get;set;}
    public List<OpportunityLineItem> lstOLI{get;set;}
    public List<click_Applicant__c> lstApplicant{get;set;}
    public List<Funding_Position_Detail__c> lstFPD{get;set;}
    public List<Asset_And_Liability__c> lstAssetLiab{get;set;}
    public List<Income_And_Expense__c> lstIncomeExpense{get;set;}
    public map<string,list<string>> mapFPD{get;set;}
    public Map<String,String> MapOfIncomeandExpense{get;set;}
    public Map<String,List<String>> mapFundingPosDetail{get;set;}
    public List<string> listFieldName{get;set;}
    public List<String> listAssetLiabFieldName{get;set;}
    public Map<String,list<string>> mapAssetLiab{get;set;}
    public List<string> listIncomeExpensesFieldName{get;set;}
    public Map<String,List<string>> mapIncomeExpense{get;set;}
    public map<id,Decimal> mapOliIDToTotalCostLoan{get;set;}
    public map<id,Integer> mapAppIDToApplicantAge{get;set;}
    public map<id,Decimal> mapOliIDToTotalRepayment{get;set;}
    public map<id,Decimal> mapOliIDToLoanAmt{get;set;}
    public map<Id,string> mapOliTDToLoanRequest{get;set;}
    public map<Id,Decimal> mapProd2IDToApplFee{get;set;}
    public map<Id,Decimal> mapProd2IdToLegalFee{get;set;}
    public map<Id,Decimal> mapProd2IdToAnnualFee{get;set;}
    public map<Id,Decimal> mapProd2IdToMonthlyFee{get;set;}
        
    public Date date1;
    public Date date2;
 
    public String strDOB;
    public string myDate;
    
    public list<wrapFPDetails> lstWrapFPDetails {get;set;} 
    public list<wrapFPDetails> lstWrapALDetails {get;set;}
    public List<wrapFPDetails> lstWrapQuestion {get;set;}
    
    public Opportunity objOpp{get;set;}
    
    public CreditProposalDisclosureController()
    {
        mapOliIDToTotalCostLoan = new map<id,Decimal>();
        mapAppIDToApplicantAge  = new map<id,Integer>();
        mapOliIDToTotalRepayment = new map<id,Decimal>();
        mapOliIDToLoanAmt = new map<Id,Decimal>();
        mapOliTDToLoanRequest = new map<Id,string>();
        mapProd2IDToApplFee = new map<Id,Decimal>();
        mapProd2IdToLegalFee = new map<Id,Decimal>();
        mapProd2IdToAnnualFee = new map<Id,Decimal>();
        mapProd2IdToMonthlyFee = new map<Id,Decimal>();
        
        OpportunityId = ApexPages.currentPage().getParameters().get('id');
        system.debug('OpportunityId -----'+OpportunityId);
        strCurrentLender = '';
        strDocCurrentDate = '';
        OppAmount = 0;
        FundingPosLMI = 0;
        formulaTotalFee = 0;
        formulaCreditAvailable = 0;
        strAclHolder = '';
        EstMonthlyPAY = 0;
        strAclAddress = '';
        strAclLicenceNo = '';
        strAccountAddress = '';
        OLILoanAmt = 0;
        OLIRepayment = 0;
        strOLILoanTerm = '';
        OLIRate = 0;
        strOLIPaymentType = '';
        strOLILender = '';
        strOLIProdName = '';
        strTotalCostofLoan = 0;
        strProd2LegalFee = 0;
        strOLIAnnualFee = 0;
        Prod2MonthlyFee = 0;
        decLVRApplFee = 0;
        decLVRLegalFee = 0;
        decLVRAnnualFee = 0;
        decLVRMonthlyFee = 0;
        
        
        lstOpp = new List<Opportunity>();
        if(OpportunityId != null)
        {
        
            lstOpp = [SELECT  Name,Amount,Sum_Estimated_MonthlyPayment__c,Current_Lender__c,acfDate_Docs_Generated__c,Current_Assigned_Broker__c,Account.acfWhat_is_your_postcode__pc,CurrentAssignedBroker__r.ACL_Address__c,
                      CurrentAssignedBroker__r.Name ,CurrentAssignedBroker__r.Email__c ,CurrentAssignedBroker__r.Channel__c,
                      CurrentAssignedBroker__r.MobilePhone__c,Account.Recordtypeid,Product_Name__c,CurrentAssignedBroker__r.ACL_Licence__c,CurrentAssignedBroker__r.Representative_Email__c,
                      CurrentAssignedBroker__r.ACL_EDR_Membership_No__c,CurrentAssignedBroker__r.ACL_EDR_Scheme__c,CurrentAssignedBroker__r.ACL_Email__c,CurrentAssignedBroker__r.ACL_Holder__c,
                      CurrentAssignedBroker__r.ACL_Phone__c,CurrentAssignedBroker__r.ACR__c,CurrentAssignedBroker__r.Representative_Business_Address__c,
                      CurrentAssignedBroker__r.ACR_EDR_Membership_No__c,CurrentAssignedBroker__r.ACR_EDR_Expiry__c,CurrentAssignedBroker__r.ACR_EDR_Scheme_Name__c,acfWhy_are_you_refinancing__c,
                      How_long_do_you_expect_to_remain_in_the__c,Loan_Repayment_Type_being_Considered__c,Primary_purpose_for_seeking_credit__c,Past_legal_issues_re_credit_contracts__c,
                      Past_legal_issues_details__c,Current_credit_commitments_up_to_date__c,Current_credit_commitments_plan__c,Concerned_about_rising_interest_rates__c,
                      Would_you_consider_taking_a_fixed_rate_l__c,Rate_your_current_job_security__c,Adequate_insurance__c,Insurance_Referral__c,Extra_Repayments__c,Loan_Redraw__c,
                      Offset_Account__c,Portability__c,Multiple_Account_Splits__c,Line_of_Credit_Option__c,Fixed_Rate_Option__c,Loan_Variations__c,Access_to_Lender_Branch__c,
                      Access_to_Fee_Free_ATM_transactions__c,Cheque_Book_linked_to_loan_or_offset_acc__c,Internet_Banking_Access__c,Foreseeable_changes_in_Expenses__c,
                      Other_Factors_affecting_Income_Expenses__c,Foreseeable_changes_in_Income__c,
                      (select PricebookEntry.Product2.Name,Click_Tenure__c,click_Loan_Amount__c,acfRate__c,click_Type__c,Click_Estimated_Monthly_Payment__c,
                      acfApplication_Fee__c,acfLegal_Fees__c,lender__c from OpportunityLineItems ORDER BY createddate Desc Limit 1),
                      (select Name,Opportunity__c,Opportunity__r.Name,LMI__c,Borrower_Contributions__c,Client_Legal_Fees__c,First_Home_Owner_Concessions_and_Grants__c,
                      Funds_Requested__c,Funds_Requested_Inc_LMI__c,Funds_Required__c,Lender_Set_Up_Fees__c,
                      Net_Surplus__c,Other_Sundries__c,Summary_From_Details__c,Opportunity_Name__c from Funding_Positions__r ORDER BY CreatedDate ASC LIMIT 1),
                      (select id,name,Creditor__c,Value__c,Limit__c,Current_Balance__c,Used_as_Security__c,To_Be_Purchased__c,Clearing_From_This_Loan__c,Street_Number__c,Street_Name__c 
                       from Asset_And_Liabilities__r),
                      (SELECT Name,acf_applicant_DOB__c,Applicant_Email__c FROM Applicants__r),
                      (SELECT id,Category__c,Amount__c,name,recordtype.name from IncomeAndExpenses__r)
                       FROM Opportunity where id =: OpportunityId];
             
            lstProduct = new List<Product2>();
                lstProduct = [SELECT Id,Name,acfApplication_Fee__c,acfLegal_Fees__c,Upfront_Commission__c,Trailing_Commission__c,Annual_Fee__c,Monthly_Fee__c 
                              FROM Product2 WHERE Id IN (SELECT Product2Id FROM OpportunityLineItem where OpportunityId =:OpportunityId) ORDER BY CreatedDate ASC];
                
                set<Id> setFPD = new Set<Id>();
                
           lstLVRRate = new List<LVR_Rate__c>();
               lstLVRRate = [SELECT id,acfAnnual_Fees__c,acfEstablishment_Fee__c,acfLegal_Fees__c,acfMonthly_Fees__c,
                             (select id,Click_Loans_LVR_Rate__c,PricebookEntry.Product2.Name 
                             FROM Opportunity_Product__r 
                             where OpportunityId =: OpportunityId) from LVR_Rate__c ORDER BY CreatedDate ASC];     
            system.debug('lvrrrrrr'+lstLVRRate);
            
            lstFPD = new List<Funding_Position_Detail__c>();    
                lstFPD = [select Amount__c,Category__c,CreatedDate,Detail_Type__c,Name,id, Funding_Position__r.name,Funding_Position__r.Opportunity__c
                         from Funding_Position_Detail__c where Funding_Position__r.Opportunity__c=:OpportunityId];  
                if(lstFPD.size() > 0 && lstFPD != null)
                {
                    for(Funding_Position_Detail__c objFPD : lstFPD)
                    {
                        setFPD.add(objFPD.id);        
                    }
                }
                system.debug('setFPD----'+setFPD);
        
                mapFPD = new map<string,list<string>>();
                if(setFPD != null && setFPD.size() > 0)
                    mapFPD = clickcommon.mapLabelToFieldValueFP('FSofFPD','Funding_Position_Detail__c',setFPD);
                system.debug('mapFPD----'+mapFPD);
                string typeFPD = 'Funding_Position_Detail__c';
                Map<String, Schema.SObjectType> schemaMapFPD = Schema.getGlobalDescribe();
                Schema.SObjectType FPDSchema = schemaMapFPD.get(typeFPD); 
                Map<String, Schema.SObjectField> fieldLabelMapFPD = FPDSchema.getDescribe().fields.getMap();
                listFieldName = new list<string>();
                list<string> tempFPDApiNames = new list<string>();
                tempFPDApiNames = clickcommon.getlstFieldApiNames('FSofFPD','Funding_Position_Detail__c');
                string strLabelName = '';
                if(tempFPDApiNames != null && !tempFPDApiNames.IsEmpty())
                {
                    for(string apiname : tempFPDApiNames)
                    {
                        strLabelName = fieldLabelMapFPD.get(apiName).getDescribe().getLabel(); 
                        listFieldName.add(strLabelName); 
                    }
                }
                if(setFPD != null && setFPD.size() > 0 && tempFPDApiNames != null && tempFPDApiNames.size() > 0)         
                    mapFundingPosDetail =  clickcommon.mapLabelToFieldValue('FSofFPD','Funding_Position_Detail__c',setFPD,tempFPDApiNames);         
           
           lstApplicant = new List<click_Applicant__c>();                         
                lstApplicant = [SELECT Id,acf_Applicant_Name__c,clickApp_1_Monthly_Expenses__c,acf_applicant_DOB__c,Applicant_Email__c,clickOpportunity__c from click_Applicant__c where clickOpportunity__c =:OpportunityId];
                system.debug('lstApplicant$$$$' +lstApplicant +'lstApplicantsize'+lstApplicant.size());       
                map<ID,string>  MapIdtoFundingPos = new map<ID,string>();
                String type ='Funding_Position__c';
                String fpvalue;
                set<string> setFPApiNames = new set<string>();
                setFPApiNames.add('Name');
                setFPApiNames.add('Opportunity_Name__c');
                setFPApiNames.add('LMI__c');
                setFPApiNames.add('Borrower_Contributions__c');
                setFPApiNames.add('Client_Legal_Fees__c');
                setFPApiNames.add('First_Home_Owner_Concessions_and_Grants__c');
                setFPApiNames.add('Funds_Requested__c');
                setFPApiNames.add('Funds_Requested_Inc_LMI__c');
                setFPApiNames.add('Funds_Required__c');
                setFPApiNames.add('Lender_Set_Up_Fees__c');
                setFPApiNames.add('Net_Surplus__c');
                setFPApiNames.add('Other_Sundries__c');
                setFPApiNames.add('Summary_From_Details__c');
             // setFPApiNames.add('Opportunity__c');
                
                

                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType FundingPosSchema = schemaMap.get(type); 
                Map<String, Schema.SObjectField> fieldLabelMap = FundingPosSchema.getDescribe().fields.getMap();
                lstWrapFPDetails = new list<wrapFPDetails>();   
                if(lstOpp.size()>0)
                {
                if(lstOpp[0].Funding_Positions__r != null && !lstOpp[0].Funding_Positions__r.isEmpty() && lstOpp[0] != null )
                {
                  for(string apiname : setFPApiNames)
                  {
                      if(apiname <> null && apiname <> '')
                      {     
                           String fundpos = string.valueof(lstOpp[0].Funding_Positions__r[0].get(apiName));
                         // String apivalue = '';
                          wrapFPDetails objwrapFPDetails = new wrapFPDetails();
                          objwrapFPDetails.strFPLabel = fieldLabelMap.get(apiName).getDescribe().getLabel(); 
                           if(apiname == 'LMI__c' || apiname == 'Borrower_Contributions__c' || apiname =='Client_Legal_Fees__c' || apiname== 'First_Home_Owner_Concessions_and_Grants__c' ||
                                apiname == 'Funds_Requested__c' || apiname == 'Funds_Requested_Inc_LMI__c' || apiname == 'Funds_Required__c' || apiname=='Lender_Set_Up_Fees__c' ||
                                apiname == 'Net_Surplus__c' || apiname == 'Other_Sundries__c' || apiname == 'Summary_From_Details__c' )
                           {
                           String strfp = (Decimal.valueOf(fundpos==null||fundpos.trim()==''?'0':fundpos).setScale(2)).format();
                              objwrapFPDetails.strFPValue = '$' +strfp;    
                           }
                           else {
                          objwrapFPDetails.strFPValue = string.valueof(lstOpp[0].Funding_Positions__r[0].get(apiName));
                          }
                          lstWrapFPDetails.add(objwrapFPDetails);
                      }
                  } 
                }
                }
                //String ALvalue;
                String typeAL ='Asset_And_Liability__c';
                set<string> setAssetLiabApiNames = new set<string>();
                setAssetLiabApiNames.add('name');
                setAssetLiabApiNames.add('Creditor__c');
                setAssetLiabApiNames.add('Value__c');
                setAssetLiabApiNames.add('Limit__c');
                setAssetLiabApiNames.add('Current_Balance__c');
                setAssetLiabApiNames.add('Used_as_Security__c');
                setAssetLiabApiNames.add('To_Be_Purchased__c');
                setAssetLiabApiNames.add('Clearing_From_This_Loan__c');
               // setAssetLiabApiNames.add('Street_Number__c');
               // setAssetLiabApiNames.add('Street_Name__c');
                setAssetLiabApiNames.add('Desciption__c');
                setAssetLiabApiNames.add('Type__c');

                Map<String, Schema.SObjectType> schemaMapAssetLiab = Schema.getGlobalDescribe();
                Schema.SObjectType AssetLiabSchema = schemaMapAssetLiab.get(typeAL); 
                Map<String, Schema.SObjectField> fieldLabelMapAssetLiab = AssetLiabSchema.getDescribe().fields.getMap();
                lstAssetLiab = new list<Asset_And_Liability__c>(); 
                lstWrapALDetails = new List<wrapFPDetails>();
                lstAssetLiab = [select name,Creditor__c,Value__c,Desciption__c,Type__c,Opportunity__c,Limit__c,Current_Balance__c,Used_as_Security__c,To_Be_Purchased__c,Clearing_From_This_Loan__c,Street_Number__c,Street_Name__c from Asset_And_Liability__c where  Opportunity__c =: OpportunityId ];
        
                if(lstAssetLiab !=null && !lstAssetLiab.isEmpty())
                {
                    for(String ALapiname : setAssetLiabApiNames)
                    {   
                        wrapFPDetails objwrapALDetails = new wrapFPDetails();
                        if(ALapiname <> null && ALapiname <> '')
                        {    
                            objwrapALDetails.strALlabel = fieldLabelMapAssetLiab.get(ALapiname).getDescribe().getLabel();
                        }
                        for(Asset_And_Liability__c objAssetLiab : lstAssetLiab)
                        {
                            objwrapALDetails.strALValue = string.valueOf(objAssetLiab.get(ALapiname)); 
                            lstWrapALDetails.add(objwrapALDetails);  
                            system.debug('--AssetLialstWrapFPDetails---'+lstWrapALDetails);
                        }
                    }                  
                 }

                string typeAssetLiab = 'Asset_And_Liability__c';
                Map<String, Schema.SObjectType> schemaMapAssetLiability = Schema.getGlobalDescribe();
                Schema.SObjectType AssetLiabilitySchema = schemaMapAssetLiability.get(typeAssetLiab); 
                Map<String, Schema.SObjectField> fieldLabelMapAssetLiability = AssetLiabilitySchema.getDescribe().fields.getMap();
                listAssetLiabFieldName = new list<string>();
                list<string> AssetLiabApiNames = new list<string>();
                AssetLiabApiNames = clickcommon.getlstFieldApiNames('FSAssetLiab','Asset_And_Liability__c');
                string strAssetLabelName = '';
                for(string apiname : AssetLiabApiNames)
                {
                    strAssetLabelName = fieldLabelMapAssetLiability.get(apiName).getDescribe().getLabel(); 
                    listAssetLiabFieldName.add(strAssetLabelName); 
                }
          
                Set<Id> strAssetLiab = new Set<Id>();  
                if(lstAssetLiab.size() > 0 && lstAssetLiab != null)
                {
                    for(Asset_And_Liability__c objAssetLiab : lstAssetLiab)
                    {
                        strAssetLiab.add(objAssetLiab.id);        
                    }
                }
                if(strAssetLiab != null && strAssetLiab.size() > 0 && AssetLiabApiNames != null && AssetLiabApiNames.size() > 0)         
                    mapAssetLiab = Clickcommon.mapLabelToFieldValue('FSAssetLiab','Asset_And_Liability__c',strAssetLiab,AssetLiabApiNames); 
                system.debug('mapAssetLiab-----'+mapAssetLiab) ;   
                
                lstIncomeExpense = new List<Income_And_Expense__c>();
                lstIncomeExpense = [select Opportunity__c,Category__c,Amount__c,name,recordtype.name,Record_Type__c from Income_And_Expense__c where Opportunity__c =: OpportunityId];
                labelname = '';
                String typeIE = 'Income_And_Expense__c';
                Map<String, Schema.SObjectType> schemaMapIE = Schema.getGlobalDescribe();
                MapOfIncomeandExpense = new Map<String,String>();
                Schema.SObjectType IncomeExpSchema = schemaMapIE.get(typeIE); 
                Map<String, Schema.SObjectField> fieldLabelMapIE = IncomeExpSchema.getDescribe().fields.getMap();
                listIncomeExpensesFieldName = new list<string>();
                list<string> IncomeExpenseApiNames = new list<string>();
                IncomeExpenseApiNames = clickcommon.getlstFieldApiNames('FSIncomeExpense','Income_And_Expense__c');
                string strIncomeExpenseName = '';
                if(IncomeExpenseApiNames != null && !IncomeExpenseApiNames.IsEmpty())
                {
                    for(string apiname : IncomeExpenseApiNames)
                    {
                        strIncomeExpenseName = fieldLabelMapIE.get(apiName).getDescribe().getLabel(); 
                        listIncomeExpensesFieldName.add(strIncomeExpenseName); 
                    }   
                } 
                Set<Id> setIncomeExp = new Set<Id>();  
                if(lstIncomeExpense.size() > 0 && lstIncomeExpense != null)
                {
                    for(Income_And_Expense__c objIncomeExp : lstIncomeExpense)
                    {
                        setIncomeExp.add(objIncomeExp.id);        
                    }
                }  
                if(setIncomeExp != null && setIncomeExp.size() > 0 && IncomeExpenseApiNames != null && !IncomeExpenseApiNames.IsEmpty())       
                    mapIncomeExpense = Clickcommon.mapLabelToFieldValue('FSIncomeExpense','Income_And_Expense__c',setIncomeExp,IncomeExpenseApiNames);
                        system.debug('hoolamap' +mapIncomeExpense);
                for (String fieldName: fieldLabelMapIE.keySet())
                {
                   System.debug('##Field API Name='+fieldName);// list of all field API name
                   labelname = fieldLabelMapIE.get(fieldName).getDescribe().getLabel();    //It provides to get the object fields label.
                   MapOfIncomeandExpense.put(labelname,typeIE);          
                   system.debug('labelname---'+labelname);
                }
           
                String objectName = 'Opportunity';
                SumofAppMonthlyExp=0;
                strApplicantName ='';
                if(lstApplicant != null && lstApplicant.size() > 0)
                {
                    strApplicantName   = strApplicantName  +  lstApplicant[0].acf_Applicant_Name__c  +' and '  ;
                    for(click_Applicant__c objApp : lstApplicant)
                    {
                        if(objApp.acf_applicant_DOB__c != null)
                        {
                        strDOB  =  objApp.acf_applicant_DOB__c;
                        date1 = Date.parse(strDOB);
                        date2 = Date.today();
                        decApplicantAge = (date1.daysBetween(date2)/365);
                        }
                        if(decApplicantAge != null)
                            mapAppIDToApplicantAge.put(objApp.Id,decApplicantAge);
                        system.debug('###123'+mapAppIDToApplicantAge);
                        
                        String strSumMonthlyExp = null;
                        if(objApp.clickApp_1_Monthly_Expenses__c != null)
                        {
                        SumofAppMonthlyExp += (objApp.clickApp_1_Monthly_Expenses__c).setScale(2);
                       }  
                    }              
                }
                if(strApplicantName != '' && strApplicantName !=null)
                {
                strApplicantName = strApplicantName.substring(0,strApplicantName.lastindexof('and'));
                }
                if(lstOpp !=null && lstOpp.size() > 0){
                    strAclHolder       =    lstOpp[0].CurrentAssignedBroker__r.ACL_Holder__c;
                    strAclAddress      =    lstOpp[0].CurrentAssignedBroker__r.ACL_Address__c;
                    strAclLicenceNo    =    lstOpp[0].CurrentAssignedBroker__r.ACL_Licence__c;
                    strProdName        =    lstOpp[0].Product_Name__c;
                    if(lstOpp[0].Current_Lender__c !=null)
                    {
                    strCurrentLender   =    lstOpp[0].Current_Lender__c;
                    }
                    OppAmount          =   lstOpp[0].Amount;
                    
                   /* if(OppAmount !=null)
                    {
                   // String strOppamt =  Decimal.valueOf(OppAmount==null||OppAmount.trim()==''?'0':OppAmount).setScale(2).format(); 
                    OppAmount = Decimal.valueOf('$' +OppAmount);
                    } */
                    strAccountAddress  =    lstOpp[0].Account.acfWhat_is_your_postcode__pc;
                    strDocCurrentDate  =   (String.valueOf(lstOpp[0].acfDate_Docs_Generated__c));
                    
                    if(strDocCurrentDate != null)
                    {
                        String strdate = string.valueOf(strDocCurrentDate);
                        AssesmentDate = date.valueOf(strdate).format();
                    }
                    if(strDocCurrentDate <> null)
                     formulaCurrentDate = (Date.ValueOf(strDocCurrentDate)+90).format();
                    EstMonthlyPAY      =   (lstOpp[0].Sum_Estimated_MonthlyPayment__c);

                    lstOLI = new List<OpportunityLineItem>();
                    lstOLI = [select id,Product2.Name,PricebookEntry.Product2.Name,PricebookEntry.Product2.acfApplication_Fee__c,Click_Loans_LVR_Rate__r.acfEstablishment_Fee__c,Click_Loans_LVR_Rate__r.acfLegal_Fees__c,PricebookEntry.Product2.acfLegal_Fees__c,
                              PricebookEntry.Product2.Annual_Fee__c,PricebookEntry.Product2.Monthly_Fee__c,PricebookEntry.Name,click_Loan_Amount__c,click_Type__c,Click_Loans_LVR_Rate__r.acfMonthly_Fees__c,Click_Loans_LVR_Rate__r.acfAnnual_Fees__c,
                              Click_Estimated_Monthly_Payment__c,Click_Tenure__c,acfRate__c,lender__c,OpportunityId from OpportunityLineItem where OpportunityId =: OpportunityId ORDER BY CreatedDate DESC]; 
                              system.debug('lstOLI********************'+lstOLI);        
                 } 
                 strOLIApplFee = 0;
                 Prod2AnnualFee = '';
                 strOLIProd2Monthlyfee = '';
               
               if(lstOLI !=null && !lstOLI.Isempty())
               {     
                   for(OpportunityLineItem objOLI : lstOLI)
                     {     
                         if(objOLI.click_Loan_Amount__c != null)
                         {
                          OLILoanAmt      = objOLI.click_Loan_Amount__c;
                          }
                        //  String loanamt = (Decimal.valueOf(OLILoanAmt==null||OLILoanAmt.trim()==''?'0':OLILoanAmt)).setScale(2).format();
                        //  OLILoanAmt = '$' +loanamt;
                          if(objOli.Click_Estimated_Monthly_Payment__c != null)
                              OLIRepayment  = objOli.Click_Estimated_Monthly_Payment__c;                          
                          system.debug('repayy'+OLIRepayment);
                          if(objOLI.Click_Tenure__c != null)
                              strOLILoanTerm  = objOLI.Click_Tenure__c;
                          if(objOLI.acfRate__c != null)
                              OLIRate         = objOLI.acfRate__c;
                          if(objOLI.click_Type__c != null)
                              strOLIPaymentType = objOLI.click_Type__c;
                          strOLILender    = objOLI.lender__c;
                          strOLIProdName  = objOLI.Product2.Name;
                          if(objOLI.Click_Loans_LVR_Rate__c!= null && objOLI.Click_Loans_LVR_Rate__r.acfEstablishment_Fee__c != null)
                          {
                             // strOLIApplFee   = objOLI.PricebookEntry.Product2.acfApplication_Fee__c;
                              strOLIApplFee = objOLI.Click_Loans_LVR_Rate__r.acfEstablishment_Fee__c;
                          }
                          if(objOLI.Click_Loans_LVR_Rate__c != null && objOLI.Click_Loans_LVR_Rate__r.acfAnnual_Fees__c != null)
                          {
                              strOLIAnnualFee = objOLI.Click_Loans_LVR_Rate__r.acfAnnual_Fees__c;
                          }
                          if(objOLI.Click_Loans_LVR_Rate__c != null && objOLI.Click_Loans_LVR_Rate__r.acfMonthly_Fees__c != null)
                          {
                              Prod2MonthlyFee = objOLI.Click_Loans_LVR_Rate__r.acfMonthly_Fees__c;
                          }
                          if(objOLI.Click_Loans_LVR_Rate__c != null &&  objOLI.Click_Loans_LVR_Rate__r.acfLegal_Fees__c != null)
                          {
                              strProd2LegalFee = objOLI.Click_Loans_LVR_Rate__r.acfLegal_Fees__c;
                          }
                          if(strOLIApplFee != null && objOLI <> null)
                          {
                               mapProd2IDToApplFee.put(objOLI.Id,strOLIApplFee);
                               system.debug('maplvr----'+mapProd2IDToApplFee);
                          }
                          if(strProd2LegalFee != null)
                              mapProd2IdToLegalFee.put(objOLI.Id,strProd2LegalFee);
                          if(strOLIAnnualFee != null)
                              mapProd2IdToAnnualFee.put(objOLI.id,strOLIAnnualFee);
                          if(Prod2MonthlyFee != null)
                              mapProd2IdToMonthlyFee.put(objOLI.id,Prod2MonthlyFee); 
                          if(OLIRepayment != null)
                              mapOliIDToTotalRepayment.put(objOLI.id,OLIRepayment);
                          if(OLILoanAmt != null)
                              mapOliIDToLoanAmt.put(objOLI.id,OLILoanAmt);
                              system.debug('map--oli--' +mapOliIDToLoanAmt);
                          if(objOLI.Click_Estimated_Monthly_Payment__c != null && objOLI.Click_Tenure__c != null)
                           {
                             // formulaCostOfLoan =  objOLI.Click_Estimated_Monthly_Payment__c * 12 * Decimal.valueOf(objOLI.Click_Tenure__c);
                            //  system.debug('FormlaCostofLoan-----'+formulaCostOfLoan );                    
                              strTotalCostofLoan = objOLI.Click_Estimated_Monthly_Payment__c * 12 * Decimal.ValueOf(objOLI.Click_Tenure__c);
                              system.debug('TotalCostofLoan-----'+strTotalCostofLoan);     
                           }
                          if(strTotalCostofLoan != null)
                              {
                                  mapOliIDToTotalCostLoan.put(objOLI.id,strTotalCostofLoan);
                                  system.debug('mapTotalCostLoan-----'+mapOliIDToTotalCostLoan);
                              }
                     }
                }  
       
              for(Product2 objProduct : lstProduct)
              {
                  
                  if(objProduct.acfApplication_Fee__c != null)
                  {
                       Product2ApplFee = 0;
                       Product2ApplFee  = objProduct.acfApplication_Fee__c;
                  }
                  if(objProduct.acfLegal_Fees__c != null)
                  {
                       Product2LegalFee = 0;
                       Product2LegalFee = objProduct.acfLegal_Fees__c;
                        
                  }  
                  if(objProduct.Trailing_Commission__c != null)
                  {
                    Product2TC  = objProduct.Trailing_Commission__c;
                  }
                  if(objProduct.Upfront_Commission__c != null)
                  {
                    Product2UFC      = objProduct.Upfront_Commission__c;
                  }
                  if(objProduct.Annual_Fee__c != null)
                  {
                    Product2AnnualFee = objProduct.Annual_Fee__c;
                  }
                  if(objProduct.Monthly_Fee__c != null)
                  {
                    Product2Monthlyfee =  objProduct.Monthly_Fee__c;
                  }
              }
              
             if(!lstOpp[0].Funding_Positions__r.isEmpty() &&  lstOpp[0].Funding_Positions__r[0].LMI__c != null)
                {
                  FundingPosLMI  =  lstOpp[0].Funding_Positions__r[0].LMI__c;
                }
            
             if(lstOLI !=null && !lstOLI.Isempty())
               {     
                for(OpportunityLineItem objOLI : lstOLI)
                  {       
                  if(lstLVRRate !=null && lstLVRRate.size()>0 && lstOpp.size()>0)
                  {
                    for(LVR_Rate__c objLVRate : lstLVRRate)          
                    {
                       if(objLVRate != null && objLVRate.acfEstablishment_Fee__c != null)
                       {
                       
                         decLVRApplFee = objLVRate.acfEstablishment_Fee__c;
                        
                       }   
                       
                       if(objLVRate != null && objLVRate.acfLegal_Fees__c!= null)
                       {
                          decLVRLegalFee = objLVRate.acfLegal_Fees__c;
                       }
                       
                       if(objLVRate != null && objLVRate.acfAnnual_Fees__c != null)
                       {
                          decLVRAnnualFee = objLVRate.acfAnnual_Fees__c;
                       }
                       
                       if(objLVRate != null && objLVRate.acfMonthly_Fees__c != null)
                       {
                          decLVRMonthlyFee = objLVRate.acfMonthly_Fees__c;
                       }
                        
                       if(decLVRApplFee !=null && FundingPosLMI !=null && decLVRLegalFee !=null)
                       {
                           formulaTotalFee    =   (decLVRApplFee + decLVRLegalFee + FundingPosLMI).setScale(2);  
     
                         formulaCreditAvailable = integer.valueOf(lstOpp[0].Amount) - integer.valueOf(formulaTotalFee);  
                        }             
                      } 
                }
              }
             } 
             
            if(lstOpp.size()>0)
            {
            if(lstOpp[0].CurrentAssignedBroker__r != null)
             { 
             
             strBrokerFullName  =    lstOpp[0].CurrentAssignedBroker__r.Name;
             strBrokerAddress   =    lstOpp[0].CurrentAssignedBroker__r.Representative_Business_Address__c;
             strBrokerEmail     =    lstOpp[0].CurrentAssignedBroker__r.Email__c;
             strBrokerPhone     =    lstOpp[0].CurrentAssignedBroker__r.ACL_Phone__c;
             strBrokerRepsEmail =    lstOpp[0].CurrentAssignedBroker__r.Representative_Email__c;
             strBrokerCRNo      =    lstOpp[0].CurrentAssignedBroker__r.ACR__c;
             strBrokerMob       =    lstOpp[0].CurrentAssignedBroker__r.MobilePhone__c;
             strBrokerEDR       =    lstOpp[0].CurrentAssignedBroker__r.ACR_EDR_Scheme_Name__c;
             BrokerACLMemberNo  =    lstOpp[0].CurrentAssignedBroker__r.ACL_EDR_Membership_No__c;
             BrokerACRMemberNo  =    lstOpp[0].CurrentAssignedBroker__r.ACR_EDR_Membership_No__c;
             } 
             
             system.debug('Funding Pos---' +lstOpp[0].Funding_Positions__r);  
          /*   if(!lstOpp[0].Funding_Positions__r.isEmpty() &&  lstOpp[0].Funding_Positions__r[0].LMI__c != null)
             {
             FundingPosLMI      =    lstOpp[0].Funding_Positions__r[0].LMI__c;
             }
             
             */
             system.debug('Applicant data---' +lstOpp[0].Applicants__r);

             strBrokerACLEmail  =    lstOpp[0].CurrentAssignedBroker__r.ACL_Email__c;    
             strBrokerRepEmail  =    lstOpp[0].CurrentAssignedBroker__r.Representative_Email__c;
              
              if(Product2TC != null)
              {
             Produt2TCRatePm = (Product2TC/12).setScale(2); 
             formulaTCpm           =  ((Product2TC * lstOpp[0].Amount)/12).setScale(2);
             }
             if(Product2UFC != null)
             {
             formulaUFC            =  (Product2UFC * lstOpp[0].Amount).setScale(2);
             formulaPartnerCommMin = (formulaUFC * 0.45).setScale(2);
             formulaPartnerCommMax = (formulaUFC * 0.85).setScale(2); 
             }
                
            // strProduct2Name    =  lstProduct[1].Name;  
            
            system.debug('lstProduct####'+lstProduct);
            system.debug('###123'+FundingPosLMI);
            system.debug('###'+formulaTotalFee);
            system.debug('###'+OppAmount);
            system.debug('###'+formulaCreditAvailable );
            
         /*   Decimal strProdAppFee = 0;
            Decimal strProdLegalFee = 0;
            Decimal strFundingPosLMI =0;
            if(lstLVRRate !=null && lstLVRRate.size() > 0){
                for(Product2 objProduct : lstProduct){
                 if(objProduct.acfApplication_Fee__c !=null && FundingPosLMI !=null && objProduct.acfLegal_Fees__c !=null)
                  {
                   strProdAppFee = objProduct.acfApplication_Fee__c;
                   strProdLegalFee = objProduct.acfLegal_Fees__c;
                   strFundingPosLMI = FundingPosLMI;
                   
                   if(strFundingPosLMI != null && strProdLegalFee !=null && strProdAppFee !=null)
                    {
                     formulaTotalFee    =   (objProduct.acfApplication_Fee__c + objProduct.acfLegal_Fees__c + FundingPosLMI).setScale(2);  
                   
                 //  String strTotalfeeProd = ( Decimal.valueOf(apivalue==null||apivalue.trim()==''?'0':apivalue).setScale(2)).format(); 

                     formulaCreditAvailable = integer.valueOf(lstOpp[0].Amount) - integer.valueOf(formulaTotalFee);  
                    }
                   }
                }
            }   */
       }
      } 
    }
    
  
     public class wrapFPDetails
     {
         public String strFPLabel {get;set;}
         public string strFPValue {get;set;}
         public string strALlabel {get;set;}
         public string strALValue {get;set;}  
     }
 }