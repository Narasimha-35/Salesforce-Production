/*====================================================
				Click Loans
========================================================*/
Public class acfPostquestionController
{
    Public String strPost {get;set;}
    Public String strfeedmsg {get;set;}
    Public String strfeedSuccessmsg {get;set;}
    Public boolean isError {get;set;}
    Public boolean showMessage {get;set;}
    Public Boolean successMsg {get;set;}
    Public acfPostquestionController()
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
            User usrObj = [select id,contactId,AccountId from user where id=:userInfo.getuserId()];
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            textSegmentInput.text = strPost;
            messageBodyInput.messageSegments.add(textSegmentInput);
    
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = usrObj.accountId;
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput, null);
            successMsg = true;
            showMessage = false;
            strfeedSuccessmsg = 'Your query has been submitted. We will get back to you soon';  
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