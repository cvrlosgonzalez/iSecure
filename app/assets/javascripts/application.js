// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
  $( document ).ready(function() {
      // $('#activate').delegate('.monitor_toggle', 'click', function() {
      $('.monitor_toggle').on("click", function(){
      // $('#activate').on('click', '.monitor_toggle', function(){
        console.log("click works");
        var monId = $(this).attr('id');
        var monVal = $(this).attr('value')
      $.ajax({
          url: "/monitor_"+monVal
          // type: 'GET'
      })
        .done(function() {
          $('#monitor_status').text("The monitor is set to: " + monVal.toUpperCase());
          $('#monitor_status').css("display", "block");
        })
      });
  });
