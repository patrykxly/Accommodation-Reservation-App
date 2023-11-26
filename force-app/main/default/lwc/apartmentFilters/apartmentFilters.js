import { LightningElement, api } from "lwc";

const DATE_FROM = "dateFrom";
const DATE_TO = "dateTo";

export default class ApartmentFilters extends LightningElement {
  @api apartments;
  @api filterOptions;
  @api reservations;
  @api rooms;

  filterToFilterValue = {
    name: "",
    types: "",
    prices: "",
    capacities: "",
    countries: "",
    dateFrom: "",
    dateTo: ""
  };

  renderedCallback() {
    this.dispatchEvent(
      new CustomEvent("filterload", {
        detail: {
          filtersOptions: this.getFilterOptions()
        }
      })
    );
  }

  @api
  filterApartments(event) {
    this.filterToFilterValue[event.detail.filterBy] = event.detail.filterValue;
    return this.apartments.filter((apartment) => this.checkFilters(apartment));
  }

  getFilterOptions() {
    return [
      {
        types: this.getUniqueApartmentTypesFilterOptions()
      },
      {
        prices: this.getPricesFilterOptions()
      },
      {
        capacities: this.getCapacitiesFilterOptions()
      },
      {
        countries: this.getUniqueCountriesFilterOptions()
      }
    ];
  }

  getUniqueApartmentTypesFilterOptions() {
    return [].concat(
      { label: "Any Type", value: "" },
      [
        ...new Set(
          this.apartments
            .map((apartment) => ({
              label: `${apartment.ApartmentType__r.Name}`,
              value: `${apartment.ApartmentType__r.Name}`
            }))
            .map(JSON.stringify)
        )
      ].map(JSON.parse)
    );
  }

  getUniqueCountriesFilterOptions() {
    return [].concat(
      { label: "Any Country", value: "" },
      [
        ...new Set(
          this.apartments
            .map((apartment) => ({
              label: `${apartment.Country__c}`,
              value: `${apartment.Country__c}`
            }))
            .map(JSON.stringify)
        )
      ].map(JSON.parse)
    );
  }

  getPricesFilterOptions() {
    let priceRangesFilter = [{ label: "Any Price", value: "" }];
    const maxPrice = Math.max(
      ...this.rooms.map((room) => room.Price_Per_Night__c)
    );

    for (let start = 1; start <= maxPrice; start += 200) {
      const end = Math.min(start + 200 - 1, Math.ceil(maxPrice / 100) * 100);

      priceRangesFilter = this.getMappedFiltersArray(
        priceRangesFilter,
        `${start}-${end}`
      );
    }
    return priceRangesFilter;
  }

  getCapacitiesFilterOptions() {
    let capacitiesFilter = [{ label: "Any Capacity", value: "" }];
    const maxCapacity = Math.max(...this.rooms.map((room) => room.Capacity__c));

    for (let capacityNum = 1; capacityNum <= maxCapacity; capacityNum++) {
      capacitiesFilter = this.getMappedFiltersArray(
        capacitiesFilter,
        capacityNum
      );
    }

    return capacitiesFilter;
  }

  getMappedFiltersArray(filtersArray, label) {
    return [...filtersArray, { label: `${label}`, value: `${label}` }];
  }

  checkFilters(apartment) {
    return (
      this.checkNameFilter(apartment) &&
      this.checkTypeFilter(apartment) &&
      this.checkPriceFilter(apartment) &&
      this.checkCapacityFilter(apartment) &&
      this.checkCountryFilter(apartment) &&
      this.checkDateFilter(apartment)
    );
  }

  checkNameFilter(apartment) {
    return (
      !this.filterToFilterValue.name ||
      apartment.Name.toLowerCase().includes(
        this.filterToFilterValue.name.toLowerCase()
      )
    );
  }

  checkTypeFilter(apartment) {
    return (
      !this.filterToFilterValue.types ||
      apartment.ApartmentType__r.Name === this.filterToFilterValue.types
    );
  }

  checkCountryFilter(apartment) {
    return (
      !this.filterToFilterValue.countries ||
      apartment.Country__c === this.filterToFilterValue.countries
    );
  }

  checkDateFilter(apartment) {
    const apartmentReservations = this.reservations.filter(
      (reservation) => reservation.Apartment__c === apartment.Id
    );

    return (
      !apartmentReservations.length ||
      (!this.filterToFilterValue[DATE_FROM] &&
        !this.filterToFilterValue[DATE_TO]) ||
      this.isDateAvailable(apartment, apartmentReservations)
    );
  }

  isDateAvailable(apartment, apartmentReservations) {
    const apartmentRooms = this.getApartmentRoomsFilteredByCapacity(apartment);

    const uniqueRoomsFromApartmentReservations = new Set(
      apartmentReservations.map((reservation) => reservation.ApartmentRoom__c)
    );
    return (
      (this.isOtherRoomAvailable(
        apartmentRooms,
        uniqueRoomsFromApartmentReservations
      ) &&
        this.isSomeNotReservedRoomWithProperCapacityAvailable(
          apartmentRooms,
          uniqueRoomsFromApartmentReservations
        )) ||
      apartmentReservations.some(
        (reservation) =>
          !(
            (this.filterToFilterValue.dateFrom >= reservation.DateFrom__c &&
              this.filterToFilterValue.dateFrom <= reservation.DateTo__c) ||
            (this.filterToFilterValue.dateTo >= reservation.DateFrom__c &&
              this.filterToFilterValue.dateTo <= reservation.DateTo__c) ||
            (this.filterToFilterValue.dateFrom <= reservation.DateFrom__c &&
              this.filterToFilterValue.dateTo >= reservation.DateTo__c)
          )
      )
    );
  }

  isOtherRoomAvailable(apartmentRooms, uniqueRoomsFromApartmentReservations) {
    return !(
      apartmentRooms.length === uniqueRoomsFromApartmentReservations.length
    );
  }

  isSomeNotReservedRoomWithProperCapacityAvailable(
    apartmentRooms,
    uniqueRoomsFromApartmentReservations
  ) {
    return apartmentRooms
      .filter((room) => !uniqueRoomsFromApartmentReservations.has(room.Id))
      .some((room) => room.Capacity__c >= this.filterToFilterValue.capacities);
  }

  checkPriceFilter(apartment) {
    const apartmentRooms = this.getApartmentRoomsFilteredByCapacity(apartment);
    const [minPrice, maxPrice] = this.filterToFilterValue.prices.split("-");

    return (
      !this.filterToFilterValue.prices ||
      apartmentRooms.some(
        (room) =>
          room.Price_Per_Night__c >= minPrice &&
          room.Price_Per_Night__c <= maxPrice
      )
    );
  }

  checkCapacityFilter(apartment) {
    const apartmentRooms = this.getApartmentsRooms(apartment);
    return (
      !this.filterToFilterValue.capacities ||
      apartmentRooms.some(
        (room) =>
          room.Capacity__c >= Number(this.filterToFilterValue.capacities)
      )
    );
  }

  getApartmentsRooms(apartment) {
    return this.rooms.filter((room) => room.Apartment__c === apartment.Id);
  }

  getApartmentRoomsFilteredByCapacity(apartment) {
    let apartmentRooms = this.rooms.filter(
      (room) => room.Apartment__c === apartment.Id
    );

    const chosenCapacity = Number(this.filterToFilterValue.capacities);
    if (chosenCapacity) {
      apartmentRooms = apartmentRooms.filter(
        (room) => room.Capacity__c >= Number(chosenCapacity)
      );
    }

    return apartmentRooms;
  }
}
