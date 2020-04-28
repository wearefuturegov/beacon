import flatpickr from "flatpickr";

const datepickers = document.querySelectorAll('input[datepicker=flatpickr]');
Array.prototype.forEach.call(datepickers, function(element) {
    console.log("setting ", element);
    flatpickr(element, {
        minDate: "today",
        dateFormat: "d/m/Y",
        defaultDate: element.value ? null : new Date().fp_incr(6),
        allowInput: true
    });
});