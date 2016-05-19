trigger AddCallFileToLead on Lead (before insert, before update) {
	if((Boolean) ACFSwitch__c.getOrgDefaults().get('LeadTriggerSwitch__c') == false) return;
	//for (Lead lead : [Select l.vhc__targetOutboundCampaignId__c, l.vhc__CallFile__c, l.smagicinteract__SMSOptOut__c, l.pi__utm_term__c, l.pi__utm_source__c, l.pi__utm_medium__c, l.pi__utm_content__c, l.pi__utm_campaign__c, l.pi__url__c, l.pi__score__c, l.pi__notes__c, l.pi__last_activity__c, l.pi__grade__c, l.pi__first_touch_url__c, l.pi__first_search_type__c, l.pi__first_search_term__c, l.pi__first_activity__c, l.pi__created_date__c, l.pi__conversion_object_type__c, l.pi__conversion_object_name__c, l.pi__conversion_date__c, l.pi__comments__c, l.pi__campaign__c, l.bizible__WebSource__c, l.bizible__Text_Ad__c, l.bizible__Search_Phrase__c, l.bizible__Region__c, l.bizible__ReferrerPage__c, l.bizible__Medium__c, l.bizible__LandingPage__c, l.bizible__Keyword__c, l.bizible__Device__c, l.bizible__Country__c, l.bizible__City__c, l.bizible__Bizible_UserId__c, l.bizible__Ad_Group__c, l.bizible__AdWords_Campaign__c, l.affiliate_source__c, l.Vehicle_Price__c, l.Vehicle_Build_Year__c, l.UnbounceSubmissionTime__c, l.UnbounceSubmissionDate__c, l.UnbouncePageVariant__c, l.UnbouncePageID__c, l.Transaction__c, l.Transaction_Type__c, l.Total_Calls__c, l.Too_Many_Credit_Enquiries__c, l.Title, l.SystemModstamp, l.Super_Balance__c, l.Sugar_Lead_Source__c, l.Sugar_Date_Created__c, l.SubmitterIP__c, l.Street, l.Status, l.StateCode, l.State, l.Source__c, l.Send_Property_Report__c, l.Salutation, l.Remove_from_Callfile__c, l.RecordTypeId, l.Pre_Sales_Notes__c, l.PostalCode, l.PhotoUrl, l.Phone, l.Partner_Super_Balance__c, l.Partner_Annual_Income__c, l.Paid_or_Unpaid_Defaults__c, l.OwnerId, l.Number_of_Children__c, l.NumberOfEmployees, l.No_Credit_History__c, l.Name, l.Modified_in_last_4_Hours__c, l.Model__c, l.MobilePhone, l.MasterRecordId, l.Marital_Status__c, l.Make__c, l.MC4SF__MC_Subscriber__c, l.Longitude, l.Loan_Value__c, l.Loan_Deposit__c, l.Lead_Type__c, l.LeadSource, l.Latitude, l.Last_Refinance__c, l.Last_Pardot_Form_Handler__c, l.LastViewedDate, l.LastReferencedDate, l.LastName, l.LastModifiedDate, l.LastModifiedById, l.LastActivityDate, l.Landing_Page__c, l.Job_Title__c, l.JigsawContactId, l.Is_Updated__c, l.IsUnreadByOwner, l.IsDeleted, l.IsConverted, l.Internal_Referrer_Name__c, l.Industry, l.In_Line_Status_Update__c, l.Id, l.Housing_Status__c, l.HasOptedOutOfEmail, l.Gender__c, l.Fixed_Rate_Expiry__c, l.FirstName, l.Est_Location__c, l.Employment_Status__c, l.Employment_Start_Date__c, l.Employer_Name__c, l.EmailBouncedReason, l.EmailBouncedDate, l.Email, l.DoNotCall, l.Discharged_from_Part_9_or_Bankruptcy__c, l.Description, l.DNCR_Washing_Transaction_ID__c, l.DNCR_Wash_Expiry__c, l.DNCR_Wash_Date__c, l.DNCR_Outcome__c, l.Current_Property_Value__c, l.Current_Loan_Value__c, l.Current_Loan_Type__c, l.Current_Lender__c, l.Current_Interest_Rate__c, l.Current_Interest_Rate_Type__c, l.Current_Financials_Up_to_Date__c, l.Credit_History__c, l.Credit_Guide_Quote_Privacy__c, l.CreatedDate, l.CreatedById, l.CountryCode, l.Country, l.ConvertedOpportunityId, l.ConvertedDate, l.ConvertedContactId, l.ConvertedAccountId, l.Company, l.City, l.Calls_Last_Disposition__c, l.Birthday__c, l.Annual_Income__c, l.Amount__c, l.Age_of_Current_Loan__c, l.Affiliate_campaign__c, l.Address From Lead l where l.Id In :Trigger.newMap.keySet()]) {
	//	LeadToCallFileUtilities.selectRightCallFileForLead(lead);
	//}
	List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveLeadToCallFileRules();
	Map<Id, Datetime> getPardotLastActivityFromOld = new Map<Id, Datetime>();
	Map<Id, String> oldLastPardotFormHandler = new Map<Id, String>();
	for (Lead lead : trigger.new ) {
		LeadToCallFileUtilities.selectRightCallFileForLead(lead, rules);
		Utilities.updateTimezoneOnLead(lead);
	}
	if (Trigger.isUpdate) {
		Set<Id> leadIds = new Set<Id>();
		for (Lead lead : trigger.old) {
			if(lead.Is_Update_Activity__c != null && lead.Is_Update_Activity__c) {
				leadIds.add(lead.Id);
			}
			getPardotLastActivityFromOld.put(lead.Id, lead.pi__last_activity__c);
			oldLastPardotFormHandler.put(lead.Id, lead.Last_Pardot_Form_Handler__c);
		}
		for (Lead lead : trigger.new) {
			if (!leadIds.contains(lead.Id) && lead.Email != null && lead.Email != '') {
				//compare the last pardot activity time
				if (getPardotLastActivityFromOld.get(lead.Id) != null &&
				lead.pi__last_activity__c > getPardotLastActivityFromOld.get(lead.Id)) {
					lead.Is_Update_Activity__c = true;
				}
			}
			//System.debug(oldLastPardotFormHandler.get(lead.Id) + '  -  ' + lead.Last_Pardot_Form_Handler__c);
			if (oldLastPardotFormHandler.get(lead.Id) != null && oldLastPardotFormHandler.get(lead.Id) != lead.Last_Pardot_Form_Handler__c) {
				lead.Last_Pardot_Form_Handler_Change_Time__c = System.now();
			}
		}
	}
	if (Trigger.isInsert) {
		for (Lead lead : trigger.new) {
			lead.Last_Pardot_Form_Handler_Change_Time__c = System.now();
			if (lead.Email != null && lead.Email != '') {
				lead.Is_Update_Activity__c = true;
			}
		}
	}
}