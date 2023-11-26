public without sharing class DataGeneratorService {
    private static Integer apartmentDescriptionIndex = 0;
    private static List<Contact> contacts = new List<Contact>();
    private static Map<String, ApartmentType__c> apartmentTypeMap = new Map<String, ApartmentType__c>();

    private static final Map<String, List<Double>> APARTMENT_GEOLOCATIONS = new Map<String, List<Double>>{
        'Cozy Holiday Retreat' => new List<Double>{ 40.7128, -74.0060 },
        'Seaside Getaway' => new List<Double>{ 34.0522, -118.2437 },
        'Mountain View Cabin' => new List<Double>{ 37.7749, -122.4194 },
        'Urban Loft' => new List<Double>{ 41.8781, -87.6298 },
        'Luxury Beach Villa' => new List<Double>{ 25.0343, -77.3963 },
        'Alpine Chalet' => new List<Double>{ 46.603354, 9.055010 },
        'City Center Apartment' => new List<Double>{ 51.5074, -0.1278 },
        'Riverside Retreat' => new List<Double>{ 37.7749, -122.4194 },
        'Cosmopolitan Penthouse' => new List<Double>{ 40.7128, -74.0060 },
        'Scenic Lake Cottage' => new List<Double>{ 44.9362, -93.2250 },
        'Sunny Beach House' => new List<Double>{ 35.6895, 139.6917 },
        'Charming Countryside Villa' => new List<Double>{ 48.8566, 2.3522 },
        'Tranquil Forest Lodge' => new List<Double>{ 47.3769, 8.5417 },
        'Historic Townhouse' => new List<Double>{ 52.5200, 13.4050 },
        'Modern Skyline Apartment' => new List<Double>{ 33.6844, -117.8265 },
        'Coastal Retreat' => new List<Double>{ 37.3541, -121.9552 },
        'Lakefront Haven' => new List<Double>{ 47.6062, -122.3321 },
        'Serenity Cottage' => new List<Double>{ 40.7128, -74.0060 },
        'Panoramic View Penthouse' => new List<Double>{ 37.7749, -122.4194 },
        'Mountain Serenity Cabin' => new List<Double>{ 47.6038, -122.3301 }
    };

    private static final Map<Integer, String> APARTMENT_DESCRIPTION_MAP = new Map<Integer, String>{
        0 => 'Experience the ultimate luxury at our spacious beachfront villa. Unwind in style and enjoy stunning ocean views from your private balcony.',
        1 => 'Stay in our charming beachside cottage, just a short walk from the sand. Enjoy coastal vibes and create memories by the waves.',
        2 => 'Escape to the mountains and cozy up in our charming cabin. Relax by the fireplace and explore the scenic trails just steps away.',
        3 => 'Stay in style at our modern city center apartment. Explore the vibrant neighborhood and immerse yourself in local culture.',
        4 => 'Discover the magic of our tropical oasis. Relax by the pool, sip cocktails on the patio, and enjoy the lush surroundings.',
        5 => 'Experience the allure of our luxurious ski chalet. Hit the slopes during the day, then warm up by the fireplace in the evening.',
        6 => 'Find bliss in our secluded forest lodge, surrounded by tall trees and wildlife. It\'s the perfect escape from the hustle and bustle.',
        7 => 'Unwind in our panoramic view penthouse, offering breathtaking vistas of the city skyline and the sparkling river below.',
        8 => 'Live the high life in our cosmopolitan penthouse. Experience breathtaking city views and upscale amenities for a truly memorable stay.',
        9 => 'Find peace in our serene lakefront cottage. Enjoy fishing, kayaking, and evenings by the fire pit under the starry sky.',
        10 => 'Experience the coastal lifestyle in our sunny beach house. Bask in the sun, surf the waves, and create lasting memories.',
        11 => 'Indulge in the tranquility of our countryside villa. Surrounded by lush gardens and picturesque landscapes, it\'s the perfect retreat.',
        12 => 'Find bliss in our secluded forest lodge, surrounded by tall trees and wildlife. It\'s the perfect escape from the hustle and bustle.',
        13 => 'Step back in time in our historic townhouse. Experience the charm of the past with modern comforts in the heart of the old city.',
        14 => 'Stay in style at our modern city center apartment. Explore the vibrant neighborhood and immerse yourself in local culture.',
        15 => 'Relax in our coastal retreat and soak up the sun on sandy beaches. Immerse yourself in beachside living with ocean breezes and stunning sunsets.',
        16 => 'Indulge in the luxury of our exquisite lakeside villa. Enjoy a private dock, water activities, and stunning sunrises.',
        17 => 'Relax in our charming cottage nestled by a bubbling brook. Enjoy the soothing sounds of nature and unwind in comfort.',
        18 => 'Unwind in our panoramic view penthouse, offering breathtaking vistas of the city skyline and the sparkling river below.',
        19 => 'Embrace the rustic elegance of our mountain serenity cabin. Reconnect with nature and savor the peaceful mountain atmosphere.'
    };

    private static final Map<String, List<String>> APARTMENT_TYPE_TO_PICTURE_PATHS_MAP = new Map<String, List<String>>{
        'beachfront' => new List<String>{
            '/resource/BeachfrontApartments/beach1.jpg',
            '/resource/BeachfrontApartments/beach2.jpg',
            '/resource/BeachfrontApartments/beach3.jpg',
            '/resource/BeachfrontApartments/beach4.jpg',
            '/resource/BeachfrontApartments/beach5.jpg'
        },
        'mountain_cabin' => new List<String>{
            '/resource/MountainCabins/cabin1.jpg',
            '/resource/MountainCabins/cabin2.jpg',
            '/resource/MountainCabins/cabin3.jpg',
            '/resource/MountainCabins/cabin4.jpg',
            '/resource/MountainCabins/cabin5.jpg'
        },
        'urban_loft' => new List<String>{
            '/resource/UrbanLofts/loft1.jpg',
            '/resource/UrbanLofts/loft2.jpg',
            '/resource/UrbanLofts/loft3.jpg',
            '/resource/UrbanLofts/loft4.jpg',
            '/resource/UrbanLofts/loft5.jpg'
        },
        'countryside_villa' => new List<String>{
            '/resource/CountrysideVillas/villa1.jpg',
            '/resource/CountrysideVillas/villa2.jpg',
            '/resource/CountrysideVillas/villa3.jpg',
            '/resource/CountrysideVillas/villa4.jpg',
            '/resource/CountrysideVillas/villa5.jpg'
        },
        'city_penthouse' => new List<String>{
            '/resource/CityPenthouses/penthouse1.jpg',
            '/resource/CityPenthouses/penthouse2.jpg',
            '/resource/CityPenthouses/penthouse3.jpg',
            '/resource/CityPenthouses/penthouse4.jpg',
            '/resource/CityPenthouses/penthouse5.jpg'
        },
        'lake_cottage' => new List<String>{
            '/resource/LakeCottages/cottage1.jpg',
            '/resource/LakeCottages/cottage2.jpg',
            '/resource/LakeCottages/cottage3.jpg',
            '/resource/LakeCottages/cottage4.jpg',
            '/resource/LakeCottages/cottage5.jpg'
        },
        'historic_townhouse' => new List<String>{
            '/resource/HistoricTownhouses/townhouse1.jpg',
            '/resource/HistoricTownhouses/townhouse2.jpg',
            '/resource/HistoricTownhouses/townhouse3.jpg',
            '/resource/HistoricTownhouses/townhouse4.jpg',
            '/resource/HistoricTownhouses/townhouse5.jpg'
        },
        'coastal_retreat' => new List<String>{
            '/resource/CoastalRetreats/retreat1.jpg',
            '/resource/CoastalRetreats/retreat2.jpg',
            '/resource/CoastalRetreats/retreat3.jpg',
            '/resource/CoastalRetreats/retreat4.jpg',
            '/resource/CoastalRetreats/retreat5.jpg'
        },
        'skyline_apartment' => new List<String>{
            '/resource/SkylineApartments/apartment1.jpg',
            '/resource/SkylineApartments/apartment2.jpg',
            '/resource/SkylineApartments/apartment3.jpg',
            '/resource/SkylineApartments/apartment4.jpg',
            '/resource/SkylineApartments/apartment5.jpg'
        }
    };

    public static void init() {
        if(![SELECT Id FROM Apartment__c LIMIT 1].isEmpty()) {
            deleteOldData();
        }
        generateNewData();
    }

    private static void deleteOldData() {
        delete [SELECT Id FROM Opportunity];
        delete [SELECT Id FROM Case];
        delete [SELECT Id FROM Account];
        delete [SELECT Id FROM Contact];
        delete [SELECT Id FROM Apartment__c];
        delete [SELECT Id FROM ApartmentType__c];
        delete [SELECT Id FROM ApartmentReview__c];
        delete [SELECT Id FROM ApartmentReservation__c];
        delete [SELECT Id FROM ApartmentRoom__c];
    }

    private static void generateNewData() {
        contacts = insertAccountAndContactsAndGetContacts();
        apartmentTypeMap = insertApartmentTypesAndGetApartmentTypesMap();
        insertApartments();
        if(!Test.isRunningTest()) {
            insertApartmentRooms();
        }
    }

    private static void insertApartments() {
        List<Apartment__c> apartmentsToInsert = new List<Apartment__c>();

        for (String apartmentName : APARTMENT_GEOLOCATIONS.keySet()) {
            Contact randomContact = contacts[getRandomInteger(0, (contacts.size() - 1))];

            List<String> castKeys = new List<String>(APARTMENT_TYPE_TO_PICTURE_PATHS_MAP.keySet());
            String apartmentType = castKeys[getRandomInteger(0, (castKeys.size() - 1))];

            List<Double> latitudeAndLongitude = APARTMENT_GEOLOCATIONS.get(apartmentName);

            List<String> resourcePaths = APARTMENT_TYPE_TO_PICTURE_PATHS_MAP.get(apartmentType);
            String picturePath = resourcePaths[getRandomInteger(0, (resourcePaths.size() - 1))];

            Apartment__c apartment = new Apartment__c(
                Name = apartmentName,
                Contact__c = randomContact.Id,
                ApartmentType__c = apartmentTypeMap.get(apartmentType).Id,
                Year_Built__c = getRandomInteger(2000, 2020),
                Picture__c = picturePath,
                Description__c = getNextApartmentDescription(),
                Geolocation__Latitude__s = latitudeAndLongitude[0],
                Geolocation__Longitude__s = latitudeAndLongitude[1]
            );
            apartmentsToInsert.add(apartment);
        }
        insert apartmentsToInsert;
        if(!Test.isRunningTest()) {
            GeolocationDecoder.setApartmentCountries();
        }
    }

    private static String getNextApartmentDescription() {
        if (apartmentDescriptionIndex > APARTMENT_DESCRIPTION_MAP.size() - 1) {
            apartmentDescriptionIndex = 0;
        }

        return APARTMENT_DESCRIPTION_MAP.get(apartmentDescriptionIndex++);
    }

    private static List<Contact> insertAccountAndContactsAndGetContacts() {
        List<Contact> contactsToInsert = new List<Contact>();

        Account newAccount = new Account(Name = 'House Rental Account', BillingCity = 'San Francisco', BillingCountry = 'California');
        insert newAccount;

        Contact contact1 = new Contact(FirstName = 'Jamie', LastName = 'Powell', AccountId = newAccount.Id, Email = 'jamie@example.com');
        contactsToInsert.add(contact1);

        Contact contact2 = new Contact(FirstName = 'Gayatri', LastName = 'Bhatt', AccountId = newAccount.Id, Email = 'gayatri@example.com');
        contactsToInsert.add(contact2);

        Contact contact3 = new Contact(FirstName = 'Aaron', LastName = 'Gray', AccountId = newAccount.Id, Email = 'aaron@example.com');
        contactsToInsert.add(contact3);

        Contact contact4 = new Contact(
            FirstName = 'Emanuel',
            LastName = 'Manzanares',
            AccountId = newAccount.Id,
            Email = 'emanuel@example.com'
        );
        contactsToInsert.add(contact4);

        Contact contact5 = new Contact(FirstName = 'Rachel', LastName = 'King', AccountId = newAccount.Id, Email = 'rachel@example.com');
        contactsToInsert.add(contact5);

        Contact contact6 = new Contact(
            FirstName = 'Takuya',
            LastName = 'Watanabe',
            AccountId = newAccount.Id,
            Email = 'takuya@example.com'
        );
        contactsToInsert.add(contact6);

        Contact contact7 = new Contact(
            FirstName = 'Byanca',
            LastName = 'Goncalves',
            AccountId = newAccount.Id,
            Email = 'byanca@example.com'
        );
        contactsToInsert.add(contact7);

        Contact contact8 = new Contact(FirstName = 'Liam', LastName = 'Bates', AccountId = newAccount.Id, Email = 'Liam@example.com');
        contactsToInsert.add(contact8);

        Contact contact9 = new Contact(FirstName = 'Skye', LastName = 'Taylor', AccountId = newAccount.Id, Email = 'skye@example.com');
        contactsToInsert.add(contact9);

        Contact contact10 = new Contact(FirstName = 'Millie', LastName = 'Brooks', AccountId = newAccount.Id, Email = 'millie@example.com');

        contactsToInsert.add(contact10);

        Contact contact11 = new Contact(FirstName = 'Jose', LastName = 'Weimar', AccountId = newAccount.Id, Email = 'weimar@example.com');

        contactsToInsert.add(contact11);

        Contact contact12 = new Contact(FirstName = 'James', LastName = 'August', AccountId = newAccount.Id, Email = 'james@example.com');

        contactsToInsert.add(contact12);

        Contact contact13 = new Contact(
            FirstName = 'Solange',
            LastName = 'Pereira',
            AccountId = newAccount.Id,
            Email = 'solange@example.com'
        );

        contactsToInsert.add(contact13);

        Contact contact14 = new Contact(
            FirstName = 'Matheus',
            LastName = 'Henrique',
            AccountId = newAccount.Id,
            Email = 'matheus@example.com'
        );

        contactsToInsert.add(contact14);

        Contact contact15 = new Contact(
            FirstName = 'Ronaldo',
            LastName = 'Nazario',
            AccountId = newAccount.Id,
            Email = 'ronaldo@example.com'
        );

        contactsToInsert.add(contact15);

        insert contactsToInsert;
        return contactsToInsert;
    }

    private static void insertApartmentRooms() {
        List<ApartmentRoom__c> apartmentRoomsToInsert = new List<ApartmentRoom__c>();
        Integer roomsNumber;
        Integer capacity;
        
        for (Apartment__c apartment : [SELECT Id, Name, ApartmentType__r.Name FROM Apartment__c]) {
            roomsNumber = getRandomInteger(1, 4);
            
            for (Integer i = 1; i <= roomsNumber; i++) { 
                capacity = getRandomInteger(1, 6);
                ApartmentRoom__c room = new ApartmentRoom__c(
                    Name = capacity + ' Person Room',
                    Description__c = 'This is Room ' + i + ' in ' + apartment.Name + '.',
                    Capacity__c = capacity,
                    Price_Per_Night__c = getPriceForApartmentType(apartment.ApartmentType__r.Name) * capacity,
                    Apartment__c = apartment.Id
                );
                apartmentRoomsToInsert.add(room);
            }
        }

        insert apartmentRoomsToInsert;
    }

    private static Map<String, ApartmentType__c> insertApartmentTypesAndGetApartmentTypesMap() {
        List<ApartmentType__c> apartmentTypesToInsert = new List<ApartmentType__c>(); 
        ApartmentType__c beachfront = new ApartmentType__c(Name = 'Beachfront');
        apartmentTypesToInsert.add(beachfront);

        ApartmentType__c mountainCabin = new ApartmentType__c(Name = 'Mountain Cabin');
        apartmentTypesToInsert.add(mountainCabin);

        ApartmentType__c urbanLoft = new ApartmentType__c(Name = 'Urban Loft');
        apartmentTypesToInsert.add(urbanLoft);

        ApartmentType__c countrysideVilla = new ApartmentType__c(Name = 'Countryside Villa');
        apartmentTypesToInsert.add(countrysideVilla);

        ApartmentType__c cityPenthouse = new ApartmentType__c(Name = 'City Penthouse');
        apartmentTypesToInsert.add(cityPenthouse);

        ApartmentType__c lakeCottage = new ApartmentType__c(Name = 'Lake Cottage');
        apartmentTypesToInsert.add(lakeCottage);

        ApartmentType__c historicTownhouse = new ApartmentType__c(Name = 'Historic Townhouse');
        apartmentTypesToInsert.add(historicTownhouse);

        ApartmentType__c coastalRetreat = new ApartmentType__c(Name = 'Coastal Retreat');
        apartmentTypesToInsert.add(coastalRetreat);

        ApartmentType__c skylineApartment = new ApartmentType__c(Name = 'Skyline Apartment');
        apartmentTypesToInsert.add(skylineApartment);

        insert apartmentTypesToInsert;
        Map<String, ApartmentType__c> apartmentTypeNameMap = new Map<String, ApartmentType__c>{
            'beachfront' => beachfront,
            'mountain_cabin' => mountainCabin,
            'urban_loft' => urbanLoft,
            'countryside_villa' => countrysideVilla,
            'city_penthouse' => cityPenthouse,
            'lake_cottage' => lakeCottage,
            'historic_townhouse' => historicTownhouse,
            'coastal_retreat' => coastalRetreat,
            'skyline_apartment' => skylineApartment
        };

        return apartmentTypeNameMap;
    }

    public static Integer getPriceForApartmentType(String apartmentType) {
        Map<String, Integer> apartmentTypeToPricePerNight = new Map<String, Integer>{
            'Beachfront' => getRandomInteger(200, 60),
            'Mountain Cabin' => getRandomInteger(150, 400),
            'Urban Loft' => getRandomInteger(180, 500),
            'Countryside Villa' => getRandomInteger(250, 700),
            'City Penthouse' => getRandomInteger(150, 400),
            'Lake Cottage' => getRandomInteger(60, 200),
            'Historic Townhouse' => getRandomInteger(280, 750),
            'Coastal Retreat' => getRandomInteger(300, 800),
            'Skyline Apartment' => getRandomInteger(400, 1000),
            '' => 500
        };

        return apartmentTypeToPricePerNight.get(apartmentType);
    }

    private static Integer getRandomInteger(Integer min, Integer max) {
        return Math.round(Math.random() * (max - min) + min);
    }
}
