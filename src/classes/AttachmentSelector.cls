public with sharing class AttachmentSelector extends SObjectSelector {
	public AttachmentSelector() {
		super('Attachment', null, null);
	}

	public AttachmentSelector(Set<String> specFields, Set<String> excludeFields) {
		super('Attachment', specFields, excludeFields);
	}

	public List<Attachment> getById(List<Id> ids) {
		return (List<Attachment>) super.selectByIds(ids);
	}

	public Attachment getById(Id rid) {
		return (Attachment) super.selectByIds(new List<Id>{rid})[0];
	}

	public List<Attachment> getByParentId(List<Id> parentId) {
		return (List<Attachment>) super.selectByRelationId('ParentId', parentId);
	}
}
