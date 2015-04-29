$(document).ready(function(){
  var $editableFieldDialog = $('#editable-field'),
      $editableActivityDialog = $('#activity-dialog'),
      $activityBody = $('#activity-body'),
      $declinedCommentDialog = $('#declined-comment'),
      $declinedCommentBody = $('#declined_comment_body'),
      $editableFieldTextArea = $('#editable-field-textarea'),
      $remainderDialog = $('#remainderDialog'),
      $notifier = $('.notifier'),
      pathFirstPart = '/tables/';

  var MAIN_LOGIC_STATUSES = ['sold', 'declined',
                             'we_declined',
                             'he_declined',
                             'hired',
                             'contact_later']

  var DECLINE_DIALOG_STATUSES = ['declined',
                                 'we_declined',
                                 'he_declined']

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

  $('.editable-activity').on('dblclick', function(){
    $editableActivityDialog.data('activityName', $(this).attr('value'));
    $editableActivityDialog.data('rowId', $(this).id());
    $editableActivityDialog.data('$td', $(this));
    $editableActivityDialog.dialog('option', 'position', { my: 'left top', at: 'left bottom',  of: $(this) });
    $editableActivityDialog.dialog('option', 'title', capitalize($(this).attr('value')));
    $editableActivityDialog.dialog('open');
    $editableActivityDialog.prepend($(this).children().clone());
  });

  $('#activity-add').on('click', function(){
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
        path = '/comments'
        dataForSend = { table_id: rowId, body: inputData }
      }
      break;
      }
      $.ajax({
        type: 'POST',
        url: path,
        data: dataForSend,
        success: function(data){
          $editableActivityDialog.children('div').append(data);
          $td.children('div').append(data);
          $activityBody.val('');
          d = new Date();
          updateDate(rowId, d, activityName);
        }
      });
    }
  }

  $('.editable-field').on('dblclick', function(){
    var currentData = $(this).text();
    $editableFieldDialog.dialog('option', 'position', { my: 'left top', at: 'left bottom',  of: $(this) });
    $editableFieldDialog.dialog('option', 'title', capitalize($(this).attr('value')));
    $editableFieldDialog.data('$td', $(this));
    $editableFieldTextArea.val(currentData);
    $editableFieldDialog.dialog('open');
  });

  $editableFieldTextArea.on('keydown', function(event){
    if(event.which===13){
      var $td = $editableFieldDialog.data('$td'),
          name = $td.name(),
          rowId = $td.id(),
          newValue = $editableFieldTextArea.val(),
          d = new Date();

      var dataForSend = name + '=' + newValue,
          path = pathFirstPart + rowId;

      $.when(sendData(dataForSend, path, $td.attr('value'), d)).always(function(data, textStatus, jqXHR){
        if(textStatus==='success'){
          $editableFieldTextArea.val('');
          $editableFieldDialog.dialog('close');
          $td.text(newValue);
          notifie(capitalize($td.attr('value')) + ' was successfully updated', $notifier);
          updateDate(rowId, d, $td.attr('value'));
        } else {
          error('', $notifier);
        }
      });
    }
  });

// OPTIMIZE
  $('.selectable-field').on('change', function(){
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
      if(textStatus==='success'){
          updateDate(rowId, d, $td.children().attr('fieldname'));
          if($td.children().attr('fieldname') === 'status_id') {
            if(selectedText == 'assigned_meeting'){
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

  $('#remainder-dialog-save-button').on('click', function(){
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

  $('.date-time-editable').on('dblclick',function(){
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

  $('.controll').on('change', function(){
    $('#' + this.value).toggleClass('warning');
  })
  $('.delete').on('click', function(){
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
    if( ['topic', 'source_id', 'name', 'date'].indexOf(fieldName) === -1 ){
      dataForSend += '&table[date]=' + d;
    }
    return $.ajax({
        type: 'PUT',
        url: path,
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

