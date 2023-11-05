@isTest
public with sharing class PageControllerTest {
    @TestSetup
    static void setup() {
        // insert mock data
        insert new Contact(FirstName = 'Contact', LastName = 'First', Counter__c = 0);
        insert new Contact(FirstName = 'Contact', LastName = 'Second', Counter__c = 0);
        insert new Account(Name = 'First Account');
        insert new Account(Name = 'Second Account');
    }

    @isTest
    public static void itShouldReturnSearchResult() {
        Test.startTest();
        
        PageController controller = new PageController();
        controller.searchText = 'First';
        controller.search();
        System.assertEquals(2, controller.searchResult.size());
        for (PageController.SearchResult o : controller.searchResult)
            System.assertEquals('First ' + o.Type, o.Name);

        Test.stopTest();
    }

    @isTest
    public static void itShouldReturnEmptyList() {
        Test.startTest();
        
        PageController controller = new PageController();
        controller.searchText = 'Empty';
        controller.search();
        System.assertEquals(0, controller.searchResult.size());
        
        Test.stopTest();
    }

    @isTest
    public static void itShouldIncreaseContactCounter() {
        Test.startTest();
        
        Contact contact = [SELECT Id, Counter__c FROM Contact LIMIT 1];

        PageController controller = new PageController();
        SObject obj = pageController.increaseCounter(contact.Id, 'Contact');

        Contact updatedContact = [SELECT Id, Counter__c FROM Contact WHERE Id = :contact.Id LIMIT 1];

        System.assertEquals(updatedContact.Counter__c, contact.Counter__c + 1);
        
        Test.stopTest();
    }

    @isTest
    public static void itShouldIncreaseAccountCounter() {
        Test.startTest();
        
        Account account = [SELECT Id, Counter__c FROM Account LIMIT 1];

        PageController controller = new PageController();
        SObject obj = pageController.increaseCounter(account.Id, 'Account');

        Account updatedContact = [SELECT Id, Counter__c FROM Account WHERE Id = :account.Id LIMIT 1];

        System.assertEquals(updatedContact.Counter__c, account.Counter__c + 1);
        
        Test.stopTest();
    }

    @isTest
    public static void itShouldThrowInvalidTypeError() {
        Test.startTest();
        
        Account account = [SELECT Id, Counter__c FROM Account LIMIT 1];

        PageController controller = new PageController();
        try {
            SObject obj = pageController.increaseCounter(account.Id, 'InvalidType');

            System.assert(false, 'Do not expect to go here');
        } catch (Exception e) {
            System.assert(e instanceof PageController.ApplicationException);
            System.assertEquals('INVALID_TYPE', e.getMessage());
        }
        
        Test.stopTest();
    }

    @isTest
    public static void itShouldThrowObjectNotFoundError() {
        Test.startTest();
        
        Account account = [SELECT Id, Counter__c FROM Account LIMIT 1];

        PageController controller = new PageController();
        try {
            SObject obj = pageController.increaseCounter('0035j00001Dew3FAKE', 'Account');

            System.assert(false, 'Do not expect to go here');
        } catch (Exception e) {
            System.assert(e instanceof PageController.ApplicationException);
            System.assertEquals('OBJECT_NOT_FOUND', e.getMessage());
        }
        
        Test.stopTest();
    }
}