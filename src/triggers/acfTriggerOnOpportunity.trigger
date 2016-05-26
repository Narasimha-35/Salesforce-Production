/*====================================================
        Click Loans
========================================================*/
trigger acfTriggerOnOpportunity on Opportunity (after insert) 
{
  acfTriggerOnOpportunityHandler objTrgOppHandler = new acfTriggerOnOpportunityHandler();
  if(trigger.isAfter && trigger.isInsert)
    objTrgOppHandler.OnAfterInsert(Trigger.new);
}