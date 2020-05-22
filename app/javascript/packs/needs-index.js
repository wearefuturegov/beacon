$(() => {
    $(".table.data-table tbody tr").click((e) => {
        window.location = $(e.currentTarget).data("navigate-to");
    });
    $(".button-link").click((e) => {
        e.stopPropagation();
        e.preventDefault;
    });
});

$("tr .button-grid").click((e) => {
    e.stopPropagation();
    localStorage.setItem("startAssessment", "startAssessment");
    const rowElement = $(e.currentTarget).closest("tr");
    window.location = rowElement.data("navigate-to");
});