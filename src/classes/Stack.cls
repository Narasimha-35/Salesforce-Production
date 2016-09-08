/*
* Stack
*/
public class Stack implements Iterator<Object> {
	private List<Object> items;
	private Integer index;

	public Stack() {
		this.items = new List<Object>();
		this.index = -1;
	}

	public Boolean hasNext() {
		return index > 0;
	}

	public Object next() {
		return hasNext() ? items[--index] : null;
	}

	public void push(Object newItem) {
		index = items.size();
		items.add(newItem);
	}

	public Object pop() {
		return isEmpty() ? null : items.remove(items.size() - 1);
	}

	public Boolean isEmpty() {
		return items.size() == 0 ? true : false;
	}

	public Object peak() {
		return isEmpty() ? null : items[items.size() - 1];
	}

	public override String toString() {
		return items[index] + '';
	}

	public void print() {
		String ret = '';
		for(Object item : items) ret += item + ' -> ';
		System.debug(ret + 'Head');
	}

}
