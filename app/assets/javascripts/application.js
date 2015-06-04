// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery-ui
//= require moment
//= require bootstrap-datetimepicker
//= require tinymce-jquery

var notifierTimer

function notifie(message, $notifier){
  clearTimeout(notifierTimer);
  initNotifierSuccess($notifier);
  $notifier.children('.notice-mess').html(message);
  destroyNotifier($notifier);
}

function error(mess, $notifier) {
  clearTimeout(notifierTimer);
  initNotifierError($notifier);
  if(mess){
    $notifier.children('.notice-mess').html(mess);
  } else{
    $notifier.children('.notice-mess').html('Something went wrong, please repeat the action later!');
  }
  destroyNotifier($notifier);
}

function initNotifierSuccess($notifier){
  $notifier.addClass('notifier-init notice-success').removeClass('notice-error');
  $notifier.fadeIn('fast');
}

function initNotifierError($notifier){
  $notifier.addClass('notifier-init notice-error').removeClass('notice-success');
  $notifier.fadeIn('fast');
}

function destroyNotifier($notifier){
  notifierTimer = setTimeout(function(){
    $notifier.fadeOut('slow');
  },2000);    
}

function isInArray(value, array) {
  return array.indexOf(value) > -1;
}

function capitalize(string) {
  return string.charAt(0).toUpperCase() + string.slice(1); 
}

/* ============== HIDE AND SHOW SUB MENU ========================== */

var didScroll;
var lastScrollTop = 0;
var delta = 5;
var navbarHeight = $('#navbar-submenu').outerHeight();

$(window).scroll(function(event){
    didScroll = true;
});

setInterval(function() {
    if (didScroll) {
        hasScrolled();
        didScroll = false;
    }
}, 250);

function hasScrolled() {
    var st = $(this).scrollTop();
    
    // Make sure they scroll more than delta
    if(Math.abs(lastScrollTop - st) <= delta)
        return;

    // If they scrolled down and are past the navbar, add class .nav-up.
    // This is necessary so you never see what is "behind" the navbar.
    if (st > lastScrollTop && st > navbarHeight){
        // Scroll Down
        $('#navbar-submenu').removeClass('nav-down').addClass('nav-up');
    } else {
        // Scroll Up
        if(st + $(window).height() < $(document).height()) {
            $('#navbar-submenu').removeClass('nav-up').addClass('nav-down');
        }
    }

    lastScrollTop = st;
}
