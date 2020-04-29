document.querySelectorAll('.need--status_complete').forEach(e => e.style.display = 'none');

let showCompletedNeeds = false;
const toggleDisplay = (show) => show ? 'table-row' : 'none';

document.getElementById('toggle-visibility-completed-assessments').addEventListener('click', (e) => {
    showCompletedNeeds = !showCompletedNeeds;
    document.querySelectorAll('.need--status_complete').forEach(e => e.style.display = toggleDisplay(showCompletedNeeds));
    e.preventDefault()
});