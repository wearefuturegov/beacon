document.querySelectorAll('.completed-need').forEach(e => e.style.display = 'none');

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
  document.querySelectorAll('.completed-need').forEach(e => e.style.display = toggleDisplayCompletedNeeds(toShowCompletedNeeds));
  e.preventDefault()
});