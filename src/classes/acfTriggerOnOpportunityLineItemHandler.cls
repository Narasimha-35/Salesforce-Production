public  class acfTriggerOnOpportunityLineItemHandler extends TriggerHandler{
  public override void beforeInsert() { 
    UpdateOpportunityLineItem();  
    //Added on 02-03-2016 regarding multiple product funtionality
    ValidateExistingBankProducts();
    copyProductFields();
   }
  
  
  public void copyProductFields(){
      Set<id> productId = new Set<Id>();
      Map<id,PricebookEntry> priceBookMap = new Map<id,PricebookEntry>([Select id,Product2Id FROM PricebookEntry]);
      for(Opportunitylineitem pro:(List<Opportunitylineitem>) trigger.new){
          if(pro.PricebookEntryId !=null && priceBookMap.containsKey(pro.PricebookEntryId))
              productId.add(priceBookMap.get(pro.PricebookEntryId).Product2Id);
      }
      
      
      Map<Id,Product2> prodObjectMap = new Map<Id,Product2>([Select id,acfInterest_Only_term__c,acfTenure_in_Years__c From Product2 where id IN:productId]);
      for(Opportunitylineitem pro:(List<Opportunitylineitem>) trigger.new){
          if(prodObjectMap !=null && pro.PriceBookEntryId !=null && priceBookMap.containsKey(pro.PricebookEntryId) && priceBookMap.get(pro.PricebookEntryId).Product2Id  != null){
              if(prodObjectMap.get(priceBookMap.get(pro.PricebookEntryId).Product2Id).acfInterest_Only_term__c != null)          
                  pro.Interest_Only_term__c = prodObjectMap.get(priceBookMap.get(pro.PricebookEntryId).Product2Id).acfInterest_Only_term__c;
              if(prodObjectMap.get(priceBookMap.get(pro.PricebookEntryId).Product2Id).acfTenure_in_Years__c !=null)
                  pro.Fix_Rate_Term__c = Integer.valueOf(prodObjectMap.get(priceBookMap.get(pro.PricebookEntryId).Product2Id).acfTenure_in_Years__c);
          }
      }
      
  }
  public override void beforeUpdate()
  {
    UpdateOpportunityLineItem();
  }
  public override void afterInsert()
  {
    
    UpdateFeeInOpportunity();
    createEConsentForProduct('Insert');
    updateRequiredDocumentOnOpportunity();
    updateFundingPosition();
   // populateLoanMaxProduct('Insert',new Set<Id>());
    
    if(ACFSwitch__c.getOrgDefaults().OLIBatchSwitch__c != null && ACFSwitch__c.getOrgDefaults().OLIBatchSwitch__c == true){
     callServicingCalAPI();
    }
    
  }
  public override void afterUpdate()
  {
    UpdateFeeInOpportunity();
    updateRequiredDocumentOnOpportunity();
    updateFundingPosition();
    //populateLoanMaxProduct('Update',new Set<Id>());
    system.debug('==== afterUpdate ');
    
    if(ACFSwitch__c.getOrgDefaults().OLIBatchSwitch__c != null && ACFSwitch__c.getOrgDefaults().OLIBatchSwitch__c == true){
     callServicingCalAPI();
    }
    
  }
  public override void afterDelete()
  {
     // UpdateFeeInOpportunity(triggerOld);
     deleteEConsetForProduct();
   // populateLoanMaxProduct('Delete',new Set<Id>());
     // createEConsentForProduct(triggerold,trigger.oldMap,'Delete');
  }
    Static Integer flagForAPI = 0 ;
    public void callServicingCalAPI(){
       if(flagForAPI  == 0){
          system.debug('==== callServicingCalAPI ');
          List<Opportunitylineitem> oppLineItemList = (List<Opportunitylineitem>)trigger.new ;
          System.debug('AMAR oppLineItemList '+oppLineItemList );
          Opportunitylineitem pliObj ;
          Id pliObjId ;
          for(Opportunitylineitem oppLineItemObj : oppLineItemList ){
            if(oppLineItemObj.OpportunityId <> null){
               pliObjId  = oppLineItemObj.id  ;
               
               break ;
            }
          }
          System.debug('AMAR pliObj 12344567 '+pliObjId );
          pliObj = [SELECT id,PricebookEntry.Product2Id,OpportunityId from Opportunitylineitem  where PricebookEntry.Product2Id != null AND OpportunityId  != null and id = : pliObjId]; 
          System.debug('AMAR pliObj 1234 '+pliObj );
          if(pliObj != null){
              Id productId =    pliObj .PricebookEntry.Product2Id  ;
              Id oppId     =    pliObj .OpportunityId ;
              System.debug('amar123 productId  '+productId +' oppId '+oppId );
              flagForAPI  = flagForAPI  + 1 ;
           // Database.executeBatch(new OpportunityLineItemHandlerBatch (oppId ,productId),1);
          }
       }
    }
  
  public void deleteEConsetForProduct(){
       List<Opportunity> oppList;
       List<Product2> prodList;
       Map<id,id> oppProductMap = new Map<id,id>();
       Set<id> appSet = new Set<id>();
       List<E_Consent__c> consentToDelete = new List<E_Consent__c>();
       Set<id> productSet = new Set<id>();
       Map<id,id> prodBankMap = new Map<id,id>();
       Set<id> oppSet = new Set<id>();
       Map<id,PricebookEntry> priceBookMap = new Map<id,PricebookEntry>([Select id,Product2Id FROM PricebookEntry]);
       
       for(OpportunityLineItem tNew:(List<Opportunitylineitem>) trigger.old){
         system.debug('###tNew'+priceBookMap.get(tNew.PricebookEntryId).Product2Id);
         system.debug('###tNew'+tNew);
         if(priceBookMap !=null && priceBookMap.containsKey(tNew.PricebookEntryId)){
            productSet.add(priceBookMap.get(tNew.PricebookEntryId).Product2Id);
            oppProductMap.put(tNew.id,priceBookMap.get(tNew.PricebookEntryId).Product2Id);
         }
         
         if(tNew.OpportunityId !=null)
            oppSet.add(tNew.OpportunityId);
       }
       
            
        if(oppSet != null && oppSet.size() > 0){
            oppList = [Select id, (Select Id,PricebookEntryId From OpportunityLineItems), (Select id FROM Applicants__r) From Opportunity o where id=:oppSet];
         }
         
         if(productSet != null && productSet.size() > 0){
             prodList = [Select id,Click_Loans_Bank_Detail__c FROM Product2 where id=:productSet];
         }
         
         system.debug('###prodDoc'+prodList);
         for(Product2 pr:prodList){
             prodBankMap.put(pr.id,pr.Click_Loans_Bank_Detail__c);
         }
            
        for(Opportunity opp:oppList){
            for(click_Applicant__c app:opp.Applicants__r){   
                appSet.add(app.id);
            }    
        }
         System.Debug('appset======'+appset);
         List<E_Consent__c> consentExistingList =  [Select id,EConsent_Type__c,Applicant__c,Consent_Completed__c,Related_Bank_Id__c from E_Consent__c where Applicant__c=:appSet];
         System.Debug('=========='+consentExistingList );
         Map<id,List<E_Consent__c>> appConsentMap = new Map<id,List<E_Consent__c>>();
         Set<id> bankStringSet = new Set<id>();
         System.Debug('outttttt');
         for(E_Consent__c conObj:consentExistingList){
             System.Debug('fooooooooooooor');
            if(!appConsentMap.containsKey(conObj.Applicant__c)){
                System.Debug('forrrrrr if');
                appConsentMap.put(conObj.Applicant__c, new List<E_Consent__c>());
            }
            appConsentMap.get(conObj.Applicant__c).add(conObj);
            
         }
         String OPPORTUNITYID = 'OpportunityId';
         Map<id,List<OpportunityLineItem>> deletedLineItem = new Map<id,List<OpportunityLineItem>>();
         for(Id lineId:trigger.oldMap.KeySet()){
             if(!deletedLineItem.containsKey(((OpportunityLineItem)trigger.oldMap.get(lineId)).OPPORTUNITYID))
                 deletedLineItem.put(((OpportunityLineItem)trigger.oldMap.get(lineId)).OPPORTUNITYID,new List<OpportunityLineItem>());
             deletedLineItem.get(((OpportunityLineItem)trigger.oldMap.get(lineId)).OPPORTUNITYID).add((OpportunityLineItem)trigger.oldMap.get(lineId));
         }
         
         for(Opportunity opp:oppList){
            //integer countLineItem = 0;
            System.debug('###prod'+prodBankMap);
             System.debug('###opp'+oppProductMap);
            for(OpportunityLineItem oppLi:opp.OpportunityLineItems){
                oppProductMap.put(oppLi.id,priceBookMap.get(oppLi.PricebookEntryId).Product2Id);
            }
            for(OpportunityLineItem oppLi:opp.OpportunityLineItems){
                bankStringSet.add(prodBankMap.get(oppProductMap.get(oppLi.id)));
            }
            system.debug('###bankStringSet'+bankStringSet);
            System.debug('###deleted'+deletedLineItem.get(opp.id));
            for(OpportunityLineItem oppLi:deletedLineItem.get(opp.id)){
                //if(oppLi.OpportunityId == opp.id){
               if(!bankStringSet.contains(prodBankMap.get(oppProductMap.get(oppLi.id)))){
                  for(click_Applicant__c app:opp.Applicants__r){
                      if(appConsentMap.containsKey(app.id)){
                          for(E_Consent__c econ:appConsentMap.get(app.id)){
                              if(econ.Related_Bank_Id__c == prodBankMap.get(oppProductMap.get(oppLi.id)) && econ.Consent_Completed__c == false){
                                  consentToDelete.add(econ);
                              }
                          }
                      }
                  }  
               } 
            }
               
         }  
         if(consentToDelete.size() > 0){
             delete consentToDelete;
         }
  }
  
  public void createEConsentForProduct(String event){
     Set<id> productSet = new Set<id>();
     Set<id> oppSet = new Set<id>();
     Map<id,List<Product_Document__c>> dependentDocMap = new Map<id,List<Product_Document__c>>();
     List<Opportunity> oppList;
     List<Product2> prodDocList;
     Map<id,id> oppProductMap = new Map<id,id>();
     Map<id,id> prodBankMap = new Map<id,id>();
     Set<id> bankSet = new Set<id>();
     List<E_Consent__c> consentToDelete = new List<E_Consent__c>();
     Map<id,PricebookEntry> priceBookMap = new Map<id,PricebookEntry>([Select id,Product2Id FROM PricebookEntry]);
     List<E_Consent__c> consentList = new List<E_Consent__c>();
     
    
     for(OpportunityLineItem tNew:(List<Opportunitylineitem>) trigger.new){
         system.debug('###tNew'+priceBookMap.get(tNew.PricebookEntryId).Product2Id);
         system.debug('###tNew'+tNew);
         if(priceBookMap !=null && priceBookMap.containsKey(tNew.PricebookEntryId)){
            productSet.add(priceBookMap.get(tNew.PricebookEntryId).Product2Id);
            oppProductMap.put(tNew.id,priceBookMap.get(tNew.PricebookEntryId).Product2Id);
         }
         
         if(tNew.OpportunityId !=null)
            oppSet.add(tNew.OpportunityId);
         
     } 
     if(event == 'Insert'){
         if(oppSet != null && oppSet.size() > 0){
            oppList = [Select id, (Select Id From OpportunityLineItems), (Select id FROM Applicants__r) From Opportunity o where id=:oppSet];
         }
         
         if(productSet != null && productSet.size() > 0){
             prodDocList = [Select id,Click_Loans_Bank_Detail__c ,(Select id,Click_Loans_Document_Master__c,Click_Loans_Document_Master__r.acf_Source__c,Product__c FROM DepedentDocumentOnProduct__r) FROM Product2 where id=:productSet];
         
             system.debug('###prodDoc'+prodDocList);
             for(Product2 pr:prodDocList){
                 system.debug('###bank'+bankSet);
                 if(!bankset.contains(pr.Click_Loans_Bank_Detail__c)){
                     for(Product_Document__c depDoc:pr.DepedentDocumentOnProduct__r){
                         if(!dependentDocMap.containsKey(pr.id)){
                            dependentDocMap.put(pr.id,new List<Product_Document__c>());
                         }
                         if(depDoc.Click_Loans_Document_Master__r.acf_Source__c == 'E-Consent')
                            dependentDocMap.get(pr.id).add(depDoc);
                     }
                     
                     prodBankMap.put(pr.id,pr.Click_Loans_Bank_Detail__c);
                     bankset.add(pr.Click_Loans_Bank_Detail__c);
                 }
                 system.debug('###pro'+prodBankMap);
                 
             }
         }
       
       List<acf_Bank_Template__c> listBankTempLate =  [Select  Template_Version__c ,  Click_Loans_Bank_Detail__c   from acf_Bank_Template__c where Click_Loans_Bank_Detail__c =:bankset];
       map<Id,String> mapBankVersion = new  map<Id,String>();
       if(listBankTempLate.size() > 0)
       {
           for( acf_Bank_Template__c  obj : listBankTempLate )
           {
               if(obj.Template_Version__c  != null  &&   obj.Click_Loans_Bank_Detail__c != null){
                 mapBankVersion.put( obj.Click_Loans_Bank_Detail__c,obj.Template_Version__c);
               }
           }
       }
     
        
         Set<id> appSet = new Set<id>();
         for(Opportunity opp:oppList){
            for(click_Applicant__c app:opp.Applicants__r){
                 appSet.add(app.id);
            }
         }
         
         system.debug('###appSet'+appSet);
         List<E_Consent__c> consentExistingList =  [Select id,EConsent_Type__c,Applicant__c,Related_Bank_Id__c from E_Consent__c where Applicant__c=:appSet];
         
         Set<String> relatedBankId;
         Map<id,List<E_Consent__c>> appConsentMap = new Map<id,List<E_Consent__c>>();
         
         for(E_Consent__c conObj:consentExistingList){
            if(!appConsentMap.containsKey(conObj.Applicant__c)){
                appConsentMap.put(conObj.Applicant__c, new List<E_Consent__c>());
            }
            appConsentMap.get(conObj.Applicant__c).add(conObj);
            
         }
         
         for(Opportunity opp:oppList){
              
             relatedBankId = new Set<String>();
             for(OpportunityLineItem oppLi:opp.OpportunityLineItems){
                
                if(trigger.newMap !=null && trigger.newMap.containsKey(oppLi.id) && oppProductMap!=null && oppProductMap.get(oppLi.id)!= null && oppProductMap.get(oppLi.id) != null && dependentDocMap.get(oppProductMap.get(oppLi.id)) !=null && dependentDocMap.get(oppProductMap.get(oppLi.id)).size() > 0){  
                    for(click_Applicant__c app:opp.Applicants__r){
                        boolean flag = true;
                        if(appConsentMap.containsKey(app.id) && appConsentMap.get(app.id).size() > 0){
                            for(E_Consent__c econ:appConsentMap.get(app.id)){
                                if(econ.Related_Bank_Id__c == prodBankMap.get(oppProductMap.get(oppLi.id))){
                                    flag = false;
                                    break;
                                }
                                else{
                                    continue;
                                }
                            }
                        }
                        if(appConsentMap.containsKey(app.id) && appConsentMap.get(app.id).size() == 0){
                            flag = true;
                        }
                        if(flag == true){
                            
                                consentList.add(new E_Consent__c(EConsent_Type__c = 'Product Specific Econsent',Applicant__c=app.id,Related_Product_Id__c = oppProductMap.get(oppLi.id), Related_Bank_Id__c = prodBankMap.get(oppProductMap.get(oppLi.id))    ));
                            
                        }
                        
                    }
                       
                }
            }
        }
     }
     system.debug('###noEconsnet'+consentList);

     if(consentList.size() > 0){
         insert consentList;
     }
        
      
  }
  
  public void updateFundingPosition(){
    Set<id> oppIdSet = new Set<Id>();
    for(OpportunityLineItem tNew:(List<Opportunitylineitem>) trigger.new){
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
  public void UpdateFeeInOpportunity()
  {
    set<Id>setOpportunityID = new set<Id>();
    List<Opportunity>lstOpportunityToUpdate = new List<Opportunity>();
    for(Opportunitylineitem objOppLi:(List<Opportunitylineitem>) trigger.new)
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
  public void UpdateOpportunityLineItem()
  {
    //if(triggerNew <> null && triggerNew.size()>0)
    //{
      for(OpportunityLineItem objOppLi:(List<Opportunitylineitem>) trigger.new)
      {
        //Added on 3/2/2016
        objOppLi.Quantity = 1;
        objOppLi.click_Loan_Amount__c = objOppLi.UnitPrice;
      }
     //} 
   }
   
   /*public void populateLoanMaxProduct(String event,Set<id> oppAssetSet){
        Set<id> oppSet = new Set<id>();
        Map<id,List<OpportunityLineItem>> oppLineMap = new Map<id,List<OpportunityLineItem>>();
        Map<id,PricebookEntry> priceBookMap = new Map<id,PricebookEntry>([Select id,Product2Id FROM PricebookEntry]);
        Set<id> oppIdSet = new Set<id>();
        Map<id,Double> oppLVRMap = new map<id,Double>();
        decimal houseValue = 0;
        decimal loanAmount = 0;
        Double LVR = 0;
        List<OpportunityLineItem> oppLiDMLList;
        if(event == 'Insert' || event == 'Update')
            oppLiDMLList = (List<OpportunityLineItem>) trigger.new;
        else if(event == 'Delete')
            oppLiDMLList = (List<OpportunityLineItem>) trigger.old;
        else if(event == 'Asset Operation'){
            oppLiDMLList = new List<OpportunityLineItem>();
            oppIdSet = oppAssetSet;
        }
            
        if(oppLiDMLList != null && oppLiDMLList.size() > 0){
            for(OpportunityLineItem objOLI: oppLiDMLList){
                if(!oppLineMap.containsKey(objOLI.OpportunityId)){
                    oppLineMap.put(objOLI.OpportunityId,new List<OpportunityLineItem>());
                }
                //oppLineMap.get(objOLI.OpportunityId).add(objOLI);
                if(objOLI.OpportunityId != null)
                    oppIdSet.add(objOLI.OpportunityId);
            }
        }
        else{
            for(Id oppId: oppIdSet){
                if(!oppLineMap.containsKey(oppId)){
                    oppLineMap.put(oppId,new List<OpportunityLineItem>());
                }
            }
        }
        system.debug('@@@oppidset'+oppIdSet);
        List<Opportunity> lstOpportunity = [Select id,Amount,acfAsset_House_Worth__c,Account.acfAsset_House_Worth__c,AccountId,(Select id,UnitPrice,PricebookEntryId,OpportunityId from OpportunityLineItems) FROM Opportunity where id=:oppIdSet];
        system.debug('@@@lst'+lstOpportunity);
        //List<OpportunityLineItem> lineItemList = new List<OpportunityLineItem>();
        Set<id> productId = new Set<id>();
        Map<id,Id> lineItemProdMap = new Map<id,id>();
        for(Opportunity opp:lstOpportunity){
            if(opp.Amount != null && opp.Account.acfAsset_House_Worth__c !=null){
                houseValue = opp.acfAsset_House_Worth__c;
                for(opportunitylineitem pro:opp.OpportunityLineItems){
                    loanAmount = loanAmount + pro.UnitPrice;
                    if(pro.OpportunityId !=null){
                        oppLineMap.get(pro.OpportunityId).add(pro);
                        if(pro.PricebookEntryId !=null && priceBookMap.containsKey(pro.PricebookEntryId)){
                            productId.add(priceBookMap.get(pro.PricebookEntryId).Product2Id);
                            lineItemProdMap.put(pro.id,priceBookMap.get(pro.PricebookEntryId).Product2Id);
                        }
                    }
                }
                if((loanAmount != null || loanAmount != 0) && (houseValue !=null || houseValue !=0)){
                    LVR = loanAmount/houseValue*100; 
                    system.debug('@@@lvr'+LVR);
                    oppLVRMap.put(opp.id,LVR);
                }
            }
        }
        
      //    Map<Id,Product2> prodObjectMap = new Map<Id,Product2>([Select id,acfInterest_Only_term__c,acfTenure_in_Years__c From Product2 where id IN:productId]);
        List<Product2> productList = [Select id,(Select Name, acfLVR__c, acfLoan_Size__c, clickLVR_From__c, clickLoan_Size_From__c From LVR_Rate__r) From Product2 where id =:productId];
        map<id,List<LVR_Rate__c>> prodLVRMap = new map<id,List<LVR_Rate__c>>();
        for(Product2 prod:productList){
            for(LVR_Rate__c lvrRate:prod.LVR_Rate__r){
                if(!prodLVRMap.containsKey(prod.id)){
                    prodLVRMap.put(prod.id,new List<LVR_Rate__c>());
                }
                prodLVRMap.get(prod.id).add(lvrRate);
            }
        }
        List<Opportunity> oppList = [Select id,(Select id,Used_as_Security__c, Value__c From Asset_And_Liabilities__r) From Opportunity where id=:oppIdSet];
        map<id,Double> oppAssetNumberMap = new map<id,Double>();
        for(Opportunity opp:oppList){
            Double totalValue = 0;
            for(Asset_And_Liability__c asset:opp.Asset_And_Liabilities__r){
                if(asset.Used_as_Security__c == true){
                    totalValue = totalValue + Double.valueOf(asset.Value__c);
                }
            }
            oppAssetNumberMap.put(opp.id,totalValue);
        }
        
        Map<id,Double> maxLVROppPro = new Map<id,Double>();
        Map<id,Double> minLVRMap = new Map<id,Double>();
        for(Id opp:oppLineMap.KeySet()){
            Double minLVR = 0; 
            List<Double> minLVRList = new List<Double>();
            if(oppLineMap.containsKey(opp)){
                for(OpportunityLineItem line:oppLineMap.get(opp)){
                    system.debug('@@@lvrobj1'+line);
                   if( lineItemProdMap.get(line.id)  != null &&   prodLVRMap.get(lineItemProdMap.get(line.id))  != null )
                   {
                   for(LVR_Rate__c lvrObj:prodLVRMap.get(lineItemProdMap.get(line.id))){
                        system.debug('@@@oppLVR'+oppLVRMap.get(opp));
                        system.debug('@@@mylvr'+lvrObj);
                        if(oppLVRMap.containsKey(opp)){
                            if(lvrObj.acfLVR__c>=oppLVRMap.get(opp) && lvrObj.clickLVR_From__c<=oppLVRMap.get(opp) && lvrObj.clickLoan_Size_From__c<= loanAmount && lvrObj.acfLoan_Size__c >= loanAmount){
                                
                                
                                if(!maxLVROppPro.containsKey(line.id)){
                                    maxLVROppPro.put(line.id,lvrObj.acfLVR__c);
                                }
                                else if(maxLVROppPro.containsKey(line.id) && maxLVROppPro.get(line.id) < lvrObj.acfLVR__c){
                                    maxLVROppPro.put(line.id,lvrObj.acfLVR__c);
                                }
                            }
                        }
                    }
                   }
                    
                    if(maxLVROppPro.get(line.id) != null)
                        minLVRList.add(maxLVROppPro.get(line.id));
                }   
            }
           // system.debug('@@@data'+minLVRList[0]);
            system.debug('@@@data1'+oppAssetNumberMap.get(opp));
            system.debug('@@@data2'+minLVRList);
            if(minLVRList != null && minLVRList.size()>0 && oppAssetNumberMap  != null && oppAssetNumberMap.containsKey(opp)){
                minLVRList.sort();
                minLVR = minLVRList[0]/100*oppAssetNumberMap.get(opp);
                minLVRMap.put(opp,minLVR);
            }
        }
        
        if(oppIdSet != null && oppIdSet.size() > 0){
            List<Funding_Position__c> fundingList = [Select id,Loan_Max_Asset__c,Loan_Max_Product__c ,Opportunity__c from Funding_Position__c where Opportunity__c=:oppIdSet];
            if(fundingList != null && fundingList.size() > 0){
                for(Funding_Position__c fp:fundingList){
                    if(minLVRMap.containsKey(fp.Opportunity__c)){
                        fp.Loan_Max_Product__c = minLVRMap.get(fp.Opportunity__c);
                    }
                }
                update fundingList;
            }
            
            if(oppAssetSet.size() == 0){
                AssetAndLiabilityTriggerHandler assetObj= new AssetAndLiabilityTriggerHandler();
               // assetObj.calcLoanValueMaxAsset('LineItemOperation',oppIdset); 
            }
        }   
   }
   */
   
   
   public void updateRequiredDocumentOnOpportunity()
   {
        map<id,id> mapProduct2IdToOpportunityID = new map<id,id>();
        map<id,id> mapPricebookEntryIdToOpportunityID = new map<id,id>();
        set<id> setOfDocumentMasterId = new set<id>();
        set<id> setOfDocMasterId = new set<id>();
        map<id,set<id>> mapopportunityIdtoSetDocMasterId = new map<id,set<id>>();
        set<id> setOfOppId = new set<id>();
         for (OpportunityLineItem objOLI: (List<Opportunitylineitem>) trigger.new)
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
    public void ValidateExistingBankProducts() 
    {
    // changes done by Ankit 
    // added GUID functionality.
    //if(trigger.new != null && trigger.new.size() > 0)
    //{
         map<id,id> mapOppLineItemIdToOppId = new map<id,id>();
         string strCommName = System.label.Lendi; 
         set<Id> setOfOppId = new set<Id>();
         Id lendiRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(strCommName).getRecordTypeId();
         for(OpportunityLineItem objOppLineItem : (List<Opportunitylineitem>) trigger.new)
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
         for(OpportunityLineItem objOppLineItems : (List<Opportunitylineitem>) trigger.new)
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
    //}
    
        Set<Id> setOppIds = new Set<Id>();
        Set<Id> setPriceBookEntryIds = new Set<Id>();
        map<Id,set<Id>> mapOppIdToBankIds = new map<Id,set<Id>>();
        map<Id,Id> mapProdIdToBankId = new map<Id,Id>();
        for(OpportunityLineItem objOppLI : (List<Opportunitylineitem>) trigger.new)
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
                for(OpportunityLineItem objnewOppLI : (List<OpportunityLineItem>) trigger.new)
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