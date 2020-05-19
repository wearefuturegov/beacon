$(() => {
    $(".buttons-container .button-link").click(element => {
        $(".needs-container").addClass("invisible");
        $(".notes-container").addClass("invisible");
        $(".buttons-container").addClass("invisible");
        $(".make-call-container").removeClass("invisible");
    });
});