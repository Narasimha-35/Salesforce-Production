@isTest(SeeAllData =true)
private class acfLoanDashboardControllerBrokerTracker {
private static Product2 objProduct2;
static private User objUser;
public static acfBank_Detail__c objBankDetail;
private static Contact objContact; 
private static Account objAccount;   
private static Opportunity objOpportunity;
private static Lead objLead;
public static  Account objacc;
public static Lead objLead1;
public static Pricebook2 pbk1;
public static Product2 prd1;
public static PricebookEntry pbe1;
public static OpportunityLineItem lineItem1;
    
    static testMethod void validateLoanDashboard()
    {   
     
        LoadData();
        
        acfLoanDashboardController_Broker.WrapperProducts wrapp = new acfLoanDashboardController_Broker.WrapperProducts();
        wrapp.decRate =10.0;
        wrapp.ProductName ='test';
        wrapp.strRateType = 'test';
        wrapp.decComparisionRate = 10;
        wrapp.strcomparisionType='test';
        wrapp.strRating = 'test';
        wrapp.decMonthlyPayment = 101;
        wrapp.ProductId = objProduct2.id;
        wrapp.ProdLVRID = objProduct2.id;
        wrapp.TenureInMonth = 10.25;
        wrapp.LoanFees = 10.25;
        wrapp.IndexNo =10;
        wrapp.EstimatedSaving = 10.25;
        wrapp.TenureInYears = 10.25;
        wrapp.Feature_1 ='test';
        wrapp.Feature_2 ='test';
        wrapp.Feature_3 ='test';
        wrapp.AddRepayments = true;
        wrapp.DebitCard = true;
        wrapp.Redraw = true;
        wrapp.InterestOnly = true;
        wrapp.OffsetAccount = true;
        wrapp.MultipleSplits = true;
               
  //      RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Fixed'];
        product2 objPro = new product2();
        objPro.ACF_Comparison_Rate__c = 10;
        objPro.IsActive = true;
        objPro.acfType__c = 'Variable';
 //       objPro.Recordtype.Name = objRT.name;
        objPro.acfTenure_in_Years__c = '2'; 
        objPro.acfvarTenure_In_Years__c = 10;
    //    objPro.clickLoan_Type__c =  'Basic';
        objPro.acfOffset_Account__c = false;
        objPro.Name = 'test';
      //  objPro.acfRating__c = '1';
        insert objPro;  
        
        
        acfSuggested_Product__c objsuggest = new acfSuggested_Product__c();
        objsuggest.acfFilter__c = 'Exclude';
        objsuggest.acfProduct__c = objProduct2.id;
        objsuggest.acfOpportunity__c = objOpportunity.id;
        insert objsuggest;

        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.acfLVR__c = 1500.25;
        objLVR.acfRate__c = 10.25;
        objLVR.acfProduct__c = objProduct2.id;
        objLVR.acfLoan_Size__c = 10000.20;
        objLVR.ACF_Comparison_Rate__c = 10.00; 
        objLVR.clickFixed_Interest_Rate__c = 9.00;
        objLVR.clickLoan_Size_From__c = 50.50;
        objLVR.clickLVR_From__c = 10.2;
        objLVR.acfApplication_Fee__c = 5000; 
        insert objLVR; 
        
        Click_Community_Setup__c objccs=new Click_Community_Setup__c();
        objccs.Name='ClickLoans';
        objccs.Click_Page_Prefix__c = 'Click';
        objccs.Click_Network_ID__c='0DB900000008Ptg';
        insert objccs;
        
        objBankDetail = new acfBank_Detail__c();
        objBankDetail.acfBank_Name__c = 'Bank of Statements';
        objBankDetail.acfBankSlugName__c = 'bank_of_statements';
        objBankDetail.click_Show_on_Current_Lender_question__c = true;
        insert objBankDetail;
        
        ApexPages.currentPage().getParameters().put('cid',objaccount.id);
        
        set<string> setProductIdToExclude = new set<string>();
        setProductIdToExclude.add(objLVR.acfProduct__c);
        
        
        
        acfLoanDashboardController_Broker objacfLoanDashboardController = new acfLoanDashboardController_Broker();      
        objacfLoanDashboardController.acid=objaccount.id;
        objacfLoanDashboardController.strLVRProductId ='Ankit';
        objacfLoanDashboardController.EstimatedSaving =10;
        objacfLoanDashboardController.strCustomLabelValue ='Ankit';
        objacfLoanDashboardController.DateConditionallyApproved ='Ankit';
        objacfLoanDashboardController.DateFormallyApproved ='Ankit';
        objacfLoanDashboardController.DateDocsGenerated ='Ankit';
        objacfLoanDashboardController.DateExpectedSettlement ='Ankit';
        objacfLoanDashboardController.strConditionsOfApproval ='Ankit';
        objacfLoanDashboardController.strDescription ='Ankit';
        objacfLoanDashboardController.NoOfYears = 10;
        
        objacfLoanDashboardController.OpportunityId = objOpportunity.Id;
        objacfLoanDashboardController.prodListIndex = -5;
        
     /* objacfLoanDashboardController.stwrapper[0].selected = true;
        objacfLoanDashboardController.stwrapper[1].selected = true;
        objacfLoanDashboardController.stwrapper[2].selected = true; */
        objacfLoanDashboardController.prodListIndex = 0;
//        objacfLoanDashboardController.ChooseProduct();
 //       objacfLoanDashboardController.OnProductSelection();
        objacfLoanDashboardController.IsValidDecimal(20.1);
        objacfLoanDashboardController.DisplayLoanProducts(objOpportunity.id,20,20,200.00,'Cash');
        objacfLoanDashboardController.redirect();       
        objacfLoanDashboardController.DisplayOpportunityLIProducts(objOpportunity.id,10.01,'Cash');
 //       objacfLoanDashboardController.DisplayEstimatedSaving(10.01,10.06,10.36,'Cash',1.5); 
        objacfLoanDashboardController.ConvertDateToString(system.today());  
        objacfLoanDashboardController.Test1();
        objacfLoanDashboardController.Test2();
        objacfLoanDashboardController.Test3();
      objacfLoanDashboardController.Test4();
      objacfLoanDashboardController.Test5();
      objacfLoanDashboardController.Test6();
      objacfLoanDashboardController.Test7();
      objacfLoanDashboardController.Test8();
      objacfLoanDashboardController.Test9();
      objacfLoanDashboardController.Test10();
      objacfLoanDashboardController.Test11();
      objacfLoanDashboardController.Test12();
      objacfLoanDashboardController.Test13();
      objacfLoanDashboardController.Test14();
      objacfLoanDashboardController.Test15();
      objacfLoanDashboardController.Test16();
      objacfLoanDashboardController.Test17();
      objacfLoanDashboardController.Test18();
      objacfLoanDashboardController.Test19();
      objacfLoanDashboardController.Test20();
      objacfLoanDashboardController.Test21();
      objacfLoanDashboardController.Test22();
      objacfLoanDashboardController.Test23();
      objacfLoanDashboardController.Test24();
      objacfLoanDashboardController.Test25();
      objacfLoanDashboardController.Test26();
      objacfLoanDashboardController.Test27();
      objacfLoanDashboardController.Test28();
      objacfLoanDashboardController.Test29();
      objacfLoanDashboardController.Test30();
      objacfLoanDashboardController.Test31();
      objacfLoanDashboardController.Test32();
      
        
    }
    
