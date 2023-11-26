import { LightningElement, wire, track, api } from "lwc";
import { publish, MessageContext } from "lightning/messageService";
import APARTMENTMC from "@salesforce/messageChannel/apartmentMessageChannel__c";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {
  SUCCESS_VARIANT,
  ERROR_VARIANT,
  SYSTEM_ADMINISTRATOR,
  COLUMNS
} from "./consts";
import labels from "./customLabels";

import { refreshApex } from "@salesforce/apex";
import getCurrentUserProfile from "@salesforce/apex/ApartmentSearchController.getCurrentUserProfile";
import updateApartmentList from "@salesforce/apex/ApartmentDataService.updateApartmentList";

export default class ApartmentFilterResults extends LightningElement {
  _isLoading = false;
  labels = labels;
  columns = COLUMNS;
  apartmentTypeId = "";
  profileName;

  @api
  wiredApartments;

  @api
  apartments;

  @api
  selectedApartmentId;

  get shouldDisplayApartmentEditorTab() {
    return this.profileName === SYSTEM_ADMINISTRATOR;
  }

  @track
  draftValues = [];

  @wire(getCurrentUserProfile)
  wiredProfile({ error, data }) {
    if (data) {
      this.profileName = data;
    } else if (error) {
      console.error(error);
    }
  }

  @wire(MessageContext)
  messageContext;

  @api
  async refresh() {
    this.isLoading = true;
    await refreshApex(this.wiredApartments);
    this.isLoading = false;
  }

  updateSelectedTile(event) {
    // eslint-disable-next-line @lwc/lwc/no-api-reassignments
    this.selectedApartmentId = event.detail.apartmentId;
    this.sendMessageService(this.selectedApartmentId);
  }

  sendMessageService(apartmentId) {
    publish(this.messageContext, APARTMENTMC, { recordId: apartmentId });
  }

  handleSave(event) {
    updateApartmentList({ data: event.detail.draftValues })
      .then(() => {
        this.showToast(SUCCESS_VARIANT);
        this.draftValues = [];
        return this.refresh();
      })
      .catch(() => {
        this.showToast(ERROR_VARIANT);
      });
  }

  showToast(variant) {
    const chosenVariantLabel =
      variant === SUCCESS_VARIANT ? labels.success : labels.error;

    this.dispatchEvent(
      new ShowToastEvent({
        title: chosenVariantLabel,
        message: "Apartments successfuly updated",
        variant: variant
      })
    );
  }
}
