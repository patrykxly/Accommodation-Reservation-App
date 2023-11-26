@isTest
public with sharing class ApartmentSearchControllerTest {
    private static final String SYSTEM_ADMINISTRATOR = 'System Administrator';

    @TestSetup
    static void setup(){
        DataGeneratorService.init();
    }

    @isTest
    static void ApartmentSearchControllerTest() {
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = :SYSTEM_ADMINISTRATOR];
        String email = 'systemadminuser' + System.now().getTime() + '@testred.com';
        User adminUser = new User(
            Alias = 'sysad',
            Email = email,
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = adminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = email
        );

        System.runAs(adminUser) {
            Assert.areEqual(SYSTEM_ADMINISTRATOR, ApartmentSearchController.getCurrentUserProfile());
        }
    }

    @isTest
    static void testGetApartmentReservations() {
        insert new ApartmentReservation__c(Apartment__c = [SELECT Id FROM Apartment__c LIMIT 1].Id, DateFrom__c = Date.today(), DateTo__c = Date.today(), Price__c = 100);
        List<ApartmentReservation__c> reservations = ApartmentSearchController.getAllReservations();

        Assert.areEqual(1, reservations.size());
    }

    @isTest
    static void testGetApartmentRooms() {
        Apartment__c apartment = [SELECT Id FROM Apartment__c LIMIT 1];
        insert new ApartmentRoom__c(Apartment__c = apartment.Id, Capacity__c = 5, Description__c = 'test', Price_Per_Night__c = 100, Name = 'test');

        Assert.areEqual(1, ApartmentSearchController.getAllRooms().size());
    }

    @isTest
    static void testGetApartmentsByLocation() {
        List<Apartment__c> apartment = [
            SELECT Id, Geolocation__Latitude__s, Geolocation__Longitude__s, apartmentType__r.Id
            FROM Apartment__c
            LIMIT 1
        ];
        List<Object> apartmentsByLocation = (List<Object>) JSON.deserializeUntyped(
            ApartmentSearchController.getApartmentsByLocation(
                apartment.get(0).Geolocation__Latitude__s,
                apartment.get(0).Geolocation__Longitude__s,
                apartment.get(0).apartmentType__r.Id
            )
        );
        List<Apartment__c> apartmentsExpected = [
            SELECT Id
            FROM Apartment__c
            WHERE apartmentType__c = :apartment.get(0).apartmentType__r.Id
            ORDER BY
                DISTANCE(
                    Geolocation__c,
                    GEOLOCATION(:apartment.get(0).Geolocation__Latitude__s, :apartment.get(0).Geolocation__Longitude__s),
                    'mi'
                )
            LIMIT 10
        ];

        Assert.areEqual(1, apartment.size());
        Assert.areEqual(
            apartmentsExpected.size(),
            apartmentsByLocation.size()
        );
    }
}
