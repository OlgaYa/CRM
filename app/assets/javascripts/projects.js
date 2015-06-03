// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$.fn.listVars = function(){
  var result = [];
  $(this).children('li').each(function(){
    result.push($(this).attr('id'));
  })
  return result;
}

function listFilter(header, list) {
      var input = $("input#filterinput");

      $(input).change( function () {
        var filter = $(this).val();
        if(filter) {
          $(list).find("p:not(:Contains(" + filter + "))").parent().slideUp();
          $(list).find("p:Contains(" + filter + ")").parent().slideDown();
        } else {
          $(list).find("li").slideDown();
        }
        return false;
      })
      .keyup( function () {
        $(this).change();
      });
    }


function appendNotAssignFields($selector){
  for(var i = 0; i < settings.not_assign.length; i = i+1){
    $selector.append("<li id='"+settings.not_assign[i][2] + "'> <p>" + settings.not_assign[i][0] + " " + settings.not_assign[i][1] +"</p> </li>");
  }
}

function appendAssignFields($selector){
  for(var i = 0; i < settings.assign.length; i = i+1){
    $selector.append("<li id='" + settings.assign[i][2] + "'> <p>"+ settings.assign[i][0] + " " + settings.assign[i][1] +'</p></li>');
  }
}
