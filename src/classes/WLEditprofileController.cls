/*====================================================
                Click Loans
========================================================*/
Public class WLEditprofileController {
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
    private string strNetworkId;
    private List<Click_Community_Setup__c> lstCommunity;
    
    Public WLEditprofileController(){
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
        strNetworkId = Network.getNetworkId();
  //    strNetworkId = '0DBN0000000CamKOAS';
        lstCommunity = new List<Click_Community_Setup__c>();
        if(strNetworkId != null && strNetworkId != '')
        {
            lstCommunity = [select id,name,Click_Page_Prefix__c,Click_Network_ID__c,Click_URL__c,Community_User_Name_Prefix__c,Click_IsActive__c,Click_Support_Team_Name__c from Click_Community_Setup__c where Click_Network_ID__c = : strNetworkId AND Click_IsActive__c =: true limit 1];
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
     If(ClickCommon.checkEmail(usrObj.Email)){ 
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
      string pgUrl;
      if(!test.isrunningtest())
      {
          if(lstCommunity <> null && lstCommunity.size() >0 && lstCommunity[0].Click_Page_Prefix__c <> null && lstCommunity[0].Click_Page_Prefix__c <> '' )  
          pgUrl = '/'+ lstCommunity[0].Click_Page_Prefix__c +'dashboard';
      }
      else
       {
           pgUrl = 'www.google.com';
       }
      pagereference hPage = new pagereference(pgUrl);
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
       string pgUrl;
       if(!test.isrunningtest())
       {
           if(lstCommunity <> null && lstCommunity.size() >0 && lstCommunity[0].Click_Page_Prefix__c <> null && lstCommunity[0].Click_Page_Prefix__c <> '' )
           pgUrl = '/'+ lstCommunity[0].Click_Page_Prefix__c +'editprofile';
       }
       else
       {
           pgUrl = 'www.google.com';
       }
       PageReference pageRef = new pagereference(pgUrl);
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
       string pgUrl;
       if(!test.isrunningtest())
       {
           if(lstCommunity <> null && lstCommunity.size() >0 && lstCommunity[0].Click_Page_Prefix__c <> null && lstCommunity[0].Click_Page_Prefix__c <> '' )
           pgUrl = '/'+ lstCommunity[0].Click_Page_Prefix__c +'editprofile';
       }
       else
       {
           pgUrl = 'www.google.com';
       }
       PageReference pageRef = new pagereference(pgUrl);
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
    string pgUrl;
    if(!test.isrunningtest())
    {
        if(lstCommunity <> null && lstCommunity.size() >0 && lstCommunity[0].Click_Page_Prefix__c <> null && lstCommunity[0].Click_Page_Prefix__c <> '' )
        pgUrl = '/'+ lstCommunity[0].Click_Page_Prefix__c +'editprofile';
    }
    else
    {
        pgUrl = 'www.google.com';
    }
    PageReference pageRef = new pagereference(pgUrl);
    pageRef.setRedirect(true);
    return pageRef ;
  }
  Public Pagereference Cancel(){
      string pgUrl;
      if(!test.isrunningtest())
      {
          if(lstCommunity[0].Click_Page_Prefix__c <> null && lstCommunity[0].Click_Page_Prefix__c <> ''  && lstCommunity <> null && lstCommunity.size() >0)
          pgUrl = '/'+ lstCommunity[0].Click_Page_Prefix__c +'dashboard';
      }
       else
      {
        pgUrl = 'www.google.com';
      }
      Pagereference pageRef = new pagereference(pgUrl);
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
      if(strNetworkId != null && lstCommunity != null && lstCommunity.size() > 0)
      {
          string returnURL = ClickCommon.redirect(userinfo.getuserId(),lstCommunity[0].Click_Page_Prefix__c + 'editprofile',strNetworkId);
          if(returnURL != null && returnURL <> '' && returnURL != 'false')
          {
               return new Pagereference('/'+returnURL);
          }else{
              return null;
          }
      }
      return null;
   }   
}