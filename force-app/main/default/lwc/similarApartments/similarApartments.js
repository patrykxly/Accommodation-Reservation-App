import { LightningElement, wire, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getSimilarApartments from "@salesforce/apex/SimilarApartmentsController.getSimilarApartments";

export default class SimilarApartments extends NavigationMixin(
  LightningElement
) {
  currentApartment;
  relatedApartments;
  apartmentId;

  @api
  similarBy;

  @api
  get recordId() {
    return this.apartmentId;
  }

  set recordId(value) {
    this.setAttribute("apartmentId", value);
    this.apartmentId = value;
  }

  get title() {
    return `Similar apartments by ${this.similarBy}`;
  }

  get isAnyApartmentExisting() {
    return !(this.relatedApartments && this.relatedApartments.length > 0);
  }

  @wire(getSimilarApartments, {
    apartmentId: "$apartmentId",
    similarBy: "$similarBy"
  })
  similarApartments({ error, data }) {
    if (data) {
      this.relatedApartments = data;
    } else if (error) {
      console.error(error);
    }
  }

  openApartmentDetailPage(event) {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        objectApiName: "Apartment__c",
        recordId: event.detail.apartmentId,
        actionName: "view"
      }
    });
  }
}
