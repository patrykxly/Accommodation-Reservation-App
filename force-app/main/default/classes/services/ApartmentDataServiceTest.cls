@isTest
private class ApartmentDataServiceTest {
    @testSetup
    static void setup() {
        Test.startTest();
        DataGeneratorService.init();
        Test.stopTest();
    }

    @isTest
    static void testGetApartments() {
        List<Apartment__c> apartmentsToTest = apartmentDataService.getApartments();
        List<Apartment__c> apartmentsWithIdExpected = [SELECT Id FROM Apartment__c];

        Assert.areEqual(
            apartmentsWithIdExpected.size(),
            apartmentsToTest.size()
        );
    }

    @isTest
    static void getGetApartmentTypes() {
        List<ApartmentType__c> apartmentTypesToTest = apartmentDataService.getApartmentTypes();
        List<ApartmentType__c> apartmentTypesWithIdExpected = [SELECT Id FROM ApartmentType__c];

        Assert.areEqual(
            apartmentTypesWithIdExpected.size(),
            apartmentTypesToTest.size()
        );
    }
}
