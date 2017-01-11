@isTest
public with sharing class TestApplicantUtilities {

	private static testMethod void testGetDateFieldInGMT() {
		System.assertEquals('1988-02-10T00:00:00', ApplicantUtilities.getDateFieldInGMT('10/02/1988').left(19));
		System.assertEquals('1951-01-07T00:00:00', ApplicantUtilities.getDateFieldInGMT('7/1/1951').left(19));
		System.assertEquals(null, ApplicantUtilities.getDateFieldInGMT(''));
		System.assertEquals('1988-02-10T00:00:00', ApplicantUtilities.getDateFieldInGMT('10/2/88').left(19));
	}

	private static testMethod void testCleanInteger() {
		System.assertEquals(null, ApplicantUtilities.cleanInteger('asd3'));
		System.assertEquals(1, ApplicantUtilities.cleanInteger('1'));
		System.assertEquals(5, ApplicantUtilities.cleanInteger('5+'));
	}

}