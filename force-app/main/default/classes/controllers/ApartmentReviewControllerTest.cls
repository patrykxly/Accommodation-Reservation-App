@isTest
public with sharing class ApartmentReviewControllerTest {
    @TestSetup
    static void setup(){
        DataGeneratorService.init();    
    }

    @isTest
    static void testGetReviewsByApartmentId() {
        Apartment__c apartment = [SELECT Id FROM Apartment__c LIMIT 1];
        insert new ApartmentReview__c(Apartment__c = apartment.Id, Comment__c = 'test', Rating__c = 5);
        List<apartmentReview__c> reviews = ApartmentReviewController.getReviewsByApartmentId(apartment.Id);

        Assert.areEqual(1, reviews.size());
    }
}