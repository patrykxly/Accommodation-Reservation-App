public without sharing class ApartmentSearchController {
    @AuraEnabled(cacheable=true)
    public static String getCurrentUserProfile() {
        return [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1].Name;
    }

    @AuraEnabled(cacheable=true)
    public static List<ApartmentReservation__c> getAllReservations() {
        return [SELECT Apartment__c, DateFrom__c, DateTo__c, ApartmentRoom__c FROM ApartmentReservation__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<ApartmentRoom__c> getAllRooms(){
        return [SELECT Name, Apartment__c, Description__c, Capacity__c, Price_Per_Night__c FROM ApartmentRoom__c];
    }

    @AuraEnabled(cacheable=true)
    public static String getApartmentsByLocation(Decimal latitude, Decimal longitude, String apartmentTypeId) {
        String query = 'SELECT Name, Geolocation__Latitude__s, Geolocation__Longitude__s FROM Apartment__c ';
        if (String.isNotBlank(apartmentTypeId)) {
            query += 'WHERE ApartmentType__c = :apartmentTypeId ';
        }
        query += ' WITH SECURITY_ENFORCED ORDER BY DISTANCE(Geolocation__c, GEOLOCATION(:latitude, :longitude), \'mi\') LIMIT 10';
        return JSON.serialize(Database.query(query));
    }
}
