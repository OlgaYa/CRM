$(document).ready(function(){
  var $editableFieldDialog = $('#editable-field'),
      $editableActivityDialog = $('#activity-dialog'),
      $activityBody = $('#activity-body'),
      $declinedCommentDialog = $('#declined-comment'),
      $declinedCommentBody = $('#declined_comment_body'),
      $pseudoUniqDialog = $('#pseudo-uniq-dialog'),
      $pseudoUniqDialogContent = $('#pseudo-uniq-dialog-content'),
      $editableFieldTextArea = $('#editable-field-textarea'),
      $remainderDialog = $('#remainderDialog'),
      $notifier = $('.notifier'),
      pathFirstPart = '/tables/';

  var MAIN_LOGIC_STATUSES = ['sold', 'declined',
                             'we_declined',
                             'he_declined',
                             'hired',
                             'contact_later'];

  var DECLINE_DIALOG_STATUSES = ['declined',
                                 'we_declined',
                                 'he_declined'];

  var CHECK_DUPLICATE_FIELDS = ['table[phone]',
                                'table[email]',
                                'table[skype]'];

  $editableFieldDialog.dialog({
    autoOpen: false,
    resizable: false,
    width: 300,
    height: 100
  });

  $editableActivityDialog.dialog({
    autoOpen: false,
    modal: true,
    width: 300,
    resizable: false,
    close: function(){
      $(this).children('div').remove();
    }
  });

  $pseudoUniqDialog.dialog({
    autoOpen: false,
    modal: true,
    resizable: false,
    buttons:
      [
        {
          text: 'Delete current',
          click: function(){
            $.ajax({
              type: 'DELETE',
              url: '/tables/' + $pseudoUniqDialog.data('id'),
              success: function(){
                location.reload(true);
              }
            });
          }
        },
        {
          text: 'Ignore',
          click: function(){
            $pseudoUniqDialog.dialog('close');
            $pseudoUniqDialogContent.empty();
          }         
        }
      ]
  });

  // OPTIMIZE
  var reload = true;
  $declinedCommentDialog.dialog({
    autoOpen: false,
    modal: true,
    title: 'Please describe the reason of refusal',
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
            var currentData = $declinedCommentBody.val();
            if(currentData.length > 0){
              reload = false;
              var $td = $(this).data('$td'),
                  dataForSend = $(this).data('dataForSend'),
                  path = $(this).data('path'),
                  d = new Date();
              sendActivityData(currentData, 'comments', $td.id());
              sendData(dataForSend, path, 'status_id', d);
              changeStatus($td.parent(), $declinedCommentDialog.data('status'));
              $declinedCommentBody.val('');
              $(this).dialog('close');
            }
            reload = true;
          }
        }
      ]
  });

  $(document).on('dblclick', '.editable-activity', function(){
    $editableActivityDialog.data('activityName', $(this).attr('value'));
    $editableActivityDialog.data('rowId', $(this).id());
    $editableActivityDialog.data('$td', $(this));
    $editableActivityDialog.dialog('option', 'position', { my: 'left top', at: 'left bottom',  of: $(this) });
    $editableActivityDialog.dialog('option', 'title', capitalize($(this).attr('value')));
    $editableActivityDialog.dialog('open');
    $editableActivityDialog.prepend($(this).children().clone());

  });

  $(document).on('click', '#activity-add', function(){
    var currentData = $activityBody.val(),
        rowId = $editableActivityDialog.data('rowId'),
        activityName = $editableActivityDialog.data('activityName');
    sendActivityData(currentData, activityName, rowId);
  });

  $activityBody.on('keydown', function(event){
    if(event.which === 13){
      var currentData = $activityBody.val(),
          rowId = $editableActivityDialog.data('rowId'),
          activityName = $editableActivityDialog.data('activityName');
      sendActivityData(currentData, activityName, rowId);
    }
  });

  function sendActivityData(inputData, activityName, rowId){
    var $td = $editableActivityDialog.data('$td'),
        dataForSend;

    if(inputData.length > 0){
      switch(activityName){
      case 'links': {
        path = '/tables/links'
        var alt = inputData.match(/[a-z0-9]*(\.?[a-z0-9]+)\.[a-z]{2,10}(:[0-9]{1,10})?(.\/)?/)[0]
        dataForSend = { table_id: rowId, alt: alt, href: inputData };
      }
      break;
      case 'comments': {
        path = '/comments' + location.search;
        dataForSend = { table_id: rowId, body: inputData };
      }
      break;
      }
      $.ajax({
        type: 'POST',
        url: path,
        data: dataForSend,
        success: function(data){
          if (data.comment) {
            $editableActivityDialog.children('div').prepend(data.comment);
            $td.children('div').prepend(data.comment);
            $('.data-table tbody').remove();
            $('.data-table').append(data.table);
            dateInputInit();
          } else {
            $editableActivityDialog.children('div').append(data);
            $td.children('div').append(data);
          }
          $activityBody.val('');
          d = new Date();
          updateDate(rowId, d, activityName);
        }
      });
    }
  }

  $(document).on('dblclick', '.editable-field', function(){
    var currentData = $(this).text();
    $editableFieldDialog.dialog('option', 'position', { my: 'left top', at: 'left bottom',  of: $(this) });
    $editableFieldDialog.dialog('option', 'title', capitalize($(this).attr('value')));
    $editableFieldDialog.data('$td', $(this));
    $editableFieldTextArea.val(currentData);
    $editableFieldDialog.dialog('open');
  });

  $editableFieldTextArea.on('keydown', function(event){
    if(event.which === 13){
      var $td = $editableFieldDialog.data('$td'),
          name = $td.name(),
          rowId = $td.id(),
          newValue = $editableFieldTextArea.val(),
          d = new Date();

      var dataForSend = name + '=' + newValue,
          path = pathFirstPart + rowId;
      $.when(sendData(dataForSend, path, $td.attr('value'), d)).always(function(data, textStatus, jqXHR){
        if(textStatus === 'success') {
          var id,
              name,
              skype,
              email
              flag = false;
          $editableFieldTextArea.val('');
          $editableFieldDialog.dialog('close');
          $td.text(newValue);
          notifie(capitalize($td.attr('value')) + ' was successfully updated', $notifier);
          updateDate(rowId, d, $td.attr('value'));
          if(data.pseudo_uniq){
            for(var i = 0; i < data.candidates.length; i = i + 1) {
              if(data.candidates[i].id != rowId){
                flag = true;
                id = document.createElement('div');
                name = document.createElement('div');
                skype = document.createElement('div');
                email = document.createElement('div');
                phone = document.createElement('div');
                $(id).text('id: ' + data.candidates[i].id);
                $(name).text('name: ' + data.candidates[i].name);
                $(skype).text('skype: ' + data.candidates[i].skype);
                $(email).text('email: ' + data.candidates[i].email);
                $(phone).text('phone: ' + data.candidates[i].phone);
                $pseudoUniqDialogContent.append($(id))
                                        .append($(name))
                                        .append($(skype))
                                        .append($(email))
                                        .append($(phone))
                                        .append('<hr>');
                $pseudoUniqDialog.data('id', data.id);
              }
              if(flag) {
                $pseudoUniqDialog.dialog('option', 'title', 'Similar contacts with ' + rowId);
                $pseudoUniqDialog.dialog('open');
              }
             }
          }
        } else {
          error('', $notifier);
        }
      });
    }
  });

