import flatpickr from "flatpickr";

const dateElement = document.getElementById("contact_needs_needs_list[0][start_on]");
flatpickr(dateElement, {
    minDate: "today",
    dateFormat: "d/m/Y",
    defaultDate: new Date().fp_incr(6)
});