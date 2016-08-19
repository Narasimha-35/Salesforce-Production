public  class acfTriggerOnOpportunityLineItemHandler 
{
  public void OnBeforeInsert(List<Opportunitylineitem>triggerNew)
  {
    UpdateOpportunityLineItem(triggerNew);  
    //Added on 02-03-2016 regarding multiple product funtionality
    ValidateExistingBankProducts(triggerNew);
  }
  public void OnBeforeUpdate(List<Opportunitylineitem>triggerNew)
  {
    UpdateOpportunityLineItem(triggerNew);
  }
  public void OnAfterInsert(List<Opportunitylineitem>triggerNew)
  {
    
    UpdateFeeInOpportunity(triggerNew);
    updateRequiredDocumentOnOpportunity(triggerNew);
    updateFundingPosition(triggerNew);
  }
  public void OnAfterUpdate(List<Opportunitylineitem>triggerNew)
  {
    UpdateFeeInOpportunity(triggerNew);
    updateRequiredDocumentOnOpportunity(triggerNew);
    updateFundingPosition(triggerNew);
  }
  public void OnAfterDelete(List<Opportunitylineitem>triggerOld)
  {
      UpdateFeeInOpportunity(triggerOld);
  }
  
  public void updateFundingPosition(List<opportunitylineitem> triggernew){
    Set<id> oppIdSet = new Set<Id>();
    for(OpportunityLineItem tNew:triggernew){
        oppIdSet.add(tNew.OpportunityId);
    }
    List<Funding_Position__c> fPositionList = new List<Funding_Position__c>();
    if(oppIdSet.size() > 0){
         List<OpportunityLineItem> oppLineList = [SELECT acfLegal_Fees__c,clickEstablishment_Fee__c,clickMortgage_Risk_Fee__c FROM OpportunityLineItem where OpportunityId =:oppIdSet ORDER BY CreatedDate ASC LIMIT 1];
         fPositionList  = [SELECT Id,Lender_Set_Up_Fees__c FROM Funding_Position__c where Opportunity__c =:oppIdSet];
         if(fPositionList.size() >0){
             for(Funding_Position__c fList:fPositionList){
                 
                if(oppLineList[0].acfLegal_Fees__c != null && oppLineList[0].clickEstablishment_Fee__c !=null && oppLineList[0].clickMortgage_Risk_Fee__c !=null){
                    fList.Lender_Set_Up_Fees__c = Integer.valueOf(oppLineList[0].acfLegal_Fees__c) + Integer.valueOf(oppLineList[0].clickEstablishment_Fee__c) + Integer.valueOf(oppLineList[0].clickMortgage_Risk_Fee__c);
                }
             }
             update fPositionList;
         }
         
     }
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
    if(triggerNew <> null && triggerNew.size()>0)
    {
      for(OpportunityLineItem objOppLi:triggerNew)
      {
        //Added on 3/2/2016
        objOppLi.Quantity = 1;
        objOppLi.click_Loan_Amount__c = objOppLi.UnitPrice;
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
        // changes done by Ankit 
        // added GUID functionality.
        if(triggerNew != null && triggerNew.size() > 0)
        {
             map<id,id> mapOppLineItemIdToOppId = new map<id,id>();
             string strCommName = System.label.Lendi; 
             set<Id> setOfOppId = new set<Id>();
             Id lendiRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(strCommName).getRecordTypeId();
             for(OpportunityLineItem objOppLineItem : triggerNew)
             {
                 if(objOppLineItem.OpportunityId != null)
                     mapOppLineItemIdToOppId.put(objOppLineItem.id,objOppLineItem.OpportunityId);
             }
              
             List<Opportunity> lstOpp = new List<Opportunity>();
             if(mapOppLineItemIdToOppId != null && !mapOppLineItemIdToOppId.isempty() && mapOppLineItemIdToOppId.values() != null && string.isNotempty(strCommName) && lendiRecordTypeId != null)
                 lstOpp =[select id,RecordTypeId,Community_Setup__c,Community_Setup__r.Name from Opportunity where id=:mapOppLineItemIdToOppId.values() 
                          and Community_Setup__c != null and Community_Setup__r.Name =: strCommName and RecordTypeId =:lendiRecordTypeId];
             if(lstOpp != null && !lstOpp.isempty())
             {
                 for(Opportunity objOpp : lstOpp)
                 {
                     setOfOppId.add(objOpp.Id);
                 }
             }
             for(OpportunityLineItem objOppLineItems : triggerNew)
             {
                 system.debug('mapOppLineItemIdToOppId ************'+mapOppLineItemIdToOppId+'%^&*'+ mapOppLineItemIdToOppId.get(objOppLineItems.Id));
                 system.debug('setOfOppId************'+setOfOppId+'%^&*'+ setOfOppId.contains(objOppLineItems.OpportunityId));
                 if(mapOppLineItemIdToOppId != null && !mapOppLineItemIdToOppId.isempty() && mapOppLineItemIdToOppId.get(objOppLineItems.Id) != null && setOfOppId != null
                    && setOfOppId.size() > 0 && setOfOppId.contains(objOppLineItems.OpportunityId) && string.isEmpty(objOppLineItems.Lendi_Opportunity_Product_uuid__c))
                 {
                     List<string> lstGuid = new List<string>();
                     lstGuid = Utilities.NewGuid();
                     if(lstGuid != null && !lstGuid.isEmpty())
                         objOppLineItems.Lendi_Opportunity_Product_uuid__c = lstGuid[0];
                 }
             }
        }
        
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