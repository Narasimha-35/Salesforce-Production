@isTest(SeeAllData=true)

public class acfCloneOppTracker {
 static testmethod void myTestMethod1() {
List<click_Applicant__c >lstApplicant = [SELECT ACf1_Current_employer_Start_Date__c,ACF1_Previous_Employer_Name0__c,ACF1_Previous_Employer_Name12__c,
                          ACF1_Previous_Employer_Name24__c,ACF1_Previous_Em_Start_Date0__c,ACF1_Previous_Em_Start_Date12__c,ACF1_Previous_Em_Start_Date24__c,
                          acfBusiness_Name_or_ABN_autofill__c,acfDependant1_Age__c,acfDependant2_Age__c,acfDependant3_Age__c,acfDependant4_Age__c,acfDependant5_Age__c,
                          acfEconsent_App2__c,acfEconsent__c,acfEmployment_Type__c,acfLast_2_years_Tax_Return_or_ATO_NOA__c,acf_ACf1_Current_employer_Start_Da__c,
                          acf_applicant_Annual_profit_income__c,acf_applicant_App_1_Monthly_Expenses__c,acf_applicant_Dependants__c,acf_applicant_DOB__c,
                          acf_applicant_Employer_Name__c,acf_applicant_Marital_Status__c,acf_applicant_Monthlly_Salary__c,acf_Applicant_Name__c,
                          acf_applicant_Residency_status__c,acf_appl_ACf2_Current_employer_Start_Da__c,acf_How_Long_have_you_been_employed__c,acf_How_Long__c,
                          Applicant_Email__c,Applicant_Phone__c,clickApp_1_Monthly_Expenses__c,clickMarried_To__c,clickOpportunity__c,click_Account__c,
                          click_Applicant_Number__c,CreatedById,CreatedDate,Current_Role__c,Id,IsDeleted,LastActivityDate,LastModifiedById,
                          LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,acf_create_from_custom_clone_button__C,
                    (SELECT acfDetails__c,Amount__c,Applicant__c,Asset_And_Liability__c,Category__c,Name FROM Income_And_Expenses__r where Applicant__c != null )      
                     FROM click_Applicant__c where  click_Account__c != null  AND clickOpportunity__c  != null  limit 1 ] ;
  List<Account>  lstAcc = [select id,LastName,RecordTypeId,FirstName,PersonEmail,Click_Is_Phone_Broker_customer__c,
                PersonMobilePhone,Click_Community_Setup__c,IsMaster__c,SelfLookup__c,SelfLookup__r.Click_Community_Setup__c,
                (select id,Click_Community_Setup__c,SelfLookup__c from Accounts__r)             
                from Account whete   where RecordTypeId != null  and Click_Community_Setup__c != null and id = :
                 lstApplicant[0].click_Account__c  limit 1  ];
               
                
                PageReference myVfPage = Page.cloneOpportunities;
Test.setCurrentPage(myVfPage);

// Put Id into the current page Parameters
ApexPages.currentPage().getParameters().put('accid',lstAcc[0].Id);
ApexPages.StandardController sc = new ApexPages.StandardController(lstAcc[0]);
 acfCreateNewOpportunity oppobj=new acfCreateNewOpportunity (sc);
     oppobj.selectedLoanType='New Purchase';
     oppobj.getNewAccountDetails();
     oppobj.CreateNewOpportunnit();
    }

static testmethod void myTestMethod2() {
 List<Asset_And_Liability__c> lstAssets= [SELECT Account_Name__c,Account_Number__c,Account__c,Address__c,BSB__c,City__c,Clearing_From_This_Loan__c,Country__c,CreatedById,CreatedDate,Creditor__c,Credit_Card_Type__c,Current_Balance__c,Desciption__c,Evidence_of_Tenancy__c,Frequency__c,Gross_Amount__c,Id,Institution__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Limit__c,Name,Opportunity__c,Order__c,OwnerId,Postcode__c,Primary_Purpose__c,RecordTypeId,Rental_Income__c,Repayments__c,Repayment_Frequency__c,State__c,acf_create_from_custom_clone_button__C,
                        Street_Name__c,Street_Number__c,Street_Type__c,SystemModstamp,To_Be_Purchased__c,Type__c,Used_as_Security__c,
                        Value_Basis__c,Value__c,Vehicle_Make__c,Vehicle_Type__c,Vehicle_Year__c,Zoning__c, 
                        ( SELECT acfDetails__c,Amount__c,Applicant__c,Asset_And_Liability__c,Category__c,Name FROM Income_And_Expenses__r  )
                         FROM Asset_And_Liability__c where Account__c != null AND  Opportunity__c  != null ];
  List<Account>  lstAcc = [select id,LastName,RecordTypeId,FirstName,PersonEmail,Click_Is_Phone_Broker_customer__c,
                PersonMobilePhone,Click_Community_Setup__c,IsMaster__c,SelfLookup__c,SelfLookup__r.Click_Community_Setup__c,
                (select id,Click_Community_Setup__c,SelfLookup__c from Accounts__r)             
                from Account whete   where RecordTypeId != null  and Click_Community_Setup__c != null and id = :
                 lstAssets[0].account__C  limit 1  ];
               
                
                PageReference myVfPage = Page.cloneOpportunities;
Test.setCurrentPage(myVfPage);

// Put Id into the current page Parameters
ApexPages.currentPage().getParameters().put('accid',lstAcc[0].Id);
ApexPages.StandardController sc = new ApexPages.StandardController(lstAcc[0]);
 acfCreateNewOpportunity oppobj=new acfCreateNewOpportunity (sc);
     oppobj.selectedLoanType='Refinance';
     oppobj.getNewAccountDetails();
     oppobj.CreateNewOpportunnit();
    } 



    

