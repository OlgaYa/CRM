$(document).ready(function(){
  $('#date-picker-month').datepicker( {
    changeMonth: true,
    changeYear: true,
    dateFormat: 'MM/yy',
    onClose: function(dateText, inst) { 
        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
        $(this).datepicker('setDate', new Date(year, month, 1));
    },
    onChangeMonthYear: function(y, m){
      var date =  m + "/" + y;
      document.location.href = "http://localhost:3000/reports?date_report="+ date;
    }
  });
  $('#add').bind( 'click', function(){
    $('#modal_report').load("reports/new");
  });
  $('#settings').bind('click', function(){
    alert("settings");
  });
  $('.edit').bind( 'click', function(){
    var id = $(this).attr('id-object');
    $('#modal_report').load("reports/" + id + "/edit", function(){
      $('#myModal_edit').modal();
      $('#dpd2').datepicker( {dateFormat: 'dd-mm-yy'});
    });
  });

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
      $selector.append("<li id='"+settings.visible[i][1] + "'>" + settings.visible[i][0] +"</li>");
    }
  }

  function appendInvisibleFields($selector){
    for(var i = 0; i < settings.invisible.length; i = i+1){
      $selector.append("<li id='" + settings.invisible[i][1] + "'>"+ settings.invisible[i][0] +'</li>');
    }
  }
})
