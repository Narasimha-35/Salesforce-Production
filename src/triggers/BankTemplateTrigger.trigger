trigger BankTemplateTrigger on acf_Bank_Template__c (before  update , before insert ) {

new BankTemplateTriggerHandler().run();

}