    static testmethod void myTestMethod3() {
 //List<Income_And_Expense__c> iddn = [select  Applicant__c FROM Income_And_Expense__c where Applicant__c != null limit 1 ];
List<click_Applicant__c >lstApplicant = [SELECT ACf1_Current_employer_Start_Date__c,ACF1_Previous_Employer_Name0__c,ACF1_Previous_Employer_Name12__c,
                          ACF1_Previous_Employer_Name24__c,ACF1_Previous_Em_Start_Date0__c,ACF1_Previous_Em_Start_Date12__c,ACF1_Previous_Em_Start_Date24__c,
                          acfBusiness_Name_or_ABN_autofill__c,acfDependant1_Age__c,acfDependant2_Age__c,acfDependant3_Age__c,acfDependant4_Age__c,acfDependant5_Age__c,
                          acfEconsent_App2__c,acfEconsent__c,acfEmployment_Type__c,acfLast_2_years_Tax_Return_or_ATO_NOA__c,acf_ACf1_Current_employer_Start_Da__c,
                          acf_applicant_Annual_profit_income__c,acf_applicant_App_1_Monthly_Expenses__c,acf_applicant_Dependants__c,acf_applicant_DOB__c,
                          acf_applicant_Employer_Name__c,acf_applicant_Marital_Status__c,acf_applicant_Monthlly_Salary__c,acf_Applicant_Name__c,
                          acf_applicant_Residency_status__c,acf_appl_ACf2_Current_employer_Start_Da__c,acf_How_Long_have_you_been_employed__c,acf_How_Long__c,
                          Applicant_Email__c,Applicant_Phone__c,clickApp_1_Monthly_Expenses__c,clickMarried_To__c,clickOpportunity__c,click_Account__c,
                          click_Applicant_Number__c,CreatedById,CreatedDate,Current_Role__c,Id,IsDeleted,LastActivityDate,LastModifiedById,
                          LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,acf_create_from_custom_clone_button__C,
                    (SELECT acfDetails__c,Amount__c,Applicant__c,Asset_And_Liability__c,Category__c,Name FROM Income_And_Expenses__r where Applicant__c != null )      
                     FROM click_Applicant__c where  click_Account__c != null  AND clickOpportunity__c  != null   limit 1 ] ;
  List<Account>  lstAcc = [select id,LastName,RecordTypeId,FirstName,PersonEmail,Click_Is_Phone_Broker_customer__c,
                PersonMobilePhone,Click_Community_Setup__c,IsMaster__c,SelfLookup__c,SelfLookup__r.Click_Community_Setup__c,
                (select id,Click_Community_Setup__c,SelfLookup__c from Accounts__r)             
                from Account whete   where RecordTypeId != null  and Click_Community_Setup__c != null and id = :
                 lstApplicant[0].click_Account__c  limit 1  ];
               
                
                PageReference myVfPage = Page.cloneOpportunities;
Test.setCurrentPage(myVfPage);

// Put Id into the current page Parameters
ApexPages.currentPage().getParameters().put('accid',lstAcc[0].Id);
ApexPages.StandardController sc = new ApexPages.StandardController(lstAcc[0]);
 acfCreateNewOpportunity oppobj=new acfCreateNewOpportunity (sc);
     oppobj.selectedLoanType='New Purchase';
     oppobj.getNewAccountDetails();
     oppobj.CreateNewOpportunnit();
     oppobj.getLoanType();
      oppobj.getBankNames();
    }
    
