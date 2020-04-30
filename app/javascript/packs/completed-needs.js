document.querySelectorAll('.completed-need').forEach(e => e.style.display = 'none');

let toShowCompletedNeeds = false;
const toggleDisplayCompletedNeeds = (show) => show ? 'table-row' : 'none';

document.getElementById('toggle-visibility-completed-needs').addEventListener('click', (e) => {
  toShowCompletedNeeds = !toShowCompletedNeeds;
  document.querySelectorAll('.completed-need').forEach(e => e.style.display = toggleDisplayCompletedNeeds(toShowCompletedNeeds));
  e.preventDefault()
});