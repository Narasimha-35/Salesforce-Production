// Trigger Created By saasfocus on 10.04.2015

trigger SaaSfocus_CreateEventOnGoogleCalender on Event (after insert,after update) {
  if(Saasfocus_Global.GoogleSyncProces==True)
  {
  return;
  }

    List<Event >  lstApp = new List<Event > ();
    List<String>  ids = new List<String> ();
    
    Schema.DescribeSObjectResult r = Broker__c.sObjectType.getDescribe();
    String keyPrefix = r.getKeyPrefix();
   
    System.debug('::::::::::::::    '+Limits.getFutureCalls());
    for(Event eventObj : Trigger.new){
        String whatId = eventObj.whatId;
        
        if(whatid == null)
        continue;
        
        if(whatId.contains(keyPrefix)){
            ids.add(eventObj.id);
        }
        System.debug(':::::::::     '+ids);
    }
    
    
    
    if(Trigger.isInsert) {
        if(ids!=null){
         Saasfocus_GoogleCalenderHelper.processEvent(ids);
        }
    }
    

}