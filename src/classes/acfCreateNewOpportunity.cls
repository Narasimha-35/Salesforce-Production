/*
    This class is used handle Clone New Opportunity logic.
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Prateek Kumar Gupta                                            1.0
    =============================================================================
*/

public class acfCreateNewOpportunity {
    public  Opportunity oppObj {get ;set;}
    String accountId;
    ID commId;
    public List<WrapperQuestions>lstMasterWrapperQuestion;
    public List<WrapperQuestions>lstWrapperQuestion{get;set;}
    public map<id,string> mapIdToAnswer;
    Integer             indexNo = 0;
    public String selectedLoanType{get;set;}
    public boolean  ShowPageBlock {get ;set;}
    public List<Click_Community_Setup__c> lstComm ;
    List<click_Applicant__c>  lstApplicant ;
    List<Asset_And_Liability__c>  lstAssets ;
    
      
    public acfCreateNewOpportunity(ApexPages.StandardController controller) 
    {
        oppObj = new Opportunity ();
        getOPPDetails();
    }
    
   
   
    // This method reset all wapper if the account lookup is changed.
    public void getNewAccountDetails(){
        List<Id> OppLts = new List<ID>();
        String  ConvertedOpportunityId ='';
        if  ( oppObj.accountid  != null)
        {
            accountId = oppObj.accountid;
            if(accountId != null )
            {                                    
                List<Account>  lstAcc = [select id,LastName,RecordTypeId,FirstName,PersonEmail,Click_Is_Phone_Broker_customer__c,PersonMobilePhone,
                                         Click_Community_Setup__c,IsMaster__c,SelfLookup__c,SelfLookup__r.Click_Community_Setup__c,(select id,Click_Community_Setup__c,
                                         SelfLookup__c from Accounts__r) ,(select id  from Opportunities ) from Account where id=:accountId ];
                if(lstAcc != null && !lstAcc.isEmpty() && lstAcc[0].Click_Community_Setup__c != null)
                {
                    oppObj.accountid =Id.valueof(accountId );
                    commId=lstAcc[0].Click_Community_Setup__c;
                    if(lstAcc[0].Opportunities  != null )
                    {
                        for(Opportunity Opp : lstAcc[0].Opportunities)
                        {
                            OppLts.add(opp.Id);
                        }
                    }
                }
            }
      
            lstApplicant = [SELECT ACf1_Current_employer_Start_Date__c,ACF1_Previous_Employer_Name0__c,ACF1_Previous_Employer_Name12__c,
                            ACF1_Previous_Employer_Name24__c,ACF1_Previous_Em_Start_Date0__c,ACF1_Previous_Em_Start_Date12__c,ACF1_Previous_Em_Start_Date24__c,
                            acfBusiness_Name_or_ABN_autofill__c,acfDependant1_Age__c,acfDependant2_Age__c,acfDependant3_Age__c,acfDependant4_Age__c,acfDependant5_Age__c,
                            acfEconsent_App2__c,acfEconsent__c,acfEmployment_Type__c,acfLast_2_years_Tax_Return_or_ATO_NOA__c,acf_ACf1_Current_employer_Start_Da__c,
                            acf_applicant_Annual_profit_income__c,acf_applicant_App_1_Monthly_Expenses__c,acf_applicant_Dependants__c,acf_applicant_DOB__c,
                            acf_applicant_Employer_Name__c,acf_applicant_Marital_Status__c,acf_applicant_Monthlly_Salary__c,acf_Applicant_Name__c,
                            acf_applicant_Residency_status__c,acf_appl_ACf2_Current_employer_Start_Da__c,acf_How_Long_have_you_been_employed__c,acf_How_Long__c,
                            Applicant_Email__c,Applicant_Phone__c,clickApp_1_Monthly_Expenses__c,clickMarried_To__c,clickOpportunity__c,click_Account__c,
                            click_Applicant_Number__c,CreatedById,CreatedDate,Current_Role__c,Id,IsDeleted,LastActivityDate,LastModifiedById,
                            LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,acf_create_from_custom_clone_button__C,
                            (SELECT acfDetails__c,Amount__c,Applicant__c,Asset_And_Liability__c,Category__c,Name FROM Income_And_Expenses__r )      
                            FROM click_Applicant__c where  click_Account__c = :accountId OR clickOpportunity__c  in : OppLts ] ;
            
            System.debug('QWERTY@@'+lstApplicant);
            lstAssets= [SELECT Account_Name__c,Account_Number__c,Account__c,Address__c,BSB__c,City__c,Clearing_From_This_Loan__c,Country__c,CreatedById,CreatedDate,Creditor__c,Credit_Card_Type__c,Current_Balance__c,Desciption__c,Evidence_of_Tenancy__c,Frequency__c,Gross_Amount__c,Id,Institution__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Limit__c,Name,Opportunity__c,Order__c,OwnerId,Postcode__c,Primary_Purpose__c,RecordTypeId,Rental_Income__c,Repayments__c,Repayment_Frequency__c,State__c,acf_create_from_custom_clone_button__C,
                        Street_Name__c,Street_Number__c,Street_Type__c,SystemModstamp,To_Be_Purchased__c,Type__c,Used_as_Security__c,Value_Basis__c,
                        Value__c,Vehicle_Make__c,Vehicle_Type__c,Vehicle_Year__c,Zoning__c,(SELECT acfDetails__c,Amount__c,Applicant__c,Asset_And_Liability__c,
                        Category__c,Name FROM Income_And_Expenses__r) FROM Asset_And_Liability__c where Account__c = : accountId OR
                         Opportunity__c  in : OppLts];
                        // making PreLogin Question.    
                        PreLoginQuestion();
        }
        else
        { 
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Please select account');
            apexpages.addmessage(msg);
        }   
    }
    // This method call on change of picklist value  and it creates wraper of all related Applicant and Aseets record.
    public void getOPPDetails()
    {
        ShowPageBlock  = false;
        accountId = ApexPages.currentPage().getParameters().get('accid');
        List<Id> OppLts = new List<ID>();
        if(accountId != null )
        {
            List<Account>  lstAcc = [select id,LastName,RecordTypeId,FirstName,PersonEmail,Click_Is_Phone_Broker_customer__c,PersonMobilePhone,
                                     Click_Community_Setup__c,IsMaster__c,SelfLookup__c,SelfLookup__r.Click_Community_Setup__c,
                                        (select id,Click_Community_Setup__c,SelfLookup__c from Accounts__r),(Select Id from Opportunities) from Account where id=:accountId ];
            if(lstAcc[0].Click_Community_Setup__c != null)
            {
                oppObj.accountid =Id.valueof(accountId);
                commId=lstAcc[0].Click_Community_Setup__c;
                if(lstAcc[0].Opportunities  != null )
                {
                    for(Opportunity Opp : lstAcc[0].Opportunities)
                    {
                        OppLts.add(opp.Id);
                    }
                }
            }
        }
        lstApplicant = [SELECT ACf1_Current_employer_Start_Date__c,ACF1_Previous_Employer_Name0__c,ACF1_Previous_Employer_Name12__c,ACF1_Previous_Employer_Name24__c,ACF1_Previous_Em_Start_Date0__c,ACF1_Previous_Em_Start_Date12__c,ACF1_Previous_Em_Start_Date24__c,acfBusiness_Name_or_ABN_autofill__c,acfDependant1_Age__c,acfDependant2_Age__c,acfDependant3_Age__c,acfDependant4_Age__c,acfDependant5_Age__c,acfEconsent_App2__c,acfEconsent__c,acfEmployment_Type__c,acfLast_2_years_Tax_Return_or_ATO_NOA__c,acf_ACf1_Current_employer_Start_Da__c,acf_applicant_Annual_profit_income__c,acf_applicant_App_1_Monthly_Expenses__c,acf_applicant_Dependants__c,acf_applicant_DOB__c,acf_applicant_Employer_Name__c,acf_applicant_Marital_Status__c,acf_applicant_Monthlly_Salary__c,acf_Applicant_Name__c,acf_applicant_Residency_status__c,acf_appl_ACf2_Current_employer_Start_Da__c,acf_How_Long_have_you_been_employed__c,acf_How_Long__c,Applicant_Email__c,Applicant_Phone__c,clickApp_1_Monthly_Expenses__c,clickMarried_To__c,clickOpportunity__c,click_Account__c,click_Applicant_Number__c,CreatedById,CreatedDate,Current_Role__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,acf_create_from_custom_clone_button__C,
                        (SELECT acfDetails__c,Amount__c,Applicant__c,Asset_And_Liability__c,Category__c,Name FROM Income_And_Expenses__r )       
                        FROM click_Applicant__c where  click_Account__c = :accountId OR clickOpportunity__c  in : OppLts ] ;
        
        lstAssets= [SELECT Account_Name__c,Account_Number__c,Account__c,Address__c,BSB__c,City__c,Clearing_From_This_Loan__c,Country__c,CreatedById,CreatedDate,Creditor__c,Credit_Card_Type__c,Current_Balance__c,Desciption__c,Evidence_of_Tenancy__c,Frequency__c,Gross_Amount__c,Id,Institution__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Limit__c,Name,Opportunity__c,Order__c,OwnerId,Postcode__c,Primary_Purpose__c,RecordTypeId,Rental_Income__c,Repayments__c,Repayment_Frequency__c,State__c,
                    Street_Name__c,Street_Number__c,Street_Type__c,SystemModstamp,To_Be_Purchased__c,Type__c,Used_as_Security__c,
                    Value_Basis__c,Value__c,Vehicle_Make__c,Vehicle_Type__c,Vehicle_Year__c,Zoning__c,acf_create_from_custom_clone_button__C, 
                    ( SELECT acfDetails__c,Amount__c,Applicant__c,Asset_And_Liability__c,Category__c,Name FROM Income_And_Expenses__r  )
                    FROM Asset_And_Liability__c where Account__c = :  accountId OR Opportunity__c  in : OppLts  ];   
    }
    
