@RestResource (UrlMapping='/property/*' )
global with sharing class PropertyManager {

    @HttpGet
    global static void getProperty() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String propertyId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        List <Property__c> results = new List<Property__c>();
        System.debug(propertyId);

        if (String.isBlank(propertyId)) {
            results =  PropertySelector.getListProperties();
        } else {
            if (propertyId.length() == 18) {
                results =  PropertySelector.getPropertyById(propertyId);
            } else {
                response.statusCode = 400;
                response.responseBody = Blob.valueOf('Property Id is wrong');
                return;
            }
        }
        if (results.isEmpty()) {
            response.statusCode = 404;
            response.responseBody = Blob.valueOf('Property Id is not found');
            return;
        }
        response.headers.put('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf(JSON.serializePretty(results));
    }

    @HttpPost
    global static void createProperty(String name, String title, String address, Id accountId, Decimal price, Id type) {
        RestResponse response = RestContext.response;
        Property__c property = new Property__c();
        property.Name = name;
        property.Property_Title__c = title;
        property.Address__c = address;
        property.Account__c = accountId;
        property.Price__c = price;
        property.RecordTypeId = type;
        insert property;
        response.headers.put('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf(JSON.serialize(property));
    }

    @HttpPatch
    global static void updateProperty(Decimal price) {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String propertyId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        if (String.isBlank(propertyId) || propertyId.length() != 18 ) {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('Property Id is missing or wrong!');
            return;
        }

        List<Property__c> results = PropertySelector.getPropertyForPatch(propertyId);

        if (results.isEmpty()){
            response.statusCode = 404;
            response.responseBody = Blob.valueOf('Property Id is not found');
            return;
        }
        results[0].Price__c = price;
        update results[0];
        response.headers.put('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf(JSON.serialize(results[0]));
    }

    @HttpDelete
    global static void deleteProperty() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String propertyId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        if (String.isBlank(propertyId) || propertyId.length() != 18 ) {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('Property Id is missing or wrong');
            return;
        }

        List<Property__c> results = PropertySelector.getPropertyForPatch(propertyId);

        if (results.isEmpty()){
            response.statusCode = 404;
            response.responseBody = Blob.valueOf('Property Id is not found');
            return;
        }
        delete results;
        response.headers.put('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf(JSON.serialize('Property Id: ' + propertyId + ' has been deleted'));
    }
}