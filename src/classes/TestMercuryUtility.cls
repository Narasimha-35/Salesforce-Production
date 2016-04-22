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
    private static final String testLoanPeopleString = '[{"uniqueId":"e2db00ee-c583-11e5-9595-00155d006737","relationship":"Primary Applicant","personID":"D6326846-939D-F4C9-4B1D-14710291DE49","loanID":"B1C70990-BB7B-1353-FDF7-86CF1E469F64","email":"billybyrne1@hotmail.com"},{"uniqueId":"e2710778-c583-11e5-9595-00155d006737","relationship":"Applicant","personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","loanID":"B1C70990-BB7B-1353-FDF7-86CF1E469F64","email":"alexandriamayer@hotmail.com"}]';
    private static final String testPeopleString = '[{"webPassword":"","webAccess":false,"uniqueId":"D6326846-939D-F4C9-4B1D-14710291DE49","trustName":null,"title":"Mr","salutationOrFirstName":"Billy","salutation":"Billy","relationshipManagerName":"","relationshipManager":"","phoneDisplayType4":"Business Fax","phoneDisplayType3":"Business","phoneDisplayType2":"Mobile","phoneDisplayType1":"Home","personDataType":"Full","partnerName":"Australian Credit and Finance","occupation":"Pipe Layer","numberOfDependents":1,"notes":"<html>\\n <head></head>\\n <body></body>\\n</html>","mobile":"0419 878 619","middleName":"","markAsPrivate":false,"maritalStatus":"DeFacto","lastName":"Byrne","jobTitle":"Pipe Layer","isNew":null,"isDeleted":false,"importDocumentId":"","homeSuburb":null,"homePhone":"0243325087","gender":"M","funambolUsers":null,"fullName":"Billy Byrne","firstName":"Billy","employmentStatus":"Full Time","employmentCommenced":"2015-01-12","employer":"Robsons Civil Projects ","emailBounced":false,"email":"billybyrne1@hotmail.com","driversLicenceState":"NSW","driversLicenceNumber":"14292695","driversLicenceExpiry":"2016-04-16","doNotMail":false,"deletedOn":null,"deletedBy":null,"dateOfBirth":"503607600000","createdOn":null,"createdBy":"CA47016","contactType":null,"contactMethods":[{"personID":"D6326846-939D-F4C9-4B1D-14710291DE49","content":"0243325087","contactMethod":"Home"},{"personID":"D6326846-939D-F4C9-4B1D-14710291DE49","content":"0419878619","contactMethod":"Mobile"},{"personID":"D6326846-939D-F4C9-4B1D-14710291DE49","content":"","contactMethod":"Business"},{"personID":"D6326846-939D-F4C9-4B1D-14710291DE49","content":"","contactMethod":"Business Fax"},{"personID":"D6326846-939D-F4C9-4B1D-14710291DE49","content":"billybyrne1@hotmail.com","contactMethod":"Email 1"}],"company":"P200019","businessPhone":"","annualSalary":78566.0,"addressDisplay":"Home","acn":null,"abn":null},{"webPassword":"","webAccess":false,"uniqueId":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","trustName":null,"title":"Ms","salutationOrFirstName":"Alexandria","salutation":"","relationshipManagerName":"","relationshipManager":"","phoneDisplayType4":"Business Fax","phoneDisplayType3":"Business","phoneDisplayType2":"Mobile","phoneDisplayType1":"Home","personDataType":"Full","partnerName":"Australian Credit and Finance","occupation":"Carer","numberOfDependents":0,"notes":"<html>\\n <head></head>\\n <body></body>\\n</html>","mobile":"0413171511","middleName":"","markAsPrivate":false,"maritalStatus":"DeFacto","lastName":"Mayer","jobTitle":"Carer","isNew":null,"isDeleted":false,"importDocumentId":"","homeSuburb":null,"homePhone":"0243325087","gender":"F","funambolUsers":null,"fullName":"Alexandria Mayer","firstName":"Alexandria","employmentStatus":"Part Time","employmentCommenced":"2013-06-10","employer":"Hammond Care","emailBounced":false,"email":"alexandriamayer@hotmail.com","driversLicenceState":"NSW","driversLicenceNumber":"15190186","driversLicenceExpiry":"2017-01-25","doNotMail":false,"deletedOn":null,"deletedBy":null,"dateOfBirth":"605732400000","createdOn":null,"createdBy":"CA47016","contactType":null,"contactMethods":[{"personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","content":"0243325087","contactMethod":"Home"},{"personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","content":"0413171511","contactMethod":"Mobile"},{"personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","content":"","contactMethod":"Business"},{"personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","content":"","contactMethod":"Business Fax"},{"personID":"36E8562C-2310-0AF5-FDD9-147811ABEAE7","content":"alexandriamayer@hotmail.com","contactMethod":"Email 1"}],"company":"P200019","businessPhone":"","annualSalary":30036.0,"addressDisplay":"Home","acn":null,"abn":null}]';

    private static Mercury_Opportunity__c testMercOppo;
    private static List<MercuryModel.LoanPeople> loanPeopleList;
    private static List<MercuryModel.People> peopleList;
    static {
        testMercOppo = new Mercury_Opportunity__c();
        testMercOppo.merc_people__c = testPeopleString;
        testMercOppo.merc_loanPeople__c = testLoanPeopleString;

        loanPeopleList = MercuryUtility.getLoanPeople(testMercOppo);
        peopleList = MercuryUtility.getPeople(testMercOppo);
    }

    private static testMethod void testGetLoanPeople() {
        List<MercuryModel.LoanPeople> loanPeop = MercuryUtility.getLoanPeople(testMercOppo);
        System.assertEquals('e2db00ee-c583-11e5-9595-00155d006737', loanPeop[0].uniqueId);
        System.assertEquals('e2710778-c583-11e5-9595-00155d006737', loanPeop[1].uniqueId);
    }

    private static testMethod void testGetPeople() {
        List<MercuryModel.People> peop = MercuryUtility.getPeople(testMercOppo);
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

    private static testMethod void testGetAnyApplicantHaveEmail() {
        List<MercuryModel.People> testPeopleList = peopleList.clone();
        testPeopleList[0].email = null;
        String paid = MercuryUtility.getAnyApplicantHaveEmail(testPeopleList).uniqueId;
        System.assertEquals('36E8562C-2310-0AF5-FDD9-147811ABEAE7', paid);
    }

}
