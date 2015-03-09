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
		title: 'Add new user'
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
	        dataType: "JSON" 
	    }).success(function(data){
	    	if(data.id){
	    		userStatus = data.admin ? 'Admin' : 'User';
	    		$usersTable.append("<tr class='danger'>"
	    											+"<td>"+ data.first_name +"</td>"
	    											+"<td>"+ data.last_name +"</td>"
	    											+"<td>"+ data.email +"</td>"
	    											+"<td>"+ userStatus +"</td>"
	    											+"<td></td>"
	    											+"</tr>");
	    		$('.form-control').each(function(){
	    			$(this).val("");
	    		})
	    		$('.check-box-field').prop('checked', false);
	    		notifie('New user was successfully invited')
	    		$newUserDialog.dialog('close');
	    	}	else {
	    		$errors = $('#new-user-form').children('.error').children('#error_explanation');
	    		$errors.empty();
	    		for(i = 0; i < data.length; i++ ){
	    			$errors.append(data[i] + "<br>");
	    		}
	    	}
	    });
	    return false; // prevents normal behaviour
	});	


	function notifie(message){
    clearTimeout(notifierTimer);
    initNotifierSuccess();
    $notifier.children('.notice-mess').html(message);
    destroyNotifier();
  }

  function error(mess) {
    clearTimeout(notifierTimer);
    initNotifierError();
    if(mess){
      $notifier.children('.notice-mess').html(mess);
    } else{
      $notifier.children('.notice-mess').html('Something went wrong, please repeat the action later!');
    }
    destroyNotifier();
  }

  function initNotifierSuccess(){
    $notifier.addClass('notifier-init notice-success').removeClass('notice-error');
    $notifier.fadeIn('fast');
  }

  function initNotifierError(){
    $notifier.addClass('notifier-init notice-error').removeClass('notice-success');
    $notifier.fadeIn('fast');
  }

  function destroyNotifier(){
    notifierTimer = setTimeout(function(){
      $notifier.fadeOut('slow');
    },2000);    
  }
});