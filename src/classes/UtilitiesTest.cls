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
    static testMethod void testUpdateTimezoneOnLead1a() {
        Lead leadTest1 = new Lead();
        leadTest1.LastName = 'test1';
        insert leadTest1;
        Utilities.updateTimezoneOnLead(leadTest1);
        Lead leadTest1New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest1.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1b() {
        Lead leadTest2 = new Lead();
        leadTest2.LastName = 'test2';
        leadTest2.PostalCode = '0900';
        insert leadTest2;
        Utilities.updateTimezoneOnLead(leadTest2);
        Lead leadTest2New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest2.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1c() {
        Lead leadTest3 = new Lead();
        leadTest3.LastName = 'test3';
        leadTest3.PostalCode = '4000';
        insert leadTest3;
        Utilities.updateTimezoneOnLead(leadTest3);
        Lead leadTest3New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest3.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1d() {
        Lead leadTest4 = new Lead();
        leadTest4.LastName = 'test4';
        leadTest4.PostalCode = '5500';
        insert leadTest4;
        Utilities.updateTimezoneOnLead(leadTest4);
        Lead leadTest4New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest4.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1e() {
        Lead leadTest5 = new Lead();
        leadTest5.LastName = 'test5';
        leadTest5.PostalCode = '6000';
        insert leadTest5;
        Utilities.updateTimezoneOnLead(leadTest5);
        Lead leadTest5New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest5.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1f() 
    {
        Lead leadTest6 = new Lead();
        leadTest6.LastName = 'test6';
        leadTest6.PostalCode = '';
        insert leadTest6;
        Utilities.updateTimezoneOnLead(leadTest6);
        Lead leadTest6New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest6.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1g() 
    {
        Lead leadTest7 = new Lead();
        leadTest7.LastName = 'test7';
        leadTest7.PostalCode = '0850';
        insert leadTest7;
        Utilities.updateTimezoneOnLead(leadTest7);
        Lead leadTest7New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest7.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1h() 
    {
        Lead leadTest8 = new Lead();
        leadTest8.LastName = 'test8';
        leadTest8.StateCode = 'ACT';
        insert leadTest8;
        Utilities.updateTimezoneOnLead(leadTest8);
        Lead leadTest8New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest8.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1i() 
    {
        Lead leadTest9 = new Lead();
        leadTest9.LastName = 'test9';
        leadTest9.StateCode = 'NSW';
        insert leadTest9;
        Utilities.updateTimezoneOnLead(leadTest9);
        Lead leadTest9New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest9.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1j() 
    {
        Lead leadTest10 = new Lead();
        leadTest10.LastName = 'test10';
        leadTest10.StateCode = 'NT';
        insert leadTest10;
        Utilities.updateTimezoneOnLead(leadTest10);
        Lead leadTest10New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest10.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1K() 
    {
        Lead leadTest11 = new Lead();
        leadTest11.LastName = 'test11';
        leadTest11.StateCode = 'QLD';
        insert leadTest11;
        Utilities.updateTimezoneOnLead(leadTest11);
        Lead leadTest11New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest11.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1l() 
    {
        Lead leadTest12 = new Lead();
        leadTest12.LastName = 'test12';
        leadTest12.StateCode = 'SA';
        insert leadTest12;
        Utilities.updateTimezoneOnLead(leadTest12);
        Lead leadTest12New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest12.Id];
    }
    
    static testMethod void testUpdateTimezoneOnLead1m() 
    {
        Lead leadTest14 = new Lead();
        leadTest14.LastName = 'test14';
        leadTest14.StateCode = 'VIC';
        insert leadTest14;
        Utilities.updateTimezoneOnLead(leadTest14);
        Lead leadTest14New = [SELECT Id, vhc__TimeZone__c From Lead Where Id =: leadTest14.Id]; 
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

    private static testMethod void testCastId() {
        Account a = testUtilities.createAccount();
        insert a;
        System.assertEquals(a.id, Utilities.castId(a.id));
        System.assertEquals(null, Utilities.castId('abc'));
    }

    private static testMethod void testIsBussy() {
        Datetime now = Datetime.now();

        Saasfocus_EventClass e = new Saasfocus_EventClass();
        e.StartDateTime = String.valueOf(now);
        e.EndDateTime = String.valueOf(now.addDays(1));

        Datetime st = now.addMinutes(1);
        Datetime ed = st.addDays(1);
        System.assertEquals(true, Utilities.isBussy(st, ed, e));

        st = now.addMinutes(-2);
        System.assertEquals(true, Utilities.isBussy(st, ed, e));

        ed = ed.addMinutes(-2);
        System.assertEquals(true, Utilities.isBussy(st, ed, e));

        st = now.addMinutes(-10);
        ed = now.addMinutes(-9);
        System.debug(String.valueofGmt(st));
        System.debug(String.valueofGmt(ed));
        System.debug(e.startdatetime);
        System.debug(e.enddatetime);
        System.assertEquals(false, Utilities.isBussy(st, ed, e));

        st = now.addDays(1).addMinutes(8);
        ed = now.addDays(1).addMinutes(10);
        System.assertEquals(false, Utilities.isBussy(st, ed, e));
    }

    private static testMethod void testIncreaseDuplicateCounter() {
        String name1 = 'test.txt';
        String name2 = 'test (1).txt';

        String ret1 = Utilities.increaseDuplicateCounter(name1);
        String ret2 = Utilities.increaseDuplicateCounter(name2);

        System.assertEquals('test (1).txt', ret1);
        System.assertEquals('test (2).txt', ret2);
    }

    private static testMethod void testConstructPageRef() {
        System.assertNotEquals('', Utilities.constructPageRef('Account', new Map<String, String>{'id' => 'aaaa'}).getURL());
    }

    private static testMethod void testGenerateRandomString() {
        Integer num = 10;
        System.assertEquals(num, ((String) Utilities.generateRandomString(num)).length());
    }
    
    private static testMethod void testNewGuid() 
    {
        Utilities.NewGuid();
        Utilities.getGMTTime(system.now());
        Utilities.getCurrentMonthStartTime();
        Datetime myDateTime = Datetime.newInstance(2016, 2, 17);
        Datetime startDateTime = myDateTime.addDays(2);
        Datetime endDateTime = myDateTime.addDays(7);

        List<Saasfocus_EventClass> lstEventClass = new List<Saasfocus_EventClass>();
        Saasfocus_EventClass obj = new Saasfocus_EventClass();
        obj.Email = 'ankit@gmail.com';
        obj.StartDateTime = string.valueof(startDateTime);
        obj.EndDateTime = string.valueof(endDateTime);
        lstEventClass.add(obj);
        
        Utilities.isBussy(startDateTime,endDateTime,lstEventClass);
        Map<String, Schema.DisplayType> maps = new Map<String, Schema.DisplayType>();
        maps.put('Name',Schema.DisplayType.Date);
        Utilities.parseValue(maps,'Name','Account');
        maps.clear();
        maps.put('Name',Schema.DisplayType.DateTime);
        Utilities.parseValue(maps,'Name','Account');
    }
}