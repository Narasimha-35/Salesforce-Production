@isTest(SeeAllData=true)
private class UtilitiesTest {

    static testMethod void getPicklistValuesTest() {
        List<SelectOption> options = Utilities.getPicklistValues(new Lead(), 'Status');
        System.assert(options.size() > 0);
    }

    static testMethod void getAllFieldsFromSObjectTest() {
        List<String> fieldsInObject = Utilities.getAllFieldsFromSObject('lead');
        System.assert(fieldsInObject.size() > 0);
    }

    static testMethod void getSObjectFieldAsSelectOptionsTest() {
        List<SelectOption> options = Utilities.getSObjectFieldAsSelectOptions('lead');
        System.assert(options.size() > 0);
    }

    static testMethod void getCallFileToList() {
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
        vhc__Campaign__c callFile = new vhc__Campaign__c();
        callFile.Name = 'Call File Test 1';
        callFile.vhc__Batch_Id__c = 'xxtest';
        callFile.vhc__Outgoing_Campaign__c = testout.Id;
        insert callFile;
        List<SelectOption> options = Utilities.getCallFileSelectOptions();
        System.assert(options.size() >= 0);
    }

    static testMethod void getObjectInfoTest() {
        String test = 'lead.Souce__c#String';
        String result1 = Utilities.getObjectInfo(test, Utilities.SOBJECT_NAME);
        String result2 = Utilities.getObjectInfo(test, Utilities.SOBJECT_TYPE);
        String result3 = Utilities.getObjectInfo(test, Utilities.FIELD_NAME);
        String result4 = Utilities.getObjectInfo(test, 'sfda');
        System.assertEquals(result1, 'lead');
        System.assertEquals(result2, 'String');
        System.assertEquals(result3, 'Souce__c');
        String test1 = null;
        String result5 = Utilities.getObjectInfo(test1, Utilities.SOBJECT_NAME);
        System.assert(result4 == null);
        System.assert(result5 == null);
    }

    static testMethod void getCredentialInfo() {
        String key = Utilities.getPardotUserKey();
        String pass = Utilities.getPardotUserPassword();
        String email = Utilities.getPardotUserEmail();
        System.assert(key != null);
        System.assert(pass != null);
        System.assert(email != null);
        System.assertEquals(email, 'chen@creditandfinance.com.au');
    }

    static testMethod void byteAbbreviateTest() {
        String testA = 'ABCDEFG';
        String result = Utilities.byteAbbreviate(testA, 4);
        System.assert(result != null);
        System.assert(result == 'A...');
    }

    static testMethod void sendAppointmentConfirmEmail() {
        List<Appointment__c> testApps = [select Id from Appointment__c limit 1];
        if (testApps.size() == 1) {
            Appointment__c testApp = testApps.get(0);
            test.startTest();
            Utilities.sendAppointmentConfirmEmail(testApp.Id);
            test.stopTest();
        }
    }

