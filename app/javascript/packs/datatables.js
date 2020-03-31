const $  = require( 'jquery' );
const dt = require('datatables.net-dt');
require('datatables.net-dt/css/jquery.dataTables.css');

$(document).ready( function () {
    const element = $('.table').first();
    const table = element.DataTable();
    element.find('tfoot th').each(function(){
       const title = $(this).text();
       const search = $(this).html( '<input type="text" placeholder="Search '+title+'" />' );

       table.columns().every(function() {

       });
        table.columns().every( function () {
            var that = this;

            $( 'input', this.footer() ).on( 'keyup change clear', function () {
                if ( that.search() !== this.value ) {
                    that
                        .search( this.value )
                        .draw();
                }
            } );
        });
    });
});