let needs = document.querySelectorAll(".select-needs")

let showAssignAction = false
let assignAction = document.querySelector("#assign-selected-needs")
assignAction.setAttribute("hidden", "true")

let showHideAssignAction = () => {
  if(showAssignAction) {
    assignAction.removeAttribute("hidden")
  } else {
    assignAction.setAttribute("hidden", "true")
  }
}

let needClicked = (e) => {
  e.stopPropagation()
  showAssignAction = false
  needs.forEach((need) => {
    if (need.checked) {
      showAssignAction = true
      return;
    }
  })
  
  showHideAssignAction()
}

needs.forEach((need) => need.addEventListener('click', needClicked))

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
  
  showHideAssignAction()
  needs.forEach((need) => {
    need.checked = checked
  })
}

allNeeds.addEventListener('click', selectAllNeeds)

document.querySelector("#assign-selected-needs").addEventListener("change", (e) => {
  let user_id = e.target.value
  if(e.target.value) {
    if (user_id === 'Unassigned') {
      user_id = null
    }
    let for_update = []
    needs.forEach((need) => {
      if (need.checked) {
        for_update.push({ need_id: need.value, user_id: user_id })
      }
    })
    
    fetch(`/needs_multiple`,{
      method: 'PATCH',
      body: `for_update=${JSON.stringify(for_update)}`,
      headers:  { 
        'Content-type': 'application/x-www-form-urlencoded',
        "X-CSRF-Token": getMetaValue("csrf-token")
      },
      credentials: 'same-origin' 
    })
    .then((res) => res.json())
    .then((res) => {
      if (res.status === 'ok') {
        location.reload()
      }
    })
  }
})

function getMetaValue(name) {
  return document.head.querySelector(`meta[name="${name}"]`).getAttribute("content")
}
