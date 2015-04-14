 $(document).ready(function(){
  var $allStatuses = $('#All_statuses');
  var $allFields = $('#All_fields');
  var $allUsers = $('#All_users');

  $( ".from" ).datepicker({
    defaultDate: "+1w",
    changeMonth: true,
    numberOfMonths: 3,
    dateFormat: 'yy-mm-dd',
    onClose: function( selectedDate ) {
      $( ".to" ).datepicker( "option", "minDate", selectedDate );
    }
  });
  $( ".to" ).datepicker({
    defaultDate: "+1w",
    changeMonth: true,
    numberOfMonths: 3,
    dateFormat: 'yy-mm-dd',
    onClose: function( selectedDate ) {
      $( ".from" ).datepicker( "option", "maxDate", selectedDate );
    }
  });

  $allStatuses.on('change', function(){
    check(this, $('#statuses'));
  });

  $allFields.on('change', function(){
    check(this, $('#fields'));
  });

  $allUsers.on('change', function(){
    check(this, $('#users'));
  });

  function check(checkBox, selector){
    if(checkBox.checked){
      selector.checkedAll(true);  
    } else {
      selector.checkedAll(false);
    }
  }
});

$.fn.checkedAll = function(bool){
  this.children('input').prop('checked', bool);
}