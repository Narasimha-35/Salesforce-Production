/*====================================================
                Click Loans
========================================================*/
public  class acfTriggerOnOpportunityHandler 
{
    public acfTriggerOnOpportunityHandler()
    {
    }
    //Method to call on opportunity after Update.
    public void OnAfterInsert(List<opportunity>lstTriggerNew)
    {
       createRequiresDocumentForLendi(lstTriggerNew,null);
       //Create Task from TaskMaster   
       CreateTaskFromTaskMaster(lstTriggerNew); 
       CreateOpportunityLineItems(lstTriggerNew);
       mapOpportunityWIthFpRecord(lstTriggerNew);
       TagApplicantWithOpportunity(lstTriggerNew);
    }
    public void onAfterUpdate(list<opportunity> triggernew,map<id,opportunity> triggerOldMap)
    {
        updateOppLIMonthlyPayments(triggernew,triggerOldMap);
        sendEmailonOppUpdate(triggernew,triggerOldMap);
        createRequiresDocumentForLendi(triggernew,triggerOldMap);
    }
    //Create task after opportunity created. 
    public void CreateTaskFromTaskMaster(List<opportunity>lstTriggerNew)
    {
        List<Task>lstTaskToInsert = new List<Task>();
        List<acfTask_Master__c>lstTask = [select id,acfDescription__c,acfIsActive__c,acfStage__c,acfSubject__c 
                                                 from acfTask_Master__c where acfIsActive__c=true and acfStage__c='Opportunity Creation'];
                                         
        for(Opportunity objOpp:lstTriggerNew)
        {
            for(acfTask_Master__c objTMTask:lstTask)
            {
                Task objTask             = new Task();
                objTask.Description      = objTMTask.acfDescription__c;
                objTask.WhatId           = objOpp.id;    
                objTask.Status           = 'open';
                objTask.Priority         = 'Normal';
                objTask.ActivityDate     = system.Today();
                objTask.IsVisibleInSelfService  = true;
                objTask.subject          = objTMTask.acfSubject__c;
                lstTaskToInsert.add(objTask);
            }
        }
        if(lstTaskToInsert <> null && lstTaskToInsert.size()>0)
          insert lstTaskToInsert;                                                                
    }
    
    public void updateExistingTaskStatus(List<opportunity>lstTriggerNew)
    {
        set<Id> setOpportunityBankIds = new set<Id>();
        set<Id> setOpportunityIdentityIds = new set<Id>();
        if(lstTriggerNew != null && lstTriggerNew.size()>0)
        {
            for(opportunity objOpportunity : lstTriggerNew)
            {
            system.debug('@@@karthik@'+objOpportunity.clickJumio_Status__c+'===='+objOpportunity.acfBankdetailStatus__c);
                if(objOpportunity.acfBankdetailStatus__c == 'Completed')
                {
                    setOpportunityBankIds.add(objOpportunity.id);
                }
                if(objOpportunity.clickJumio_Status__c == 'Attempted')
                {
                    setOpportunityIdentityIds.add(objOpportunity.id);
                }
            }
        }
        if(setOpportunityBankIds != null && setOpportunityIdentityIds != null)
        {
            list<Task> lstTaskToUpdate = [select id,Status,WhatId,acf_Is_Upload_Bank_Stmt__c,acf_Is_Upload_Identity_Verification__c,subject from Task where (WhatId IN:setOpportunityBankIds AND acf_Is_Upload_Bank_Stmt__c = true) OR (WhatId IN:setOpportunityIdentityIds AND acf_Is_Upload_Identity_Verification__c = true)];
            list<Task> lstUpdatedTasks = new list<Task>();
            for(Task objTask : lstTaskToUpdate)
            {
                objTask.Status = 'Completed';
                lstUpdatedTasks.add(objTask);
            }
            if(lstUpdatedTasks != null && lstUpdatedTasks.size()>0)
            {
                update lstUpdatedTasks;
            }
        }
    }    
    
