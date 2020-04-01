const $  = require( 'jquery' );
const dt = require('datatables.net-dt');
// require('datatables.net-dt/css/jquery.dataTables.css');

this.setFilterValues = function(searchElement, column){
     if (searchElement.nodeName === "SELECT") {
            if (searchElement.options[searchElement.selectedIndex].value === "") {
                column.search("").draw();
            } else {
                const searchText = searchElement.options[searchElement.selectedIndex].text;
                column.search(searchText).draw();
            }
        } else {
            column.search(searchElement.value).draw();
        }
};

$(document).ready(() => {
    if ($(".dataTables_wrapper").length > 0) return;

    const element = $('.needs-table').first();
    const table = $('.data-table').DataTable();

    document.addEventListener("turbolinks:before-cache", function() {
        if (table !== null) {
            table.destroy();
        }
    });

    element.find('tfoot th').each((footerIndex, footerElement) => {
        let searchElement = $(footerElement).find('input, select').first();
        if (searchElement === null) {
            return;
        }
        searchElement = searchElement[0];
        const column = table.columns(footerIndex);

        $(searchElement).on('keyup change clear', () => {
            this.setFilterValues(searchElement, column);
        });
    });
});
