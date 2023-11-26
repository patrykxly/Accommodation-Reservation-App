public without sharing class ApartmentDataService {
    @AuraEnabled(cacheable=true)
    public static List<Apartment__c> getApartments() {
        return [
            SELECT
                Name,
                Description__c,
                Geolocation__Latitude__s,
                Geolocation__Longitude__s,
                Country__c,
                Picture__c,
                Year_Built__c,
                Contact__r.Name,
                ApartmentType__c,
                ApartmentType__r.Name
            FROM Apartment__c
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<ApartmentType__c> getApartmentTypes() {
        return [SELECT Name, Id FROM ApartmentType__c ORDER BY Name];
    }

    @AuraEnabled
    public static void updateApartmentList(Object data) {
        update (List<Apartment__c>) JSON.deserialize(JSON.serialize(data), List<Apartment__c>.class);
    }
}