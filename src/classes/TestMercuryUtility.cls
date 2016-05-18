@isTest
public with sharing class TestMercuryUtility {
    //Loan People
    // [
    //   {
    //     "uniqueId": "e2db00ee-c583-11e5-9595-00155d006737",
    //     "relationship": "Primary Applicant",
    //     "personID": "D6326846-939D-F4C9-4B1D-14710291DE49",
    //     "loanID": "B1C70990-BB7B-1353-FDF7-86CF1E469F64",
    //     "email": "billybyrne1@hotmail.com"
    //   },
    //   {
    //     "uniqueId": "e2710778-c583-11e5-9595-00155d006737",
    //     "relationship": "Applicant",
    //     "personID": "36E8562C-2310-0AF5-FDD9-147811ABEAE7",
    //     "loanID": "B1C70990-BB7B-1353-FDF7-86CF1E469F64",
    //     "email": "alexandriamayer@hotmail.com"
    //   }
    // ]

    //People
    // [
    //   {
    //     "webPassword": "",
    //     "webAccess": false,
    //     "uniqueId": "D6326846-939D-F4C9-4B1D-14710291DE49",
    //     "trustName": null,
    //     "title": "Mr",
    //     "salutationOrFirstName": "Billy",
    //     "salutation": "Billy",
    //     "relationshipManagerName": "",
    //     "relationshipManager": "",
    //     "phoneDisplayType4": "Business Fax",
    //     "phoneDisplayType3": "Business",
    //     "phoneDisplayType2": "Mobile",
    //     "phoneDisplayType1": "Home",
    //     "personDataType": "Full",
    //     "partnerName": "Australian Credit and Finance",
    //     "occupation": "Pipe Layer",
    //     "numberOfDependents": 1,
    //     "notes": "<html>\\n <head></head>\\n <body></body>\\n</html>",
    //     "mobile": "0419 878 619",
    //     "middleName": "",
    //     "markAsPrivate": false,
    //     "maritalStatus": "DeFacto",
    //     "lastName": "Byrne",
    //     "jobTitle": "Pipe Layer",
    //     "isNew": null,
    //     "isDeleted": false,
    //     "importDocumentId": "",
    //     "homeSuburb": null,
    //     "homePhone": "0243325087",
    //     "gender": "M",
    //     "funambolUsers": null,
    //     "fullName": "Billy Byrne",
    //     "firstName": "Billy",
    //     "employmentStatus": "Full Time",
    //     "employmentCommenced": "2015-01-12",
    //     "employer": "Robsons Civil Projects ",
    //     "emailBounced": false,
    //     "email": "billybyrne1@hotmail.com",
    //     "driversLicenceState": "NSW",
    //     "driversLicenceNumber": "14292695",
    //     "driversLicenceExpiry": "2016-04-16",
    //     "doNotMail": false,
    //     "deletedOn": null,
    //     "deletedBy": null,
    //     "dateOfBirth": "503607600000",
    //     "createdOn": null,
    //     "createdBy": "CA47016",
    //     "contactType": null,
    //     "contactMethods": [
    //       {
    //         "personID": "D6326846-939D-F4C9-4B1D-14710291DE49",
    //         "content": "0243325087",
    //         "contactMethod": "Home"
    //       },
    //       {
    //         "personID": "D6326846-939D-F4C9-4B1D-14710291DE49",
    //         "content": "0419878619",
    //         "contactMethod": "Mobile"
    //       },
    //       {
    //         "personID": "D6326846-939D-F4C9-4B1D-14710291DE49",
    //         "content": "",
    //         "contactMethod": "Business"
    //       },
    //       {
    //         "personID": "D6326846-939D-F4C9-4B1D-14710291DE49",
    //         "content": "",
    //         "contactMethod": "Business Fax"
    //       },
    //       {
    //         "personID": "D6326846-939D-F4C9-4B1D-14710291DE49",
    //         "content": "billybyrne1@hotmail.com",
    //         "contactMethod": "Email 1"
    //       }
    //     ],
    //     "company": "P200019",
    //     "businessPhone": "",
    //     "annualSalary": 78566.0,
    //     "addressDisplay": "Home",
    //     "acn": null,
    //     "abn": null
    //   },
    //   {
    //     "webPassword": "",
    //     "webAccess": false,
    //     "uniqueId": "36E8562C-2310-0AF5-FDD9-147811ABEAE7",
    //     "trustName": null,
    //     "title": "Ms",
    //     "salutationOrFirstName": "Alexandria",
    //     "salutation": "",
    //     "relationshipManagerName": "",
    //     "relationshipManager": "",
    //     "phoneDisplayType4": "Business Fax",
    //     "phoneDisplayType3": "Business",
    //     "phoneDisplayType2": "Mobile",
    //     "phoneDisplayType1": "Home",
    //     "personDataType": "Full",
    //     "partnerName": "Australian Credit and Finance",
    //     "occupation": "Carer",
    //     "numberOfDependents": 0,
    //     "notes": "<html>\\n <head></head>\\n <body></body>\\n</html>",
    //     "mobile": "0413171511",
    //     "middleName": "",
    //     "markAsPrivate": false,
    //     "maritalStatus": "DeFacto",
    //     "lastName": "Mayer",
    //     "jobTitle": "Carer",
    //     "isNew": null,
    //     "isDeleted": false,
    //     "importDocumentId": "",
    //     "homeSuburb": null,
    //     "homePhone": "0243325087",
    //     "gender": "F",
    //     "funambolUsers": null,
    //     "fullName": "Alexandria Mayer",
    //     "firstName": "Alexandria",
    //     "employmentStatus": "Part Time",
    //     "employmentCommenced": "2013-06-10",
    //     "employer": "Hammond Care",
    //     "emailBounced": false,
    //     "email": "alexandriamayer@hotmail.com",
    //     "driversLicenceState": "NSW",
    //     "driversLicenceNumber": "15190186",
    //     "driversLicenceExpiry": "2017-01-25",
    //     "doNotMail": false,
    //     "deletedOn": null,
    //     "deletedBy": null,
    //     "dateOfBirth": "605732400000",
    //     "createdOn": null,
    //     "createdBy": "CA47016",
    //     "contactType": null,
    //     "contactMethods": [
    //       {
    //         "personID": "36E8562C-2310-0AF5-FDD9-147811ABEAE7",
    //         "content": "0243325087",
    //         "contactMethod": "Home"
    //       },
    //       {
    //         "personID": "36E8562C-2310-0AF5-FDD9-147811ABEAE7",
    //         "content": "0413171511",
    //         "contactMethod": "Mobile"
    //       },
    //       {
    //         "personID": "36E8562C-2310-0AF5-FDD9-147811ABEAE7",
    //         "content": "",
    //         "contactMethod": "Business"
    //       },
    //       {
    //         "personID": "36E8562C-2310-0AF5-FDD9-147811ABEAE7",
    //         "content": "",
    //         "contactMethod": "Business Fax"
    //       },
    //       {
    //         "personID": "36E8562C-2310-0AF5-FDD9-147811ABEAE7",
    //         "content": "alexandriamayer@hotmail.com",
    //         "contactMethod": "Email 1"
    //       }
    //     ],
    //     "company": "P200019",
    //     "businessPhone": "",
    //     "annualSalary": 30036.0,
    //     "addressDisplay": "Home",
    //     "acn": null,
    //     "abn": null
    //   }
    // ]
    public static final String testLoanPeopleString = '[{"uniqueId":"e2db00ee-c583-11e5-9595-00155d006737","relationship":"Primary Applicant","personID":"D6326846-939D-F4C9-4B1D-14710291DE49","loanID":"B1C70990-BB7B-1353-FDF7-86CF1E469F64","email":"billybyrne1@hotmail.com"},{"uniqueId":"e2710778-c583-11e5-9595-00155d006737","relationship":"Applicant","personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","loanID":"B1C70990-BB7B-1353-FDF7-86CF1E469F64","email":"alexandriamayer@hotmail.com"}]';
    public static final String testPeopleString = '[{"webPassword":"","webAccess":false,"uniqueId":"D6326846-939D-F4C9-4B1D-14710291DE49","trustName":null,"title":"Mr","salutationOrFirstName":"Billy","salutation":"Billy","relationshipManagerName":"","relationshipManager":"","phoneDisplayType4":"Business Fax","phoneDisplayType3":"Business","phoneDisplayType2":"Mobile","phoneDisplayType1":"Home","personDataType":"Full","partnerName":"Australian Credit and Finance","occupation":"Pipe Layer","numberOfDependents":1,"notes":"<html>\\n <head></head>\\n <body></body>\\n</html>","mobile":"0419 878 619","middleName":"","markAsPrivate":false,"maritalStatus":"DeFacto","lastName":"Byrne","jobTitle":"Pipe Layer","isNew":null,"isDeleted":false,"importDocumentId":"","homeSuburb":null,"homePhone":"0243325087","gender":"M","funambolUsers":null,"fullName":"Billy Byrne","firstName":"Billy","employmentStatus":"Full Time","employmentCommenced":"2015-01-12","employer":"Robsons Civil Projects ","emailBounced":false,"email":"billybyrne1@hotmail.com","driversLicenceState":"NSW","driversLicenceNumber":"14292695","driversLicenceExpiry":"2016-04-16","doNotMail":false,"deletedOn":null,"deletedBy":null,"dateOfBirth":"503607600000","createdOn":null,"createdBy":"CA47016","contactType":null,"contactMethods":[{"personID":"D6326846-939D-F4C9-4B1D-14710291DE49","content":"0243325087","contactMethod":"Home"},{"personID":"D6326846-939D-F4C9-4B1D-14710291DE49","content":"0419878619","contactMethod":"Mobile"},{"personID":"D6326846-939D-F4C9-4B1D-14710291DE49","content":"","contactMethod":"Business"},{"personID":"D6326846-939D-F4C9-4B1D-14710291DE49","content":"","contactMethod":"Business Fax"},{"personID":"D6326846-939D-F4C9-4B1D-14710291DE49","content":"billybyrne1@hotmail.com","contactMethod":"Email 1"}],"company":"P200019","businessPhone":"","annualSalary":78566.0,"addressDisplay":"Home","acn":null,"abn":null},{"webPassword":"","webAccess":false,"uniqueId":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","trustName":null,"title":"Ms","salutationOrFirstName":"Alexandria","salutation":"","relationshipManagerName":"","relationshipManager":"","phoneDisplayType4":"Business Fax","phoneDisplayType3":"Business","phoneDisplayType2":"Mobile","phoneDisplayType1":"Home","personDataType":"Full","partnerName":"Australian Credit and Finance","occupation":"Carer","numberOfDependents":0,"notes":"<html>\\n <head></head>\\n <body></body>\\n</html>","mobile":"0413171511","middleName":"","markAsPrivate":false,"maritalStatus":"DeFacto","lastName":"Mayer","jobTitle":"Carer","isNew":null,"isDeleted":false,"importDocumentId":"","homeSuburb":null,"homePhone":"0243325087","gender":"F","funambolUsers":null,"fullName":"Alexandria Mayer","firstName":"Alexandria","employmentStatus":"Part Time","employmentCommenced":"2013-06-10","employer":"Hammond Care","emailBounced":false,"email":"alexandriamayer@hotmail.com","driversLicenceState":"NSW","driversLicenceNumber":"15190186","driversLicenceExpiry":"2017-01-25","doNotMail":false,"deletedOn":null,"deletedBy":null,"dateOfBirth":"605732400000","createdOn":null,"createdBy":"CA47016","contactType":null,"contactMethods":[{"personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","content":"0243325087","contactMethod":"Home"},{"personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","content":"0413171511","contactMethod":"Mobile"},{"personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","content":"","contactMethod":"Business"},{"personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","content":"","contactMethod":"Business Fax"},{"personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","content":"alexandriamayer@hotmail.com","contactMethod":"Email 1"}],"company":"P200019","businessPhone":"","annualSalary":30036.0,"addressDisplay":"Home","acn":null,"abn":null}]';

    public static Mercury_Opportunity__c testMercOppo;
    public static List<MercuryModel.LoanPeople> loanPeopleList;
    public static List<MercuryModel.People> peopleList;
    static {
        testMercOppo = new Mercury_Opportunity__c();
        testMercOppo.merc_people__c = testPeopleString;
        testMercOppo.merc_loanPeople__c = testLoanPeopleString;
        testMercOppo.merc_uniqueId__c = 'Some id';

        loanPeopleList = MercuryUtility.getLoanPeopleFromMercuryOpportunity(testMercOppo);
        peopleList = MercuryUtility.getPeopleFromMercuryOpportunity(testMercOppo);
    }

    private static testMethod void testGetLoanPeople() {
        List<MercuryModel.LoanPeople> loanPeop = MercuryUtility.getLoanPeopleFromMercuryOpportunity(testMercOppo);
        System.assertEquals('e2db00ee-c583-11e5-9595-00155d006737', loanPeop[0].uniqueId);
        System.assertEquals('e2710778-c583-11e5-9595-00155d006737', loanPeop[1].uniqueId);
    }

    private static testMethod void testGetPeople() {
        List<MercuryModel.People> peop = MercuryUtility.getPeopleFromMercuryOpportunity(testMercOppo);
        System.assertEquals('D6326846-939D-F4C9-4B1D-14710291DE49', peop[0].uniqueId);
        System.assertEquals('36E8562C-2310-0AF5-FDD9-147811ABEAE7', peop[1].uniqueId);
    }

    private static testMethod void testGetPrimayApplicantId() {
        String mid = MercuryUtility.getPrimaryApplicantId(loanPeopleList);
        System.assertEquals('D6326846-939D-F4C9-4B1D-14710291DE49', mid);
    }

    private static testMethod void testGetApplicantById() {
        String paid = MercuryUtility.getApplicantById(peopleList, 'D6326846-939D-F4C9-4B1D-14710291DE49').uniqueId;
        System.assertEquals('D6326846-939D-F4C9-4B1D-14710291DE49', paid);
    }

    private static testMethod void testGetAnyApplicantHaveValue() {
        List<MercuryModel.People> testPeopleList = peopleList.clone();
        testPeopleList[0].email = null;
        String paid = MercuryUtility.getAnyApplicantHaveValue(testPeopleList, new Set<String>{'email'}).uniqueId;
        System.assertEquals('36E8562C-2310-0AF5-FDD9-147811ABEAE7', paid);
    }

    private static testMethod void testGetApplicant() {

    }

    //The chance of not picking up is (1/2)^5 = 0.00390625
    private static testMethod void testGetMostRecentAppointmentAccountWithouSynced() {
        for(Integer i = 0; i < 8; i++) {
            randomTestGetMostRecentAppointmentAccountWithouSynced();
        }
    }

    private static void randomTestGetMostRecentAppointmentAccountWithouSynced() {
        Opportunity o1 = TestUtilities.createOpportunity();
        Account a1 = TestUtilities.createAccount();
        Account a2 = TestUtilities.createAccount();

        insert a1;
        insert a2;
        Set<Opportunity> oppos = new Set<Opportunity>(TestUtilities.createOpportunities(9, o1));
        oppos.add(o1);

        Opportunity oMax = o1;
        Datetime temp = Datetime.now();
        for(Opportunity o : oppos) {
            if(Math.mod(Datetime.now().getTime(), 3) == 0) {
                o.current_Appointment_Date_Time__c = null;
            }
            else {
                o.current_Appointment_Date_Time__c = temp;
                oMax = o;
            }
            if(Math.mod(Datetime.now().getTime(), 2) == 0) o.accountId = a1.id;
            else o.accountId = a2.id;
            temp = temp.addHours(1);
        }
        insert new List<Opportunity>(oppos);

        for(Opportunity o : oppos) {
            System.debug(o.accountId + ' => ' + o.current_Appointment_Date_Time__c);
        }

        Account resAcc = MercuryUtility.getMostRecentAppointmentAccountWithouSynced(new List<Account>{a1, a2});
        System.assertEquals(oMax.accountId, resAcc.id);
    }

    private static testMethod void testRemoveMercuryOpportunityAndCreateOpportunitySuccess() {
        Account applicantAcc = TestUtilities.createAccount();
        Opportunity oppo = TestUtilities.createOpportunity();
        Mercury_Opportunity__c merc_oppo = new Mercury_Opportunity__c();
        insert merc_oppo;

        Boolean res = MercuryUtility.removeMercuryOpportunityAndCreateOpportunity(applicantAcc, oppo, merc_oppo);
        System.assertEquals(true, res);
        System.assertEquals(1, [SELECT id FROM Account].size());
        System.assertEquals(1, [SELECT id FROM Opportunity].size());
        System.assertEquals(0, [SELECT id FROM Mercury_Opportunity__c].size());
    }

    private static testMethod void testRemoveMercuryOpportunityAndCreateOpportunityFail() {
        Account applicantAcc = TestUtilities.createAccount();
        Opportunity oppo = new Opportunity();
        Mercury_Opportunity__c merc_oppo = new Mercury_Opportunity__c();
        insert merc_oppo;

        Boolean res = MercuryUtility.removeMercuryOpportunityAndCreateOpportunity(applicantAcc, oppo, merc_oppo);
        System.assertEquals(false, res);
        System.assertEquals(0, [SELECT id FROM Account].size());
        System.assertEquals(0, [SELECT id FROM Opportunity].size());
        System.assertEquals(1, [SELECT id FROM Mercury_Opportunity__c].size());
    }

    private static testMethod void testConstructOpportunityFromMercuryOpp() {
        Mercury_Opportunity__c mo = testMercOppo;
        Opportunity o = MercuryUtility.constructOpportunityFromMercuryOpp(mo);
        System.assertEquals(MercuryUtility.OPPORTUNITY_STAGE, o.stageName);
        System.assertEquals(MercuryUtility.LEAD_SOURCE, o.leadSource);
        System.assertNotEquals(null, o.merc_uniqueId__c);
        System.assertEquals(o.mercury_Loan_Id__c, o.merc_uniqueId__c);
    }

    private static testMethod void testGetApplicantAccountNoMatch() {
        Account a = MercuryUtility.getApplicantAccount(peopleList[0]);
        System.assertEquals(null, a.id); //new created Account
    }

    private static testMethod void testGetApplicantAccountOneMatch() {
        Account a = peopleList[0].convertToAccount();
        insert a;
        a = MercuryUtility.getApplicantAccount(peopleList[0]);
        System.assertNotEquals(null, a.id); //merged Account
        System.assertNotEquals(null, a.description);
    }

    private static testMethod void testGetApplicantAccountMultipleMatch() {
        Account a1 = peopleList[0].convertToAccount();
        Account a2 = peopleList[0].convertToAccount();

        insert a1;
        insert a2;

        Opportunity o1 = TestUtilities.createOpportunity();
        Opportunity o2 = TestUtilities.createOpportunity();
        o1.accountId = a1.id;
        o2.accountId = a2.id;
        o1.current_Appointment_Date_Time__c = Datetime.now();
        o2.current_Appointment_Date_Time__c = Datetime.now().addHours(1);

        insert o1;
        insert o2;

        Account a = MercuryUtility.getApplicantAccount(peopleList[0]);
        System.assertEquals(a2.id, a.id); //a2 wins
        System.assertNotEquals(null, a.description);
    }

    private static testMethod void testGetStandardMobileFormat() {
        String case1 = '0401 234 567';
        String expect1 = '+61401234567';

        String case2 = '0401234567';
        String expect2 = '+61401234567';

        String case3 = '0401 2 3 4 5 6 7';
        String expect3 = '+61401234567';

        String case4 = '0401 234 567 890';
        String expect4 = null;

        String case5 = '401 234 567';
        String expect5 = '+61401234567';

        String case6 = '501 000 000';
        String expect6 = null;

        System.assertEquals(expect1, MercuryUtility.getStandardMobileFormat(case1));
        System.assertEquals(expect2, MercuryUtility.getStandardMobileFormat(case2));
        System.assertEquals(expect3, MercuryUtility.getStandardMobileFormat(case3));
        System.assertEquals(expect4, MercuryUtility.getStandardMobileFormat(case4));
        System.assertEquals(expect5, MercuryUtility.getStandardMobileFormat(case5));
        System.assertEquals(expect6, MercuryUtility.getStandardMobileFormat(case6));
    }

    private static testMethod void testGenerateDetailPart() {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();

        system.assertNotEquals(null, MercuryUtility.generateDetailPart(req, res));
    }

    private static testMethod void testGenerateHTMLEmailBody() {
        MercuryUtility.generateHTMLEmailBody('a', 'b', 'c', 'd');
        system.assert(true);
    }

    private static testMethod void testCheckRecordFromResMap() {
        Map<String, Object> resMap = new Map<String, Object>();
        Map<String, String> item = new Map<String, String>();
        item.put('uniqueId', 'abc');
        resMap.put('people', item);

        System.assertEquals(true, MercuryUtility.checkRecordFromResMap(resMap, 'Account', 'abc'));
        System.assertEquals(false, MercuryUtility.checkRecordFromResMap(null, 'account', 'abc'));
        System.assertEquals(false, MercuryUtility.checkRecordFromResMap(resMap, 'account', 'abCd'));
        System.assertEquals(false, MercuryUtility.checkRecordFromResMap(resMap, 'account', 'abc'.toUpperCase()));
    }

}