    static testMethod void validateLoanDashboard1()
    {   
     
        LoadData();
        
        acfLoanDashboardController_Broker.WrapperProducts wrapp = new acfLoanDashboardController_Broker.WrapperProducts();
        wrapp.decRate =10.0;
        wrapp.ProductName ='test';
        wrapp.strRateType = 'test';
        wrapp.decComparisionRate = 10;
        wrapp.strcomparisionType='test';
        wrapp.strRating = 'test';
        wrapp.decMonthlyPayment = 101;
        wrapp.ProductId = objProduct2.id;
        wrapp.ProdLVRID = objProduct2.id;
        wrapp.TenureInMonth = 10.25;
        wrapp.LoanFees = 10.25;
        wrapp.IndexNo =10;
        wrapp.EstimatedSaving = 10.25;
        wrapp.TenureInYears = 10.25;
        wrapp.Feature_1 ='test';
        wrapp.Feature_2 ='test';
        wrapp.Feature_3 ='test';
        wrapp.AddRepayments = true;
        wrapp.DebitCard = true;
        wrapp.Redraw = true;
        wrapp.InterestOnly = true;
        wrapp.OffsetAccount = true;
        wrapp.MultipleSplits = true;
               
  //      RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Fixed'];
        product2 objPro = new product2();
        objPro.ACF_Comparison_Rate__c = 10;
        objPro.IsActive = true;
        objPro.acfType__c = 'Fixed';
 //       objPro.Recordtype.Name = objRT.name;
        objPro.acfTenure_in_Years__c = '2'; 
        objPro.acfvarTenure_In_Years__c = 10;
    //    objPro.clickLoan_Type__c =  'Basic';
        objPro.acfOffset_Account__c = false;
        objPro.Name = 'test';
  //      objPro.acfRating__c = '1';
        insert objPro;  
        
        RecordType objRec=[Select Name,Id From RecordType where sObjectType='Product2' and isActive=true and Name='Fixed'];
        objProduct2.RecordTypeId=objRec.Id;
        objProduct2.acfvarTenure_In_Years__c=1;
        update objProduct2;
        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.acfLVR__c = 1500.25;
        objLVR.acfRate__c = 10.25;
        objLVR.acfProduct__c = objProduct2.id;
        objLVR.acfLoan_Size__c = 10000.20;
        objLVR.ACF_Comparison_Rate__c = 10.00; 
        objLVR.clickFixed_Interest_Rate__c = 9.00;
        objLVR.clickLoan_Size_From__c = 50.50;
        objLVR.clickLVR_From__c = 10.2;
        objLVR.acfApplication_Fee__c = 5000;
        //objLVR.clickFixed_Interest_Rate__c=4; 
        /*objLVR.acfOngoing_Fees_annual__c=1000;
        objLVR.acfLegal_Fees__c=100;
        objLVR.acfAnnual_Fees__c=1200;
        objLVR.acfMonthly_Fees__c=200;
        objLVR.acfEstablishment_Fee__c=100;
        objLVR.acfMortgage_Risk_Fee__c=10;
        objLVR.acfTitle_Protection_Fee__c=40;
        objLVR.acfValuation_Fee__c=1290;*/
        insert objLVR; 
        
          Click_Community_Setup__c objccs=new Click_Community_Setup__c();
        objccs.Name='ClickLoans';
        objccs.Click_Page_Prefix__c = 'Click';
        objccs.Click_Network_ID__c='0DB900000008Ptg';
        insert objccs;
        
        objBankDetail = new acfBank_Detail__c();
        objBankDetail.acfBank_Name__c = 'Bank of Statements';
        objBankDetail.acfBankSlugName__c = 'bank_of_statements';
        objBankDetail.click_Show_on_Current_Lender_question__c = true;
        insert objBankDetail;
        
        ApexPages.currentPage().getParameters().put('cid',objaccount.id);
        
        set<string> setProductIdToExclude = new set<string>();
        setProductIdToExclude.add(objLVR.acfProduct__c);
        
       
        acfLoanDashboardController_Broker objacfLoanDashboardController = new acfLoanDashboardController_Broker();      
        objacfLoanDashboardController.acid=objaccount.id;
        objacfLoanDashboardController.strLVRProductId ='Ankit';
        objacfLoanDashboardController.EstimatedSaving =10;
        objacfLoanDashboardController.strCustomLabelValue ='Ankit';
        objacfLoanDashboardController.DateConditionallyApproved ='Ankit';
        objacfLoanDashboardController.DateFormallyApproved ='Ankit';
        objacfLoanDashboardController.DateDocsGenerated ='Ankit';
        objacfLoanDashboardController.DateExpectedSettlement ='Ankit';
        objacfLoanDashboardController.strConditionsOfApproval ='Ankit';
        objacfLoanDashboardController.strDescription ='Ankit';
        objacfLoanDashboardController.NoOfYears = 10;
        
        objacfLoanDashboardController.OpportunityId = objOpportunity.Id;
        objacfLoanDashboardController.prodListIndex = -5;
        
     /* objacfLoanDashboardController.stwrapper[0].selected = true;
        objacfLoanDashboardController.stwrapper[1].selected = true;
        objacfLoanDashboardController.stwrapper[2].selected = true; */
        objacfLoanDashboardController.prodListIndex = 0;
//        objacfLoanDashboardController.ChooseProduct();
 //       objacfLoanDashboardController.OnProductSelection();
        objacfLoanDashboardController.IsValidDecimal(20.1);
        objacfLoanDashboardController.DisplayLoanProducts(objOpportunity.id,20,20,200.00,'Cash');
        objacfLoanDashboardController.redirect();       
        objacfLoanDashboardController.DisplayOpportunityLIProducts(objOpportunity.id,10.01,'Cash');
 //       objacfLoanDashboardController.DisplayEstimatedSaving(10.01,10.06,10.36,'Cash',1.5); 
        objacfLoanDashboardController.ConvertDateToString(system.today());  
        
    }
    
    
      static testMethod void validateLoanDashboard2()
    {   
     
        LoadData();
        
        acfLoanDashboardController_Broker.WrapperProducts wrapp = new acfLoanDashboardController_Broker.WrapperProducts();
        wrapp.decRate =10.0;
        wrapp.ProductName ='test';
        wrapp.strRateType = 'test';
        wrapp.decComparisionRate = 10;
        wrapp.strcomparisionType='test';
        wrapp.strRating = 'test';
        wrapp.decMonthlyPayment = 101;
        wrapp.ProductId = objProduct2.id;
        wrapp.ProdLVRID = objProduct2.id;
        wrapp.TenureInMonth = 10.25;
        wrapp.LoanFees = 10.25;
        wrapp.IndexNo =10;
        wrapp.EstimatedSaving = 10.25;
        wrapp.TenureInYears = 10.25;
        wrapp.Feature_1 ='test';
        wrapp.Feature_2 ='test';
        wrapp.Feature_3 ='test';
        wrapp.AddRepayments = true;
        wrapp.DebitCard = true;
        wrapp.Redraw = true;
        wrapp.InterestOnly = true;
        wrapp.OffsetAccount = true;
        wrapp.MultipleSplits = true;
               
 
        product2 objPro = new product2();
        objPro.ACF_Comparison_Rate__c = 10;
        objPro.IsActive = true;
        objPro.acfType__c = 'Fixed';
        objPro.acfTenure_in_Years__c = '2'; 
        objPro.acfvarTenure_In_Years__c = 10;
     //  objPro.clickLoan_Type__c =  'Basic';
        objPro.acfOffset_Account__c = false;
        objPro.Name = 'test';
     //   objPro.acfRating__c = '1';
        insert objPro;  
        

        objProduct2.acfvarTenure_In_Years__c=1;
        objProduct2.ClickFeature_1__c='test1';
        objProduct2.ClickFeature_2__c='test2';
        objProduct2.ClickFeature_3__c='test3';
        update objProduct2;
        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.acfLVR__c = 1500.25;
        objLVR.acfRate__c = 10.25;
        objLVR.acfProduct__c = objProduct2.id;
        objLVR.acfLoan_Size__c = 10000.20;
        objLVR.ACF_Comparison_Rate__c = 10.00; 
        objLVR.clickFixed_Interest_Rate__c = 9.00;
        objLVR.clickLoan_Size_From__c = 50.50;
        objLVR.clickLVR_From__c = 10.2;
        objLVR.acfApplication_Fee__c = 5000; 
    //    objLVR.acfOngoing_Fees_annual__c=100000;
        objLVR.acfLegal_Fees__c=100;
        objLVR.acfAnnual_Fees__c=1200;
        objLVR.acfMonthly_Fees__c=200;
        objLVR.acfEstablishment_Fee__c=100;
        objLVR.acfMortgage_Risk_Fee__c=10;
        objLVR.acfTitle_Protection_Fee__c=40;
        objLVR.acfValuation_Fee__c=1290;
        insert objLVR; 
        
          Click_Community_Setup__c objccs=new Click_Community_Setup__c();
        objccs.Name='ClickLoans';
        objccs.Click_Page_Prefix__c = 'Click';
        objccs.Click_Network_ID__c='0DB900000008Ptg';
        insert objccs;
        
        objBankDetail = new acfBank_Detail__c();
        objBankDetail.acfBank_Name__c = 'Bank of Statements';
        objBankDetail.acfBankSlugName__c = 'bank_of_statements';
        objBankDetail.click_Show_on_Current_Lender_question__c = true;
        insert objBankDetail;
        
        ApexPages.currentPage().getParameters().put('cid',objaccount.id);
        
        set<string> setProductIdToExclude = new set<string>();
        setProductIdToExclude.add(objLVR.acfProduct__c);
        
       
        acfLoanDashboardController_Broker objacfLoanDashboardController = new acfLoanDashboardController_Broker();      
        objacfLoanDashboardController.acid=objaccount.id;
        objacfLoanDashboardController.strLVRProductId ='Ankit';
        objacfLoanDashboardController.EstimatedSaving =10;
        objacfLoanDashboardController.strCustomLabelValue ='Ankit';
        objacfLoanDashboardController.DateConditionallyApproved ='Ankit';
        objacfLoanDashboardController.DateFormallyApproved ='Ankit';
        objacfLoanDashboardController.DateDocsGenerated ='Ankit';
        objacfLoanDashboardController.DateExpectedSettlement ='Ankit';
        objacfLoanDashboardController.strConditionsOfApproval ='Ankit';
        objacfLoanDashboardController.strDescription ='Ankit';
        objacfLoanDashboardController.NoOfYears = 10;
        
        objacfLoanDashboardController.OpportunityId = objOpportunity.Id;
        objacfLoanDashboardController.prodListIndex = -5;
        
        objacfLoanDashboardController.prodListIndex = 0;
//        objacfLoanDashboardController.ChooseProduct();
 //       objacfLoanDashboardController.OnProductSelection();
        objacfLoanDashboardController.IsValidDecimal(20.1);
        objacfLoanDashboardController.DisplayLoanProducts(objOpportunity.id,20,20,200.00,'Cash');
        objacfLoanDashboardController.redirect();       
        objacfLoanDashboardController.DisplayOpportunityLIProducts(objOpportunity.id,10.01,'Cash');
 //       objacfLoanDashboardController.DisplayEstimatedSaving(10.01,10.06,10.36,'Cash',1.5); 
        objacfLoanDashboardController.ConvertDateToString(system.today());  
   
    }
    
    
        
