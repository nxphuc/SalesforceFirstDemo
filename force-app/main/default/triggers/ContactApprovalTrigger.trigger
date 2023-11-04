trigger ContactApprovalTrigger on Contact (after insert) {
    List<Contact> contactList = new List<Contact>();

    for(Contact cont : trigger.new)
        contactList.add(new Contact(Id = cont.Id, Active__c = false));
    // force set ative status to be false
    update contactList;

    for(Contact cont : trigger.new) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval. Please approve.');
        req.setObjectId(cont.Id);
        Approval.ProcessResult result = Approval.process(req);
    }
}