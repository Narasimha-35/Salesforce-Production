public class WLFeedDashboard {

    public user user_obj {set; get;}
    
    public WLFeedDashboard() {
        id user_id = userInfo.getUserId(); 
        
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
        String oppId = acfCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId()); 
        If(oppId != null && oppId <> ''){
           return null;
        }else{
                String retUrl  = acfCommon.sendReturnUrl(userInfo.getuserId(),false,'acfFeedDashboard'); 
                Pagereference pageref= new Pagereference('/'+retUrl);
                return pageref;
             }
    }   
}