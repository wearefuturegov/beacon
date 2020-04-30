const allNeedsStatusComplete = document.querySelectorAll('.need--status_complete')
const showHideAllNeedsStatusComplete = (display) => {
  for(let i = 0; i < allNeedsStatusComplete.length; i++) {
    allNeedsStatusComplete[i].style.display = display
  }  
}
showHideAllNeedsStatusComplete('none')

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
    showHideAllNeedsStatusComplete(toggleDisplay(showCompletedNeeds))
    e.preventDefault()
});

document.getElementById('btnAssessmentDropdown').addEventListener('click', (e) => {
    document.getElementById('assessmentDropdownElements').classList.toggle('assessment-dropdown-show');
    window.addEventListener('click', onWindowClick);

    function onWindowClick(e) {
        if (e.target.id.toString() !== 'btnAssessmentDropdown') {
            const dropdown = document.getElementById('assessmentDropdownElements');
            if (dropdown && dropdown.classList.contains('assessment-dropdown-show')) {
                dropdown.classList.remove('assessment-dropdown-show');
            }
        }
    }
});



