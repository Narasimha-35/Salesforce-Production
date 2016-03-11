global class acfDashboardDocumentController_broker {

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
   
   public list<Attachment> lstAttach {get;set;}
   public list<Note> noteLst1{get;set;}
   public static id accid;
   public List<user>lstuser;
   public Id OpportunityId;
   public Id RequiredDocumentId;
   public Integer IndexNo{get;set;}
   public Integer IndexNo1{get;set;}
   public List<WrapperDocuments>lstWrapperDocumnets{get;set;}
   public Map<id,boolean> mapIsdocrejected {get;set;}
   Public Map<id,String> mapIsBankstmtCompleted {get;set;}
   public Id acid{set;get;}//use by laxman
   public List<User> ulst;//use by laxman
   
   Public String strPost1 {get;set;}
   Public String strfeedmsg1 {get;set;}
   Public String strfeedSuccessmsg1 {get;set;}
   Public boolean isError1 {get;set;}
   Public boolean showMessage1 {get;set;}
   Public Boolean successMsg1 {get;set;}
   public string requiredDocName{get;set;}
   public list<wrapAttachDocs> lstWrapAttach {get;set;}  
   
   public list<Click_Uploaded_Documents__c> lstUploadDocs{get;set;}
   public string strBankFrameURl {get;set;}
   public string strJumioFrameUrl {get;set;} 
    
    
    
    
      
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
     accid=acid;
     strBankFrameURl = '';
     strJumioFrameUrl = '';
     requiredDocName = '';
     strfeedmsg1 = '';
     strfeedSuccessmsg1 = '';
     showMessage1 = false;
     successMsg1 = false;
     
     
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
     //OpportunityId = acfCommon.getCurrentLoggedInOpportunityId(ulst[0].id);
      List<Opportunity> oppolst=new List<Opportunity>();
     if(acid!=null)
        {
            oppolst=[select id from opportunity where accountid =:acid and (recordtype.name ='Click Refi' or recordtype.name ='Click New Loans' ) limit 1];
        }
        if(oppolst<>null && oppolst.size()>0)
            OpportunityId = oppolst[0].id;
      lstUploadDocs = new list<Click_Uploaded_Documents__c>();
     // Bind Required Documents in Wrapper list.
     BindWrapperDocument(OpportunityId);
     lstAttach = new List<Attachment>();
     noteLst1 = new list<Note>();
     lstWrapAttach = new list<wrapAttachDocs>();
       
   }
   //Method to bind values in Document wrapper.
   public void BindWrapperDocument(Id OpportunityId)
   {
     mapIsdocrejected = new Map<id,boolean>();
     mapIsBankstmtCompleted  = new Map<id,String>();
          if(OpportunityId<> null)
     {
        lstWrapperDocumnets = new List<WrapperDocuments>();        
        system.debug('**OpportunityId'+OpportunityId);
        for(Required_Document__c objRequiredDoc:[select id,name,acfOpportunity__c,Click_Is_Note_Type__c,acfOpportunity__r.clickJumio_Status__c,
                                                acfOpportunity__r.acfIs_Identity_Document_Rejected__c,acfOpportunity__r.acfBankdetailStatus__c,
                                                acf_Is_Identity_Verification_Doc__c,acfStatus__c,acfDocument_Master__c,acf_Bank_Statement_Doc__c,
                                                click_Is_Uploaded__c,(select id from Attachments) 
                                                from Required_Document__c where acfOpportunity__c=:OpportunityId order by createddate ASC])
        { 
            system.debug('OpportunityId'+objRequiredDoc.acfOpportunity__r.acfIs_Identity_Document_Rejected__c);
            system.debug('!@#$%^&'+objRequiredDoc.acfOpportunity__r.clickJumio_Status__c);
            WrapperDocuments objDocument = new WrapperDocuments();
            mapIsdocrejected.put(objRequiredDoc.id,objRequiredDoc.acfOpportunity__r.acfIs_Identity_Document_Rejected__c);
            If(objRequiredDoc.acfOpportunity__r.acfBankdetailStatus__c != null)
               mapIsBankstmtCompleted.put(objRequiredDoc.id,objRequiredDoc.acfOpportunity__r.acfBankdetailStatus__c);           
            objDocument.objRequiredDocumnets = objRequiredDoc; 
            
            list<Attachment> attList = objRequiredDoc.Attachments;
            if(attList.isempty() == false){
                    objDocument.imageURL= label.site_URL+'/servlet/servlet.FileDownload?file='; 
                    objDocument.imageURL= objDocument.imageURL + attList[0].id;
            }
                           
            lstWrapperDocumnets.add(objDocument);
            
        }
        system.debug('@@Bankstmt'+mapIsBankstmtCompleted);
     } 
     
     
   }
   
   
    public void previewdoc()
   {
       system.debug('index ...'+IndexNo  );
       if(IndexNo  <> null && IndexNo<lstWrapperDocumnets.size())
       {
           WrapperDocuments objWrapDoc = lstWrapperDocumnets[IndexNo];
           lstWrapAttach = new list<wrapAttachDocs>();
           list<Click_Uploaded_Documents__c> lstUploadedDocs = [select id,Click_Loans_Required_Document__c,click_Is_deleted__c,Name,
                                                               Click_Attachment_Id__c from Click_Uploaded_Documents__c where 
                                                               Click_Loans_Required_Document__c =: objWrapDoc.objRequiredDocumnets.id];
            for(Click_Uploaded_Documents__c objUploadDoc : lstUploadedDocs)
            {
                wrapAttachDocs objWrapAttach = new wrapAttachDocs();
                objWrapAttach.strDocName = objUploadDoc.Name;
                objWrapAttach.isDeleted = objUploadDoc.click_Is_deleted__c;
                objWrapAttach.attachId = objUploadDoc.Click_Attachment_Id__c;
                objWrapAttach.imgUrl = label.acfBroker_url+'/servlet/servlet.FileDownload?file='+objUploadDoc.Click_Attachment_Id__c;
                lstWrapAttach.add(objWrapAttach);
            }
            system.debug('lstWrapAttach'+lstWrapAttach);

           /* if(objWrapDoc <> null)
            {
            //    lstAttach = [select id,name, parentid from Attachment where parentid = : objWrapDoc.objRequiredDocumnets.id];
                list<Attachment> attachList = [select id,name, parentid from Attachment where parentid = : objWrapDoc.objRequiredDocumnets.id];
                  system.debug('attachList'+attachList);
                if(attachList.isempty() == false){
                   //     objWrapDoc.imageURL= label.acfSite_Url+'/servlet/servlet.FileDownload?file='; 
                  //      objWrapDoc.imageURL= objWrapDoc.imageURL+ attachList [0].id;                 
                 //      if(IndexNo1  <> null) 
                 //      {
                       //    attachList.remove(IndexNo1);
                     //      objWrapDoc.attList = attachList;  
                 //      }
                 //      else
                //       {
                           objWrapDoc.attList = attachList;
                           system.debug('objWrapDoc.attList'+objWrapDoc.attList);
                 //      }
                       
                }
            }
           */
       } 
   }
   //to delete attachment
   public pagereference DeleteDoc()
   {
      system.debug('indx ...'+IndexNo);
       if(IndexNo  <> null && IndexNo<lstWrapAttach.size())
       {
           wrapAttachDocs objWrapDoc = lstWrapAttach[IndexNo];
           list<Click_Uploaded_Documents__c> lstUploadedDocs = [select id,Click_Attachment_Id__c from Click_Uploaded_Documents__c where 
                                                                Click_Attachment_Id__c =: objWrapDoc.attachId];
            if(lstUploadedDocs != null && lstUploadedDocs.size()>0)
            {
                lstUploadedDocs[0].click_Is_deleted__c = true;
                update lstUploadedDocs;
            }
           lstWrapAttach.remove(IndexNo);
           
            List<Attachment> lstAtt = new List<Attachment>();
           if(objWrapDoc.attachId <> null)
           lstAtt = [select id,ParentId from Attachment where id=:objWrapDoc.attachId];
           if(lstAtt != null && lstAtt.size() > 0)
           {
              lstUploadDocs = [select id,Click_Loans_Required_Document__c,click_Is_deleted__c,
                                 Click_Loans_Required_Document__r.acfOpportunity__c
                                 from Click_Uploaded_Documents__c where 
                                 Click_Loans_Required_Document__c =: lstAtt[0].ParentId
                                 AND click_Is_deleted__c = false];
                  if(lstUploadDocs != null && lstUploadDocs.size() > 0)  
                  {
                  }
                  else
                  {
                      Required_Document__c objRequiredDoc = new Required_Document__c(id = lstAtt[0].ParentId);
                      objRequiredDoc.acfStatus__c = 'Pending';
                      update objRequiredDoc;
                      Required_Document__c objRequiredDocs = [select id,Name from Required_Document__c where id=:objRequiredDoc.Id];
                      system.debug('OpportunityId @#$%^&*'+OpportunityId+'Name!@#$%^&'+objRequiredDoc.Name);
                      List<Task> lstTasks = [select id,Subject,whatid from Task where whatid=:OpportunityId And Subject =:'Upload '+objRequiredDocs.Name];
                      system.debug('lstTask@#$%^&*'+lstTasks);
                      if(lstTasks != null && lstTasks.size() > 0)
                      {
                          Task objTask = new Task(id=lstTasks[0].Id);
                          objTask.Status = 'Open';
                          update objTask;
                          system.debug('objTask@#$%^&*'+objTask);
                      }  
                      return (new Pagereference('/BrokerClickDashboard?cid='+acid));
                  
                  }                                            
           } 
           
           
           
           
       }
       return null;
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
                    List<Required_Document__c> lstobjRequiredDoc = [select id,Name,click_Is_Uploaded__c,acfOpportunity__c,acf_Bank_Statement_Doc__c,acf_Is_Identity_Verification_Doc__c from Required_Document__c where id=:objRequiredDoc.id];
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
        return (new Pagereference('/BrokerClickDashboard?cid='+acid));
   } 
   
   @RemoteAction
   global static String attachBlobs(string AccountId,String parentId, String attachmentId, String fileName, String contentType, String base64BlobValue,integer fileIndexNo)
   {
        /*
        parentId: The sfdc object Id this file will be attached to
        attachmentId: The record of the current Attachment file being processed
        fileName: Name of the attachment
        contentTye: Content Type of the file being attached
        base64BlobValue: Base64 encoded string of the file piece currently processing
        */
               
        //If recordId is blank this is the first part of a multi piece upload
        
        system.debug('@@@ashuparentId=>'+parentId+'attaId=>'+attachmentId+'=>filename'+fileName);
        
        if(attachmentId == '' || attachmentId == null)
        {

            Attachment att = new Attachment(
                ParentId = parentId,
                Body = EncodingUtil.Base64Decode(base64BlobValue),
                Name = fileName,
                ContentType = contentType
            );
            insert att;
            uploadMultipleDoc(AccountId,fileIndexNo);
            //Return the new attachment Id
            return att.Id;
            
        }
        return attachmentId;
    } 
    
    public static void uploadMultipleDoc(string AccountId,integer fileIndexNo)
    {
        Id currentOppId;
        if(fileIndexNo <> null)
        {
           system.debug('@@@'+fileIndexNo);
           list<WrapperDocuments> lstStaticWrapDocs = new list<WrapperDocuments>(); 
           List<Opportunity> opplst2=new List<Opportunity>(); 
           if(AccountId!=null)
            {
                opplst2=[select id from opportunity where accountid =:AccountId and (recordtype.name ='Click Refi' or recordtype.name ='Click New Loans' ) limit 1];
            }
            if(opplst2<>null && opplst2.size()>0)
                currentOppId= opplst2[0].id;
               
              
              
           
            
           for(Required_Document__c objRequiredDoc:[select id,name,acfOpportunity__c,Click_Is_Note_Type__c,acfOpportunity__r.clickJumio_Status__c,
                                                acfOpportunity__r.acfIs_Identity_Document_Rejected__c,acfOpportunity__r.acfBankdetailStatus__c,
                                                acf_Is_Identity_Verification_Doc__c,acfStatus__c,acfDocument_Master__c,acf_Bank_Statement_Doc__c,
                                                click_Is_Uploaded__c
                                                from Required_Document__c where acfOpportunity__c=:currentOppId order by createddate ASC])
            {
                WrapperDocuments objDocument = new WrapperDocuments();          
                objDocument.objRequiredDocumnets = objRequiredDoc;                
                lstStaticWrapDocs.add(objDocument);    
            }
            system.debug('@#$%'+lstStaticWrapDocs);
            Attachment attachmnt = new Attachment();
            if(fileIndexNo <> null && fileIndexNo<lstStaticWrapDocs.size())
            {                               
                WrapperDocuments objWrapDoc = lstStaticWrapDocs[fileIndexNo];
                if(objWrapDoc <> null)
                {   
                    Required_Document__c objRequiredDoc = new Required_Document__c(id = objWrapDoc.objRequiredDocumnets.id);
                    objRequiredDoc.acfStatus__c = 'Uploaded';
                    update objRequiredDoc;
                    //added by karthik on 29-01-2015
                    List<Required_Document__c> lstobjRequiredDoc = [select id,Name,click_Is_Uploaded__c,acfOpportunity__c,acf_Bank_Statement_Doc__c,acf_Is_Identity_Verification_Doc__c from Required_Document__c where id=:objRequiredDoc.id];
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
                }   
            }
        }     
    }
    
    
    
       
    
    Public pagereference ResetPopup1(){
        successMsg1 = false;
        showMessage1 = false;
        strfeedSuccessmsg1 = '';
        strPost1 = '';
        return null;
    }
    
    public void fetchDocName()
    {
         if(IndexNo  <> null)
           {
               WrapperDocuments objWrapDoc = lstWrapperDocumnets[IndexNo];
               requiredDocName = objWrapDoc.objRequiredDocumnets.name;
               noteLst1 = [select id,Body,Title,ParentId from Note where ParentId =:objWrapDoc.objRequiredDocumnets.id];
               if(noteLst1 <> null && noteLst1.size() > 0)
               {
                  strPost1 = noteLst1[0].Body;
               } 
           }
           
          
    }
    //To add notes

    public pagereference addNotes()
    {   
        system.debug('str message'+strPost1);
        //String userId = userInfo.getuserId();
      try{
            List<Note> lstNote = new List<Note>();
            if(IndexNo  <> null)
           {
               WrapperDocuments objWrapDoc = lstWrapperDocumnets[IndexNo];
                if(objWrapDoc <> null && strPost1 != null && strPost1 <> '')
                {
                       List<Note> noteLst = [select id,Body,Title,ParentId from Note where ParentId =:objWrapDoc.objRequiredDocumnets.id];
                       if(noteLst <> null && noteLst.size() > 0)
                       {
                           Note NoteObj = new Note(id=noteLst[0].Id);
                           NoteObj.Body = strPost1;
                           update NoteObj; 
                           successMsg1 = true;
                           showMessage1 = false;
                           strfeedSuccessmsg1 = 'Your Notes has been submitted.';
                //           IsNoteFound = true;   
                       }
                       else
                       {
                           Note objNote = new Note();
                           objNote.ParentId = objWrapDoc.objRequiredDocumnets.id;
                           objNote.Body = strPost1;
                           objNote.Title = objWrapDoc.objRequiredDocumnets.Name; 
                           lstNote.add(objNote);
                           Required_Document__c objRequiredDoc = new Required_Document__c(id = objWrapDoc.objRequiredDocumnets.id);
                           objRequiredDoc.acfStatus__c = 'Note Added';
                           update objRequiredDoc;
                           successMsg1 = true;
                           showMessage1 = false;
                           strfeedSuccessmsg1 = 'Your Notes has been submitted.';  
                           system.debug('Ankit&&&&&&');
                       }
                }
                else
                {
                           showMessage1 = true;
                           successMsg1 = false;
                           strfeedmsg1 = 'Please complete the info required here. Give us as much detail as possible, and don t worry - you can add to this later.';
                }
             }
             
             if(lstNote != null && lstNote.size() > 0)
             {
                 insert lstNote;
                 system.debug('Ankit&&&&&&8***********'+lstNote);
             }
       }catch(Exception Ex){
           showMessage1 = true;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Your Query'));
            strfeedmsg1 = 'Please enter your query';
           }    
       return null;
    }

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
       public list<Attachment> attList{get;set;}
       public list<wrapAttachDocs> lstWrapAttachDocs {get;set;}
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
     public pagereference frameURL()
   {
        strBankFrameURl = system.Label.acfBroker_url+'/BrokerClickBankInfoDetails?cid='+acid+'&header=false';
        strJumioFrameUrl = system.Label.acfBroker_url+'/Brokerclickjumiointegration?cid='+acid+'&header=false';
        return null;
   }
   
     public class wrapAttachDocs
   {
    public string strDocName{get;set;}
    public boolean isDeleted {get;set;}
    public string attachId {get;set;}
    public string imgUrl {get;set;}
   }
}