trigger trackOppStatusfeedTrigger on Opportunity (after update) { 

   ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
   if (acfSwitch != null && acfSwitch.get('OppStatusfeedTriggerSwitch__C') != null 
        && (Boolean) acfSwitch.get('OppStatusfeedTriggerSwitch__C')) {
   
           Set<ID> accIds = new Set<ID>();
           Map<ID,String> Map_trackOpp = new Map<ID,String>();
           List<AccountFeed> List_accFeed = new List<AccountFeed>();
           String strTrack = '';
           if(acfCommon.IsStopRecursion == true)
           {
              acfCommon.IsStopRecursion = false;
               for(Id oppId : Trigger.newMap.keySet()){
                 if( Trigger.oldMap.get(oppId).acf_Status__c != Trigger.newMap.get(oppId).acf_Status__c && Trigger.newMap.get(oppId).acf_Status__c != 'Application')
                 {
                    accIds.add(Trigger.newMap.get(oppId).accountId);
                    strTrack = 'The Opportunity Status is changed from '+Trigger.oldMap.get(oppId).acf_Status__c+' to '+Trigger.newMap.get(oppId).acf_Status__c;
                    Map_trackOpp.put(Trigger.newMap.get(oppId).accountId,strTrack);
                 }
               }
           }    
          If(!accIds.isEmpty()){
           for(ID acId : accIds){
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                    
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                    
                textSegmentInput.text = Map_trackOpp.get(acId);
                messageBodyInput.messageSegments.add(textSegmentInput);
        
                feedItemInput.body = messageBodyInput;
                feedItemInput.visibility = ConnectApi.FeedItemVisibilityType.allusers;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput.subjectId = acId;
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput, null);
               // AccountFeed accf = [select id,visibility from accountfeed where id =: acId];
               // system.debug('@@@@'+accf);
            }
          }
     }     
}