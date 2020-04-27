let needs = document.querySelectorAll(".select-needs")

let showAssignAction = false
let assignAction = document.querySelector("#assign-selected-needs-users")
assignAction.setAttribute("disabled", "disabled")

let enableDisableAssignAction = () => {
  if(showAssignAction) {
    assignAction.removeAttribute("disabled")
  } else {
    assignAction.setAttribute("disabled", "disabled")
  }
}

let needClicked = (e) => {
  e.stopPropagation()
  showAssignAction = false
  for (let i = 0; i < needs.length; i++) {
    if (needs[i].checked) {
      showAssignAction = true
      break;
    }
  }

  enableDisableAssignAction()
}

for (let i = 0; i < needs.length; i++) {
  needs[i].addEventListener('click', needClicked)
}

let allNeeds = document.querySelector("#select-all-needs")
let selectAllNeeds = () => {
  let checked;
  if(allNeeds.checked) {
    checked = true
    showAssignAction = true
  } else {
    checked = false
    showAssignAction = false
  }
  
  enableDisableAssignAction()
  for (let i = 0; i < needs.length; i++) {
    needs[i].checked = checked
  }
}

allNeeds.addEventListener('click', selectAllNeeds)
    
document.querySelector("#assign-selected-needs-users").addEventListener("change", (e) => {
  let user_id = e.target.value
  if(e.target.value) {
    if (user_id === 'Unassigned') {
      user_id = null
    }
    let for_update = []
    for (let i = 0; i < needs.length; i++) {
      if (needs[i].checked) {
        for_update.push({ need_id: needs[i].value, user_id: user_id })
      }
    }
    
    $.ajax({
      url: '/needs_multiple',
      type: 'PATCH',
      data: `for_update=${JSON.stringify(for_update)}`,
      headers:  { 
        'Content-type': 'application/x-www-form-urlencoded',
        "X-CSRF-Token": getMetaValue("csrf-token")
      },
      dataType: "json",
      success: function(res) {
        if (res.status === 'ok') {
          location.reload()
        }
      }
    })  
  }
})

function getMetaValue(name) {
  return document.head.querySelector(`meta[name="${name}"]`).getAttribute("content")
}
