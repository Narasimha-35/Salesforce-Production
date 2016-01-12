/*====================================================
               WHITE LABEL
========================================================*/

Public class WLId_VerifyController {
    Public String retUrl;
    Public List<User> lstuser;
    Public Boolean isSkipvisible {get;set;}
    //Public String UserId;
    Public Click_Community_Setup__c lstCommunity = new Click_Community_Setup__c();
    Public string strNetworkId;
    
    Public WLId_VerifyController()
    {
         strNetworkId =  Network.getNetworkId();
         if(strNetworkId != null)
         {
              system.debug('=======Network ID======'+strNetworkId);
              lstCommunity = ClickCommon.getCommunitySetup(strNetworkId);
         }
         
         lstuser = [select Id, ContactId, Contact.acf_Lead__c from User where Id =: userinfo.getuserId()];
         isSkipvisible = true;
        //UserId = userinfo.getuserId();
        String strLeadId = ClickCommon.getCurrentLoggedInLeadId(userinfo.getuserId());
        If(strLeadId <> '' && strLeadId !=null)
        {
            List<Lead> lstLead = [select id,acfIs_Bank_Statement_Submitted__c,acfIs_Post_Login_Ques_Attempted__c from lead where id=:strLeadId];
            If(lstLead != null && lstLead.size()>0)
            {
                   If(lstLead[0].acfIs_Bank_Statement_Submitted__c && lstLead[0].acfIs_Post_Login_Ques_Attempted__c)
                   {
                        isSkipvisible = false;
                   }
            }
        }
        retUrl = '';  
        //ClickQuoteDetail.intWidth = 10;
        WLQuoteDetail.setProgressBarWidth(0,0,(ClickCommon.getCommunitySetup(strNetworkId)).Click_Page_Prefix__c+'id_verification',strNetworkId);
    }
    
    Public pagereference redirectToJumio()
    {
        Pagereference pageref = new pagereference('/'+(ClickCommon.getCommunitySetup(strNetworkId)).Click_Page_Prefix__c+'jumiointegration');
        pageref.setredirect(true);
        return pageref;
    }
    
    Public pagereference redirectToNextPage()
    {
        string loggedInOppId = ClickCommon.getCurrentLoggedInOpportunityId(UserInfo.getuserId(),(ClickCommon.getCommunitySetup(strNetworkId)).Click_Page_Prefix__c);
        if(loggedInOppId == null)
        {
            string strLoggedInleadid = ClickCommon.getCurrentLoggedInLeadId(userInfo.getuserId());
            if(strLoggedInleadid != null)
            {
                lead leadObj = new lead(acfIs_Identity_Document_Submitted__c =true,clickJumio_Status__c = 'Skipped', id= strLoggedInleadid);
                update leadObj;
            }
        }else if(loggedInOppId != null){
            opportunity objOpp = new opportunity(acfIs_Identity_Document_Submitted__c =true,clickJumio_Status__c = 'Skipped',id= loggedInOppId);
            update objOpp;
        }
        String retPgname = ClickCommon.sendReturnUrl(userinfo.getuserId(),false,(ClickCommon.getCommunitySetup(strNetworkId)).Click_Page_Prefix__c+'id_verification',strNetworkId);
        Pagereference pageref = new Pagereference(retPgname);
        //Pagereference pageref = page.acfBankDetails;
       // pageref.setredirect(true);
        return pageref;
    }
    
    Public pagereference redirect()
    {
      string returnURL;
      if(strNetworkId != null)
      {
          returnURL = ClickCommon.redirect(userinfo.getuserId(),(ClickCommon.getCommunitySetup(strNetworkId)).Click_Page_Prefix__c+'id_verification',strNetworkId);
      }
      if(returnURL != null && returnURL <> '' && returnURL != 'false')
      {
           return new Pagereference(returnURL);
      }else{
          return null;
      }
      /*  String strOppId = ClickCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId());
        If(strOppId != null && strOppId <> ''){
          List<Opportunity> lstOpportunity = [select id,acfIs_Identity_Document_Rejected__c,acfIs_Identity_Document_Submitted__c from Opportunity where id =: strOppId];
            If(lstOpportunity != null && lstOpportunity.size()>0){ 
              If(lstOpportunity[0].acfIs_Identity_Document_Rejected__c == false)       
               return new Pagereference('/clickdashboard');
          }
        }
       return null;   */     
    }


}