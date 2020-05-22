require("select2");

const dropdowns = $("#formAssessment .dropdown");
dropdowns.select2();

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
