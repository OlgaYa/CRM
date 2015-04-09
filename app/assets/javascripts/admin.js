$(document).ready(function(){
	var $newUserDialog = $('#new-user-dialog'),
	    $usersTable = $('#users-table'),
      $editDialog = $('#edit-dialog'),
      $editInp    = $('#edit-input'),
      $notifier   = $('.notifier');

/* START ============ DIALOGS INIT ===================== */

  // NEW USER DIALOG
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

  // STATUS AND SOURCES
  $editDialog.dialog({
    autoOpen: false,
    buttons: 
    [
      {
        text: 'Close',
        click: function(e){
          $editDialog.dialog('close');
        }
      },
      {
        text: 'Save',
        click: function(e){
          var id    = $(this).data('id'),
              field = $(this).data('field'),
              path  = $(this).data('path'),
              entity  = $(this).data('entity'),
              value = $editInp.val();

          dataForSend = { 'field':field, 'value':value }
          if(value){
            $.when($.ajax({
              type: 'PUT',
              url: path,
              data: dataForSend
            })).always(function(data, textStatus, jqXHR){
              if(textStatus === 'success'){
                $('#' + entity + '_' + id).children('.editable-name').text(value);
                $editDialog.dialog('close');
              } else {
                error('', $notifier);    
              }
            })
          } else {
            error("Input field can't be blank", $notifier);
          }
        }
      }
    ]
  })

/* END ============== DIALOGS INIT ============================ */
/* ============================================================ */
/* START ============ ADD NEW USER EVENTS ===================== */

	$('#add-new-user').on('click', function(){
		$newUserDialog.dialog('open');
	});

  $('#new-user-form').on('submit', function() {  
      var valuesToSubmit = $(this).serialize();
      $.ajax({
        type: "POST",
        url: $(this).attr('action'), 
        data: valuesToSubmit,
        success: function(data){
          if(typeof data !== 'object'){
            $usersTable.append(data);
            notifie('New user was successfully invited', $notifier)
            $newUserDialog.dialog('close');
          } else {
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

  $('form.task-control').on('submit', function(){
    var $inp = $(this).children('.new');
    if($inp.val()===''){
      error('Field must not be empty', $notifier);
      return false;
    }
  })

/* END ============= ADD NEW USER EVENTS ====================== */
/* ============================================================ */
/* START =========== USER STATUS EVENTS ======================= */
 
  $(document).on('click', '.user-status', function(){
    var id    = $(this).parent().attr('value'),
        $cell = $(this);

    $.when(sendAjax('/admin/user_status/' + id, 
                    $cell.attr('name'), 
                    $cell.attr('value'))).always(function(data, textStatus, jqXHR){
                      if(textStatus === 'success') {
                        if($cell.hasClass('lock')){
                          $cell.removeClass('lock').addClass('unlock');
                          $cell.attr('value', 'lock');
                        } else {
                          $cell.removeClass('unlock').addClass('lock');
                          $cell.attr('value', 'unlock');
                        }
                        notifie('User status was successful updated!', $notifier);
                      } else {
                        error('', $notifier);
                      }
                    });
  });

  function sendAjax(path, field, value){
    dataForSend = { 'field':field, 'value':value }
    return  $.ajax({
              type: 'PUT',
              url: path,
              data: dataForSend
            });
  }

/* END ============= USER STATUS EVENTS ===================== */
/* ========================================================== */
/* START ========= EDIT STATUS AND SOURCE EVENTS ============ */

  $(document).on('click', '.edit', function(){
    var value  = $(this).parents('tr').children().text().trim(),
        id     = $(this).parents('tr').attr('value'),
        entity = $(this).parents('tr').attr('name');
    $editInp.val(value);
    if(entity === 'status'){
      $editDialog.data('path', '/admin/status/' + id);
    } else {
      $editDialog.data('path', '/admin/source/' + id);
    }
    $editDialog.data('id', id);
    $editDialog.data('field', 'name');
    $editDialog.data('entity', entity);
    $editDialog.dialog('open');
  });

/* END ======== EDIT STATUS AND SOURCE EVENTS =============== */
/* ========================================================== */
});