trigger TriggerOnAsyncRequest on AsyncRequest__c (after insert) {
   System.debug(LoggingLevel.INFO, '[TriggerOnAsyncRequest] Async Request Inserted: ' + Trigger.new);
   if(!ACFSwitch__c.getOrgDefaults().QueuedAsyncRequestSwitch__c) return;
   AsyncApexJobSelector aajs = new AsyncApexJobSelector();
   Integer incompleteJobCount = aajs.getInCompleteJobs().size();

   Boolean mercuryRequestBatchStartFlag = false;
   for(AsyncRequest__c ar : Trigger.new) {
      System.debug(LoggingLevel.INFO, '[TriggerOnAsyncRequest] Checking Request Type: ' + ar);
      if(mercuryRequestBatchStartFlag == false && ar.type__c == 'sync with mercury' && incompleteJobCount == 0) {
         mercuryRequestBatchStartFlag = true;
      }
   }

   if(mercuryRequestBatchStartFlag) {
      System.debug(LoggingLevel.INFO, '[TriggerOnAsyncRequest] Execute Async Request...');
      Database.executeBatch(new MercuryRequestBatch(0), 1);
   }
}
