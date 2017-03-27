public class DealIQConditionTriggerHandler extends TriggerHandler{
    public override void afterInsert() {
      
       insertRequiredDocuments();
       
    }
    
    public override void afterUpdate() {
      
       deleteRequiredDocuments();
       
    }
    
    private void insertRequiredDocuments(){
        List<Required_Document__c> reqDocList = new List<Required_Document__c>();
        Set<id> dealGlobalSet = new Set<id>();
        Map<id,Global_DealIQ_Condition__c> dealGlobalMap = new Map<id,Global_DealIQ_Condition__c>();
        
        for(acfDealIQ_Condition__c dealCond:(List<acfDealIQ_Condition__c>)trigger.new){
            dealGlobalSet.add(dealCond.acfGlobal_DealIQ_Rule__c);
        }
        
        List<Global_DealIQ_Condition__c> acfGlobalList = [Select id,Name,Document_Master__c FROM Global_DealIQ_Condition__c where id=:dealGlobalSet];
        Map<id,Document_Master__c> docMasterMap = new Map<id,Document_Master__c>([Select id,Name,acf_Source__c FROM Document_Master__c LIMIT 50000]);
        
        for(Global_DealIQ_Condition__c deal:acfGlobalList){
            dealGlobalMap.put(deal.id,deal);
        }
        
        for(acfDealIQ_Condition__c dealCond:(List<acfDealIQ_Condition__c>)trigger.new){
            system.debug('hiiii');
            Required_Document__c reqDoc = new Required_Document__c();
            if(dealGlobalMap != null && dealGlobalMap.containsKey(dealCond.acfGlobal_DealIQ_Rule__c) && dealCond.acfOpportunity__c != null){
                system.debug('@@@'+dealGlobalMap);
                string docMasterId = dealGlobalMap.get(dealCond.acfGlobal_DealIQ_Rule__c).Document_Master__c;
                reqDoc.acfDocument_Master__c = docMasterId;
                reqDoc.acfOpportunity__c = dealCond.acfOpportunity__c;
                reqDoc.DealIQCondition__c = dealCond.id;
                if(docMasterMap != null && docMasterId != null)
                    reqDoc.Name = docMasterMap.get(docMasterId).Name + '- Condition';
                if(docMasterMap.get(docMasterId).acf_Source__c == 'Jumio'){
                    reqDoc.acf_Is_Identity_Verification_Doc__c = true;
                }
                else if(docMasterMap.get(docMasterId).acf_Source__c == 'Bank Statement'){
                    reqDoc.acf_Bank_Statement_Doc__c = true;
                }
                else if(docMasterMap.get(docMasterId).acf_Source__c == 'Downloadable'){
                    reqDoc.Is_Download_Doc__c = true;
                }
                else if(docMasterMap.get(docMasterId).acf_Source__c == 'E-Consent'){
                    reqDoc.Click_Is_E_consent__c = true;
                }
                else if(docMasterMap.get(docMasterId).acf_Source__c == 'Note'){
                    reqDoc.Click_Is_Note_Type__c = true;
                }
            }
            reqDocList.add(reqDoc);
        }
        if(reqDocList!=null && reqDocList.size() > 0){
            insert reqDocList;
        }
       
    }
    
    private void deleteRequiredDocuments(){
        List<Required_Document__c> reqDocList = new List<Required_Document__c>();
        Set<id> dealGlobalSet = new Set<id>();
        Map<id,Required_Document__c> reqDealMap = new Map<id,Required_Document__c>();
        List<Required_Document__c> deleteReqList = new List<Required_Document__c>();
        
        String STATUS = 'acfStatus__c';
        for(acfDealIQ_Condition__c dealCond:(List<acfDealIQ_Condition__c>)trigger.new){
            dealGlobalSet.add(dealCond.id);
        }
        
        reqDocList = [Select id,DealIQCondition__c FROM Required_Document__c where DealIQCondition__c=:dealGlobalSet];
        for(Required_Document__c req:reqDocList){
            reqDealMap.put(req.DealIQCondition__c,req);
        }
        
        for(acfDealIQ_Condition__c dealCond:(List<acfDealIQ_Condition__c>)trigger.new){
            
            if(dealCond.acfStatus__c != null && dealCond.acfStatus__c != trigger.oldMap.get(dealCond.id).get(STATUS) && dealCond.acfStatus__c == 'System Mitigated'){
                if(reqDealMap!= null && reqDealMap.containsKey(dealCond.id)){
                    deleteReqList.add(reqDealMap.get(dealCond.id));
                }  
            }
        } 
        if(deleteReqList != null && deleteReqList.size()  > 0){
            delete deleteReqList;
        } 
    }
}