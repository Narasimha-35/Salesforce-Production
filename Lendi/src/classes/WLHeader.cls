Public Class WLHeader
{
    public string strusername{get;set;}
    public string strPassword{get;set;}
    public string strTimezoneId{get;set;}
    public String strforgotUsername {get;set;}
    public Boolean mailSent {get;set;}
    public String showConfirmMsg {get;set;}
    public string pge_name {set; get;}
    public string NetworkId;
    public Click_Community_Setup__c ObjcommSetup;
    
    public acfContentManagementSystem__c cms_obj {get; set;}
    public list<acfContentManagementSystem__c> lstFooterLinks {get;set;}
    public string selectedLinkId {get;set;}
    public Map<string,string> mapCMSpgid {get;set;}
    
    public string strURLPrefix
    {
       get
       {
           return ClickCommon.URLPrefix;
       }
       set;
    }
   
    public boolean isLoggedIn
    {
        get
        {
            if (UserInfo.getName().tolowercase().contains('guest'))
            return false;
            else
            return true;
        }
        set;
    }
    
    public WLHeader()
    {
        strusername = '';
        strPassword = '';
        strTimezoneId = '';
        strforgotUsername = '';
        mailSent = false;
        
        NetworkId = Network.getNetworkId();
        Click_Community_Setup__c commSetup = ClickCommon.getCommunitySetup(NetworkId);
        
        string pge = Apexpages.currentPage().getUrl();
        List<String> parts = pge.split('/'); 
        List<String> parts1 = parts[2].split('\\?');
        pge_name = parts1[0].toLowerCase(); 
        system.debug('cons pge_name --------'+pge_name);  
        
        mapCMSpgid = new map<string,string>();
        if(NetworkId != null)
        { 
            cms_obj = [select id,name,acfDescription__c,acfPageName__c,acfSectionName__c from acfContentManagementSystem__c  where acfPageName__c = 'common' and acfSectionName__c = 'Footer' and Click_Community_Setup__c =:commSetup.id limit 1]; 
            lstFooterLinks = [select id,name,acfDescription__c,acfPageName__c,acfSectionName__c,acfLink_URL__c,acfIs_Checked__c,acfHeading__c,acfSequence__c,acfHeader_Sequance__c,acfCMS_Page__c from acfContentManagementSystem__c  where acfSectionName__c = 'Footer Links' AND acfIs_Checked__c = true AND Click_Community_Setup__c =:commSetup.id  order by acfSequence__c];
            for(acfContentManagementSystem__c cmsObj : lstFooterLinks)
            {
                If(cmsObj.acfCMS_Page__c != null)
                {   
                    mapCMSpgid.put(cmsObj.id,cmsObj.acfCMS_Page__c); 
                }
            }  
        }     
    }    
    //added by karthik on 25-04-2015 
    public pageReference memberLogin()
    {
        if(strusername != null && strusername.trim() <> '')
        {
            if(strPassword <> null && strPassword <> '')
            {
                strUsername = strUsername.trim();
                String Networkid = Network.getNetworkId();
                string strFUsername = strUsername;
                Click_Community_Setup__c commSetup = ClickCommon.getCommunitySetup(Networkid);
                if(commSetup.Community_User_Name_Prefix__c != null)
                strFUsername = commSetup.Community_User_Name_Prefix__c + strUsername;
                
                list<User> lstUser = [select id, acfIs_Password_Reset__c,TimeZoneSidKey,contact.acfIsLoginAttemptCompleted__c from user where username =: strFUsername.trim() and IsActive =: true];
                system.debug('@@@@lstuser'+lstUser);
                if(lstUser != null && lstUser.size() > 0)
                {
                    if(lstUser[0].acfIs_Password_Reset__c == false)
                    {
                        If(lstUser[0].contact != null)
                        {
                            lstUser[0].contact.acfIsLoginAttemptCompleted__c = true;
                            Update lstUser[0].contact;
                        }
                        // return site.login(strusername.trim(), strPassword.trim(), '/acfLoanDashboard'); 
                    }
                    system.debug('karthik@@@'+strTimezoneId);
                    if(strTimezoneId != null && strTimezoneId <> '')
                    {
                        lstUser[0].TimeZoneSidKey = strTimezoneId;
                        Update lstUser[0];
                    }
                    string retUrl = ClickCommon.sendReturnUrl(lstUser[0].id,false,'Login',NetworkId);//acfLoanDashboard'
                    system.debug('@@@ retUrl'+retUrl);
                    return site.login(strFUsername.trim(), strPassword.trim(),'/'+retUrl); 
                    }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid username and password'));  
                    return null;
                }
                
            }
            else
            {
                //strMsg = 'ACF_Valid_UserName';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid password'));  
                return null;
            } 
        }
        else
        {
            strusername = '';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid username'));  
            return null;  
        }    
        return null;
    }
    
    public void ResetPassword()
    {
        mailSent = false;
        system.debug('@@@test'+strforgotUsername);
        
        String Networkid = Network.getNetworkId();
        string strFUsername = strforgotUsername;
        Click_Community_Setup__c commSetup = ClickCommon.getCommunitySetup(Networkid);
        if(commSetup.Community_User_Name_Prefix__c != null)
        strFUsername = commSetup.Community_User_Name_Prefix__c + strforgotUsername;
        
        if(strforgotUsername != '')
        {
            List<User> lstUser = [select Id,Name,IsActive,Email,MobilePhone from user where Username =: strFUsername];
            
            if(lstUser != Null && lstUser.size() > 0)
            {
                User objForgotuser = lstUser[0];
                
                if(objForgotuser.IsActive)
                {    
                    try
                    {
                        Boolean emailsent = Site.forgotPassword(strFUsername);
                        system.debug('emailsent'+emailsent);
                        if(emailsent)
                        {
                            String strMessage = 'A link has been sent to your email ID ('+objForgotuser.Email+'). Please follow the link to reset your password.';
                            mailSent = true;
                            showConfirmMsg = strMessage;
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Password reset mail sent successfully.'));    
                            // String response = acfCommon.sendSMS(objForgotuser.Name,objForgotuser.MobilePhone,strMessage,true);
                        }
                        else
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in reseting password.'));  
                        }
                    }
                    catch(Exception ex)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));  
                    }
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This user is temporary disabled or not an active user.'));  
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Username.'));  
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide value for username.'));  
        }
    }
    
    public pagereference clearUserSessionCookies()
    {
        Click_Community_Setup__c commSetup = ClickCommon.getCommunitySetup(Networkid);
        Cookie  ACFQues = new Cookie(commSetup.Click_Page_Prefix__c+'ACFQues',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{ACFQues});
        
        Cookie  ACFAnswers = new Cookie(commSetup.Click_Page_Prefix__c+'ACFAnswers',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{ACFAnswers});        
        
        Cookie  IsNewHomeLoan = new Cookie(commSetup.Click_Page_Prefix__c+'IsNewHomeLoan',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{IsNewHomeLoan});   
        
        Cookie LeadId = new Cookie(commSetup.Click_Page_Prefix__c+'leadId',null,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{LeadId});
        
        return null;
    }
    
    Public pagereference resetforgotPopup()
    {
        mailSent = false;
        strforgotUsername = '';
        return null;
    }
}