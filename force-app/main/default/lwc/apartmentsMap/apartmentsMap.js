import { LightningElement, wire, api } from "lwc";
import getApartmentsByLocation from "@salesforce/apex/ApartmentSearchController.getApartmentsByLocation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import labels from "./customLabels";

const ICON_STANDARD_USER = "standard:user";
const ERROR_VARIANT = "error";

export default class ApartmentsMap extends LightningElement {
  mapMarkers = [];
  isLoading = true;
  labels = labels;
  isRendered;
  latitude;
  longitude;

  @api
  apartmentTypeId;

  @wire(getApartmentsByLocation, {
    latitude: "$latitude",
    longitude: "$longitude",
    apartmentTypeId: "$apartmentTypeId"
  })
  wiredApartmentsJSON({ error, data }) {
    if (data) {
      this.createMapMarkers(data);
    } else if (error) {
      const toast = new ShowToastEvent({
        title: labels.errorLoadingApartments,
        message: error.message,
        variant: ERROR_VARIANT
      });
      this.dispatchEvent(toast);
    }
    this.isLoading = false;
  }

  renderedCallback() {
    if (!this.isRendered) {
      this.getUserLocationFromBrowser();
    }
    this.isRendered = true;
  }

  getUserLocationFromBrowser() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) => {
        this.latitude = position.coords.latitude;
        this.longitude = position.coords.longitude;
      });
    }
  }

  createMapMarkers(apartmentData) {
    this.mapMarkers = [
      {
        location: { Latitude: this.latitude, Longitude: this.longitude },
        title: labels.yourLocation,
        icon: ICON_STANDARD_USER
      },
      ...JSON.parse(apartmentData).map((apartment) => ({
        location: {
          Latitude: apartment.Geolocation__Latitude__s,
          Longitude: apartment.Geolocation__Longitude__s
        },
        title: apartment.Name
      }))
    ];
  }
}
