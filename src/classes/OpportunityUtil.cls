/*
* OpportunityUtil
*/

public class OpportunityUtil {

	public static Double getTotalOpportunityLineItemValue(Id oppoId) {
		return (Double) [SELECT SUM(click_Loan_Amount__c) total FROM OpportunityLineItem WHERE Opportunity.id =: oppoId][0].get('total');
	}

	public static Map<Id, Double> getTotalOpportunityLineItemValue(Set<Id> oppoId) {
		List<AggregateResult> aggregates = [SELECT Opportunity.id id, SUM(click_Loan_Amount__c) total FROM OpportunityLineItem WHERE Opportunity.id IN :oppoId GROUP BY Opportunity.id];
		Map<Id, Double> ret = new Map<Id, Double>();
		for(AggregateResult agg : aggregates) {
			ret.put((String) agg.get('id'), (Double) agg.get('total'));
		}
		return ret;
	}

}
