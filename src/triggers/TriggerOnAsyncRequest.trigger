trigger TriggerOnAsyncRequest on AsyncRequest__c (after insert) {
   if(!ACFSwitch__c.getOrgDefaults().QueuedAsyncRequestSwitch__c) return;
   AsyncApexJobSelector aajs = new AsyncApexJobSelector();
   Integer incompleteJobCount = aajs.getInCompleteJobs().size();

   Boolean mercuryRequestBatchStartFlag = false;
   for(AsyncRequest__c ar : Trigger.new) {
      if(mercuryRequestBatchStartFlag == false && ar.type__c == 'sync with mercury' && incompleteJobCount == 0) {
         mercuryRequestBatchStartFlag = true;
      }
   }

   if(mercuryRequestBatchStartFlag) Database.executeBatch(new MercuryRequestBatch(0), 1);
}
