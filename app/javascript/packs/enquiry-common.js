$(document).ready(() => {
    $("#btnAddEnquiry").click(function() {
        const popup = new window.Popup();
        popup.show("<p>My content</p>", "This is my header");
    })
})