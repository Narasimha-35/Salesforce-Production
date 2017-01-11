public Class chatterUtlities {
    
    @InvocableMethod
    // makes a simple chatter text post to the specified user from the running user 
    public static void mentionTextPost(List<Id> accountId) { 
        if(accountId.size() != 1) return;
        Id accId = accountId[0];
        Account acc = [SELECT id, Chatter_Message__c FROM Account WHERE id = :accId];
        
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        //set community user id
        User commUser = [SELECT id, accountid, contactid FROM User WHERE accountid = :accId];
        mentionSegmentInput.id = commUser.id;
        messageBodyInput.messageSegments.add(mentionSegmentInput);

        //set message
        textSegmentInput.text = acc.Chatter_Message__c;
        messageBodyInput.messageSegments.add(textSegmentInput);

        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        //record id
        feedItemInput.subjectId = accId;
        feedItemInput.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;

        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput, null);
        acc.Chatter_Message__c = '';
        update acc;
    }
    
}