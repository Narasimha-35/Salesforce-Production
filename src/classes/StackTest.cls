@isTest
public class StackTest {
	private static Object testItem1 = 'a';
	private static Object testItem2 = 'b';

	private static Stack initTestStack() {
		Stack st = new Stack();
		st.push(testItem1);
		st.push(testItem2);
		return st;
	}

	private static testMethod void testIteratable() {
		Stack st = initTestStack();

		System.assertEquals(testItem2, st.peak());
		System.assertEquals(true, st.hasNext());
		System.assertEquals(testItem1, st.next());
		System.assertEquals(false, st.hasNext());
		System.assertEquals(testItem2, st.peak());
	}

	private static testMethod void testStack() {
		Stack st = initTestStack();

		System.assertEquals(testItem2, st.pop());
		System.assertEquals(false, st.isEmpty());
		System.assertEquals(testItem1, st.pop());
		System.assertEquals(null, st.pop());
		System.assertEquals(true, st.isEmpty());

		st.push(testItem1);
		System.assertEquals(testItem1, st.peak());
		System.assertEquals(false, st.isEmpty());
	}

	private static testMethod void testToString() {
		Stack st = initTestStack();
		System.assertEquals(testItem2, '' + st);
	}

}
