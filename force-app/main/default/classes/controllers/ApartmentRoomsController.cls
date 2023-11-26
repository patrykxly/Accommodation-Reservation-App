public without sharing class ApartmentRoomsController {
    @AuraEnabled(cacheable=true)
    public static List<ApartmentRoom__c> getRoomsByApartmentId(Id apartmentId){
        return [SELECT Name, Apartment__c, Description__c, Capacity__c, Price_Per_Night__c FROM ApartmentRoom__c WHERE Apartment__c =: apartmentId];
    }
}