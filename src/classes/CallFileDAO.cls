public class CallFileDAO {
	public static List<vhc__Campaign__c> getAllCallFiles() {
		List<vhc__Campaign__c> callFiles = [Select Id, Name, vhc__Batch_Id__c, vhc__Country_Number_Format__c, vhc__National_Number_Format__c, vhc__Outgoing_Campaign__c, vhc__Total_Contacts__c, vhc__Total_To_Create__c, vhc__Total_To_Delete__c, vhc__Total_To_Update__c from vhc__Campaign__c];
		return callFiles;
	}
}