import { LightningElement, api } from "lwc";

const DATE_FROM = "dateFrom";
const DATE_TO = "dateTo";

export default class ApartmentFilterOptions extends LightningElement {
  @api
  filters;
  dateFrom;
  dateTo;

  get typeFiltersOptions() {
    return this.filters.find((filter) => "types" in filter).types;
  }

  get priceFiltersOptions() {
    return this.filters.find((filter) => "prices" in filter).prices;
  }

  get capacityFiltersOptions() {
    return this.filters.find((filter) => "capacities" in filter).capacities;
  }

  get countryFiltersOptions() {
    return this.filters.find((filter) => "countries" in filter).countries;
  }

  get minDate() {
    return new Date().toJSON().slice(0, 10);
  }

  handleSearchOptionChange(event) {
    const filterBy = event.target.options
      ? this.getSelectedFilterLabel(event.target.options[0])
      : event.target.label.replace(/\s+/g, "")[0].toLowerCase() +
        event.target.label.replace(/\s+/g, "").slice(1);

    if (filterBy === DATE_FROM) {
      this.handleDateFromChange(event);
    } else if (filterBy === DATE_TO) {
      this.handleDateToChange(event);
    }

    this.dispatchEvent(
      new CustomEvent("search", {
        detail: {
          filterBy: filterBy,
          filterValue: event.detail.value
        }
      })
    );
  }

  getSelectedFilterLabel(firstOptionOfFilterOptions) {
    let selectedLabel;

    for (const filterOptions of this.filters) {
      const filterOptionsKey = Object.keys(filterOptions)[0];
      if (filterOptions[filterOptionsKey][0] === firstOptionOfFilterOptions) {
        selectedLabel = filterOptionsKey;
        break;
      }
    }
    return selectedLabel;
  }

  handleDateFromChange(event) {
    this.dateFrom = event.detail.value;
    event.target.max = this.dateTo || "";
  }

  handleDateToChange(event) {
    this.dateTo = event.detail.value;
    event.target.min = this.dateFrom || "";
  }
}
