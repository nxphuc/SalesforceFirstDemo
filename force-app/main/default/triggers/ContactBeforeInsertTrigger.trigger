trigger ContactBeforeInsertTrigger on Contact (before insert) {
    // force set ative status to be false
    for (Contact contact : Trigger.new)
        contact.Active__c = false;
}