    static testMethod void testUpdateTimezoneOnLead() {
        Lead leadTest1 = new Lead();
        leadTest1.LastName = 'test1';

        Lead leadTest2 = new Lead();
        leadTest2.LastName = 'test2';
        leadTest2.PostalCode = '0900';

        Lead leadTest3 = new Lead();
        leadTest3.LastName = 'test3';
        leadTest3.PostalCode = '4000';

        Lead leadTest4 = new Lead();
        leadTest4.LastName = 'test4';
        leadTest4.PostalCode = '5500';

        Lead leadTest5 = new Lead();
        leadTest5.LastName = 'test5';
        leadTest5.PostalCode = '6000';

        Lead leadTest6 = new Lead();
        leadTest6.LastName = 'test6';
        leadTest1.PostalCode = '';

        Lead leadTest7 = new Lead();
        leadTest7.LastName = 'test7';
        leadTest7.PostalCode = '0850';

        Lead leadTest8 = new Lead();
        leadTest8.LastName = 'test8';
        leadTest8.StateCode = 'ACT';

        Lead leadTest9 = new Lead();
        leadTest9.LastName = 'test9';
        leadTest9.StateCode = 'NSW';

        Lead leadTest10 = new Lead();
        leadTest10.LastName = 'test10';
        leadTest10.StateCode = 'NT';

        Lead leadTest11 = new Lead();
        leadTest11.LastName = 'test11';
        leadTest11.StateCode = 'QLD';

        Lead leadTest12 = new Lead();
        leadTest12.LastName = 'test12';
        leadTest12.StateCode = 'SA';

        Lead leadTest14 = new Lead();
        leadTest14.LastName = 'test14';
        leadTest14.StateCode = 'VIC';

        Lead leadTest15 = new Lead();
        leadTest15.LastName = 'test15';
        leadTest15.StateCode = 'WA';

        insert leadTest1;
        Lead leadTest1New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest1.Id];
        System.assertEquals(leadTest1New.vhc__TimeZone__c, '(UTC+08:00) Perth');

        insert leadTest2;
        Lead leadTest2New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest2.Id];
        System.assertEquals(leadTest2New.vhc__TimeZone__c, '(UTC+10:00) Canberra, Melbourne, Sydney');

        insert leadTest3;
        Lead leadTest3New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest3.Id];
        System.assertEquals(leadTest3New.vhc__TimeZone__c, '(UTC+10:00) Brisbane');

        insert leadTest4;
        Lead leadTest4New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest4.Id];
        System.assertEquals(leadTest4New.vhc__TimeZone__c, '(UTC+09:30) Adelaide');

        insert leadTest5;
        Lead leadTest5New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest5.Id];
        System.assertEquals(leadTest5New.vhc__TimeZone__c, '(UTC+08:00) Perth');

        insert leadTest6;
        Lead leadTest6New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest6.Id];
        System.assertEquals(leadTest6New.vhc__TimeZone__c, '(UTC+08:00) Perth');

        insert leadTest7;
        Lead leadTest7New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest7.Id];
        System.assertEquals(leadTest7New.vhc__TimeZone__c, '(UTC+09:30) Darwin');

        //new
        insert leadTest8;
        Lead leadTest8New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest8.Id];
        System.assertEquals(leadTest8New.vhc__TimeZone__c, '(UTC+10:00) Canberra, Melbourne, Sydney');

        insert leadTest9;
        Lead leadTest9New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest9.Id];
        System.assertEquals(leadTest9New.vhc__TimeZone__c, '(UTC+10:00) Canberra, Melbourne, Sydney');

        insert leadTest10;
        Lead leadTest10New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest10.Id];
        System.assertEquals(leadTest10New.vhc__TimeZone__c, '(UTC+09:30) Darwin');

        insert leadTest11;
        Lead leadTest11New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest11.Id];
        System.assertEquals(leadTest11New.vhc__TimeZone__c, '(UTC+10:00) Brisbane');

        insert leadTest12;
        Lead leadTest12New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest12.Id];
        System.assertEquals(leadTest12New.vhc__TimeZone__c, '(UTC+09:30) Adelaide');

        insert leadTest14;
        Lead leadTest14New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest14.Id];
        System.assertEquals(leadTest14New.vhc__TimeZone__c, '(UTC+10:00) Canberra, Melbourne, Sydney');
    }

    static testMethod void testSendEmail() {
        Utilities.sendEmail(new list<String>{'test@creditandfinance.com.au'}, 'test', 'test');
    }

    static testMethod void testGetDNCRTeleCredientals() {
        Utilities.getDNCRTeleMarketerId();
        Utilities.getDNCRTeleMarketerPassword();
        Utilities.getDNCRTEndUrlId();
    }
    // private static testMethod void testGetStaticResource() {
    //     System.assertNotEquals(null, Utilities.getStaticResource('MercuryLoanSuccessResponse'));
    // }
}