    static testmethod void myTestMethod4() {
        List<click_Applicant__c >lstApplicant = [SELECT ACf1_Current_employer_Start_Date__c,ACF1_Previous_Employer_Name0__c,ACF1_Previous_Employer_Name12__c,
                          ACF1_Previous_Employer_Name24__c,ACF1_Previous_Em_Start_Date0__c,ACF1_Previous_Em_Start_Date12__c,ACF1_Previous_Em_Start_Date24__c,
                          acfBusiness_Name_or_ABN_autofill__c,acfDependant1_Age__c,acfDependant2_Age__c,acfDependant3_Age__c,acfDependant4_Age__c,acfDependant5_Age__c,
                          acfEconsent_App2__c,acfEconsent__c,acfEmployment_Type__c,acfLast_2_years_Tax_Return_or_ATO_NOA__c,acf_ACf1_Current_employer_Start_Da__c,
                          acf_applicant_Annual_profit_income__c,acf_applicant_App_1_Monthly_Expenses__c,acf_applicant_Dependants__c,acf_applicant_DOB__c,
                          acf_applicant_Employer_Name__c,acf_applicant_Marital_Status__c,acf_applicant_Monthlly_Salary__c,acf_Applicant_Name__c,
                          acf_applicant_Residency_status__c,acf_appl_ACf2_Current_employer_Start_Da__c,acf_How_Long_have_you_been_employed__c,acf_How_Long__c,
                          Applicant_Email__c,Applicant_Phone__c,clickApp_1_Monthly_Expenses__c,clickMarried_To__c,clickOpportunity__c,click_Account__c,
                          click_Applicant_Number__c,CreatedById,CreatedDate,Current_Role__c,Id,IsDeleted,LastActivityDate,LastModifiedById,
                          LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,acf_create_from_custom_clone_button__C,
                    (SELECT acfDetails__c,Amount__c,Applicant__c,Asset_And_Liability__c,Category__c,Name FROM Income_And_Expenses__r where Applicant__c != null )      
                     FROM click_Applicant__c where  click_Account__c != null  AND clickOpportunity__c  != null   limit 1 ] ;
  List<Account>  lstAcc = [select id,LastName,RecordTypeId,FirstName,PersonEmail,Click_Is_Phone_Broker_customer__c,
                PersonMobilePhone,Click_Community_Setup__c,IsMaster__c,SelfLookup__c,SelfLookup__r.Click_Community_Setup__c,
                (select id,Click_Community_Setup__c,SelfLookup__c from Accounts__r)             
                from Account whete   where RecordTypeId != null  and Click_Community_Setup__c != null and id = :
                 lstApplicant[0].click_Account__c  limit 1  ];
    List<Click_Community_Setup__c>   lstComm = [select id,Click_Page_Prefix__c from Click_Community_Setup__c where id =:lstAcc[0].Click_Community_Setup__c];
     List<Script__c>lstScript = [select id,acf_Sequence_no__c,acf_Type__c from Script__c where acf_Type__c=:'Pre-Login'  AND Click_Community_Setup__c =: lstComm[0].id order by acf_Sequence_no__c limit 1];
List<Question__c>   quest = [select id,acf_ApiName__c,Click_Is_Broker_Question__c,acf_Description__c,
acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, 
acf_Postal_Code__c,
    acfBubble_Text__c,acfWatermark_Text__c,acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c,                                                           
   (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
   where ((acf_Master_Question__r.acf_Script__c =: lstScript[0].id or acf_Script__c =:lstScript[0].id) and acf_Active__c = true and 
   acfIs_New_Loan__c = true AND Click_Is_Broker_Question__c = false) order by acfNew_Loan_Sequence_No__c];
   
   set<string> ansId  = new set<String>();
   for(Question__c q :quest ){
       for(Answer__c  ans : q.Answer__r){
           ansId.add(ans.id);
       }
           
           
       }
       ApexPages.currentPage().getParameters().put('accid',lstAcc[0].Id);
ApexPages.StandardController sc = new ApexPages.StandardController(lstAcc[0]);
 acfCreateNewOpportunity oppobj=new acfCreateNewOpportunity (sc);
     oppobj.selectedLoanType='New Purchase';
     oppobj.getNewAccountDetails();
     oppobj.CreateNewOpportunnit();
     oppobj.getLoanType();
      oppobj.getBankNames();
      List<Opportunity> oppObj1 = [Select ID ,AccountId from Opportunity where AccountId = : lstacc[0].id];
     acfCreateNewOpportunity.getSuggestedProductsFromAnswers(oppObj1[0].id,ansId,String.valueof(lstacc[0].Click_Community_Setup__c));
       acfCreateNewOpportunity.getRequiredDocumentsFromAnswersFromCRM(oppObj1[0].id,ansId,String.valueof(lstacc[0].Click_Community_Setup__c));
       
      }
   }