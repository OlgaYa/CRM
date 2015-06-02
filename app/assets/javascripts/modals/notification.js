$.fn.notification = function(title, $body, action){
  $(this).on(action,function(){
    $('#notification').modal();
  })
  
  $('.modal-body').append($body);
  $('.modal-title').append(title);
}