$(document).ready(() => {
    const progressWizard = new ProgressWizard();
    progressWizard.markCallComplete();
    progressWizard.markTriageCurrent();

    $("#assessment-cancel").click(() => {
        localStorage.setItem("failedCall", "true");
    })
});