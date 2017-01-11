trigger AddCallFileToAccount on Account(before insert, before update) {

  List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveAccountToCallFileRules();
  System.debug(LoggingLevel.DEBUG, '[AddCallFileToOpportunity] rules: ' + rules);
  if(rules == null || rules.size() == 0) {
    System.debug(LoggingLevel.INFO, '[AddCallFileToOpportunity] there is no rule applys exit...');
    return;
  }
  for (Account acc: trigger.new ) {
    AccountToCallFileUtilities.selectRightCallFileForAccount(acc, rules);
  }
  }