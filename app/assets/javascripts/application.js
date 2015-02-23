// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/dialog
//= require turbolinks
//= require tinymce-jquery
//= require_tree .

 
$(function(){
  var task_id
  var $td
  var $td_field

  $('#dialog').dialog({
    autoOpen: false,
    // баг с использованием фокуса
    // modal: true,
    close: function(event, ui){
      $td.removeClass('info');
    },
    open: function(event, ui){
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

  $('.editor').dblclick(function() {
    $(this).addClass('info');
    $td = $(this);
    $td_field = $(this).children()
    task_id = $(this).parent().attr('id')
    
    //open popup 
    $('#dialog').dialog('open');

    $('textarea').tinymce({
      toolbar: 'link',
      plugins: 'link'
    });
  });

  $('.user, .status').change(function(){
    task_id = $(this).parents().eq(1).attr('id');
    send_ajax(task_id, $(this).attr('name'), $(this).val())
    if($(this).attr('name')==='status'){ 
      // debugger;
      d = new Date();
      $(this).parents().eq(1).children('.date').text(d.yyyymmdd());
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

// Prevent jQuery UI dialog from blocking focusin
// $(document).on('focusin', function(e) {
//     if ($(event.target).closest(".mce-window").length) {
//       e.stopImmediatePropagation();
//   }
// });