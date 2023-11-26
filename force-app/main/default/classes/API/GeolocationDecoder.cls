public with sharing class GeolocationDecoder {
    @future(callout = true)
    public static void setApartmentCountries() {
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            List<Apartment__c> apartments = [SELECT Geolocation__Latitude__s, Geolocation__Longitude__s FROM Apartment__c];

            for(Apartment__c apartment: apartments) {
                request.setEndpoint('https://geocode.maps.co/reverse?lat=' + apartment.Geolocation__Latitude__s + '&lon=' + apartment.Geolocation__Longitude__s);
                HttpResponse response = http.send(request);

                if(response.getStatusCode() == 200) {
                    Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    apartment.Country__c = (String) ((Map<String, Object>) payload.get('address')).get('country');
                }
            }

            update apartments;
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}