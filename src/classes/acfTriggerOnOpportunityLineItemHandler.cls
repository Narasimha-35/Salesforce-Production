public  class acfTriggerOnOpportunityLineItemHandler 
{
  public void OnBeforeInsert(List<Opportunitylineitem>triggerNew)
  {
    UpdateOpportunityLineItem(triggerNew);
  }
  public void OnBeforeUpdate(List<Opportunitylineitem>triggerNew)
  {
    UpdateOpportunityLineItem(triggerNew);
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
      decimal TotalApplicationFee,TotalValuationFee,TotalLegalFee,TotalOnGoingFee,TotalCurrentRate,TotalComparisionRate,TotalMortgageFee,TotalMonthlyFee,TotalMortgageRiskFee,TotalTitleProtectionFee,TotalUpfronFee,totalEstablishFee;
      for(Opportunity opp:[select id,Car_Application_Fee__c,acfOngoing_Fees__c,acfCuurent_Rate__c,acfValuation_Fee__c,acfLegal_Fees__c,Current_Interest_Rate__c,acfComparison_Rate__c,
                 clickMonthly_Fees__c,clickMortgage_Risk_Fee__c,clickTitle_Protection_Fee__c,clickTotal_Upfront_Fee__c,clickEstablishment_Fee__c,              
                 (select id,acfValuation_Fee__c,clickEstablishment_Fee__c,clickMortgage_Risk_Fee__c,clickTitle_Protection_Fee__c,acfOngoing_Fees__c,
                 acfLegal_Fees__c,acfApplication_Fee__c,acfRate__c,acfComparison_Rate__c,clickMonthly_Fees__c,clickTotal_Upfront_Fee__c from OpportunityLineItems) from Opportunity where id in:setOpportunityID])
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
            TotalMortgageRiskFee  = OppLi.clickMortgage_Risk_Fee__c;
          if(OppLi.clickTitle_Protection_Fee__c <> null)
            TotalTitleProtectionFee = OppLi.clickTitle_Protection_Fee__c;
          if(OppLi.clickTotal_Upfront_Fee__c <> null)
            TotalUpfronFee = OppLi.clickTotal_Upfront_Fee__c;
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
      for(LVR_Rate__c objLVRRate:[select id,acfLVR__c,acfProduct__c,acfProduct__r.RecordType.Name,acfRate__c,acfAnnual_Fees__c,acfApplication_Fee__c,acfTotal_Fee__c,ACF_Comparison_Rate__c,acfEstablishment_Fee__c,clickFixed_Interest_Rate__c,acfLegal_Fees__c,
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
                Decimal CurrentEMI = 0;
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
                 if(objFinalLVR <> null && acfRate <> null && TenureInYears <> null)
                 {
                       CurrentEMI = acfCommon.calculateMonthlyPayment(LoanAmount,double.valueof(acfRate),PaymentType,double.valueof(TenureInYears));
                       objOppLi.UnitPrice = CurrentEMI;
                       objOppLi.acfRate__c = acfRate;
                       objOppLi.acfComparison_Rate__c = objFinalLVR.ACF_Comparison_Rate__c;
                       objOppLi.Quantity  = TenureInYears*12;
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
        set<id> setOfRequiredDocumentId = new set<id>();
        for (OpportunityLineItem objOLI: triggerNew)
        {
            system.debug('objoli--------------------'+objoli);
            if(objOLI.PricebookEntryId <> null && objOLI.Opportunityid <> null)
            {
                mapPricebookEntryIdToOpportunityID.put(objOLI.PricebookEntryId,objOLI.OpportunityId);
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
                 }   
            }
        }
        List<Product_Document__c>  lstProductDocument = new List<Product_Document__c>();
        if(mapProduct2IdToOpportunityID.keyset() <> null)
        lstProductDocument = [select id,Click_Loans_Required_Document_del__c,Product__c from Product_Document__c
                                where Product__c =:mapProduct2IdToOpportunityID.keyset()]; 
        List<Required_Document__c>  lstRequiredDocument = new List<Required_Document__c>();                 
        if(lstProductDocument <> null && lstProductDocument.size() > 0) 
        {
            for(Product_Document__c objProductDocument : lstProductDocument)
            {
                if(objProductDocument.Click_Loans_Required_Document_del__c <> null)
                {
                    if(!setOfRequiredDocumentId.contains(objProductDocument.Click_Loans_Required_Document_del__c))
                    {
                        Required_Document__c objRequiredDocument = new Required_Document__c(id=objProductDocument.Click_Loans_Required_Document_del__c);
                        objRequiredDocument.acfOpportunity__c = mapProduct2IdToOpportunityID.get(objProductDocument.Product__c);
                        lstRequiredDocument.add(objRequiredDocument);
                        setOfRequiredDocumentId.add(objProductDocument.Click_Loans_Required_Document_del__c);
                    }
                }
            }
        }   
        if(lstRequiredDocument <> null && lstRequiredDocument.size() > 0)
        {
            update lstRequiredDocument;
        }
    }
}