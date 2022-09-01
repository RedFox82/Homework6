@IsTest
private with sharing class PropertyManagerTest {

//Tests for GET method
    @IsTest static void testGetPropertyById_Positive() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        Id recordId = [SELECT Id FROM Property__c LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://brave-goat-icrgm5-dev-ed.my.salesforce.com/services/' +
                            'apexrest/property/' + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.getProperty();
        Test.stopTest();

        //then
        response = RestContext.response;
        String actual = response.responseBody.toString().normalizeSpace();
        String expected = '[ { "attributes" : { "type" : "Property__c", "url" : ' +
                        '"/services/data/v55.0/sobjects/Property__c/' + recordId + '" }, "Id" : "'
                        + recordId + '", "Name" : "Barad-dur0", "Property_Title__c" : "Barad-dur apartments", ' +
                        '"Address__c" : "13, Sauron str., Mordor" } ]';

        System.assertEquals(expected, actual);
    }

    @IsTest static void testGetPropertyList() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        Id recordId = [SELECT Id FROM Property__c LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://brave-goat-icrgm5-dev-ed.my.salesforce.com/services/services/' +
                            'apexrest/property/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.getProperty();
        Test.stopTest();

        //then
        response = RestContext.response;
        String actual = response.responseBody.toString().normalizeSpace();
        String expected = '[ { "attributes" : { "type" : "Property__c", "url" : ' +
                        '"/services/data/v55.0/sobjects/Property__c/' + recordId + '" }, "Id" : "'
                        + recordId + '", "Name" : "Barad-dur0", "Property_Title__c" : "Barad-dur apartments", ' +
                        '"Address__c" : "13, Sauron str., Mordor" } ]';
        System.assertEquals(expected, actual);
    }

    @IsTest static void testGetPropertyWrongID() {
        //given
        String recordId = 'qwwq34as';
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestUri ='https://yourInstance.my.salesforce.com/services/' +
                            'apexrest/property/' + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.getProperty();
        Test.stopTest();

        //then
        response = RestContext.response;
        Integer actual = response.statusCode;
        Integer expected = 400;
        System.assertEquals(expected,actual);
    }

    @IsTest static void testGetPropertyById_Negative() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        Id recordId = '0017R00002pQoyRQAS';
                RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestUri = 'https://yourInstance.my.salesforce.com/services/' +
                'apexrest/property/' + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.getProperty();
        Test.stopTest();

        //then
        response = RestContext.response;
        Integer actual = response.statusCode;
        Integer expected = 404;
        System.assertEquals(expected, actual);
    }

//Tests for POST method
    @IsTest static void testPostProperty() {
        //given
        String name = 'Barad-dur2';
        String title = 'Barad-dur apartments';
        String address = 'Address__c" : "13, Sauron str., Mordor';
        Id accountId = '0017R00002pQoyRQAS';
        Decimal price = 1000;
        Id type = '0127R0000011UrPQAU';

        RestResponse response = new RestResponse();
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.createProperty(name, title, address, accountId, price, type);
        Test.stopTest();

        //then
        Id recordId = [SELECT Id FROM Property__c].Id;
        response = RestContext.response;
        String actual = response.responseBody.toString().normalizeSpace();
        String expected = '{"attributes":{"type":"Property__c","url":"/services/data/v55.0/sobjects/Property__c/' +
                recordId + '"},"Name":"Barad-dur2","Property_Title__c":"Barad-dur apartments",' +
                '"Address__c":"Address__c\\" : \\"13, Sauron str., Mordor",' +
                '"Account__c":"0017R00002pQoyRQAS","Price__c":1000,"RecordTypeId":"0127R0000011UrPQAU",' +
                '"Id":"' + recordId + '"}';
        System.assertEquals(expected, actual);
    }

//Tests for PATCH method
    @IsTest static void testPatchProperty_Positive() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        Id recordId = [SELECT Id FROM Property__c LIMIT 1].Id;
        Decimal price = 2000;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://brave-goat-icrgm5-dev-ed.my.salesforce.com/services/' +
                'apexrest/property/' + recordId;
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.updateProperty(price);
        Test.stopTest();

        //then
        response = RestContext.response;
        String actual = response.responseBody.toString().normalizeSpace();
        String expected = '{"attributes":{"type":"Property__c",' +
                        '"url":"/services/data/v55.0/sobjects/Property__c/' + recordId + '"},' +
                        '"Id":"' + recordId + '","Price__c":2000}';

        System.assertEquals(expected, actual);
    }

    @IsTest static void testPatchProperty_Negative1() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        Id recordId = null;
        Decimal price = 2000;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://brave-goat-icrgm5-dev-ed.my.salesforce.com/services/' +
                'apexrest/property/' + recordId;
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.updateProperty(price);
        Test.stopTest();

        //then
        response = RestContext.response;
        Integer actual = response.statusCode;
        Integer expected = 400;
        System.assertEquals(expected, actual);
    }

    @IsTest static void testPatchProperty_Negative2() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        String recordId = 'rwtwt33t';
        Decimal price = 2000;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://brave-goat-icrgm5-dev-ed.my.salesforce.com/services/' +
                'apexrest/property/' + recordId;
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.updateProperty(price);
        Test.stopTest();

        //then
        response = RestContext.response;
        Integer actual = response.statusCode;
        Integer expected = 400;
        System.assertEquals(expected, actual);
    }

    @IsTest static void testPatchProperty_Negative3() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        Id recordId = '001R00002pQoyRQAS7';
        Decimal price = 2000;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://brave-goat-icrgm5-dev-ed.my.salesforce.com/services/' +
                'apexrest/property/' + recordId;
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.updateProperty(price);
        Test.stopTest();

        //then
        response = RestContext.response;
        Integer actual = response.statusCode;
        Integer expected = 404;
        System.assertEquals(expected, actual);
    }

//Tests for DELETE method
    @IsTest static void testDeleteProperty_Positive() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        Id recordId = [SELECT Id FROM Property__c LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://brave-goat-icrgm5-dev-ed.my.salesforce.com/services/' +
                'apexrest/property/' + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.deleteProperty();
        Test.stopTest();

        //then
        response = RestContext.response;
        property = [SELECT Id FROM Property__c WHERE Id = :recordId];
        System.assertEquals(true, property.isEmpty());
    }

    @IsTest static void testDeleteProperty_Negative1() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        Id recordId = null;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://brave-goat-icrgm5-dev-ed.my.salesforce.com/services/' +
                'apexrest/property/' + recordId;
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.deleteProperty();
        Test.stopTest();

        //then
        response = RestContext.response;
        Integer actual = response.statusCode;
        Integer expected = 400;
        System.assertEquals(expected, actual);
    }

    @IsTest static void testDeleteProperty_Negative2() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        String recordId = 'rwtwt33t';
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://brave-goat-icrgm5-dev-ed.my.salesforce.com/services/' +
                'apexrest/property/' + recordId;
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.deleteProperty();
        Test.stopTest();

        //then
        response = RestContext.response;
        Integer actual = response.statusCode;
        Integer expected = 400;
        System.assertEquals(expected, actual);
    }

    @IsTest static void testDeleteProperty_Negative3() {
        //given
        List<Property__c> property = TestDataFactory.ListProperties(1);
        insert property;
        Id recordId = '001R00002pQoyRQAS7';
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://brave-goat-icrgm5-dev-ed.my.salesforce.com/services/' +
                'apexrest/property/' + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        PropertyManager.deleteProperty();
        Test.stopTest();

        //then
        response = RestContext.response;
        Integer actual = response.statusCode;
        Integer expected = 404;
        System.assertEquals(expected, actual);
    }

}

