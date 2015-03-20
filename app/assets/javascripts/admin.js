// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
	var $newUserDialog = $('#new-user-dialog');
	var $usersTable = $('#users-table');
	var $notifier = $('.notifier');
	var notifierTimer;

	$newUserDialog.dialog({
		autoOpen: false,
		modal: true,
		width: 410,
		resizable: false,
		title: 'Add new user',
		close: function(){
			$('.form-control').each(function(){
	    			$(this).val("");
	    		})
  		$('.check-box-field').prop('checked', false);
  		$('#error_explanation').empty();
		}
	});

	// ============= EVENTS ====================== //

	$('#add-new-user').on('click', function(){
		$newUserDialog.dialog('open');
	});

	$('#new-user-form').on('submit', function() {  
	    var valuesToSubmit = $(this).serialize();
	    $.ajax({
        type: "POST",
        url: $(this).attr('action'), 
        data: valuesToSubmit,
        dataType: "JSON",
        success: function(data){
		    	if(data.id){
		    		userStatus = data.admin ? 'Admin' : 'User';
		    		$usersTable.append("<tr class='danger'>"
		    											+"<td>"+ data.first_name +"</td>"
		    											+"<td>"+ data.last_name +"</td>"
		    											+"<td>"+ data.email +"</td>"
		    											+"<td>"+ userStatus +"</td>"
		    											+"<td></td>"
		    											+"<td></td>"
		    											+"</tr>");
		    		notifie('New user was successfully invited', $notifier)
		    		$newUserDialog.dialog('close');
		    	}	else {
		    		$errors = $('#error_explanation');
		    		$errors.empty();
		    		for(i = 0; i < data.length; i++ ){
		    			$errors.append(data[i] + "<br>");
		    		}
		    	}
    		},
    		error: function() {
    			error('', $notifier);
    			$newUserDialog.dialog('close');
    		} 
	    });
	    return false; // prevents normal behaviour
	});	
});