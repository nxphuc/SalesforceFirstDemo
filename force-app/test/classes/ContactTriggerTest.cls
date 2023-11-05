@isTest
public with sharing class ContactTriggerTest {
    @isTest
    public static void itShouldCreateNewApprovalProcessAndAutomaticallyApproved() {
        Test.startTest();
        Account account = new Account(Name='Test account');
        insert account;
        Contact contact = new Contact(AccountId = account.Id, LastName='Test contact', Active__c = false);
        insert contact;

        List<ProcessInstance> existingApprovals = [
            SELECT Id, Status
            FROM ProcessInstance
            WHERE TargetObjectId = :contact.Id AND IsDeleted = false
        ];
        System.assert(existingApprovals.size() == 1);
        System.assert(existingApprovals[0].Status == 'Approved');

        contact = [SELECT Id, Active__c FROM Contact WHERE Id = :contact.Id LIMIT 1];
        System.assert(contact.Active__c == true);
        
        Test.stopTest();
    }

    @isTest
    public static void itShouldIncreaseAccountTotalOfContacts() {
        Test.startTest();
        Account account = new Account(Name='Test account');
        insert account;

        account = [SELECT Id, Total_Contacts__c FROM Account WHERE Id = :account.Id LIMIT 1];
        System.assert(account.Total_Contacts__c == 0);

        Contact contact = new Contact(AccountId = account.Id, LastName='Test contact');
        insert contact;

        Account updatedAccount = [SELECT Id, Total_Contacts__c FROM Account WHERE Id = :account.Id LIMIT 1];
        System.assert(account.Total_Contacts__c + 1 == updatedAccount.Total_Contacts__c);
        Test.stopTest();
    }

    @isTest
    public static void itShouldDecreaseAccountTotalofContactsOnDelete() {
        Test.startTest();
        Account account = new Account(Name='Test account', Total_Contacts__c = 0);
        insert account;

        Contact contact = new Contact(AccountId = account.Id, LastName='Test contact');
        insert contact;

        account = [SELECT Id, Total_Contacts__c FROM Account WHERE Id = :account.Id LIMIT 1];
        delete contact;

        Account updatedAccount = [SELECT Id, Total_Contacts__c FROM Account WHERE Id = :account.Id LIMIT 1];
        System.assert(account.Total_Contacts__c - 1 == updatedAccount.Total_Contacts__c);
        Test.stopTest();
    }
}