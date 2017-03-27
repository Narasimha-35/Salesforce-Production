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
        
    public PageReference deleteCondition()
    {
        Global_DealIQ_Condition__c objacfdeal = new Global_DealIQ_Condition__c();
        System.debug('ashishkkakakaka'+dealId);
        if(string.isNotempty(dealId))
        {
            objacfdeal = [select id,Name FROM Global_DealIQ_Condition__c where id=: dealId];
            if(objacfdeal !=null)
            {
                try
                {
                    delete objacfdeal;
                    system.debug('try');
                }
                catch (Exception ex)
                {
                    system.debug('!@#$%^**************************');
                    List<acfDealIQ_Condition__c> lstAcfDealIqCondition = new List<acfDealIQ_Condition__c>();
                    lstAcfDealIqCondition = [select id, Name,acfGlobal_DealIQ_Rule__c from acfDealIQ_Condition__c where acfGlobal_DealIQ_Rule__c =:dealId limit 3];
                    system.debug('lstAcfDealIqCondition**************************'+lstAcfDealIqCondition);
                    if(lstAcfDealIqCondition != null && !lstAcfDealIqCondition.isEmpty())
                    {
                        string strMessage = 'Your attempt to delete '+objacfdeal.Name+ ' could not be completed because it is associated with the following';
                        strMessage += ' dealIq conditions - ';
                        for(acfDealIQ_Condition__c objDealIqCondition : lstAcfDealIqCondition)
                        {
                            strMessage+= objDealIqCondition.Name + ', '; 
                        } 
                        strMessage = strMessage.removeEnd(', ');  
                        strMessage+= '. Please remove the reference to delete it.';  
                        system.debug('strMessage**************************'+strMessage);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,strMessage));              
                    }
                }
            }
            return null;
        }
        return null;
    }
    
    public PageReference navigateToPage()
    {
        if(string.isNotempty(dealId))
        {
            pageReference pageRef = new pageReference('/apex/ClickGlobalConditionsRuleSet?dealId='+dealId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }
}