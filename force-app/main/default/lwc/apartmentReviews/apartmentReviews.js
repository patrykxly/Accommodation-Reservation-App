import { LightningElement, api } from "lwc";
import getReviewsByApartmentId from "@salesforce/apex/ApartmentReviewController.getReviewsByApartmentId";
import { NavigationMixin } from "lightning/navigation";

export default class ApartmentReviews extends NavigationMixin(
  LightningElement
) {
  apartmentId;
  apartmentReviews;
  isLoading;

  @api
  refresh() {
    this.getReviews();
  }

  @api
  set recordId(value) {
    this.apartmentId = value;
    this.getReviews();
  }

  get recordId() {
    return this.apartmentId;
  }

  get isAnyReviewAvailable() {
    return this.apartmentReviews?.length;
  }

  getReviews() {
    if (this.apartmentId) {
      this.isLoading = true;
      getReviewsByApartmentId({ apartmentId: this.apartmentId })
        .then((data) => {
          this.apartmentReviews = data;
        })
        .catch((error) => {
          console.error(error);
        })
        .finally((this.isLoading = false));
    }
  }

  navigateToRecord(event) {
    event.preventDefault();
    event.stopPropagation();
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        objectApiName: "User",
        recordId: event.target.dataset.recordId,
        actionName: "view"
      }
    });
  }
}
