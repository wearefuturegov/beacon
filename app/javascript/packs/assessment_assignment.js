require("select2");

$(document).ready(() => {
   const progressWizard = new ProgressWizard();
   progressWizard.markCallComplete();
   progressWizard.markTriageComplete();
   progressWizard.markAssignCurrent();
});

const form = $("form");
const formDropdowns = form.find(".dropdown");
formDropdowns.select2();