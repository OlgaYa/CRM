$(document).ready(function(){
  $('#date-picker-month').datepicker( {
    changeMonth: true,
    changeYear: true,
    dateFormat: 'MM/yy',
    onClose: function(dateText, inst) { 
        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
        $(this).datepicker('setDate', new Date(year, month, 1));
    },
    onChangeMonthYear: function(y, m){
      var date =  m + "/" + y;
      document.location.href = "http://localhost:3000/reports?date_report="+ date;
    }
  });
  $('#add').bind( 'click', function(){
    $('#myModal').modal();
    $('#report_date').datepicker( {dateFormat: 'dd-mm-yy'});
  });
  $('.report').bind( 'click', function(){
    var id = $(this).attr('id');
    $('#modal_report').load("reports/" + id + "/edit", function(){
      $('#myModal_edit').modal();
      $('#dpd2').datepicker( {dateFormat: 'dd-mm-yy'});
    });
  });
})