public class WLTaskDashboard {

    Public list<task> tsk_obj {get; set;}
    Public id user_id;
    Public user user_obj;
    Public List<Opportunity> List_opp;
    Public String strTasksub {get;set;}
    public boolean isBankTaskDone {get;set;}
    public boolean isIDverifyDone {get;set;} 
    public string strNetworkId;
    public String MyOpportunityIds;
    public string setMyOpportunityIds(String testId)
    {
        MyOpportunityIds = testId; 

        If(MyOpportunityIds != null && MyOpportunityIds <> '')    // List_opp != null && !List_opp.isEmpty()
        {
            List_opp = [select id,acfBankdetailStatus__c,clickJumio_Status__c from opportunity where id=:Id.valueof(MyOpportunityIds)];
            tsk_obj = [SELECT ActivityDate, Id, Status,IsVisibleInSelfService, Subject, WhatId, WhoId, who.name FROM Task WHERE WhatId =: id.valueof(MyOpportunityIds)];   //List_opp[0].Id
            system.debug('task object ------ '+tsk_obj);
            if(List_opp[0].acfBankdetailStatus__c == 'Completed'){
                isBankTaskDone = true;
            }
            if(List_opp[0].clickJumio_Status__c == 'Attempted'){
                isIDverifyDone = true;
            }
        }
        return null; 
    } 
    
    public String getMyOpportunityIds()
    {
       return MyOpportunityIds; 
    }

    Public WLTaskDashboard() 
    {
    //  user_id = userInfo.getUserId();
        List_opp = new List<Opportunity>();     
        strTasksub = '';
        isBankTaskDone = false;
        isIDverifyDone = false;
    /*  Opportunity opp = new Opportunity();
        if(user_id != null)
        {
            user_obj = [select id, name, email, ContactId,AccountId from user where id =: user_id];
            system.debug('user_obj------'+user_obj);
            strNetworkId=  Network.getNetworkId();
            opp.id = ClickCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId(),ClickCommon.getCommunitySetup(strNetworkId).Click_Page_Prefix__c); 
            If(user_obj != null && user_obj.AccountId != null && opp <> null)
            {
                List_opp = [select id,acfBankdetailStatus__c,clickJumio_Status__c from opportunity where id=:opp.id];
            }    
        }    */       
    }
    Public pagereference redirect(){
        strNetworkId=  Network.getNetworkId();
        String oppId =  MyOpportunityIds ; // ClickCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId(),ClickCommon.getCommunitySetup(strNetworkId).Click_Page_Prefix__c); 
        If(oppId != null && oppId <> ''){
           return null;
        }else{
                String retUrl  = ClickCommon.sendReturnUrl(userInfo.getuserId(),false,'acfTaskDashboard',strNetworkId); 
                Pagereference pageref= new Pagereference('/'+retUrl);
                return pageref;
             }
    } 
    
   Public pagereference toOpenTaskdetails(){
      // system.debug('@@@subject'+strTasksub);
       String retUrl = '';
       If(strTasksub != null && strTasksub <> ''){
           List<acfTask_Master__c> lstTask = [select id,acfLink_page__c,acfDescription__c,acfIsActive__c,acfStage__c,acfSubject__c 
                                             from acfTask_Master__c where acfIsActive__c=true AND acfStage__c='Opportunity Creation' AND acfSubject__c =: strTasksub];
           
           If(lstTask != null && lstTask.size()>0){
            retUrl = lstTask[0].acfLink_page__c;
            return new pagereference('/'+retUrl);
           } 
       }
       return null;
   } 
}