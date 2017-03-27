@isTest(SeeAllData=true)
private class CallFileDAOTest {

    static testMethod void getAllCallFilesTest() {
    	List<vhc__Campaign__c> callFiles = CallFileDAO.getAllCallFiles();
    	Integer size1 = callFiles.size();
    	vhc__Campaign__c callFile = new vhc__Campaign__c();
    	vhc__Customer__c testcompany = new vhc__Customer__c();
    	testcompany.Name = 'acf';
    	testcompany.vhc__DefaultPhoneNumber__c = '+61422504992';
    	testcompany.vhc__Manager_email__c = 'test@test.com';
    	testcompany.vhc__Manager_name__c = 'test test';
    	testcompany.vhc__ForcePhoneDisplay__c = 'The Real Phone Number';
    	insert testcompany;
    	vhc__Outgoing_Campaign__c testout = new vhc__Outgoing_Campaign__c();
    	testout.Name = 'TEST';
    	testout.vhc__Language__c = 'en';
    	testout.vhc__outMode__c = 'Progressive';
    	testout.vhc__PhoneDisplay__c = 'The Real Phone Number';
    	testout.vhc__Customer__c = testcompany.Id;
    	insert testout;
    	callFile.Name = 'Call File New';
    	callFile.vhc__Batch_Id__c = 'test';
    	callFile.vhc__Outgoing_Campaign__c = testout.Id;
    	insert callFile;
    	List<vhc__Campaign__c> callFiles2 = CallFileDAO.getAllCallFiles();
    	Integer size2 = callFiles2.size();
    	System.assertEquals(size2, size1 + 1);
    }
}