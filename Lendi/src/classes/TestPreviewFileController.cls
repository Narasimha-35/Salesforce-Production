@isTest
private class TestPreviewFileController {
	public static Opportunity testOppo1;
	public static Required_Document__c reqDocs;
	public static Attachment attachment1;
	public static Attachment attachment2;

	static {
		Account account = new Account();
		account.LastName = 'testLastName';
		account.PersonEmail = 'test@mailinator.com';
		account.PersonMobilePhone = '+61428938900';
		account.Employment_Status__pc = 'Full Time';
		account.Marital_Status__pc = 'Single';
		account.Housing_Status__pc = 'Mortgage';
		account.Number_of_Children__pc = '2';
		account.Annual_Income__pc = 100000;
		account.Super_Balance__pc = 1;
		account.Partner_Annual_Income__pc = 0;
		account.Partner_Super_Balance__pc = 0;
		insert account;
		
	 	testOppo1 = new Opportunity();
	 	testOppo1.Name = 'test 1';
	 	testOppo1.AccountId = account.Id;
	 	testOppo1.CloseDate = Date.today().addDays(1);
	 	testOppo1.StageName = 'Appointed';
	 	testOppo1.Transaction_Type__c = 'Refinance';
	 	testOppo1.Current_Lender__c = 'AMP';
	 	testOppo1.Current_Loan_Value__c = 40000;
	 	testOppo1.Current_Loan_Type__c = 'Commercial';
	 	testOppo1.Personal_Loan_Balance__c = 300;
	 	testOppo1.Credit_Card_Balance__c = 3;
	 	testOppo1.Car_Loan_Balance__c = 400;
	 	RecordType recType = [Select Id, Name From RecordType  Where SobjectType = 'Opportunity' and Name = 'Home Opportunity'];
	 	testOppo1.RecordTypeId = recType.Id;
	 	insert testOppo1;

	 	//create require doc
	 	reqDocs = new Required_Document__c();
	 	reqDocs.Name = 'test doc';
	 	reqDocs.acfOpportunity__c = testOppo1.Id;
	 	insert reqDocs;
	 	//create attachment linked with require doc and oppo
	 	String encodedContentsString = 'get test done';
	 	attachment1 = new Attachment();
		attachment1.Body = Blob.valueOf(encodedContentsString);
		attachment1.Name = String.valueOf('test1.txt');
		attachment1.ParentId = reqDocs.Id; 
		insert attachment1;

		attachment2 = new Attachment();
		attachment2.Body = Blob.valueOf(encodedContentsString);
		attachment2.Name = String.valueOf('test2.txt');
		attachment2.ParentId = testOppo1.Id; 
		insert attachment2;
	}

	@isTest static void getAllAttachmentFromOpportunityTest() {
		Test.startTest();
		System.debug('testOppoId' + testOppo1.Id);
		System.debug('reqDocs ' + reqDocs.Id + reqDocs.acfOpportunity__c);
		System.currentPageReference().getParameters().put('id', testOppo1.Id);
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(testOppo1);
        PreviewFileController stdController = new PreviewFileController(controller);
        System.assert(stdController != null);
        PreviewFileController.getAllAttachmentFromOpportunity();
        System.debug(PreviewFileController.attachInfos.size());
        Test.stopTest();
	}
	
}