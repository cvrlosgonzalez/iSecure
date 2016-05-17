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
//= require_tree .

function parseBool(val) { return val === true || val === "true" }
function confirmation(text){
    resp = window.confirm(text);
    return resp;
  }

  function toggle_power(option){
    $.ajax({
        url: "/monitorfire/2/?power="+option
          })
  };


$( document ).ready(function() {
  //section to save alerts
    $('.monitor_toggle').on("click", function(){
      console.log("click works");
      var monId = $(this).attr('id');
      var monVal = $(this).attr('value')
    $.ajax({
        url: "/monitor_"+monVal
    })
      .done(function() {
        $('#monitor_status').text("The monitor is set to: " + monVal.toUpperCase());
        $('#monitor_status').css("display", "block");
      })
    });

    $('.cams_power').on("click", function(){
      var camspower = $(this).attr('value');
      var option = parseBool(camspower) //turn string true/false into bool true/false
      console.info('option is ' + option);
      // confirm = confirm('You are about to turn the camera ' + option + '. Click ok to confirm and proceed.' );
      // confirm = window.confirm('You are about to turn the camera ' + option + '. Click ok to confirm and proceed.' );
      if(option){ user_option = "ON" } else { user_option = "OFF"};
      console.log('user_option is ' + user_option);
      user_confirm = confirmation('You are about to turn the camera ' + option + '. Click ok to confirm and proceed.')
      console.log('user_confirm is ' + user_confirm);
      if(user_option == "ON" && user_confirm === true){
        var ref = new Firebase('wss://developer-api.nest.com');
        toggle_power(option);
        $('#cam_status').text("Camera status changed to "+ user_option, "block");
        $('#cam_status').css("display", "block");
      } else if (user_option == "OFF" && user_confirm === true) {
        toggle_power(option);
        $('#cam_status').text("Camera status changed to "+user_option, "block");
        $('#cam_status').css("display", "block");
      } else {
        $('#cam_status').text("No changes have been made to the camera's power status. ", "block");
        $('#cam_status').append("\nCamera status is: " + user_option);
        $('#cam_status').css("display", "block");
      };
    })
});
