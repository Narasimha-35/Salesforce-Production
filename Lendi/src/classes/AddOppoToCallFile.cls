global class AddOppoToCallFile implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        BatchAddCallFileToOpportunity b = new BatchAddCallFileToOpportunity(); //ur batch class
        database.executebatch(b);
    }
}