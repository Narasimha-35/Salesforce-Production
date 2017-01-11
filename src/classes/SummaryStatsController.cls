public class SummaryStatsController {
public Integer getVeryLargeSummaryStat() {
    Integer closedOpportunityStats = 
        [SELECT COUNT() from vhc__Call__c where vhc__Qualification_Detail__c = 'Has Mortgage'];
    return closedOpportunityStats;
}
}