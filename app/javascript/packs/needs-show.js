$(document).on("turbolinks:load", () => {
    const linkButton = $(".buttons-container .button-link");
    linkButton.click(element => {
        element.stopPropagation();
        $(".needs-container").addClass("invisible");
        $(".notes-container").addClass("invisible");
        $(".buttons-container").addClass("invisible");
        $(".make-call-container").removeClass("invisible");
    });
    if (localStorage.getItem("startAssessment")) {
        localStorage.removeItem("startAssessment");
        linkButton.click();
    }

    $(".panel__header").click((e) => {
        if (e.target.id === "edit-need-btn") {
            return;
        }
        window.location = $(e.currentTarget).find(".panel__header-link").attr("href");
    });

    $(".panel__header .panel__header-link").click((e) => {
        e.stopPropagation();
    });
});