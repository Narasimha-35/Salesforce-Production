@isTest
public with sharing class TestModel {

	private class MyModel extends Model {
		public String attribute1;
		public Boolean attribute2;
		public Decimal attribute3;
	}

	private static testMethod void testSetterAndGetter() {
		MyModel m = new MyModel();
		m = (MyModel) m.put('attribute1', 'Some String', MyModel.class);
		m = (MyModel) m.put('attribute2', false, MyModel.class);
		m = (MyModel) m.put('attribute3', 1.1, MyModel.class);

		System.assertEquals('Some String', m.get('attribute1'));
		System.assertEquals(false, m.get('attribute2'));
		System.assertEquals(1.1, m.get('attribute3'));
	}

	private static testMethod void testGetAttributes() {
		MyModel m = new MyModel();
		Set<String> attr = m.getAttributes();
		Set<String> expect = new Set<String>{'attribute1', 'attribute2', 'attribute3'};
		attr.removeALl(expect);
		System.assertEquals(0, attr.size());
	}

	private static testMethod void testGetNonNullAttributeSet() {
		MyModel m = new MyModel();
		Set<String> nonNullSet = m.getNonNullAttributeSet();
		System.assertEquals(0, nonNullSet.size());
	}
}
