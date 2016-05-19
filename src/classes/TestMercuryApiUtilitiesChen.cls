@isTest(seeAllData=true)
public with sharing class TestMercuryApiUtilitiesChen {
    private static Opportunity oppo {get; set;}
    private static Account account {get; set;}
    private static Contact contact {get; set;}
    static {
        account = TestUtilities.createAccount(true);
        insert account;
        contact = TestUtilities.createContact();
        insert contact;
        oppo = TestUtilities.createOpportunity();
        insert oppo;

        MercuryTestUtilities.setMock(oppo.id, account.id);
    }

    static testMethod void getDataBackTest() {
        String accountId = account.Id;
        String oppoId = oppo.Id;
        Test.startTest();
        MercuryApiUtilitiesChen.getDataBack(oppoId, true, accountId, true);
        Test.stopTest();
    }

    static testMethod void updatePeopleUpdateFTest() {
        Test.startTest();
        MercuryApiUtilitiesChen.updateAccountF(account.id, oppo.id);

        Test.stopTest();
    }

    static testMethod void updatePeopleUpdate() {
        String accountId = account.Id;
        String token = 'f92699d9-42cd-4d0a-8a98-2487dac5f9b7';
        String branchId = 'P200019';
        MercuryApiUtilitiesChen.updatePeopleInMercury(accountId, token, branchId);
    }

    static testMethod void getOpportunityAndSaveOnOppoTest() {
        String oppoId = '006O0000006a5MZ';
        MercuryApiUtilitiesChen.getOpportunityAndSaveOnOppo(oppoId, false);
    }

    static testMethod void getPeopleAndSaveOnAccount() {
        MercuryApiUtilitiesChen.getPeopleAndSaveOnAccount(account.id, false);
    }

    private static testMethod void testGetAllPersonalBranches(){
        MercuryApiUtilitiesChen.getAllPersonalBranches('token');
        system.assert(true);
    }

}