/*====================================================
                WHITE LABEL
========================================================*/
public class WLDashboardController 
{
    //Property to display and maintain selected tab
    public string strActiveTab{get;set;}
    public boolean isPasswordReset {get;set;}
    public id accntid{set;get;}
    public Id communityId{get;set;}
    public id redirectOpportunityId{get;set;}
    public id OpportunityId{get;set;}
    Private string strNetworkId;
    public List<Wrapper> lstwrapper{get;set;}
    public String selectedLoanType{get;set;}
    public id redirectOppId{get;set;}

    
    //Constructor
    public WLDashboardController()
    {
        lstwrapper = new List<Wrapper>();
        Cookie cookieActiveTab = ApexPages.currentPage().getCookies().get('cookieActiveTab');
        isPasswordReset = false;
        List<Opportunity> lstOppo = new List<Opportunity>();
        if(ClickCommon.getConvertedOpportunityId(UserInfo.getuserId()) !=  null)
            redirectOpportunityId = ClickCommon.getConvertedOpportunityId(UserInfo.getuserId());
        redirectOppId = redirectOpportunityId;      
        
        List<User> lstUser = [select id,AccountId,Account.Click_Community_Setup__c,acfIs_Password_Reset__c from User where id =: UserInfo.getuserId() AND IsActive =: true];
        If(lstUser != null && lstUser.size()>0)
        {
           isPasswordReset = lstUser[0].acfIs_Password_Reset__c;
           accntid = lstUser[0].AccountId;
           communityId = lstUser[0].Account.Click_Community_Setup__c;
        }
        
        if(accntid != null && communityId != null)
        {
            lstOppo = [select id,Name,Community_Setup__c,AccountId from Opportunity where Community_Setup__c=:communityId and AccountId=:accntid ORDER BY LastModifiedDate DESC]; 
            system.debug('!@#$Ankit*************************'+lstOppo);
            if(!lstOppo.isEmpty())
            {
                for(Opportunity objOpportunity :lstOppo)
                {
                    Wrapper objwrap = new Wrapper();
                    objwrap.opportunityId = objOpportunity.id;
                    objwrap.OpportunityName = objOpportunity.Name;
                    lstwrapper.add(objwrap);
                }
            }
        }
        id OppIds = apexpages.currentpage().getparameters().get('id');   
        if(OppIds != null) 
        {   
            redirectOppId = OppIds;
        }
        else
        {
            if(!lstOppo.isEmpty())
            {
                redirectOppId = lstOppo[0].id;
            }
            else
            {
                redirectOppId = redirectOpportunityId;
            }
        } 
        
        if(cookieActiveTab != null && cookieActiveTab.getvalue() != null && cookieActiveTab.getValue() != '')
            strActiveTab = cookieActiveTab.getValue();
        else
            strActiveTab = 'Loan';
    }
    
    //Method to redirect the user to pending page if opportunity is not created
    Public pagereference redirect()
    {
      string returnURL;
      string strNetworkId =  Network.getNetworkId();
     
      if(strNetworkId != null)
      {
              system.debug('=======Network ID======'+strNetworkId);
            returnURL = ClickCommon.redirect(userinfo.getuserId(),(ClickCommon.getCommunitySetup(strNetworkId)).Click_Page_Prefix__c+'dashboard',strNetworkId);
      }
      if(returnURL != null && returnURL <> '' && returnURL != 'false')
       return new Pagereference(returnURL);
      else return null;
      
        /* String oppId = acfCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId()); 
        
        If(oppId != null && oppId <> '')
        {
            return null;
        }
        else
        {
            String retUrl  = acfCommon.sendReturnUrl(userInfo.getuserId(),false,'clickdashboard'); 
            Pagereference pageref= new Pagereference('/'+retUrl);
            return pageref;
        } */
    }
    
    //Method to maintain current active tab
    public void SetCurrentTab()
    {
        strActiveTab = ApexPages.currentPage().getParameters().get('currenttab');
        
        if(strActiveTab == null || strActiveTab == '')
            strActiveTab = 'Loan';
            
        Cookie cookieActiveTab = new Cookie('cookieActiveTab', strActiveTab, null, -1, true);           
        ApexPages.currentPage().setCookies( new Cookie[]{ cookieActiveTab });
    }
    
   // Wrapper Class for Showing opportunity in Picklist.
   public class Wrapper
   {
       public id opportunityId{get;set;}
       public String OpportunityName{get;set;}    
   } 
   
    // This method is used to redirect to dashboard on the basis of OpportunityId.
    public pagereference redirectOppId()
     {
         List<Click_Community_Setup__c> lstComm = new List<Click_Community_Setup__c>();
         if(communityId != null)
         {
             lstComm = [select id,Click_Page_Prefix__c from Click_Community_Setup__c where id=:communityId];
         }
         String oppid = Apexpages.currentPage().getParameters().get('OpportuntyIds');
         system.debug('###123'+oppid);
         if(!lstComm.isempty() && oppid != null)
             return new pagereference('/'+lstComm[0].Click_Page_Prefix__c +'Dashboard?id='+oppid);
         return null;    
     }

}