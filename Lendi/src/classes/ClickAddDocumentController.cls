public class ClickAddDocumentController
{
    public string MyAccountId{get; set;}
    public  string strReqDocName {get;set;}
    public Account objAccount;
    public string strerrMsg{get;set;}
    public boolean isDocAdded {get;set;}
    public string docMasterId {get;set;}
    public string strCommunityName {get;set;}
    public boolean strCommName {get;set;}
    public String MyOpportunityIds;
    public string setMyOpportunityIds(String testId)
    {
        MyOpportunityIds = testId; 
     // AddDocument();
        return null; 
    } 
    
    public String getMyOpportunityIds()
    {
       return MyOpportunityIds; 
    }
    
    public void AddDocument()
    {
        
    }
    public ClickAddDocumentController()
    {   
        strerrMsg = ''; 
        isDocAdded = false;
        docMasterId = '';   
        strReqDocName = '';
        
        strCommunityName = ClickCommon.getCommunitySetup(Network.getNetworkId()).Click_Page_Prefix__c;
        if(strCommunityName == 'ACF')
        {
        strCommName = false;
        }
        else if(strCommunityName == 'Click')
        {
        strCommName  = true;
        }     
    }
    
 /*   public Account getObjAccount()
    {
       Account objAcc = new Account();
       List<User> lstUser = [select id,AccountId,acfIs_Password_Reset__c from User where id =: UserInfo.getuserId() AND IsActive =: true];
        if(lstUser != null && lstUser.size()>0)
        {
            MyAccountId = lstUser[0].AccountId;
        }
        if(MyAccountId != null)
        {
            list<Account> lstAccount = [select id,acf_Lead__pc,acf_Lead__pr.isConverted,acf_Lead__pr.ConvertedOpportunityId from account where id =: MyAccountId];           
            
            if(lstAccount != null && lstAccount.size()>0)
            {
                objAcc = lstAccount[0];
            }
        }
        return objAcc;
    }     */
    public void insertReqDocument()
    {
       try
       {
     /* objAccount = getObjAccount();
        system.debug('objAccount!@#$%'+objAccount+'!@#$%^&*ANKIT'+objAccount.acf_Lead__pr+'*******'+objAccount.acf_Lead__pr.ConvertedOpportunityId);  */
        if(MyOpportunityIds != null && MyOpportunityIds <> '')   
        {
           system.debug('MyOpportunityIds___________AddDoc'+MyOpportunityIds);
           system.debug('strReqDocName ###########'+strReqDocName );
           system.debug('docMasterId ###########'+docMasterId );
                
           if(strReqDocName != null && strReqDocName <> '' && docMasterId != null && docMasterId <> '')
           { 
                List<Document_Master__c> lstDocMaster = [select id,acf_Source__c from Document_Master__c where id=:docMasterId and
                                                            (acf_Source__c = 'Jumio' OR acf_Source__c = 'Bank Statement' OR acf_Source__c = 'Note')];
                system.debug('lstDocMaster ###########'+lstDocMaster);                                            
                Required_Document__c ObjReqDocument = new Required_Document__c();
                ObjReqDocument.Name = strReqDocName;
                ObjReqDocument.acfStatus__c = 'Pending';
                ObjReqDocument.acfDocument_Master__c = docMasterId;
                if(lstDocMaster <> null && lstDocMaster.size() > 0)
                {
                    if(lstDocMaster[0].acf_Source__c == 'Jumio')
                    {
                        ObjReqDocument.acf_Is_Identity_Verification_Doc__c = true;
                    }
                    if(lstDocMaster[0].acf_Source__c == 'Bank Statement')
                    {
                        ObjReqDocument.acf_Bank_Statement_Doc__c = true;
                    }
                    if(lstDocMaster[0].acf_Source__c == 'Note')
                    {
                        ObjReqDocument.Click_Is_Note_Type__c = true;
                    }
                }
                if(MyOpportunityIds != null && MyOpportunityIds <> '') // objAccount.acf_Lead__pc != null && objAccount.acf_Lead__pr.isConverted == true
                {
                   ObjReqDocument.acfOpportunity__c = Id.valueof(MyOpportunityIds); //objAccount.acf_Lead__pr.ConvertedOpportunityId;
                }
                insert ObjReqDocument;
                system.debug('ObjReqDocument___________'+ObjReqDocument);
                strerrMsg = 'Required document added successfully.';
                isDocAdded = true;
           }else{
               strerrMsg = 'Please fill all required fields';
           }
        }else{
             strerrMsg = 'Required document not added,Please try again!';
        }
       }catch(Exception ex)
           {
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please fill all values'));
             strerrMsg = 'Required document not added,Please try again!';
           }
    }
       
   public pagereference reqDocCancel()
   {   
 //   string strNetworkId =  Network.getNetworkId();
      if(ClickCommon.getCommunitySetup(Network.getNetworkId()).Click_Page_Prefix__c != null)
      {
        Pagereference pageref = new Pagereference('/apex/'+ClickCommon.getCommunitySetup(Network.getNetworkId()).Click_Page_Prefix__c+'Dashboard?id='+MyOpportunityIds);
        pageref.setRedirect(true);
        Cookie cookieActiveTab = new Cookie('cookieActiveTab', 'Document', null, -1, true);           
        ApexPages.currentPage().setCookies( new Cookie[]{ cookieActiveTab });
        return pageref;
       }
       return null;
    }
    
    public void resetReqDocPopup()
    {
        strerrMsg = '';
        docMasterId = '';
        strReqDocName = '';
        isDocAdded = false;
    }
    
    public List<SelectOption> getDocumentMasterNames()
    {         
        List<Document_Master__c> lstDocMaster = [select id,Name,acfActive__c from Document_Master__c where acfActive__c = true AND Click_Community_Setup__r.Click_Network_ID__c=: Network.getNetworkId() order by Name ASC];
        List<SelectOption> options = new List<SelectOption>();
        if(lstDocMaster != null && lstDocMaster.size()>0)
        {
           options.add(new SelectOption('','--NONE--'));
           for(Document_Master__c objDocMaster : lstDocMaster)
           { 
             options.add(new SelectOption(objDocMaster.id,objDocMaster.Name));
           }
        }
        return options;
    }
}