@isTest
private class GeolocationDecoderTest {
    @testVisible
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"address": {"country": "TestCountry"}}');
            return res;
        }
    }

    @isTest
    static void testSetApartmentCountries() {
        Contact testContact = new Contact(FirstName='John', LastName = 'Doe');
        insert testContact;

        insert new Apartment__c(Name = 'TestApartment', Geolocation__Latitude__s = 0.0, Geolocation__Longitude__s = 0.0, Contact__c = testContact.Id);

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        Test.startTest();
        GeolocationDecoder.setApartmentCountries();
        Test.stopTest();

        Apartment__c updatedApartment = [SELECT Country__c FROM Apartment__c LIMIT 1];
        Assert.areEqual('TestCountry', updatedApartment.Country__c);
    }
}