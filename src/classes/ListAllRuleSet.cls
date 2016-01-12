public without sharing class ListAllRuleSet {
    
    public LeadToCallFileRule__c rule {get; set;}
    public List<LeadToCallFileRuleSet__c> ruleSets {get; set;}
    public Boolean isActive {get; set;}
    public Boolean excludeDoNotCall {get; set;}
    public Boolean excludeDoNotEmail {get; set;}
    public Boolean excludeConverted {get; set;}
    public Boolean excludeClosedAndLost {get; set;}
    public list<SelectOption> fieldOptions {get; set;}
    public list<SelectOption> operators {get; set;}
    public String ruleName {get; set;}
    public String ruleDescription {get; set;}
    public String selectedRuleSetId {get; set;}
    public String selectedRuleObject {get; set;}
    public Boolean renderErrorMessage {get; set;}
    public String errorMessage {get; set;}
    public List<SelectOption> callFilesOptions {get; set;}
    public List<SelectOption> ruleObjectOptions { get; set; }
    
    public ListAllRuleSet() {
    	renderErrorMessage = false;
    	selectedRuleObject = '';
        rule = new LeadToCallFileRule__c();
        Id ruleId =  ApexPages.currentPage().getParameters().get('Id');
        fieldOptions = new list<SelectOption>();
        //fieldOptions = Utilities.getPicklistValues(new LeadToCallFileRuleSet__c() , 'Field_Name__c');
        operators = new list<SelectOption>();
        operators = Utilities.getPicklistValues(new LeadToCallFileRuleSet__c(), 'Operator__c');
        callFilesOptions = new list<SelectOption>();
        callFilesOptions = QuickSort.sortOptionList(Utilities.getCallFileSelectOptions());
        ruleObjectOptions = new list<SelectOption>();
        ruleObjectOptions = getRuleObjectsOptions();
        if (ruleId != null) {
        	rule = LeadToCallFileDAO.getLeadToCallFileRuleById(ruleId);
            if (rule != null) {
                ruleSets = new List<LeadToCallFileRuleSet__c>();
                ruleSets = rule.LeadToCallFileRuleSets__r;
                if (rule.Rule_Object__c == null) {
                	selectedRuleObject = 'lead';
                } else {
                	selectedRuleObject = rule.Rule_Object__c;
                }            
            } else {
            	selectedRuleObject = 'lead';
            }
        } else {
        	selectedRuleObject = 'lead';
        }
        fieldOptions = QuickSort.sortOptionList(Utilities.getSObjectFieldAsSelectOptions(selectedRuleObject));
    }
   
   	public void changeRuleObject() {
   		fieldOptions = QuickSort.sortOptionList(Utilities.getSObjectFieldAsSelectOptions(this.selectedRuleObject));
   	}
   
    public PageReference save() {
    	//ruleSets Debugging
    	Boolean isValidRuleSet = true;
    	for (LeadToCallFileRuleSet__c ruleSet : ruleSets) {
    		if (!LeadToCallFileUtilities.ruleSetErrorCheck(ruleSet)) {
    			isValidRuleSet = false;
    			break;
    		}
    	}
    	if (isValidRuleSet) {
    		renderErrorMessage = true;
    		errorMessage = 'Success Saved';
    		update ruleSets;
	        if (rule != null && rule.Rule_Name__c != null && rule.Rule_Name__c != '') {
	            rule.Name = rule.Rule_Name__c;
	        }
	        upsert rule;
    	} else {
    		errorMessage = 'There is something wrong in the filter';
    		renderErrorMessage = true;
    	}
        return null;
    }
    
    public void moreRule() {
        LeadToCallFileRuleSet__c newRule = new LeadToCallFileRuleSet__c();
        newRule.LeadToCallFileRule__c = rule.Id;
        insert newRule;
        ruleSets.add(newRule);
        //update ruleSets;
    }
    
    public static list<SelectOption> getRuleObjectsOptions() {
   		list<SelectOption> options = new list<SelectOption>();
   		options.add(new SelectOption('lead', 'lead'));
   		options.add(new SelectOption('opportunity', 'opportunity'));
   		//options.add(new SelectOption('Account', 'Account'));
   		return options;
   }
    
    public void deleteRule() {
        // if for any reason we are missing the reference 
        if (selectedRuleSetId == null) {
            return;
        }
        // find the ruleSet in the list
        LeadToCallFileRuleSet__c tobeDeleted = null;
        for(Integer i=0; i < ruleSets.size(); i ++) {
            if (ruleSets.get(i).Id == selectedRuleSetId) {
                tobeDeleted = ruleSets.get(i);
                ruleSets.remove(i);
                break;
            }
        }
        
       //if ruleSet record found delete it
       if (tobeDeleted != null) {
           Delete tobeDeleted;
       }
       
    }
}