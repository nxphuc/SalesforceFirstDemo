@RestResource(urlMapping='/MyRestService')
global with sharing class MyRestService {
    public class HttpException extends Exception {}

    @HttpPatch
    global static void updateContacts() {
        try {
            List<Contact> requestBody = (List<Contact>)JSON.deserialize(RestContext.request.requestBody.toString(), List<Contact>.class);
            Set<String> contactIds = new Set<String>();

            for (Contact obj : requestBody) {
                if (String.isEmpty(obj.Id) || String.isBlank(obj.Id))
                    throw new HttpException(Constants.OBJECT_ID_MISSING);
                if (contactIds.contains(obj.Id))
                    throw new HttpException(Constants.OBJECT_ID_DUPLICATED);
                contactIds.add(obj.Id);
            }

            List<Contact> contactList = [SELECT Id FROM Contact WHERE Id IN :requestBody];

            if (contactList.size() != contactIds.size())
                throw new HttpException(Constants.OBJECT_NOT_FOUND);

            update requestBody;
            HttpResponseHandler.SuccessResponse(Constants.SUCCESS);
        } catch (Exception e) {
            HttpResponseHandler.FailureResponse(e.getMessage());
        }
    }
}