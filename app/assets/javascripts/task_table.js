$(document).on('ready page:load', function(){
  var $notifier = $('.notifier');

// ==== $(#dialog) vars === //
  var $td_editor; // cell 
  var $td_field; // cell children (div)

// ==== $(#comments_dialog) vars === //
  var $td_comment; // cell 

// =========================== modal dialogs ======================================= //
  //dialog for text editor
  $('#dialog').dialog({
    autoOpen: false,
    closeOnEscape: true,
    close: function(event, ui){
      $td_editor.removeClass('active_td');
    },
    open: function(event, ui){
      $('.ui-dialog-titlebar').show();
      $input = $(this).children('textarea');
      str = $td_field.html();
      $input.val(str); 
    },
    buttons: [
      {
        text: 'Close',
        click: function() {
          $(this).dialog('close');
        }
      },
      
      {
        text: 'Save',
        click: function() {
          str = $(this).children('textarea').val();
          $td_field.empty();
          $td_field.html(str);
          $(this).dialog('close');
          send_ajax(task_id, $td_editor.attr('name'), str)
        }
      }
    ]
  });

  // dialog for comments editor
  $('#comments_dialog').dialog({
    autoOpen: false,
    draggable: false,
    modal: true,
    width: 300,
    draggable: true,
    close: function(event, ui){
      $(this).children('div').remove();      
    },
    open: function(event, ui){
      $td_comment.addClass('active_td');
      $(".ui-dialog-titlebar").hide();
    }
  });

  $('.date-input').datepicker({
    dateFormat: 'yy-mm-dd',
    onClose: function(date, obj){
      task_id = obj.input.parents().eq(1).attr('id');
      send_ajax(task_id, 'date', date);
    }
  });

// =========================== open text editor EVENT ================================== //
  $('.editor').on('dblclick', function() {
    $('#dialog').dialog('close');
    $(this).addClass('active_td');
    $td_editor = $(this);
    $td_field = $(this).children()
    task_id = $(this).parent().attr('id')
    $('#dialog').dialog('open');

    $('.text_editor').tinymce({
      toolbar: 'link',
      plugins: 'link'
    });
  });

// ================ comments_dialog EVENTS ==================== //
  var timer;
  var add_comment_task_id;

  // open comments_dialog
  $('.comments').on('dblclick', function(e){
    $('#dialog').dialog('close'); // close dialog if event start and previous dialog was not closed
    
    $td_comment = $(this) // cell
    add_comment_task_id = $td_comment.parent().attr('id') // tr.attr('id') == Task.id
    
    $('#comments_dialog').dialog('option', 'position', { my: 'left-20 top-20',  of: e } );
    $('#comments_dialog').dialog('open'); // open new dialog
    $('#comments_dialog').prepend($td_comment.children().clone())
  });

  // close comments_dialog
  $('#comments_dialog').on('mouseleave', function(){
    timer = setTimeout(function () {
      $('#comments_dialog').dialog('close');
      $td_comment.removeClass('active_td');
    }, 500);
  }).on("mouseenter", function(){
    clearTimeout(timer);
  });

  // save comment
  $('.comment_save').on("click", function(){
    var body = $('.comment_body').val()
    if(body.length > 0) {
      var values = { 'task_id': add_comment_task_id, 'body': body }; // add_comment_task_id == Task.id
      $.ajax({
        type: 'POST',
        url: 'comments',
        dataType: 'html',
        success: function(resp){
          $('#comments_dialog').children('.comment_list').append($.parseHTML(resp));
          $('#'+add_comment_task_id).children('.comments').children('.comment_list').append($.parseHTML(resp));
          $('.comment_body').val("");
        },
        error: function(){
          console.log("error");
        },
        data: values 
      });
    }
  });

// ================ change assign_to and status EVENTS ==================== //
  $('.user, .status').on('change', function(){
    var task_id = $(this).parents().eq(1).attr('id');
    
    if(task_id) {      
      var field_value = $(this).val();
      var field_name = $(this).attr('name');

      // replace it
      d = new Date();
      $(this).parents().eq(1).children('.date').children('.date-input').val(d.yyyymmdd());

      $.when(send_ajax(task_id, field_name, field_value)).then(function(data, textStatus, jqXHR){
        if(data == 'success'){ // check for server errors 
          if(field_name == 'status'){         
            // check at what page happend this event            
              switch(getParameterByName('only')){
                case 'sold': {
                    //here mast me aaded logic to add price and terms to comments
                    
                  }
                  break;
                case 'declined': {
                             
                  }
                  break;
                default: {
                                  
                  }
              }
              moveTo(field_value);
              $('#'+task_id).remove(); 
          }
        } else {
          error();
        }
      });      
    } 
  });
  
  function send_ajax(task_id, field, value){
    var values = { 'field': field, 'value': value };
    return $.ajax({
            type: 'PATCH',
            url: 'tasks/' + task_id,
            dataType: 'json',
            success: function(){

            },
            error: function(){
              console.log("error");
            },
            data: values 
          });
  }

  Date.prototype.yyyymmdd = function() {
    var yyyy = this.getFullYear().toString();
    var mm = (this.getMonth()+1).toString(); // getMonth() is zero-based
    var dd  = this.getDate().toString();
    return yyyy +'-'+(mm[1]?mm:"0"+mm[0]) +'-'+ (dd[1]?dd:"0"+dd[0]); // padding
  }

  //function parse value of params with 'name' 
  function getParameterByName(name) {
      var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
          results = regex.exec(location.search);
      return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
  }  

  function moveTo(path){
    switch(path) {
      case 'declined': {
          notifie('Task was successful moved to "Declined tasks"')
        }
        break;

      case 'sold': {
          notifie('Task was successful moved to "Sold tasks"')
        }
        break;

      default: {
          notifie('Task was successful moved to "Open tasks"')
        }
        break;
    }
  }

  function notifie(message){
    initNotifierSuccess();
    $notifier.children('.notice-mess').html(message);
    destroyNotifier();
  }

  function error() {
    initNotifierError();
    $notifier.children('.notice-mess').html('Something went wrong, please repeat the action later!');
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

  var notifierTimer;
  function destroyNotifier(){
    notifierTimer = setTimeout(function(){
      $notifier.fadeOut('slow');
    },2000);    
  }
});