    public void CreateOpportunityLineItems(List<opportunity>lstTriggerNew)
    {
        set<Id>setLVRID = new set<Id>();
        set<Id>setProductIDs = new set<Id>();
        map<Id,LVR_Rate__c>mapLVRProdIdToLVR = new map<Id,LVR_Rate__c>();
        map<id,pricebookentry>mapPricebookentries = new map<id,pricebookentry>();
        List<OpportunityLineItem>lstOpportunityLIToInsert = new List<OpportunityLineItem>();
        for(Opportunity objOpp:lstTriggerNew)
        {
            if(objOpp.acfProduct_LVR__c <> null)
            {
              setLVRID.add(objOpp.acfProduct_LVR__c);   
            }
            
        }
        system.debug('!@#$%^'+setLVRID);
        if(setLVRID.size()>0)
        {
            for(LVR_Rate__c objLVR:[select id,acfLVR__c,acfProduct__c,acfRate__c,acfProduct__r.acfTotal_Fee__c,acfProduct__r.acfTenure_in_Years__c,acfProduct__r.acfvarTenure_In_Years__c,acfProduct__r.RecordType.Name,acfProduct__r.ACF_Comparison_Rate__c,acfTotal_Fee__c,ACF_Comparison_Rate__c from LVR_Rate__c where id In:setLVRID])
            {
                setProductIDs.add(objLVR.acfProduct__c);
                mapLVRProdIdToLVR.put(objLVR.id,objLVR);
            }
            if(setProductIDs.size()>0)
            {
                  for(pricebookentry pbe:[select id, unitprice, product2id  from pricebookentry where pricebook2.isstandard = true and product2id in :setProductIDs])
                  {
                      mapPricebookentries.put(pbe.product2id, pbe);
                  }
            }
            system.debug('!@#$%^'+mapLVRProdIdToLVR);
            if(mapLVRProdIdToLVR <> null)
            {
                for(Opportunity objOpp:lstTriggerNew)
                {
                    if(objOpp.acfProduct_LVR__c <> null && mapLVRProdIdToLVR.get(objOpp.acfProduct_LVR__c)<> null && mapPricebookentries <> null && mapPricebookentries.get(mapLVRProdIdToLVR.get(objOpp.acfProduct_LVR__c).acfProduct__c)<>null)
                    {
                        
                        LVR_Rate__c objLVR = mapLVRProdIdToLVR.get(objOpp.acfProduct_LVR__c);
                        system.debug('@@@testing'+objLVR);
                        if(objOpp.acfCurrentLoanAmount__c <> null && objLVR.acfRate__c <> null && objOpp.acfPayment_Type__c <> null && (objLVR.acfProduct__r.acfTenure_in_Years__c <> null || objLVR.acfProduct__r.acfvarTenure_In_Years__c <> null))
                        {
                            OpportunityLineItem objOppLI   = new OpportunityLineItem();
                            objOppLI.OpportunityId         = objOpp.id;
                            If(objLVR.acfProduct__r.RecordType.Name == 'Fixed'){
                                objOppLI.Quantity = Integer.valueof(objLVR.acfProduct__r.acfTenure_in_Years__c);
                            }
                            If(objLVR.acfProduct__r.RecordType.Name == 'Variable') {
                                objOppLI.Quantity = objLVR.acfProduct__r.acfvarTenure_In_Years__c;
                            }
                            system.debug('!@#$%^'+objOpp.acfCurrentLoanAmount__c);
                            If(objLVR.acfProduct__r.RecordType.Name == 'Fixed'){
                                if(acfCommon.calculateMonthlyPayment(objOpp.acfCurrentLoanAmount__c,double.valueof(objLVR.acfRate__c),objOpp.acfPayment_Type__c,double.valueof(objLVR.acfProduct__r.acfTenure_in_Years__c))<> null)
                                    objOppLI.UnitPrice  = acfCommon.calculateMonthlyPayment(objOpp.acfCurrentLoanAmount__c,double.valueof(objLVR.acfRate__c),objOpp.acfPayment_Type__c,double.valueof(objLVR.acfProduct__r.acfTenure_in_Years__c));
                                else
                                   objOppLI.UnitPrice = 0.00;
                            }else If(objLVR.acfProduct__r.RecordType.Name == 'Variable'){
                                if(acfCommon.calculateMonthlyPayment(objOpp.acfCurrentLoanAmount__c,double.valueof(objLVR.acfRate__c),objOpp.acfPayment_Type__c,double.valueof(objLVR.acfProduct__r.acfvarTenure_In_Years__c))<> null)
                                    objOppLI.UnitPrice  = acfCommon.calculateMonthlyPayment(objOpp.acfCurrentLoanAmount__c,double.valueof(objLVR.acfRate__c),objOpp.acfPayment_Type__c,double.valueof(objLVR.acfProduct__r.acfvarTenure_In_Years__c));
                                else
                                   objOppLI.UnitPrice = 0.00;
                                }
                            system.debug('@@@#$%'+objOppLI.UnitPrice);
                            objOppLI.PricebookEntryId      = mapPricebookentries.get(objLVR.acfProduct__c).id;
                            objOppLI.acfRate__c            = objLVR.acfRate__c; 
                            objOppLI.acfLoan_Fees__c       = objLVR.acfTotal_Fee__c;
                            objOppLI.acfComparison_Rate__c = objLVR.ACF_Comparison_Rate__c;                          
                            lstOpportunityLIToInsert.add(objOppLI);
                        }    
                    }   
                }
                if(lstOpportunityLIToInsert <> null && lstOpportunityLIToInsert.size()>0)
                {
                    system.debug('testing@@@'+lstOpportunityLIToInsert);
                    insert lstOpportunityLIToInsert;
                }
            }
        }
    }
    //method to recalculate LVR on oppLI based on total amount
    public void updateOppLIMonthlyPayments(list<opportunity> triggernew,map<id,opportunity> triggerOldMap)
    {
        set<Id>setAccountId = new set<Id>();
        List<OpportunityLineItem> updateOLI = new List<OpportunityLineItem>();
        set<id> setObj = new set<id>();
        map<Id,Account> mapOppIdToOpp = new map<Id,Account>();
        map<id,List<OpportunityLineItem>> mapOLI = new  map<Id, List<OpportunityLineItem>>();
        set<Id>setPriceBookEntryId = new set<Id>();
        map<id,id> mapPricebookEntryIdToOLIID = new map<id,id>();
        map<Id, Asset_And_Liability__c> mapAsetandLib = new map<Id, Asset_And_Liability__c>();
        set<Id>setProductId = new set<Id>();
        map<Id,PricebookEntry>mapPBEIdToPBE = new map<Id,PricebookEntry>();
        for(Opportunity ObjTemp  : Triggernew )
        {
            setObj.add(ObjTemp.ID);
            // mapOppIdToOpp.put(ObjTemp.id,ObjTemp);       
            setAccountId.add(ObjTemp.AccountId);  
        }
        List<Account> accObj = [Select Id, acfAsset_House_Worth__c,acfApproximately_how_much_is_your_house__pc from Account where id in  :setAccountId];
        for(Account accobj1 :  accObj)
        {
            mapOppIdToOpp.put(accobj1.id , accobj1);    
        }  
        //get all related opportunity line items
        List<OpportunityLineItem>  lstOLI =  [SELECT acfApplication_Fee__c,acfComparison_Rate__c,acfLegal_Fees__c,acfLoan_Fees__c,acfOngoing_Fees__c,acfOppLIComparison_Rate__c,acfRate__c,acfTotal_Fee__c,acfValuation_Fee__c,clickEstablishment_Fee__c,clickMonthly_Fees__c,clickMortgage_Risk_Fee__c,clickTitle_Protection_Fee__c,clickTotal_Upfront_Fee__c,Click_Estimated_Monthly_Payment__c,click_Loan_Amount__c,click_Purpose__c,Click_Tenure__c,click_Type__c,Description,Id,ListPrice,OpportunityId,PricebookEntryId,Quantity,TotalPrice,UnitPrice FROM OpportunityLineItem  where  OpportunityId in : setObj];
        for(OpportunityLineItem oli :  lstOLI)
        {
          setPriceBookEntryId.add(oli.PricebookEntryId);
          mapPricebookEntryIdToOLIID.put(oli.PricebookEntryId,oli.Id);
          if(mapOLI.containskey(oli.OpportunityId )){
               mapOLI.get(oli.OpportunityId).add(oli);
          }
          else{
              list<OpportunityLineItem> tempOli = new list<OpportunityLineItem>();
               tempOli.add(oli);
               mapOLI.put(oli.OpportunityId , tempOli);  
          }  
        }
        if(setPriceBookEntryId <> null && setPriceBookEntryId.size()>0)
        {
          for(PricebookEntry objPBE:[select id,product2Id,product2.acfvarTenure_In_Years__c,product2.acfInterest_Only__c from PricebookEntry where id in:setPriceBookEntryId])
          {
            setProductId.add(objPBE.product2Id);
            mapPBEIdToPBE.put(objPBE.id,objPBE);
          }                  
        }  
        map<Id,List<LVR_Rate__c>>mapProductIdToListOfLVR = new map<id,List<LVR_Rate__c>>();    
        if(setProductId <> null && setProductId.size()>0)
        {
          for(LVR_Rate__c objLVRRate:[select id,acfLVR__c,acfProduct__c,acfProduct__r.RecordType.Name,acfProduct__r.acfInterest_Only__c,acfRate__c,acfAnnual_Fees__c,acfApplication_Fee__c,acfTotal_Fee__c,ACF_Comparison_Rate__c,acfEstablishment_Fee__c,clickFixed_Interest_Rate__c,acfLegal_Fees__c,
          acfMonthly_Fees__c,acfMortgage_Risk_Fee__c,acfOngoing_Fees_annual__c,acfTitle_Protection_Fee__c,acfValuation_Fee__c,acfTerm_in_Years__c,clickLoan_Size_From__c,acfLoan_Size__c,clickLVR_From__c 
          from LVR_Rate__c where acfProduct__c in:setProductId])
          {
            if(mapProductIdToListOfLVR.get(objLVRRate.acfProduct__c) == null)
              mapProductIdToListOfLVR.put(objLVRRate.acfProduct__c,new List<LVR_Rate__c>());
            mapProductIdToListOfLVR.get(objLVRRate.acfProduct__c).add(objLVRRate);
          }
        }         
            List<PricebookEntry> lstPriceBookEntry = new List<PricebookEntry>();
            if(mapPricebookEntryIdToOLIID.keyset() <> null)
            {
                lstPriceBookEntry = [select id,Product2Id,product2.acfInterest_Only__c from PricebookEntry where id =:mapPricebookEntryIdToOLIID.keyset()];
            }       
            map<id,id> mapProduct2IdToOLIID = new map<id,id>();
            map<id,Boolean> mapOLIIdWithInterestOnly = new map<id,Boolean>(); 
            if(lstPriceBookEntry <> null && lstPriceBookEntry .size() > 0)
            {
                for(PricebookEntry objpricebook : lstPriceBookEntry)
                {
                     if(objpricebook.Product2Id <> null)
                     {
                         mapProduct2IdToOLIID.put(objpricebook.Product2Id,mapPricebookEntryIdToOLIID.get(objpricebook.id));
                         system.debug('objoli--------------------'+mapProduct2IdToOLIID);
                     }   
                }
            }  
            if( mapProduct2IdToOLIID.keySet().size() > 0)   {
            for(Product2 objProd : [ SELECT Id , acfInterest_Only__c 
                                     FROM Product2
                                     WHERE Id IN :mapProduct2IdToOLIID.keySet()
                                   ]){
            
                mapOLIIdWithInterestOnly.put(mapProduct2IdToOLIID.get(objProd.Id), objProd.acfInterest_Only__c );                         
            }
            }
              
            for(Opportunity ObjOpp  : Triggernew)
            {               
                if(mapOLI.get(ObjOpp.id)  <> null  &&  (ObjOpp.Amount != triggerOldMap.get(ObjOpp.Id).Amount || ObjOpp.acfAsset_House_Worth__c != triggerOldMap.get(ObjOpp.Id).acfAsset_House_Worth__c))
                {
                  for(OpportunityLineItem objOppLi: mapOLI.get(ObjOpp.id) )
                  {                      
                    objOppLi.Quantity = 1;
                    objOppLi.click_Loan_Amount__c = objOppLi.UnitPrice;            
                    if(mapPBEIdToPBE.get(objOppLi.PricebookEntryId)<>null 
                    && mapProductIdToListOfLVR.get(mapPBEIdToPBE.get(objOppLi.PricebookEntryId).Product2Id)<>null)
                    {
                      if(ObjOpp.acfCurrentLoanAmount__c <> null)
                      {
                       // List<decimal> lstFinalRate = new List<decimal>();
                        string PaymentType = ObjOpp.acfPayment_Type__c;
                        decimal acfRate = 0;
                        decimal TenureInYears;
                        decimal HouseValue = 0;
                        decimal LoanAmount = 0;
                        
                        if(ObjOpp.id != null)
                        {                      
                           if(mapOppIdToOpp != null && !mapOppIdToOpp.isempty() && mapOppIdToOpp.get(ObjOpp.Accountid)!= null && mapOppIdToOpp.get(ObjOpp.Accountid).acfAsset_House_Worth__c != null)    
                            HouseValue = (mapOppIdToOpp.get(ObjOpp.Accountid).acfAsset_House_Worth__c);
                             System.debug(HouseValue);                  
                        }
                        if(mapPBEIdToPBE.get(objOppLi.PricebookEntryId) <> null && mapPBEIdToPBE.get(objOppLi.PricebookEntryId).Product2.acfvarTenure_In_Years__c <> null) 
                            TenureInYears = mapPBEIdToPBE.get(objOppLi.PricebookEntryId).Product2.acfvarTenure_In_Years__c;    
                       
                        if(ObjOpp.acfCurrentLoanAmount__c != null)
                            LoanAmount = ObjOpp.Amount;
                       
                       // map<decimal,decimal>mapLVRToRate  = new map<decimal,decimal>();
                       
                       System.debug('__LoanAmount__'+LoanAmount);
                       System.debug('HouseValue'+HouseValue);
                           System.debug('TenureInYears'+TenureInYears);
                           System.debug('PaymentType'+PaymentType);
                        if(LoanAmount <> null && HouseValue <> Null && TenureInYears <> null && PaymentType <> null  && HouseValue <> 0)
                        {
                          Double  LVR = ((LoanAmount/HouseValue)*100);
                          system.debug('@#$%%'+LVR);
                          List<LVR_Rate__c> lstLVR = mapProductIdToListOfLVR.get(mapPBEIdToPBE.get(objOppLi.PricebookEntryId).Product2Id);
                          system.debug('@#$%%'+lstLVR);       
                          LVR_Rate__c objFinalLVR = new LVR_Rate__c();
                          if(lstLVR <> null && lstLVR.size()>0)
                          {
                            Decimal decTempRate = 0;
                           
                            for(LVR_Rate__c objLVR:lstLVR)
                            {   System.debug('____'+objLVR);
                                System.debug('__LVR__'+LVR);
                                System.debug('objLVR.acfLVR__c'+objLVR.acfLVR__c);
                                
                                if(objLVR.acfLVR__c>=LVR && objLVR.clickLVR_From__c<=LVR && objLVR.clickLoan_Size_From__c<=objopp.acfCurrentLoanAmount__c && objLVR.acfLoan_Size__c >= objopp.acfCurrentLoanAmount__c)  
                                {
                                  if((objLVR.acfProduct__r.RecordType.Name == 'Variable' && (objLVR.acfRate__c < decTempRate)) || (objLVR.acfProduct__r.RecordType.Name == 'Fixed' && (objLVR.clickFixed_Interest_Rate__c < decTempRate)) || decTempRate == 0)
                                  {   
                                    objFinalLVR = objLVR;
                                  }
                                  if(objLVR.acfProduct__r.RecordType.Name == 'Variable')
                                  {
                                    decTempRate = objLVR.acfRate__c;
                                    if(acfRate == null || acfRate == 0)
                                    {
                                        acfRate = objLVR.acfRate__c;
                                    }
                                  }
                                  if(objLVR.acfProduct__r.RecordType.Name == 'Fixed')
                                  {
                                    decTempRate = objLVR.clickFixed_Interest_Rate__c;
                                    if(acfRate == null || acfRate == 0)
                                    {
                                        acfRate = objLVR.clickFixed_Interest_Rate__c;
                                    }
                                  }
                                }
                            }                                                       
                             System.debug('_acfRate__'+acfRate);                           
                             system.debug('mapOLIIdWithInterestOnly***********bhasin***********' +mapOLIIdWithInterestOnly);
                             if(objFinalLVR <> null && acfRate <> null)
                             {
                               Boolean acfInterestOnly;
                               acfInterestOnly = mapOLIIdWithInterestOnly.get(objOppLi.Id);
                            //   objOppLi.product2Id.acfInterest_Only__c  = mapProduct2IdToOLIID.get(Product2.acfInterest_Only__c);
                               Decimal CurrentEMI = 0;
                               system.debug('acfInterestOnly----------bhasin------------'+acfInterestOnly);
                               if(acfRate > 0 && objOppLi.UnitPrice != null && objOppLi.click_Type__c != null && objOppLi.click_Tenure__c != null ) 
                                 {
                                    
                                    System.debug(CurrentEMI);          
                                    System.debug(objOppLi.UnitPrice);
                                    System.debug(double.valueof(acfRate));
                                    System.debug(objOppLi.click_Type__c);
                                    System.debug(double.valueof(objOppLi.click_Tenure__c));
                                  //OpportunityLineItem oppLi = new OpportunityLineItem;
                                  
                               String temp = '';
                               if(acfInterestOnly == true && objOppLi.click_Type__c.equals('Interest Only') ){
                                    temp='Interest Only';
                                     
                                }else{
                                    temp = 'Principal and Interest';
                                }
                                
                             /*  if (acfInterestOnly == false && objOppLi.click_Type__c == 'Interest Only' )
                                {
                                temp = 'Principal and Interest';
                                }
                                if (objOppLi.click_Type__c == 'Principal and Interest' )
                                {
                                  temp='Principal and Interest';
                                } */ 
                                
                               if(temp != '')
                               {
                                CurrentEMI = ClickCommon.calculateMonthlyPayment(objOppLi.UnitPrice,double.valueof(acfRate),temp,double.valueof(objOppLi.click_Tenure__c)); 
                                System.debug(CurrentEMI);                                             
                                objOppLi.Click_Estimated_Monthly_Payment__c = CurrentEMI;
                               }
                               objOppLi.acfRate__c = acfRate;
                               objOppLi.acfComparison_Rate__c = objFinalLVR.ACF_Comparison_Rate__c;
                               //objOppLi.Quantity  = TenureInYears*12;
                               objOppLi.acfApplication_Fee__c = objFinalLVR.acfApplication_Fee__c;
                               objOppLi.acfValuation_Fee__c =objFinalLVR.acfValuation_Fee__c;
                               objOppLi.acfLegal_Fees__c = objFinalLVR.acfLegal_Fees__c;
                               objOppLi.acfOngoing_Fees__c = objFinalLVR.acfOngoing_Fees_annual__c;
                               objOppLi.clickEstablishment_Fee__c = objFinalLVR.acfEstablishment_Fee__c;
                               objOppLi.clickMonthly_Fees__c = objFinalLVR.acfMonthly_Fees__c;
                               objOppLi.clickMortgage_Risk_Fee__c = objFinalLVR.acfMortgage_Risk_Fee__c;
                               objOppLi.clickTitle_Protection_Fee__c = objFinalLVR.acfTitle_Protection_Fee__c;
                               objOppLi.clickTotal_Upfront_Fee__c = objFinalLVR.acfTotal_Fee__c; 
                               objOppLi.Click_Loans_LVR_Rate__c =  objFinalLVR.id;             
                               updateOLI.add(objOppLi);
             
                             }
                      
                          }
                        }     
                      }  
                    }   
                  }
                 }  
               }
              }
          if(updateOLI <> null && updateOLI.size() > 0)
              update updateOLI;
        }
        
