import { LightningElement, wire } from "lwc";
import {
  MessageContext,
  subscribe,
  APPLICATION_SCOPE
} from "lightning/messageService";
import { getRecord } from "lightning/uiRecordApi";
import APARTMENTMC from "@salesforce/messageChannel/apartmentMessageChannel__c";
import APARTMENT_ID_FIELD from "@salesforce/schema/Apartment__c.Id";
import APARTMENT_NAME_FIELD from "@salesforce/schema/Apartment__c.Name";
import labels from "./customLabels";

const APARTMENT_FIELDS = [APARTMENT_ID_FIELD, APARTMENT_NAME_FIELD];
export default class ApartmentDetailTabs extends LightningElement {
  apartmentId;
  rooms;
  labels = labels;
  subscription = null;

  @wire(MessageContext)
  messageContext;

  @wire(getRecord, { recordId: "$apartmentId", fields: APARTMENT_FIELDS })
  wiredRecord;

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

  handleReviewCreated() {
    this.template.querySelector("lightning-tabset").activeTabValue = "reviews";
    this.template.querySelector("c-apartment-reviews").refresh();
  }

  handleRoomsChanged() {
    this.template.querySelector("c-apartment-rooms-details").refresh();
  }
}
