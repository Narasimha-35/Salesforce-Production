// ----------------------------------------------------------------------------------
// This class tests business logic for CounterACFFaceBroker
// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       15-April-2015      Amit Kumar Sharma         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// Notes: 
// ----------------------------------------------------------------------------------
// Test coverage for CounterACFFaceBroker:  100%

public class SaasFocus_CounterACFFaceBroker
{
//picks type of channel from picklist and makes the counter zero monthly
public void count()
{
    
    list<Counter__c> lstCounter=[select Count__c, Broker__r.Channel__c from Counter__c where Broker__r.Channel__c = 'Employee' or Broker__r.Channel__c = 'Partner'];
   
    for(Counter__c cc: lstCounter)
    {
         cc.Count__c =0;
    }
 update lstCounter;
}
}