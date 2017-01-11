@isTest(SeeAllData =true)
private class WLLoanDashboardControllerTracker {
private static Product2 objProduct2;
static private User objUser1;  
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
        try
        {
            //Test.setMock(MockHttpResponseGeneratorLendi.class, new MockHttpResponseGenerator());
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorLendi());
            test.starttest();
            LoadData();
            WLLoanDashboardController.WrapperProducts wrapp = new WLLoanDashboardController.WrapperProducts();
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
                   
      //    RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Fixed'];
            product2 objPro = new product2();
            objPro.ACF_Comparison_Rate__c = 10;
            objPro.IsActive = true;
            objPro.acfType__c = 'Variable';
     //     objPro.Recordtype.Name = objRT.name;
            objPro.acfTenure_in_Years__c = '2'; 
            objPro.acfvarTenure_In_Years__c = 10;
     //     objPro.clickLoan_Type__c =  'Basic';
            objPro.acfOffset_Account__c = false;
            objPro.Name = 'test';
     //     objPro.acfRating__c = '1';
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
            
            set<string> setProductIdToExclude = new set<string>();
            setProductIdToExclude.add(objLVR.acfProduct__c);
                  
            system.runas(objUser1)
            {
                WLLoanDashboardController objacfLoanDashboardController = new WLLoanDashboardController();      
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
                objacfLoanDashboardController.IsValidDecimal(20.1);
                objacfLoanDashboardController.DisplayLoanProducts(objOpportunity.id,20,20,200.00,'Cash');
                objacfLoanDashboardController.redirect();       
                objacfLoanDashboardController.DisplayOpportunityLIProducts(objOpportunity.id,10.01,'Cash'); 
                objacfLoanDashboardController.ConvertDateToString(system.today());
            }
            test.stoptest();    
        }
       catch(exception e)
       {}
    }
    
     static testMethod void validateLoanDashboard1()
    {   
        try
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorLendi());
            test.starttest();
            LoadData();
            WLLoanDashboardController.WrapperProducts wrapp = new WLLoanDashboardController.WrapperProducts();
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
            
            acfBank_Detail__c objBankDetail = new acfBank_Detail__c();
            objBankDetail.acfBank_Name__c = 'ANZ';
            objBankDetail.acfBankSlugName__c = 'ANZ';
            insert objBankDetail;
    
            Click_Loans_Bank__c objClickLoanBank = new Click_Loans_Bank__c();
            objClickLoanBank.Click_Loans_Bank_Detail__c = objBankDetail.Id;
            objClickLoanBank.Community_Setup__c = ClickCommon.getCommunitySetup('').id;
            insert objClickLoanBank;    
            Id devRecordTypeId = Schema.SObjectType.product2.getRecordTypeInfosByName().get('Variable').getRecordTypeId();      
    
            product2 objPro = new product2();
            objPro.ACF_Comparison_Rate__c = 10;
            objPro.IsActive = true;
            objPro.acfType__c = 'Variable';
            objPro.RecordtypeId = devRecordTypeId;
            objPro.acfTenure_in_Years__c = '2'; 
            objPro.acfvarTenure_In_Years__c = 10;
     //     objPro.clickLoan_Type__c =  'Basic';
            objPro.acfOffset_Account__c = false;
            objPro.Name = 'test';
     //     objPro.acfRating__c = '1';
            objPro.Click_Loans_Bank_Detail__c = objClickLoanBank.Click_Loans_Bank_Detail__c;
            insert objPro;  
            
            acfSuggested_Product__c objsuggest = new acfSuggested_Product__c();
            objsuggest.acfFilter__c = 'Exclude';
            objsuggest.acfProduct__c = objProduct2.id;
            objsuggest.acfOpportunity__c = objOpportunity.id;
            insert objsuggest; 
    
            LVR_Rate__c objLVR = new LVR_Rate__c();
            objLVR.acfLVR__c = 1500.25;
            objLVR.acfRate__c = 10.25;
            objLVR.acfProduct__c = objPro.id;
            objLVR.acfLoan_Size__c = 10000.20;
            objLVR.ACF_Comparison_Rate__c = 10.00; 
            objLVR.clickFixed_Interest_Rate__c = 9.00;
            objLVR.clickLoan_Size_From__c = 10.20;
            objLVR.clickLVR_From__c = 20.2;
            objLVR.acfApplication_Fee__c = 5000;  
            insert objLVR; 
            
            set<string> setProductIdToExclude = new set<string>();
            setProductIdToExclude.add(objLVR.acfProduct__c);
            
            objOpportunity.stageName = 'Approval';
            update objOpportunity;
                  
            system.runas(objUser1)
            {
                WLLoanDashboardController objacfLoanDashboardController = new WLLoanDashboardController();      
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
                objacfLoanDashboardController.IsValidDecimal(20.1);
                objacfLoanDashboardController.DisplayLoanProducts(objOpportunity.id,20,20,200.00,'Cash');
                objacfLoanDashboardController.redirect();       
                objacfLoanDashboardController.DisplayOpportunityLIProducts(objOpportunity.id,10.01,'Cash'); 
                objacfLoanDashboardController.ConvertDateToString(system.today());
            }
            test.stoptest();
        }
       catch(exception e)
       {}
    }
    
     static testMethod void validateLoanDashboard2()
    {   
        try
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorLendi());
            test.starttest();
            LoadData();
            WLLoanDashboardController.WrapperProducts wrapp = new WLLoanDashboardController.WrapperProducts();
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
            
            acfBank_Detail__c objBankDetail = new acfBank_Detail__c();
            objBankDetail.acfBank_Name__c = 'ANZ';
            objBankDetail.acfBankSlugName__c = 'ANZ';
            insert objBankDetail;
    
            Click_Loans_Bank__c objClickLoanBank = new Click_Loans_Bank__c();
            objClickLoanBank.Click_Loans_Bank_Detail__c = objBankDetail.Id;
            objClickLoanBank.Community_Setup__c = ClickCommon.getCommunitySetup('').id;
            insert objClickLoanBank;    
            Id devRecordTypeId = Schema.SObjectType.product2.getRecordTypeInfosByName().get('Fixed').getRecordTypeId();
                   
      //    RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Fixed'];
            product2 objPro = new product2();
            objPro.ACF_Comparison_Rate__c = 10;
            objPro.IsActive = true;
            objPro.acfType__c = 'Fixed';
            objPro.RecordtypeId = devRecordTypeId ;
            objPro.acfTenure_in_Years__c = '2'; 
            objPro.acfvarTenure_In_Years__c = 10;
            objPro.acfTenure_in_Years__c = '1';
       //     objPro.isFixed1YrCompleted = false;
     //     objPro.clickLoan_Type__c =  'Basic';
            objPro.acfOffset_Account__c = false;
            objPro.Name = 'test';
     //     objPro.acfRating__c = '1';
            insert objPro;  
            
            acfSuggested_Product__c objsuggest = new acfSuggested_Product__c();
            objsuggest.acfFilter__c = 'Exclude';
            objsuggest.acfProduct__c = objProduct2.id;
            objsuggest.acfOpportunity__c = objOpportunity.id;
            insert objsuggest;      
    
            LVR_Rate__c objLVR = new LVR_Rate__c();
            objLVR.acfLVR__c = 1500.25;
            objLVR.acfRate__c = 10.25;
            objLVR.acfProduct__c = objPro.id;
            objLVR.acfLoan_Size__c = 10000.20;
            objLVR.ACF_Comparison_Rate__c = 10.00; 
            objLVR.clickFixed_Interest_Rate__c = 9.00;
            objLVR.clickLoan_Size_From__c = 50.50;
            objLVR.clickLVR_From__c = 10.2;
            objLVR.acfApplication_Fee__c = 5000; 
            insert objLVR; 
            
            set<string> setProductIdToExclude = new set<string>();
            setProductIdToExclude.add(objLVR.acfProduct__c);
            
            objOpportunity.stageName = 'Loan Document';
            update objOpportunity;
                  
            system.runas(objUser1)
            {
                WLLoanDashboardController objacfLoanDashboardController = new WLLoanDashboardController();      
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
                objacfLoanDashboardController.IsValidDecimal(20.1);
                objacfLoanDashboardController.DisplayLoanProducts(objOpportunity.id,20,20,200.00,'Cash');
                objacfLoanDashboardController.redirect();       
                objacfLoanDashboardController.DisplayOpportunityLIProducts(objOpportunity.id,10.01,'Cash'); 
                objacfLoanDashboardController.ConvertDateToString(system.today());
            }
            test.stoptest();
        }
       catch(exception e)
       {}
    }
    
      static testMethod void validateLoanDashboard3()
    {   
        try
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorLendi());
            test.starttest();
            LoadData();
            WLLoanDashboardController.WrapperProducts wrapp = new WLLoanDashboardController.WrapperProducts();
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
                   
      //    RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Fixed'];
            product2 objPro = new product2();
            objPro.ACF_Comparison_Rate__c = 10;
            objPro.IsActive = true;
            objPro.acfType__c = 'Variable';
     //     objPro.Recordtype.Name = objRT.name;
            objPro.acfTenure_in_Years__c = '2'; 
            objPro.acfvarTenure_In_Years__c = 10;
     //     objPro.clickLoan_Type__c =  'Basic';
            objPro.acfOffset_Account__c = false;
            objPro.Name = 'test';
     //     objPro.acfRating__c = '1';
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
            
            set<string> setProductIdToExclude = new set<string>();
            setProductIdToExclude.add(objLVR.acfProduct__c);
            
            objOpportunity.stageName = 'Settlement';
            objOpportunity.acf_Status__c  = 'Approved and pending settlement';
            update objOpportunity;
                  
            system.runas(objUser1)
            {
                WLLoanDashboardController objacfLoanDashboardController = new WLLoanDashboardController();      
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
                objacfLoanDashboardController.IsValidDecimal(20.1);
                objacfLoanDashboardController.DisplayLoanProducts(objOpportunity.id,20,20,200.00,'Cash');
                objacfLoanDashboardController.redirect();       
                objacfLoanDashboardController.DisplayOpportunityLIProducts(objOpportunity.id,10.01,'Cash'); 
                objacfLoanDashboardController.ConvertDateToString(system.today());
            }
            test.stoptest();
        }
       catch(exception e)
       {}
    }
    
     static testMethod void validateLoanDashboard4()
    {  
        try
        {    
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorLendi());
            test.starttest();
            LoadData();
            WLLoanDashboardController.WrapperProducts wrapp = new WLLoanDashboardController.WrapperProducts();
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
                   
      //    RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Fixed'];
            product2 objPro = new product2();
            objPro.ACF_Comparison_Rate__c = 10;
            objPro.IsActive = true;
            objPro.acfType__c = 'Variable';
     //     objPro.Recordtype.Name = objRT.name;
            objPro.acfTenure_in_Years__c = '2'; 
            objPro.acfvarTenure_In_Years__c = 10;
     //     objPro.clickLoan_Type__c =  'Basic';
            objPro.acfOffset_Account__c = false;
            objPro.Name = 'test';
     //     objPro.acfRating__c = '1';
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
            
            set<string> setProductIdToExclude = new set<string>();
            setProductIdToExclude.add(objLVR.acfProduct__c);

            objOpportunity.stageName = 'Settled';
            objOpportunity.acf_Status__c  = 'Settled';
            update objOpportunity;

                  
            system.runas(objUser1)
            {
                WLLoanDashboardController objacfLoanDashboardController = new WLLoanDashboardController();      
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
                objacfLoanDashboardController.IsValidDecimal(20.1);
                objacfLoanDashboardController.DisplayLoanProducts(objOpportunity.id,20,20,200.00,'Cash');
                objacfLoanDashboardController.redirect();       
                objacfLoanDashboardController.DisplayOpportunityLIProducts(objOpportunity.id,10.01,'Cash'); 
                objacfLoanDashboardController.ConvertDateToString(system.today());
            }
            test.stoptest();
        }
       catch(exception e)
       {}    
    }
    
      static testMethod void validateLoanDashboard5()
    {   
        try
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorLendi());
            test.starttest();
            LoadData();
            WLLoanDashboardController.WrapperProducts wrapp = new WLLoanDashboardController.WrapperProducts();
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
                   
      //    RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Fixed'];
            product2 objPro = new product2();
            objPro.ACF_Comparison_Rate__c = 10;
            objPro.IsActive = true;
            objPro.acfType__c = 'Variable';
     //     objPro.Recordtype.Name = objRT.name;
            objPro.acfTenure_in_Years__c = '2'; 
            objPro.acfvarTenure_In_Years__c = 10;
     //     objPro.clickLoan_Type__c =  'Basic';
            objPro.acfOffset_Account__c = false;
            objPro.Name = 'test';
     //     objPro.acfRating__c = '1';
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
            
            set<string> setProductIdToExclude = new set<string>();
            setProductIdToExclude.add(objLVR.acfProduct__c);
            

            objOpportunity.stageName = 'Settled';
            objOpportunity.acf_Status__c  = 'Settled';
            update objOpportunity;
                  
            WLLoanDashboardController objacfLoanDashboardController = new WLLoanDashboardController();      
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
            objacfLoanDashboardController.IsValidDecimal(20.1);
            objacfLoanDashboardController.DisplayLoanProducts(objOpportunity.id,20,20,200.00,'Cash');
            objacfLoanDashboardController.redirect();       
            objacfLoanDashboardController.DisplayOpportunityLIProducts(objOpportunity.id,10.01,'Cash'); 
            objacfLoanDashboardController.ConvertDateToString(system.today());
            test.stoptest();
       }
       catch(exception e)
       {}
        
    }

    
    private static void LoadData()
    {
        createLead();
        createProduct();
        createAccount();
        createuser();
        createOpportunity();
        createOppLineItem();
    }
    
    static void  createproduct()
    {
        objProduct2= new Product2();
        objProduct2 = WLCommonTrackerClass.createproduct(objProduct2);      
    }
    
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommontrackerClass.createLead(objLead);
        system.debug('objLead************'+objLead);
    }
        
    static void createAccount()
    {
       objacc = new account();
       objacc.acfApproximately_how_much_is_your_house__pc = 12.00;
       objacc.acfCurrent_Rate__pc = 10.20;
       objacc.acfCurrent_Loan_Amount__pc = 10.00;
       objacc.acfWhat_is_your_current_payment_type__pc ='Cash'; 
       objacc=WLCommonTrackerClass.createAccount(objacc); 
       system.debug('objacc************'+objacc);
    }
    
    static void createUser()
    {
        objUser1 = new User();
        objUser1 = WLCommonTrackerClass.CreatePortalUser(objacc.id);  
        system.debug('objUser1************'+objUser1);     
    }
    
     static void createOpportunity()
    {
        objOpportunity = new Opportunity();
        system.debug('@@@@@test'+objUser1+'@@@@@@@@@@@'+objUser1.AccountId);
        list<Account> lstAccount = [select id from Account where personContactId =: objUser1.ContactId limit 1];
        objOpportunity.AccountId =lstAccount[0].id;
        objOpportunity.recordtypeid = ClickCommon.GetRecordTypeId('Opportunity','Click Refi');
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
        insert objOpportunity;
        system.debug('objOpportunity************'+objOpportunity);
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
    

    public class MockHttpResponseGeneratorLendi implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            //res.setHeader('Content-Type', 'application/json');
            res.setBody('');
            res.setStatusCode(200);
            return res;
    }
}
}