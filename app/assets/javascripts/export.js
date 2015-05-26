 $(document).ready(function(){
  var $allStatuses = $('#All_statuses');
  var $allFields = $('#All_fields');
  var $allUsers = $('#All_users');
  var $allLevels = $('#All_levels');
  var $allSpecializations = $('#All_specializations');

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
  $allLevels.on('change', function(){
    check(this, $('#levels'));
  });

  $allSpecializations.on('change', function(){
    check(this, $('#specializations'));
  });

  function check(checkBox, selector){
    if(checkBox.checked){
      selector.checkedAll(true);  
    } else {
      selector.checkedAll(false);
    }
  }

  $('.hasDatepicker').on('submit', function(){
    return false;
  });

});

$.fn.checkedAll = function(bool){
  this.children('input').prop('checked', bool);
}