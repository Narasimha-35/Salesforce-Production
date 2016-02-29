trigger TriggerOnAsyncRequest on AsyncRequest__c (after insert) {
   System.debug(LoggingLevel.INFO, '[TriggerOnAsyncRequest] Async Request Inserted: ' + Trigger.new);
   if(!ACFSwitch__c.getOrgDefaults().QueuedAsyncRequestSwitch__c) return;
   System.debug(LoggingLevel.INFO, '[TriggerOnAsyncRequest] QueuedAsyncRequestSwitch__c is on');
   AsyncApexJobSelector aajs = new AsyncApexJobSelector();
   Integer incompleteJobCount = aajs.getInCompleteJobs().size();
   if(incompleteJobCount != 0) return;
   System.debug(LoggingLevel.INFO, '[TriggerOnAsyncRequest] incompleteJobCount: ' + incompleteJobCount);

   Boolean mercuryRequestBatchStartFlag = false;
   for(AsyncRequest__c ar : Trigger.new) {
      System.debug(LoggingLevel.INFO, '[TriggerOnAsyncRequest] Checking Request Type: ' + ar);
      if(ar.type__c == '' + AsyncRequestType.SF_TO_MERCURY || ar.type__c == '' + AsyncRequestType.MERCURY_TO_SF) {
         mercuryRequestBatchStartFlag = true;
         break;
      }
   }

   if(mercuryRequestBatchStartFlag && aajs.getInCompleteJobs().size() != 0) {
      System.debug(LoggingLevel.INFO, '[TriggerOnAsyncRequest] Execute Async Request...');
      Database.executeBatch(new MercuryRequestBatch(0), 1);
   }
}
