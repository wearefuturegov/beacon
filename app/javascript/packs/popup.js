class Popup {
    constructor() {
        this.modalSelectorId = "mainModal";
        this.headerSeletorClass = "modal-header";
        this.contentAreaId = "modalContent";
        this.closeIconClass = "close";

        $(`.${this.closeIconClass}`).click(() => {
            this.close();
        })
    }

    show(content, header = undefined) {
        let modalWindow = $(`#${this.modalSelectorId}`);
        let contentArea = modalWindow.find(`#${this.contentAreaId}`);
        contentArea.html(content);
        if (header) {
            let headerArea = $(`.${this.headerSeletorClass} h2`);
            headerArea.text(header);
        }
        modalWindow.css("display", "block");
    }

    close() {
        let modalWindow = $(`#${this.modalSelectorId}`);
        modalWindow.css("display", "none");
    }
}

export default Popup