    //create fundind position records
    public void mapOpportunityWIthFpRecord(list<opportunity> triggernew)
    {
        set<Id> setObj = new set<Id>();
        map<Id, Id> mapAccountOppId = new map<Id,ID>();      
        for(Opportunity ObjTemp  : triggerNew )
        {   
             if(ObjTemp.accountid <> null && ObjTemp.create_from_custom_clone_button__c == false)
             {
                 mapAccountOppId.put(ObjTemp.accountid, ObjTemp.id);
                 setObj.add(ObjTemp.accountid);
             }
        }
        List<Funding_Position__c> updateFp = new List<Funding_Position__c>();
        List<Asset_And_Liability__c> updateAsset = new List<Asset_And_Liability__c>();
        List<Funding_Position__c> lstFp = [SELECT Account__c, Opportunity__c FROM Funding_Position__c where Account__c in :setObj  ];
        List<Asset_And_Liability__c> lstAsset = [SELECT Account__c, Opportunity__c,id FROM Asset_And_Liability__c where Account__c in :setObj];
        
        for(Funding_Position__c fp :lstFp)
        {      
            if(fp.Account__c <> null && mapAccountOppId <> null && mapAccountOppId.size()>0 && mapAccountOppId.get(fp.Account__c) != null)
            {
                fp.Opportunity__c = mapAccountOppId.get(fp.Account__c);
                updateFp.add(fp);
            }          
        }
        
        for(Asset_And_Liability__c assetObj :lstAsset){
            
            if(assetObj.Account__c <> null && mapAccountOppId <> null && mapAccountOppId.size()>0 && mapAccountOppId.get(assetObj.Account__c) != null )
            {
                assetObj.Opportunity__c = mapAccountOppId.get(assetObj.Account__c);
                updateAsset.add(assetObj);
            }   
        }      
        if(updateFp != null && updateFp.size() > 0){
            update updateFp;
        } 
        
        if(updateAsset != null && updateAsset.size() > 0){
            update updateAsset;
        }       
    }    
    
