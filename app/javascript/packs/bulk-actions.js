require("select2");

let needs = document.querySelectorAll(".select-needs");
let allNeeds = document.querySelector("#select-all-needs");
const assign = document.querySelector("#assign-selected-needs");
const status = document.querySelector("#status-selected-needs");
const bulkActionsElems = [assign, status]

const assignJQueryWrapper = $(assign);
assignJQueryWrapper.select2();
assignJQueryWrapper.on("select2:select", (e) => {
  let assigned_to = e.currentTarget.value === "Unassigned"
      ? null
      : e.currentTarget.value;
  const for_update = []
  for (let i = 0; i < needs.length; i++) {
    if (needs[i].checked) {
      for_update.push({ need_id: needs[i].value, assigned_to: assigned_to });
    }
  }
  if (for_update.length > 0) {
    applyPatchUpdate(for_update);
  }
});

const statusJQueryWrapper = $(status);
statusJQueryWrapper.select2();
statusJQueryWrapper.on("select2:select", (e) => {
  let status = e.currentTarget.value;
  if (!status) {
    return;
  }

  const for_update = [];
  for (let i = 0; i < needs.length; i++) {
    if (needs[i].checked) {
      for_update.push({ need_id: needs[i].value, status: status })
    }
  }

  if (for_update.length > 0) {
    applyPatchUpdate(for_update)
  }
});

for (let i = 0; i < needs.length; i++) needs[i].addEventListener('click', checkboxClicked)
if(allNeeds) {
  allNeeds.addEventListener('click', selectAllNeeds)
}
function checkboxClicked(e) {
  e.stopPropagation()
  let checkedCount = 0;
  for (let i = 0; i < needs.length; i++) if (needs[i].checked) { checkedCount++ }
  (checkedCount > 0) ? enableBulkActions() : disableBulkActions()
}

function selectAllNeeds() {
  let checked = (allNeeds.checked) ? true : false
  for (let i = 0; i < needs.length; i++) needs[i].checked = checked;
  (checked) ? enableBulkActions() : disableBulkActions()
}

/**
 * PATCH update
 */
applyPatchUpdate = (for_update) => {
  $.ajax({
    url: '/needs_bulk_action',
    type: 'PATCH',
    data: `for_update=${JSON.stringify(for_update)}`,
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
};

function getMetaValue(name) {
  return document.head.querySelector(`meta[name="${name}"]`).getAttribute("content");
}

function disableBulkActions() {
  for(let i = 0; i < bulkActionsElems.length; i++) bulkActionsElems[i].setAttribute("disabled", "disabled")
}

function enableBulkActions() {
  for(let i = 0; i < bulkActionsElems.length; i++) bulkActionsElems[i].removeAttribute("disabled")
}
