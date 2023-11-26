@isTest
public with sharing class ApartmentRoomsControllerTest {
    @TestSetup
    static void setup(){
        DataGeneratorService.init();
    }

    @isTest
    static void testGetApartmentRoomsByApartmentId() {
        Apartment__c apartment = [SELECT Id FROM Apartment__c LIMIT 1];
        insert new ApartmentRoom__c(Apartment__c = apartment.Id, Capacity__c = 5, Description__c = 'test', Price_Per_Night__c = 100, Name = 'test');
        List<ApartmentRoom__c> rooms = apartmentDataService.getRoomsByApartmentId(apartment.Id);

        Assert.areEqual(1, rooms.size());
        Assert.areEqual(apartment.Id, rooms.get(0).Apartment__c);
    }
}