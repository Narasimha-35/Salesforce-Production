public class acfFeedDashboard_broker {


/*====================================================
                Click Loans
========================================================*/


    public user user_obj {set; get;}
    public Id acid;//use by laxman
    public List<User> ulst;//use by laxman
    
    public acfFeedDashboard_broker() {
        acid=apexpages.currentpage().getparameters().get('cid');//updated by laxman
        ulst=[select id,name from user where accountid =:acid limit 1];//updated by laxman
        id user_id = ulst[0].id; 
        
        if(user_id != null){
            user_obj = [select id,name,FullPhotoUrl,ContactId,accountId from user where id =: user_id];
            system.debug('user_obj' +user_obj);
            
            if(user_obj.ContactId != null){
                contact con_obj = [select id,acf_Lead__c from contact where Id =: user_obj.ContactId]; 
                system.debug('contact object ----------- '+con_obj);              
            }
        }   
    }
    Public pagereference redirect(){
        String oppId = acfCommon.getCurrentLoggedInOpportunityId(ulst[0].id); 
        If(oppId != null && oppId <> ''){
           return null;
        }else{
                String retUrl  = acfCommon.sendReturnUrl(userInfo.getuserId(),false,'acfFeedDashboard'); 
                Pagereference pageref= new Pagereference('/'+retUrl);
                return pageref;
             }
    }   
}