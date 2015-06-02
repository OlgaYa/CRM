// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$.fn.listVars = function(){
  var result = [];
  $(this).children('li').each(function(){
    result.push($(this).attr('id'));
  })
  return result;
}

function appendNotAssignFields($selector){
  for(var i = 0; i < settings.not_assign.length; i = i+1){
    $selector.append("<li id='"+settings.not_assign[i][1] + "'>" + settings.not_assign[i][0] +"</li>");
  }
}

function appendAssignFields($selector){
  for(var i = 0; i < settings.assign.length; i = i+1){
    $selector.append("<li id='" + settings.assign[i][1] + "'>"+ settings.assign[i][0] +'</li>');
  }
}
