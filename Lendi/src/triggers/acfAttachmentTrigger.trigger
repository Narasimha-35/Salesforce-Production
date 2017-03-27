trigger acfAttachmentTrigger on Attachment (after insert) {
    AttachmentTriggerHandler attHandler = new AttachmentTriggerHandler();
    attHandler.updateFileURL(trigger.new);
}