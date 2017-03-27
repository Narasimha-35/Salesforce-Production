public without sharing class AccountToCallFileUtilities {
    public final static String IS_EQUAL_TO = 'is equal to';
    public final static String IS_NOT_EQUAL_TO = 'is not equal to';
    public final static String CONTAINS_WITH = 'contains with';
    public final static String IS_GREATER_THAN = 'is greater than';
    public final static String IS_LESS_THAN = 'is less than';
    public final static String STATUS_CLOSED_LOST = 'Closed Lost';

    public static void selectRightCallFileForAccount(Account acc, List<LeadToCallFileRule__c> rules) {
        //List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveLeadToCallFileRules();
        if (rules.size() > 0) {
            for (LeadToCallFileRule__c rule : rules) {
                boolean fitRule = checkIfaccFitTheRule(acc, rule);
                System.debug(fitRule);
                if (fitRule) {
                    //add delay date here
                    if (acc.vhc__CallFile__c != null && acc.vhc__CallFile__c != rule.Call_File__c) {
                        if (rule.Delay_To_Call_File_Days__c != null && rule.Delay_To_Call_File_Days__c > 0) {
                            acc.Add_To_Call_File_Date__c = Date.today().addDays((Integer) rule.Delay_To_Call_File_Days__c);
                            acc.LeadToCallFileRule__c = rule.Id;
                            acc.vhc__CallFile__c = null;
                            acc.Call_File_Is_Updated__c = false;
                        } 
                        else if(rule.Delay_To_Call_File_Days__c != null && rule.Delay_To_Call_File_Days__c == 0){
                            acc.Add_To_Call_File_Date__c = null;
                            acc.LeadToCallFileRule__c = null;
                            acc.vhc__CallFile__c = rule.Call_File__c;
                            acc.Call_File_Is_Updated__c = true;
                        }
                        else {
                            acc.vhc__CallFile__pc = rule.Call_File__c;
                            acc.Call_File_Is_Updated__c = true;
                        }
                    } else if (acc.vhc__CallFile__c == null || String.valueOf(acc.vhc__CallFile__c) == '') {
                        if (rule.Delay_To_Call_File_Days__c != null && rule.Delay_To_Call_File_Days__c > 0) {
                            acc.Add_To_Call_File_Date__c = Date.today().addDays((Integer) rule.Delay_To_Call_File_Days__c);
                            acc.LeadToCallFileRule__c = rule.Id;
                            acc.vhc__CallFile__c = null;
                            acc.Call_File_Is_Updated__c = false;
                        } 
                         else if(rule.Delay_To_Call_File_Days__c != null && rule.Delay_To_Call_File_Days__c == 0){
                            acc.Add_To_Call_File_Date__c = null;
                            acc.LeadToCallFileRule__c = null;
                            acc.vhc__CallFile__c = rule.Call_File__c;
                            acc.Call_File_Is_Updated__c = true;
                        }
                        
                        else {
                            acc.vhc__CallFile__c = rule.Call_File__c;
                            acc.Call_File_Is_Updated__c = true;
                        }
                    }
                    break;
                }
            }
        }
    }

    public static Boolean checkIfaccFitTheRule(Account acc, LeadToCallFileRule__c rule) {
        //lead.ConvertedDate
        //should be sorted by priority
        //list<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveLeadToCallFileRules();
        Boolean fitRule = true;
        System.debug(rule.Id);
        if (rule != null) {
            //for (LeadToCallFileRule__c rule : rules) {
                list<LeadToCallFileRuleSet__c> ruleSets = rule.LeadToCallFileRuleSets__r;
                System.debug(ruleSets.size());
                if (ruleSets.size() > 0) {
                    //check all the exclusions
                    if (rule.Exclude_Do_Not_Call__c  && acc.PersonDoNotCall) {
                        fitRule = false;
                    }
                    if (rule.Exclude_Do_Not_Email__c && acc.PersonHasOptedOutOfEmail) {
                        fitRule = false;
                    }
                    /*if (rule.Exclude_Do_Not_Call__c && lead.DoNotCall) {
                        fitRule = false;
                    }
                    if (rule.Exclude_Do_Not_Email__c && lead.HasOptedOutOfEmail) {
                        fitRule = false;
                    }
                    if (rule.Exclude_Closed_And_Lost__c && (lead.Status == null || lead.Status.contains(STATUS_CLOSED_LOST))) {
                        fitRule = false;
                    }
                    if (rule.Exclude_Converted_Lead__c && lead.ConvertedDate != null) {
                        fitRule = false;
                    }*/
                    if(fitRule) {
                        for (LeadToCallFileRuleSet__c ruleSet : ruleSets) {
                            //get current ruleSet object type
                            //TO-DO: in the future we may need to add related list check here
                            String objectName = Utilities.getObjectInfo(ruleSet.Field_Name_Dyna__c, Utilities.SOBJECT_NAME);
                            //get current ruleSet object field name
                            System.debug(objectName );
                            String fieldName = Utilities.getObjectInfo(ruleSet.Field_Name_Dyna__c, Utilities.FIELD_NAME);
                            //get current ruleSet object field type
                            String objectFieldType = Utilities.getObjectInfo(ruleSet.Field_Name_Dyna__c, Utilities.SOBJECT_TYPE);
                              System.debug(objectFieldType );
                            //check the field type Date or Datetime
                            //according to the operator, and compare result to decide which call file it should belong to
                            //if the lead already has call file and it is same with the call file we gonna assign, then do not do anything
                            //otherwise assign the call file to this lead
                            //update the field
                            if (objectFieldType == 'DATE' || (objectFieldType == 'DATETIME' && ruleSet.Field_Value__c == 'TODAY')) 
                            {
                                //translate dateString to Date
                                Date currentDate = null;
                                if (ruleSet.Field_Value__c == 'TODAY') {
                                    currentDate = System.today();
                                } else {
                                    currentDate = LeadToCallFileUtilities.convertStringToDate(ruleSet.Field_Value__c);
                                }
                                Date recordDate = null;
                                if (objectFieldType == 'DATETIME') {
                                    Datetime dT = (Datetime) acc.get(fieldName);
                                    if (dT != null) {
                                        recordDate = date.newinstance(dT.year(), dT.month(), dT.day());
                                    }
                                } else {
                                    recordDate = (Date) acc.get(fieldName);
                                }
                                System.debug(currentDate + ' '  +  ruleSet.Operator__c + ' ' + recordDate);
                                if (ruleSet.Operator__c == IS_EQUAL_TO) {
                                    if (currentDate != recordDate) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == IS_NOT_EQUAL_TO) {
                                    if (currentDate == recordDate) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == IS_GREATER_THAN) {
                                    if (recordDate <= currentDate) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == IS_LESS_THAN) {
                                    if (recordDate >= currentDate) {
                                        fitRule = false;
                                    }
                                }
                            } 
                            else if (objectFieldType == 'DATETIME') 
                            {
                                Datetime currentDatetime = LeadToCallFileUtilities.convertStringToDateTime(ruleSet.Field_Value__c);
                                Datetime recordDatetime = (Datetime) acc.get(fieldName);
                                if (ruleSet.Operator__c == IS_EQUAL_TO) {
                                    if (currentDatetime != recordDatetime) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == IS_NOT_EQUAL_TO) {
                                    if (currentDatetime == recordDatetime) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == IS_GREATER_THAN) {
                                    if (recordDatetime <= currentDatetime) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == IS_LESS_THAN) {
                                    if (recordDatetime >= currentDatetime) {
                                        fitRule = false;
                                    }
                                }
                            } 
                            else if (  objectFieldType == 'EMAIL' ||  objectFieldType == 'STRING' || objectFieldType == 'TEXTAREA' || objectFieldType == 'PICKLIST' || objectFieldType == 'PHONE') 
                            {
                                String compareValue = String.valueOf(ruleSet.Field_Value__c);
                                  String recordValue ='';
                                if(fieldName == 'Name')
                                {
                                    if(acc.get('FirstName') != null)
                                    {
                                        recordValue = (String) acc.get('FirstName')+' '+(String) acc.get('LastName');
                                    }
                                    else
                                    {
                                        recordValue = (String) acc.get('LastName');
                                    }
                                }
                                else
                                {
                                 recordValue = (String) acc.get(fieldName);
                                }
                                
                                System.debug(compareValue + ' ' + recordValue);
                                if (ruleSet.Operator__c == IS_EQUAL_TO) {
                                    if (recordValue != compareValue) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == CONTAINS_WITH) {
                                    if (recordValue == null || !recordValue.contains(compareValue)) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == IS_NOT_EQUAL_TO) {
                                    if (recordValue == compareValue) {
                                        fitRule = false;
                                    }
                                }
                            }
                            else if (objectFieldType == 'INTEGER' || objectFieldType == 'DOUBLE' || objectFieldType == 'CURRENCY' || objectFieldType == 'PERCENT') {
                                Double compareValue = Double.valueOf(ruleSet.Field_Value__c);
                                Double recordValue = (Double) acc.get(fieldName);
                                if (ruleSet.Operator__c == IS_EQUAL_TO) {
                                    if (compareValue != recordValue) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == IS_NOT_EQUAL_TO) {
                                    if (compareValue == recordValue) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == IS_GREATER_THAN) {
                                    if (recordValue <= compareValue) {
                                        fitRule = false;
                                    }
                                } else if (ruleSet.Operator__c == IS_LESS_THAN) {
                                    if (recordValue >= compareValue) {
                                        fitRule = false;
                                    }
                                }
                            }
                            // if any ruleset is false, then jump to the next rule
                            if (!fitRule) {
                                break;
                            }
                        }
                    }
                    //if current rule is satified, then check the call file if they are the same
                    /*if (fitRule) {
                        if (lead.vhc__CallFile__c != null && String.valueOf(lead.vhc__CallFile__c) != ''
                            && String.valueOf(lead.vhc__CallFile__c) == String.valueOf(rule.Call_File__c)) {
                            fitRule = false;
                        }
                    }*/
                }
            //}
        }
        return fitRule;
    }
}