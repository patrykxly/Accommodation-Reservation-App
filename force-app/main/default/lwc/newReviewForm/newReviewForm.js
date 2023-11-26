import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import labels from "./customLabels";

import APARTMENT_REVIEW from "@salesforce/schema/ApartmentReview__c";
import APARTMENT_REVIEW_NAME from "@salesforce/schema/ApartmentReview__c.Name";
import APARTMENT_REVIEW_COMMENT from "@salesforce/schema/ApartmentReview__c.Comment__c";

const SUCCESS_TITLE = "Review Created!";
const SUCCESS_VARIANT = "success";

export default class NewReviewForm extends LightningElement {
  apartmentId;
  rating;

  labels = labels;

  apartmentReviewObject = APARTMENT_REVIEW;
  nameField = APARTMENT_REVIEW_NAME;
  commentField = APARTMENT_REVIEW_COMMENT;

  get recordId() {
    return this.apartmentId;
  }

  @api
  set recordId(value) {
    this.setAttribute("apartmentId", value);
    this.apartmentId = value;
  }

  handleRatingChanged(event) {
    this.rating = event.detail.rating;
  }

  handleSubmit(event) {
    event.preventDefault();
    const fields = event.detail.fields;
    fields.Rating__c = this.rating;
    fields.Apartment__c = this.apartmentId;
    this.template.querySelector("lightning-record-edit-form").submit(fields);
  }

  handleSuccess() {
    this.dispatchEvent(
      new ShowToastEvent({
        title: SUCCESS_TITLE,
        variant: SUCCESS_VARIANT
      })
    );
    this.handleReset();
    this.dispatchEvent(new CustomEvent("createreview"));
  }

  handleReset() {
    this.template
      .querySelectorAll("lightning-input-field")
      ?.forEach((field) => {
        field.reset();
      });
  }
}