    //  This method create a wraper of prelogin question.
    Public void PreLoginQuestion()
    {
        ShowPageBlock  = true;
        lstWrapperQuestion = new List<WrapperQuestions>();
        lstMasterWrapperQuestion = new List<WrapperQuestions>();
        getPreLoginQuestion( commId);
    }
    
    
    public void getPreLoginQuestion(Id CommunityId)
    {
        map<id,Question__c>  mapQuestionIdToQuestion  = new map<id,Question__c>();
        mapIdToAnswer = new map<id,string>();
        lstComm = [select id,Name,Click_Page_Prefix__c from Click_Community_Setup__c where id =:CommunityId];
        if(lstComm != null && lstComm.size() > 0)
        {
            List<Script__c> lstScript = [select id,acf_Sequence_no__c,acf_Type__c from Script__c where acf_Type__c=:'Pre-Login'  AND Click_Community_Setup__c =: lstComm[0].id order by acf_Sequence_no__c limit 1];
            if(lstScript != null && lstScript.size() >0)
            {
                List<Questions> lstQuestions = new List<Questions>();
                WrapperQuestions objWarpperQues = new WrapperQuestions();
                if(selectedLoanType == 'New Purchase')
                { 
                           
                    for(Question__c objQuestion : [select id,acf_ApiName__c,Click_Is_Broker_Question__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,
                                                    acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,acfBubble_Text__c,acfWatermark_Text__c,
                                                    acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c,(select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r                                                            
                                                    order by acfSequence_No__c) from Question__c where ((acf_Master_Question__r.acf_Script__c =: lstScript[0].id or acf_Script__c =:lstScript[0].id)
                                                    and acf_Active__c = true and acfIs_New_Loan__c = true AND Click_Is_Broker_Question__c = false) order by acfNew_Loan_Sequence_No__c])
                    {   
                        Questions  objQuestions = new Questions();                         
                        mapQuestionIdToQuestion.put(objQuestion.id,objQuestion);
                        objQuestions.objWrapQuestion = objQuestion;
                        objWarpperQues.objWrapQuestion = objQuestion;
                        if(objQuestion.acf_Script__c <> null)
                        lstQuestions.add(objQuestions);
                    }  
                    objWarpperQues.lstRelatedQuestion = lstQuestions;
                    List<WrapperApplicant> lstwrpApplicant = new  List<WrapperApplicant> ();
                    if(lstApplicant != null && lstApplicant.size() > 0)
                    {                                                    
                        for(click_Applicant__c  applicant : lstApplicant)
                        {
                            WrapperApplicant  objApplicant = new WrapperApplicant();
                            objApplicant.objWrapApplicant =applicant;
                            List<WrapperIncomeAndExpense> lstIncomeExpense = new List<WrapperIncomeAndExpense>();
                            for(Income_And_Expense__c incomeAndExpence :  applicant.Income_And_Expenses__r)
                            {
                                WrapperIncomeAndExpense  ieobj = new WrapperIncomeAndExpense();
                                ieobj.objWrapIncomeExpense =  incomeAndExpence;
                                lstIncomeExpense.add(ieobj);
                            }
                            objApplicant.lstIe = lstIncomeExpense;
                            lstwrpApplicant.add(objApplicant);
                        }
                        objWarpperQues.lstWrapperApplicant = lstwrpApplicant;
                    }                
                    objWarpperQues.lstWrapperApplicant = getWrapperApplicant();
                    objWarpperQues.lstWrapperAssetAndLiability = getWrapperAssetAndLiability();
                    if(objWarpperQues != null)
                        lstMasterWrapperQuestion.add(objWarpperQues);      
                 }
                 else if(selectedLoanType == 'Refinance')
                 {
                    for(Question__c objQuestion : [select id,acf_ApiName__c,Click_Is_Broker_Question__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                                   acfBubble_Text__c,acfWatermark_Text__c,acfIs_refinance__c,acfRefinance_Sequence_No__c,                                                          
                                                   (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                   where ((acf_Master_Question__r.acf_Script__c =: lstScript[0].id or acf_Script__c =:lstScript[0].id) and acf_Active__c = true and acfIs_refinance__c = true AND Click_Is_Broker_Question__c = false) order by acfRefinance_Sequence_No__c])  
                    {   
                        Questions  objQuestions = new Questions();                         
                        mapQuestionIdToQuestion.put(objQuestion.id,objQuestion);
                        objQuestions.objWrapQuestion = objQuestion;
                        objWarpperQues.objWrapQuestion = objQuestion;
                        if(objQuestion.acf_Script__c <> null)
                            lstQuestions.add(objQuestions);
                    }  
                    objWarpperQues.lstRelatedQuestion = lstQuestions;
                    objWarpperQues.lstWrapperApplicant = getWrapperApplicant();
                    objWarpperQues.lstWrapperAssetAndLiability = getWrapperAssetAndLiability();
                    if(objWarpperQues != null)
                        lstMasterWrapperQuestion.add(objWarpperQues);    
                 }
                 //for adding wrapperlist in a page for all master questions.  
                 if(lstMasterWrapperQuestion != null && lstMasterWrapperQuestion.size()>0)
                 {
                    for(WrapperQuestions objMasterQuestion:lstMasterWrapperQuestion)
                    {      
                        for(Questions  question : objMasterQuestion.lstRelatedQuestion  )
                        {
                            question.lstSelectOpt = new List<SelectOption>();
                            question.lstSelectOptions = new List<Answer__c>();
                            question.lstCheckBoxAnswer = new List<string>();
                            for(Answer__c objAnswer:question.objWrapQuestion.Answer__r)
                            {   
                                question.lstSelectOptions.add(objAnswer);
                                question.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                                mapIdToAnswer.put(objAnswer.id,objAnswer.acf_Answer__c);
                            }
                        }
                        lstWrapperQuestion.add(objMasterQuestion); 
                    }
                 }
              }
          }            
     }
    // This methhod is used to create Applicant wrapper.
    public List<WrapperApplicant> getWrapperApplicant()
    {                               
        List<WrapperApplicant> lstwrpApplicant = new  List<WrapperApplicant> ();
        if(lstApplicant != null && lstApplicant.size() > 0)
        {           
            for(click_Applicant__c  applicant : lstApplicant)
            {
                WrapperApplicant  objApplicant = new WrapperApplicant();
                objApplicant.objWrapApplicant =applicant;
                List<WrapperIncomeAndExpense> lstIncomeExpense = new List<WrapperIncomeAndExpense>();
                for(Income_And_Expense__c incomeAndExpence :  applicant.Income_And_Expenses__r)
                {
                    WrapperIncomeAndExpense  ieobj = new WrapperIncomeAndExpense();
                    ieobj.objWrapIncomeExpense =  incomeAndExpence;
                    lstIncomeExpense.add(ieobj);
                }
                objApplicant.lstIe = lstIncomeExpense;
                lstwrpApplicant.add(objApplicant);
            }
        }
        return lstwrpApplicant ;
     }
     
     // This methhod is used to create AssetAndLiability wrapper.
     public List<WrapperAssetAndLiability> getWrapperAssetAndLiability()
     {                              
        List<WrapperAssetAndLiability> lstwrpAsset = new  List<WrapperAssetAndLiability> ();
        if(lstAssets != null && lstAssets.size() > 0)
        {  
            for(Asset_And_Liability__c  asset : lstAssets)
            {
                WrapperAssetAndLiability  objAsset = new WrapperAssetAndLiability();
                objAsset.objWrapAl =asset;
                List<WrapperIncomeAndExpense> lstIncomeExpense = new List<WrapperIncomeAndExpense>();
                for(Income_And_Expense__c incomeAndExpence :  asset.Income_And_Expenses__r)
                {
                    WrapperIncomeAndExpense  ieobj = new WrapperIncomeAndExpense();
                    ieobj.objWrapIncomeExpense =  incomeAndExpence;
                    lstIncomeExpense.add(ieobj);
                }
                objAsset.lstIe = lstIncomeExpense;
                lstwrpAsset.add(objAsset);
            }
        }
        return lstwrpAsset ;
    }
    
    public List<SelectOption> getLoanType()
    {  
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--NONE--'));
        options.add(new SelectOption('Refinance','Refinance'));
        options.add(new SelectOption('New Purchase','New Purchase')); 
        return options;
    }
    
    public class Questions
    {
        public Question__c objWrapQuestion {get;set;}
        public string strWrapAnswer {get;set;}
        public List<SelectOption>lstSelectOpt {get;set;}
        public List<Answer__c>lstSelectOptions{get;set;}
        public List<string>lstCheckBoxAnswer{get;set;}   
    } 
    
    public class WrapperQuestions
    {
        public List<Questions>lstRelatedQuestion {get;set;}
        public Question__c objWrapQuestion {get;set;}
        public string strWrapAnswer {get;set;}
        public List<SelectOption>lstSelectOpt {get;set;}
        public List<Answer__c>lstSelectOptions{get;set;}
        public List<string>lstCheckBoxAnswer{get;set;}
        public List<WrapperApplicant >lstWrapperApplicant {get;set;}
        public List<WrapperAssetAndLiability> lstWrapperAssetAndLiability {get ;set;}
    }
    
    public class WrapperApplicant
    {
        public click_Applicant__c objWrapApplicant {get;set;}
        public boolean SelectedApplicant {get ;set ;}
        public List<WrapperIncomeAndExpense>  lstIe {get ;set ;}
        public WrapperApplicant()
        {
            lstIe= new List<WrapperIncomeAndExpense> ();
            SelectedApplicant = false;
        }
    }
    
    public class WrapperIncomeAndExpense
    {
        public Income_And_Expense__c objWrapIncomeExpense {get;set;}
        public boolean SelectedIE {get ;set ;}
    }
    
    public class WrapperAssetAndLiability 
    {
        public Asset_And_Liability__c objWrapAl {get;set;}
        public boolean SelectedAl {get ;set ;}
        public List<WrapperIncomeAndExpense> lstIe{get ;set ;}
        public WrapperAssetAndLiability()
        {
            lstIe= new List<WrapperIncomeAndExpense> ();
            SelectedAl = false;
        }
    }
    
    
    public List<SelectOption> getBankNames()
    {  
        List<acfBank_Detail__c> lstBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c,clickShow_on_Bank_Statements_Integration__c from acfBank_Detail__c where click_Show_on_Current_Lender_question__c = true];
        List<SelectOption> options = new List<SelectOption>();
        if(lstBank != null && lstBank.size()>0)
        {
           options.add(new SelectOption('','--NONE--'));
           for(acfBank_Detail__c objBank : lstBank)
           { 
             options.add(new SelectOption(objBank.acfBank_Name__c,objBank.acfBank_Name__c));
           }
             options.add(new SelectOption('Other','Other'));
        }
        return options;
    }
    
//  This method is used to create a new opprtunit with all prelogin question , applicant and asset records.
       public PageReference CreateNewOpportunnit(){
       try{  
        System.debug('________________________________________________'+lstWrapperQuestion);
        Opportunity  Opp = new Opportunity ();
        List<click_Applicant__c> ltsapplicant = new List<click_Applicant__c>();
        List<Asset_And_Liability__c>  assetObj = new List<Asset_And_Liability__c> ();
        List<Income_And_Expense__c> lstInsertIE = new List<Income_And_Expense__c>();
        List<click_Applicant__c>  appObj = new List<click_Applicant__c> ();
        map<id, List<Income_And_Expense__c>>  mapApplicant = new map<id, List<Income_And_Expense__c>>();
        List<Asset_And_Liability__c> lstAssets= new List<Asset_And_Liability__c>();
        map<click_Applicant__c , List<Income_And_Expense__c>> mapIncomeExpense = new map<click_Applicant__c , List<Income_And_Expense__c>> ();
        Set<String> ansId = new Set<String>();
        system.debug('@@@@@'+selectedLoanType+'&&&&&'+lstComm);
        
        
        if(lstWrapperQuestion !=null && lstWrapperQuestion.size() > 0)
        {
            opp.Transaction_Type__c = selectedLoanType;
            opp.AccountId = accountId;
            opp.StageName = 'Application Taken';
            opp.Name = 'New';
           
            if(selectedLoanType == 'New Purchase' && lstComm != null && !lstComm.isEmpty()  && lstComm[0].Click_Page_Prefix__c != null  &&   Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c +' New Loans') != null &&   Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c +' New Loans').getRecordTypeId() !=null )
            {
                 opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c +' New Loans').getRecordTypeId();
            } 
            else if(selectedLoanType == 'Refinance' && lstComm != null && !lstComm.isEmpty() && lstComm[0].Click_Page_Prefix__c != null && Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c +' Refi') != null  && Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c +' Refi').getRecordTypeId() != null)
            {
                 system.debug('@@@@@====='+Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c +' Refi').getRecordTypeId());
                opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c +' Refi').getRecordTypeId();  
            }
            else if(lstComm != null && !lstComm.isEmpty() && lstComm[0].Name == 'Lendi')
            {
                opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lendi').getRecordTypeId();
            }
            if(lstComm != null && !lstComm.isempty())
                opp.Community_Setup__c = lstComm[0].Id;
            opp.closedate = System.today();
            opp.create_from_custom_clone_button__c=true;
            for(WrapperQuestions  wrpques : lstWrapperQuestion )
            {
              for( Questions   ques  :wrpques.lstRelatedQuestion)
              {
                    if(!string.isblank(ques.strWrapAnswer)    && ques.objWrapQuestion.acf_ApiName__c =='acfEmployment_Type__c'  && ques.strWrapAnswer != 'None'){
                        opp.acfEmployment_Type__c =mapIdToAnswer.get(ques.strWrapAnswer) != null ? mapIdToAnswer.get(ques.strWrapAnswer) : '' ;
                        ansId.add(ques.strWrapAnswer);
                    }
                    if(!string.isblank(ques.strWrapAnswer)    && ques.objWrapQuestion.acf_ApiName__c =='acfLoan_Amount__c' && ques.strWrapAnswer != 'None'){
                    Opp.acfLoan_Amount_c__c = Decimal.valueof(ques.strWrapAnswer);
                    }
                    if(!string.isblank(ques.strWrapAnswer) &&  ques.objWrapQuestion.acf_ApiName__c =='acfApproximately_how_much_is_your_house__c' && ques.strWrapAnswer != 'None'){
                     Opp.acfApproximately_how_much_is_your_house__c = Decimal.valueof(ques.strWrapAnswer);
                    }
                    if(!string.isblank(ques.strWrapAnswer)  && ques.objWrapQuestion.acf_ApiName__c =='acfWhat_is_your_current_payment_type__c' && ques.strWrapAnswer != 'None'){
                    Opp.acfWhat_is_your_current_payment_type__c = ques.strWrapAnswer != null ? mapIdToAnswer.get(ques.strWrapAnswer) : '' ;
                    }
                    if(!string.isblank(ques.strWrapAnswer) && ques.objWrapQuestion.acf_ApiName__c =='click_Is_this_loan_for_an_investment_p__c' && ques.strWrapAnswer != 'None'){
                    Opp.click_Is_this_loan_for_an_investment__c = mapIdToAnswer.get(ques.strWrapAnswer) != null ? mapIdToAnswer.get(ques.strWrapAnswer) : '' ;
                    }
                    if(!string.isblank(ques.strWrapAnswer)  &&  ques.objWrapQuestion.acf_ApiName__c =='acfHow_is_your_current_credit_history__c' && ques.strWrapAnswer != 'None'){
                    Opp.acfHow_is_your_current_credit_history__c = mapIdToAnswer.get(ques.strWrapAnswer) != null ? mapIdToAnswer.get(ques.strWrapAnswer) : '' ;
                    ansId.add(ques.strWrapAnswer);
                    }
                    if(!string.isblank(ques.strWrapAnswer) && ques.objWrapQuestion.acf_ApiName__c =='acfWhat_is_your_postcode__c'){
                    Opp.acfWhat_is_your_postcode__c = ques.strWrapAnswer;
                    }
                    if(!string.isblank(ques.strWrapAnswer) && ques.objWrapQuestion.acf_ApiName__c =='Current_Lender__c'){
                    opp.Current_Lender__c =ques.strWrapAnswer != null ? ques.strWrapAnswer : '' ;
                    //ansId.add(ques.strWrapAnswer);
                    }
                    if(!string.isblank(ques.strWrapAnswer) && ques.objWrapQuestion.acf_ApiName__c =='acfCurrentRate__c'){
                    opp.Current_Interest_Rate__c = Decimal.valueof(ques.strWrapAnswer) ;
                    }
                    if(!string.isblank(ques.strWrapAnswer) && ques.objWrapQuestion.acf_ApiName__c =='acfWhy_are_you_refinancing__c' && ques.strWrapAnswer != 'None'){
                    opp.acfWhy_are_you_refinancing__c =mapIdToAnswer.get(ques.strWrapAnswer) != null ? mapIdToAnswer.get(ques.strWrapAnswer): '' ;
                    ansId.add(ques.strWrapAnswer);
                    }
                    if(!string.isblank(ques.strWrapAnswer) && ques.objWrapQuestion.acf_ApiName__c =='acfApproximately_how_much_is_your_house__c'){
                    opp.acfApproximately_how_much_is_your_house__c = Decimal.valueof(ques.strWrapAnswer) ;
                    }
                    if(!string.isblank(ques.strWrapAnswer) && ques.objWrapQuestion.acf_ApiName__c =='click_Is_this_loan_for_an_investment_p__c' && ques.strWrapAnswer != 'None'){
                    opp.click_Is_this_loan_for_an_investment__c = mapIdToAnswer.get(ques.strWrapAnswer) != null ? mapIdToAnswer.get(ques.strWrapAnswer) : '' ;
                    ansId.add(ques.strWrapAnswer);
                    }
                    if(!string.isblank(ques.strWrapAnswer) && ques.objWrapQuestion.acf_ApiName__c =='acfWhat_is_your_current_payment_type__c' && ques.strWrapAnswer != 'None'){
                    opp.acfWhat_is_your_current_payment_type__c = mapIdToAnswer.get(ques.strWrapAnswer) != null ? mapIdToAnswer.get(ques.strWrapAnswer) : '' ;
                     ansId.add(ques.strWrapAnswer);
                    }
              }
                  
              for(WrapperApplicant   app  : wrpques.lstWrapperApplicant)
              {
                  if(app.SelectedApplicant == true)
                  {
                      ltsapplicant.add(app.objWrapApplicant); 
                  }
                  for(WrapperIncomeAndExpense   wrpie  : app.lstIe)
                  {
                      if(wrpie.SelectedIE == true)
                      {
                          if(mapApplicant.containskey(app.objWrapApplicant.Id))
                          {
                              mapApplicant.get(app.objWrapApplicant.Id).add(wrpie.objWrapIncomeExpense);
                          }
                          else
                          {
                              List<Income_And_Expense__c> lstIncomeAndExpense= new List<Income_And_Expense__c>();
                              lstIncomeAndExpense.add(wrpie.objWrapIncomeExpense);
                              mapApplicant.put(app.objWrapApplicant.id,lstIncomeAndExpense);
                          }
                      }
                  }
                  
              }
               for(WrapperAssetAndLiability   wrpAsset  : wrpques.lstWrapperAssetAndLiability)
               {
                  if(wrpAsset.SelectedAl == true)
                  {
                     lstAssets.add(wrpAsset.objWrapAl ); 
                  }
                  for(WrapperIncomeAndExpense   wrpie  : wrpAsset.lstIe)
                  {
                      if(wrpie.SelectedIE == true)
                      {
                         if(mapApplicant.containskey(wrpAsset.objWrapAl.Id))
                         {
                              mapApplicant.get(wrpAsset.objWrapAl.Id).add(wrpie.objWrapIncomeExpense);
                         }
                         else
                         {
                            List<Income_And_Expense__c> lstIncomeAndExpense= new List<Income_And_Expense__c>();
                            lstIncomeAndExpense.add(wrpie.objWrapIncomeExpense);
                            mapApplicant.put(wrpAsset.objWrapAl.Id,lstIncomeAndExpense);

                         } 
                      }
                  } 
              }
            }
            
            insert opp; 
             if(lstComm != null && !lstComm.isEmpty() && lstComm[0].Name != 'Lendi')
            {
            Funding_Position__c objFundingPosition = new Funding_Position__c();
            objFundingPosition.Account__c = opp.AccountId;
            objFundingPosition.Opportunity__c =  opp.Id;
            insert objFundingPosition;
            }
            
            if(ltsapplicant.size() >0){
                
                for(click_Applicant__c app : ltsapplicant ){
                    click_Applicant__c obj = app.clone(false,false,false,false);
                    obj.clickOpportunity__c = opp.id;
                    obj.acf_create_from_custom_clone_button__C =true;
                    obj.acfRecordId__C = app.id;
                    obj.copy_from__C = app.id;
                    appObj.add(obj);
                     System.debug('______3_____'+opp.id);
                    
                }
            }
             
            
        if(lstAssets.size() > 0)
        {
            for(Asset_And_Liability__c asset : lstAssets )
            {
                Asset_And_Liability__c obj = asset.clone(false,false,false,false);
                obj.Opportunity__c = opp.id;
                obj.copy_from__c =asset.id;
                obj.acfRecordId__C = asset.id;
                obj.acf_create_from_custom_clone_button__c = true;
                assetObj.add(obj);
            }
        }
            
        if(appObj.size() > 0)
        {
            insert appObj;
        }
         
        List<Income_And_Expense__c> tempIncomeAndExpense = new List<Income_And_Expense__c> ();
        
         for(click_Applicant__c app  :appObj)
         {
            Id acfrecordid  =Id.valueof(app.acfrecordid__C);
            if(acfrecordid  != null && mapApplicant.get(acfrecordid  ) !=  null)
            {
                List<Income_And_Expense__c> lstIE = mapApplicant.get(acfrecordid  ) ;
                for(Income_And_Expense__c ins : lstIE)
                {
                    Income_And_Expense__c obj1 = ins.clone(false,false,false,false);
                    obj1.Applicant__c = app.id;
                    obj1.Copy_from__C = ins.id;
                    obj1.Opportunity__c = opp.id;
                    system.debug(obj1);
                    tempIncomeAndExpense.add(obj1);
                }
            }
         }

        if(assetObj.size() > 0){
            insert assetObj;
        }
        for(Asset_And_Liability__c asset  :assetObj)
        {
            Id acfrecordid  =Id.valueof(asset.acfrecordid__C);
            if(acfrecordid  != null && mapApplicant.get(acfrecordid  ) !=  null)
            {
                List<Income_And_Expense__c> lstIE = mapApplicant.get(acfrecordid  ) ;
                for(Income_And_Expense__c ins : lstIE)
                {
                    Income_And_Expense__c obj1 = ins.clone(false,false,false,false);
                    obj1.Asset_And_Liability__c = asset.id;
                    obj1.Copy_from__C = ins.id;
                    obj1.Opportunity__c = opp.id;
                    system.debug(obj1);
                    tempIncomeAndExpense.add(obj1);
                }
            }
         }

        if(tempIncomeAndExpense.size() >0)
            insert tempIncomeAndExpense;

        getRequiredDocumentsFromAnswersFromCRM(opp.id, ansId,commId);
        getSuggestedProductsFromAnswers(opp.id, ansId,commId); 
        PageReference pageRef = new PageReference('/'+opp.id);
        return pageRef ;
        }
        return null;
        }
        catch(DmlException  excp)
        { 
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, excp.getdmlMessage(0) );
            ApexPages.addMessage(msg);
            return null;
        }
     }
    // This method is  used for creating gRequired Documents 
    public static void getRequiredDocumentsFromAnswersFromCRM(Id LeadId,set<string> setSelectedAnswer,Id CommunitySetupId)
    {
        system.debug('@@#$$%'+CommunitySetupId);
       List<Required_Document__c>lstRequiredDocumentToInsert = new List<Required_Document__c>();    
       if(setSelectedAnswer <> null && setSelectedAnswer.size()>0 && CommunitySetupId <> null)
       {
       
           Set<String> st = new Set<String>();
            for(Dependent_Document__c objDependentDocument:[select id,acfAnswer__c,acfDocument_Master__c,acfDocument_Master__r.Click_Community_Setup__c,
                                                            acfActive__c,name
                                                            from Dependent_Document__c where acfAnswer__c in:setSelectedAnswer and acfActive__c = true
                                                            and acfDocument_Master__r.Click_Community_Setup__c =:CommunitySetupId])
            {
                   if(!st.contains(objDependentDocument.Name)){
                     
                       Required_Document__c objRequiredDocument  =  new Required_Document__c();
                       objRequiredDocument.Name                  =  objDependentDocument.Name;
                       objRequiredDocument.acfDocument_Master__c =  objDependentDocument.acfDocument_Master__c;
                       objRequiredDocument.acfOpportunity__c               =  LeadId;
                       objRequiredDocument.acfStatus__c          =  'Pending';
                       lstRequiredDocumentToInsert.add(objRequiredDocument);       
                       st.add(objDependentDocument.Name);
                   }
            }
            system.debug(':::::'+lstRequiredDocumentToInsert);
            if(lstRequiredDocumentToInsert <> null && lstRequiredDocumentToInsert.size()>0)
            {
                insert lstRequiredDocumentToInsert;
            }                                           
       }     
    }
    
    public static void getSuggestedProductsFromAnswers(Id LeadId,set<string> setSelectedAnswer,string strCommSetupId)
    {
        system.debug('Sumit LeadId :: '+LeadId);
        system.debug('Sumit setSelectedAnswer :: '+setSelectedAnswer);
        // changes done by Ankit for Adding bank functionality
        set<id> setOfBankDetailId = new set<id>();
        List<Click_Loans_Bank__c> lstbank = new List<Click_Loans_Bank__c>();
        if(strCommSetupId <> null)
        {
            lstbank = [select id,Click_Loans_Bank_Detail__c,Community_Setup__c from Click_Loans_Bank__c where Community_Setup__c =:strCommSetupId];
        }
        if(lstbank.size() > 0 && lstbank != null)
        {
            for(Click_Loans_Bank__c objbank : lstbank)
            {
                    setOfBankDetailId.add(objbank.Click_Loans_Bank_Detail__c);
            }
        }
        List<acfSuggested_Product__c>lstSuggestedDocumentToInsert = new List<acfSuggested_Product__c>();    
       if(setSelectedAnswer <> null && setSelectedAnswer.size()>0 && setOfBankDetailId <> null && setOfBankDetailId.size() > 0)
       {
            list<acfDependent_Product__c> lstDependentProducts = [select id,acfAnswer__c,acfFilter__c,acfProduct__c,acfProduct_Family__c 
                                                                    from acfDependent_Product__c 
                                                                    where acfAnswer__c in :setSelectedAnswer 
                                                                    and  acfProduct__r.Click_Loans_Bank_Detail__c IN : setOfBankDetailId];
            
            system.debug('Sumit lstDependentProducts :::: ' + lstDependentProducts );
            
            for(acfDependent_Product__c objDependentProd :lstDependentProducts)
            {
                acfSuggested_Product__c objSuggestedProd = new acfSuggested_Product__c();
                objSuggestedProd.acfFilter__c   =  objDependentProd.acfFilter__c;
                objSuggestedProd.acfOpportunity__c     =  LeadId; 
                objSuggestedProd.acfProduct__c  =  objDependentProd.acfProduct__c;
                lstSuggestedDocumentToInsert.add(objSuggestedProd);
            }
            system.debug('Sumit lstSuggestedDocumentToInsert ::: '+lstSuggestedDocumentToInsert);
            if(lstSuggestedDocumentToInsert <> null && lstSuggestedDocumentToInsert.size()>0)
                insert lstSuggestedDocumentToInsert;
       }   
    }
}