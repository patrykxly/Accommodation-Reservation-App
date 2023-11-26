import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getRoomsByApartmentId from "@salesforce/apex/ApartmentRoomsController.getRoomsByApartmentId";

export default class ApartmentRoomsDetails extends NavigationMixin(
  LightningElement
) {
  apartmentId;
  rooms;
  chosenRoom;

  @api
  set recordId(value) {
    this.apartmentId = value;
    this.chosenRoom = "";
    this.getRooms();
  }

  @api
  refresh() {
    this.getRooms();
  }

  get recordId() {
    return this.apartmentId;
  }

  get roomsOptions() {
    return this.rooms.map((room) => ({ label: room.Name, value: room.Id }));
  }

  getRooms() {
    if (this.apartmentId) {
      this.isLoading = true;
      getRoomsByApartmentId({ apartmentId: this.apartmentId })
        .then((data) => {
          this.rooms = data;
        })
        .catch((error) => {
          console.error(error);
        })
        .finally((this.isLoading = false));
    }
  }

  handleRoomOptionChange(event) {
    this.chosenRoom = this.rooms.find((room) => room.Id === event.detail.value);
  }

  navigateToRecordViewPage() {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        objectApiName: "ApartmentRoom__c",
        recordId: this.chosenRoom.Id,
        actionName: "view"
      }
    });
  }
}
