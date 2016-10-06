//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#    Date              Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0                       Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
public class PepperLoanProductFeeTriggerHandler extends TriggerHandler
{
    public override void BeforeInsert() 
    {
        updatePepperLoanProductFee();
    }
    
    public void updatePepperLoanProductFee()
    {
        Map<string,String> mapPepperLoanProductUniqueIdToId = new Map<string,string>();
        set<string> setOfUniqueId = new set<string>();
        for(Pepper_Loan_Product_Fee__c objPepperLoanProductFee : (List<Pepper_Loan_Product_Fee__c>) Trigger.new)
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
        
        for(Pepper_Loan_Product_Fee__c objPepperLoansProductFees : (List<Pepper_Loan_Product_Fee__c>) Trigger.new)
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