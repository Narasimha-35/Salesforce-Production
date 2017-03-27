/*
* Model
*/
public abstract class Model {

	/*
	* The patten prefix for the field name are system reserved
	*/
	public static final String REMOVE_RESERVE_PATTEN = 'param_rr_';

	public Object get(String f) {
		Map<String, Object> oMap;
		String s = JSON.serialize(this);
		oMap = (Map<String,Object>) JSON.deserializeUntyped(s);
		return oMap.get(f);
	}

	/*
	* Usage: m = (MyModel) m.put('attribute1', 'Some String', MyModel.class);
	*/
	public Object put(String f, Object v, System.Type t) {
		Map<String, Object> oMap;
		String s = JSON.serialize(this);
		oMap = (Map<String,Object>) JSON.deserializeUntyped(s);
		oMap.put(f, v);
		return JSON.deserialize(JSON.serialize(oMap), t);
	}

	public Set<String> getAttributes() {
		String s = JSON.serialize(this);
		// Deserialize it back into a key/value map
		Map<String,Object> obj = (Map<String,Object>) JSON.deserializeUntyped(s);
		// Return a Set of those fields present on our object
		return obj.keyset().clone();
	}

	public Set<String> getNonNullAttributeSet() {
		Set<String> ret = getAttributes();
		for(String s : ret) if(get(s) == null) ret.remove(s);
		return ret;
	}

	/*
	* Note: very unlikely to have some field starts with 'param_rr_' and does not because of system reserved
	* @depriciated
	*/
	public Boolean isContainsReservedName() {
		for(String s : getAttributes()) if(s.startsWith(REMOVE_RESERVE_PATTEN)) return true;
		return false;
	}

	public String serializeJSON() {
		return serializeJSON(false);
	}

	public String serializeJSON(Boolean suppressApexObjectNulls) {
		String ret = JSON.serialize(this, suppressApexObjectNulls);
		return ret.replace(REMOVE_RESERVE_PATTEN, '');
	}

	public static Object deserializeJSON(String jsonString, System.Type t) {
		JSONParser jp = JSON.createParser(jsonString);
		Set<String> fieldNameNeedsToReplace = new Set<String>();

		while(jp.nextToken() != null) {
			JSONToken token = jp.getCurrentToken();
			String value = jp.getText();
			if(token == JSONToken.FIELD_NAME && SystemStaticValues.RESERVED_KEYWORDS.contains(value)) {
				fieldNameNeedsToReplace.add(value);
			}
		}

		for(String fn : fieldNameNeedsToReplace) {
			jsonString = jsonString.replace('"' + fn + '"', '"' + REMOVE_RESERVE_PATTEN + fn + '"');
		}

		return (Object) JSON.deserialize(jsonString, t);
	}

}