trigger ContactDeleteTrigger on Contact (after delete) {
    List<Id> accIdList = new List<Id>();
    for(Contact contact : Trigger.old) {
        if (contact.Active__c == true) {
            accIdList.add(contact.AccountId);
        }
    }

    if (accIdList.size() == 0) return;

    List<Account> accountList = [
        SELECT Id, Total_Contacts__c FROM Account
        WHERE Id IN :accIdList
    ];

    for (Account acc : accountList) {
        if (acc.Total_Contacts__c > 0)
            acc.Total_Contacts__c -= 1;
    }

    update accountList;
}