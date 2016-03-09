global class acfBankInformationDetails_broker
{
    //public properties
    public integer intStepNumber{get;set;}
    public string strBankSlugName{get;set;}
    Public string strBankName {get;set;}
    public string strUserName{get;set;}
    public string strPassword{get;set;}
    public string strParentId{get;set;}    
    public string loginType{get;set;}
    Public string strSelectedOption {get;set;}
    public list<AllAccountsClass> lstBankAccounts {get; set;}
    public list<acfBank_Detail__c> lstbank;
    public List<Institution.Credential> lstCredentials {get;set;}
    Public Id loggedInOppId;
    Public string captchaImgUrl {get;set;} 
    Public Map <Integer,acfBank_Information__c> mapBankstepSequance {get;set;}
    public string strErrorMsg {get;set;}
    public list<string> lstUserCredentials;
    public list<string> lstUserQuearyType;
    public list<string> lstWaterMarkText;
    public Boolean isSkipvisible {get;set;}
    public acResponse.bankSatementResponseSuccessorFailure bnk_stmt_success_failure;
    public boolean BankNotFound {get;set;}
    public string UserAccountId{get;set;}
    public id LogedInuserId{get;set;}
    //public string strUserCredentials;
    //Constructor
    public acfBankInformationDetails_broker () 
    {
    
    
        UserAccountId=  ApexPages.currentPage().getParameters().get('cid'); 
        user userDetail = [select id,accountId,firstname,lastname from user where AccountId=:UserAccountId limit 1];
        LogedInuserId=userDetail.id;
        BankNotFound = false;
        intStepNumber = 1;
        strBankName = ''; 
        strBankSlugName = '';
        strUserName = 'Card / Access Number';
        strPassword = 'Security Number';
        strErrorMsg = '';
        mapBankstepSequance = new Map <Integer,acfBank_Information__c>();
        lstUserCredentials = new list<string>();
        lstUserQuearyType = new list<string>();
        lstWaterMarkText = new list<string>();
        loggedInOppId = acfCommon.getCurrentLoggedInOpportunityId(LogedInuserId);
        loginType = '1';
        // 1 : Username and Password
        // 2 : Username, Password and Captcha
        // 3 : Card number, Security Number, Internet Password and Issue Number
        
        lstBankAccounts = new list<AllAccountsClass>(); 
        lstCredentials = new List<Institution.Credential>();
        lstbank = new list<acfBank_Detail__c>();
        acfBank_Information__c objbankinfo = new acfBank_Information__c();
        for(Integer i=1;i<5;i++)
        {
           objbankinfo = acfBank_Information__c.getvalues('ClickScreen '+i);      
           mapBankstepSequance.put(i,objbankinfo);
           objbankinfo = new acfBank_Information__c();
        }
        isSkipvisible = true;
        String strLeadId = acfCommon.getCurrentLoggedInLeadId(LogedInuserId);
        If(strLeadId <> '' && strLeadId !=null)
        {
            List<Lead> lstLead = [select id,acfIs_Bank_Statement_Submitted__c,acfIs_Post_Login_Ques_Attempted__c,acfIs_Identity_Document_Submitted__c from lead where id=:strLeadId];
            If(lstLead != null && lstLead.size()>0)
            {
                   If(lstLead[0].acfIs_Identity_Document_Submitted__c && lstLead[0].acfIs_Post_Login_Ques_Attempted__c)
                   {
                        isSkipvisible = false;
                   }
            }
        }
        //ClickQuoteDetail.intWidth = 10;
        ClickQuoteDetail_partner.setProgressBarWidth(0,0,'BrokerClickBankInfoDetails');
    }
    
    //This method is used to select the bank name and populate the required fields on screen for login 
    public void SelectBankName()
    {
        BankNotFound = false;
       if(strBankSlugName != null && strBankSlugName <> '')
       {

        acfbankStatementRequest obj = new acfbankStatementRequest();
            Institution objBankLoginDetail = obj.FetchInstitutionDetails(strBankSlugName);
            If(objBankLoginDetail != null && objBankLoginDetail.credentials != null && objBankLoginDetail.credentials.size()>0){
                    lstCredentials = objBankLoginDetail.credentials.clone();
                    If(objBankLoginDetail.requires_preload == '1'){
                        captchaImgUrl = obj.PreloadFetchCaptcha(strBankSlugName);
                    }
                    system.debug('NRAC:::INSTITUTIONS:::'+objBankLoginDetail);
                    system.debug('Credentials::::'+lstCredentials);
                    for(integer i=0;i<lstCredentials.size();i++){
                        lstWaterMarkText.add(lstCredentials[i].name);
                    }
                    intStepNumber = 2;
                    mapBankstepSequance.get(intStepNumber).acfHeader_Text__c = mapBankstepSequance.get(intStepNumber).acfHeader_Text__c.replace('<Bankname>',strBankName);
                }
                else
                {
                    BankNotFound = true;
                    strBankName = '';
                }
          }else {
                    strErrorMsg = 'Please select bank';
                }  
    }
    
    public void hidepopup()
    {
        BankNotFound = false;
    }
    
    //This method is used to log into the selected bank and desplay the list of associated account
    public void BankLogin()
    {
      strErrorMsg = '';
        for(integer i=0;i<lstCredentials.size();i++){
            lstUserCredentials.add(lstCredentials[i].name);
            lstUserQuearyType.add(lstCredentials[i].fieldID);
        }
        system.debug('@@@@@testing'+lstUserCredentials);
        if(lstUserCredentials != null && lstUserQuearyType != null && lstUserQuearyType.size()>0 && lstUserCredentials.size()>0)
        {
            acfbankStatementRequest obj = new acfbankStatementRequest();
            bnk_stmt_success_failure = obj.loginRequest(strBankSlugName,lstUserCredentials,lstUserQuearyType, false);
            
            if(bnk_stmt_success_failure.success == true)
            {                        
                bankStatementResponse.cls_accounts bnk_stmt_cls_account = new bankStatementResponse.cls_accounts();
               // bankStatementResponse bnk_stmt_response = new bankStatementResponse();
               // bnk_stmt_response.accounts = bnk_stmt_success_failure.response.accounts;
                
                //system.debug('bnk_stmt_cls_account true==========='+bnk_stmt_cls_account);
                
                if(lstBankAccounts != null){
                    lstBankAccounts.clear();
                    intStepNumber = 3;
                }
                
                for(bankStatementResponse.cls_accounts bnk_cls_account : bnk_stmt_success_failure.response.accounts)
                {                   
                    AllAccountsClass all_account = new AllAccountsClass();
                    all_account.accountHolder = bnk_cls_account.accountHolder;
                    all_account.name = bnk_cls_account.name;
                    all_account.id = bnk_cls_account.id;
                    all_account.available = bnk_cls_account.available;
                    all_account.balance = bnk_cls_account.balance;
                    all_account.bsb = bnk_cls_account.bsb;
                    all_account.accountNumber = bnk_cls_account.accountNumber;
                    all_account.chk_box = true;
                    
                    lstBankAccounts.add(all_account); 
                }
                
                system.debug('NRAC::::'+lstBankAccounts);
            }else{
                 strErrorMsg = 'Please enter valid credentials';
              //strErrorMsg  = bnk_stmt_success_failure.Message;
                for(integer i=0;i<lstCredentials.size();i++){
                    lstCredentials[i].name = lstWaterMarkText[i];
                } 
            }
        }else{
                strErrorMsg = 'Please enter valid credentials';   
                for(integer i=0;i<lstCredentials.size();i++){
                    lstCredentials[i].name = lstWaterMarkText[i];
                }    
             }
     }
    
    //This method is used to fetch bank statements for the selected accounts
    public void FetchStatements()
    {
        string strSelectedAccounts = '';
        if(lstBankAccounts.size() > 0)
        {           
            //Adding selected account ids in strSelectedAccounts to fetch bank details
            for(AllAccountsClass all_account : lstBankAccounts)
            {
                if(all_account.chk_box == true)
                {
                    if(strSelectedAccounts == '')
                        strSelectedAccounts = all_account.id;
                    else
                        strSelectedAccounts = strSelectedAccounts + ',' + all_account.id;
                }
            }
          if(strSelectedAccounts != null && strSelectedAccounts <> '')
          {
            //TODO: Convert to dynamic
            //strParentId = '00QO0000002R6mY';
            If(loggedInOppId != null && loggedInOppId <> ''){
                strParentId = loggedInOppId;
            }else{
                    strParentId = acfCommon.getCurrentLoggedInLeadId(LogedInuserId);
                 }
            if(lstUserCredentials != null && lstUserQuearyType != null && lstUserQuearyType.size()>0 && lstUserCredentials.size()>0)
            {
                    acfbankStatementRequest obj = new acfbankStatementRequest();
                    //obj.initiate(strBankSlugName, lstUserCredentials, lstUserQuearyType, false, strParentId, strSelectedAccounts);
                    system.debug('@@@@@@@test'+bnk_stmt_success_failure);
                    obj.statementRequest(bnk_stmt_success_failure,strParentId,false,strSelectedAccounts,strBankSlugName);
                    intStepNumber = 4;
            }

          }else{
                strErrorMsg = 'Please select accounts';
          }
        }
    }
    
    //This is the Wrapper class for binding the account details on VF Page
    public class AllAccountsClass{
        public boolean chk_box {get; set;}
        public String accountHolder {get; set;}
        public String name {get; set;} 
        public String accountNumber {get; set;} 
        public String id {get; set;} 
        public String bsb {get; set;} 
        public String balance {get; set;}  
        public String available {get; set;}  
    }
    
    //This is the Wrapper class for binding the ERROR message
    public class ErrorMessage{
        public string error {set; get;} 
        public integer errorcode {set; get;}
        public string user_token {set; get;}
    }
    //added by Karthik 13-01-2015
   public PageReference redirectToNextpage()
   {
        If(loggedInOppId == null)
        {
            acfBank_Detail__c bnkObj = [select id,name,acfBank_Name__c,acfBankSlugName__c from acfBank_Detail__c where acfBankSlugName__c =: strBankSlugName];        
            lead leadObj = new lead(acfBankNameForAccountDetails__c=bnkObj.id,acfIs_Bank_Statement_Submitted__c=true,acfBankdetailStatus__c = 'Completed', id= strParentId);
            update leadObj;
            list<task> lstTask = [select id,subject,status from task where acf_Is_Upload_Bank_Stmt__c = true limit 1];
            if(lstTask != null && lstTask.size()>0)
            {
                lstTask[0].status = 'Completed';
                if(!Test.isRunningTest()){
                    update lstTask[0];
                }
            }
        }
        String retUrl = acfcommon.sendReturnUrl(LogedInuserId,false,'ClickBankInfoDetails');
        PageReference pageref = new PageReference('/apex/Broker'+retUrl+'?cid='+UserAccountId);
        return(pageref);
   }
   public pagereference skipMethod() {
   
       If(loggedInOppId == null){
           string strLoggedInleadid = acfcommon.getCurrentLoggedInLeadId(LogedInuserId);
           lead leadObj = new lead(acfIs_Bank_Statement_Submitted__c=true,acfBankdetailStatus__c = 'Skipped', id= strLoggedInleadid);
           update leadObj;
       }
       String retUrl = acfcommon.sendReturnUrl(LogedInuserId,false,'ClickBankInfoDetails');
       system.debug('@@@'+retUrl);
       PageReference pageref = new PageReference('/apex/Broker'+retUrl+'?cid='+UserAccountId);
       return(pageref);
   }
   Public pagereference redirect()
   {
      string returnURL = acfcommon.redirect(LogedInuserId,'clickbankInfodetails');
      if(returnURL != null && returnURL <> '' && returnURL != 'false')
      {
           return new Pagereference('/apex/Broker'+returnURL+'?cid='+UserAccountId);
      }else
      {
              return null;
      }
      /* String oppId = acfCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId()); 
        If(oppId != null && oppId <> ''){
           return new Pagereference('/acfLoanDashboard');
        }else{
                return null;
      }*/
    }
    
    //For Go Back
     Public pagereference gobackmethod()
     {
         intStepNumber = intStepNumber -1;
         return null;
     }
   
    @RemoteAction
    global static List<acfBank_Detail__c> AutoCompleteBanklList(string strFilter)
    {  
    If(strFilter!=null && strFilter <> ''){
        //List<acfBank_Detail__c> lstBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c,acfBankSlugName__c,acfBank_Short_Name__c,click_is_Active__c from acfBank_Detail__c where click_is_Active__c = true AND (acfBank_Name__c like: strFilter+'%' OR acfBank_Short_Name__c like: strFilter+'%')];
        List<acfBank_Detail__c> lstBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c,acfBankSlugName__c,acfBank_Short_Name__c from acfBank_Detail__c where  (acfBank_Name__c like: strFilter+'%' OR acfBank_Short_Name__c like: strFilter+'%') and clickShow_on_Bank_Statements_Integration__c = true];
        return lstBank;
        }
        else 
           return new List<acfBank_Detail__c>();
    }   
}