    // This method is used to Tag Applicant from Account to opportunity   
    public void TagApplicantWithOpportunity(List<opportunity>lstTriggerNew)
    {
        List<click_Applicant__c> lstupdatedApplicant = new List<click_Applicant__c>();
        map<id,id> mapAccountIdToOppId = new map<id,id>();
        if(lstTriggerNew != null && lstTriggerNew.size() > 0)
        {
            for(opportunity objopp : lstTriggerNew)
            {
                if(objopp.AccountId != null)
                {   if(objopp.create_from_custom_clone_button__c == false && objopp.Id <> null)
                      mapAccountIdToOppId.put(objopp.AccountId,objopp.Id);
                }
            }
            
            List<click_Applicant__c> lstApplicant = [select id,click_Account__c,clickOpportunity__c from click_Applicant__c
                                                     where click_Account__c =: mapAccountIdToOppId.keyset()];
            if(lstApplicant != null && lstApplicant.size() > 0)
            {
                for(click_Applicant__c objApplicant : lstApplicant)
                {
                    if(objApplicant.click_Account__c != null && mapAccountIdToOppId != null && mapAccountIdToOppId.keyset() != null
                       && mapAccountIdToOppId.get(objApplicant.click_Account__c) != null)
                    {
                        objApplicant.clickOpportunity__c = mapAccountIdToOppId.get(objApplicant.click_Account__c);
                        lstupdatedApplicant.add(objApplicant);
                    }  
                }  
            }
            
            if(lstupdatedApplicant != null && lstupdatedApplicant.size() > 0)
            {
                update lstupdatedApplicant;
            }
        }
    
    }   
    
  //-----------*************Created by Bhasin on 31-05-16*****************--------------//
  // This method is used to send email template to the broker when applicant is updated on the basis of stage name and status.          
    public void sendEmailonOppUpdate(List<opportunity> lstTriggerNew,map<id,Opportunity> mapTriggerOld)
    {    
      /*  Set<Id> setOppIds = new Set<Id>();
        for(Opportunity objOpp : lstTriggerNew)
        {
          if((objOpp.StageName != mapTriggerOld.get(objOpp.id).StageName && objOpp.StageName == 'Application Taken') 
                || (objOpp.acf_Status__c != mapTriggerOld.get(objOpp.id).acf_Status__c && objOpp.acf_Status__c == 'Submitted'))
            {
              setOppIds.add(objOpp.id);
              system.debug('setOppIds-----'+setOppIds);
            }
        } 
        ClickCommon.sendEmailNotification(setOppIds);    */
    }
    
       
    //===================================================================================
    //     Name             createdDate               Version
    //===================================================================================
    //    Ankit Singh       23-05-2016                 2.0
    //===================================================================================
    // This method to create Required Documents Based on the Answer Selected and Community.
    // for ACFQ-199 and ACFQ-235
    //===================================================================================
    
