public with sharing class MercuryUtility {

	public static Object parseJsonValue(Map<String, Schema.DisplayType> fieldTypeMap, String fieldName, Object inputObject) {
		try {
			if(fieldTypeMap.get(fieldName) == Schema.DisplayType.DateTime) {
				if(inputObject instanceof Long) {
					return Datetime.newInstance((Long) inputObject);
				} else if (inputObject instanceof String) {
					return Datetime.valueOf((String) inputObject);
				}
			} else if(fieldTypeMap.get(fieldName) == Schema.DisplayType.Date) {
				if(inputObject instanceof Long) {
					return (Date) Datetime.newInstance((Long) inputObject);
				} else if (inputObject instanceof String) {
					return Date.valueOf((String) inputObject);
				}
			}
		} catch (Exception e) {
			return null;
		}
		return inputObject;
	}

}
