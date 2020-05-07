let needs = document.querySelectorAll(".select-needs");
let allNeeds = document.querySelector("#select-all-needs");
const assign = document.querySelector("#assign-selected-needs");
const category = document.querySelector("#category-selected-needs");
const bulkActionsElems = [assign, category]

for (let i = 0; i < needs.length; i++) needs[i].addEventListener('click', checkboxClicked)
allNeeds.addEventListener('click', selectAllNeeds)

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
    url: '/assign_multiple',
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
}



// assign to users event listener
assign.addEventListener("change", (e) => {
  let assigned_to = e.target.value
  if(!assigned_to) return;
  if (assigned_to === 'Unassigned') assigned_to = null
  let for_update = []
  for (let i = 0; i < needs.length; i++) 
    if (needs[i].checked) for_update.push({ need_id: needs[i].value, assigned_to: assigned_to })  
  if (for_update.length > 0) applyPatchUpdate(for_update)
});

category.addEventListener("change", (e) => {
  let category = e.target.value
  if(!category) return;
  let for_update = []
  for (let i = 0; i < needs.length; i++)
    if (needs[i].checked) for_update.push({ need_id: needs[i].value, category: category })
  if (for_update.length > 0) applyPatchUpdate(for_update)
});


function getMetaValue(name) {
  return document.head.querySelector(`meta[name="${name}"]`).getAttribute("content");
}

function disableBulkActions() {
  for(let i = 0; i < bulkActionsElems.length; i++) bulkActionsElems[i].setAttribute("disabled", "disabled")
}

function enableBulkActions() {
  for(let i = 0; i < bulkActionsElems.length; i++) bulkActionsElems[i].removeAttribute("disabled")
}
