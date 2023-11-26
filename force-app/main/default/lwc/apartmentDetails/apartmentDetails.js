import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { getFieldValue } from "lightning/uiRecordApi";
import APARTMENT_NAME_FIELD from "@salesforce/schema/Apartment__c.Name";

export default class ApartmentDetails extends NavigationMixin(
  LightningElement
) {
  @api apartment;
  recordId;

  connectedCallback() {
    this.recordId = this.apartment.data.id;
  }

  get detailsTabIconName() {
    return this.apartment.data ? "utility:anchor" : null;
  }

  get apartmentName() {
    return getFieldValue(this.apartment.data, APARTMENT_NAME_FIELD);
  }

  navigateToRecordViewPage() {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        objectApiName: "Apartment__c",
        recordId: this.recordId,
        actionName: "view"
      }
    });
  }
}
