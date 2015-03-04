// $(document).on('ready page:load', function(){
$(document).ready(function(){
  var $notifier = $('.notifier');
  var notifierTimer;

  var $commonDialog   = $('#common-dialog');
  var $commentsDialog = $('#comments_dialog');
  var $declinedCommentDialog = $('#declined-comment');
  var $priceDialog = $('#price-dialog');

  var $textEditor = $('#text-editor');
  var $commentBody = $('#comment_body');
  var $priceInput = $('#price');


// =========================== DIALOGS INIT ======================================= //

  //dialog for fields name, source, skype, email, links
  $commonDialog.dialog({
    autoOpen: false,
    closeOnEscape: true,
    resizable: false,
    maxHeight: 200,
    width: 300,
    closeText: 'close',
    open: function (event, ui){
      $('.ui-dialog-titlebar').show();
      $td = $commonDialog.data('$currentTD');
      $td.active();
      var tdContent = $td.text();
      $textEditor.val(tdContent.trim());
    },
    close: function (event, ui){
      $td = $commonDialog.data('$currentTD');
      $td.nonActive();
    }
  });

   // dialog for comments editor
  $commentsDialog.dialog({
    autoOpen: false,
    draggable: false,
    modal: true,
    width: 300,
    close: function(event, ui){
      $td = $commentsDialog.data('$td')
      $(this).children('div').remove();
      $td.nonActive();      
    },
    open: function(event, ui){
      $td = $commentsDialog.data('$td');
      $td.active();      
      $(".ui-dialog-titlebar").hide();
    }
  });

  //dialog for change date
  var flag = false;
  $('.date-input').datepicker({
    dateFormat: 'yy-mm-dd',
    onSelect: function(date, obj){
      flag = true;
    },
    onClose: function(date, obj){
      if(flag){
        var task_id = obj.input.parents().eq(1).attr('id');
        var sold_task_id = $(obj.input).siblings('.id').val();
        var filedName = obj.input.attr('name');
        var path;
        var values = { 'field': filedName, 'value': date };
        if(filedName == 'date'){
          path = 'tasks/' + task_id; 
        } else {
          path = 'sold_tasks/' + sold_task_id;
        }
        $.when(sendARequest(path, values)).always(function(data, textStatus, jqXHR){
          if(textStatus == 'success'){
            notifie( capitalize(filedName) + ' has been successfully updated!');
          } else {
            error();
          }
        })
        flag = false;      
      }
    }
  });

  // popup after chenge status to "Decline"
  var reload = true;
  $declinedCommentDialog.dialog({
    autoOpen: false,
    modal: true,
    title: 'Please describe the reason of refusal',
    open: function(event, ui){
      $('.ui-dialog-titlebar').show();
    },
    close: function(event, ui){
      if(reload){
        location.reload(true);
      }
    }, 
    buttons: 
      [ 
        { 
          text: 'Close',
          click: function(){
            $(this).dialog('close');
            location.reload(true);
          }
        },
        {
          text: 'Save',
          click: function(){
            task_id = $(this).data('task_id');
            body = $('#declined_comment_body').val();
            $('#declined_comment_body').val("");
            if(body.length > 0){
              addComment(task_id, body);
              changeStatus(task_id, $(this).data('field_name'), $(this).data('field_value'), $(this).data('$field'));
              reload = false; 
              $(this).dialog('close');
              reload = true;
            }
          }
        }
      ]
  });

  //dialog for price
  $priceDialog.dialog({
    autoOpen: false,
    height: 100,
    open: function(event, ui){
      $('.ui-dialog-titlebar').show();
      $td = $priceDialog.data('$td');
      $td.active();
    }, 
    close: function(event, ui){
      $td = $priceDialog.data('$td');
      $td.nonActive();
    }
  });

// =========================== EVENTS ======================================= //
  
  // ======= open  name, source, skype, links, email editor EVENT ========= //
  $('.editable-field').on('dblclick', function(){    
    closeAllDialogs();
    title = $(this).attr('name');    
    $commonDialog.dialog('option', 'title', capitalize(title));
    $commonDialog.data('$currentTD', $(this));
    $commonDialog.dialog('open');
  });

  // update field after press enter on text editor (common dialog)
  $textEditor.on('keypress', function(e){
    if(e.keyCode == 13 ){
      $td = $commonDialog.data('$currentTD');
      var editorContent = $textEditor.val();
      var filedName = $td.attr('name');
      var taskId = $td.parent().attr('id');
      $td.html(editorContent);
      $commonDialog.dialog('close');
      
      var path = 'tasks/' + taskId
      var values = { 'field': filedName, 'value': editorContent };
      $.when(sendARequest(path, values)).always(function(data, textStatus, jqXHR){
        if(textStatus == 'success'){
          notifie(capitalize(filedName) + ' has been successfully updated!');
        } else {
          error();
        }
      });
    }
  });

  // =========================== open price editor EVENT ================================== //
  $('.price').on('dblclick', function() {
    closeAllDialogs();
    sold_task_id = $(this).children('.id').val();
    $td_field = $(this).children()
    $priceInput.val($(this).children().text().trim())
    $priceDialog.data('$td', $(this));
    $priceDialog.data('sold_task_id', sold_task_id);
    $priceDialog.dialog('open');
  });

  $priceInput.on('keypress', function(e){
    if(e.keyCode == 13 ){
      var price = $priceInput.val();
      if(price.length > 0){
        $.when(sendARequest('sold_tasks/' + $priceDialog.data('sold_task_id'), 
                            {'field': 'price', 'value': price })).always(function(data){
          if(data == 'success') { 
            $td_field.empty();
            $td_field.html(price);
            $priceDialog.dialog('close');
            notifie('Price was successful updated')      
          } else {
            error();
          }      
        });
      } else {
        error('Please type only numbers');
      }
    }
  });

  // ============================== COMMENTS ================================== //
  var timer;
  // open comments_dialog
  $('.comments').on('dblclick', function(e){    
    closeAllDialogs();
    var $td = $(this) // cell
    var task_id = $td.parent().attr('id') // tr.attr('id') == Task.id
    $commentsDialog.data('task_id', task_id);
    $commentsDialog.data('$td', $td);
    $commentsDialog.dialog('option', 'position', { my: 'left-20 top-20',  of: e } );
    $commentsDialog.dialog('open'); // open new dialog
    $commentsDialog.prepend($td.children().clone())
  });

  // close comments_dialog
  $commentsDialog.on('mouseleave', function(){
    timer = setTimeout(function () {
      $commentsDialog.dialog('close');
    }, 500);
  }).on("mouseenter", function(){
    clearTimeout(timer);
  });

  // save comment
  $('.comment_save').on("click", function(){
    var body = $commentBody.val();
    var task_id = $commentsDialog.data('task_id');
    if(body.length > 0) {
      addComment(task_id, body);
    }
  });

  function addComment(task_id, body){
    var values = { 'task_id': task_id, 'body': body }; // add_comment_task_id == Task.id
      $.ajax({
        type: 'POST',
        url: 'comments',
        dataType: 'html',
        success: function(resp){
          $commentsDialog.children('.comment_list').append($.parseHTML(resp));
          $('#'+task_id).children('.comments').children('.comment_list').append($.parseHTML(resp));
          $commentBody.val("");
        },
        data: values 
      });
  }

// ================ change assign_to and status EVENTS ==================== //
  $('.user, .status').on('change', function(event){

    var task_id = $(this).parents().eq(1).attr('id');
    var $field = $(this);       
    var field_name = $(this).attr('name');
    var field_value = $(this).val();

    if(field_name == 'status'){
      if(field_value == 'declined'){
        closeAllDialogs();
        $declinedComment = $('#declined-comment');
        $declinedComment.data('field_name', field_name);
        $declinedComment.data('task_id', task_id);
        $declinedComment.data('field_value', field_value);
        $declinedComment.data('$field', $field);
        $declinedComment.dialog('open');
      } else {       
        changeStatus(task_id, field_name, field_value, $field);
      }
    } else {
      changeUser(task_id, field_name, field_value, $field);
    }

    return false;
  });

  function changeStatus(task_id, field_name, field_value, $field){    
    $.when(sendARequest('tasks/' + task_id, { 'field': field_name, 'value': field_value })).always(function(data){
      if(data == 'success'){
        d = new Date();
        $field.parents().eq(1).children('.date').children('.date-input').val(d.yyyymmdd());   
        // check at what page happend this event            
        switch(getParameterByName('only')){
          case 'sold': {
              moveTo(task_id, field_value);                  
            }
            break;
          case 'declined': {
              moveTo(task_id, field_value);       
            }
            break;
          default: {
              if(field_value == 'declined' || field_value == 'sold'){                   
                moveTo(task_id, field_value);
              } else {
                notifie('Task status was successful changed')
              }
            }
        }           
      } else {
        error();
      }      
    });
  }

  function changeUser(task_id, field_name, field_value, $field){
    $.when(sendARequest('tasks/' + task_id, { 'field': field_name, 'value': field_value })).always(function(data){
      if(data == 'success') { 
          notifie('Task status was successful reassigned')      
      } else {
        error();
      }      
    });
  }

  function moveTo(task_id, path){
    $('#'+task_id).remove();
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

  //function parse value of params with 'name' 
  function getParameterByName(name) {
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
  }  

// ========================== AJAX ========================================= //
  function sendARequest(path, values){
    return $.ajax({
            type: 'PATCH',
            url: path,
            dataType: 'json',
            data: values 
          });
  }

//============================ HELPERS ============================================//
  function capitalize(string) {
    return string.charAt(0).toUpperCase() + string.slice(1); 
  }

  $.fn.active = function(){
    this.addClass('active-td');
  }

  $.fn.nonActive = function(){
    this.removeClass('active-td');
  }  

  Date.prototype.yyyymmdd = function() {
    var yyyy = this.getFullYear().toString();
    var mm = (this.getMonth()+1).toString(); // getMonth() is zero-based
    var dd  = this.getDate().toString();
    return yyyy +'-'+(mm[1]?mm:"0"+mm[0]) +'-'+ (dd[1]?dd:"0"+dd[0]); // padding
  }  

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

  function closeAllDialogs(){
    $commonDialog.dialog('close');
    $priceDialog.dialog('close');
  }  
});