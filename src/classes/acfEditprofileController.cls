/*====================================================
				Click Loans
========================================================*/
Public class acfEditprofileController {
    transient Attachment attach;
    transient Attachment docattach;
    Public User usrObj {get;set;}
    Public List<Contact> List_con;
    Public List<Lead> List_lead;
    Public String strPassword {get;set;}
    public string strDocumentName{get;set;}
    public string imgUrl {get;set;}
    public boolean IsError {get;set;}
    public string strmsg {get;set;}
    Public String prevImageUrl;
    public Attachment getattach() {
    if(attach == null)
        attach = new Attachment();
     return attach;
    }
    public Attachment getdocattach(){
     if(docattach== null)
        docattach = new Attachment();
     return docattach;
    } 
    
    Public acfEditprofileController(){
        strPassword = '..............';
        IsError = false;
        List_con = new List<Contact>();
        List_lead = new List<Lead>();
        usrObj = [select id,username,Name,Email,firstname,lastname,contactId,contact.acf_Lead__c,TimeZoneSidKey,fullphotourl from user where id=:UserInfo.getuserId()];
       // usrObj.Firstname = 'Enter Your First Name';
       // usrObj.lastname = 'Enter Your Last Name';
        prevImageUrl = usrObj.fullphotourl;
        If(usrObj!=null){
            List_con = [select id,FirstName,lastname,Email,acf_lead__c,acfPassword__c from contact where id=:usrObj.contactId];
        }
        If(usrObj.contact.acf_Lead__c!=null){
            List_lead = [select id,firstname,lastname,Email,acfOneTimePassword__c from lead where id=:usrObj.contact.acf_Lead__c];
        }
    }
    
    public boolean isValidPassword(string strPassword) {
       if(!Pattern.matches('(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9!@#$%^&*]{8,20})', strPassword))
       {
        return false;
       }
       else{
        return true;
       }
       return true;
    }
    
   Public pagereference saveMethod(){
     If(acfCommon.checkEmail(usrObj.Email)){ 
      If(!isUseralreadyExist()){
      // If(isValidPassword(strPassword)) {
        Update usrObj;
        If(!List_con.isEmpty()){
            List_con[0].FirstName = usrObj.FirstName;
            List_con[0].LastName = usrObj.LastName;
            List_con[0].Email = usrObj.Email;  
            Update List_con[0];
        }
        /*
        If(!List_lead.isEmpty()){
            List_lead[0].FirstName = usrObj.FirstName;
            List_lead[0].LastName = usrObj.LastName;
            List_lead[0].Email = usrObj.Email;
          //  List_lead[0].acfOneTimePassword__c = strPassword;
            Update List_lead[0];
        }
        */
      /* }else{
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Password should be alphanumeric and greater than 8 characters');                                                                 
         ApexPages.addMessage(myMsg); 
         return null;
         }*/
       } else{
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Email ID already registered');                                                                 
                 ApexPages.addMessage(myMsg); 
                 return null;
              }
       }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Email Id,Please enter valid email Id.');                                                                 
                ApexPages.addMessage(myMsg); 
                return null;
            }
       /* If(!List_con.isEmpty()){
         List_con[0].FirstName = usrObj.Firstname;
         List_con[0].LastName = usrObj.LastName;
         List_con[0].Email = usrObj.Email;
         List_con[0].acfPassword__c = strPassword;
         Update List_con[0];
        } */ 
     
      pagereference hPage = page.clickdashboard;
      hPage.setredirect(true);
      return hPage;
  }
  
  public PageReference  UploadDragableFile(){
       Attachment attachmnt ;
       String communityId = null;
       IsError = false;
       system.debug('@@@@Karthik'+docattach);
       try
       {     system.debug('@@@@Karthik'+usrObj.ContactId);
       
            if(usrObj!=null)
            {  
               ConnectApi.Photo photo = ConnectApi.ChatterUsers.setPhoto(communityId, usrObj.id,  new ConnectApi.BinaryInput(docattach.body,docattach.contentType,docattach.name));
               system.debug('url@@@'+photo);
               
            }
       }
       catch(Exception Ex)
       {
        strmsg = 'Your Upload Operation is Failed,Please Try Again.';
        system.debug('exception@@@@'+Ex);
       }
       finally{
          attachmnt = new Attachment();
       } 
      // return null;
       PageReference pageRef = Page.clickeditprofile;
       pageRef.setRedirect(true);
       return pageRef ;   
   }
   
  public PageReference uploadDoc() 
   {
       Attachment attachmnt ;
       String communityId = null;
       IsError = false;
       system.debug('@@@@Karthik'+docattach);
       try
       {     system.debug('@@@@Karthik'+usrObj.ContactId);
       
            if(usrObj!=null)
            {  
               ConnectApi.Photo photo = ConnectApi.ChatterUsers.setPhoto(communityId, usrObj.id,new ConnectApi.BinaryInput(attach.body,attach.contentType,attach.name));
               system.debug('url@@@'+photo);
               
            }
       }
       catch(Exception Ex)
       {
        strmsg = 'Your Upload Operation is Failed,Please Try Again.';
        system.debug('exception@@@@'+Ex);
       }
       finally{
          attachmnt = new Attachment();
       }  
     
     // return null;
       PageReference pageRef = Page.clickeditprofile;
       pageRef.setRedirect(true);
       return pageRef ;
   } 
   
   Public pagereference deleteImage(){
     String communityId = null;
     // ConnectApi.ChatterUsers.deletePhoto(communityId, usrObj.id);
     try{
         If(usrObj!=null){
             system.debug('userId'+usrObj.id);
             document doc = [select name,body,contentType from document where name=:'DefaultChatterImage'];
             system.debug('document'+doc);
             If(doc!=null){
                 ConnectApi.Photo photo = ConnectApi.ChatterUsers.setPhoto(communityId, usrObj.id,  new ConnectApi.BinaryInput(doc.body,doc.contentType,doc.name));
                 system.debug('url@@@'+photo);
             }
            
         }
     }
     catch(Exception Ex)
     {
        strmsg = 'Your Upload Operation is Failed,Please Try Again.';
        system.debug('@@@exception'+Ex);
     }
    //return null;
    PageReference pageRef = Page.ClickEditProfile;
    pageRef.setRedirect(true);
    return pageRef ;
  }
  Public Pagereference Cancel(){
      Pagereference pageRef = Page.clickdashboard;
      PageRef.setRedirect(true);
      return PageRef;
  }
  Public boolean isUseralreadyExist(){
    List<User> List_usr = [select id,Email,username from user where id!=:usrObj.id AND Email=:usrObj.Email AND IsActive=true];
    List<Lead> List_Lead = [select id,Email from lead where id!=:usrObj.contact.acf_Lead__c AND Email=:usrObj.Email];
    If(List_usr.size()>0&&List_Lead.size()>0){
        return true;
    }else{
          return false;
         }
  }
  Public pagereference redirect(){
      string returnURL = acfcommon.redirect(userinfo.getuserId(),'clickeditprofile');
      if(returnURL != null && returnURL <> '' && returnURL != 'false')
      {
           return new Pagereference('/'+returnURL);
      }else{
              return null;
          }
  }
}