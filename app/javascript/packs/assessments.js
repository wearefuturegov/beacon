document.querySelectorAll('.need--status_complete').forEach(e => e.style.display = 'none');

let showCompletedNeeds = false;
const toggleDisplay = (show) => show ? 'table-row' : 'none';

const toggleVisibilityCompletedAssessments = document.getElementById('toggle-visibility-completed-assessments')
toggleVisibilityCompletedAssessments.addEventListener('click', (e) => {
    showCompletedNeeds = !showCompletedNeeds;
    const table = toggleVisibilityCompletedAssessments.parentNode.parentNode
    if(showCompletedNeeds) {
      table.classList.add("table-nav-hide")
    } else {
      table.classList.remove("table-nav-hide")
    }
    document.querySelectorAll('.need--status_complete').forEach(e => e.style.display = toggleDisplay(showCompletedNeeds));
    e.preventDefault()
});