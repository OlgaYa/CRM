
$(document).on('change', '.select-year-and-month',function(){
  this.submit();
});

$(document).ready(function(){

  var settings;
  $('#table-settings-dialog').dialog({
    autoOpen: false,
    title: 'Table settings',
    width: 410,
     buttons: {
      Cancel: function() {
        $( this ).dialog( "close" );
      },
      "Save": function() {
        var dataForSend = { invisible: $('#invisible-fields').listVars() },
            path = 'reports/update_report_settings';

        $.when($.ajax({
          type: 'POST',
          url: path,
          data: dataForSend
        })).always(function(data, textStatus, jqXHR){
          if(textStatus==='success'){
            location.reload(true);
          }
        })
      }
    },
    close: function(){
      $('#visible-fields').empty();
      $('#invisible-fields').empty();
      if(settings.visible){
        appendVisibleFields($('#visible-fields'));
      }
      if(settings.invisible){
        appendInvisibleFields($('#invisible-fields'));
      }
    }
  });

  $('#table-settings').on('click', function(){
    $('#table-settings-dialog').dialog('open');
  });

  $.fn.listVars = function(){
    var result = [];
    $(this).children('li').each(function(){
      result.push($(this).attr('id'));
    })
    return result;
  }

  $("#report_project_id").chosen();

  $( "#invisible-fields, #visible-fields" ).sortable({
    connectWith: ".connectedSortable"
  }).disableSelection();

  (function(){
    var path = 'reports/reports_settings';
    $.ajax({
      type: 'GET',
      url: path,
      success: function(data){
        settings = data;
        if(data.visible){
          appendVisibleFields($('#visible-fields'));
        }

        if(data.invisible){
          appendInvisibleFields($('#invisible-fields'));
        }
      }
    });
  })();

  function appendVisibleFields($selector){
    for(var i = 0; i < settings.visible.length; i = i+1){
      $selector.append("<li id='"+settings.visible[i][1] + "' class=" + settings.visible[i][2]+">" + settings.visible[i][0] + "</li>");
    }
  }

  function appendInvisibleFields($selector){
    for(var i = 0; i < settings.invisible.length; i = i+1){
      $selector.append("<li id='"+settings.invisible[i][1] + "' class=" + settings.invisible[i][2]+">" + settings.invisible[i][0] + "</li>");
    }
  }
})
