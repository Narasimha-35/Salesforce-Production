public without sharing class DNCRuleSetUpController {
	public List<DNC_Wash_Rule__c> ruleDNCSets { get; set; }
	public DNC_Call_File_Setup__c callFileSetup { get; set; }
    public String currentBalance { get; set; }
    public Integer leadCount { get; set; }
    public Integer leadPhoneAndMobileCount { get; set; }
    public Boolean isActive { get; set; }
    public Boolean renderLeadStatistic { get; set; }
    public list<SelectOption> fieldOptions { get; set; }
    public list<SelectOption> operators { get; set; }
    public String selectedRuleSetId { get; set; }
    public Boolean renderErrorMessage { get; set; }
    public String errorMessage { get; set; }
    public List<SelectOption> callFilesOptions { get; set; }
    public Boolean excludeDoNotCall {get; set;}
    public Boolean excludeDoNotEmail {get; set;}
    public Boolean excludeConverted {get; set;}
    public Boolean excludeClosedAndLost {get; set;}
    
    public DNCRuleSetUpController() {
    	renderErrorMessage = false;
    	renderLeadStatistic = false;
    	ruleDNCSets = new List<DNC_Wash_Rule__c>();
        ruleDNCSets = [Select Id, Name, Api_Field_Name__c, Field_Value__c, Operator__c From DNC_Wash_Rule__c];
        fieldOptions = new list<SelectOption>();
        //fieldOptions = Utilities.getPicklistValues(new LeadToCallFileRuleSet__c() , 'Field_Name__c');
        fieldOptions = QuickSort.sortOptionList(Utilities.getSObjectFieldAsSelectOptions('lead'));
        operators = new list<SelectOption>();
        operators = Utilities.getPicklistValues(new DNC_Wash_Rule__c(), 'Operator__c');
        callFilesOptions = new list<SelectOption>();
        callFilesOptions = QuickSort.sortOptionList(Utilities.getCallFileSelectOptions());
        List<DNC_Call_File_Setup__c> callFileSetups = [Select Id, Name, Call_File__c, Update_Call_File_With_Lead__c From DNC_Call_File_Setup__c];
        if (callFileSetups.size() == 1) {
        	callFileSetup = callFileSetups.get(0);
        } else if (callFileSetups.size() == 0) {
        	callFileSetup = new DNC_Call_File_Setup__c();
        }
    }
   
    public PageReference save() {
    	//ruleSets Debugging
    	this.currentBalance = DNCWashUtilities.getCurrentAccountBalanceDNC();
    	Boolean isValidRuleSet = true;
    	/*for (LeadToCallFileRuleSet__c ruleSet : ruleSets) {
    		if (!LeadToCallFileUtilities.ruleSetErrorCheck(ruleSet)) {
    			isValidRuleSet = false;
    			break;
    		}
    	}*/
    	if (isValidRuleSet) {
    		renderErrorMessage = true;
    		errorMessage = 'Success Saved';
    		update ruleDNCSets;
	        //if (rule != null && rule.Rule_Name__c != null && rule.Rule_Name__c != '') {
	            //rule.Name = rule.Rule_Name__c;
	        //}
	        //upsert rule;
    	} else {
    		errorMessage = 'There is something wrong in the filter';
    		renderErrorMessage = true;
    	}
    	
    	//Start to get count;
    	DNCWashUtilities.DNCRuleResult result = DNCWashUtilities.countPhoneNumberFromAllLeadsFitRule();
        this.leadCount = result.leadCount;
        this.leadPhoneAndMobileCount = result.leadPhoneAndMobileCount;
        renderLeadStatistic = true;
        upsert callFileSetup;
        return null;
    }
    
    public void moreRule() {
        DNC_Wash_Rule__c newRule = new DNC_Wash_Rule__c();
        insert newRule;
        ruleDNCSets.add(newRule);
        //update ruleSets;
    }
    
    public void deleteRule() {
        // if for any reason we are missing the reference 
        if (selectedRuleSetId == null) {
            return;
        }
        // find the ruleSet in the list
        DNC_Wash_Rule__c tobeDeleted = null;
        for(Integer i=0; i < ruleDNCSets.size(); i ++) {
            if (ruleDNCSets.get(i).Id == selectedRuleSetId) {
                tobeDeleted = ruleDNCSets.get(i);
                ruleDNCSets.remove(i);
                break;
            }
        }
        
       //if ruleSet record found delete it
       if (tobeDeleted != null) {
           Delete tobeDeleted;
       }
    }
    
    public void triggerWashFunction() {
    	renderErrorMessage = true;
    	errorMessage = 'Start Processing';
    	BatchLeadDNCRWash job = new BatchLeadDNCRWash();
		database.executebatch(job, 10);
    }
}