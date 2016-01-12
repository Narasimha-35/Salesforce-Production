public class LeadToCallFileDAO {
	public static LeadToCallFileRule__c getLeadToCallFileRuleById(Id ruleId) {
		List<LeadToCallFileRule__c> rules = [Select Id, Name, Delay_To_Call_File_Days__c, Rule_Object__c, Rule_Name__c, Rule_Description__c, Is_Active_Rule__c, 
                    Exclude_Closed_And_Lost__c, Priority__c, Exclude_Converted_Lead__c, Exclude_Do_Not_Call__c, 
                    Exclude_Do_Not_Email__c ,Call_File__c, (select Id, Name, Field_Name_Dyna__c,
                    Field_Value__c, Operator__c From LeadToCallFileRuleSets__r)
                    From LeadToCallFileRule__c where id =: ruleId];
        if (rules.size() > 0) {
        	return rules.get(0);
        }
        return null;            
	}
	
	public static List<LeadToCallFileRule__c> getAllActiveLeadToCallFileRules() {
		List<LeadToCallFileRule__c> rules = [Select Id, Name, Delay_To_Call_File_Days__c, Rule_Object__c, Rule_Name__c, Rule_Description__c, Is_Active_Rule__c, 
                    Exclude_Closed_And_Lost__c, Priority__c, Exclude_Converted_Lead__c, Exclude_Do_Not_Call__c, 
                    Exclude_Do_Not_Email__c ,Call_File__c, (select Id, Name, Field_Name_Dyna__c,
                    Field_Value__c, Operator__c From LeadToCallFileRuleSets__r)
                    From LeadToCallFileRule__c where Is_Active_Rule__c = true and Rule_Object__c = 'Lead'];
        return rules;
	}
	
	public static List<LeadToCallFileRule__c> getAllActiveOpportunityToCallFileRules() {
		List<LeadToCallFileRule__c> rules = [Select Id, Name, Delay_To_Call_File_Days__c, Rule_Object__c, Rule_Name__c, Rule_Description__c, Is_Active_Rule__c, 
                    Exclude_Closed_And_Lost__c, Priority__c, Exclude_Converted_Lead__c, Exclude_Do_Not_Call__c, 
                    Exclude_Do_Not_Email__c ,Call_File__c, (select Id, Name, Field_Name_Dyna__c,
                    Field_Value__c, Operator__c From LeadToCallFileRuleSets__r)
                    From LeadToCallFileRule__c where Is_Active_Rule__c = true and Rule_Object__c = 'Opportunity'];
        return rules;
	}
	
	public static List<LeadToCallFileRule__c> getAllLeadToCallFileRules() {
		List<LeadToCallFileRule__c> rules = [Select Id, Name, Delay_To_Call_File_Days__c, Rule_Object__c, Rule_Name__c, Rule_Description__c, Priority__c, Is_Active_Rule__c, Call_File__c From LeadToCallFileRule__c];
		return rules;
	}
}