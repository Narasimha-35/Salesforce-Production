//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#    Date              Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0                       Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
public without sharing class PepperLoanProductFeeTriggerHandler
 {
   public void OnAfterInsert(list<Pepper_Loan_Product_Fee__c> triggerNew, map<id,Pepper_Loan_Product_Fee__c> triggerOldMap)
    {
        
    }       
   public void OnAfterUpdate(list<Pepper_Loan_Product_Fee__c> triggerNew, map<id,Pepper_Loan_Product_Fee__c> triggerOldMap,list<Pepper_Loan_Product_Fee__c> triggerOld)
    {
      
    }
   public void OnBeforeInsert(list<Pepper_Loan_Product_Fee__c> triggerNew)
    {
         updatePepperLoanProductFee(triggerNew);
    }
   public void OnBeforeUpdate(list<Pepper_Loan_Product_Fee__c> triggerNew, map<id,Pepper_Loan_Product_Fee__c> triggerOldMap)
    {

    }
   public void OnBeforeDelete(list<Pepper_Loan_Product_Fee__c> triggerOld, map<id,Pepper_Loan_Product_Fee__c> triggerOldMap)
    {
        
    }
   public void OnAfterDelete(list<Pepper_Loan_Product_Fee__c> triggerOld, map<id,Pepper_Loan_Product_Fee__c> triggerOldMap)
    {
         
    }
   public void OnAfterUnDelete(list<Pepper_Loan_Product_Fee__c> triggerNew)
    {
         
    }
    
    
    public void updatePepperLoanProductFee(list<Pepper_Loan_Product_Fee__c> triggerNew)
    {
        Map<string,String> mapPepperLoanProductUniqueIdToId = new Map<string,string>();
        set<string> setOfUniqueId = new set<string>();
        if(triggerNew.size() >0)  
        {        
            for(Pepper_Loan_Product_Fee__c objPepperLoanProductFee : triggerNew)
            {
                string strUniqueId = '';
                if(string.isNotEmpty(objPepperLoanProductFee.OpportunityId__c) && string.isNotEmpty(objPepperLoanProductFee.index__c))
                {
                    strUniqueId = objPepperLoanProductFee.OpportunityId__c +'-:-' +objPepperLoanProductFee.index__c;
                    strUniqueId = strUniqueId.trim();
                    setOfUniqueId.add(strUniqueId);    
                }
            } 
            system.debug('setOfUniqueId8************'+setOfUniqueId);   
        }
        list<Pepper_Loan_Product__c> lstPepperLoanProduct = new list<Pepper_Loan_Product__c>();
        if(setOfUniqueId <> null && setOfUniqueId.size() > 0)
        {
                      
            lstPepperLoanProduct = [select id,Opportunity__c,Index__c,UniqueId__c from Pepper_Loan_Product__c where UniqueId__c IN:setOfUniqueId];
            system.debug('lstPepperLoanProduct ************'+lstPepperLoanProduct );
                                                                                      
        }
        
        if(lstPepperLoanProduct <> null && lstPepperLoanProduct.size() > 0)
        {
            for(Pepper_Loan_Product__c objPepperLoanProduct : lstPepperLoanProduct)
            {
                mapPepperLoanProductUniqueIdToId.put(objPepperLoanProduct.UniqueId__c,objPepperLoanProduct.Id);
                system.debug('mapPepperLoanProductUniqueIdToId************'+mapPepperLoanProductUniqueIdToId);
            }
        }
        
        for(Pepper_Loan_Product_Fee__c objPepperLoansProductFees : triggerNew)
        {
            if(string.isNotEmpty(objPepperLoansProductFees.OpportunityId__c) && string.isNotEmpty(objPepperLoansProductFees.index__c)
                && mapPepperLoanProductUniqueIdToId != null && !mapPepperLoanProductUniqueIdToId.isEmpty() 
                && mapPepperLoanProductUniqueIdToId.get(objPepperLoansProductFees.OpportunityId__c+'-:-'+objPepperLoansProductFees.index__c) != null)
            {
                objPepperLoansProductFees.Pepper_Loan_Product__c = mapPepperLoanProductUniqueIdToId.get(objPepperLoansProductFees.OpportunityId__c+'-:-'+objPepperLoansProductFees.index__c);
                system.debug('!@#$%^&************'+mapPepperLoanProductUniqueIdToId.get(objPepperLoansProductFees.OpportunityId__c+'-:-'+objPepperLoansProductFees.index__c));
            }
        }
    }  
    
}