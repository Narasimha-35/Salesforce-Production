global without sharing class BatchAddCallFileToOpportunity implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global BatchAddCallFileToOpportunity() {}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select o.Add_To_Call_File_Due_Day_Check__c, o.Current_Appointment_Type__c, o.vhc__CallFile__c, o.clickJumio_Status__c, o.clickJumioLast_Name__c, o.clickJumioFirstName__c, o.acf_Status__c, o.acf_Redraw__c, o.acf_Approval__c, o.acf_Approval_Conditions__c, o.acf_Application__c, o.acfValuation_Fee__c, o.acfTenure__c, o.acfStatus__c, o.acfRedraw__c, o.acfReason_for_Rejection__c, o.acfProduct_LVR__c, o.acfPayment_Type__c, o.acfOngoing_Fees__c, o.acfOffset_Account__c, o.acfMultiple_Splits__c, o.acfMultipleSplits__c, o.acfLVR_Id__c, o.acfIssuing_Country__c, o.acfIs_Identity_Document_Submitted__c, o.acfIs_Identity_Document_Rejected__c, o.acfInterest_Only__c, o.acfInterestOnly__c, o.acfID_Type__c, o.acfID_Number__c, o.acfExpiry_Date__c, o.acfExpected_Settlement_Date__c, o.acfEstimated_Savings__c, o.acfDebit_Card__c, o.acfDebitCard__c, o.acfDate_of_Birth__c, o.acfDate_Formally_Approved__c, o.acfDate_Docs_Generated__c, o.acfDate_Conditionally_Approved__c, o.acfCuurent_Rate__c, o.acfCurrent_Lender__c, o.acfCurrent_Interest_Rate_Type__c, o.acfCurrentLoanAmount__c, o.acfConditions_of_Approval__c, o.acfComparison_Rate__c, o.acfBankdetailStatus__c, o.acfBankNameForAccountDetails__c, o.acfApproval_Conditions__c, o.acfAdd_Repayments__c, o.acfAddRepayments__c, o.Vehicle_Price__c, o.Vehicle_Build_Year__c, o.Type, o.Transaction__c, o.Transaction_Type__c, o.Total_Rescheduled__c, o.Total_No_Show__c, o.Total_New__c, o.Total_Monthly_Expenses__c, o.Total_Liabilities__c, o.Total_Held__c, o.Total_Cancelled__c, o.Total_Assets__c, o.Total_Allocated__c, o.SystemModstamp, o.SyncedQuoteId, o.Stamp_Duty__c, o.StageName, o.RecordTypeId, o.Proposed_Repayments__c, o.Product_Name__c, o.Probability, o.Pricebook2Id, o.Pre_Sales_Notes__c, o.Post_conversion_opp__c, o.Personal_Loan_Balance__c, o.Partner_Income__c, o.OwnerId, o.Outside_of_Business_Rules__c, o.Number_of_Appointments__c, o.NextStep, o.Net_Payment__c, o.Net_Income_All_Applicants__c, o.Net_Expenses_All_Applicants__c, o.Net_Assets__c, o.Net_Amount_Financed__c, o.Name, o.Manager_Approved__c, o.Lead_Type__c, o.LeadToCallFileRule__c, o.LeadSource, o.Last_Refinance__c, o.LastViewedDate, o.LastReferencedDate, o.LastModifiedDate, o.LastModifiedById, o.LastActivityDate, o.IsWon, o.IsDeleted, o.IsClosed, o.Industry__c, o.Id, o.HasOpportunityLineItem, o.ForecastCategoryName, o.ForecastCategory, o.Fixed_Rate_Expiry__c, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.Finance_Payment__c, o.Employment_Status__c, o.Description, o.Current_Loan_Value__c, o.Current_Loan_Type__c, o.Current_Lender__c, o.Current_Interest_Rate__c, o.Current_Interest_Rate_Type__c, o.Current_Financials_Up_to_Date__c, o.Current_Assigned_Broker__c, o.Current_Appointment_Status__c, o.Credit_Card_Balance__c, o.CreatedDate, o.CreatedById, o.Co_Applicant__c, o.Closed_Lost_Reason__c, o.CloseDate, o.Car_Year__c, o.Car_Transmission__c, o.Car_Term__c, o.Car_Source_of_Goods__c, o.Car_Security_Registration_Fee__c, o.Car_Product__c, o.Car_Payment_Frequency__c, o.Car_Payment_Frequency_Quote__c, o.Car_Origination_Fee__c, o.Car_New_Used_Demo__c, o.Car_Model__c, o.Car_Make__c, o.Car_Loan_Value__c, o.Car_Loan_Balance__c, o.Car_Less_Deposit__c, o.Car_Lender__c, o.Car_Interest_Rate_Cust__c, o.Car_Insurance_Provider__c, o.Car_Insurance_Financed__c, o.Car_Insurance_Commission__c, o.Car_Goods_Use__c, o.Car_Goods_Use_Description__c, o.Car_Details__c, o.Car_Brokerage__c, o.Car_Brokerage_Finance_or_Overs__c, o.Car_Balloon__c, o.Car_Balloon_Quote__c, o.Car_Asset_Cost__c, o.Car_Application_Fee__c, o.Car_Applicant__c, o.Car_Advance_Arrears__c, o.Car_Admin_Fee__c, o.Car_Admin_Fee_Quote__c, o.Capacity__c, o.Capacity_Met__c, o.CampaignId, o.Call_File_Is_Updated__c, o.Asset_Liability_Statement__c, o.Annual_Income__c, o.Amount, o.Age_of_Current_Loan__c, o.Add_To_Call_File_Date__c, o.Account_Do_Not_Email__c, o.Account_Do_Not_Call__c, o.AccountId From Opportunity o where o.Call_File_Is_Updated__c != true and o.Add_To_Call_File_Due_Day_Check__c != true and o.Add_To_Call_File_Date__c = today limit 10000';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> oppos) {
        if (oppos != null && oppos.size() > 0) {
            List<Opportunity> opposNew = new List<Opportunity>();
            for (Opportunity oppo : oppos) {
                if (oppo.LeadToCallFileRule__c != null) {
                    //select the rule 
                    LeadToCallFileRule__c rule = LeadToCallFileDAO.getLeadToCallFileRuleById(oppo.LeadToCallFileRule__c);
                    boolean isFittedRule = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(oppo, rule);
                    System.debug('isFittedRule ' + isFittedRule);
                    if (isFittedRule) {
                    
                        oppo.vhc__CallFile__c = rule.Call_File__c;
                        oppo.Call_File_Is_Updated__c = true;
                        oppo.Add_To_Call_File_Due_Day_Check__c = true;
                        opposNew.add(oppo);
                        System.debug('oppo.vhc__CallFile__c ' + oppo.vhc__CallFile__c);
                        System.debug('oppo.Call_File_Is_Updated__c ' +  oppo.Call_File_Is_Updated__c);
                    }
                }
            }
            update opposNew;
            System.debug(opposNew.size());
        }
    }
    
    global void finish(Database.BatchableContext BC) { 
        /*List<Opportunity> oppos = [select Id from Opportunity where Call_File_Is_Updated__c != true and Add_To_Call_File_Date__c = today limit 1];
        if (oppos.size() > 0) {
            BatchAddCallFileToOpportunity job = new BatchAddCallFileToOpportunity();
            database.executebatch(job, 10);
        }*/
    }
}