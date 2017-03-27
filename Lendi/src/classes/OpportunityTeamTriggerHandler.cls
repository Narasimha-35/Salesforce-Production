public class OpportunityTeamTriggerHandler extends TriggerHandler {
     public override void afterInsert() {
        for(OpportunityTeamMember member:((List<OpportunityTeamMember>) trigger.new)){
            // check case 1 if the current userid is default user, need round robin
            
            // check case 2 if the current team user is already exist in the team
             
            // check case 3 if the current team user is not in the team, need round robin
            
        }
     }
     
     public override void afterUpdate() {
     
     }
}