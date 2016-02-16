trigger UpdateBrokerTrigger on Appointment__c (after update) {
    List<AsyncRequest__c> requestList = new List<AsyncRequest__c>();
    List<Opportunity> oppstoupdate = new list<Opportunity>();
    RecordType rtypes = [SELECT Name, id FROM RecordType WHERE sObjectType='Appointment__c' and isActive=true and Name='Confirmed Appointment'];

    for (Appointment__c app : Trigger.new) {
        if(app.Broker__c != null && app.RecordTypeId == rtypes.id) {
            oppstoupdate.add(new Opportunity(id = app.Opportunity__c, CurrentAssignedBroker__c = app.Broker__c));
            if(app.Previous_Broker_Mobile__c == null && app.Account_Mercury_Id__c == null) {
                //MercuryApiUtilities.syncWithMercury(app.Opportunity__c, app.Account_Id__c);
                Map<String, String> params = new Map<String, String>{'oppoId' => app.Opportunity__c, 'accId' => app.Account_Id__c};
                requestList.add(new AsyncRequest__c(type__c = 'sync with mercury', params__c = (String) JSON.serialize(params)));
            }
        }
    }
    insert requestList;
    update oppstoupdate;
}
