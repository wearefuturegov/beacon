$(document).on("turbolinks:load", () => {
    const linkButton = $(".buttons-container .button-link");
    linkButton.click(element => {
        element.stopPropagation();
        $(".needs-container").addClass("invisible");
        $(".notes-container").addClass("invisible");
        $(".buttons-container").addClass("invisible");
        $(".make-call-container").removeClass("invisible");
        const progressWizard = new ProgressWizard();
        progressWizard.markCallCurrent();
    });
    if (localStorage.getItem("startAssessment")) {
        localStorage.removeItem("startAssessment");
        linkButton.click();
    }
});