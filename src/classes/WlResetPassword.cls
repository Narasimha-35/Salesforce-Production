public class WlResetPassword 
{
        //variables declarations
    public String stroldPassword {get;set;} 
    public String strnewPassword {get;set;}
    public String strverifynewPassword {get;set;}
    public String isSuccess {get;set;}
    Public String pageName {get;set;} 
    Public Boolean IsLoginAttemptCompleted {get;set;}
    List<User> lstUser;
    //Constructor
    public wlResetPassword()
    {
        stroldPassword = '';
        strnewPassword = '';
        strverifynewPassword = '';
        isSuccess = 'False';
        
        string pge = Apexpages.currentPage().getUrl();
        List<String> parts = pge.split('/'); 
        List<String> parts1 = parts[2].split('\\?');
        pageName = parts1[0].toLowerCase(); 
        system.debug('cons pge_name --------'+pageName);   
       /* pageName   = ApexPages.CurrentPage().getUrl(); 
        pageName = pageName.replaceFirst('/apex/',''); 
        pageName = pageName.substring(0,pageName.indexof('?')); 
        system.debug('test' + pageName);
        pageName = pageName.toLowerCase();*/
        lstUser = [select id,AccountId from user where id=: UserInfo.getuserId()];
        
        If(lstUser != null && lstUser.size()>0){
            If(lstUser[0].AccountId != null){
             list<Account> lstAccount = [select id,acfIsLoginAttemptCompleted__pc,acfPassword__c from account where id=:lstUser[0].AccountId];
              system.debug('@@@Karthik'+lstUser[0]);
              if(lstAccount != null && lstAccount.size()>0)
              {
               IsLoginAttemptCompleted = lstAccount[0].acfIsLoginAttemptCompleted__pc; 
               If(IsLoginAttemptCompleted == false && pageName != 'clickeditprofile'){
                     stroldPassword = lstAccount[0].acfPassword__c;
               }
              }
            }
        }
      }    
    
    public PageReference ResetPassword()
    {
       isSuccess = 'False';
     /*  If(lstUser != null && lstUser.size()>0){
            If(lstUser[0].Account != null){
               system.debug('@@@'+lstUser[0]);
               IsLoginAttemptCompleted = lstUser[0].Account.acfIsLoginAttemptCompleted__pc; 
               If(IsLoginAttemptCompleted == false && pageName != 'clickeditprofile'){
                  stroldPassword = lstUser[0].Account.acfPassword__c;
               }
            }
        }*/
        system.debug('@@@@'+stroldPassword);
        if(stroldPassword != Null && stroldPassword != '' && strnewPassword != Null && strnewPassword != '' && strverifynewPassword != Null && strverifynewPassword != '')
        {

                if(strnewPassword.length() > 8 && strverifynewPassword.length() > 8 && ChkValidPassword(strnewPassword) && ChkValidPassword(strverifynewPassword))
                {
                    try
                    {
                        PageReference chngpass = Site.changePassword(strnewPassword,strverifynewPassword,stroldPassword);
                        
                        if(chngpass != null)
                        {
                            if(pageName == 'clickeditprofile')
                            {
                                User objuser = new User(id=UserInfo.getUserId());  
                                objuser.acfIs_Password_Reset__c = true;
                                update objuser;
                                isSuccess = 'True';
                                return null;
                            }
                            else
                            {
                                String strReturnUrl = acfCommon.sendReturnUrl(UserInfo.getUserId(),false,'acfResetPassword');
                                
                                if(strReturnUrl != 'error')
                                {
                                    User objuser = new User(id=UserInfo.getUserId());  
                                    objuser.acfIs_Password_Reset__c = true;
                                    update objuser;
                                    
                                    string retUrl = Clickcommon.sendReturnUrl(objuser.id,false,'acfResetPassword',Network.GetNetworkId());
                                    
                                    PageReference pageref = new PageReference(retUrl);
                                    pageref.setRedirect(true);
                                    return(pageref);
                                }   
                                else
                                {
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error occured. contact administrator...'));  
                                    return null;              
                                }      
                            }
                        }
                        
                        return null;
                    }
                    catch(Exception ex)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));  
                        return null;          
                    }
                }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Password must be greater than 8 characters and alphanumeric'));  
                return null;      
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide values for all the fields'));  
            return null;  
        }
    }
    
    public boolean ChkValidPassword(string strPassword)
    {
        if(!Pattern.matches('(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9!@#$%^&*]{8,20})', strPassword))
        {
            return false;
        }
        else
        {
            return true;
        }
    }
}