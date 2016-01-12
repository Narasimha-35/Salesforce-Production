global without sharing class BatchLeadDNCRWash implements Database.Batchable<sObject>, Database.AllowsCallouts {
	global BatchLeadDNCRWash() {}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = DNCWashUtilities.constructDynamicSoqlForDNCR(DNCWashUtilities.QUERY_TYPE_FIELD);
		//Construct dynamic soql
		//exclude all the converted leads
		//soql escape special charactor
		//Use DNCR Wash Date as stop point
		//limit 10 per batch
		String queryEnd = ' And DoNotCall != true And (NOT Status like \'%Closed Lost%\' ) And ConvertedDate = null And DNCR_Wash_Date__c != Today limit 10';
		String finalQuery = query + queryEnd;
		System.debug(finalQuery);
		return Database.getQueryLocator(finalQuery);
	}
	
	global void execute(Database.BatchableContext BC, List<Lead> leads) {
		//for each lead, get phone and mobile
		//pass in as string list and check if it is success full
		for (Lead lead : leads) {
			System.debug(lead.Id);
			if (lead.Phone == null && lead.MobilePhone == null) {
				//continue;
				lead.DNCR_Wash_Date__c = Date.today();
			} else if (lead.Phone != null && lead.MobilePhone == null) {
				List<String> phoneList = new List<String>();
				phoneList.add(lead.Phone);
				DNCWashUtilities.washPhoneNumbers(lead.Phone.replace('+61', '0'), lead);
			} else if (lead.Phone == null && lead.MobilePhone != null) {
				List<String> phoneList = new List<String>();
				phoneList.add(lead.MobilePhone);
				DNCWashUtilities.washPhoneNumbers(lead.MobilePhone.replace('+61', '0'), lead);
			} else if (lead.Phone != null && lead.MobilePhone != null) {
				List<String> phoneList = new List<String>();
				phoneList.add(lead.MobilePhone);
				phoneList.add(lead.Phone);
				DNCWashUtilities.washPhoneNumbers(lead.Phone.replace('+61', '0'), lead);
			}
		}
		//Check if add to call file
		List<DNC_Call_File_Setup__c> callFileSetups = [Select Id, Name, Call_File__c, Update_Call_File_With_Lead__c From DNC_Call_File_Setup__c];
		if (callFileSetups.size() == 1) {
			if (callFileSetups.get(0).Update_Call_File_With_Lead__c && callFileSetups.get(0).Call_File__c != null) {
				for (Lead lead : leads) {
					if (lead.DNCR_Outcome__c != null && lead.DNCR_Outcome__c == 'N') {
						lead.vhc__CallFile__c = callFileSetups.get(0).Call_File__c;
						lead.Is_Updated__c = true;
					}
				}
			}
		}
		update leads;
	}
	
	global void finish(Database.BatchableContext BC) { 
		//check still have or not;
		String query = DNCWashUtilities.constructDynamicSoqlForDNCR(DNCWashUtilities.QUERY_TYPE_COUNT);
		String queryEnd = ' And DoNotCall != true And (NOT Status like \'%Closed Lost%\' ) And ConvertedDate = null And DNCR_Wash_Date__c != Today limit 10';
		//if have, trigger again
		Integer countAmount = Database.countQuery(query + queryEnd);
		System.debug('countAmount ' + countAmount);
		if (countAmount > 0) {
			//Call batch again
			if (!Test.isRunningTest()) {
				BatchLeadDNCRWash job = new BatchLeadDNCRWash();
				database.executebatch(job, 10);
			}
		}
	}
}