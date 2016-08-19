@isTest
private class AssetAndLiabilityTriggerHandlerTracker
{

                private static click_Bank_Statement_Data__c objBankStmtData;
                private static click_Bank_Statements_Sub_Category__c objBankStmtSubCat;
                private static Asset_And_Liability__c objAssetLiab;
                private static Asset_And_Liability__c objAssetLiabs;
                private static Account objAccount;
                private static Account objAccount1;
                private static Funding_Position__c objFundingpos;
                private static Opportunity objOpportunity;
                private static Funding_Position_Detail__c objFundingPosDetail;
                private static Financials_Source__c objFinanceSource;
                private static User objUser;
                private static State__c objState;
                private static Lead objLead;
                private static Product2 objPro;
                private static OpportunityLineItem oppLine;
                private static PricebookEntry pbEntry ;
                private static Pricebook2 objPricebook;
                private static acfTask_Master__c objTaskMaster;
                private static Opportunity objOpp;
                private static Id contactId;
                private static contact objContact;
                static List<Funding_Position__c> lstFpos=new List<Funding_Position__c>();
        
        static testMethod void validate()
        
        {
                LoadData();
                
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                      
            
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Liabilities Mortgage Loan';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c ='Owner Occupied';
                objAssetLiab.Repayments__c=09876;
                objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                objAssetLiab.Repayment_Frequency__c='Weekly';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
                   Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
               fundingobj.name='test';
               fundingobj.Detail_Type__c='Potential Accrued Interest';
               fundingobj.Asset_And_Liability__c=objAssetLiab.id;
               fundingobj.Amount__c=67;
               fundingobj.Funding_Position__c=objFundingpos.id;
               insert fundingobj;
                
                
              Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
              mapobj.put(objAssetLiab.Account__c ,objFundingpos);
                
       
     AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
   // obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
    // obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
     
                
                  
                
                 
        }
           static testMethod void validate7()
        
        {
               
                
                LoadData();
                
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                
               Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
               fundingobj.name='test';
               fundingobj.Detail_Type__c='Potential Accrued Interest';
               fundingobj.Funding_Position__c=objFundingpos.id;
               insert fundingobj;
                
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Asset Real Estate';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c ='Owner Occupied';
                objAssetLiab.Repayments__c=09876;
                objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                objAssetLiab.State__c='NSW';
                objAssetLiab.To_Be_Purchased__c=false;
                objAssetLiab.Repayment_Frequency__c='Weekly';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
              Map<Id,Funding_Position__c> mapobj1=new Map<Id,Funding_Position__c> ();
              mapobj1.put(objAssetLiab.Account__c ,objFundingpos);
       
     AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
    // obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
    // obj.insertFPAssetEstateRecords(objAssetLiab,mapobj1);
     
                
                  
                
                 
        }
         static testMethod void validate9()
        
        {
                
                
                LoadData();
                
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                
               Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
               fundingobj.name='test';
               fundingobj.Detail_Type__c='Potential Accrued Interest';
               fundingobj.Funding_Position__c=objFundingpos.id;
               fundingobj.Detail_Type__c='Transfer Fee';
               insert fundingobj;
                
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Asset Real Estate';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c =null;
                objAssetLiab.Repayments__c=09876;
                objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                objAssetLiab.State__c='NSW';
                objAssetLiab.To_Be_Purchased__c=false;
                objAssetLiab.Repayment_Frequency__c='Weekly';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
              Map<Id,Funding_Position__c> mapobj1=new Map<Id,Funding_Position__c> ();
              mapobj1.put(objAssetLiab.Account__c ,objFundingpos);
       
     AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
    // obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
    // obj.insertFPAssetEstateRecords(objAssetLiab,mapobj1);
     
                
                  
                
                 
        }
         static testMethod void validate88()
        
        {
                LoadData();
                
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=false;
                objAssetLiab.name='Liability Mortgage Loan';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
               
                insert objAssetLiab;
       
     
     
                
                  
                
                 
        }
         
        static testMethod void validate1()
        
        {
               
                
                LoadData();
                
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Repayments__c=33;
                objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);
                objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
                objAssetLiab.name='Liabilities Mortgage Loan';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.Repayments__c=37;
                objAssetLiab.Current_Balance__c=987;
                 
                  
               objFundingpos=new Funding_Position__c ();
               objFundingpos.Account__c=objAccount.id;
               objFundingPos.Opportunity__c = objOpportunity.id;
               insert objFundingpos; 
      
               Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
               fundingobj.name='test';
               fundingobj.Detail_Type__c='Potential Accrued Interest';
               fundingobj.Funding_Position__c=objFundingpos.id;
               insert fundingobj; 
               
            
              
