const $  = require( 'jquery' );
const dt = require('datatables.net-dt');
require('datatables.net-dt/css/jquery.dataTables.css');

$(document).ready( function () {
    $('.table').first().DataTable();
});