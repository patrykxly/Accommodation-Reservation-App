import { LightningElement, api } from "lwc";

export default class ApartmentRent extends LightningElement {
  @api recordId;

  get inputVariables() {
    return [
      {
        name: "apartmentId",
        type: "String",
        value: this.recordId
      }
    ];
  }
}
