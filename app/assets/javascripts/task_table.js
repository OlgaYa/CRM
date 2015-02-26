

$(document).on("ready page:load", function(){
  var $td
  var $td_field
  var $td_comment

  $('#dialog').dialog({
    autoOpen: false,
    closeOnEscape: true,
    close: function(event, ui){
      $td.removeClass('active_td');
    },
    open: function(event, ui){
      $(".ui-dialog-titlebar").show();
      $input = $(this).children('textarea');
      str = $td_field.html();
      $input.val(str); 
    },
    buttons: [
      {
        text: "Close",
        click: function() {
          $(this).dialog('close');
        }
      },
      
      {
        text: "Save",
        click: function() {
          str = $(this).children('textarea').val();
          $td_field.empty();
          $td_field.html(str);
          $(this).dialog('close');
          send_ajax(task_id, $td.attr('name'), str)
        }
      }
    ]
  });

  $('#comments_dialog').dialog({
    autoOpen: false,
    draggable: false,
    modal: true,
    width: 300,
    close: function(event, ui){
      $(this).children('div').remove();      
    },
    open: function(event, ui){
      $td_comment.addClass('active_td');
      $(".ui-dialog-titlebar").hide();
    }
  });

  $('.editor').on('dblclick', function() {
    $('#dialog').dialog('close');
    $(this).addClass('active_td');
    $td = $(this);
    $td_field = $(this).children()
    task_id = $(this).parent().attr('id')
    $('#dialog').dialog('open');

    $('.text_editor').tinymce({
      toolbar: 'link',
      plugins: 'link'
    });
  });

  $('.user, .status').on('change', function(){
    task_id = $(this).parents().eq(1).attr('id');
    if(task_id) {
      send_ajax(task_id, $(this).attr('name'), $(this).val())
      if($(this).attr('name')==='status'){ 
        d = new Date();
        $(this).parents().eq(1).children('.date').children('.date-input').val(d.yyyymmdd());
      }
    } 
  });

  var timer;
  var add_comment_task_id;
  $('.comments').on("dblclick", function(e){
    $('#dialog').dialog('close');
    $td_comment = $(this)
    add_comment_task_id = $td_comment.parent().attr('id')
    $('#comments_dialog').dialog('option', 'position', { my: "left-20 top-20",  of: e } );
    $('#comments_dialog').dialog('open');
    $('#comments_dialog').prepend($td_comment.children().clone())
  });

  $('#comments_dialog').on("mouseleave", function(){
    timer = setTimeout(function () {
      $('#comments_dialog').dialog('close');
      $td_comment.removeClass('active_td');
    }, 500);
  }).on("mouseenter", function(){
    clearTimeout(timer);
  });

  $('.comment_save').on("click", function(){
    body = $('.comment_body').val()
    if(body.length > 0) {
      var values = { 'task_id': add_comment_task_id, 'body': body };
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
  
  $('.date-input').datepicker({
    dateFormat: "yy-mm-dd",
    onClose: function(date, obj){
      task_id = obj.input.parents().eq(1).attr('id');
      send_ajax(task_id, 'date', date);
    }
  });
});

function send_ajax(task_id, field, value){
  var values = { 'field': field, 'value': value };
  $.ajax({
    type: 'PATCH',
    url: 'tasks/' + task_id,
    dataType: 'json',
    success: function(resp){
      console.log(resp);
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
};

