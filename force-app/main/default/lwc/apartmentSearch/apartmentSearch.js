import { LightningElement, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import labels from "./customLabels";
import getCurrentUserProfile from "@salesforce/apex/ApartmentSearchController.getCurrentUserProfile";
import getApartments from "@salesforce/apex/ApartmentDataService.getApartments";
import getAllReservations from "@salesforce/apex/ApartmentSearchController.getAllReservations";
import getAllRooms from "@salesforce/apex/ApartmentSearchController.getAllRooms";

const SYSTEM_ADMINISTRATOR = "System Administrator";
const MAX_WIRES_NUMBER = 4;

export default class ApartmentSearch extends NavigationMixin(LightningElement) {
  isLoading = true;
  filtersLoaded = false;
  labels = labels;
  wiresNumber = 0;
  profileName;
  wiredApartmentsResult;
  wiredReservationsResult;
  wiredRoomsResult;
  apartments;
  filteredApartments;
  filtersOptions;

  get shouldDisplayAddButton() {
    return this.profileName === SYSTEM_ADMINISTRATOR;
  }

  get dataLoaded() {
    return (
      this.wiredReservationsResult.data &&
      this.wiredApartmentsResult.data &&
      this.wiredRoomsResult.data
    );
  }

  @wire(getCurrentUserProfile)
  wiredProfile({ error, data }) {
    if (data) {
      this.profileName = data;
    } else if (error) {
      console.error(error);
    }
  }

  @wire(getAllReservations)
  wiredReservations(value) {
    this.handleLoading();
    this.wiredReservationsResult = value;
    this.handleDoneLoading();
  }

  @wire(getAllRooms)
  wiredRooms(value) {
    this.handleLoading();
    this.wiredRoomsResult = value;
    this.handleDoneLoading();
  }

  @wire(getApartments)
  wiredApartments(value) {
    this.handleLoading();
    this.wiredApartmentsResult = value;
    const { data, error } = value;

    if (data) {
      this.apartments = data;
    } else if (error) {
      console.error(error);
    }

    this.handleDoneLoading();
  }

  createApartment() {
    this[NavigationMixin.Navigate]({
      type: "standard__objectPage",
      attributes: {
        objectApiName: "Apartment__c",
        actionName: "new"
      }
    });
  }

  handleFilterLoad(event) {
    this.filtersOptions = event.detail.filtersOptions;
    this.filtersLoaded = true;
  }

  filterApartments(event) {
    this.isLoading = true;
    this.apartments = this.template
      .querySelector("c-apartment-filters")
      .filterApartments(event);

    this.isLoading = false;
  }

  handleLoading() {
    this.isLoading = true;
    this.wiresNumber++;
  }

  handleDoneLoading() {
    if (this.wiresNumber === MAX_WIRES_NUMBER) {
      this.isLoading = false;
    }
  }
}
