// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery/dist/jquery.min
//= require materialize
//= require_tree .

$(document).ready(function() {
  $('#js-showPassword').on('click', function() {
    var passwordField = $('#password');
    var passwordFieldType = passwordField.attr('type');

    if (passwordFieldType === 'password') {
      passwordField.attr('type', 'text');
    } else {
      passwordField.attr('type', 'password');
    }
  });
  $('.collapsible').collapsible({accordion: false});
});


$('a[data-popup]').live('click', function(e) { 
  window.open( $(this).attr('href'), "Popup", "height=300, width=300" ); 
  e.preventDefault(); 
});
