public with sharing class EventSelector extends SObjectSelector {

	public EventSelector() {
		super('Event', null, null);
	}

	public EventSelector(Set<String> specFields, Set<String> excludeFields) {
		super('Event', specFields, excludeFields);
	}

	public List<Event> getById(List<Id> ids) {
		return (List<Event>) super.selectByIds(ids);
	}

	public Event getById(Id rid) {
		return (Event) super.selectByIds(new List<Id>{rid})[0];
	}

}
