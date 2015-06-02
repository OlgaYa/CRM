// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$.fn.listVars = function(){
  var result = [];
  $(this).children('li').each(function(){
    result.push($(this).attr('id'));
  })
  return result;
}

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
