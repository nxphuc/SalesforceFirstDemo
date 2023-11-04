public with sharing class HttpResponseHandler {
    public static RestResponse res = RestContext.response;
    public static RestRequest req = RestContext.request;


    public static void SuccessResponse(String message) {
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(message);
    }

    public static void FailureResponse(String message) {
        res.statusCode = 400;
        res.responseBody = Blob.valueOf(message);
    }
}