public with sharing class FundingPositionTriggerHandler extends TriggerHandler{
    
    
    string strAmountPurchase = system.label.acf_AMOUNT_PURCHASE;
    
    public override void beforeUpdate() 
    { 
        updateFPRecordsUpdate();
    }
    
    public void  updateFPRecordsUpdate(){
        for(Funding_Position__c fPos:(List<Funding_Position__c>)trigger.new){
           if(fPos.AmountPurachaseStamp__c != trigger.oldmap.get(fPos.id).get(strAmountPurchase)){
                if(fPos.AmountPurachaseStamp__c > 0){
                    fPos.Client_Legal_Fees__c = 1500;
                }
                else if(fPos.AmountPurachaseStamp__c == 0){
                    fPos.Client_Legal_Fees__c = 0;
                }
            }
        }
    }
}