    public void createRequiresDocumentForLendi(List<opportunity>lstTriggerNew,map<id,opportunity> triggerOldMap)
    {
        Id CommId;
        string strCommName = System.label.Lendi; 
        System.debug('strCommName@@'+strCommName);
        map<Id,Id> MapAccountIdToOpportunityId = new map<Id,Id>();
        Set<Id> setOfoppId = new Set<Id>();
        List<Opportunity> lstOpp = new List<Opportunity>();  
        List<Question__c> lstQuestions = new List<Question__c>();
        set<id> setOfBankDetailId = new set<id>();
        List<Click_Loans_Bank__c> lstbank = new List<Click_Loans_Bank__c>();
        List<Document_Master__c> List_DocMaster = new List<Document_Master__c>();
        Id lendiRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(strCommName).getRecordTypeId();
        if(lstTriggerNew != null && lstTriggerNew.size() > 0)
        {
            system.debug('!@#$%**************************************'+trigger.isInsert);
            system.debug('!@#$%1**************************************'+trigger.isUpdate);
            lstOpp = [select id,RecordTypeId,Community_Setup__c,Community_Setup__r.Name,acfRequired_Document_Generation__c,AccountId from 
            Opportunity where id in : lstTriggerNew];
            if(lstOpp != null && !lstOpp.Isempty())
            {
                System.debug('@@lstOpp'+lstOpp);
                for(opportunity objopp : lstOpp)
                {
                    System.debug('objopp.Community_Setup__r.Name objopp.Community_Setup__r.Name '+objopp.Community_Setup__r.Name );
                    if((trigger.isInsert && objopp.Community_Setup__c != null && objopp.Community_Setup__r.Name == strCommName && objopp.RecordTypeId == lendiRecordTypeId && objopp.acfRequired_Document_Generation__c)
                        ||(trigger.isUpdate && objopp.Community_Setup__c != null && objopp.Community_Setup__r.Name == strCommName && objopp.RecordTypeId == lendiRecordTypeId 
                        && triggerOldMap.get(objopp.id).get('acfRequired_Document_Generation__c') == false && objopp.get('acfRequired_Document_Generation__c') != triggerOldMap.get(objopp.id).get('acfRequired_Document_Generation__c')))
                    {
                        system.debug('objopp.AccountId****************************'+objopp.AccountId);
                        CommId = objopp.Community_Setup__c;
                        setOfoppId.add(objopp.Id);
                    }
                    else if(trigger.isInsert && objopp.Community_Setup__c != null && objopp.Community_Setup__r.Name == strCommName && objopp.RecordTypeId == lendiRecordTypeId && objopp.acfRequired_Document_Generation__c == false)
                    {
                        CommId = objopp.Community_Setup__c;
                        if(objopp.AccountId != null)
                        {
                            MapAccountIdToOpportunityId.put(objopp.AccountId,objopp.Id);
                        }
                    }
                }
                if(strCommName != null && strCommName != '' && lendiRecordTypeId != null && CommId != null && ((MapAccountIdToOpportunityId != null && MapAccountIdToOpportunityId.size() > 0
                   && MapAccountIdToOpportunityId.keyset() != null) || setOfoppId != null && setOfoppId.size() > 0))
                {
                    System.debug('!@#$%asasasasasasasasasa'+CommId);
                    lstQuestions = [select id,acf_Script__r.Click_Community_Setup__c,acf_ApiName__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,
                                    acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,acfBubble_Text__c,acfOpportunity_Api_Name__c,
                                    (select id,acf_Answer__c from Answer__r),acf_AccountApiName__c,acfWatermark_Text__c,acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c
                                    from Question__c where (acf_Script__r.Click_Community_Setup__c =:CommId and acf_Script__r.acf_Type__c='Pre-Login' and acf_Active__c = true 
                                    and (acf_Type__c ='picklist' or acf_Type__c ='Checkbox' or acf_Type__c ='button' or acf_Type__c ='Radiobutton'))];
                    system.debug('lstQuestions****************************'+lstQuestions);
                    //map AnswerId to list of Dependent document. 
                    lstbank = [select id,Click_Loans_Bank_Detail__c,Community_Setup__c from Click_Loans_Bank__c where Community_Setup__c =:CommId];
                    
                    if(lstbank != null && lstbank.size() > 0) 
                    {
                        for(Click_Loans_Bank__c objbank : lstbank)
                        {
                            setOfBankDetailId.add(objbank.Click_Loans_Bank_Detail__c);
                        }
                    }
                    List_DocMaster = [select id,Name,acfActive__c,acfDescription__c,acf_Source__c,Click_Community_Setup__c from Document_Master__c
                                          where acfActive__c=true AND Click_Community_Setup__c =: CommId];
                    system.debug('MapAccountIdToOpportunityId ******************'+MapAccountIdToOpportunityId );
                    system.debug('lstQuestions ******************'+lstQuestions );
                    system.debug('setOfBankDetailId ******************'+setOfBankDetailId);
                    system.debug('List_DocMaster ******************'+List_DocMaster);
                    if(MapAccountIdToOpportunityId != null && MapAccountIdToOpportunityId.size() > 0 && MapAccountIdToOpportunityId.keyset() != null
                        && lstQuestions != null && !lstQuestions.isEmpty() && setOfBankDetailId != null && setOfBankDetailId.size() > 0 && List_DocMaster != null
                        && !List_DocMaster.isEmpty())
                    {
                        set<id> setOfnullId = new set<id>();
                        insertrequiredDocforLendi(MapAccountIdToOpportunityId,setOfnullId,lstOpp,'acf_AccountApiName__c',lstQuestions,setOfBankDetailId,
                                                  List_DocMaster,strCommName,lendiRecordTypeId,CommId);
                    }
                    if(setOfoppId != null && setOfoppId.size() > 0 && lstQuestions != null && !lstQuestions.isEmpty() && setOfBankDetailId != null && 
                        setOfBankDetailId.size() > 0 && List_DocMaster != null && !List_DocMaster.isEmpty())
                    {
                        map<Id,Id> MapnullIdTonullId = new map<Id,Id>();
                        insertrequiredDocforLendi(MapnullIdTonullId,setOfoppId,lstOpp,'acfOpportunity_Api_Name__c',lstQuestions,setOfBankDetailId,
                                                  List_DocMaster,strCommName,lendiRecordTypeId,CommId);
                    }
                }
            }
        }
    }
    
