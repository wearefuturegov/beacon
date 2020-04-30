Array.prototype.slice.call(document.querySelectorAll('.need--status_complete')).forEach((e, i) => e => e.style.display = 'none');

let showCompletedNeeds = false;
const toggleDisplay = (show) => show ? 'table-row' : 'none';

document.getElementById('toggle-visibility-completed-assessments').addEventListener('click', (e) => {
    showCompletedNeeds = !showCompletedNeeds;
    document.querySelectorAll('.need--status_complete').forEach(e => e.style.display = toggleDisplay(showCompletedNeeds));
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



