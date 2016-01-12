public class WLLoginController {

    public string operatingSec {get;set;}
    public string strmsgs {get;set;}
    public string fstrmsgs {get;set;}
    public String username {get; set;}
    public String Fusername {get; set;}
    public String password {get; set;}
    public boolean success {get; set;}
    
    public WLLoginController()
    { 
        operatingSec = 'login';
    }
    public void UserforgotPassword() 
    {
        fusername= fusername.trim();
         operatingSec = 'forgetPass';
         strmsgs = '';
         fstrmsgs = '';
         success  = false;
         String Networkid = Network.getNetworkId();
         if(Networkid != null && fusername!= null && fusername!='')
         {
            string strUsername = fusername;
            Click_Community_Setup__c commSetup = ClickCommon.getCommunitySetup(Networkid);
            if(commSetup != null)
            {
                 if(commSetup.Community_User_Name_Prefix__c != null)
                     strUsername = commSetup.Community_User_Name_Prefix__c + fusername;
                 list<User> lstuser =[select id,Username from user where username =: strUsername ];
                 
                 if(lstuser != null && lstuser.size() > 0)
                 {
                    success  = Site.forgotPassword(strUsername);
                    if (!success)              
                        fstrmsgs = 'Please enter a Valid User Name.';
                     else
                     {
                         fstrmsgs ='Password reset successfully. Please check your link in your mail';
                         fusername = '';
                     }
                      
                 } 
                 else
                  fstrmsgs = 'Invalid username';
            }
            else
                  fstrmsgs = 'Some thing going wrong';
         } 
         else 
         {
             fstrmsgs ='Please enter Username.';
             
         }
    }
     public PageReference Userlogin() 
     {
         username = username.trim();
         strmsgs = '';
         fstrmsgs = '';
         operatingSec = 'login';
         success  = false;
         String Networkid = Network.getNetworkId();
         if(Networkid != null && username!= null && username!='' && password !=Null && password != '')
         {
            string strUsername = username;
            Click_Community_Setup__c commSetup = ClickCommon.getCommunitySetup(Networkid);
            if(commSetup != null)
            {
                 if(commSetup.Community_User_Name_Prefix__c != null)
                     strUsername = commSetup.Community_User_Name_Prefix__c + username;
                 list<User> lstuser =[select id,Username from user where username =: strUsername ];
                 if(lstuser != null)
                 {
                     
                     pagereference prf = Site.login(strUsername,password,ClickCommon.URLPrefix + commSetup.Click_Page_prefix__c + 'DashBoard');
                     if(prf != null)
                         return prf;
                     else
                         strmsgs ='Username and Password not matching'; 
                 } 
                 else
                  strmsgs = 'Invalid username';
            }
            else
                  strmsgs = 'Some thing going wrong';
         } 
         else 
         {
             strmsgs='Please enter Username & Password.';
             
         }
         return null;
     }
}