    public void insertrequiredDocforLendi(map<id,id> MapAccountIdToOpportunityId,set<id> setOfoppId,List<opportunity> lstOpp,string strApiName,List<Question__c> lstQuestions,set<id> setOfBankDetailId,List<Document_Master__c> List_DocMaster,string strCommName,Id lendiRecordTypeId,id CommId)
    {
        Set<String> setOfQuesApiNames = new Set<String>();
        List<Answer__c> lstAnswer = new List<Answer__c>();
        List<Answer__c> lstAnswers = new List<Answer__c>();
        Set<Id> setOfAnswerId = new Set<Id>();
        map<Id,List<Dependent_Document__c>> mapIdtoDependentDoc = new map<Id,List<Dependent_Document__c>>();  
        map<Id,List<acfDependent_Product__c>> mapIdtoDependentProduct = new map<Id,List<acfDependent_Product__c>>();
        List<Required_Document__c> lstRequiredDocumentToInsert = new List<Required_Document__c>(); 
        List<acfSuggested_Product__c> lstSuggestedDocumentToInsert = new List<acfSuggested_Product__c>();
        map<id,set<string>> mapIdToSetofAnswer = new map<id,set<string>>();
        map<id,set<Id>> mapIdToSetofAnswerId = new map<id,set<Id>>();
        map<id,set<Id>> mapIdToSetofDocumentMasterId = new map<id,set<Id>>();
        //Code to display set of selected Answer products.
        // Get Pre-Login Question And There Answer For Particular Community.
        
       if(lstQuestions != null && lstQuestions.size()>0)
       {
            for(Question__c objQues :lstQuestions)
            {
                if(strApiName <> null && strApiName <> '' && objQues.get(strApiName) != null && objQues.get(strApiName) != '')
                {
                    setOfQuesApiNames.add(string.valueof(objQues.get(strApiName)));
                    for(Answer__c objAns: objQues.Answer__r)
                    {
                        lstAnswer.add(objAns);
                        setOfAnswerId.add(objAns.Id);
                    }
                }
            }
        }
        String strleadQues='';
        if(setOfQuesApiNames != null && setOfQuesApiNames.size()>0)
        {
            for(String strApinames : setOfQuesApiNames)
            {
                strleadQues = strleadQues+strApinames+',';
            }
        }
        
        set<Id> setofAccountId = new set<Id>();
        if(MapAccountIdToOpportunityId != null && MapAccountIdToOpportunityId.size() > 0 && MapAccountIdToOpportunityId.keyset() != null)
        {
            setofAccountId = MapAccountIdToOpportunityId.keyset();
            
            if(MapAccountIdToOpportunityId.values() != null && !MapAccountIdToOpportunityId.values().isEmpty())
            {
                List<Opportunity> lstOpps = new List<Opportunity>();
                lstOpps = [select id,(select id,acfDocument_Master__c from Required_Documents__r) from Opportunity where id=:MapAccountIdToOpportunityId.values()];
                for(Opportunity objOpp : lstOpps)
                {
                    if(objOpp.Required_Documents__r != null && !objOpp.Required_Documents__r.isEmpty())
                    {
                        for(Required_Document__c objRequiredDoc : objOpp.Required_Documents__r)
                        {
                            if(mapIdToSetofDocumentMasterId.get(objOpp.Id) == null)
                            {
                                mapIdToSetofDocumentMasterId.put(objOpp.Id,new set<id>());
                            }
                            mapIdToSetofDocumentMasterId.get(objOpp.Id).add(objRequiredDoc.acfDocument_Master__c); 
                        }
                    }
                }
            }
        }
        if(setOfoppId != null && setOfoppId.size() > 0)
        {
            List<Opportunity> lstOpps = new List<Opportunity>();
            
            lstOpps = [select id,(select id,acfDocument_Master__c from Required_Documents__r) from Opportunity where id in :setOfoppId];
            
            
            for(Opportunity objOpp : lstOpps)
            {
                if(objOpp.Required_Documents__r != null && !objOpp.Required_Documents__r.isEmpty())
                {
                    for(Required_Document__c objRequiredDoc : objOpp.Required_Documents__r)
                    {
                        if(mapIdToSetofDocumentMasterId.get(objOpp.Id) == null)
                        {
                            mapIdToSetofDocumentMasterId.put(objOpp.Id,new set<id>());
                        }
                        mapIdToSetofDocumentMasterId.get(objOpp.Id).add(objRequiredDoc.acfDocument_Master__c); 
                    }
                }
            }
        }
        system.debug('mapIdToSetofDocumentMaster*&^%$#'+mapIdToSetofDocumentMasterId);
        if(strleadQues != null && strleadQues <> '')
        {
            String strQueryOnObj = '';
            if(setOfoppId != null && setOfoppId.size() > 0)
                strQueryOnObj = 'select '+strleadQues+'id from opportunity where Id IN:setOfoppId';
            if(MapAccountIdToOpportunityId != null && MapAccountIdToOpportunityId.size() > 0 && MapAccountIdToOpportunityId.keyset() != null)
                strQueryOnObj = 'select '+strleadQues+'id from Account where Id IN:setofAccountId';
            system.debug('strQueryOnObj **************************'+strQueryOnObj);
            SObject[] lstDependentObj = Database.query(strQueryOnObj);
            if(lstDependentObj != null && lstDependentObj.size()>0)
            {
                for(SObject objDependentObj : lstDependentObj)
                {
                    for(String strApiNames : setOfQuesApiNames)
                    {
                        If(strApiNames <> '' && objDependentObj.get(strApiNames) <> null)
                        {  
                            if(mapIdToSetofAnswer.get(objDependentObj.Id) == null)
                            {
                                mapIdToSetofAnswer.put(objDependentObj.Id,new set<string>());
                            }
                            mapIdToSetofAnswer.get(objDependentObj.Id).add(string.valueof(objDependentObj.get(strApiNames))); 
                        }
                    }   
                }
            }
            system.debug('mapIdToSetofAnswer****************************'+mapIdToSetofAnswer);
            if(mapIdToSetofAnswer != null && mapIdToSetofAnswer.size() > 0 && mapIdToSetofAnswer.Keyset() != null)
            {
                for(Id objOppId : mapIdToSetofAnswer.Keyset())
                {
                    if(lstAnswer != null && lstAnswer.size()>0)
                    {
                        for(Answer__c objAns : lstAnswer)
                        {
                            if(mapIdToSetofAnswer.get(objOppId).contains(objAns.acf_Answer__c))
                            {
                                if(mapIdToSetofAnswerId.get(objOppId) == null)
                                {
                                    mapIdToSetofAnswerId.put(objOppId,new set<Id>());
                                }
                                mapIdToSetofAnswerId.get(objOppId).add(objAns.id);
                            }
                        }
                    }   
                }
            }
            system.debug('mapIdToSetofAnswerId****************************'+mapIdToSetofAnswerId);
        }   
        if(setOfAnswerId != null && setOfAnswerId.size() > 0)
        {
            lstAnswers = [select id,acf_Answer__c,(select id,acfAnswer__c,acfFilter__c,acfProduct__c,acfProduct__r.Click_Loans_Bank_Detail__c,acfProduct_Family__c from Dependent_Products__r
                          where acfProduct__r.Click_Loans_Bank_Detail__c IN : setOfBankDetailId),(select id,name,acfDocument_Master__c,acfDocument_Master__r.Click_Community_Setup__c
                          from Dependent_Documents__r where acfDocument_Master__r.Click_Community_Setup__c =:CommId ) from Answer__c where id=:setOfAnswerId];
            if(lstAnswers != null && !lstAnswers.isEmpty())
            {
                for(Answer__c objAnswers: lstAnswers)
                {
                    if(objAnswers.Dependent_Documents__r != null && objAnswers.Dependent_Documents__r.size() > 0)
                    {
                        for(Dependent_Document__c objDependentDoc : objAnswers.Dependent_Documents__r)
                        {
                            if(mapIdtoDependentDoc.get(objAnswers.id) == null)
                            {
                                mapIdtoDependentDoc.put(objAnswers.id,new List<Dependent_Document__c>());
                            }
                            mapIdtoDependentDoc.get(objAnswers.id).add(objDependentDoc);
                        }
                    }
                    if(objAnswers.Dependent_Products__r != null && objAnswers.Dependent_Products__r.size() > 0)
                    {
                        for(acfDependent_Product__c objDependentProduct : objAnswers.Dependent_Products__r)
                        {
                            if(mapIdtoDependentProduct.get(objAnswers.id) == null)
                            {
                                mapIdtoDependentProduct.put(objAnswers.id,new List<acfDependent_Product__c>());
                            }
                            mapIdtoDependentProduct.get(objAnswers.id).add(objDependentProduct);
                        }
                    }
                }
            }
        }
        system.debug('mapIdtoDependentDoc****************************'+mapIdtoDependentDoc);
        system.debug('mapIdtoDependentDoc****************************'+mapIdtoDependentProduct);
        
        Set<String> st = new Set<String>();
        if(lstOpp != null && !lstOpp.isEmpty())
        {
            for(opportunity objopp : lstOpp)
            {
                if(objopp.Community_Setup__c != null && objopp.Community_Setup__r.Name == strCommName && objopp.RecordTypeId == lendiRecordTypeId && objopp.acfRequired_Document_Generation__c == false)
                {
                    if(objopp.AccountId != null && mapIdToSetofAnswerId != null && mapIdToSetofAnswerId.size() > 0 && mapIdToSetofAnswerId.Keyset() != null
                       && mapIdToSetofAnswerId.get(objopp.AccountId) != null)
                    {
                        for(Id AnswerObjIds : mapIdToSetofAnswerId.get(objopp.AccountId))
                        {
                            if(mapIdtoDependentDoc != null && mapIdtoDependentDoc.size() > 0 && mapIdtoDependentDoc.Keyset() != null
                               && mapIdtoDependentDoc.get(AnswerObjIds) != null)
                            {
                               for(Dependent_Document__c objDependentDoc: mapIdtoDependentDoc.get(AnswerObjIds))
                               {
                                    if(!st.contains(objDependentDoc.Name) && mapIdToSetofDocumentMasterId.isEmpty())
                                    {
                                        Required_Document__c objRequiredDocument  =  new Required_Document__c();
                                        objRequiredDocument.Name                  =  objDependentDoc.Name;
                                        objRequiredDocument.acfDocument_Master__c =  objDependentDoc.acfDocument_Master__c;
                                        objRequiredDocument.acfOpportunity__c     =  objopp.id;
                                        objRequiredDocument.acfStatus__c          =  'Pending';
                                        lstRequiredDocumentToInsert.add(objRequiredDocument);       
                                        st.add(objDependentDoc.Name);
                                    } 
                                    else if(!st.contains(objDependentDoc.Name) && mapIdToSetofDocumentMasterId != null && mapIdToSetofDocumentMasterId.size() > 0 
                                            && mapIdToSetofDocumentMasterId.keyset() != null && mapIdToSetofDocumentMasterId.get(objopp.id) != null 
                                            && !mapIdToSetofDocumentMasterId.get(objopp.id).contains(objDependentDoc.acfDocument_Master__c))
                                    {
                                        Required_Document__c objRequiredDocument  =  new Required_Document__c();
                                        objRequiredDocument.Name                  =  objDependentDoc.Name;
                                        objRequiredDocument.acfDocument_Master__c =  objDependentDoc.acfDocument_Master__c;
                                        objRequiredDocument.acfOpportunity__c     =  objopp.id;
                                        objRequiredDocument.acfStatus__c          =  'Pending';
                                        lstRequiredDocumentToInsert.add(objRequiredDocument);       
                                        st.add(objDependentDoc.Name);
                                    }                                        
                                }
                            }
                            if(mapIdtoDependentProduct != null && mapIdtoDependentProduct.size() > 0 && mapIdtoDependentProduct.Keyset() != null
                               && mapIdtoDependentProduct.get(AnswerObjIds) != null)
                            {
                                for(acfDependent_Product__c objDependentProducts : mapIdtoDependentProduct.get(AnswerObjIds))
                                {
                                    acfSuggested_Product__c objSuggestedProd = new acfSuggested_Product__c();
                                    objSuggestedProd.acfFilter__c   =  objDependentProducts.acfFilter__c;
                                    objSuggestedProd.acfOpportunity__c =  objopp.id; 
                                    objSuggestedProd.acfProduct__c  =  objDependentProducts.acfProduct__c;
                                    lstSuggestedDocumentToInsert.add(objSuggestedProd);
                                }
                            }
                        }
                        If(List_DocMaster != null && !List_DocMaster.isEmpty())
                        {
                            for(Document_Master__c objDoc : List_DocMaster)
                            {
                                system.debug('mapIdToSetofDocumentMasterId******************'+mapIdToSetofDocumentMasterId);
                                if(mapIdToSetofDocumentMasterId.isEmpty())
                                {
                                    If(objDoc.acf_Source__c == 'Jumio' || (objDoc.acf_Source__c == 'Bank Statement'))
                                    {
                                        Required_Document__c objReqDoc = new Required_Document__c();
                                        objReqDoc.Name = objDoc.Name;
                                        objReqDoc.acfOpportunity__c = objopp.id;
                                        objReqDoc.acfDocument_Master__c = objDoc.id;
                                        if(objDoc.acf_Source__c == 'Jumio')
                                          objReqDoc.acf_Is_Identity_Verification_Doc__c = true;
                                        else if(objDoc.acf_Source__c == 'Bank Statement')
                                           objReqDoc.acf_Bank_Statement_Doc__c = true;  
                                        lstRequiredDocumentToInsert.add(objReqDoc);
                                    }
                                }
                                else if(mapIdToSetofDocumentMasterId != null && mapIdToSetofDocumentMasterId.size() > 0 
                                       && mapIdToSetofDocumentMasterId.keyset() != null && mapIdToSetofDocumentMasterId.get(objopp.id) != null 
                                       && !mapIdToSetofDocumentMasterId.get(objopp.id).contains(objDoc.Id))
                                {
                                    If(objDoc.acf_Source__c == 'Jumio' || (objDoc.acf_Source__c == 'Bank Statement'))
                                    {
                                        Required_Document__c objReqDoc = new Required_Document__c();
                                        objReqDoc.Name = objDoc.Name;
                                        objReqDoc.acfOpportunity__c = objopp.id;
                                        objReqDoc.acfDocument_Master__c = objDoc.id;
                                        if(objDoc.acf_Source__c == 'Jumio')
                                          objReqDoc.acf_Is_Identity_Verification_Doc__c = true;
                                        else if(objDoc.acf_Source__c == 'Bank Statement')
                                           objReqDoc.acf_Bank_Statement_Doc__c = true;  
                                        lstRequiredDocumentToInsert.add(objReqDoc);
                                    }
                                }   
                            }
                        }
                        st.clear();
                    }
                }
                else if(objopp.Community_Setup__c != null && objopp.Community_Setup__r.Name == strCommName && objopp.RecordTypeId == lendiRecordTypeId && objopp.acfRequired_Document_Generation__c)
                {
                    if(mapIdToSetofAnswerId != null && mapIdToSetofAnswerId.size() > 0 && mapIdToSetofAnswerId.Keyset() != null
                       && mapIdToSetofAnswerId.get(objopp.Id) != null)
                    {
                        for(Id AnswerObjIds : mapIdToSetofAnswerId.get(objopp.Id))
                        {
                            if(mapIdtoDependentDoc != null && mapIdtoDependentDoc.size() > 0 && mapIdtoDependentDoc.Keyset() != null
                               && mapIdtoDependentDoc.get(AnswerObjIds) != null)
                            {
                               for(Dependent_Document__c objDependentDoc: mapIdtoDependentDoc.get(AnswerObjIds))
                               {
                                    if(!st.contains(objDependentDoc.Name) && mapIdToSetofDocumentMasterId.isEmpty())
                                    {
                                        Required_Document__c objRequiredDocument  =  new Required_Document__c();
                                        objRequiredDocument.Name                  =  objDependentDoc.Name;
                                        objRequiredDocument.acfDocument_Master__c =  objDependentDoc.acfDocument_Master__c;
                                        objRequiredDocument.acfOpportunity__c     =  objopp.id;
                                        objRequiredDocument.acfStatus__c          =  'Pending';
                                        lstRequiredDocumentToInsert.add(objRequiredDocument);       
                                        st.add(objDependentDoc.Name);
                                    } 
                                    else if(!st.contains(objDependentDoc.Name)  && mapIdToSetofDocumentMasterId != null && mapIdToSetofDocumentMasterId.size() > 0 
                                       && mapIdToSetofDocumentMasterId.keyset() != null && mapIdToSetofDocumentMasterId.get(objopp.id) != null 
                                       && !mapIdToSetofDocumentMasterId.get(objopp.id).contains(objDependentDoc.acfDocument_Master__c))
                                    {
                                        Required_Document__c objRequiredDocument  =  new Required_Document__c();
                                        objRequiredDocument.Name                  =  objDependentDoc.Name;
                                        objRequiredDocument.acfDocument_Master__c =  objDependentDoc.acfDocument_Master__c;
                                        objRequiredDocument.acfOpportunity__c     =  objopp.id;
                                        objRequiredDocument.acfStatus__c          =  'Pending';
                                        lstRequiredDocumentToInsert.add(objRequiredDocument);       
                                        st.add(objDependentDoc.Name);
                                    }   
                                }
                            }
                            if(mapIdtoDependentProduct != null && mapIdtoDependentProduct.size() > 0 && mapIdtoDependentProduct.Keyset() != null
                               && mapIdtoDependentProduct.get(AnswerObjIds) != null)
                            {
                                for(acfDependent_Product__c objDependentProducts : mapIdtoDependentProduct.get(AnswerObjIds))
                                {
                                    acfSuggested_Product__c objSuggestedProd = new acfSuggested_Product__c();
                                    objSuggestedProd.acfFilter__c   =  objDependentProducts.acfFilter__c;
                                    objSuggestedProd.acfOpportunity__c =  objopp.id; 
                                    objSuggestedProd.acfProduct__c  =  objDependentProducts.acfProduct__c;
                                    lstSuggestedDocumentToInsert.add(objSuggestedProd);
                                }
                            }
                        }
                        If(List_DocMaster <> null && !List_DocMaster.isEmpty())
                        {
                            for(Document_Master__c objDoc : List_DocMaster)
                            {
                                system.debug('mapIdToSetofDocumentMasterId11111******************'+mapIdToSetofDocumentMasterId);
                                if(mapIdToSetofDocumentMasterId.isEmpty())
                                {
                                    If(objDoc.acf_Source__c == 'Jumio' || (objDoc.acf_Source__c == 'Bank Statement'))
                                    {
                                        Required_Document__c objReqDoc = new Required_Document__c();
                                        objReqDoc.Name = objDoc.Name;
                                        objReqDoc.acfOpportunity__c = objopp.id;
                                        objReqDoc.acfDocument_Master__c = objDoc.id;
                                        if(objDoc.acf_Source__c == 'Jumio')
                                          objReqDoc.acf_Is_Identity_Verification_Doc__c = true;
                                        else if(objDoc.acf_Source__c == 'Bank Statement')
                                           objReqDoc.acf_Bank_Statement_Doc__c = true;  
                                        lstRequiredDocumentToInsert.add(objReqDoc);
                                    }
                                }
                                else if(mapIdToSetofDocumentMasterId != null && mapIdToSetofDocumentMasterId.size() > 0 
                                        && mapIdToSetofDocumentMasterId.keyset() != null && mapIdToSetofDocumentMasterId.get(objopp.id) != null 
                                        && !mapIdToSetofDocumentMasterId.get(objopp.id).contains(objDoc.Id))
                                {
                                    If(objDoc.acf_Source__c == 'Jumio' || (objDoc.acf_Source__c == 'Bank Statement'))
                                    {
                                        Required_Document__c objReqDoc = new Required_Document__c();
                                        objReqDoc.Name = objDoc.Name;
                                        objReqDoc.acfOpportunity__c = objopp.id;
                                        objReqDoc.acfDocument_Master__c = objDoc.id;
                                        if(objDoc.acf_Source__c == 'Jumio')
                                          objReqDoc.acf_Is_Identity_Verification_Doc__c = true;
                                        else if(objDoc.acf_Source__c == 'Bank Statement')
                                           objReqDoc.acf_Bank_Statement_Doc__c = true;  
                                        lstRequiredDocumentToInsert.add(objReqDoc);
                                    }
                                }
                            }
                        }
                        st.clear();
                    }
                }
            }
            if(lstRequiredDocumentToInsert <> null && lstRequiredDocumentToInsert.size()>0)
            {
                system.debug('lstRequiredDocumentToInsert****************************'+lstRequiredDocumentToInsert);
                insert lstRequiredDocumentToInsert;
            } 
            if(lstSuggestedDocumentToInsert <> null && lstSuggestedDocumentToInsert.size()>0)
                insert lstSuggestedDocumentToInsert;
        }
    }  
    
    

public void createFundingPosition(List<Opportunity>  lstOpp)
{
    if(!test.isrunningtest())
    {
        List<Funding_Position__c>  fPosExistingList = [Select id,Account__c , Opportunity__c from Funding_Position__c where Opportunity__c IN:lstOpp];
        
        map<Id, Funding_Position__c>  mapFunding = new map<Id, Funding_Position__c>();
        
        for(Funding_Position__c  fpObj  : fPosExistingList)
        {
            mapFunding.put(fpObj.Opportunity__c , fpObj );
        }
        Set<ID>  oppId = new Set<Id>();
        for(Opportunity  opp :  lstOpp)
        {
            oppId.add(opp.id);
        }
        map<Id ,OpportunityLineItem >  mapOLI = new map<Id ,OpportunityLineItem >();
       
        List<OpportunityLineItem> oppLineList = [ SELECT acfLegal_Fees__c,OpportunityId,clickEstablishment_Fee__c,clickMortgage_Risk_Fee__c
        FROM OpportunityLineItem  where OpportunityId in : oppId  ORDER BY CreatedDate Asc];
        
        for(OpportunityLineItem   oli : oppLineList )
        {
            mapOLI.put(oli.OpportunityId, oli );
            
        }
    
    
        List<Funding_Position__c>  fpObj = new List<Funding_Position__c>();
        for(Opportunity  opp :  lstOpp)
        {
        if(opp.recordtypeid != null )
        {
            string recordtypename = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.recordtypeid).getname();    
            if(recordtypename == 'Lendi')
            {   
                if(!mapFunding.containskey(opp.id))
                {
                    Funding_Position__c fp = new Funding_Position__c();
                    
                    fp.Account__c = opp.AccountId;
                    fp.Opportunity__c = opp.id;
                    
                     if(mapOLI.containsKey(opp.ID) && mapOLI.get(opp.ID).acfLegal_Fees__c !=null && mapOLI.get(opp.ID).clickEstablishment_Fee__c !=null && mapOLI.get(opp.ID).clickMortgage_Risk_Fee__c !=null){
                      fp.Lender_Set_Up_Fees__c = (Integer)mapOLI.get(opp.ID).acfLegal_Fees__c + (Integer) mapOLI.get(opp.ID).clickEstablishment_Fee__c + (Integer) mapOLI.get(opp.ID).clickMortgage_Risk_Fee__c;
                     }
                     
                    fpObj.add(fp);
                }   
                else
                {
                    Funding_Position__c fp  =   mapFunding.get(opp.id) ;
                    if(mapOLI.containsKey(opp.ID) && mapOLI.get(opp.ID).acfLegal_Fees__c !=null && mapOLI.get(opp.ID).clickEstablishment_Fee__c !=null && mapOLI.get(opp.ID).clickMortgage_Risk_Fee__c !=null){
                      fp.Lender_Set_Up_Fees__c = (Integer)mapOLI.get(opp.ID).acfLegal_Fees__c + (Integer) mapOLI.get(opp.ID).clickEstablishment_Fee__c + (Integer) mapOLI.get(opp.ID).clickMortgage_Risk_Fee__c;
                     }
                     
                    fpObj.add(fp);
                }
            }
        }
            
        }
        
        if(fpObj.size() > 0){
            upsert fpObj ;
        }
    }

}
 
}