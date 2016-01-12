public class acfDashboardDocumentController_broker {

/*====================================================
                Click Loans
========================================================*/

//This Class is used as Controller of Document upload page.

   @TestVisible transient Attachment attach;
   @TestVisible transient Attachment docattach;
   public string strUseEmailID{get;set;}
   public string strDocumentName{get;set;}
   public string IsPopupShow{get;set;}
   public boolean IsIdentificationCompleted{get;set;}
   public boolean IsPaySlipCompleted{get;set;}
   public boolean IsLoanStmtCompleted{get;set;}
   public boolean IsCreditPaymntsmtCompleted{get;set;}
   public boolean IsError{get;set;}
   public boolean IsJumioAttempted {get;set;}
   
   public List<user>lstuser;
   public Id OpportunityId;
   public Id RequiredDocumentId;
   public Integer IndexNo{get;set;}
   public List<WrapperDocuments>lstWrapperDocumnets{get;set;}
   public Map<id,boolean> mapIsdocrejected {get;set;}
   Public Map<id,String> mapIsBankstmtCompleted {get;set;}
    public Id acid;//use by laxman
    public List<User> ulst;//use by laxman
      
   public Attachment getattach() 
   {
    if(attach == null)
        attach = new Attachment();
     return attach ;
   }
   public Attachment getdocattach()
   {
    if(docattach== null)
        docattach = new Attachment();
     return docattach;
   } 
   //public  Attachment docattach{get;set;} 
   public acfDashboardDocumentController_broker()
   {
     acid=apexpages.currentpage().getparameters().get('cid');//updated by laxman
     ulst=[select id,name,email from user where accountid =:acid limit 1];//updated by laxman  
     IsIdentificationCompleted  = false;
     IsError = false;
     IsPaySlipCompleted = false;
     IsLoanStmtCompleted = false;
     IsCreditPaymntsmtCompleted = false;
     attach = new Attachment ();
     lstuser = new List<User>();
     docattach = new  Attachment ();
     strUseEmailID = ulst[0].email;
     lstWrapperDocumnets = new List<WrapperDocuments>();
     Cookie currentUId = ApexPages.currentPage().getCookies().get('DocPopUp');
     if(currentUId <> null)
      IsPopupShow = currentUId.getvalue();
     OpportunityId = acfCommon.getCurrentLoggedInOpportunityId(ulst[0].id);
     // Bind Required Documents in Wrapper list.
     BindWrapperDocument(OpportunityId);
   }
   //Method to bind values in Document wrapper.
   public void BindWrapperDocument(Id OpportunityId)
   {
     mapIsdocrejected = new Map<id,boolean>();
     mapIsBankstmtCompleted  = new Map<id,String>();
     if(OpportunityId <> null)
     {
        lstWrapperDocumnets = new List<WrapperDocuments>();
        system.debug('**OpportunityId'+OpportunityId);
        for(Required_Document__c objRequiredDoc:[select id,name,acfOpportunity__c,acfOpportunity__r.clickJumio_Status__c,acfOpportunity__r.acfIs_Identity_Document_Rejected__c,acfOpportunity__r.acfBankdetailStatus__c,acf_Is_Identity_Verification_Doc__c,acfStatus__c,acfDocument_Master__c,acf_Bank_Statement_Doc__c from Required_Document__c where acfOpportunity__c=:OpportunityId])
        { 
            system.debug('OpportunityId'+objRequiredDoc.acfOpportunity__r.acfIs_Identity_Document_Rejected__c);
            system.debug('!@#$%^&'+objRequiredDoc.acfOpportunity__r.clickJumio_Status__c);
            WrapperDocuments objDocument = new WrapperDocuments();
            mapIsdocrejected.put(objRequiredDoc.id,objRequiredDoc.acfOpportunity__r.acfIs_Identity_Document_Rejected__c);
            If(objRequiredDoc.acfOpportunity__r.acfBankdetailStatus__c != null)
               mapIsBankstmtCompleted.put(objRequiredDoc.id,objRequiredDoc.acfOpportunity__r.acfBankdetailStatus__c);
           
            objDocument.objRequiredDocumnets = objRequiredDoc;
            
            list<Attachment> attList = [select id,name, parentid from Attachment where parentid = : objRequiredDoc.id order by createddate desc limit 1];
            if(attList.isempty() == false){
                    objDocument.imageURL= label.acf_Broker_Url+'/servlet/servlet.FileDownload?file='; 
                    objDocument.imageURL= objDocument.imageURL + attList[0].id;
            }
                
            lstWrapperDocumnets.add(objDocument);
        }
        system.debug('@@Bankstmt'+mapIsBankstmtCompleted);
     }
     
     
   }
   
   Public pagereference redirect(){
        String oppId = acfCommon.getCurrentLoggedInOpportunityId(ulst[0].id); 
        If(oppId != null && oppId <> ''){
           return null;
        }else{
                String retUrl  = acfCommon.sendReturnUrl(ulst[0].id,false,'acfDocumentDashboard'); 
                Pagereference pageref= new Pagereference('/apex/Broker'+retUrl);
                return pageref;
             }
    }
   
   public PageReference uploadDoc() 
   {
        system.debug('@@@'+IndexNo);
        system.debug('@#$%'+lstWrapperDocumnets.size());
        Attachment attachmnt = new Attachment();
        IsError = false;
        try
        {
            if(IndexNo  <> null && IndexNo<lstWrapperDocumnets.size())
            {
                                
                WrapperDocuments objWrapDoc = lstWrapperDocumnets[IndexNo];
                if(objWrapDoc <> null)
                {   
                   /*list<Attachment> attList = [select id,name, parentid from Attachment where parentid = : objWrapDoc.objRequiredDocumnets.id];
                    if(attList.isempty() == false)
                    {
                        delete attList;
                    }  */
                
                    attachmnt = new Attachment();
                    attachmnt.body = attach.body;
                    attachmnt.name = attach.name;
                    attachmnt.parentid= objWrapDoc.objRequiredDocumnets.id;
                    attachmnt.ContentType = attach.contentType;
                    if(attach.body.size()>5242880)
                    {
                       IsError  = true;
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Can not upload file more than 5 mb.'));
                       return null;
                    }
                    insert attachmnt;
                    
                    Required_Document__c objRequiredDoc = new Required_Document__c(id = objWrapDoc.objRequiredDocumnets.id);
                    objRequiredDoc.acfStatus__c = 'Uploaded';
                    update objRequiredDoc;
                    //added by karthik on 29-01-2015
                    List<Required_Document__c> lstobjRequiredDoc = [select id,Name,acfOpportunity__c,acf_Bank_Statement_Doc__c,acf_Is_Identity_Verification_Doc__c from Required_Document__c where id=:objRequiredDoc.id];
                    If(lstobjRequiredDoc != null && lstobjRequiredDoc.size()>0)
                    {
                        Opportunity ObjOpp = new Opportunity(id= lstobjRequiredDoc[0].acfOpportunity__c);
                        If(lstobjRequiredDoc[0].acf_Bank_Statement_Doc__c)
                        {  
                            ObjOpp.acfBankdetailStatus__c = 'Completed';
                        }
                        If(lstobjRequiredDoc[0].acf_Is_Identity_Verification_Doc__c)
                        {
                           ObjOpp.clickJumio_Status__c = 'Attempted';
                        }
                        Update ObjOpp;
                    }
                    //Updating task status.
                    string strTaskSubject = 'Upload '+objWrapDoc.objRequiredDocumnets.Name;
                    List<Task>lstTaskToclosed = new List<Task>();
                    system.debug('234567___'+strTaskSubject+'#$%'+objWrapDoc.objRequiredDocumnets.acfOpportunity__c);
                    for(Task objTask:[select id,status,subject,WhatId from task where subject=:strTaskSubject and WhatId=:objWrapDoc.objRequiredDocumnets.acfOpportunity__c])
                    {
                        objTask.Status = 'Completed';
                        lstTaskToclosed.add(objTask);
                    }
                    system.debug('!@#$%^'+lstTaskToclosed);
                    if(lstTaskToclosed.size()>0)
                        update lstTaskToclosed;
                    // Bind Documents in Wrapper
                    BindWrapperDocument(OpportunityId);
                }   
            }
        }
        catch(Exception Ex)
        {
        }
        finally{
          attachmnt = new Attachment();
        }         
        return (new Pagereference('/apex/BrokerClickDashboard?cid='+acid));
   } 
   // This method is used to attach documents from drag and drop functionality.
   public PageReference  UploadDragableFile()
   {
       Attachment attachmnt ;
       IsError = false;
       system.debug('@@@@LOkesh'+docattach);
       try
       {  
           system.debug('IndexNo  '+IndexNo  );
            if(IndexNo  <> null && IndexNo < lstWrapperDocumnets.size())
            {
                WrapperDocuments objWrapDoc = lstWrapperDocumnets[IndexNo];
                if(objWrapDoc <> null)
                {
                    list<Attachment> attList = [select id,name, parentid from Attachment where parentid = : objWrapDoc.objRequiredDocumnets.id];
                    if(attList.isempty() == false){
                        delete attList;
                    }
                    
                    attachmnt = new Attachment();
                    attachmnt.body = docattach.body;
                    attachmnt.name = docattach.name;
                    attachmnt.parentid = objWrapDoc.objRequiredDocumnets.id;
                    attachmnt.ContentType = docattach.contentType;
                    system.debug('@@@Attachment'+docattach.body.size());
                    if(docattach.body.size()>5242880)
                    {
                        IsError  = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Can not upload file more than 5 mb.'));
                        return null;
                    }
                    insert attachmnt;
                    Required_Document__c objRequiredDoc = new Required_Document__c(id = objWrapDoc.objRequiredDocumnets.id);
                    objRequiredDoc.acfStatus__c = 'Uploaded';
                    update objRequiredDoc;
                    //added by karthik on 29-01-2015
                    List<Required_Document__c> lstobjRequiredDoc = [select id,Name,acfOpportunity__c from Required_Document__c where id=:objRequiredDoc.id];
                    If(lstobjRequiredDoc != null && lstobjRequiredDoc.size()>0)
                    {
                        Opportunity ObjOpp = new Opportunity(id= lstobjRequiredDoc[0].acfOpportunity__c);
                        If(lstobjRequiredDoc[0].acf_Bank_Statement_Doc__c)
                        {  
                            ObjOpp.acfBankdetailStatus__c = 'Completed';
                        }
                        If(lstobjRequiredDoc[0].acf_Is_Identity_Verification_Doc__c)
                        {
                           ObjOpp.clickJumio_Status__c = 'Attempted';
                        }
                        Update ObjOpp;
                    }
                    
                    //Updating task status.
                    string strTaskSubject = 'Upload '+objWrapDoc.objRequiredDocumnets.Name;
                    List<Task>lstTaskToclosed = new List<Task>();
                    system.debug('234567___'+strTaskSubject+'#$%'+objWrapDoc.objRequiredDocumnets.acfOpportunity__c);
                    for(Task objTask:[select id,status,subject,WhatId from task where subject=:strTaskSubject and WhatId=:objWrapDoc.objRequiredDocumnets.acfOpportunity__c])
                    {
                        objTask.Status = 'Completed';
                        lstTaskToclosed.add(objTask);
                    }
                    system.debug('!@#$%^'+lstTaskToclosed);
                    if(lstTaskToclosed.size()>0)
                        update lstTaskToclosed;
                    // Bind Documents in Wrapper
                    BindWrapperDocument(OpportunityId);
                }
            }   
       }
       catch(Exception Ex)
       {
       }
       finally{
          attachmnt = new Attachment();
       }        
       return null;
   }
   /*For Sending mail to the user for Document
   public pageReference SendmailForDocumentUpload()
   {
        system.debug('@@@Lokesh'+strUseEmailID);
        if((acfCommon.IsNullOrEmptyString(strUseEmailID)==false) && (acfCommon.IsNullOrEmptyString(strDocumentName)==false))
        {
             string strContent = 'Please click on the link below to upload ' +strDocumentName+ ' Document for further processing.<br/>';
             strContent += '<a href='+Label.acfSite_Url+'/acfdocumentdashboard?document='+strDocumentName+'>'+Label.acfSite_Url+'/acfdocumentdashboard?document='+strDocumentName+'</a>';// https://acf-creditandfinance.cs5.force.com/partners/acfdocumentdashboard?document="></a>';
             string strSubject = 'Upload Document';
             List<string>lstToEmail = new List<string>();
             lstToEmail.add(strUseEmailID);
             acfCommon.sendTemplatedEmail(null, strContent, strSubject, lstToEmail, null);
        }
        return null;
   }*/
   // For Setting one Time document popup
   public pageReference UploadDocumentsNotification()
   {
      Cookie User_Id = new Cookie('DocPopUp','true',null,72000, false); 
      ApexPages.currentPage().setCookies( new Cookie[]{ User_Id });
      Cookie currentUId = ApexPages.currentPage().getCookies().get('DocPopUp');
      if(currentUId <> null)
       IsPopupShow = currentUId.getvalue();
      return null;
   }
   // Wrapper Class for Document.
   public class WrapperDocuments
   {
       public Required_Document__c objRequiredDocumnets{get;set;}
       public String imageURL{get;set;}
   }
   
   public pagereference DeleteDoc()
   {
       system.debug('indx ...'+IndexNo  );
       if(IndexNo  <> null && IndexNo<lstWrapperDocumnets.size())
       {
            WrapperDocuments objWrapDoc = lstWrapperDocumnets[IndexNo];
            if(objWrapDoc <> null)
            {
                Required_Document__c objRequiredDoc = new Required_Document__c(id = objWrapDoc.objRequiredDocumnets.id);
                objRequiredDoc.acfStatus__c = 'Pending';
                update objRequiredDoc;
                
               /* list<Attachment> attList = [select id,name, parentid from Attachment where parentid = : objWrapDoc.objRequiredDocumnets.id];
                if(attList.isempty() == false){
                    delete attList;
                } */
                
                 //Updating task status.
                    string strTaskSubject = 'Upload '+objWrapDoc.objRequiredDocumnets.Name;
                    List<Task>lstTaskToclosed = new List<Task>();
                    system.debug('234567___'+strTaskSubject+'#$%'+objWrapDoc.objRequiredDocumnets.acfOpportunity__c);
                    for(Task objTask:[select id,status,subject,WhatId from task where subject=:strTaskSubject and WhatId=:objWrapDoc.objRequiredDocumnets.acfOpportunity__c])
                    {
                        objTask.Status = 'Open';
                        lstTaskToclosed.add(objTask);
                    }
                    system.debug('!@#$%^'+lstTaskToclosed);
                    if(lstTaskToclosed.size()>0)
                        update lstTaskToclosed;
            }
       }
       
       BindWrapperDocument(OpportunityId);
       
       return (new Pagereference('/apex/BrokerClickDashboard?cid='+acid));
   }
   
   public void previewdoc(){
      /*  system.debug('indx ...'+IndexNo  );
       if(IndexNo  <> null && IndexNo<lstWrapperDocumnets.size())
       {
           WrapperDocuments objWrapDoc = lstWrapperDocumnets[IndexNo];
            if(objWrapDoc <> null)
            {
                list<Attachment> attList = [select id,name, parentid from Attachment where parentid = : objWrapDoc.objRequiredDocumnets.id];
                if(attList.isempty() == false){
                    imageURL= label.acfSite_Url+'/servlet/servlet.FileDownload?file='; 
                    imageURL= imageURL+ attList[0].id;
                }
            }
       } */
   }
}