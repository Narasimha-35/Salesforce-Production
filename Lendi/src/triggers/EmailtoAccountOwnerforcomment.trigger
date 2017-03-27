trigger EmailtoAccountOwnerforcomment on FeedComment (After insert) {

set<id> setofAccountownerid = new set<id>();
List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
id currentloggedinUserId = userinfo.getuserid();
  for(FeedComment fc : trigger.new)
   {
    if(fc.CommentBody <> null && fc.CommentBody <> '')
    {
      if(fc.InsertedById == currentloggedinUserId)
  setofAccountownerid.add(fc.InsertedById);     
    }
  
   }

    //User us = [select id,Email from User where id IN : setofAccountownerid Limit 1];
    List<User> lstUser = [Select Id,contactid,Contact.Accountid from User where  Id =: currentloggedinUserId];        
    if(lstUser != null && lstUser.size()>0 && lstUser[0].Contactid != null && lstUser[0].Contact.Accountid <> null)
    {  
     
    id id1 = lstUser[0].Contact.Accountid;
    system.debug('id1'+id1);
    
    Account objacc = [Select id,Name,owner.Name,Ownerid,owner.email,Feed_Comment_check__c  from Account where id=:id1 limit 1];
 //map<id,user> mapUserIdToUser = new map<id,user>([select id,email from user where id=:objacc.ownerid]);
    system.debug('id1'+objacc);
 //   list<account> lstaccount = new list<account>();
 //system.debug('@@Test'+mapUserIdToUser);
  for(FeedComment fc : trigger.new)
  {
   if(fc.CommentBody <> null && fc.CommentBody <> '')
    {
 /*     Account acc = new Account(id =objacc.id) ;
        if(acc.Feed_Comment_check__c == false)
        {
  
        
           String userEmail = 'ankit.singh@saasfocus.com'; */
         
            String userEmail = objacc.owner.email; 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            String[] toAddresses = new String[] {userEmail}; 
            mail.setToAddresses(toAddresses); 
            mail.setSubject('Click Feed'); 
            String body = 'Hi '+objacc.owner.Name+',';
             body +='<br/><p>'+objacc.Name+' needs your assistance.</p>'; 
            mail.setHtmlBody(body); 
            emails.add(mail);
   /*         acc.Feed_Comment_check__c = true;
            lstaccount.add(acc);
            }      
            system.debug('id2'+acc);   */
       }
     }   
  
    /*      if(lstaccount != null && lstaccount.size() > 0)
          {
           update lstaccount;
           }
         
     */
      

    
    
    if(emails <> null && emails.size() > 0)
     {
       Messaging.sendEmail(emails);
     }
     
  }
     
}