/*====================================================
                WHITE LABEL
========================================================*/
public class WLDashboardController 
{
    //Property to display and maintain selected tab
    public string strActiveTab{get;set;}
    public boolean isPasswordReset {get;set;}
    
    //Constructor
    public WLDashboardController()
    {
        Cookie cookieActiveTab = ApexPages.currentPage().getCookies().get('cookieActiveTab');
        isPasswordReset = false;
        List<User> lstUser = [select id,acfIs_Password_Reset__c from User where id =: UserInfo.getuserId() AND IsActive =: true];
        If(lstUser != null && lstUser.size()>0)
        {
           isPasswordReset = lstUser[0].acfIs_Password_Reset__c;
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
      
      if(returnURL != null && returnURL <> '' && returnURL != 'false') return new Pagereference(returnURL);
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
}