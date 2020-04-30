const allCompletedNeeds = document.querySelectorAll('.completed-need')
let showHideAllCompletedNeeds = (display) => {
  for(let i = 0; i < allCompletedNeeds.length; i++) {
    allCompletedNeeds[i].style.display = display
  }  
}
showHideAllCompletedNeeds('none')

let toShowCompletedNeeds = false;
const toggleDisplayCompletedNeeds = (show) => show ? 'table-row' : 'none';

const toggleVisibilityCompletedNeeds = document.getElementById('toggle-visibility-completed-needs')
toggleVisibilityCompletedNeeds.addEventListener('click', (e) => {
  toShowCompletedNeeds = !toShowCompletedNeeds;
  const table = toggleVisibilityCompletedNeeds.parentNode.parentNode
  if(toShowCompletedNeeds) {
    table.classList.add("table-nav-hide")
  } else {
    table.classList.remove("table-nav-hide")
  }
  showHideAllCompletedNeeds(toggleDisplayCompletedNeeds(toShowCompletedNeeds))
  e.preventDefault()
});