trigger ContactActiveTrigger on Contact (after update) {
    List<Id> accIdList = new List<Id>();
    for(Contact contact : Trigger.new) {
        if (Trigger.oldMap.get(contact.Id).Active__c == false && contact.Active__c == true) {
            accIdList.add(contact.AccountId);
        }
    }

    if (accIdList.size() == 0) return;

    List<Account> accountList = [
        SELECT Id, Total_Contacts__c FROM Account
        WHERE Id IN :accIdList
    ];

    for (Account acc : accountList) {
        acc.Total_Contacts__c += 1;
    }

    update accountList;
}