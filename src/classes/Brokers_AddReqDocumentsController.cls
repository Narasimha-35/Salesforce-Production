public class Brokers_AddReqDocumentsController
{
    public string MyAccountId{get; set;}
    public  string strReqDocName {get;set;}
    public Account objAccount;
    public string strerrMsg{get;set;}
    public boolean isDocAdded {get;set;}
    public string docMasterId {get;set;}
    public Brokers_AddReqDocumentsController()
    {
        strerrMsg = ''; 
        isDocAdded = false;
        docMasterId = '';   
        strReqDocName = '';
    }
    
    public Account getObjAccount()
    {
       Account objAcc = new Account();
        if(MyAccountId != null && MyAccountId <> '')
        {
            list<Account> lstAccount = [select id,acf_Lead__pc,acf_Lead__pr.isConverted,acf_Lead__pr.ConvertedOpportunityId from account where id =: MyAccountId];           
            
            if(lstAccount != null && lstAccount.size()>0)
            {
                objAcc = lstAccount[0];
            }
        }
        return objAcc;
    }
    public void insertReqDocument()
    {
       try
       {
        objAccount = getObjAccount();
        if(objAccount != null && objAccount.acf_Lead__pr.ConvertedOpportunityId != null)
        {
           if(strReqDocName != null && strReqDocName <> '' && docMasterId != null && docMasterId <> '')
           { 
                Required_Document__c ObjReqDocument = new Required_Document__c();
                ObjReqDocument.Name = strReqDocName;
                ObjReqDocument.acfStatus__c = 'Pending';
                ObjReqDocument.acfDocument_Master__c = docMasterId;
               /* if(objAccount.acf_Lead__pc != null && objAccount.acf_Lead__pr.isConverted == false)
                {
                    ObjReqDocument.Lead__c = objAccount.acf_Lead__pc;
                }else*/
                    if(objAccount.acf_Lead__pc != null && objAccount.acf_Lead__pr.isConverted == true)
                    {
                       ObjReqDocument.acfOpportunity__c = objAccount.acf_Lead__pr.ConvertedOpportunityId;
                    }
                insert ObjReqDocument;
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
        Pagereference pageref = new Pagereference('/apex/BrokerClickDashboard?cid='+MyAccountId);
        pageref.setRedirect(true);
        Cookie cookieActiveTab = new Cookie('cookieActiveTab', 'Document', null, -1, true);           
        ApexPages.currentPage().setCookies( new Cookie[]{ cookieActiveTab });
        //PageReference pageref = Page.BrokerClickDashboard;
        //pageref.getParameters().put('cid',MyAccountId);
        return pageref;
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
        List<Document_Master__c> lstDocMaster = [select id,Name,acfActive__c from Document_Master__c where acfActive__c = true];
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