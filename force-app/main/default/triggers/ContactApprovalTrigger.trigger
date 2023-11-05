trigger ContactApprovalTrigger on Contact (after insert) {
    for(Contact cont : trigger.new) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval. Please approve.');
        req.setObjectId(cont.Id);
        Approval.ProcessResult result = Approval.process(req);
    }
}