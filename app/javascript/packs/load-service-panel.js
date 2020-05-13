const updateLeadService = (contact_id, lead_service_id, lead_service_note) => {
  $.ajax({
    url: '/contact_update_lead_service',
    type: 'PATCH',
    data: `for_update=${JSON.stringify({
      contact_id: contact_id, 
      lead_service_id: lead_service_id,
      lead_service_note: lead_service_note 
    })}`,
    headers:  { 
      'Content-type': 'application/x-www-form-urlencoded',
      "X-CSRF-Token": getMetaValue("csrf-token")
    },
    dataType: "json",
    success: function(res) {
      if (res.status === 'ok') {
        location.reload();
      }
    }
  });
}

$( document ).ready(function() {
  $("#contact-service-panel-cancel").click(function() {
    location.reload();
  });
  
  $("#contact-service-panel-save").click(function() {
    updateLeadService($("#contact_id").val(), $("#lead_service_id").val(), $("#contact_lead_service_note").val())
  });
});

function getMetaValue(name) {
  return document.head.querySelector(`meta[name="${name}"]`).getAttribute("content");
}