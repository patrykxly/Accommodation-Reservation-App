import { api, LightningElement, wire } from "lwc";
import {
  subscribe,
  APPLICATION_SCOPE,
  MessageContext
} from "lightning/messageService";
import { getRecord } from "lightning/uiRecordApi";
import labels from "./customLabels";
import APARTMENTMC from "@salesforce/messageChannel/apartmentMessageChannel__c";

const LOCATION_FIELDS = [
  "Apartment__c.Geolocation__Longitude__s",
  "Apartment__c.Geolocation__Latitude__s"
];

export default class ApartmentMap extends LightningElement {
  subscription = null;
  labels = labels;
  apartmentId;
  mapMarkers = [];

  get shouldMapBeVisible() {
    return this.mapMarkers.length > 0;
  }

  get recordId() {
    return this.apartmentId;
  }

  @api
  set recordId(value) {
    this.apartmentId = value;
  }

  @wire(MessageContext)
  messageContext;

  @wire(getRecord, { recordId: "$apartmentId", fields: LOCATION_FIELDS })
  wiredRecord({ error, data }) {
    if (data) {
      this.updateMap(
        data.fields.Geolocation__Longitude__s.value,
        data.fields.Geolocation__Latitude__s.value
      );
    } else if (error) {
      this.apartmentId = undefined;
      this.mapMarkers = [];
    }
  }

  connectedCallback() {
    this.subscribeMessageChannel();
  }

  subscribeMessageChannel() {
    if (this.subscription || this.recordId) {
      return;
    }
    this.subscription = subscribe(
      this.messageContext,
      APARTMENTMC,
      (message) => {
        this.apartmentId = message.recordId;
      },
      { scope: APPLICATION_SCOPE }
    );
  }

  updateMap(Longitude, Latitude) {
    this.mapMarkers = [{ location: { Latitude, Longitude } }];
  }
}
