global with sharing class PageController {
    public class SearchResult {
        public Id Id { get; set; }
        public String Name { get; set; }
        public String Type { get; set; }
        public Decimal Counter { get; set; }

        public SearchResult(Id Id, String Name, String Type, Decimal Counter) {
            this.Id = Id;
            this.Name = Name;
            this.Type = Type;
            this.Counter = Counter;
        }
    }

    public class ApplicationException extends Exception {}

    public String searchText { get; set; }
    public List<SearchResult> searchResult { get; set; }

    public PageReference search() {
        List<Account> accountResult = [SELECT Id, Name, Counter__c FROM Account WHERE Name LIKE :(searchText + '%')];
        List<Contact> contactResult = [SELECT Id, Name, Counter__c FROM Contact WHERE Name LIKE :(searchText + '%')];
        
        searchResult = new List<SearchResult>();

        for (Account account : accountResult)
            searchResult.add(new SearchResult(account.Id, account.Name, 'Account', account.Counter__c != null ? account.Counter__c : 0));
        for (Contact contact : contactResult)
            searchResult.add(new SearchResult(contact.Id, contact.Name, 'Contact', contact.Counter__c != null ? contact.Counter__c : 0));

        return null;
    }

    @RemoteAction
    global static SObject increaseCounter(String id, String type) {
        SObject obj;
        if (!type.equals('Account') && !type.equals('Contact'))
            throw new ApplicationException('INVALID_TYPE');
        try {
            obj = Database.query('SELECT Id, Counter__c FROM ' + type + ' WHERE Id = \'' + Id + '\' LIMIT 1');
        } catch (Exception e) {
            throw new ApplicationException('OBJECT_NOT_FOUND');
        }
        obj.put('Counter__c', obj.get('Counter__c') != null ? (Decimal)obj.get('Counter__c') + 1 : 1);
        update obj;
        return obj;
    }
}