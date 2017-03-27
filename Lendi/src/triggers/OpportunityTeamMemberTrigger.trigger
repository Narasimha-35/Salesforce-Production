trigger  OpportunityTeamMemberTrigger  on OpportunityTeamMember ( Before delete ,after update) 
{
     new OpportunityTeamMemberTriggerHelper().run();
}