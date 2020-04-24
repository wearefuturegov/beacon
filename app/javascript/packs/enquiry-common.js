let _this = {};
function Popup() {
    this.modalSelectorId = "mainModal";
    this.headerSeletorClass = "modal-header";
    this.contentAreaId = "modalContent";
    this.closeIconClass = "close";

    _this = this;

    $(`.${this.closeIconClass}`).click(function() {
        _this.close();
    })
}

Popup.prototype.show = function(content, header = undefined) {
    let modalWindow = $(`#${_this.modalSelectorId}`);
    let contentArea = modalWindow.find(`#${_this.contentAreaId}`);
    contentArea.html(content);
    if (header) {
        let headerArea = $(`.${_this.headerSeletorClass} h2`);
        headerArea.text(header);
    }
    modalWindow.css("display", "block");
};

Popup.prototype.close = function() {
    let modalWindow = $(`#${_this.modalSelectorId}`);
    modalWindow.css("display", "none");
};

$(document).ready(() => {
    $("#btnAddEnquiry").click(function() {
        const popup = new Popup();
        popup.show("<p>My content</p>", "This is my header");
    })
})