public class SimilarApartmentsController {
    public static final String COUNTRY_TYPE = 'Country';
    public static final String TYPE_TYPE = 'Type';
    public static Apartment__c parentApartment;

    @AuraEnabled(cacheable=true)
    public static List<Apartment__c> getSimilarApartments(Id apartmentId, String similarBy) {
        parentApartment = [
            SELECT Id, ApartmentType__c, ApartmentType__r.Name, Country__c
            FROM Apartment__c
            WHERE Id = :apartmentId
            LIMIT 1
        ];
        List<Apartment__c> similarApartments = new List<Apartment__c>();

        if (parentApartment == null) {
            return similarApartments;
        } else if (similarBy == COUNTRY_TYPE) {
            similarApartments = getSimilarApartmentsByCountry();
        } else if (similarBy == TYPE_TYPE) {
            similarApartments = getSimilarApartmentsByApartmentType();
        }
        return similarApartments;
    }
    
    private static List<Apartment__c> getSimilarApartmentsByCountry() {
        return [
            SELECT Id, Contact__r.Name, Name, ApartmentType__c, ApartmentType__r.Name, Picture__c, Country__c, Year_Built__c
            FROM Apartment__c
            WHERE Id != :parentApartment.Id AND Country__c =: parentApartment.Country__c
            ORDER BY Year_Built__c
            LIMIT 5
        ];
    }

    private static List<Apartment__c> getSimilarApartmentsByApartmentType() {
        return [
            SELECT Id, Contact__r.Name, Name, ApartmentType__c, ApartmentType__r.Name, Picture__c, Country__c, Year_Built__c
            FROM Apartment__c
            WHERE Id != :parentApartment.Id AND ApartmentType__c = :parentApartment.ApartmentType__c
            ORDER BY Year_Built__c
        ];
    }
}
