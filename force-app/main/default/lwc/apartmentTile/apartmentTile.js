import { LightningElement, api } from "lwc";

const TILE_WRAPPER_SELECTED = "tile-wrapper selected";
const TILE_WRAPPER = "tile-wrapper";

export default class ApartmentTile extends LightningElement {
  @api
  apartment;

  @api
  selectedApartmentId;

  get backgroundStyle() {
    return "background-image:url(" + this.apartment.Picture__c + ")";
  }

  get tileClass() {
    return this.apartment.Id === this.selectedApartmentId
      ? TILE_WRAPPER_SELECTED
      : TILE_WRAPPER;
  }

  selectApartment() {
    // eslint-disable-next-line @lwc/lwc/no-api-reassignments
    this.selectedApartmentId = this.apartment.Id;
    this.dispatchEvent(
      new CustomEvent("apartmentselect", {
        detail: { apartmentId: this.selectedApartmentId }
      })
    );
  }
}
