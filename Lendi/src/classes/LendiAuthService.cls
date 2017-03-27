/**
* LendiAuthService
*/
global with sharing class LendiAuthService {
	public static final String CLASS_NAME = LendiAuthService.class.getName();

	public static LendiApiService lendiService = new LendiApiService();

	/**
	* get lendi authenticate token with account id
	*/
	webservice static String getAuthToken(String accId) {
		return lendiService.getAuthToken(accId);
	}

}