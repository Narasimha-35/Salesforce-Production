@isTest
private  without sharing class acfAssetLiabilitiesControllerTracker 
{
    private static Lead objLead;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;

    
    static testMethod void validate() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        

        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
        if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10000;
        wrap.strBalance =10000;
        wrap.strLimit = 10000;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
        objass.strSelectedChildType = 'Home';
        objass.LoadAssetAndLiabilities();
        wrap.strAmount=10000;
        wrap.strBalance=10000;
        wrap.strLimit=10000;
        objass.objwrapperAssetLiabilities=wrap;
        
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
    
  }  
        static testMethod void validate1() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
        if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
        objass.strSelectedChildType = 'Investment Property1';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Investment Property1';
        objass.assetaddMethod();
        objass.resetPopupMethod();

//    }
    }
    
         static testMethod void validate2() 
    {
       
        LoadData();
  //      System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
        objass.strSelectedChildType = 'Investment Property2';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Investment Property2';
        objass.assetaddMethod();
        objass.resetPopupMethod();

//    }
   }
    
    
             static testMethod void validate3() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
        objass.strSelectedChildType = 'Investment Property3';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Investment Property3';
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
   }
    
    
         static testMethod void validate4() 
      {
       
        LoadData();
//        System.runAs(objuser) 
  //      {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Cash';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Cash';
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
    }
    
    
    static testMethod void validate5() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
//        {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Super';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType = 'Super';
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
  }
    
    
       static testMethod void validate6() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
        objass.strSelectedChildType = 'Investment1';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Investment1';
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
   }
    
    
      static testMethod void validate7() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Investment2';

        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Investment2';
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
    }
    
    
      static testMethod void validate8() 
    {
       
        LoadData();
//        System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Other';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Other';
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
    }
             static testMethod void validate9() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strLimit = 10.01;
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Home Mortgage';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Home Mortgage';
        objass.assetaddMethod();
        objass.resetPopupMethod();

  //  }
    }
    
             static testMethod void validate10() 
    {
       
        LoadData();
   //     System.runAs(objuser) 
  //      {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strLimit = 10.01;
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'IP Mortgage1';
        objass.LoadAssetAndLiabilities();
         objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='IP Mortgage1';
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
    }
    
    
             static testMethod void validate11() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strLimit = 10.01;
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'IP Mortgage2';
        objass.LoadAssetAndLiabilities();
         objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='IP Mortgage2';
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
    }
    
    
             static testMethod void validate12() 
    {
       
        LoadData();
//        System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'IP Mortgage3';
        objass.LoadAssetAndLiabilities();
         objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='IP Mortgage3';
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
    }
    
    
      
             static testMethod void validate13() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Personal Loan1';
        objass.LoadAssetAndLiabilities();
         objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Personal Loan1';
        objass.assetaddMethod();
        objass.resetPopupMethod();
 //       }

    }
    
    
      
             static testMethod void validate14() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strLimit = 10.01;
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Personal Loan2';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Personal Loan2';
        objass.assetaddMethod();
        objass.resetPopupMethod();
  //      }

    }
    
    
      
             static testMethod void validate15() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
//        {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Personal Loan3';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Personal Loan3';
        objass.assetaddMethod();
        objass.resetPopupMethod();