               update objAssetLiab;
     
                
        }
        
         static testMethod void validate2()
        
        {
              
                LoadData();
                
                 objAssetLiab=new Asset_And_Liability__c();
                 objAssetLiab.Clearing_From_This_Loan__c=false;
                 objAssetLiab.name='Liability';
                 objAssetLiab.Opportunity__c=objOpportunity.id;
                 objAssetLiab.Repayment_Frequency__c='Weekly';
                 objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();  
                 objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);
       
     
     
      
      
                 objFundingpos=new Funding_Position__c ();
                 objFundingpos.Account__c=objAccount.id;
                 objFundingPos.Opportunity__c = objOpportunity.id;
                 insert objFundingpos; 
                 
        }
        
          static testMethod void validate21()
        
        {
               
                LoadData();
                
                 objAssetLiab=new Asset_And_Liability__c();
                 objAssetLiab.Clearing_From_This_Loan__c=false;
                 objAssetLiab.name='Liability';
                 objAssetLiab.Opportunity__c=objOpportunity.id;
                 objAssetLiab.Repayment_Frequency__c='Monthly';
                   objAssetLiab.Current_Balance__c=99;
                   objAssetLiab.Limit__c=88;
                 objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();  
                 objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);
       
     
     
      
      
                 objFundingpos=new Funding_Position__c ();
                 objFundingpos.Account__c=objAccount.id;
                 objFundingPos.Opportunity__c = objOpportunity.id;
                 insert objFundingpos; 
                 
        }
        
         static testMethod void validate25()
        
        {
                LoadData();
                
                 objAssetLiab=new Asset_And_Liability__c();
                 objAssetLiab.Clearing_From_This_Loan__c=false;
                 objAssetLiab.name='Liability';
                 objAssetLiab.Opportunity__c=objOpportunity.id;
                 objAssetLiab.Repayment_Frequency__c='Anually';
                 objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();  
                 objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);
       
     
     
      
      
                 objFundingpos=new Funding_Position__c ();
                 objFundingpos.Account__c=objAccount.id;
                 objFundingPos.Opportunity__c = objOpportunity.id;
                 insert objFundingpos; 
                 
        }
        
         static testMethod void validate22()
        
        {
              
                
                LoadData();
                
                 objAssetLiab=new Asset_And_Liability__c();
                 objAssetLiab.Clearing_From_This_Loan__c=false;
                 objAssetLiab.name='Liability';
                 objAssetLiab.Opportunity__c=objOpportunity.id;
                 objAssetLiab.Repayment_Frequency__c='Fortnightly';
                 objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();  
                 objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);
       
     
     
      
      
                 objFundingpos=new Funding_Position__c ();
                 objFundingpos.Account__c=objAccount.id;
                 objFundingPos.Opportunity__c = objOpportunity.id;
                 insert objFundingpos; 
                 
        }
        
         static testMethod void validate10()
        
        {
               
                LoadData();
                
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                
               Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
               fundingobj.name='test';
               fundingobj.Detail_Type__c='Potential Accrued Interest';
               fundingobj.Funding_Position__c=objFundingpos.id;
               insert fundingobj;
                
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Asset Real Estate';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c ='Owner Occupied';
                objAssetLiab.Repayments__c=09876;
                objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                objAssetLiab.State__c='NSW';
                objAssetLiab.To_Be_Purchased__c=false;
                objAssetLiab.Repayment_Frequency__c='Weekly';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
              Map<Id,Funding_Position__c> mapobj1=new Map<Id,Funding_Position__c> ();
              mapobj1.put(objAssetLiab.Account__c ,objFundingpos);
       
     AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
    // obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
    // obj.insertAssetEstateSingleRecords(objAssetLiab,mapobj1,66);
     
                
                  
                
                 
        }
        
           static testMethod void validate45()
        
        {
            
                
                LoadData();
                
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Liabilities Mortgage Loan';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c ='Owner Occupied';
                objAssetLiab.Repayments__c=09876;
                objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                objAssetLiab.Repayment_Frequency__c='Monthly';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
              Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
              mapobj.put(objAssetLiab.Account__c ,objFundingpos);
                
       
     AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
   // obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
    // obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
     
                
                  
                
                 
        }
        
        static testMethod void validate46()
        
        {
                
                LoadData();
                
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Liabilities Mortgage Loan';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c ='Owner Occupied';
                objAssetLiab.Repayments__c=09876;
                objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                objAssetLiab.Repayment_Frequency__c='Anually';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
              Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
              mapobj.put(objAssetLiab.Account__c ,objFundingpos);
                
       
     AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
   //  obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
  //   obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
     
                
                  
                
                 
        }
        
        static testMethod void validate47()
        
        {
               
                LoadData();
              
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Liabilities Mortgage Loan';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c ='Owner Occupied';
                objAssetLiab.Repayments__c=09876;
                objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                objAssetLiab.Repayment_Frequency__c='Fortnightly';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
                
                  
                 
                
              Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
              mapobj.put(objAssetLiab.Account__c ,objFundingpos);
                
       
     AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
    // obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
   //  obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
     
                
                  
                
                 
        }
        
        static testMethod void validate90()
        
        {
             
                
                LoadData();
                
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                      
            
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Liability';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c ='Owner Occupied';
                objAssetLiab.Repayments__c=09876;
                objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                //objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.Repayment_Frequency__c='Weekly';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
                   Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
               fundingobj.name='test';
               fundingobj.Detail_Type__c='Potential Accrued Interest';
               fundingobj.Asset_And_Liability__c=objAssetLiab.id;
               fundingobj.Amount__c=67;
               fundingobj.Funding_Position__c=objFundingpos.id;
               insert fundingobj;
                
                
              Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
              mapobj.put(objAssetLiab.Account__c ,objFundingpos);
                
       
     AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
   // obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
    // obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
     
                
                  
                
                 
        }
        
        static testMethod void validate91()
        
        {
              
                LoadData();
                
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                      
            
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Liability';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c ='Owner Occupied';
                objAssetLiab.Repayments__c=09876;
                objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                objAssetLiab.To_Be_Purchased__c=true; 
                //objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.Repayment_Frequency__c='Weekly';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
                   Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
               fundingobj.name='test';
               fundingobj.Detail_Type__c='Potential Accrued Interest';
               fundingobj.Asset_And_Liability__c=objAssetLiab.id;
               fundingobj.Amount__c=67;
               fundingobj.Funding_Position__c=objFundingpos.id;
               insert fundingobj;
                
                
              Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
              mapobj.put(objAssetLiab.Account__c ,objFundingpos);
                
       
     AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
   // obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
    // obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
     
                
                  
                
                 
        }
        
          static testMethod void validate92()
        
        {
              
                LoadData();
                
                objFundingpos=new Funding_Position__c ();
                objFundingpos.Account__c=objAccount.id;
                objFundingPos.Opportunity__c = objOpportunity.id;
                insert objFundingpos; 
                
                      
            
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Liability';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c ='Owner Occupied';
                objAssetLiab.Repayments__c=09876;
               // objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                objAssetLiab.To_Be_Purchased__c=true; 
                //objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.Repayment_Frequency__c='Weekly';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
                   Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
               fundingobj.name='test';
               fundingobj.Detail_Type__c='Potential Accrued Interest';
               fundingobj.Asset_And_Liability__c=objAssetLiab.id;
               fundingobj.Amount__c=67;
               fundingobj.Funding_Position__c=objFundingpos.id;
               insert fundingobj;
                
                
              Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
              mapobj.put(objAssetLiab.Account__c ,objFundingpos);
                
       
     AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
     //obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
    // obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
     
                
                  
                
                 
        }
      static void LoadData()
      {
      
      
                ACFSwitch__c acfswitch = new ACFSwitch__c();
                acfswitch.Asset_And_Liability_Switch__c= true;
                insert acfswitch;
                
      
      
            CoreLogic__c objcore=new CoreLogic__c();
            objcore.name='CoreLogic';
            objcore.UserName__c='test';
            objcore.password__c='AusCred4321';
            objcore.EndPoint__c='https://access-api.corelogic.asia';
            objcore.AvmEndpoint__c='test';
            objcore.ClientID__c='test';
            objcore.ClientSecret__c='test';
            objcore.TokenEndPoint__c='test';
            objcore.SearchApiEndPoint__c='test';
            insert objcore;
      
        objState=new State__c();
          objState.name='test';
          insert objState;
      
           objAccount1=new account();
           objAccount1=WLCommonTrackerClass.createAccount(objAccount1);
          
      
          objLead=new Lead();
          objLead=WLCommonTrackerClass.createLead(objLead);
          objLead.acf_partner_account__c=objAccount1.id;
          objLead.acfWhat_is_your_postcode__c='testinggg';
          update objLead;
          
          
              
        
      
          objAccount=new account();
          objAccount=WLCommonTrackerClass.createAccount(objAccount);
       
      
          objContact=new contact();
          objContact=WLCommonTrackerClass.createContact(objContact,objAccount);
      
          objUser = new User();
          objuser.ContactId = objContact.id;
          objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
          
          objOpportunity = new Opportunity();
          objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
          objOpportunity.acfLegal_Fees__c=88;
          objOpportunity.clickEstablishment_Fee__c=99;
          objOpportunity.clickMortgage_Risk_Fee__c=888;
          update objOpportunity;
          
      
          objPro=new product2();
          objPro=WLCommonTrackerClass.createProduct(objPro);
          
          pbEntry = new PriceBookEntry();
          pbEntry.UnitPrice = 300;
          pbEntry.PriceBook2Id = Test.getStandardPricebookId();
          pbEntry.Product2Id = objPro.Id;
          pbEntry.IsActive = true;
          insert pbEntry ;
              
          oppLine = new OpportunityLineItem();
          oppLine.pricebookentryid=pbEntry.Id;
          oppLine.TotalPrice=2000;
          oppLine.Quantity = 2;
          oppLine.lender__c='test';
          oppLine.OpportunityID = objOpportunity.Id;
          insert oppLine;
      
      
      
     
     
      
      }
      
      }