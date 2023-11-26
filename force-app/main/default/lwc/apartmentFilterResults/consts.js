import labels from "./customLabels";

const SUCCESS_VARIANT = "success";
const ERROR_VARIANT = "error";
const SYSTEM_ADMINISTRATOR = "System Administrator";

const COLUMNS = [
  { label: labels.name, fieldName: "Name", editable: true },
  { label: labels.description, fieldName: "Description__c", editable: true },
  { label: labels.yearBuilt, fieldName: "Year_Built__c", editable: true }
];

export { SUCCESS_VARIANT, ERROR_VARIANT, SYSTEM_ADMINISTRATOR, COLUMNS };
