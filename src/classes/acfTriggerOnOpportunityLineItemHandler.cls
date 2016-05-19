public  class acfTriggerOnOpportunityLineItemHandler 
{
  public void OnBeforeInsert(List<Opportunitylineitem>triggerNew)
  {
   // UpdateOpportunityLineItem(triggerNew);  //commented on 22-04-2016 regarding recalculate LVR
    //Added on 02-03-2016 regarding multiple product funtionality
    ValidateExistingBankProducts(triggerNew);
  }
  public void OnBeforeUpdate(List<Opportunitylineitem>triggerNew)
  {
    //UpdateOpportunityLineItem(triggerNew);
  }
  public void OnAfterInsert(List<Opportunitylineitem>triggerNew)
  {
    
    UpdateFeeInOpportunity(triggerNew);
    updateRequiredDocumentOnOpportunity(triggerNew);
  }
  public void OnAfterUpdate(List<Opportunitylineitem>triggerNew)
  {
    UpdateFeeInOpportunity(triggerNew);
    updateRequiredDocumentOnOpportunity(triggerNew);
  }
  public void OnAfterDelete(List<Opportunitylineitem>triggerOld)
  {
      UpdateFeeInOpportunity(triggerOld);
  }
  public void UpdateFeeInOpportunity(List<Opportunitylineitem>triggerNew)
  {
    set<Id>setOpportunityID = new set<Id>();
    List<Opportunity>lstOpportunityToUpdate = new List<Opportunity>();
    for(Opportunitylineitem objOppLi:triggerNew)
    { 
      setOpportunityID.add(objOppLi.OpportunityId);
    }
    system.debug('!@#$%'+setOpportunityID);
    if(setOpportunityID.size()>0)
    {
      decimal TotalApplicationFee,TotalValuationFee,TotalLegalFee,TotalOnGoingFee,TotalCurrentRate,TotalComparisionRate,TotalMortgageFee,TotalMonthlyFee,TotalMortgageRiskFee,TotalTitleProtectionFee,TotalUpfronFee,totalEstablishFee,totalAmount;
      for(Opportunity opp:[select id,Car_Application_Fee__c,acfOngoing_Fees__c,acfCuurent_Rate__c,acfValuation_Fee__c,acfLegal_Fees__c,Current_Interest_Rate__c,acfComparison_Rate__c,
                 clickMonthly_Fees__c,clickMortgage_Risk_Fee__c,clickTitle_Protection_Fee__c,clickTotal_Upfront_Fee__c,clickEstablishment_Fee__c,click_Loan_Amount__c,              
                 (select id,acfValuation_Fee__c,clickEstablishment_Fee__c,clickMortgage_Risk_Fee__c,clickTitle_Protection_Fee__c,acfOngoing_Fees__c,
                 acfLegal_Fees__c,acfApplication_Fee__c,acfRate__c,acfComparison_Rate__c,clickMonthly_Fees__c,clickTotal_Upfront_Fee__c,Click_Loan_Amount__c from OpportunityLineItems) from Opportunity where id in:setOpportunityID])
      {
        TotalApplicationFee = 0.00;
        TotalValuationFee = 0;
        TotalLegalFee = 0;
        TotalOnGoingFee = 0;
        TotalCurrentRate = 0;
        TotalComparisionRate = 0;
        TotalMortgageFee = 0;
        TotalMonthlyFee = 0;
        TotalMortgageRiskFee = 0;
        TotalTitleProtectionFee = 0;
        TotalUpfronFee = 0;
        totalEstablishFee = 0;
        totalAmount = 0;
        for(OpportunityLineItem OppLi:opp.OpportunityLineItems)
        {
          if(OppLi.acfApplication_Fee__c <> null)
            TotalApplicationFee += OppLi.acfApplication_Fee__c;
          if(OppLi.acfValuation_Fee__c <> null)  
            TotalValuationFee   += OppLi.acfValuation_Fee__c;
          if(OppLi.acfLegal_Fees__c <> null)  
            TotalLegalFee     += OppLi.acfLegal_Fees__c;
          if(OppLi.acfOngoing_Fees__c <> null)  
            TotalOnGoingFee     += OppLi.acfOngoing_Fees__c;
          if(OppLi.acfRate__c <> null)  
            TotalCurrentRate     += OppLi.acfRate__c;
          if(OppLi.acfComparison_Rate__c <> null)   
            TotalComparisionRate += OppLi.acfComparison_Rate__c;    
          if(OppLi.clickMonthly_Fees__c <> null)
            TotalMonthlyFee += OppLi.clickMonthly_Fees__c;
          if(OppLi.clickEstablishment_Fee__c <> null)
            totalEstablishFee += OppLi.clickEstablishment_Fee__c;
          if(OppLi.clickMortgage_Risk_Fee__c <> null)
            TotalMortgageRiskFee  = TotalMortgageRiskFee+OppLi.clickMortgage_Risk_Fee__c;
          if(OppLi.clickTitle_Protection_Fee__c <> null)
            TotalTitleProtectionFee = TotalTitleProtectionFee + OppLi.clickTitle_Protection_Fee__c;
          if(OppLi.clickTotal_Upfront_Fee__c <> null)
            TotalUpfronFee = TotalUpfronFee + OppLi.clickTotal_Upfront_Fee__c;
          if(OppLi.Click_Loan_Amount__c <> null)
          {
            totalAmount = totalAmount + OppLi.Click_Loan_Amount__c;
          }
        }
        opp.Car_Application_Fee__c      = TotalApplicationFee;
        opp.acfValuation_Fee__c         = TotalValuationFee;
        opp.acfLegal_Fees__c            = TotalLegalFee;
        opp.acfOngoing_Fees__c          = TotalOnGoingFee;
        opp.Current_Interest_Rate__c    = TotalCurrentRate;
        opp.acfComparison_Rate__c       = TotalComparisionRate;
        opp.clickMonthly_Fees__c        =  TotalMonthlyFee;
        opp.clickMortgage_Risk_Fee__c = TotalMortgageFee;
        opp.clickTitle_Protection_Fee__c = TotalTitleProtectionFee;
        opp.clickTotal_Upfront_Fee__c = TotalUpfronFee;
        opp.clickEstablishment_Fee__c = totalEstablishFee;      
        opp.click_Loan_Amount__c = totalAmount;
        lstOpportunityToUpdate.add(opp);
      }
      system.debug('!@#$%'+lstOpportunityToUpdate);
      if(lstOpportunityToUpdate.size()>0)
      {
        update lstOpportunityToUpdate;
      }           
    }
  }
  public void UpdateOpportunityLineItem(List<Opportunitylineitem>triggerNew)
  {
    set<Id>setOpportunityId = new set<Id>();
    set<Id>setPriceBookEntryId = new set<Id>();
    set<Id>setProductId = new set<Id>();
    map<Id,PricebookEntry>mapPBEIdToPBE = new map<Id,PricebookEntry>();
    map<Id,Opportunity>mapOppIdToOpp = new map<Id,Opportunity>();
    map<Id,List<LVR_Rate__c>>mapProductIdToListOfLVR = new map<id,List<LVR_Rate__c>>();
    if(triggerNew <> null && triggerNew.size()>0)
    {
      for(OpportunityLineItem objOppLi:triggerNew)
      {
        //Added on 3/2/2016
        objOppLi.Quantity = 1;
        objOppLi.click_Loan_Amount__c = objOppLi.UnitPrice;
        //Added on 3/2/2016
        if(objOppLi.OpportunityId <> null)
        {
           setOpportunityId.add(objOppLi.OpportunityId);
        }
        if(objOppLi.PricebookEntryId <> null)
        {
          setPriceBookEntryId.add(objOppLi.PricebookEntryId);
        }
        system.debug('1234567'+setPriceBookEntryId);
      }
    }
    if(setPriceBookEntryId <> null && setPriceBookEntryId.size()>0)
    {
      for(PricebookEntry objPBE:[select id,product2Id,product2.acfvarTenure_In_Years__c from PricebookEntry where id in:setPriceBookEntryId])
      {
        setProductId.add(objPBE.product2Id);
        mapPBEIdToPBE.put(objPBE.id,objPBE);
      }                  
    }
    if(setOpportunityId <> null && setOpportunityId.size()>0)
    {
      for(Opportunity objOpp:[select id,acfCurrentLoanAmount__c,acfCuurent_Rate__c,acfPayment_Type__c,Account.acfApproximately_how_much_is_your_house__pc from Opportunity where id in:setOpportunityId])
      {
        mapOppIdToOpp.put(objOpp.id,objOpp);            
      }
    }
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
    if(mapOppIdToOpp <> null && mapPBEIdToPBE <> null)
    {
      for(OpportunityLineItem objOppLi:triggerNew)
      {


        if(mapOppIdToOpp.get(objOppLi.OpportunityId)<> null && mapPBEIdToPBE.get(objOppLi.PricebookEntryId)<>null && mapProductIdToListOfLVR.get(mapPBEIdToPBE.get(objOppLi.PricebookEntryId).Product2Id)<>null)
        {
          if(mapOppIdToOpp.get(objOppLi.OpportunityId).acfCurrentLoanAmount__c <> null)
          {
           // List<decimal> lstFinalRate = new List<decimal>();
            string PaymentType = (mapOppIdToOpp.get(objOppLi.OpportunityId).acfPayment_Type__c);
            decimal acfRate = 0;
            decimal TenureInYears;
            decimal HouseValue = 0;
            decimal LoanAmount = 0;
            if(mapPBEIdToPBE.get(objOppLi.PricebookEntryId) <> null && mapPBEIdToPBE.get(objOppLi.PricebookEntryId).Product2.acfvarTenure_In_Years__c <> null) 
                TenureInYears = mapPBEIdToPBE.get(objOppLi.PricebookEntryId).Product2.acfvarTenure_In_Years__c;    
            if(mapOppIdToOpp.get(objOppLi.OpportunityId).Account.acfApproximately_how_much_is_your_house__pc != null)    
                HouseValue = (mapOppIdToOpp.get(objOppLi.OpportunityId).Account.acfApproximately_how_much_is_your_house__pc);
            if(mapOppIdToOpp.get(objOppLi.OpportunityId).acfCurrentLoanAmount__c != null)
                LoanAmount = (mapOppIdToOpp.get(objOppLi.OpportunityId).acfCurrentLoanAmount__c);
           /* if(mapOppIdToOpp.get(objOppLi.OpportunityId).acfCuurent_Rate__c != null)
            {
                acfRate = (mapOppIdToOpp.get(objOppLi.OpportunityId).acfCuurent_Rate__c);
            }*/
           // map<decimal,decimal>mapLVRToRate  = new map<decimal,decimal>();
            if(LoanAmount <> null && HouseValue <> Null && TenureInYears <> null && PaymentType <> null)
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
                {
                    if(objLVR.acfLVR__c>=LVR && objLVR.clickLVR_From__c<=LVR && objLVR.clickLoan_Size_From__c<=LoanAmount && objLVR.acfLoan_Size__c >= LoanAmount)  
                    {
                    //  mapLVRToRate.put(objLVR.acfLVR__c,objLVR.acfRate__c);
                     // lstFinalRate.add(objLVR.acfRate__c);
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
       
                 if(objFinalLVR <> null && acfRate <> null)
                 {
      
                   Decimal CurrentEMI = 0;
                   if(acfRate <> 0 && objOppLi.Click_Loan_Amount__c != null && objOppLi.click_Type__c != null && objOppLi.click_Tenure__c != null)                      
                   CurrentEMI = ClickCommon.calculateMonthlyPayment(objOppLi.Click_Loan_Amount__c,double.valueof(acfRate),objOppLi.click_Type__c,double.valueof(objOppLi.click_Tenure__c));            
                   objOppLi.Click_Estimated_Monthly_Payment__c = CurrentEMI;
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
 
                 }
              }
            }     
          }  
        }   
      }
     }  
   }
   public void updateRequiredDocumentOnOpportunity(list<OpportunityLineItem> triggerNew)
   {
        map<id,id> mapProduct2IdToOpportunityID = new map<id,id>();
        map<id,id> mapPricebookEntryIdToOpportunityID = new map<id,id>();
        set<id> setOfDocumentMasterId = new set<id>();
        set<id> setOfDocMasterId = new set<id>();
        map<id,set<id>> mapopportunityIdtoSetDocMasterId = new map<id,set<id>>();
        set<id> setOfOppId = new set<id>();
         for (OpportunityLineItem objOLI: triggerNew)
        {
            system.debug('objoli--------------------'+objoli);
            if(objOLI.PricebookEntryId <> null && objOLI.Opportunityid <> null)
            {
                mapPricebookEntryIdToOpportunityID.put(objOLI.PricebookEntryId,objOLI.OpportunityId);
                setOfOppId.add(objOLI.Opportunityid);
            }  
        }
        List<PricebookEntry> lstPriceBookEntry = new List<PricebookEntry>();
        if(mapPricebookEntryIdToOpportunityID.keyset() <> null)
        {
            lstPriceBookEntry = [select id,Product2Id from PricebookEntry where id =:mapPricebookEntryIdToOpportunityID.keyset()];
        }
        if(lstPriceBookEntry <> null && lstPriceBookEntry .size() > 0)
        {
            for(PricebookEntry objpricebook : lstPriceBookEntry)
            {
                 if(objpricebook.Product2Id <> null)
                 {
                     mapProduct2IdToOpportunityID.put(objpricebook.Product2Id,mapPricebookEntryIdToOpportunityID.get(objpricebook.id));
                     system.debug('objoli--------------------'+mapProduct2IdToOpportunityID);
                 }   
            }
        }
        List<Product_Document__c>  lstProductDocument = new List<Product_Document__c>();
        List<Opportunity>  lstOpp = new List<Opportunity>();
        if(mapProduct2IdToOpportunityID.keyset() <> null)
        lstProductDocument = [select id,Click_Loans_Document_Master__c,Click_Loans_Document_Master__r.Name,
                                Product__c from Product_Document__c
                                where Product__c =:mapProduct2IdToOpportunityID.keyset()]; 
        lstOpp = [select id,(select id,name,acfDocument_Master__c from Required_Documents__r) from opportunity where id=:setOfOppId]; 
        for(Opportunity objOpp : lstOpp)   
        {
            for(Required_Document__c objRd :objOpp.Required_Documents__r)
            {
                 if(mapopportunityIdtoSetDocMasterId.get(objOpp.id) == null)
                 {
                     mapopportunityIdtoSetDocMasterId.put(objOpp.id,new set<id>());
                 }
                 mapopportunityIdtoSetDocMasterId.get(objOpp.id).add(objRd.acfDocument_Master__c);   
            }
        }                     
        List<Required_Document__c>  lstRequiredDocument = new List<Required_Document__c>();                 
        if(lstProductDocument <> null && lstProductDocument.size() > 0) 
        {
            for(Product_Document__c objProductDocument : lstProductDocument)
            {
                system.debug('Ankit'+mapProduct2IdToOpportunityID.get(objProductDocument.Product__c));
                system.debug('Ankit11'+mapopportunityIdtoSetDocMasterId.get(mapProduct2IdToOpportunityID.get(objProductDocument.Product__c)));
                if(objProductDocument.Click_Loans_Document_Master__c <> null && mapProduct2IdToOpportunityID.get(objProductDocument.Product__c) <> null
                  && mapopportunityIdtoSetDocMasterId.get(mapProduct2IdToOpportunityID.get(objProductDocument.Product__c)) <> null
                    && !mapopportunityIdtoSetDocMasterId.get(mapProduct2IdToOpportunityID.get(objProductDocument.Product__c)).contains(objProductDocument.Click_Loans_Document_Master__c))
                {
                    Required_Document__c objRequiredDocument = new Required_Document__c(); 
                    objRequiredDocument.Name = objProductDocument.Click_Loans_Document_Master__r.name;
                    objRequiredDocument.acfOpportunity__c = mapProduct2IdToOpportunityID.get(objProductDocument.Product__c);
                    objRequiredDocument.acfDocument_Master__c = objProductDocument.Click_Loans_Document_Master__c;
                    objRequiredDocument.acfStatus__c  =  'Pending';
                    lstRequiredDocument.add(objRequiredDocument);
                    mapopportunityIdtoSetDocMasterId.get(mapProduct2IdToOpportunityID.get(objProductDocument.Product__c)).add(objProductDocument.Click_Loans_Document_Master__c);
                }
                else if(objProductDocument.Click_Loans_Document_Master__c <> null && mapProduct2IdToOpportunityID.get(objProductDocument.Product__c) <> null
                     && mapopportunityIdtoSetDocMasterId.get(mapProduct2IdToOpportunityID.get(objProductDocument.Product__c)) == null)     
                {
                    Required_Document__c objRequiredDocument = new Required_Document__c(); 
                    objRequiredDocument.Name = objProductDocument.Click_Loans_Document_Master__r.name;
                    objRequiredDocument.acfOpportunity__c = mapProduct2IdToOpportunityID.get(objProductDocument.Product__c);
                    objRequiredDocument.acfDocument_Master__c = objProductDocument.Click_Loans_Document_Master__c;
                    objRequiredDocument.acfStatus__c  =  'Pending';
                    lstRequiredDocument.add(objRequiredDocument);
                    if(mapopportunityIdtoSetDocMasterId.get(mapProduct2IdToOpportunityID.get(objProductDocument.Product__c)) == null)
                     {
                         mapopportunityIdtoSetDocMasterId.put(mapProduct2IdToOpportunityID.get(objProductDocument.Product__c),new set<id>());
                     }
                     mapopportunityIdtoSetDocMasterId.get(mapProduct2IdToOpportunityID.get(objProductDocument.Product__c)).add(objProductDocument.Click_Loans_Document_Master__c);   
                }
             
            }
        }   
        if(lstRequiredDocument <> null && lstRequiredDocument.size() > 0)
        {
            insert lstRequiredDocument;
        }
    }     
    //added on 02-03-2016
    public void ValidateExistingBankProducts(list<OpportunityLineItem> triggerNew) 
    {
        Set<Id> setOppIds = new Set<Id>();
        Set<Id> setPriceBookEntryIds = new Set<Id>();
        map<Id,set<Id>> mapOppIdToBankIds = new map<Id,set<Id>>();
        map<Id,Id> mapProdIdToBankId = new map<Id,Id>();
        for(OpportunityLineItem objOppLI : triggerNew)
        {
            setOppIds.add(objOppLI.OpportunityId);
            setPriceBookEntryIds.add(objOppLI.PricebookEntryId);
        }
        if(setOppIds != null && setOppIds.size()>0)
        {
            list<Opportunity> lstOpportunity = [select id,(select id,priceBookEntry.product2.Click_Loans_Bank_Detail__c from opportunityLineItems) from Opportunity where id IN:setOppIds];
            list<PriceBookEntry> lstPriceEntries = [select id,product2.Click_Loans_Bank_Detail__c from PriceBookEntry where id IN:setPriceBookEntryIds];
            if(lstOpportunity != null && lstOpportunity.size()>0)
            {
                for(Opportunity objOpportunity : lstOpportunity)
                {
                    for(OpportunityLineItem objchildOppLI : objOpportunity.opportunityLineItems)
                    {
                        if(mapOppIdToBankIds.get(objOpportunity.id) == null)
                        {
                            mapOppIdToBankIds.put(objOpportunity.id,new set<Id>());
                        }
                        if(mapOppIdToBankIds.get(objOpportunity.id) != null)
                        {
                            mapOppIdToBankIds.get(objOpportunity.id).add(objchildOppLI.priceBookEntry.product2.Click_Loans_Bank_Detail__c);
                        }
                   }                    
                }               
            }
            if(lstPriceEntries != null && lstPriceEntries.size()>0)
            {
                for(PriceBookEntry objPriceEntry : lstPriceEntries)
                {
                  mapProdIdToBankId.put(objPriceEntry.id,objPriceEntry.Product2.Click_Loans_Bank_Detail__c);  
                }
            } 
            if(mapOppIdToBankIds != null && mapOppIdToBankIds.size()>0 && mapProdIdToBankId != null && mapProdIdToBankId.size()>0)
            {
                for(OpportunityLineItem objnewOppLI : triggerNew)
                {
                     if(mapOppIdToBankIds.get(objnewOppLI.opportunityId) !=null){
                       if(!mapOppIdToBankIds.get(objnewOppLI.opportunityId).contains(mapProdIdToBankId.get(objnewOppLI.PricebookEntryId)))
                       {
                            objnewOppLI.addError('Please select products from same bank');
                       } 
                     }                      
                }
            }           
        }
    }
}