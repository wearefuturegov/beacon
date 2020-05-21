$(document).ready(() => {
    const progressWizard = new ProgressWizard()
    progressWizard.markCallComplete();
    progressWizard.markTriageComplete();
    progressWizard.markAssignComplete();
    progressWizard.markCompleteCurrent();
})

const flatpickr = require('flatpickr')
flatpickr('#assessment_completion_form_next_check_in_date', {
    dateFormat: "d/m/Y",
    allowInput: true
});