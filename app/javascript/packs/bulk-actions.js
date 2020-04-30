let needs = document.querySelectorAll(".select-needs");
let showAssignAction = false;

/**
 * Checkbox clicked event
 */
let checkboxClicked = (e) => {
  e.stopPropagation()
  showAssignAction = false;
  for (let i = 0; i < needs.length; i++) {
    if (needs[i].checked) {
      showAssignAction = true;
      break;
    }
  }
}

for (let i = 0; i < needs.length; i++) {
  needs[i].addEventListener('click', checkboxClicked)
}

let allNeeds = document.querySelector("#select-all-needs")

/**
 * Select all needs
 */
let selectAllNeeds = () => {
  let checked;
  if(allNeeds.checked) {
    checked = true;
  } else {
    checked = false;
  }
  for (let i = 0; i < needs.length; i++) {
    needs[i].checked = checked;
  }
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

allNeeds.addEventListener('click', selectAllNeeds)

// assign to users event listener
document.querySelector("#assign-selected-needs").addEventListener("change", (e) => {
  let assigned_to = e.target.value
  if(e.target.value) {
    if (assigned_to === 'Unassigned') {
      assigned_to = null;
    }
    let for_update = []
    for (let i = 0; i < needs.length; i++) {
      if (needs[i].checked) {
        for_update.push({ need_id: needs[i].value, assigned_to: assigned_to });
      }
    }    
    if (for_update.length > 0) {
      applyPatchUpdate(for_update);
    }
  }
});


function getMetaValue(name) {
  return document.head.querySelector(`meta[name="${name}"]`).getAttribute("content");
}
