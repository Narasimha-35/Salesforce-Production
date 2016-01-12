Public class WLBookAppointmentController
{   
    Public User usrObj;
    Public User Obj_OppOwner {get;set;}
    Public String selectedDate {get;set;}
    Public String selectedTime {get;set;}
    Public Boolean isScheduleTask {get;set;}
    Public List<String> List_schTime {get;set;}
    public List<MortgageExpert__c> List_mExpert{get;set;}
    public boolean isMsgsent {get;set;}
    public String schDate {get;set;}
    Public String ErrorMsg {get;set;}
    Public String RequestStatus {get;set;}
    public string strMortgageMsg {get;set;}  
    public boolean isSuccessmsg {get;set;} 
    public Map<string,integer> MapMonthList;

    Public String strPost {get;set;}
    Public String strfeedmsg {get;set;}
    Public String strfeedSuccessmsg {get;set;}
    Public boolean isError {get;set;}
    Public boolean showMessage {get;set;}
    Public Boolean successMsg {get;set;}
    Public Opportunity oppObj;
    
    public WLBookAppointmentController(){ 
        isScheduleTask = false;
        ErrorMsg = '';
        RequestStatus = '';
        schDate = '';
        selectedTime = '';
        strMortgageMsg = '';
        isSuccessmsg = false;
        //isMsgsent = false; 
        List_schTime = new List<String>();
        MapMonthList = new Map<string,integer>();
        List_mExpert = new List<MortgageExpert__c>();
        usrObj = [select id,username,Name,contactId,contact.ownerId,accountId,account.ownerId,account.Partner_User__c,contact.acf_lead__c,Email,firstName,lastName,MobilePhone from user where id=:UserInfo.getuserId()];
               
        schTimeMethod();
        List_mExpert = MortgageExpert__c.getall().values();
        If(usrObj != null && usrObj.accountId != null)
        {
            Id mortgageExpertId = usrObj.contact.ownerId;
            if(usrObj.account.Partner_User__c != null)
            {
                mortgageExpertId = usrObj.account.Partner_User__c;
            }
            list<user> lstUserList = new list<user>();
            if(mortgageExpertId <> null)
            {
                lstUserList = [select id,Name,FullPhotoUrl,username,acfWork_Experience__c,MobilePhone,Email from user where id=:mortgageExpertId]; 
     //           system.debug('@@@mortage'+Obj_OppOwner);
            }
            if(lstUserList != null && lstUserList.size()>0)
            {
                Obj_OppOwner = lstUserList[0];
            }
        }
    }
    
    public void schTimeMethod(){
      Schema.DescribeFieldResult fieldResult = Task.Due_Time__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry tVar : ple){
            List_schTime.add(tVar.getvalue());
        }
        MapMonthList.put('Jan',1);
        MapMonthList.put('Feb',2);
        MapMonthList.put('Mar',3);
        MapMonthList.put('Apr',4);
        MapMonthList.put('May',5);
        MapMonthList.put('Jun',6);
        MapMonthList.put('Jul',7);
        MapMonthList.put('Aug',8);
        MapMonthList.put('Sep',9);
        MapMonthList.put('Oct',10);
        MapMonthList.put('Nov',11);
        MapMonthList.put('Dec',12);
        
        system.debug('time values@@@@'+List_schTime);
    }
    
    Public pagereference redirect(){
        String oppId = acfCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId()); 
        If(oppId != null && oppId <> ''){
           return null;
        }else{
                String retUrl  = acfCommon.sendReturnUrl(userInfo.getuserId(),false,'acfBookAppointment'); 
                Pagereference pageref= new Pagereference('/'+retUrl);
                return pageref;
             }
    }
    
    public pagereference sendmsgToLeadOwner(){
        if(strMortgageMsg != null && strMortgageMsg <> '')
        {
            If(Obj_OppOwner!=null && Obj_OppOwner.mobilePhone != null){
               string strMobile = Obj_OppOwner.mobilePhone;
               If(strMobile.startswith('+61') == true){
                    String response = acfCommon.sendSMS(Obj_OppOwner.Name,Obj_OppOwner.mobilePhone,strMortgageMsg,true); 
                   /* isMsgsent = true;  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,+response);                                                                 
                    ApexPages.addMessage(myMsg);*/
                    system.debug('@@@@@@@@@@@@@@test123'+response);
                    If(response <> null && response <> '' && response.contains('success')){
                        ErrorMsg = 'Your request has been sent.Our mortgage expert will get back to you soon!';
                        isSuccessmsg = true;
                    }else{
                            ErrorMsg = 'Your Request Failed,Please Try Again!';
                            isSuccessmsg = false;
                         }
                }else{
                          ErrorMsg = 'User mobile number should starts with +61';
                          isSuccessmsg = false;
                      }
             }else{
                     ErrorMsg = 'User mobile number should not be null';
                     isSuccessmsg = false;
                  }
        }else{
            ErrorMsg = 'Please enter text';
            isSuccessmsg = false;
        }
        return null;
    }
    
    public pagereference showCalender(){
        system.debug('@@karthik@@'+selectedDate);
        RequestStatus = '';
        selectedTime = '';
        schDate = '';
         If(selectedDate == 'Schedule'){
          isScheduleTask = true;

         }else{
               isScheduleTask = false; 
         }       
        system.debug('@@karthik@@'+isScheduleTask);
        return null;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('ASAP','As Soon Possible')); 
        options.add(new SelectOption('Schedule','Schedule Time')); 
        return options; 
    }
    
    Public List<SelectOption> getTimeItems(){
        List<SelectOption> options = new List<SelectOption>(); 
        for(String strTime : List_schTime){
            options.add(new SelectOption(strTime,strTime));
        }
        return options;
    }        
    
    
    Public pagereference createTask()
    {
       system.debug('date schedule'+schDate);
       system.debug('selectedtime@@@'+selectedTime);
       try{
        If(Obj_OppOwner!=null&&usrObj.contactId!=null){
             Task tObj = new Task();
             tObj.subject = 'Appointment Request from Customer';
             tObj.Whoid = usrObj.contactId;
             tObj.Whatid = usrObj.accountId;
             tObj.OwnerId = Obj_OppOwner.id;
             tObj.IsVisibleInSelfService = false;
              
              If(selectedTime != null && schDate != null && selectedTime <> '' && schDate <> '')
              {   
                Integer month = Integer.valueof(schDate.substring(0,2));
                Integer day = Integer.valueof(schDate.substring(3,5));
                Integer year = Integer.valueof(schDate.substring(6,10));
                system.debug('day var'+day);
                system.debug(''+year);
                system.debug(''+month);
                 Date Actdate  = Date.newInstance(Year, month, day);
                 system.debug('schedule date'+Actdate);
                                  
                 if (Actdate < system.today()){
                     RequestStatus = 'Please select a valid time slot';
                 }else{
                     
                     if(Actdate == system.today()){
                         Integer hrs = Integer.valueof(selectedTime.substring(0,2));
                         Integer mins = Integer.valueof(selectedTime.substring(3,5));
                         string ampm = selectedTime.substring(6,8);
                         if(ampm == 'PM'){
                             hrs = hrs + 12 ;
                         }
                         Time myTime = Time.newInstance(hrs , mins , 0, 0);
                         system.debug(' MyTime'+myTime );
                         if(myTime >= system.Now().time()){
                             tObj.ActivityDate = Actdate;
                             system.debug('Activity Date'+tObj.ActivityDate);
                             tObj.Due_Time__c = selectedTime;
                             insert tObj;

                             system.debug('@@karthik@@'+tObj);
                             RequestStatus = 'Your request submitted successfully';
                         }else{
                             RequestStatus = 'Please select a valid time slot';
                         }
                     }else{
                             tObj.ActivityDate = Actdate;
                             system.debug('Activity Date'+tObj.ActivityDate);
                             tObj.Due_Time__c = selectedTime;
                             insert tObj;
                             system.debug('@@karthik@@'+tObj);
                             RequestStatus = 'your request submitted successfully';
                     }
                     
                }
             }else{
                 RequestStatus = 'Please Select Date And Time before book';
             }
             system.debug('RequestStatus '+RequestStatus );
             if(RequestStatus == 'your request submitted successfully')
             {
              String oppId = acfCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId()); 
              oppObj = new Opportunity();
              oppObj.id = oppId;
              oppObj.Acf_IsMailSentToOwner__c = true;
             update oppObj;
             }
            /* ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'your request submitted successfully');                                                                 
             ApexPages.addMessage(myMsg);*/
        
         }
        } 
        
        catch(Exception Ex){
               system.debug('#Error@@@'+Ex);
               RequestStatus = 'Your request not submitted,Please try again!';
             /*  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Your request not submitted,Please try again!');                                                                 
               ApexPages.addMessage(myMsg);*/
              }
              isScheduleTask = false;
         return null;   
    }
    
    
/*    public static void sendTemplatedEmail(string strContent, string strSubject,tObj.OwnerId)
    {
        //try 
        //{
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            if(targetObjId <> null)
                email.setTargetObjectId(OpportunityId);
            if(lstToEmail <> null && lstToEmail.size()>0)
                email.setToAddresses(lstToEmail);
                email.setToAddresses(tObj.OwnerId);  
            email.setSubject(tObj.subject);
            email.setSenderDisplayName('ACF');
            email.setPlainTextBody(strContent);
            email.setHtmlBody(strContent);
            email.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        //}
        //catch (Exception e) 
        //{
       // }
    }  */

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