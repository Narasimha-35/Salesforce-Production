/*====================================================
                Click Loans
========================================================*/

public class acfTaskDashboard {

    Public list<task> tsk_obj {get; set;}
    Public id user_id;
    Public user user_obj;
    Public List<Opportunity> List_opp;
    Public String strTasksub {get;set;}
    public boolean isBankTaskDone {get;set;}
    public boolean isIDverifyDone {get;set;} 
    Public acfTaskDashboard () 
    {
        user_id = userInfo.getUserId();
        List_opp = new List<Opportunity>();
        strTasksub = '';
        isBankTaskDone = false;
        isIDverifyDone = false;
        if(user_id != null)
        {
            user_obj = [select id, name, email, ContactId,AccountId from user where id =: user_id];
            system.debug('user_obj------'+user_obj);
            String oppId = acfCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId()); 
            If(user_obj != null && user_obj.AccountId != null && oppId <> null)
            {
                List_opp = [select id,acfBankdetailStatus__c,clickJumio_Status__c from opportunity where id=:oppId];
            }
             
            If(List_opp != null && !List_opp.isEmpty())
            {
                tsk_obj = [SELECT ActivityDate, Id, Status,IsVisibleInSelfService, Subject, WhatId, WhoId, who.name FROM Task WHERE WhatId =: List_opp[0].Id];
                system.debug('task object ------ '+tsk_obj);
                if(List_opp[0].acfBankdetailStatus__c == 'Completed'){
                    isBankTaskDone = true;
                }
                if(List_opp[0].clickJumio_Status__c == 'Attempted'){
                    isIDverifyDone = true;
                }
            }
        }
    }
    Public pagereference redirect(){
        String oppId = acfCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId()); 
        If(oppId != null && oppId <> ''){
           return null;
        }else{
                String retUrl  = acfCommon.sendReturnUrl(userInfo.getuserId(),false,'acfTaskDashboard'); 
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