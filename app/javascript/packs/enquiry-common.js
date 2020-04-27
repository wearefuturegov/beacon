
$(document).ready(() => {    
    $("#btnAddEnquiry").click(function() {
        const popup = new Popup();
        const title = "You are about to exit this page";
        const p1 = "<p>You can save the triage info and continue later or stay on this page</p>";
        const button1 = "<button id='save-for-later-btn' class='button button--dark'>Save and continue later</button>";
        const button2 = "<button id='cancel-modal-btn' class='button button--dark'>Stay on this page</button>";
        popup.show(p1 + button2 + button1, title);

        $("#save-for-later-btn").on("click", function(){
            $('#save-triage-for-later').val('true');
            $('#triage-submit-btn').click();
        });
        $("#cancel-modal-btn").on("click", function(){
            popup.close();
        });             
    })
})