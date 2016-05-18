public with sharing class ApplicantUtilities {

	public static String getDateFieldInGMT(String dateString) {
		Date retDate = null;
		try {
			retDate = Date.parse(dateString);
		} catch(Exception e) {
			return null;
		}

		return Datetime.newInstance(retDate.year(), retDate.month(), retDate.day()).format('yyyy-MM-dd\'T\'HH:mm:ssXXX');
	}

	public static Integer cleanInteger(String intString) {
		Integer ret = null;
		try {
			intString = intString.replace('+', '');
			ret = Integer.valueOf(intString);
		} catch (Exception e) {
			return null;
		}

		return ret;
	}


}
