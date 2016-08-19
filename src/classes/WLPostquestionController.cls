Public class WLPostquestionController
{
    Public String strPost {get;set;}
    Public String strfeedmsg {get;set;}
    Public String strfeedSuccessmsg {get;set;}
    Public boolean isError {get;set;}
    Public boolean showMessage {get;set;}
    Public Boolean successMsg {get;set;}
    Public WLPostquestionController()
    {
      strfeedmsg = '';
      strPost = '';
      strfeedSuccessmsg = '';
      showMessage = false;
      successMsg = false; 
    } 
    Public pagereference ResetPopup(){
        successMsg = false;
        showMessage = false;
        strfeedSuccessmsg = '';
        strPost = null;
        return null;
    }
    Public pagereference postQuery()
    {   
        system.debug('str message'+strPost);
        //String userId = userInfo.getuserId();
      try{
            If(strPost != null || strPost <> ' ')
            {
                list<User> lstCurrentUser = [select id,contactId,AccountId,Account.OwnerId from user where id=:userInfo.getuserId()];
                if(lstCurrentUser != null && !lstCurrentUser.isEmpty())
                {
                    System.debug('@#@#@#lstCurrentUser======'+lstCurrentUser[0]);
                    user usrObj = lstCurrentUser[0];
                    System.debug('=====usrObj===='+usrObj);
                    if(usrObj.accountId != null)
                    {
                        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                        
                        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                        system.debug('!@!@!@'+usrObj.Account.OwnerId);
                        mentionSegmentInput.id = usrObj.Account.OwnerId;            
                        textSegmentInput.text = strPost;
                        messageBodyInput.messageSegments.add(textSegmentInput);
                
                        feedItemInput.body = messageBodyInput;
                        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                        feedItemInput.subjectId = usrObj.accountId;
                        if(!test.isrunningtest())
                            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput, null);
                        System.debug('=====feedElement ======'+'feedElement ');
                        successMsg = true;
                        showMessage = false;
                        strfeedSuccessmsg = 'Your query has been submitted. We will get back to you soon';  
                        System.debug('asaaaaaaaaaaaaaa');
                        //For sending Email To Account Owner. added on 15/06/2016 by karthik
                        List<Account> lstAccount = [select id,OwnerId,Name,Owner.Name,Owner.Email from Account where id=:usrObj.accountId];
                       System.debug('======lstAccount======='+lstAccount);
                        if(lstAccount != null && !lstAccount.isEmpty())  
                        {                                    
                             string strUrl = '<a href='+ label.acfSalesforceUrl+'/'+lstAccount[0].id+'>'+ lstAccount[0].Name+'</a>'; 
                             // grab the email template
                             list<EmailTemplate> lstEmailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'SendEmailToOwner' limit 1];   
                             if(lstEmailTemplate != null && !lstEmailTemplate.isEmpty())
                             {
                                 EmailTemplate EmailTemplate =  lstEmailTemplate[0]; 
                                 //Subject
                                 String strSubject = emailTemplate.Subject;
                                 String ToAddress  = lstAccount[0].Owner.Email;
                                 List<String> LstToAddress  =new List<String>();
                                 LstToAddress.add(ToAddress);                         
                                 strSubject = strSubject.replace('{!AccountName}', lstAccount[0].Name);                         
                                 String strBody = emailTemplate.HtmlValue;
                                 strBody = strBody.replace('{!AccountOwner}', lstAccount[0].Owner.Name);
                                 strBody = strBody.replace('{!AccountName}', lstAccount[0].Name);
                                 strBody = strBody.replace('{!strComment}', strPost);
                                 strBody = strBody.replace('{!linkurl}', strUrl);
                                 WLSendMessageController.sendTemplatedEmail(lstAccount[0].ownerid , strBody, strSubject,LstToAddress,null); 
                             }
                         }                     
                    }   
                }
            } else{
                   showMessage = true;
                   successMsg = false;
                   strfeedmsg = 'Please enter your query';
                }
       }catch(Exception Ex){
           showMessage = true;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Your Query'));
            strfeedmsg = 'Please enter your query';
           }    
       return null;
    }
}