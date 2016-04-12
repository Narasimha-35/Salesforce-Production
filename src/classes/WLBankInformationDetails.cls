global without sharing class WLBankInformationDetails 
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
   // public Boolean isSkipvisible {get;set;}
    public acResponse.bankSatementResponseSuccessorFailure bnk_stmt_success_failure;
    public boolean BankNotFound {get;set;}
    private string strNetworkId;
    private Click_Community_Setup__c objCommunitySetUp;
    public boolean isOppExist {get;set;}
    //public string strUserCredentials;
    //Constructor
    public WLBankInformationDetails () 
    {
        BankNotFound = false;
        intStepNumber = 1;
        strBankName = ''; 
        strBankSlugName = '';
        strUserName = 'Card / Access Number';
        strPassword = 'Security Number';
        strErrorMsg = '';
        isOppExist = false;
        strNetworkId = Network.getNetworkId();
        objCommunitySetUp = new Click_Community_Setup__c ();
        system.debug('Hi Community2'+Network.getNetworkId());
        system.debug('Hi Community1'+ClickCommon.getCommunitySetup(Network.getNetworkId()).id);
        if(ClickCommon.getCommunitySetup(Network.getNetworkId()).id != null)
        {
            system.debug('Hi Community'+ClickCommon.getCommunitySetup(Network.getNetworkId()).id);
            objCommunitySetUp = ClickCommon.getCommunitySetup(Network.getNetworkId());
        }
        mapBankstepSequance = new Map <Integer,acfBank_Information__c>();
        lstUserCredentials = new list<string>();
        lstUserQuearyType = new list<string>();
        lstWaterMarkText = new list<string>();
        if(objCommunitySetUp.Click_Page_Prefix__c != null)
        {
            loggedInOppId = ClickCommon.getCurrentLoggedInOpportunityId(UserInfo.getuserId(),objCommunitySetUp.Click_Page_Prefix__c);
            if(loggedInOppId != null)
            {
                isOppExist = true;
            }
        }
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
           if(strNetworkId != null)
           {
               objbankinfo = acfBank_Information__c.getvalues(objCommunitySetUp.Click_Page_Prefix__c+'Screen '+i);
           }      
           mapBankstepSequance.put(i,objbankinfo);
           objbankinfo = new acfBank_Information__c();
        }
        /*isSkipvisible = true;
        String strLeadId = ClickCommon.getCurrentLoggedInLeadId(userinfo.getuserId());
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
        }*/
        //ClickQuoteDetail.intWidth = 10;
        WLQuoteDetail.setProgressBarWidth(0,0,objCommunitySetUp.Click_Page_Prefix__c+'BankInfoDetails',strNetworkId);
    }
    
    //This method is used to select the bank name and populate the required fields on screen for login 
    public void SelectBankName()
    {
        BankNotFound = false;
       if(strBankSlugName != null && strBankSlugName <> '')
       {

        WLbankStatementRequest obj = new WLbankStatementRequest();
            Institution objBankLoginDetail = obj.FetchInstitutionDetails(strBankSlugName,objCommunitySetUp.Click_Page_Prefix__c);
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
      if(lstCredentials != null && lstCredentials.size()>0)
      {
        for(integer i=0;i<lstCredentials.size();i++)
        {
            lstUserCredentials.add(lstCredentials[i].name);
            lstUserQuearyType.add(lstCredentials[i].fieldID);
        }
      }
        system.debug('@@@@@testing'+lstUserCredentials);
        if(lstUserCredentials != null && lstUserQuearyType != null && lstUserQuearyType.size()>0 && lstUserCredentials.size()>0)
        {
            WLbankStatementRequest obj = new WLbankStatementRequest();
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
              if(lstCredentials != null && lstCredentials.size()>0 && lstWaterMarkText != null && lstWaterMarkText.size()>0)
              {
                for(integer i=0;i<lstCredentials.size();i++){
                    lstCredentials[i].name = lstWaterMarkText[i];
                }
              } 
            }
        }else{
                strErrorMsg = 'Please enter valid credentials'; 
                if(lstCredentials != null && lstCredentials.size()>0)  
                {
                    for(integer i=0;i<lstCredentials.size();i++){
                        lstCredentials[i].name = lstWaterMarkText[i];
                    } 
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
            If(loggedInOppId != null){
                strParentId = loggedInOppId;
            }else{
                    strParentId = ClickCommon.getCurrentLoggedInLeadId(UserInfo.getuserId());
                 }
            if(lstUserCredentials != null && lstUserQuearyType != null && lstUserQuearyType.size()>0 && lstUserCredentials.size()>0)
            {
                    WLbankStatementRequest obj = new WLbankStatementRequest();
                    //obj.initiate(strBankSlugName, lstUserCredentials, lstUserQuearyType, false, strParentId, strSelectedAccounts);
                    system.debug('@@@@@@@test'+bnk_stmt_success_failure);
                    obj.statementRequest(bnk_stmt_success_failure,strParentId,false,strSelectedAccounts,strBankSlugName);
                    system.debug('obj!@#$%^&'+obj);
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
            // changes done by Ankit for Adding bank functionality
          /*  set<id> setOfBankDetailId = new set<id>();
            List<Click_Loans_Bank__c> lstbank = new List<Click_Loans_Bank__c>();
            if(objCommunitySetUp.id <> null)
            {
                lstbank = [select id,Click_Loans_Bank_Detail__c,Community_Setup__c from Click_Loans_Bank__c where Community_Setup__c =:objCommunitySetUp.id];
            }
            if(lstbank.size() > 0 && lstbank != null)
            {
                for(Click_Loans_Bank__c objbank : lstbank)
                {
                        setOfBankDetailId.add(objbank.Click_Loans_Bank_Detail__c);
                }
            }*/
            acfBank_Detail__c bnkObj = new acfBank_Detail__c();
           
            bnkObj = [select id,name,acfBank_Name__c,acfBankSlugName__c from acfBank_Detail__c where acfBankSlugName__c =: strBankSlugName];        
            lead leadObj = new lead(acfBankNameForAccountDetails__c=bnkObj.id,acfIs_Bank_Statement_Submitted__c=true,acfBankdetailStatus__c = 'Completed', id= strParentId);
            update leadObj;
            list<Required_Document__c> lstRequiredDoc = [select id, acfStatus__c from Required_Document__c where acf_Bank_Statement_Doc__c = true
                                                          AND Lead__c=:leadObj.id];
            system.debug('lstRequiredDoc------'+lstRequiredDoc);
            if(lstRequiredDoc != null && lstRequiredDoc.size() > 0)
            {
                     lstRequiredDoc[0].click_Is_Uploaded__c= true; 
                     update lstRequiredDoc[0];        
            }
                                        
            
            String retUrl = ClickCommon.sendReturnUrl(UserInfo.getuserId(),false,objCommunitySetUp.Click_Page_Prefix__c+'BankInfoDetails',strNetworkId);
            PageReference pageref = new PageReference(retUrl);
            return(pageref);
        }
        else
        {
            if(loggedInOppId <> null)
            {
                list<Required_Document__c> lstRequiredDoc = new list<Required_Document__c>();
                String ReqdocId = Apexpages.currentpage().getparameters().get('Docid');
                if(ReqdocId <> null && ReqdocId <> '')
                {
                    lstRequiredDoc = [select id,Name, acfStatus__c from Required_Document__c where acf_Bank_Statement_Doc__c = true AND id =: ReqdocId
                                                                  AND acfOpportunity__c =:strParentId];
                }else{
                        lstRequiredDoc = [select id,Name, acfStatus__c from Required_Document__c where acf_Bank_Statement_Doc__c = true
                                                                  AND acfOpportunity__c =:strParentId];
                    }
                if(lstRequiredDoc != null && lstRequiredDoc.size() > 0)
                {
                     system.debug('!@#$lstRequiredDoc');
                     string strTaskSubject = 'Upload '+lstRequiredDoc[0].name;
                     lstRequiredDoc[0].click_Is_Uploaded__c= true; 
                     update lstRequiredDoc[0]; 
                      
                     system.debug('!@#$strTaskSubject '+strTaskSubject );
                     list<task> lstTask = [select id,subject,status,whatid from task where Subject =:strTaskSubject AND whatid =:strParentId limit 1];
                     if(lstTask != null && lstTask.size()>0)
                     {
                        system.debug('!@#$lstTask'+lstTask);
                        lstTask[0].status = 'Completed';
                        if(!Test.isRunningTest()){
                            update lstTask[0];
                            system.debug('!@#$lstTask'+lstTask[0]);
                        }
                     }    
                } 
            }
                                    
        }
        return null;      
   }
   
   public pagereference skipMethod() 
   {
   
       If(loggedInOppId == null){
           string strLoggedInleadid = ClickCommon.getCurrentLoggedInLeadId(userInfo.getuserId());
           if(strLoggedInleadid <> null && strLoggedInleadid <> ''){
               lead leadObj = new lead(acfIs_Bank_Statement_Submitted__c=true,acfBankdetailStatus__c = 'Skipped', id= strLoggedInleadid);
               update leadObj;
           }
       }
       String retUrl = ClickCommon.sendReturnUrl(UserInfo.getuserId(),false,objCommunitySetUp.Click_Page_Prefix__c+'BankInfoDetails',strNetworkId);
       system.debug('@@@'+retUrl);
       PageReference pageref = new PageReference(retUrl);
       return(pageref);
   }
   
   Public pagereference redirect()
   {
      string returnURL = ClickCommon.redirect(userinfo.getuserId(),objCommunitySetUp.Click_Page_Prefix__c+'BankInfoDetails',strNetworkId);
      if(returnURL != null && returnURL <> '' && returnURL != 'false')
      {
           return new Pagereference(returnURL);
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
        If(strFilter!=null && strFilter <> '')
        {
            /* changes done by Ankit for Adding bank functionality
            set<id> setOfBankDetailId = new set<id>();
            List<Click_Loans_Bank__c> lstbanks = new List<Click_Loans_Bank__c>();
            if(objCommunity.id <> null)
            {
                lstbanks = [select id,Click_Loans_Bank_Detail__c,Community_Setup__c from Click_Loans_Bank__c where Community_Setup__c =:objCommunity.id];
            }
            if(lstbanks.size() > 0 && lstbanks != null)
            {
                for(Click_Loans_Bank__c objbank : lstbanks)
                {
                        setOfBankDetailId.add(objbank.Click_Loans_Bank_Detail__c);
                }
            }*/
            List<acfBank_Detail__c> lstBank = new List<acfBank_Detail__c>();                        
            lstBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c,acfBankSlugName__c,acfBank_Short_Name__c,
                        clickShow_on_Bank_Statements_Integration__c from acfBank_Detail__c where clickShow_on_Bank_Statements_Integration__c = true 
                        AND (acfBank_Name__c like: strFilter+'%' OR acfBank_Short_Name__c like: strFilter+'%')];
            return lstBank;
         }
            else
         return new list<acfBank_Detail__c>();
    }  
}