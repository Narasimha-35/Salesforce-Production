public abstract class Model {

	public Object get(String f) {
		Map<String, Object> oMap;
		String s = JSON.serialize(this);
		oMap = (Map<String,Object>) JSON.deserializeUntyped(s);
		return oMap.get(f);
	}

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
}