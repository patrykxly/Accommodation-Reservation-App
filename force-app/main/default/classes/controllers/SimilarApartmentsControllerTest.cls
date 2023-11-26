@isTest
private class SimilarApartmentsControllerTest {
    @testSetup
    static void setup() {
        Test.startTest();
        DataGeneratorService.init();
        Test.stopTest();
    }

    @isTest
    static void getSimilarApartmentsByCountryTest() {
        List<ApartmentType__c> apartmentTypes = ApartmentDataService.getApartmentTypes();

        List<Apartment__c> apartmentsByType = SimilarApartmentsController.getSimilarApartments(
            [SELECT Id FROM Apartment__c LIMIT 1].Id,
            SimilarApartmentsController.COUNTRY_TYPE
        );

        Assert.isFalse(apartmentTypes.isEmpty(), 'The there are no apartment Type records.');
        Assert.isFalse(
            apartmentsByType.isEmpty(),
            'The similar Apartments by type query did not return the right amount.'
        );
    }

    @isTest
    static void getSimilarApartmentsByTypeTest() {
        List<ApartmentType__c> apartmentTypes = ApartmentDataService.getApartmentTypes();

        List<Apartment__c> apartmentsByType = SimilarApartmentsController.getSimilarApartments(
            [SELECT Id FROM Apartment__c LIMIT 1].Id,
            SimilarApartmentsController.TYPE_TYPE
        );

        Assert.isFalse(apartmentTypes.isEmpty(), 'The there are no apartment Type records.');
        Assert.isFalse(
            apartmentsByType.isEmpty(),
            'The similar Apartments by type query did not return the right amount.'
        );
    }

    @isTest
    static void getSimilarApartmentsParentApartmentEmptyTest() {
        Assert.isTrue(SimilarApartmentsController.getSimilarApartments(null, '').isEmpty(), 'The similar Apartments should be empty.');
    }
}