// OPTIMIZE
  $(document).on('change', '.selectable-field', function(){
    var selectedText = $(this).children(':selected').text().toLowerCase(),
        dataForSend = $(this).name() + '=' + $(this).val(),
        rowId = $(this).parent().id(),
        path = pathFirstPart + rowId,
        d = new Date(),
        fieldName = $(this).attr('fieldname'),
        $td = $(this).parent();
    if(fieldName === 'status_id' && isInArray(selectedText, DECLINE_DIALOG_STATUSES)){
      $declinedCommentDialog.data('$td', $td);
      $declinedCommentDialog.data('dataForSend', dataForSend);
      $declinedCommentDialog.data('path', path);
      $declinedCommentDialog.data('status', selectedText);
      $declinedCommentDialog.dialog('open');
      return false;
    }
    if(fieldName === 'status_id' && selectedText === 'contact_later'){
      $remainderDialog.data('$td', $td);
      $remainderDialog.data('dataForSend', dataForSend);
      $remainderDialog.data('path', path);
      $remainderDialog.data('status', selectedText);
      $remainderDialog.modal();
      return false;
    }
    $.when(sendData(dataForSend, path, fieldName, d)).always(function(data, textStatus, jqXHR){
      if(textStatus === 'success'){
          updateDate(rowId, d, $td.children().attr('fieldname'));
          if($td.children().attr('fieldname') === 'status_id') {
            if(selectedText === 'assigned_meeting' || selectedText === 'interview'){
              $('#myModal').modal();
              $('#_meeting_table_id')[0].setAttribute('value',rowId);
            }
            changeStatus($td.parent(), selectedText);
          } else {
            notifie('Field was successfully updated', $notifier);
          }
        } else {
          error('', $notifier);
        }
    });
    return false;
  });

  $(document).on('click', '#remainder-dialog-save-button', function(){
    var currentData = $('#remainder-date-time').val(),
        $td = $remainderDialog.data('$td'),
        dataForSend = $remainderDialog.data('dataForSend'),
        path = $remainderDialog.data('path'),
        d = new Date();
    if(currentData.length > 0){
      sendData('table[reminder_date]=' + currentData, path, 'reminder_date', d)
      if(dataForSend){
        sendData(dataForSend, path, 'status_id', d);
        changeStatus($td.parent(), $remainderDialog.data('status'));
      }
      if($td.hasClass('date-time-editable')){
        $td.text(currentData);
        notifie('Reminder date was successful changed', $notifier)
      }
    }
    $remainderDialog.modal('hide');
  });

  $(document).on('dblclick', '.date-time-editable',function(){
    var rowId = $(this).id(),
        path = pathFirstPart + rowId;
    $remainderDialog.data('$td', $(this));
    $remainderDialog.data('path', path);
    $('#remainder-date-time').val($(this).text())
    $remainderDialog.modal();
  });

  function changeStatus($row, field_text){
    if(isInArray(getParameterByName('only'), MAIN_LOGIC_STATUSES))
      moveTo($row, field_text);
    else {
      if(isInArray(field_text, MAIN_LOGIC_STATUSES)){
        moveTo($row, field_text);
      } else {
        notifie('Task status was successful changed', $notifier)
      }
    }
  }

  function moveTo($row, path){
    $row.remove();
    switch(path) {
    case 'declined': {
      notifie('Task was successful moved to "Declined" section', $notifier)
    }
    break;
    case 'sold': {
      notifie('Task was successful moved to "Sold" section', $notifier)
    }
    break;
    case 'hired': {
      notifie('Candidate was successful moved to "Hired" section', $notifier)
    }
    break;
    case 'we_declined': {
      notifie('Candidate was successful moved to "We Declined" section', $notifier)
    }
    break;
    case 'he_declined': {
      notifie('Candidate was successful moved to "He Declined" section', $notifier)
    }
    break;
    case 'contact_later': {
      notifie('Candidate was successful moved to "Contact Later" section', $notifier)
    }
    break;
    default: {
      notifie('It was successful moved to "Open" section', $notifier)
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

  //dialog for change date
  var flag = false;
  function dateInputInit(){
    $('.date-input').datepicker({
      dateFormat: 'yy-mm-dd',
      onSelect: function(date, obj){
        flag = true;
      },
      onClose: function(date, obj){
        if(flag){
          var $td = obj.input.parent(),
              path = pathFirstPart + $td.id(),
              dataForSend = $(obj.input).name() + '=' + date;

          $.when(sendData(dataForSend, path, 'date')).always(function(data, textStatus, jqXHR){
            if(textStatus == 'success'){
              notifie('Date has been successfully updated!', $notifier);
            } else {
              error('', $notifier);
            }
          })
          flag = false;
        }
      }
    });
  }
  dateInputInit();

  $(document).on('change', '.controll', function(){
    $('#' + this.value).toggleClass('warning');
  })

  $(document).on('click', '.delete', function(){
    if($('.controll:checked').size() === 0){
      error('Please select some row', $notifier);
      return false;
    } else {
      if(confirm('Are you sure you want to delete selected rows?')){
        $('.controll:checked').each(function(){
          var id = this.value;
          $.ajax({
            type: 'DELETE',
            url: '/tables/' + id
          });
        });
      }
    }
    return false;
  });

  function sendData(dataForSend, path, fieldName, d){
    var table_type = getParameterByName('type');
    return $.ajax({
        type: 'PUT',
        url: path + '?type=' + table_type,
        data: dataForSend
      })
  }

  function updateDate(row_id, d, fieldName) {
    if(fieldName == 'comments'){
      $('#'+row_id).children('.td-date').children('.date-input').val(d.yyyymmdd());
    }
  }

  Date.prototype.yyyymmdd = function() {
    var yyyy = this.getFullYear().toString();
    var mm = (this.getMonth()+1).toString(); // getMonth() is zero-based
    var dd  = this.getDate().toString();
    return yyyy +'-'+(mm[1]?mm:"0"+mm[0]) +'-'+ (dd[1]?dd:"0"+dd[0]); // padding
  }

  $.fn.name = function(){
    return $(this).attr('name');
  }

  $.fn.id = function() {
    return $(this).parent().attr('id');
  }

  $('.date-input-filter').datepicker({
    dateFormat: 'yy-mm-dd',
  });

  /* ====================== Hiding columns ========================= */
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
            path = 'tables/update_table_settings' + location.search;

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
        appendVisibleFields($('#visible-fields'))
      }
      if(settings.invisible){
        appendInvisibleFields($('#invisible-fields'))
      }
    }
  });

  $('#table-settings').on('click', function(){
    $('#table-settings-dialog').dialog('open');
  });

  $( "#invisible-fields, #visible-fields" ).sortable({
    connectWith: ".connectedSortable"
  }).disableSelection();

  (function(){
    var path = 'tables/table_settings' + location.search;
    $.ajax({
      type: 'GET',
      url: path,
      success: function(data){
        settings = data;
       
        if(data.visible){
          appendVisibleFields($('#visible-fields'))
        }

        if(data.invisible){
          appendInvisibleFields($('#invisible-fields'))
        }
      }
    });
  })();

  function appendVisibleFields($selector){
    var i = 0;
    for(i; i < settings.visible.length; i = i+1){
      $selector.append('<li>'+ settings.visible[i] +'</li>')
    }
  }
  
  function appendInvisibleFields($selector){
    var i = 0;
    for(i; i < settings.invisible.length; i = i+1){
      $selector.append('<li>'+ settings.invisible[i] +'</li>')
    }
  }

  $.fn.listVars = function(){
    var result = [];
    $(this).children('li').each(function(){
      result.push($(this).text());
    })
    return result;
  }
});

$(function () {
  $(".chosen-select").chosen();
  $('#datetimepicker6').datetimepicker({ format: 'DD/MM/YYYY HH:mm' });
  $('#datetimepicker7').datetimepicker({ format: 'DD/MM/YYYY HH:mm' });
  $("#datetimepicker6").on("dp.change",function (e) {
    $('#datetimepicker7').data("DateTimePicker").minDate(e.date);
  });
  $("#datetimepicker7").on("dp.change",function (e) {
    $('#datetimepicker6').data("DateTimePicker").maxDate(e.date);
  });
  $('#datetimepicker_reminder').datetimepicker({format: 'DD/MM/YYYY HH:mm'});
});

