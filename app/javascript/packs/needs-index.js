$(() => {
    $(".table.data-table tr").click((e) => {
        window.location = $(e.currentTarget).data("navigate-to");
    });
});



$("tr .button-grid").click((e) => {
    e.stopPropagation();
    localStorage.setItem("startAssessment", "startAssessment");
    const rowElement = $(e.currentTarget).closest("tr");
    window.location = rowElement.data("navigate-to");
});