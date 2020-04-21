import flatpickr from "flatpickr";

const dateElement = document.getElementById("contact_needs_needs_list_0_start_on");
flatpickr(dateElement, {
    minDate: "today",
    dateFormat: "d/m/Y",
    defaultDate: dateElement.value ? null : new Date().fp_incr(6),
    allowInput: true
});