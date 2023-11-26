@isTest
private class DataGeneratorServiceTests {
    @isTest
    static void initTest() {
        Test.startTest();
        DataGeneratorService.init();
        Test.stopTest();

        Assert.isTrue([SELECT COUNT() FROM Apartment__c] > 0, 'No Apartment__c were found');
        Assert.isTrue([SELECT COUNT() FROM ApartmentType__c] > 0, 'No ApartmentType__c were found');
        Assert.isTrue([SELECT COUNT() FROM Account] > 0, 'No Account was found');
        Assert.isTrue([SELECT COUNT() FROM Contact] > 0, 'No Contacts found');
    }

    @isTest
    static void getPriceForApartmentTypeNoTypeTest() {
        Assert.areEqual(500, DataGeneratorService.getPriceForApartmentType(''), 'The apartment price was calculated wrongly.');
    }
}
