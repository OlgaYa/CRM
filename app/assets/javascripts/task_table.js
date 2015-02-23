 
$(function(){
  var $td
  var $td_field

  $('#dialog').dialog({
    autoOpen: false,
    closeOnEscape: true,
    // баг с использованием фокуса
    // modal: true,
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
      $(".ui-dialog-titlebar").hide();
    }
  });

  $('.editor').dblclick(function() {
    $(this).addClass('active_td');
    $td = $(this);
    $td_field = $(this).children()
    task_id = $(this).parent().attr('id')
    
    //open popup 
    $('#dialog').dialog('open');

    //open popup with text editor
    $('.text_editor').tinymce({
      toolbar: 'link',
      plugins: 'link'
    });
  });

  $('.user, .status').change(function(){
    task_id = $(this).parents().eq(1).attr('id');
    send_ajax(task_id, $(this).attr('name'), $(this).val())
    if($(this).attr('name')==='status'){ 
      d = new Date();
      $(this).parents().eq(1).children('.date').text(d.yyyymmdd());
    } 
  });

  var timer;
  $('.comments').on("dblclick", function(e){
    $td_comment = $(this)
    $('#comments_dialog').dialog('option', 'position', { my: "left-20 top-20",  of: e } );
    $('#comments_dialog').dialog('open');
    $('#comments_dialog').prepend($(this).children().clone())
  });

  $('#comments_dialog').on("mouseleave", function(){
    timer = setTimeout(function () {
      $('#comments_dialog').dialog('close');
    }, 500);
  }).on("mouseenter", function(){
    clearTimeout(timer);
  });
});

function send_ajax(task_id, field, value){
  var values = { 'field': field, 'value': value };
  $.ajax({
    type: 'PATCH',
    url: 'tasks/' + task_id,
    dataType: 'json',
    success: function(resp){
      //тут должна быть адекватная реакция
      console.log(resp);
    },
    error: function(){
      //тут должна быть адекватная реакция
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


