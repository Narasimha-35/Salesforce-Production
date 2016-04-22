public class LeadToCallFileUtilities {
    public final static String IS_EQUAL_TO = 'is equal to';
    public final static String IS_NOT_EQUAL_TO = 'is not equal to';
    public final static String CONTAINS_WITH = 'contains with';
    public final static String IS_GREATER_THAN = 'is greater than';
    public final static String IS_LESS_THAN = 'is less than';
    public final static String STATUS_CLOSED_LOST = 'Closed Lost';

    //select all the active rule sorted by Priority
    //for each rule, go to checkIfLeadFitTheRule Method
    //As long as the rule is fit, break
    //Get the call file, if it is update, check if the call file is the same,
    //otherwise it is insert or it is different
    //assign the call file, update the field
    public static void selectRightCallFileForLead(Lead lead, List<LeadToCallFileRule__c> rules) {
        //List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveLeadToCallFileRules();
        if (rules.size() > 0) {
            for (LeadToCallFileRule__c rule : rules) {
                boolean fitRule = checkIfLeadFitTheRule(lead, rule);
                if (fitRule) {
                    System.debug('This is the rule fit ' + rule.Id);
                    // last time call file is different from the new call file
                    if (lead.vhc__CallFile__c != null && lead.vhc__CallFile__c != rule.Call_File__c) {
                        if (rule.Delay_To_Call_File_Days__c != null && rule.Delay_To_Call_File_Days__c > 0) {
                            lead.AddToCallFileDate__c = Date.today().addDays((Integer) rule.Delay_To_Call_File_Days__c);
                            lead.LeadToCallFileRule__c = rule.Id;
                        } else {
                            lead.vhc__CallFile__c = rule.Call_File__c;
                            lead.Is_Updated__c = true;
                        }
                        // first time call file update
                    } else if (lead.vhc__CallFile__c == null || String.valueOf(lead.vhc__CallFile__c) == '') {
                        if (rule.Delay_To_Call_File_Days__c != null && rule.Delay_To_Call_File_Days__c > 0) {
                            lead.AddToCallFileDate__c = Date.today().addDays((Integer) rule.Delay_To_Call_File_Days__c);
                            lead.LeadToCallFileRule__c = rule.Id;
                        } else {
                            lead.vhc__CallFile__c = rule.Call_File__c;
                            lead.Is_Updated__c = true;
                        }
                    }
                    break;
                }
            }
        }
    }

    public static Boolean checkIfLeadFitTheRule(Lead lead, LeadToCallFileRule__c rule) {
        //lead.ConvertedDate
        //should be sorted by priority
        //list<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveLeadToCallFileRules();
        Boolean fitRule = true;
        if (rule != null) {
            //for (LeadToCallFileRule__c rule : rules) {
            list<LeadToCallFileRuleSet__c> ruleSets = rule.LeadToCallFileRuleSets__r;
            if (ruleSets.size() > 0) {
                //check all the exclusions
                if (rule.Exclude_Do_Not_Call__c && lead.DoNotCall) {
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
                }
                if(fitRule) {
                    for (LeadToCallFileRuleSet__c ruleSet : ruleSets) {
                        //get current ruleSet object type
                        //TO-DO: in the future we may need to add related list check here
                        String objectName = Utilities.getObjectInfo(ruleSet.Field_Name_Dyna__c, Utilities.SOBJECT_NAME);
                        //get current ruleSet object field name
                        String fieldName = Utilities.getObjectInfo(ruleSet.Field_Name_Dyna__c, Utilities.FIELD_NAME);
                        //get current ruleSet object field type
                        String objectFieldType = Utilities.getObjectInfo(ruleSet.Field_Name_Dyna__c, Utilities.SOBJECT_TYPE);
                        //check the field type Date or Datetime
                        //according to the operator, and compare result to decide which call file it should belong to
                        //if the lead already has call file and it is same with the call file we gonna assign, then do not do anything
                        //otherwise assign the call file to this lead
                        //update the field
                        if (objectFieldType == 'DATE' || (objectFieldType == 'DATETIME' && ruleSet.Field_Value__c == 'TODAY')) {
                            //translate dateString to Date
                            /* Check TODAY keyword */
                            Date currentDate = null;
                            if (ruleSet.Field_Value__c == 'TODAY') {
                                currentDate = System.today();
                            } else {
                                currentDate = convertStringToDate(ruleSet.Field_Value__c);
                            }
                            Date recordDate = null;
                            if (objectFieldType == 'DATETIME') {
                                Datetime dT = (Datetime) lead.get(fieldName);
                                if (dT != null) {
                                    recordDate = date.newinstance(dT.year(), dT.month(), dT.day());
                                }
                            } else {
                                recordDate = (Date) lead.get(fieldName);
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
                        } else if (objectFieldType == 'DATETIME') {
                            /*Add Today Key Word*/
                            Datetime currentDatetime = convertStringToDateTime(ruleSet.Field_Value__c);
                            Datetime recordDatetime = (Datetime) lead.get(fieldName);
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
                        } else if (objectFieldType == 'STRING' || objectFieldType == 'TEXTAREA' || objectFieldType == 'PICKLIST' || objectFieldType == 'PHONE') {
                            String compareValue = String.valueOf(ruleSet.Field_Value__c);
                            String recordValue = (String) lead.get(fieldName);
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
                        } else if (objectFieldType == 'INTEGER' || objectFieldType == 'DOUBLE' || objectFieldType == 'CURRENCY' || objectFieldType == 'PERCENT') {
                            Double compareValue = Double.valueOf(ruleSet.Field_Value__c);
                            Double recordValue = (Double) lead.get(fieldName);
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
            }
            //}
        }
        return fitRule;
    }

    public static boolean checkDateFormat(String dateString) {
        List<String> parts = dateString.split('-');
        if (parts.size() == 3 && Integer.valueof(parts.get(0)) > 1000  && Integer.valueof(parts.get(0)) <3000
        && Integer.valueof(parts.get(1)) < 13 && Integer.valueof(parts.get(1)) > 0
        && Integer.valueof(parts.get(2)) < 32 && Integer.valueof(parts.get(2)) > 0) {
            return true;
        }
        return false;
    }

    public static Date convertStringToDate(String dateString) {
        List<String> parts = dateString.split('-');
        Date myDate = Date.newInstance(Integer.valueOf(parts.get(0)), Integer.valueOf(parts.get(1)), Integer.valueOf(parts.get(2)));
        return myDate;
    }

    public static Datetime convertStringToDateTime(String datetimeString) {
        List<String> parts = datetimeString.split('-');
        Datetime myDatetime = Datetime.newInstanceGMT(Integer.valueOf(parts.get(0)), Integer.valueOf(parts.get(1)), Integer.valueOf(parts.get(2)));
        return myDatetime;
    }

    public static boolean ruleSetErrorCheck(LeadToCallFileRuleSet__c ruleSet) {
        if (ruleSet != null && ruleSet.Field_Value__c != null
        && ruleSet.Field_Value__c != '' && ruleSet.Field_Name_Dyna__c != null
        && ruleSet.Field_Name_Dyna__c != '' && ruleSet.Operator__c != null
        && ruleSet.Operator__c != '') {
            String fieldType = Utilities.getObjectInfo(ruleSet.Field_Name_Dyna__c, Utilities.SOBJECT_TYPE);
            if (fieldType.contains('DATE')) {
                // Date type
                if (checkDateFormat(ruleSet.Field_Value__c) || ruleSet.Field_Value__c == 'Today') {
                    return true;
                } else {
                    return false;
                }
            } else if (fieldType.contains('DOUBLE') || fieldType.contains('INTEGER') || fieldType.contains('CURRENCY') || fieldType.contains('PERCENT')) {
                // Number
                if (ruleSet.Field_Value__c.isNumeric()) {
                    return true;
                } else {
                    return false;
                }
            }
        } else {
            return false;
        }
        return true;
    }
}
