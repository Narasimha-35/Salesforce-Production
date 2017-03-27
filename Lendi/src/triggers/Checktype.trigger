trigger Checktype on Script__c (before insert,before Update){
Integer value=0;
value = [SELECT count() FROM Script__c WHERE acf_Type__c = 'Pre-Login'];
List<RecordType> lstrecdId = [SELECT Id FROM RecordType WHERE Name = 'Pre-Login'];
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Script__c obj:trigger.new){
            if(obj.RecordTypeId!=null){
                if(obj.RecordTypeId.equals(lstrecdId[0].id)){
                    if(value>0){
                    obj.addError('Error occured, Only One Record should be of Type Pre-Login');
                    }
                    else{
                        value=1;
                    }
                }
            }
            else{
                if(obj.acf_Type__c!=null){
                    if(obj.acf_Type__c.equals('Pre-Login')){
                        if(value>0){
                            obj.addError('Error occured, Only One Record should be of Type Pre-Login');
                        }
                        else{
                            value=1;
                        }
                    }
                }       
            }
        }
    }
}