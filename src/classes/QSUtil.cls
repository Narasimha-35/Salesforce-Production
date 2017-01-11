/*
* QSUtil
*/
public class QSUtil {
	private static final String OBJECT_MARK = 'OBJECT';
	private static final Integer INIT_INDEX = -1;

	@testVisible
	private static Boolean isArrayLabel(String label) {
		return Pattern.matches('\\[[-]?\\d+\\]', label);
	}

	@testVisible
	private static Integer getArrayCounter(String label) {
		try {
			return Integer.valueOf(label.subString(1, label.length() - 1));
		} catch (TypeException e) {
			return null;
		}
	}

	@testVisible
	private static String constructItemString(String item) {
		return isArrayLabel(item) ? item : '[' + item + ']';
	}

	@testVisible
	private static void increaseArrayStackValue(Stack st) {
		Integer counter = Integer.valueOf(getArrayCounter((String) st.pop()));
		st.push(constructItemString(counter + 1 + ''));
	}

	public static String stringify(String objectName, Object obj) {
		String jsonString = JSON.serialize(obj, true);
		JSONParser jp = JSON.createParser(jsonString);
		System.debug(jsonString);

		Stack st = new Stack();
		String ret = '';
		st.push(objectName);

		while(jp.nextToken() != null) {
			JSONToken token = jp.getCurrentToken();
			String value = jp.getText();

			//if is filed name push to stack
			if(token == JSONToken.FIELD_NAME) {
				st.push(value);
			// if is value start to build return, the atom return should be the stack of tokens
			// all returns are strings
			} else if(token == JSONToken.VALUE_STRING
			|| token == JSONToken.VALUE_TRUE
			|| token == JSONToken.VALUE_FALSE
			|| token == JSONToken.VALUE_NUMBER_FLOAT
			|| token == JSONToken.VALUE_NUMBER_INT
			) {
				if(isArrayLabel((String) st.peak())) increaseArrayStackValue(st);
				String atomString = '';
				while (st.hasNext()) {
					if(st.toString() != OBJECT_MARK) atomString = constructItemString(st.toString()) + atomString;
					st.next();
				}
				atomString = st + atomString;
				ret += atomString + '=' + value + '&';
				// pop out the last filed name since we have processed it.
				st.pop();
			// if the prev token is Array and current token is a start object, then the Array
			// count should increase by one.
			} else if(token == JSONToken.START_OBJECT) {
				if(isArrayLabel((String) st.peak())) increaseArrayStackValue(st);
				st.push(OBJECT_MARK);
			// if token is start array then initialise list index to -1
			} else if(token == JSONToken.START_ARRAY) {
				st.push(constructItemString(String.valueOf(INIT_INDEX)));
			// if close object pop out the name of the object as well.
			} else if(token == JSONToken.END_OBJECT) {
				String temp;
				do {
					temp = (String) st.pop();
				} while(temp != null && temp != OBJECT_MARK);
			// if close object pop out the remaining stuff of the list item or field names.
			} else if (token == JSONToken.END_ARRAY) {
				String temp;
				do {
					temp = (String) st.pop();
				} while(temp != null && !isArrayLabel(temp));
			}
		}
		ret = ret.left(ret.length() - 1);
		return ret;
	}

}