      static testMethod void validateLoanDashboard3()
    {   
     
        LoadData1();
      
      Opportunity objOpportunity1 = new Opportunity();
      objOpportunity1.AccountId =objUser.Accountid;
      objOpportunity1.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
      objOpportunity1.Description = 'test';
      objOpportunity1.acfTenure__c = 2.5;
      objOpportunity1.name = 'test';
      objOpportunity1.Stagename = 'Application Taken';
      objOpportunity1.CloseDate = System.today();
       
        acfLoanDashboardController_Broker.WrapperProducts wrapp = new acfLoanDashboardController_Broker.WrapperProducts();
        wrapp.decRate =10.0;
        wrapp.ProductName ='test';
        wrapp.strRateType = 'test';
        wrapp.decComparisionRate = 10;
        wrapp.strcomparisionType='test';
        wrapp.strRating = 'test';
        wrapp.decMonthlyPayment = 101;
        wrapp.ProductId = objProduct2.id;
        wrapp.ProdLVRID = objProduct2.id;
        wrapp.TenureInMonth = 10.25;
        wrapp.LoanFees = 10.25;
        wrapp.IndexNo =10;
        wrapp.EstimatedSaving = 10.25;
        wrapp.TenureInYears = 10.25;
        wrapp.Feature_1 ='test';
        wrapp.Feature_2 ='test';
        wrapp.Feature_3 ='test';
        wrapp.AddRepayments = true;
        wrapp.DebitCard = true;
        wrapp.Redraw = true;
        wrapp.InterestOnly = true;
        wrapp.OffsetAccount = true;
        wrapp.MultipleSplits = true;
               
        product2 objPro = new product2();
        objPro.ACF_Comparison_Rate__c = 10;
        objPro.IsActive = true;
        objPro.acfType__c = 'Fixed';
        objPro.acfTenure_in_Years__c = '2'; 
        objPro.acfvarTenure_In_Years__c = 10;
      //  objPro.clickLoan_Type__c =  'Basic';
        objPro.acfOffset_Account__c = false;
        objPro.Name = 'test';
     //   objPro.acfRating__c = '1';
        insert objPro;  
        
        
        objProduct2.acfvarTenure_In_Years__c=1;
        objProduct2.ClickFeature_1__c='test1';
        objProduct2.ClickFeature_2__c='test2';
        objProduct2.ClickFeature_3__c='test3';
        update objProduct2;
        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.acfLVR__c = 1500.25;
        objLVR.acfRate__c = 10.25;
        objLVR.acfProduct__c = objProduct2.id;
        objLVR.acfLoan_Size__c = 10000.20;
        objLVR.ACF_Comparison_Rate__c = 10.00; 
        objLVR.clickFixed_Interest_Rate__c = 9.00;
        objLVR.clickLoan_Size_From__c = 50.50;
        objLVR.clickLVR_From__c = 10.2;
        objLVR.acfApplication_Fee__c = 5000; 
  //      objLVR.acfOngoing_Fees_annual__c=100000;
        objLVR.acfLegal_Fees__c=100;
        objLVR.acfAnnual_Fees__c=1200;
        objLVR.acfMonthly_Fees__c=200;
        objLVR.acfEstablishment_Fee__c=100;
        objLVR.acfMortgage_Risk_Fee__c=10;
        objLVR.acfTitle_Protection_Fee__c=40;
        objLVR.acfValuation_Fee__c=1290;
        insert objLVR; 
        
          Click_Community_Setup__c objccs=new Click_Community_Setup__c();
        objccs.Name='ClickLoans';
        objccs.Click_Page_Prefix__c = 'Click';
        objccs.Click_Network_ID__c='0DB900000008Ptg';
        insert objccs;
        
        objBankDetail = new acfBank_Detail__c();
        objBankDetail.acfBank_Name__c = 'Bank of Statements';
        objBankDetail.acfBankSlugName__c = 'bank_of_statements';
        objBankDetail.click_Show_on_Current_Lender_question__c = true;
        insert objBankDetail;
        
        ApexPages.currentPage().getParameters().put('cid',objaccount.id);
        
        set<string> setProductIdToExclude = new set<string>();
        setProductIdToExclude.add(objLVR.acfProduct__c);
        
           system.runAS(objUser)
        {
        acfLoanDashboardController_Broker objacfLoanDashboardController = new acfLoanDashboardController_Broker();      
        objacfLoanDashboardController.acid=objaccount.id;
        objacfLoanDashboardController.strLVRProductId ='Ankit';
        objacfLoanDashboardController.EstimatedSaving =10;
        objacfLoanDashboardController.strCustomLabelValue ='Ankit';
        objacfLoanDashboardController.DateConditionallyApproved ='Ankit';
        objacfLoanDashboardController.DateFormallyApproved ='Ankit';
        objacfLoanDashboardController.DateDocsGenerated ='Ankit';
        objacfLoanDashboardController.DateExpectedSettlement ='Ankit';
        objacfLoanDashboardController.strConditionsOfApproval ='Ankit';
        objacfLoanDashboardController.strDescription ='Ankit';
        objacfLoanDashboardController.NoOfYears = 10;
        
        objacfLoanDashboardController.OpportunityId = null;
        objacfLoanDashboardController.prodListIndex = -5;
        
        objacfLoanDashboardController.prodListIndex = 0;
//        objacfLoanDashboardController.ChooseProduct();
 //       objacfLoanDashboardController.OnProductSelection();
        objacfLoanDashboardController.IsValidDecimal(20.1);
  //      objacfLoanDashboardController.DisplayLoanProducts(objOpportunity.id,20,20,200.00,'Cash');
        objacfLoanDashboardController.redirect();       
 //       objacfLoanDashboardController.DisplayOpportunityLIProducts(objOpportunity.id,10.01,'Cash');
 //       objacfLoanDashboardController.DisplayEstimatedSaving(10.01,10.06,10.36,'Cash',1.5); 
        objacfLoanDashboardController.ConvertDateToString(system.today());  
   }
    }
  
    
    private static void LoadData()
    {
        
        createLead();
        createProduct();
       createAccount();
        createContact();
        createuser();
        createOpportunity();
        createOppLineItem();
        
    }
    
