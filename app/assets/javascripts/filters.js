$(document).ready(function(){
  
  /*=========================== FILTERS ===============================*/
  
  var stDefaultOptions = [['equally', '_eq'],
                          ['not equally', '_not_eq'],
                          ['missing', '_null']];

  var dateOptions      = [['from', '_gteq'],
                          ['to', '_lteq'],
                          ['between', '_between']];

  var numberOptions    = [['equally', '_eq'],
                          ['not equally', '_not_eq'],
                          ['missing', '_null']];

  var presentFilters = [];


  init(fParams, fdata);

  function init(fParams, data){

    if (data) {
      data = JSON.parse(data);
    }
    for(i in data) {
      if(i.indexOf('_not_eq_all') > -1){
        buildFromParams(data, i, '_not_eq_all', '_not_eq');
        continue;
      }
      if(i.indexOf('_eq_any') > -1){
        buildFromParams(data, i, '_eq_any', '_eq');
        continue;                
      }
      if(i.indexOf('_not_eq') > -1){
        buildFromParams(data, i, '_not_eq');
        continue;               
      }
      if(i.indexOf('_eq') > -1){
        buildFromParams(data, i, '_eq');
        continue;
      }
      if(i.indexOf('_gteq') > -1){
        buildFromParams(data, i, '_gteq');
        continue;
      }
      if(i.indexOf('_lteq') > -1){
        buildFromParams(data, i, '_lteq');
        continue;
      }
      if(i.indexOf('_null') > -1){
        buildFromParams(data, i, '_null');
        continue;
      }
    }            
  };

  function buildFromParams(data, i, subStr, exclusion){
    var value = '';
    var filter_type = '';
    var option;
    var selectedValue;
    var $filterOption;
    var filterFields;
    var flag = false;

    value = i.replace(subStr, '');
    if(presentFilters.indexOf(value) > -1){
      flag = true;
    } 
    presentFilters.push(value);
    selectedValue = data[i];
    filterFields = existingFilters(value);
    if(exclusion){
      $filterOption = $('select [value=' + value + exclusion + ']');
    } else {
      $filterOption = $('select [value=' + i + ']');
    }
    selectOptionAndValues($filterOption, filterFields, selectedValue);
    
    if(flag) {
      if(value === 'date') {
        var $toDate;
        var $fromDate; 
        $('.date-filter').each(function(){
          if(this.name === 'q[date_lteq]'){
            $toDate = $(this);
          } else {
            $fromDate = $(this);
          }
        })
        $toDate.attr('id', 'temp-date-filter');
        var $toDateParent = $toDate.parent().parent();
        $fromDate.parent().append($toDate);
        $fromDate.parent().children('.filter-commands').children('select [value=date_between]').attr('selected', true);
        $toDateParent.remove();
      }
    }
  }

  function selectOptionAndValues($filterOption, filterFields, selectedValue) {
    $filterOption.attr('selected', true);
    $(filterFields).attr('name', 'q[' + $filterOption.val() + ']');
    if($(filterFields).is('input')){
      $(filterFields).val(selectedValue);
    } else {
      if(selectedValue) {
        if( Object.prototype.toString.call( selectedValue ) === '[object Array]' ) {
          $(filterFields).parent().children('.multiple').removeClass('glyphicon-plus').addClass('glyphicon-minus');
          toMultiple(filterFields.id, true);
          var i = 0;
          for (i; i < selectedValue.length; i = i + 1){
            $(filterFields).children('[value=' + selectedValue[i] + ']').attr('selected', true);
          }
        } else {
          if(selectedValue === 'true') {
            $filterOption.change();
          } else {
            $(filterFields).children('[value=' + selectedValue + ']').attr('selected', true);
          }
        }
      } 
    }
  }

  function existingFilters(value) {
    var $optionC = $('#filter-select [value=' + value + ']');
    var filter_type = $optionC.attr('filter_type');
    var filter = createFilter(value, fParams[value], filter_type);
    selected($optionC);
    return filter;
  }

  function selected($optionC){
    $optionC.attr('disabled','disabled');
    $optionC.parent().children(':first').attr('selected', true);
    $('.filters-params').css('display', 'block');
  }

  
  $(document).on('change', '#filter-select', function(){
    var $selected = $(this).children(':selected');
    var name = $selected.val();
    var filter_type = $selected.attr('filter_type');
    createFilter(name, fParams[name], filter_type);
    $selected.attr('disabled','disabled');
    $(this).children(':first').attr('selected', true);
    $('.filters-params').css('display', 'block');
  });

  function createFilter(name, params, type) {
    switch(type) {
    case 'st_default': {
      formGroup = createOptions(name, stDefaultOptions);
      return filter(name, params, stDefaultOptions, formGroup, 'st_default');
      break;
    }
    case 'date': {
      formGroup = createOptions(name, dateOptions);
      var df = dateFilter(name, dateOptions, formGroup);
      initDateFilter();
      return df;
      break;
    }
    case 'number': {
      formGroup = createOptions(name, numberOptions);
      return filter(name, params, stDefaultOptions, formGroup, 'number');
      break; 
    }
    }
  }

  function createOptions(name, options) {
    var formGroup = document.createElement('div'),
        inputGroup = document.createElement('div'),
        removeSpanInner = document.createElement('span'),
        removeIcon = document.createElement('i'),
        selectComands = document.createElement('select'),
        nameLabel = document.createElement('label');
    
    formGroup.id = name;
    removeSpanInner.value = name;
    removeSpanInner.onclick = removeFilter;

    $(nameLabel).text(name.replace('_id', ''));
    $(inputGroup).attr('currentField', name);

    nameLabel.className = 'name-label';
    formGroup.className = 'form-group';
    inputGroup.className = 'input-group';
    removeSpanInner.className = 'btn btn-sm btn-default remove-filter';
    removeIcon.className = 'glyphicon glyphicon-remove';
    selectComands.className = 'filter-commands btn-default';

    var j = 0;
    for (j; j < options.length; j = j + 1) {
      var option = document.createElement('option');
      option.text = options[j][0];
      option.value = name + options[j][1];
      selectComands.appendChild(option);
    }
    if(name !== 'date') {
      selectComands.onchange = changeOption;
    } else {
      selectComands.onchange = changeDateOption;
    }
    $(selectComands).attr('belongsTo', 'filter_' + name);

    removeSpanInner.appendChild(removeIcon);
    inputGroup.appendChild(nameLabel);
    inputGroup.appendChild(removeSpanInner);
    inputGroup.appendChild(selectComands);
    formGroup.appendChild(inputGroup);
    $(formGroup).insertBefore('.filters-params hr');
    return formGroup;
  }

  function filter(name, params, options, formGroup, type) {
    var selectFilterValue = document.createElement('select'),
        multiple = document.createElement('i');
    var i = 0;

    multiple.className = 'glyphicon glyphicon-plus multiple';
    $(multiple).attr('belongsTo', 'filter_' + name);
    selectFilterValue.className = 'btn-default filter';
    for (i; i < params.length; i = i + 1) {
      var option = document.createElement('option');
      
      if(type === 'number'){
        option.text = params[i];
        option.value = params[i];
      } else {
        option.text = params[i][0];
        option.value = params[i][1];
      }
      selectFilterValue.appendChild(option);
    }

    selectFilterValue.name = 'q[' + name + options[0][1] + ']';
    selectFilterValue.id = 'filter_' + name;
    $(formGroup).children().append(selectFilterValue);
    $(formGroup).children().append(multiple);
    return selectFilterValue;
  }

  function dateFilter(name, options, formGroup) {
    var dateField = document.createElement('input');

    dateField.className = 'date-filter';
    dateField.name = 'q[' + name + options[0][1] + ']';
    dateField.id = 'filter_' + name;
    $(formGroup).children().append(dateField);
    return dateField;
  }

  function removeFilter(event){
    $('#' + this.value).remove();
    $('#filter-select option[value="'+ this.value +'"]').attr('disabled', false);
    if($('.filters-params').children().size() < 6) {
      $('.filters-params').css('display', 'none');
    }
  }

  function changeOption(event){
    var currentValue = $(this).children(':selected').val();
    var filterId = $(this).attr('belongsTo');
    oldValue = $('#' + filterId).attr('name');
    var $filterField = $('#' + filterId);
    var newValue = '';
    if(currentValue.indexOf('_null') > -1){
      $filterField.attr('name', 'q[' + currentValue + ']');
      $filterField.attr('hidden', true);
      $filterField.parent().children('.multiple').css('display', 'none');
      var option = document.createElement('option');
      option.value = true;
      $filterField.append($(option));
      $filterField.children('[value=true]').attr('selected', 'selected');
    } 
    if(currentValue.indexOf('_eq') > -1) {
      newValue = oldValue.replace('_not_eq', '_eq');
      if(newValue.indexOf('all') > -1) {
        newValue = newValue.replace('all', 'any');
      }
      $filterField.attr('name', newValue);
    } 
    if(currentValue.indexOf('_not_eq') > -1) {
      newValue = oldValue.replace('_eq', '_not_eq');
      if(newValue.indexOf('any') > -1) {
        newValue = newValue.replace('any', 'all');
      }
      $filterField.attr('name', newValue);
    }
    if(oldValue.indexOf('_null') > -1 && currentValue.indexOf('_null') === -1){
      $filterField.children(':first').attr('selected', 'selected');
      $filterField.attr('name', 'q[' + currentValue + ']');
      $filterField.children('[value=true]').remove();
      toSingle(filterId);
      $filterField.parent().children('.multiple').removeClass('glyphicon-minus').addClass('glyphicon-plus');
      $filterField.attr('hidden', false);
      $filterField.parent().children('.multiple').css('display', 'inline-block');
    }     
  }

  function changeDateOption(event){
    var currentValue = $(this).children(':selected').val();
    if(currentValue === 'date_between') {
      specificDateFilter();
    } else {
      var filterId = $(this).attr('belongsTo');
      if(filterId === 'filter_date') {
        $('#temp-date-filter').remove();
      }
      oldValue = $('#' + filterId).attr('name');
      if(oldValue.indexOf('_gteq') > -1) {
        newValue = oldValue.replace('_gteq', '_lteq');
      } else {
        newValue = oldValue.replace('_lteq', '_gteq');
      }             
      $('#' + filterId).attr('name', newValue);
    }
  }

  function initDateFilter(){
    $('.date-filter').datepicker({
      dateFormat: 'yy-mm-dd'
    });
  }

  function specificDateFilter(){
    var $dateFilter = $('.date-filter');
    var tempDateField = document.createElement('input');
    tempDateField.className = 'date-filter';
    tempDateField.id = 'temp-date-filter';
    tempDateField.name = 'q[date_lteq]';
    $dateFilter.attr('name', 'q[date_gteq]');
    $dateFilter.parent().append(tempDateField);
    initDateFilter();
  }

  $(document).on('click', '.multiple', function(){
    if ($(this).hasClass('glyphicon-plus')){
      $(this).removeClass('glyphicon-plus').addClass('glyphicon-minus');
      toMultiple($(this).attr('belongsTo'));
    } else {
      $(this).removeClass('glyphicon-minus').addClass('glyphicon-plus');
      toSingle($(this).attr('belongsTo'));
    }
  });

  function toMultiple(id, flag) {
    var $filter = $('#' + id);
    var field = $filter.parent().attr('currentField');
    
    $filter.attr('multiple', 'multiple');
    if(flag){
      $filter.children(':first').attr('selected', false);
    }
    var name = $('#' + id).attr('name');
    if(name === 'q[' + field + '_not_eq]') {
      $filter.attr('name', 'q[' + field + '_not_eq_all]' + '[]');
    } else {
      $filter.attr('name', 'q[' + field + '_eq_any]' + '[]');
    }
  }

  function toSingle(id) {
    var $filter = $('#' + id);
    var field = $filter.parent().attr('currentField');
    
    $filter.removeAttr('multiple');
    var name = $('#' + id).attr('name');
    if(name === 'q[' + field + '_not_eq_all][]') {
      $filter.attr('name', 'q[' + field + '_not_eq]');
    } else {
      $filter.attr('name', 'q[' + field + '_eq]');
    }
  }
})