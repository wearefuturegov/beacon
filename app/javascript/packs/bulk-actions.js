let needs = document.querySelectorAll(".select-needs");
let allNeeds = document.querySelector("#select-all-needs");
const assign = document.querySelector("#assign-selected-needs");

for (let i = 0; i < needs.length; i++) {
  if (needs[i].checked && assign.hasAttribute("disabled")) {
    assign.removeAttribute('disabled');
  }
  needs[i].addEventListener('click', checkboxClicked)
}
allNeeds.addEventListener('click', selectAllNeeds)

function checkboxClicked(e) {
  e.stopPropagation()
  let checkedCount = 0;
  for (let i = 0; i < needs.length; i++) {
    if (needs[i].checked) {
      checkedCount++;
    }
  }

  if (checkedCount > 0) {
    assign.removeAttribute("disabled");
  } else {
    assign.setAttribute("disabled", "disabled");
    allNeeds.checked = false;
  }
}

function selectAllNeeds() {
  let checked;
  if(allNeeds.checked) {
    checked = true;
  } else {
    checked = false;
  }
  for (let i = 0; i < needs.length; i++) {
    needs[i].checked = checked;
  }

  if (checked) {
    assign.removeAttribute("disabled");
  } else {
    assign.setAttribute("disabled", "disabled");
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
