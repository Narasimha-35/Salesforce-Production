trigger LogPersonAccountChange on Account (before delete, after insert, after undelete)
{
  List<pi__ObjectChangeLog__c> logs = new List<pi__ObjectChangeLog__c>(); 

  if (Trigger.new != null) {
    for (Account account : Trigger.new) {

      if (Account.PersonEmail != null && Account.PersonEmail != '') {
        pi__ObjectChangeLog__c log = new pi__ObjectChangeLog__c();
        log.pi__ObjectFid__c = Account.PersonContactId;
        log.pi__ObjectType__c = 1;
        log.pi__ObjectEmail__c = Account.PersonEmail;

        if  (System.Trigger.isInsert) {
          log.pi__ObjectState__c = 1;
        } else if  (System.Trigger.isDelete) {
          log.pi__ObjectState__c = 2;
        } else if  (System.Trigger.isUnDelete) {
          log.pi__ObjectState__c = 3;

        }
        logs.add(log);
      }
    }
  } else if (Trigger.old != null) {
    for (Account account : Trigger.old) {
      if (Account.PersonEmail != null && Account.PersonEmail != '') {
        pi__ObjectChangeLog__c log = new pi__ObjectChangeLog__c();

        log.pi__ObjectFid__c = Account.PersonContactId

        ;
        log.pi__ObjectType__c = 1;
        log.pi__ObjectEmail__c = Account.PersonEmail;
        if  (System.Trigger.isInsert) {
          log.pi__ObjectState__c = 1;
        } else if  (System.Trigger.isDelete) {
          log.pi__ObjectState__c = 2;
        } else if  (System.Trigger.isUnDelete) {
          log.pi__ObjectState__c = 3;
        }
        logs.add(log);
      }
    }
  }

  if (logs.size() > 0) {

    insert logs;
  }
}