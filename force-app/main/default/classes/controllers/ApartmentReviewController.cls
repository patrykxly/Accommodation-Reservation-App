public without sharing class ApartmentReviewController {
    @AuraEnabled(cacheable=true)
    public static List<ApartmentReview__c> getReviewsByApartmentId(Id apartmentId) {
        return [
            SELECT
                Id,
                Name,
                Comment__c,
                Rating__c,
                LastModifiedDate,
                CreatedDate,
                CreatedBy.Name,
                CreatedBy.SmallPhotoUrl,
                CreatedBy.CompanyName
            FROM ApartmentReview__c
            WHERE Apartment__c = :apartmentId
            ORDER BY CreatedDate DESC
        ];
    }
}