$(document).ready(function(){
	$('form :input').on('change', function(e){
		$('form').submit();
	})
	$(".chosen-select-user").chosen();
	$(".chosen-select-status").chosen();
	$(".chosen-select-source").chosen()

	var checkin = $('#dpd1').datepicker( {dateFormat: 'dd-mm-yy'});
	var checkout = $('#dpd2').datepicker({ dateFormat: 'dd-mm-yy'});
});
