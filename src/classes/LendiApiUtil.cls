public class LendiApiUtil {

	public static String getData(HttpRequestResponse result) {
		Map<String, Object> lendiRes = (Map<String, Object>) JSON.deserializeUntyped(result.res.getBody());
		Map<String, Object> dataMap = (Map<String, Object>) lendiRes.get('data');
		String objectName = (new List<String>(dataMap.keySet()))[0];
		String ret = JSON.serialize(dataMap.get(objectName));
		return ret;
	}

}
