/*====================================================
				Click Loans
========================================================*/
trigger TriggerOnRequiredDocument on Required_Document__c (after insert, after update) 
{
	acfTriggerOnRequiredDocumnetHandler objRequiredDocument = new acfTriggerOnRequiredDocumnetHandler();
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
		{
			objRequiredDocument.OnAfterInsert(trigger.new,trigger.oldMap);
		}
		if(trigger.isUpdate)
		{
			 objRequiredDocument.onAfterUpdate(trigger.new,trigger.oldMap);
		} 
	}
}