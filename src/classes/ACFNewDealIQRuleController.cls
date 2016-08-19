public class ACFNewDealIQRuleController{


    public List<Global_DealIQ_Condition__c> dealIQRulelist{get;set;}
    public List<Global_DealIQ_Condition__c> detaillist{get;set;}
    Public String dealId{get;set;}
    
        
        public List<Global_DealIQ_Condition__c> getDealIQRuleListDetail()
        {
           List<Global_DealIQ_Condition__c> dealIQRulelist = new List<Global_DealIQ_Condition__c>();
           dealIQRulelist = [Select Id,Name,Active__c FROM Global_DealIQ_Condition__c ORDER BY CreatedDate ASC];
           return dealIQRulelist;
       }
        
    public PageReference deleteCondition() {
        Global_DealIQ_Condition__c objacfdeal = new Global_DealIQ_Condition__c();
         System.debug('ashishkkakakaka'+dealId);
        objacfdeal = [select id FROM Global_DealIQ_Condition__c where id=: dealId];
       
        if(objacfdeal !=null){
            delete objacfdeal;
        }
        //dealIQRulelist= getDealIQRuleListDetail();
        return null;
    }
    
    public PageReference navigateToPage() {
    system.debug('method');
       
  
       // System.debug('ashna'+detaillist );
        pageReference pageRef = new pageReference('/apex/ClickGlobalConditionsRuleSet?dealId='+dealId);
        
        pageRef.setRedirect(true);
        return pageRef;
        }
       

}