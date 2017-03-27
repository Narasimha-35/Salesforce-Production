@isTest
public class QSUtilTest {

	public class QSUtilTestObject {
		public String testString;
		public Integer testInteger;
		public Double testDouble;
		public QSUtilTestSubObject testSubObject;
		public List<QSUtilTestSubObject> testSubObjectList;
	}

	public class QSUtilTestSubObject {
		public String testString;
		public Integer testInteger;
		public Double testDouble;
	}

	private static testMethod void testIsArrayLabel() {
		System.assertEquals(false, QSUtil.isArrayLabel('[10a]'));
		System.assertEquals(true, QSUtil.isArrayLabel('[100]'));
		System.assertEquals(true, QSUtil.isArrayLabel('[-1]'));
	}

	private static testMethod void testGetArrayCounter() {
		System.assertEquals(null, QSUtil.getArrayCounter('[10a]'));
		System.assertEquals(100, QSUtil.getArrayCounter('[100]'));
	}

	private static testMethod void testConstructItemString() {
		System.assertEquals('[test]', QSUtil.constructItemString('test'));
	}

	private static testMethod void testIncreaseArrayStackValue() {
		Stack st = new Stack();
		st.push('[0]');
		QSUtil.increaseArrayStackValue(st);
		System.assertEquals('[1]', (String)st.pop());
	}

	private static testMethod void testStringify() {
		//TODO: add test
	}

}