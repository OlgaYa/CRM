$(document).ready(function(){
  debugger;
  var $editableFieldDialog = $('#editable-field')
      $editableFieldTextArea = $('#editable-field-textarea');

  $editableFieldDialog.dialog({
    autoOpen: false,
    resizable: false,
    width: 300,
    height: 100
  });

  $(document).on('dblclick', '.editable-field', function(){
    var currentData = $(this).contents().filter(function() {
      return this.nodeType == 3;
    }).text()
    $editableFieldDialog.dialog('option', 'position', { my: 'left top', at: 'left bottom',  of: $(this) });
    $editableFieldDialog.dialog('option', 'title', capitalize($(this).attr('value')));
    $editableFieldDialog.data('$td', $(this));
    $editableFieldTextArea.val(currentData);
    $editableFieldDialog.dialog('open');
  });

  $editableFieldTextArea.on('keydown', function(event){
    if(event.which === 13){
      var $td = $editableFieldDialog.data('$td'),
          rowId = $td.attr('id'),
          newValue = $editableFieldTextArea.val(),
          d = new Date();
      $.ajax({
        type: "PUT",
        url: "users/update_comment",
        data: {
          id: rowId,
          value: newValue},
        success: function(data) {
          $('.editable-field').html(data);
          $editableFieldTextArea.val('');
          $editableFieldDialog.dialog('close');
        }
      });
    }
  });
});