        private static void LoadData1()
    {
        
        createLead();
        createProduct();
        createAccount();
        createContact();
        createuser();
  //      createOpportunity();
  //      createOppLineItem();
        
    }
    
    static void  createproduct()
    {
      objProduct2= new Product2();
      objProduct2 = acfCommonTrackerClass.createproduct(objProduct2);      
    }
    
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = acfCommonTrackerClass.createLeadForPortal();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        //objAccount.recordtype.name='Business Account';
        objAccount.name='testname';
        insert objAccount;
        //objAccount = acfCommontrackerClass.createAccount(objaccount);
    }
    
    static void createContact()
    {
        
        objContact = new Contact();
        objContact.Lastname='hello';
        objContact.AccountId = objAccount.id;
        objContact.acf_lead__c = objLead.id;
        //objContact = acfCommontrackerClass.createPartnerContact(objContact,objAccount);
        objContact.acfCurrent_Loan_Amount__c=200000;
        objContact.acfApproximately_how_much_is_your_house__c=400000;
        insert objContact; 
        
        
        
    }
    
    static void createuser()
    {
        objUser = new User();
        objUser.MobilePhone='+611234567890';
        
        objUser.contactId=objContact.Id;
         List<Profile> lstCommUserProfile = [select id,name from profile where name='Customize Partner User' limit 1];
            //List<Account>lstPersonContact = [select id,PersonContactId from Account where id=:ContactId];
            //User objUser = new User();
            objUser.FirstName = 'test';
            objUser.LastName = 'test';
            objUser.Alias  = ('test'+String.valueof(Math.random())).substring(0,5);
            objUser.LocaleSidKey = 'en_AU';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.MobilePhone = '+6145678904';
            objUser.Username = 'test@fakeEmail.com'+objUser.Alias;
            objUser.Email = 'test@fakeEmail.com';
            objUser.ProfileId = lstCommUserProfile[0].id;
            //objUser.ContactId = lstPersonContact[0].PersonContactId;
            objuser.EmailEncodingKey = 'UTF-8';
            objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
            objUser.TimeZoneSidKey = 'Australia/Brisbane';
            objUser.acfIs_Password_Reset__c = true;
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = false;
            objUser.setOptions(dlo);
            insert(objUser);
            //return objUser;
        
        
        
        //objUser = acfCommonTrackerClass.CreatePartnerPortalUser(objContact.id); 
    }
    
     static void createOpportunity()
    {

      
      objOpportunity = new Opportunity();
      objOpportunity.AccountId =objaccount.id;
      objOpportunity.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
      objOpportunity.acfDate_Conditionally_Approved__c = system.today();
      objOpportunity.Description = 'test';
      objOpportunity.acfApproval_Conditions__c = 'testing';
      objOpportunity.acfDate_Formally_Approved__c = system.today();
      objOpportunity.acfDate_Docs_Generated__c = system.today();
      objOpportunity.acfExpected_Settlement_Date__c = system.today().adddays(+3);
      objOpportunity.acf_Status__c = 'Conditionally Approved';
      objOpportunity.acfTenure__c = 2.5;
      objOpportunity.name = 'test';
      objOpportunity.Stagename = 'Application Taken';
      objOpportunity.CloseDate = System.today();
      //objOpportunity.      
      insert objOpportunity;
      system.debug('Ankit====================================='+objUser.Accountid);
      system.debug('Ankit====================================='+objOpportunity.AccountId);
    }  
    
    static void createOppLineItem()
    {
    pbk1= [select id,name from priceBook2 where isActive= true and isStandard = true limit 1];
    

    prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1');
    insert prd1;

    pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=pbk1.id,UnitPrice=50,isActive=true);
    insert pbe1;

    lineItem1 = new OpportunityLineItem (OpportunityID=objOpportunity.id,PriceBookEntryID=pbe1.id,Quantity=1,TotalPrice=100);
    insert lineItem1;
    }  
    
    
}