//    }
    }
    
    
      
             static testMethod void validate16() 
    {
       
        LoadData();
//        System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Others1';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Others1';
        objass.assetaddMethod();
        objass.resetPopupMethod();

 //   }
    }
    
    
      
             static testMethod void validate17() 
    {
       
        LoadData();
   //     System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Others2';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Others2';
        objass.assetaddMethod();
        objass.resetPopupMethod();
//        }

    }
    
    
      
             static testMethod void validate18() 
    {
       
        LoadData();
//        System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = null;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Others3';
        objass.LoadAssetAndLiabilities();
        objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Others3';
        objass.assetaddMethod();
        objass.resetPopupMethod();
 //       }

    }
    
    
      
             static testMethod void validate19() 
    {
       
        LoadData();
//        System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = null;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
          if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = objas;
         objass.strSelectedChildType = 'Credit Card';
        objass.LoadAssetAndLiabilities();
         objass.objwrapperAssetLiabilities=wrap;
        objass.strSelectedChildType ='Credit Card';
        objass.assetaddMethod();
        objass.resetPopupMethod();
//        }

    }
    
       
      
             static testMethod void validate20() 
    {
       
        LoadData();
//        System.runAs(objuser) 
//        {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = null;
         objass.strSelectedChildType = 'Home';
        objass.LoadAssetAndLiabilities();
        objass.assetaddMethod();
        objass.resetPopupMethod();
 //       }

    }
    
          
             static testMethod void validate20a() 
    {
       
        LoadData();
 //       System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = null;
         objass.strSelectedChildType = 'Home Mortgage';
        objass.LoadAssetAndLiabilities();
        objass.assetaddMethod();
        objass.resetPopupMethod();
 //       }

    }
    
    
              
             static testMethod void validate21a() 
    {
       
        LoadData();
    //    System.runAs(objuser) 
   //     {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = null;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = 20000;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
              if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = null;
         objass.strSelectedChildType = 'Home';
        objass.LoadAssetAndLiabilities();
        objass.assetaddMethod();
        objass.resetPopupMethod();
  //      }

    }
    
              
             static testMethod void validate21b() 
    {
       
        LoadData();
  //      System.runAs(objuser) 
 //       {
        acfAssetLiabilitiesController.wrapTypeNameToExist wrper = new acfAssetLiabilitiesController.wrapTypeNameToExist();
        wrper.isTypeValueExist = true;
        wrper.isAssetType = true;
        wrper.typeValueName = 'test';
        wrper.typeImageClass = 'test';
        wrper.intSequanceNo = 10;
        
        
        acfAssetLiabilitiesController.wrapperAssetLiabilities wrap = new acfAssetLiabilitiesController.wrapperAssetLiabilities();
        wrap.strAssetType = 'test';
        wrap.strDescription = 'test';
        wrap.strSelectedAsset = 'test';
        wrap.strLiabilityType = 'test';
        wrap.strOFI = 'test';
        wrap.strAmount = 10.01;
        wrap.strBalance = 61.09;
        wrap.strLimit = 10.01;
        wrap.strMonthlyPayment= 10;
        wrap.StrAssetLiID = 'test';
        wrap.getAssetType();
        wrap.getLiabilityType();
        
        list<Asset_Liability_Statement__c> objas = new list<Asset_Liability_Statement__c>();
        Asset_Liability_Statement__c objassest = new Asset_Liability_Statement__c();
        objassest.Home_Value_Amount__c = 100000.01;
        objassest.Home_Location__c = 'Noida';
        objassest.Location_Property_1__c = 'U.P';
        objassest.Property_1_Amount__c = 1000000;
        objassest.Banking_Institution_Cash_Amount__c = 2000000;
        objassest.Super_Amount__c = 300000;
        objassest.Other_Investments_1__c = 'Property';
        objassest.Other_Investments_1_Amount__c = 10000.5;
        objassest.acfOther_Asset_Value_Amount__c = 10000; 
        objassest.Mortgage_on_Home_Amount__c = null;
        objassest.Location_Mortgage_on_Home__c = 'delhi';
        objassest.Location_Mortgage_1__c = 'Dehradun';
        objassest.Mortgage_1_Amount__c = 20000;
        objassest.Lender_Name_Loans_1__c = 'test';
        objassest.Loans_1_Amount__c = 10000;
        objassest.Other_Liabilities_1__c = 'House';
        objassest.Other_Liabilities_1_Amount__c = 5000;
        objassest.Credit_Cards_Combined_Limit__c = 3000;
        objassest.Credit_Cards_Combined_Balance__c = 3000;
        objassest.Credit_Cards_Combined__c ='Rupay';
        objassest.acfIsCreatedByPortalUser__c = true;
        objassest.AL_Statement_Owner__c = objAccount.id;
        objassest.Banking_Institution__c = 'SBI';
        objassest.acfCash_Description__c = 'cheque';
        objassest.acfSuperDescription__c = 'cheque';
        objassest.acfOther_Asset_Description__c = 'acers of land';
        objassest.acfMortgage_on_Home_Limit__c = 20000.09;
        objassest.acfLoans_1_limit__c = 10000.01;
        objassest.acfOther_Liabilities_1_limit__c = 20000;
        objassest.acfProperty_1_limit__c = 10000;
        objassest.clickLoans_2_Limit__c = 10000;
        objassest.clickLoans_3_limit__c = 10000;
        objassest.clickLocation_Mortgage_3__c = 'U.P';
        objassest.clickProperty_2_limit__c = 10000.01;
        objassest.clickMortgage_3_Amount__c = 10000;
        objassest.clickProperty_3_limit__c = 10000;
        objassest.clickOther_Liabilities_2_Limit__c = 10000;
        objassest.Property_2_Amount__c = 10000;
        objassest.clickOther_Liabilities_3_limit__c =10000;
        objassest.Property_3_Amount__c =10000;
        objassest.Other_Investments_2_Amount__c =10000;
        objassest.Other_Liabilities_3__c = 'test';
        objassest.Mortgage_2_Amount__c =1000;
        objassest.Loans_2_Amount__c = 10000;
        objassest.Loans_3_Amount__c =10000;
        objassest.Other_Liabilities_2_Amount__c =10000;
        objassest.Lender_name_Loans_2__c = 'test';
        objassest.Location_Mortgage_2__c = 'test';
        objassest.Other_Investments_2__c = 'delhi';
        objassest.Location_Property_3__c = 'narayanpur';
        objassest.Location_Property_2__c = 'mau';
        objassest.Lender_Name_Loans_3__c = 'u.p';
        objassest.Other_Liabilities_3_Amount__c = 10000;
        objas.add(objassest);
        
              if(objas.size() > 0 && objas!= null)
        {
          insert objas;
        }
        
        acfAssetLiabilitiesController objass = new acfAssetLiabilitiesController();
        objass.strSelectedParentType = 'test';
        objass.lstAssetsLiab = null;
         objass.strSelectedChildType = 'Home Mortgage';
        objass.LoadAssetAndLiabilities();
        objass.assetaddMethod();
        objass.resetPopupMethod();
   //     }

    }
    
   
    
    

 
    
    private static void LoadData()
    {   
        createLead(); 
        createAccount();
        createContact();
        createUser();
        createOpportunity();
    }
    
    
     static void createLead()
    {
        objLead = new Lead();
    //    Id recorsTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Click Loans').getRecordTypeId();

        Id recorsTypeId  = acfCommon.GetRecordTypeId('Lead','Click Refi');
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.Status = 'Open';
        objLead.RecordTypeId = recorsTypeId;
        objLead.acfOneTimePassword__c = '724715';  
        objLead.acfApproximately_how_much_is_your_house__c = 100.00;
        objLead.acfLoan_Amount__c = 100.21;
        insert objLead;
 //     objLead = acfCommonTrackerClass.createLeadForPortal();
    
    }
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = acfCommonTrackerClass.CreatePersonAccount('test1','test','+619540505050','test@fakeemail.com',objLead.id);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = acfCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = acfCommonTrackerClass.CreatePortalUser(objAccount.id); 
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    

    
}