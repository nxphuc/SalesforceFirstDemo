@isTest
public class MyRestServiceTest {
    @TestSetup
    static void setup() {
        // insert mock data
        insert new Contact(FirstName = 'First', LastName = 'Contact');
        insert new Contact(FirstName = 'Second', LastName = 'Contact');
    }

    private static void prepareRequestBody(List<Contact> contactList) {
        // prepare common request parameters
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/MyRestService';
        req.httpMethod = 'PATCH';
        req.addHeader('Content-Type', 'application/json');

        RestContext.request = req;
        List<Map<String, Object>> objList = new List<Map<String, Object>>();
        for (Contact contact : contactList) {
            objList.add((Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(contact)));
        }
        req.requestBody = Blob.valueOf(JSON.serialize(objList));
    }

    @isTest
    public static void itShouldUpdateContact() {
        Test.startTest();
        
        List<Contact> contactList = [SELECT Id, FirstName, LastName FROM Contact ORDER BY Id];
        contactList[0].FirstName = 'Changed Firstname';

        prepareRequestBody(contactList);

        RestResponse res = new RestResponse();
        RestContext.response = res;
        MyRestService.updateContacts();

        System.assertEquals(200, res.statusCode);
        Contact changedContact = [SELECT Id, FirstName, LastName FROM Contact ORDER BY Id LIMIT 1];
        System.assertEquals(changedContact.FirstName, contactList[0].FirstName);

        Test.stopTest();
    }

    @isTest
    public static void itShouldReturnContactIDMissing() {
        Test.startTest();
        
        List<Contact> contactList = new List<Contact>();
        Contact contact = new Contact();
        contactList.add(contact);

        prepareRequestBody(contactList);

        RestResponse res = new RestResponse();
        RestContext.response = res;
        MyRestService.updateContacts();

        System.assertEquals(400, res.statusCode);
        System.assertEquals('CONTACT_ID_MISSING', res.responseBody.toString());

        Test.stopTest();
    }

    @isTest
    public static void itShouldReturnContactNotFound() {
        Test.startTest();
        
        List<Contact> contactList = new List<Contact>();
        Contact contact = new Contact();
        contact.Id = (Id)'0035j00001Dew3FAKE';
        contactList.add(contact);

        prepareRequestBody(contactList);

        RestResponse res = new RestResponse();
        RestContext.response = res;
        MyRestService.updateContacts();

        System.assertEquals(400, res.statusCode);
        System.assertEquals('CONTACT_NOT_FOUND', res.responseBody.toString());

        Test.stopTest();
    }

    @isTest
    public static void itShouldReturnContactDuplicated() {
        Test.startTest();
        
        List<Contact> contactList = new List<Contact>();
        Contact contact = new Contact();
        contact.Id = (Id)'0035j00001Dew3FAKE';
        contactList.add(contact);
        contactList.add(contact);

        prepareRequestBody(contactList);

        RestResponse res = new RestResponse();
        RestContext.response = res;
        MyRestService.updateContacts();

        System.assertEquals(400, res.statusCode);
        System.assertEquals('CONTACT_ID_DUPLICATED', res.responseBody.toString());

        Test.stopTest();
    }
}