public with sharing class MercuryRecordUpdateHandler extends TriggerHandler{

    public override void beforeUpdate() {
        System.debug('brefore insert oppo');
        //MercuryService.updateLoan((Opportunity)Trigger.new[0]);
    }

}
