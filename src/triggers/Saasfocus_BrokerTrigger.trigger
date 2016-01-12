//This trigger adds a counter to the broker as soon as new broker is added.....

trigger Saasfocus_BrokerTrigger on Broker__c (after insert) 
{

List<Counter__c> lstCounter = new List<Counter__c>();
  
  //lstCounter = [SELECT Counter__c.Name, Counter__c.Broker__r.Name from Counter__c];
  for(Broker__c emp: Trigger.new)
    {
      Counter__c ob1 = new Counter__c();  
       ob1.Broker__c = emp.id;
       ob1.Count__c = 0;
       lstCounter.add(ob1);
      }
      system.debug('!bingo '+lstCounter);
      if(lstCounter.size() >0){
          insert lstCounter;
      }
}