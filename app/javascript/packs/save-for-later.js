$("#discard-draft-btn").on("click", function(event){
    $('#discard-draft').val('true');
    $('#save-triage-for-later').val('true');
    $('#triage-submit-btn').click();
});