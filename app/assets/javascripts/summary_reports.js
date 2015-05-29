$(document).ready(function(){
  $('.refresh-dt-data').notification('Desktime',
                                     'Data will be updated within a few minutes.',
                                     'click');
  $('.select-year-and-month').on('change',function(){
    this.submit();
  })
});
