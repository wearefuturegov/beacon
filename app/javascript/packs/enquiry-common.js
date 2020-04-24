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
        const title = "You are about to exit this page";
        const p1 = "<p>You can save the triage info and continue later or stay on this page</p>";
        const buttons = "<button id='save-for-later-btn' class='button button--dark'>Save for later</button>";
        popup.show(p1 + buttons, title);

        $("#save-for-later-btn").on("click", function(event){
            $('#save-triage-for-later').val('true');
            $('#triage-submit-btn').click();
        });        
    })
})