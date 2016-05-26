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
       //Create Task from TaskMaster    
       CreateTaskFromTaskMaster(lstTriggerNew); 
       CreateOpportunityLineItems(lstTriggerNew);
       mapOpportunityWIthFpRecord(lstTriggerNew);
       TagApplicantWithOpportunity(lstTriggerNew);
    }
    public void onAfterUpdate(list<opportunity> triggernew,map<id,opportunity> triggerOldMap)
    {
        updateOppLIMonthlyPayments(triggernew,triggerOldMap);
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
                  for(pricebookentry pbe:[select id, unitprice, product2id 
                                          from pricebookentry 
                                          where pricebook2.isstandard = true 
                                            and product2id in :setProductIDs]) {
                  mapPricebookentries.put(pbe.product2id, pbe);
                  }
                  system.debug('@@@@@Lokesh'+mapPricebookentries);
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
            for(Product2 objProd : [ SELECT Id , acfInterest_Only__c 
                                     FROM Product2
                                     WHERE Id IN :mapProduct2IdToOLIID.keySet()
                                   ]){
            
                mapOLIIdWithInterestOnly.put(mapProduct2IdToOLIID.get(objProd.Id), objProd.acfInterest_Only__c );                         
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
                           if(mapOppIdToOpp.get(ObjOpp.Accountid).acfAsset_House_Worth__c != null)    
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
        
    
    public void mapOpportunityWIthFpRecord(list<opportunity> triggernew){
                set<Id> setObj = new set<Id>();
        map<Id, Id> mapObj = new map<Id,ID>();
         for(Opportunity ObjTemp  : Triggernew )
        {   mapObj.put(ObjTemp.accountid, ObjTemp.id);
            setObj.add(ObjTemp.accountid);
        }
        List<Funding_Position__c> updateFp = new List<Funding_Position__c>();
        List<Funding_Position__c> lstFp = [SELECT Account__c, Opportunity__c FROM Funding_Position__c where Account__c in :setObj  ];
        
        for(Funding_Position__c fp :lstFp){
            
            if(mapObj.get(fp.Account__c) != null){
                fp.Opportunity__c = mapObj.get(fp.Account__c);
                updateFp.add(fp);
            }
            
        }
        if(updateFp.size() > 0){
            update updateFp;
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
                {
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
}