$("#save-for-later-btn").on("click", function(event){
    $('#save-triage-for-later').val('true');
    $('#triage-submit-btn').click();
});

$("#discard-draft-btn").on("click", function(event){
    $('#discard-draft').val('true');
    $('#save-triage-for-later').val('true');
    $('#triage-submit-btn').click();
});