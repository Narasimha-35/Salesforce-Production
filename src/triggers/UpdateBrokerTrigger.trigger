trigger UpdateBrokerTrigger on Appointment__c (after update) {
//Set<Id> oppIds = new Set<Id>();

List<Opportunity> oppstoupdate = new list<Opportunity>();
RecordType rtypes = [SELECT Name, id FROM RecordType WHERE sObjectType='Appointment__c' and isActive=true and Name='Confirmed Appointment'];
Appointment__c applst = new Appointment__c();
//applst = [Select Name,Broker__c,Opportunity__c,Broker_Email__c,Broker_Mobile__c from Appointment__c ];
for (Appointment__c app : Trigger.new)
{
if(app.Broker__c != null)
{
    if(app.RecordTypeId== rtypes.id)
    {
        Opportunity oppObj = new Opportunity();
        oppObj.CurrentAssignedBroker__c = app.Broker__c;
        oppobj.id=app.Opportunity__c;
        oppstoupdate.add(oppObj);
        if(app.Previous_Broker_Mobile__c == null && app.Account_Mercury_Id__c == null)
        {
            MercuryApiUtilities.syncWithMercury(app.Opportunity__c, app.Account_Id__c);
        }
    }
}
}
update oppstoupdate;
}