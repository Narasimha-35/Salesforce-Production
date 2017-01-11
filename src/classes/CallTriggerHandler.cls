public class CallTriggerHandler extends TriggerHandler{
	
	public static final String APPOINTED = 'Appointed';

	public override void afterInsert() {
    	List<Opportunity> oppos = new List<Opportunity>();
    	for(vhc__Call__c o : (List<vhc__Call__c>) Trigger.new) {
      		//update opportunity last call disposition
      		if (o.vhc__Opportunity__c != null && o.vhc__Qualification__c != null && o.vhc__Qualification__c == APPOINTED) {
      			// last call position to appointed and update the last call position date
      			List<Opportunity> opposLinkedWithCall = [Select Id, Name, Calls_Last_Disposition__c, Calls_Last_Disposition_Date__c From Opportunity Where Id = :o.vhc__Opportunity__c];
      			if (opposLinkedWithCall.size() == 1) {
      				opposLinkedWithCall.get(0).Calls_Last_Disposition__c = APPOINTED;
      				opposLinkedWithCall.get(0).Calls_Last_Disposition_Date__c = System.now();
      				oppos.add(opposLinkedWithCall.get(0));
      			} 
      		}	
    	}
    	update oppos;
  	}
}